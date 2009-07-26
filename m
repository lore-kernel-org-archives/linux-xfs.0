Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6Q0Nimi239129 for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 19:23:45 -0500
Received: from mta21.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 890D510C0D0C
	for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 17:32:59 -0700 (PDT)
Received: from mta21.charter.net (mta21.charter.net [216.33.127.81]) by
	cuda.sgi.com with ESMTP id HTEkxGKeK6wHSxqg for
	<xfs@oss.sgi.com>; Sat, 25 Jul 2009 17:32:59 -0700 (PDT)
Date: Sat, 25 Jul 2009 20:24:18 -0400
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
From: Sean Elble <elbles@sessys.com>
Message-ID: <C6911A72.B9D6%elbles@sessys.com>
In-Reply-To: <alpine.DEB.2.01.0907250241170.6426@bogon.housecafe.de>
Mime-version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2573880321283084297=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christian Kujau <lists@nerdbynature.de>, Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--===============2573880321283084297==
Content-type: multipart/signed;
	protocol="application/pkcs7-signature";
	micalg=sha1;
	boundary="B_3331398258_1856570"

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--B_3331398258_1856570
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit

On 7/25/09 5:46 AM, "Christian Kujau" <lists@nerdbynature.de> wrote:

> On Sat, 25 Jul 2009 at 09:26, Matthias Schniedermeyer wrote:
>>>   # losetup -r /dev/loop0 /path/to/IRIXbackup
>>>   # hexedit /dev/loop0 ...or whatever tool you'll be using.
>> 
>> Which has what advantage over directly changing the image?
> 
> Sean mentioned the "thrashing of the old disk" and I figured I'd be
> worried not only by that but that the old disk might die anytime soon. So
> I wanted to present an alternative to do the search - I don't know too
> much about his setup, so it's up to him to follow this advice or not.
> 

Well, I ended up dd'ing the old SCSI disk to a file on a spare Linux box I
have laying around for just this sort of purpose.  I then opened the
resulting file up with hexedit, switched to ASCII mode, did a search for the
root password hash, and replaced it with a known hash for "blah."

DD'ed the image back to the disk, threw it back in the Indigo2, and booted.
I entered maintenace mode, ran sash, and cat'ed the /etc/shadow file.  It
still had the old password.  So, back to the image file I went.  The
password string was in there multiple times, to the point where I lost
count.  I should have thought of that the first time around, but I figured
once was good enough.  Searched and replaced the string until the old string
wasn't in there anymore, reimaged the drive, put it back in the SGI, booted,
and voila:  I can log in again.

The loopback method was a moot point, as the box I was using didn't have the
loopback driver compiled in or available as a module, so I never even tried
it.  I'll definitely keep it in mind (and in my inbox) should another few
years go by and I can't remember the password again. :-)

Thanks so much for all the help guys, I really appreciate it.

-Sean

-- 
+-------------------------------------------------
|  Sean Elble      
|  Virginia Tech, Class of 2009
|  E-Mail:   elbles@sessys.com
|  Web:      http://www.sessys.com/~elbles/
|  Cell:     860.946.9477
+-------------------------------------------------

--B_3331398258_1856570
Content-type: application/pkcs7-signature; name="smime.p7s"
Content-transfer-encoding: base64
Content-disposition: attachment;
	filename="smime.p7s"

