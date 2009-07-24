Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6O31TQ4097030 for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 22:01:29 -0500
Received: from mta11.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CA9D10B6BCF
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 20:10:32 -0700 (PDT)
Received: from mta11.charter.net (mta11.charter.net [216.33.127.80]) by
	cuda.sgi.com with ESMTP id xFf2jw4Yp4UMKhBh for
	<xfs@oss.sgi.com>; Thu, 23 Jul 2009 20:10:32 -0700 (PDT)
Date: Thu, 23 Jul 2009 23:02:05 -0400
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
From: Sean Elble <elbles@sessys.com>
Message-ID: <C68E9C6D.B8C8%elbles@sessys.com>
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
Content-Type: multipart/mixed; boundary="===============3218180145743308937=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--===============3218180145743308937==
Content-type: multipart/signed;
	protocol="application/pkcs7-signature";
	micalg=sha1;
	boundary="B_3331234925_2670211"

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--B_3331234925_2670211
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

Thanks for the reply, Eric, I appreciate it.  I'll take a look and see what
I can find, being sure to post back the latest version of the kernel with
version 1 support.  Think it was removed during the 2.5.x period, or could
it possibly have made it to the 2.6 era?

-Sean

--B_3331234925_2670211
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
CQQxFgQUx5r6JecfvZDqqkY2fTnERLZ+HuowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMDkwNzI0MDMwMjA1WjANBgkqhkiG9w0BAQEFAASCAQB4rRCDTjmS
Rnyfj5rglm5UtNI+DOrbjWi3AhXVc9adwMXJHfJ2hc4rLwc4P7VMkvXLdOwPx0ObZ97Yg+Xx
ppRdw8HpTqgZFRhyOO1GcAHS56NM2Eu3TkVr4PGHYFHcgIBqldCbUsOKDJbZJtJedz2c9G8h
tUKLeEVhdM31Tstj2X0PjD13Z2+9JRAoI2ydhfOIKq24kftYEYVKxza7K0EVE+jrnUJ0jcn5
vDgiYAEehFPYSBTEcYICy+kkSsCll/8au1hLPDN9Q+qk6I4s1tVKXPR7oKfiT39MnDwxISAE
4tbmWDjyFlZQXp1epbzoz0yb7yVsgegop6CzI+stTs/S

--B_3331234925_2670211--



--===============3218180145743308937==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3218180145743308937==--
