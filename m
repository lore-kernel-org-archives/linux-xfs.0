Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 17:08:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8J08YZd013824
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 17:08:34 -0700
Received: from uwast.astro.wisc.edu (uwast.astro.wisc.edu [144.92.110.130])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 721153E0DF1
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 15:56:33 -0700 (PDT)
Received: from [192.168.1.101] (ppp-70-226-162-117.dsl.mdsnwi.ameritech.net [70.226.162.117])
	(authenticated bits=0)
	by uwast.astro.wisc.edu (8.13.4/8.13.4/SuSE Linux 0.7) with ESMTP id k8IMuBVL029290
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 17:56:13 -0500
Mime-Version: 1.0 (Apple Message framework v752.2)
In-Reply-To: <20060918222348.GY3034@melbourne.sgi.com>
References: <200609181519.18448.christian.gattermair@mci.edu> <20060918222348.GY3034@melbourne.sgi.com>
Content-Type: multipart/signed; micalg=sha1; boundary=Apple-Mail-12--75655696; protocol="application/pkcs7-signature"
Message-Id: <8B10E861-C427-4F9F-B0C4-7A87DB77236B@astro.wisc.edu>
From: Stephan Jansen <jansen@astro.wisc.edu>
Subject: Re: xfs_check - out of memory | xfs_repair - superblock error reading
Date: Mon, 18 Sep 2006 17:56:10 -0500
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--Apple-Mail-12--75655696
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed


Hi,


On Sep 18, 2006, at 5:23 PM, David Chinner wrote:

> On Mon, Sep 18, 2006 at 03:19:18PM +0200, christian gattermair wrote:
>> hi!
>>
>> after a reboot of our box (debian sarge, 3ware controller, raid 5  
>> - 3tb xfs)
>> we can not mount it any more.
>>
>> from syslog:
>>
>> Sep 18 12:51:36 localhost kernel: SGI XFS with ACLs, security  
>> attributes,
>> realtime, large block numbers, no debug enabled
>> Sep 18 12:51:36 localhost kernel: SGI XFS Quota Management subsystem
>> Sep 18 12:51:53 localhost kernel: attempt to access beyond end of  
>> device
>> Sep 18 12:51:53 localhost kernel: sdb1: rw=0, want=6445069056,
>> limit=2150101796
>> Sep 18 12:51:53 localhost kernel: I/O error in filesystem ("sdb1")  
>> meta-data
>> dev sdb1 block 0x18027f2ff       ("xfs_read_buf") error 5 buf  
>> count 512
>> Sep 18 12:51:53 localhost kernel: XFS: size check 2 failed
>
> I/O error - something is not right with your raid controller i think.
> Are there any other errors in dmesg? What does /proc/partitions tell
> you about the size of the device?
>
>> xfs_check fails with:
>>
>> xfs_check /dev/sdb1
>> XFS: totally zeroed log
>> xfs_check: out of memory
>
> 3TB filesystem - you won't be able to xfs_check that on a 32 bit  
> system,
> and you'll need >6GiB RAM to check it on a 64bit system.
>
>

I was just going to create a 3TB filesystem on a 32 bit system.  So
xfs_check will not work?  How about xfs_repair?  I assume that will
work but would like to know beforehand.

[stuff deleted]

> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>

--

----- Stephan


