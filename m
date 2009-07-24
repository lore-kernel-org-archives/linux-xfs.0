Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6OJCftK143530 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 14:12:42 -0500
Received: from mta31.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2EDED384447
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 12:13:25 -0700 (PDT)
Received: from mta31.charter.net (mta31.charter.net [216.33.127.82]) by
	cuda.sgi.com with ESMTP id k9aKdSRc4LGOFFE0 for
	<xfs@oss.sgi.com>; Fri, 24 Jul 2009 12:13:25 -0700 (PDT)
Date: Fri, 24 Jul 2009 15:13:20 -0400
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
From: Sean Elble <elbles@sessys.com>
Message-ID: <C68F8010.B953%elbles@sessys.com>
In-Reply-To: <20090724171151.GA23077@citd.de>
Mime-version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8588258213720275147=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--===============8588258213720275147==
Content-type: multipart/signed;
	protocol="application/pkcs7-signature";
	micalg=sha1;
	boundary="B_3331293200_1044000"

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--B_3331293200_1044000
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit

On 7/24/09 1:11 PM, "Matthias Schniedermeyer" <ms@citd.de> wrote:

> On 24.07.2009 11:36, Sean Elble wrote:
>> On 7/24/09 3:30 AM, "Matthias Schniedermeyer" <ms@citd.de> wrote:
>> 
>>> 
>>> I'd guess the disc isn't very big.
>>> 
>>> You just dd it completly (for backup).
>>> 
>>> Then search for the content of the shadow-file and blank out the entry
>>> with a hex-editor. Make sure that you don't change the filesize, pad
>>> the previous/following entry with any character you have to remove.
>> 
>> Right, the disk is only 2 GB.  Presumably, to back the disk up, all I'd have
>> to do would be something like:
>> 
>>     dd if=/dev/sda of=IRIXbackup
>> 
>> Correct?  No need to specify bs or count, I presume...
> 
> Exactly.
> 
>> Then, I could use hexedit in the following manner to edit the disk:
>> 
>>     hexedit -d -f /dev/sda
> 
> Don't know hexedit. Last time i used a hex editor it was "khexedit",
> worked good enough.
> 
>> I suppose I could search for the encrypted password string itself, but as
>> Chris Wedgwood suggested, I might be better off finding the offset of the
>> /etc/shadow file by doing something like the following:
>>     
>>     xfs_ncheck /dev/sda | grep /etc/shadow
>> 
>> I'm not sure if I can use the inode number directly as an offset or not, but
>> I *think* I could use it in conjunction with a xfs_db convert command to get
>> something usable as an offset.  Something like the following, perhaps?
>> 
>>     xfs_db -c convert inode <inode from xfs_ncheck command> daddr /dev/sda
> 
> 2GB is small enough to just use "brute force".
> 
> - Make a backup-copy of the image
> - Open the image in a/the hexeditor
> - Search for something that appears in the shadow file
>   it should be pretty obvious if the hit is inside the shadow file.
> - Make the changes, (Remember filesize has to stay the same!)
> - dd the image back to the HDD.
> 
> Not very complicated and it still shouldn't take too long. :-)
> 

Yeah, that's probably what I'll do then.  I figure the disk will thrash for
a while during the search for a string in /etc/shadow, but hopefully it'll
work.  Thanks for all the advice!

-Sean

-- 
+-------------------------------------------------
|  Sean Elble      
|  Virginia Tech, Class of 2009
|  E-Mail:   elbles@sessys.com
|  Web:      http://www.sessys.com/~elbles/
|  Cell:     860.946.9477
+-------------------------------------------------

--B_3331293200_1044000
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
CQQxFgQUlrub+GFD4htUXeBhGq9UHOI5PM8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMDkwNzI0MTkxMzIwWjANBgkqhkiG9w0BAQEFAASCAQBQjI1+hxXQ
D7Gs5CINkHoxHUwPICDm364Di96xwCiBD80cVTHH7hEGyd5U14Z1pPOinv/kiUgQW7Can1Xn
3f6vUSoadeVa6Y6SL6azBviVROndWTB72rNcsszzTq8xM/wltkJQ8zmPMluUnOBrhOrY6rnm
tMU6Bjtd95MNMvP2xvxJVAFIF97YlrCaOo7wX4fVLSEOj1/Xwu1lO2DLM0QZtfo10LEtCd7J
tBNDoNXosE29Jagu/QLlVhdqDqW3MEgmeo/kY67tcf/e/50oXG8+/zQ5dCI6nrQ3y5+fmOmm
qeqikwE3d+d01LWXxdR6E+czcheRPUyZxtbxIU5lVBd6

--B_3331293200_1044000--



--===============8588258213720275147==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8588258213720275147==--
