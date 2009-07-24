Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6O3VltA099061 for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 22:31:48 -0500
Received: from mta11.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C08010B6A91
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 20:40:52 -0700 (PDT)
Received: from mta11.charter.net (mta11.charter.net [216.33.127.80]) by
	cuda.sgi.com with ESMTP id F3QvXdbmFZuOKD6c for
	<xfs@oss.sgi.com>; Thu, 23 Jul 2009 20:40:52 -0700 (PDT)
Date: Thu, 23 Jul 2009 23:32:21 -0400
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
From: Sean Elble <elbles@sessys.com>
Message-ID: <C68EA385.B8CE%elbles@sessys.com>
In-Reply-To: <4A691B2D.1090600@sandeen.net>
Mime-version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0117578954530471012=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--===============0117578954530471012==
Content-type: multipart/signed;
	protocol="application/pkcs7-signature";
	micalg=sha1;
	boundary="B_3331236741_2749541"

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--B_3331236741_2749541
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit

On 7/23/09 10:23 PM, "Eric Sandeen" <sandeen@sandeen.net> wrote:

> Sean Elble wrote:
>> Hi all,
>> 
>> While I am aware that the current kernel implementation of XFS doesn't
>> support mounting an IRIX filesystem with version 1 directories, I'm not so
>> sure whether xfsdump/xfsrestore will support the dumping of an IRIX
>> filesystem with version 1 directories.  To be more specific, I am dealing
>> with an old disk from an Indigo2, running IRIX 6.5.6m with version 1
>> (0x1094) directories.  I was hoping it had version 2 directories, but after
>> finding an old SCSI card I could put in a Linux box with XFS support, I
>> found just the opposite, obviously.  I had the old SCSI card back in its
>> donor system (which was up-and-running) when it occurred to me that
>> xfsdump/xfsrestore *might* be a possibility, and I can't take it (the donor
>> system) down again unless I know I can make this work.
>> 
>> If anyone can give me an answer to this question, I would certainly
>> appreciate it.  I didn't see anything in the man pages, and my Google
>> searches have proven fruitless thus far, but I've been known to be blind on
>> occasion.  :-)  Thanks, in advance.
>> 
> 
> linux used to work with v1 dirs, though there were some problems.  It
> never got fixed, was not critical for 99.9% of users, and got taken out.
>  But it might work well enough to do what you need.  Go through the
> changelogs or google, and try an older Linux kernel, perhaps ....
> 
> -Eric
> 

Looks like the version 1 directory code was removed as of June 15th, 2006,
per this:

http://oss.sgi.com/archives/xfs/2006-06/msg00067.html

But another post <http://oss.sgi.com/archives/xfs/2003-07/msg00495.html> has
a 2.4.21 kernel being used with a patch, so I'm not sure if I want to try a
2.6 kernel, or see if I can patch together a 2.4.x kernel on an old FC4 box
I have laying around.  Truth be told, it's a lot of work just to blank the
entries in /etc/shadow so I can login to a 150 MHz box again, so who knows
if I'll even try at this point, hah.

In any event, thanks a lot for the pointers in the right direction.

-Sean

--B_3331236741_2749541
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
CQQxFgQU0hnMLPB1PpyVqPnymBRKrbEKvk8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMDkwNzI0MDMzMjIxWjANBgkqhkiG9w0BAQEFAASCAQBGCI5JO60L
fUqV2YxN4uJxXotp6d1CkrOQku85OEK48dEOmzZqBgiV4dSPImPV4sOe8UZECHExqFQsp8XI
jZBBoWFgZ4CPXOtWnxSZk2PARn/UpJh7fHS3QSzAyWNjbBLNsyk0ohkZSyi0hhMen/kxpy2R
7CevivL5qxsUNNlswnDqbiHxTFm7fAGnqPiLCFXvCamEkkvpIV5Yg29aJEaAGZzHrurqR74p
CgYfGSrXyrn3k5NO8IGbCzzAslmZZvGTytmzGfOExCi+gP1x0v6deeLPcvU+N3q0UPVWMkRq
QreqUFKuBV3BcFTCZqjPQKmOOOBh2vI4sjFVKb8JEPQV

--B_3331236741_2749541--



--===============0117578954530471012==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0117578954530471012==--