MIIIVwYJKoZIhvcNAQcCoIIISDCCCEQCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3DQEHAaCC
BiMwggLcMIICRaADAgECAhAvf5NHjc/BR/lyCoHqxXxjMA0GCSqGSIb3DQEBBQUAMGIxCzAJ
BgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYD
VQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQTAeFw0wOTAxMTYwMzA2
NTdaFw0xMDAxMTYwMzA2NTdaMEMxHzAdBgNVBAMTFlRoYXd0ZSBGcmVlbWFpbCBNZW1iZXIx
IDAeBgkqhkiG9w0BCQEWEWVsYmxlc0BzZXNzeXMuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAn0fFczG75sMuPqIaVQ3vbcN+pMJbg7mVf8UAGF7O6ObUoQofVZdePd4W
3iyG2xiGssTdRTan7s5uO/x1dLFROoFk1ZbazC32s8iHD/udyQfeaJsv02e08JlCt54ajwLg
lZSxAJSYKaCmAX5qUiumOEkRg86sf6c0Ry5AbfBcijfg0PEe4ptKV6sgF++VCo1ozBxSxN/b
tG9LR0G5wHJyAuCc+biiGv+7/Y6vihHdMXnSVaLm2mz6xE6oEVwl+tuLXPX6UUKeEUTtiDuq
yOTf7PFahGIPeWzkDkdSMf98LxxzVqsa6ak3pVgEQEZePhitLFTDPx5RlYEUfWPFWBL+qwID
AQABoy4wLDAcBgNVHREEFTATgRFlbGJsZXNAc2Vzc3lzLmNvbTAMBgNVHRMBAf8EAjAAMA0G
CSqGSIb3DQEBBQUAA4GBABuJXSYxgtvNq3jQwRuHmoU4pMf61yyKW8oSEKaPBbzF1PgwDBFa
rAKarubKQOIUJGcGvAbPbvCCXL+rn7QsRfu/LLxVJpsZignqnp+1Xd5nc/20gkoiY/AXlFf4
bnmk9lwKF9AVHlW2PWaUqLvd+L7DNy6NZQzgo3TScU3jt/EWMIIDPzCCAqigAwIBAgIBDTAN
BgkqhkiG9w0BAQUFADCB0TELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTES
MBAGA1UEBxMJQ2FwZSBUb3duMRowGAYDVQQKExFUaGF3dGUgQ29uc3VsdGluZzEoMCYGA1UE
CxMfQ2VydGlmaWNhdGlvbiBTZXJ2aWNlcyBEaXZpc2lvbjEkMCIGA1UEAxMbVGhhd3RlIFBl
cnNvbmFsIEZyZWVtYWlsIENBMSswKQYJKoZIhvcNAQkBFhxwZXJzb25hbC1mcmVlbWFpbEB0
aGF3dGUuY29tMB4XDTAzMDcxNzAwMDAwMFoXDTEzMDcxNjIzNTk1OVowYjELMAkGA1UEBhMC
WkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1Ro
YXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMIGfMA0GCSqGSIb3DQEBAQUAA4GN
ADCBiQKBgQDEpjxVc1X7TrnKmVoeaMB1BHCd3+n/ox7svc31W/Iadr1/DDph8r9RzgHU5VAK
MNcCY1osiRVwjt3J8CuFWqo/cVbLrzwLB+fxH5E2JCoTzyvV84J3PQO+K/67GD4Hv0CAAmTX
p6a7n2XRxSpUhQ9IBH+nttE8YQRAHmQZcmC3+wIDAQABo4GUMIGRMBIGA1UdEwEB/wQIMAYB
Af8CAQAwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybC50aGF3dGUuY29tL1RoYXd0ZVBl
cnNvbmFsRnJlZW1haWxDQS5jcmwwCwYDVR0PBAQDAgEGMCkGA1UdEQQiMCCkHjAcMRowGAYD
VQQDExFQcml2YXRlTGFiZWwyLTEzODANBgkqhkiG9w0BAQUFAAOBgQBIjNFQg+oLLswNo2as
Zw9/r6y+whehQ5aUnX9MIbj4Nh+qLZ82L8D0HFAgk3A8/a3hYWLD2ToZfoSxmRsAxRoLgnSe
JVCUYsfbJ3FXJY3dqZw5jowgT2Vfldr394fWxghOrvbqNOUQGls1TXfjViF4gtwhGTXeJLHT
HUb/XV9lTzGCAfwwggH4AgEBMHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFp
bCBJc3N1aW5nIENBAhAvf5NHjc/BR/lyCoHqxXxjMAkGBSsOAwIaBQCgXTAjBgkqhkiG9w0B
CQQxFgQUyAWeJ4f5lpFtrYEdODemMfQCMbswGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMDkwNzI2MDAyNDE4WjANBgkqhkiG9w0BAQEFAASCAQAvq2TeC81e
2UdtEStOSPmU3tY1/J1fR+XAPrAr25qGzo6DV3wmpN57xoE0NfGt03pFZktPLStjHLZmeEKF
zKxhwQIvxYPSsKzFPDRExL8c8cvwpcBt5cZQvckUD5f5X/IfRzZ5q4N5iapMRGrNre98ZRwJ
GwWsEeRY7Was+icgo48Z1nniqVXlM3c8yzomtNggswWBew3iswxVSk+dIT9Xr06uiKhvJO/g
mx32kBzrnD4hLOJaloeJ8+/C5O+ngWZzrks7HVB33lWxF11CfHXSwfxmuACy6/7kZzUuT8zA
sG5KGqqq81FWIlF72j1ZWSxSklzDyr+XijxgBCO+jW0Y

--B_3331398258_1856570--



--===============2573880321283084297==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2573880321283084297==--
