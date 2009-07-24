Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6OFZqFR135735 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 10:35:56 -0500
Received: from mta21.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2A70383301
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 08:36:36 -0700 (PDT)
Received: from mta21.charter.net (mta21.charter.net [216.33.127.81]) by
	cuda.sgi.com with ESMTP id MefHjXeChulK5MAW for
	<xfs@oss.sgi.com>; Fri, 24 Jul 2009 08:36:36 -0700 (PDT)
Date: Fri, 24 Jul 2009 11:36:31 -0400
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
From: Sean Elble <elbles@sessys.com>
Message-ID: <C68F4D3F.B931%elbles@sessys.com>
In-Reply-To: <20090724073030.GA15785@citd.de>
Mime-version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3495364165796250062=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--===============3495364165796250062==
Content-type: multipart/signed;
	protocol="application/pkcs7-signature";
	micalg=sha1;
	boundary="B_3331280192_225399"

> This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--B_3331280192_225399
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit

On 7/24/09 3:30 AM, "Matthias Schniedermeyer" <ms@citd.de> wrote:

>> 
>> Looks like the version 1 directory code was removed as of June 15th, 2006,
>> per this:
>> 
>> http://oss.sgi.com/archives/xfs/2006-06/msg00067.html
>> 
>> But another post <http://oss.sgi.com/archives/xfs/2003-07/msg00495.html> has
>> a 2.4.21 kernel being used with a patch, so I'm not sure if I want to try a
>> 2.6 kernel, or see if I can patch together a 2.4.x kernel on an old FC4 box
>> I have laying around.  Truth be told, it's a lot of work just to blank the
>> entries in /etc/shadow so I can login to a 150 MHz box again, so who knows
>> if I'll even try at this point, hah.
>> 
>> In any event, thanks a lot for the pointers in the right direction.
> 
> I'd guess the disc isn't very big.
> 
> You just dd it completly (for backup).
> 
> Then search for the content of the shadow-file and blank out the entry
> with a hex-editor. Make sure that you don't change the filesize, pad
> the previous/following entry with any character you have to remove.

Right, the disk is only 2 GB.  Presumably, to back the disk up, all I'd have
to do would be something like:

    dd if=/dev/sda of=IRIXbackup

Correct?  No need to specify bs or count, I presume...

Then, I could use hexedit in the following manner to edit the disk:

    hexedit -d -f /dev/sda

I suppose I could search for the encrypted password string itself, but as
Chris Wedgwood suggested, I might be better off finding the offset of the
/etc/shadow file by doing something like the following:
    
    xfs_ncheck /dev/sda | grep /etc/shadow

I'm not sure if I can use the inode number directly as an offset or not, but
I *think* I could use it in conjunction with a xfs_db convert command to get
something usable as an offset.  Something like the following, perhaps?

    xfs_db -c convert inode <inode from xfs_ncheck command> daddr /dev/sda

My apologies for all the questions, but I've never tried this before, and I
don't particularly feel like messing it up, even with a backup of the FS
available.  Many thanks to Andi Kleen and Chris Wedgwood, in addition to
Eric Sandeen and Matthias Schniedermeyer.

-Sean

--B_3331280192_225399
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
CQQxFgQUxLtejo/Xz1qzRuJW8vhdsbmbnKowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
BgkqhkiG9w0BCQUxDxcNMDkwNzI0MTUzNjMyWjANBgkqhkiG9w0BAQEFAASCAQBKjI5/M78Q
qy4yDFU331y2/gSVoVpqAcMO5UP96d6S/OfA7erhhkbWR0zld87JAmFzTyguUQJmBw8RKHqk
OB1gQL07L/FnGuBBM+CrzXcrYMLhzUAYgKCnHAjyvm6ObsarCTN7N6Sbuk1UsXhX91AGLMv/
sej1yEv8ynhOXxxBHaunBRXglcwXiste620/Jq9a2bST0/dcRM65fK4cXyhIQFFkIf7O7Oam
5FnrZfz+lku69mAepNJrwerzLzKbBUDq4ruA9T5eUbg6/3/Tt8/lpILr8A6ilPTqE8OcnAMv
3IgiSOpZ/mJx35xfSqBLnBWxLM0c4iNQL2BSrBkYaj9Y

--B_3331280192_225399--



--===============3495364165796250062==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3495364165796250062==--
