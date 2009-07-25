Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6PGOow0217579 for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 11:24:50 -0500
Received: from mta21.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 616FC385D6E
	for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 09:25:35 -0700 (PDT)
Received: from mta21.charter.net (mta21.charter.net [216.33.127.81]) by
	cuda.sgi.com with ESMTP id pCj9lW2D1TbbKYNS for
	<xfs@oss.sgi.com>; Sat, 25 Jul 2009 09:25:35 -0700 (PDT)
Date: Sat, 25 Jul 2009 12:25:30 -0400
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
From: Sean Elble <elbles@sessys.com>
Message-ID: <C690AA3A.B9D1%elbles@sessys.com>
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
Content-Type: multipart/mixed; boundary="===============4039859835399426749=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christian Kujau <lists@nerdbynature.de>, Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--===============4039859835399426749==
Content-type: multipart/signed;
	protocol="application/pkcs7-signature";
	micalg=sha1;
	boundary="B_3331369530_141012"

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--B_3331369530_141012
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
>

I think (and hope, considering its age) that the disk is OK.  My concern was
more with the speed that hexedit could traverse the drive searching for a
string, as opposed to dd'ing the drive to disk, editing the image, and then
dd'ing the image back to disk.

Using the loopback driver is definitely a thought, but I don't know if the
kernel on my spare box supports it or not.  I'll definitely take it into
consideration, depending on how it goes, so thanks for the info.

>> Even with just 10MB/s it's less than 4 Minutes for 2GB.
>> In comparison it takes over 3 hours to copy a modern 1TB HDD @ 80MB/s.
> 
> ?? (what kind of comparison is that?)
> 
> C.

-- 
+-------------------------------------------------
|  Sean Elble      
|  Virginia Tech, Class of 2009
|  E-Mail:   elbles@sessys.com
|  Web:      http://www.sessys.com/~elbles/
|  Cell:     860.946.9477
+-------------------------------------------------

--B_3331369530_141012
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
CQQxFgQUxMEWGRME39ChgeIkMY4SkQMyFa4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMDkwNzI1MTYyNTMwWjANBgkqhkiG9w0BAQEFAASCAQB5tg+BoRS7
YquOvWC6TYT0PgUrU2AdrJ8rNnflyxJoAD3kTc/2aPn7j/S9Pc07E4OmHcWv+xAiMQYctu1U
eTRD5ruJnSsON+dSB2XcFOWyxadvlB7Q8U0RiTyi+klBTDMbqlme+z8EeBperz35f+BhtZ9J
9a7z06VASqqzeg1WuMNylSjpdl2W84/mkjyR2H5mi0349pq0yHpdeHCBtGcQZ8kXtx5xyfVD
vClUptMtj3fnPplLL0Mxv3WXV76EkqWUor0xHpscMiBzyT8JT1pJz2ICHhsrO1r7zafTMI9y
c8S20FT9cnPRzwccf5ZD5PinhpQ8AIsHsmPVawf2Z/y+

--B_3331369530_141012--



--===============4039859835399426749==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4039859835399426749==--