--Apple-Mail-12--75655696
Content-Transfer-Encoding: base64
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Disposition: attachment;
	filename=smime.p7s

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEH
AQAAoIIGLzCCAvQwggJdoAMCAQICAkRNMA0GCSqGSIb3DQEBBQUAMFMxCzAJ
BgNVBAYTAlVTMRwwGgYDVQQKExNFcXVpZmF4IFNlY3VyZSBJbmMuMSYwJAYD
VQQDEx1FcXVpZmF4IFNlY3VyZSBlQnVzaW5lc3MgQ0EtMTAeFw0wNTA4Mjkx
NjA3MjBaFw0xNTA4MjkxNjA3MjBaMIGJMQswCQYDVQQGEwJVUzErMCkGA1UE
ChMiRGl2aXNpb24gb2YgSW5mb3JtYXRpb24gVGVjaG5vbG9neTEjMCEGA1UE
CxMaRmFjdWx0eSAtIFN0YWZmIC0gU3R1ZGVudHMxKDAmBgNVBAMTH1VuaXZl
cnNpdHkgb2YgV2lzY29uc2luLU1hZGlzb24wgZ8wDQYJKoZIhvcNAQEBBQAD
gY0AMIGJAoGBAOhIUdwld8sfAAlrdOv5Tt8PTX1Wku/ItsIjHrkus1MbKoul
SXxSsSUPAPYzgT8HfhuRY+tHHzohFSu3xJWgx0wk8q2pqwo4KZ2evy7GMDFx
THyXSYa/1m0Wsg5c11u8J6/tR8yqu7RWIJPr+edlPjx8r/cYP7AK5nA7msMF
FZqDAgMBAAGjgZ8wgZwwDgYDVR0PAQH/BAQDAgGGMB0GA1UdDgQWBBQcnlJS
GwRiRyxrLAG4afGpNywjJDAfBgNVHSMEGDAWgBRKeDJSEdtZFjZe38EUNkBq
R3xMoTAPBgNVHRMBAf8EBTADAQH/MDkGA1UdHwQyMDAwLqAsoCqGKGh0dHA6
Ly9jcmwuZ2VvdHJ1c3QuY29tL2NybHMvZWJpemNhMS5jcmwwDQYJKoZIhvcN
AQEFBQADgYEAJfFEWDN3f+cS1o3XqrcgmDdr5h3e37WxerB/YxVfHpsr5UzT
GVBwR09zyRA+AtmBrNBE07HcLSsri/x9o1qJPwtko8GB+ScW9lTvoSoWKf93
fkeymKj4T7X2rFV+umJTSmgs850RTh+oRx0eVGHfc1zHRNjpUiPqZRoaYqjF
Z5AwggMzMIICnKADAgECAgIAqzANBgkqhkiG9w0BAQUFADCBiTELMAkGA1UE
BhMCVVMxKzApBgNVBAoTIkRpdmlzaW9uIG9mIEluZm9ybWF0aW9uIFRlY2hu
b2xvZ3kxIzAhBgNVBAsTGkZhY3VsdHkgLSBTdGFmZiAtIFN0dWRlbnRzMSgw
JgYDVQQDEx9Vbml2ZXJzaXR5IG9mIFdpc2NvbnNpbi1NYWRpc29uMB4XDTA1
MTEwODE5NDg0NloXDTA2MTEwODE5NDg0NlowgcExCzAJBgNVBAYTAlVTMRIw
EAYDVQQIEwlXaXNjb25zaW4xEDAOBgNVBAcTB01hZGlzb24xKDAmBgNVBAoT
H1VuaXZlcnNpdHkgb2YgV2lzY29uc2luLU1hZGlzb24xIzAhBgNVBAsTGkZh
Y3VsdHkgLSBTdGFmZiAtIFN0dWRlbnRzMRcwFQYDVQQDEw5TdGVwaGVuIEph
bnNlbjEkMCIGCSqGSIb3DQEJARYVamFuc2VuQGFzdHJvLndpc2MuZWR1MIGf
MA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDYmSqLM5WAgcBhd+EtQ3lxnq2H
u6TA+EN1lzR/ZKyEjg/cFhajrs+Py5qrADFp62Chsq1BcqI8l3j3oQMiQgni
AGxVrBkg/Al5nlUuzm3G/zpgoxbOXdBPv1xv7b52ylcKkaW4byOswQdZqSLt
H7aNPHdyDLFKEG9nw4TuGPm9sQIDAQABo3AwbjAOBgNVHQ8BAf8EBAMCBeAw
OwYDVR0fBDQwMjAwoC6gLIYqaHR0cDovL2NybC5nZW90cnVzdC5jb20vY3Js
cy93aXNjb25zaW4uY3JsMB8GA1UdIwQYMBaAFByeUlIbBGJHLGssAbhp8ak3
LCMkMA0GCSqGSIb3DQEBBQUAA4GBAHslg5nIvKIHNbz6jAwLHx4JK++gdHUA
GJxm8NCog0S58/nJXNJZpiCV3YY1feC3s+8eM0LusZXJJ5O8SgRBLmBP1TMp
pIbX0WSZz40xn+IqBbSDboK2s6694y0aS8f1O/1I0+r6AEXhnBtPxK8U9UYN
quW4bAAme3t0sHAoaFANMYIC4jCCAt4CAQEwgZAwgYkxCzAJBgNVBAYTAlVT
MSswKQYDVQQKEyJEaXZpc2lvbiBvZiBJbmZvcm1hdGlvbiBUZWNobm9sb2d5
MSMwIQYDVQQLExpGYWN1bHR5IC0gU3RhZmYgLSBTdHVkZW50czEoMCYGA1UE
AxMfVW5pdmVyc2l0eSBvZiBXaXNjb25zaW4tTWFkaXNvbgICAKswCQYFKw4D
AhoFAKCCAacwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMDYwOTE4MjI1NjExWjAjBgkqhkiG9w0BCQQxFgQUCYqSbBmLgs7s
MLu1O29Xh/V50fIwgaEGCSsGAQQBgjcQBDGBkzCBkDCBiTELMAkGA1UEBhMC
VVMxKzApBgNVBAoTIkRpdmlzaW9uIG9mIEluZm9ybWF0aW9uIFRlY2hub2xv
Z3kxIzAhBgNVBAsTGkZhY3VsdHkgLSBTdGFmZiAtIFN0dWRlbnRzMSgwJgYD
VQQDEx9Vbml2ZXJzaXR5IG9mIFdpc2NvbnNpbi1NYWRpc29uAgIAqzCBowYL
KoZIhvcNAQkQAgsxgZOggZAwgYkxCzAJBgNVBAYTAlVTMSswKQYDVQQKEyJE
aXZpc2lvbiBvZiBJbmZvcm1hdGlvbiBUZWNobm9sb2d5MSMwIQYDVQQLExpG
YWN1bHR5IC0gU3RhZmYgLSBTdHVkZW50czEoMCYGA1UEAxMfVW5pdmVyc2l0
eSBvZiBXaXNjb25zaW4tTWFkaXNvbgICAKswDQYJKoZIhvcNAQEBBQAEgYBw
n2GMFMv+jKSh8IBaFdtpB43fN3/M25j8rDlnooACgWf3dZZBg/lbRzlMp2Ah
dZgQ+AwySjGTLmE1p/1GCPeLIQYnVNn26527281dZwTpFAYKebypuxoz0+7Y
neGISMSkx1ZVrol0UOLw3lSgEbUFqoerXnknGbAXKyhGitAgLQAAAAAAAA==

--Apple-Mail-12--75655696--
