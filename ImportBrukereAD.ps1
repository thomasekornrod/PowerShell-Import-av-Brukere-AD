############################################################################
############################################################################
####																	                                  ####
#### 	Laget av: Thomas - Bergeland VGS							                   	####
#### 	Dato: 02.03.2018												                          ####
#### 																	                                  ####
####	Powershell script importerer brukere fra .csv fil til AD	      	####
####	Husk å endre data Path, OU og Gruppe før import kjøres.		      	#### 
####	For å feilsøke kan script kjøres i PowerShell ISE			          	####
####																                                  	####
####	Du må også tillate at PowerShell Script kan kjøres. 		        	####
####	Dette gjøres ved å gjøre følgende kommando i PowerShell		      	####
####		Set-ExecutionPolicy unrestricted							                  ####
####	Velg Yes for å aktivere denne									                    ####
####																	                                  ####
############################################################################
############################################################################

Import-Module ActiveDirectory 

$Users = Import-Csv -Delimiter ";" -Path "C:\Tiladbrukere.csv" #CSV filnavn må være ADBrukere.csv og være plassert i C:\  

foreach ($User in $Users)  

{  

$OU = "OU=Ansatte,OU=Brukere,DC=testitest,DC=local"  #Data må byttes her til din OU samt ditt domene PS!! HUSK Å OPPRETTE DIN OU STI FØRST
$Password = $User.passord
$Group = "Ansatte" #Kommenter ut om du ikke vil melde brukere i en gruppe eller endre på gruppe navn til gruppe navn du ønsker brukere i
$EmailAddress = $User.Epost
$StreetAddress = $User.GateAddresse
$City = $User.By
$PostalCode = $User.Postnr 
$Detailedname = $User.fornavn + " " + $User.Etternavn 
$UserFirstname = $User.Fornavn
$FirstLetterFirstname = $UserFirstname.substring(0,1) #Trekker ut først bokstav i Fornavn
$SAM =  $FirstLetterFirstname + $User.Etternavn #Lager til brukernavn med første bokstav i fornavn og legger til etternavn 

New-ADUser -Name $Detailedname -SamAccountName $SAM -UserPrincipalName $SAM -DisplayName $Detailedname -GivenName $user.fornavn -Surname $user.Etternavn -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -StreetAddress $user.GateAdresse -City $user.By -PostalCode $user.Postnr -EmailAddress $user.Epost  -Enabled $true -Path $OU #må være på samme linje som New-ADUser 
Add-ADGroupMember -Identity $Group -Member $SAM #kommenter ut om du ikke skal melde inn brukere i en gruppe -Member må byttes til Members på Windows Server 2012 eller nyere
}
