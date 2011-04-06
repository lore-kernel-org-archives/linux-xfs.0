Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p36ES0Tp038945 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 09:28:01 -0500
Received: from serv132.fzu.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 860613AB891
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 07:31:15 -0700 (PDT)
Received: from serv132.fzu.cz (serv132.fzu.cz [147.231.26.132]) by
	cuda.sgi.com with ESMTP id XF3w0BG8rywF5OfB for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2011 07:31:15 -0700 (PDT)
Message-ID: <4D9C7931.6020909@fzu.cz>
Date: Wed, 06 Apr 2011 16:31:13 +0200
From: =?UTF-8?B?SmFuIEt1bmRyw6F0?= <kundratj@fzu.cz>
MIME-Version: 1.0
Subject: Re: SL's kickstart corrupting XFS by "repairing" GPT labels?
References: <4D9C3E14.6030009@fzu.cz> <20110406114146.GF31057@dastard>
In-Reply-To: <20110406114146.GF31057@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7545409963242106220=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: lcg-admin@fzu.cz, xfs@oss.sgi.com

This is a cryptographically signed message in MIME format.

--===============7545409963242106220==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000206070301030405020104"

This is a cryptographically signed message in MIME format.

--------------ms000206070301030405020104
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/06/11 13:41, Dave Chinner wrote:
>> Mar 30 14:04:44 dpmpool5 kernel: Please umount the filesystem, and
>> rectify the problem(s)
>=20
> Did you do this?

Not immediately, I wasn't the person immediately handling the issue. My
colleague did unmount that filesystem and ran xfs_repair on it, and was
successful in recovering most of the data.

>> zerombr yes
>> clearpart --all --initlabel
>> part swap --size=3D1024 --asprimary
>> part / --fstype ext3 --size=3D0 --grow --asprimary
>=20
> There your problem - hello random crap....

Oh crap. "--all" is all, indeed. Well, thanks for clarification, we were
stupid after all :).

> Given the nature of the problem, I have to assume you aren't using
> FC zoning to prevent hosts from seeing disks that don't belong to
> them?

Nope, zoning unfortunately wasn't active.

>> Would a "restore" of GPT partition table at the
>> beginning of a disk from the copy at the end qualify as a possible
>> candidate?
>=20
> No. The log messages have already told you what your next step is.

I meant that as "a candidate for the thing to blame for corruption", not
as a next step to undertake.

Cheers,
Jan


--------------ms000206070301030405020104
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
HSAEIDAeMAwGCiqGSIb3TAUCAgEwDgYMKwYBBAG+eQECAwADMDgGA1UdHwQxMC8wLaAroCmG
J2h0dHA6Ly9jcmwuY2VzbmV0LWNhLmN6L0NFU05FVF9DQV8zLmNybDAOBgNVHQ8BAf8EBAMC
BaAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEME4GA1UdEQRHMEWBD2t1bmRyYXRq
QGZ6dS5jeoESamFuLmt1bmRyYXRAZnp1LmN6gQ5qa3RAZmxhc2thLm5ldIEOamt0QGdlbnRv
by5vcmcwDQYJKoZIhvcNAQEFBQADggEBACegz6Nyqyfw55uRsb5d4pdGG/PExKBzlFdMOs6f
uJwVVQgIOQJfbCffU8uG5Dk5PlhjBh5uMj8t8rmuFBMKNEuqovQIFOTIMOsRSsCuQz3GHd6U
pEH5IzmWwyFnCOUv3WcGQolpH3ByJidGHQf6wEwSagnVrmNC1Au0Q5MVKqcVoCPiuN5jMG5l
jB+jf93IrBTWyHco/eCkyYqiBgl2FR9Sdg+nnnT5lXFLLezyVeH9mDgApYIYf8fx1O1q7iAD
idvk/W1t1IVvpRfldQkmr72V0HPnSeqm6IDAe3JbbnL/lA1ar2s/2KeRLL4qBwxmMBWh8KAC
s97fFWe6CCVU/vgwggSbMIIDg6ADAgECAghfq1s9Se9NUDANBgkqhkiG9w0BAQUFADBZMRIw
EAYKCZImiZPyLGQBGRYCY3oxGTAXBgoJkiaJk/IsZAEZFgljZXNuZXQtY2ExEjAQBgNVBAoM
CUNFU05FVCBDQTEUMBIGA1UEAwwLQ0VTTkVUIENBIDMwHhcNMTEwMTE3MTMwMDIxWhcNMTIw
MjE2MTMwMDIxWjCBiTESMBAGCgmSJomT8ixkARkWAmN6MRkwFwYKCZImiZPyLGQBGRYJY2Vz
bmV0LWNhMUIwQAYDVQQKDDlJbnN0aXR1dGUgb2YgUGh5c2ljcyBvZiB0aGUgQWNhZGVteSBv
ZiBTY2llbmNlcyBvZiB0aGUgQ1IxFDASBgNVBAMMC0phbiBLdW5kcmF0MIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4lX7WVimGgL7ZEr/111vi4MBUNev3Qm+QL2MA3W+p7Kr
lNsFqoACNckXbZ2poskynyDFIoZ8MMoF7gsZEzWPJVguvYpKy46zvLv8BTnXM6dN7f1/P8RO
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
--------------ms000206070301030405020104--


--===============7545409963242106220==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7545409963242106220==--
