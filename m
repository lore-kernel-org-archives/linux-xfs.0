Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DEE937FCD
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 15:01:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4398DAC008
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 13:01:14 -0700 (PDT)
Received: from mailgateway3.uni-freiburg.de (mailgateway3.uni-freiburg.de
	[132.230.2.213]) by cuda.sgi.com with ESMTP id jEz1QwvBimxwN2av
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Sep 2014 13:01:11 -0700 (PDT)
Received: from ms2.uni-freiburg.de ([132.230.2.3] helo=uni-freiburg.de) port
	34924 by mailgateway3.uni-freiburg.de with esmtp
	(Exim 4.80.1 #2 built 18-Dec-2013 10:01:47 running on Gentoo)
	id 1XXFDx-0007Un-BC
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:01:09 +0200
Received: from proton.ruf.uni-freiburg.de (account
	anton.gamel@physik.uni-freiburg.de [132.230.8.150] verified)
	by physik.uni-freiburg.de (CommuniGate Pro SMTP 6.0.9)
	with ESMTPA id 241100125 for xfs@oss.sgi.com;
	Thu, 25 Sep 2014 22:01:08 +0200
Message-ID: <54247484.2030808@physik.uni-freiburg.de>
Date: Thu, 25 Sep 2014 22:01:08 +0200
From: "Gamel Anton J." <anton.gamel@physik.uni-freiburg.de>
MIME-Version: 1.0
Subject: irregular mkfs.xfs results on identical HW
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2756650765347030498=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a cryptographically signed message in MIME format.

--===============2756650765347030498==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060901090108060206010307"

This is a cryptographically signed message in MIME format.

--------------ms060901090108060206010307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Dear all,

servers with identical disk setup (HW RAID0 H310a):

Disk /dev/sda: 598.9 GB, 598879502336 bytes
/dev/sda1               1       49152   394813439+  82  Linux swap / Sola=
ris
/dev/sda2           49153       50176     8225280   83  Linux
/dev/sda3            6399       72809   533446357+  44  Unknown

mkfs.xfs creates on 28 of them:
meta-data=3D/dev/sda3              isize=3D256    agcount=3D16, agsize=3D=
8335099 blks
          =3D                       sectsz=3D512   attr=3D1, projid32bit=3D=
0
data     =3D                       bsize=3D4096   blocks=3D133361584, ima=
xpct=3D25
          =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D1
          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-c=
ount=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D=
0

but on four out of them:
meta-data=3D/dev/sda3              isize=3D256    agcount=3D4, agsize=3D3=
3340398 blks
          =3D                       sectsz=3D512   attr=3D2, projid32bit=3D=
0
data     =3D                       bsize=3D4096   blocks=3D133361589, ima=
xpct=3D25
          =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D65117, version=
=3D2
          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-c=
ount=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D=
0

I did not find a way to add mkfs.xfs options to get the identical
filesystem setup on all nodes, e.g.
# mkfs.xfs -d agcount=3D16 -b size=3D4096 /dev/sda3 -f
meta-data=3D/dev/sda3              isize=3D256    agcount=3D16, agsize=3D=
8335100 blks
          =3D                       sectsz=3D512   attr=3D2, projid32bit=3D=
0
data     =3D                       bsize=3D4096   blocks=3D133361589, ima=
xpct=3D25
          =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal log           bsize=3D4096   blocks=3D65117, version=
=3D2
          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-c=
ount=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D=
0

The only way it worked was to dump nodeA:/dev/sda3 to nodeB:/dev/sda3
Is there an explanation? May be I missed something ... hints?

Cheers and thanks in advance

Anton


--=20
Beste Gruesse

Anton J. Gamel

HPC und GRID-Computing
Physikalisches Institut
Abteilung Professor Schumacher

c/o Rechenzentrum der Universit=E4t Freiburg
Arbeitsgruppe Dr. Winterer
Hermann-Herder-Stra=DFe 10
79104 Freiburg

Tel.: ++49 (0)761 203 -4670

--
Es bleibt immer ein Rest - und ein Rest vom Rest.


--------------ms060901090108060206010307
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIEQjCC
BD4wggMmoAMCAQICAlwKMA0GCSqGSIb3DQEBDQUAMDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQK
EwpHZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0EwHhcNMTQwNjMwMTMzMzI2WhcNMTUw
NzMwMTMzMzI2WjBUMQswCQYDVQQGEwJERTETMBEGA1UEChMKR2VybWFuR3JpZDEUMBIGA1UE
CxMLVW5pRnJlaWJ1cmcxGjAYBgNVBAMTEUFudG9uIEpvc2VmIEdhbWVsMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvx9uDrse74v5oGPzZLMat9I50/WrLOIshXX7jwXxGH/1
RCdOKLOi3nEOg48i4/24IxwlxJNe1XPl8BIhBnKGWeTEt9rmu9rRoir4ogeGnBSm7mTinMOJ
TmlonXEiIPerAIjAGdKVZNvCbup557HJ92bMiq/8IoNCpgD+Yu8r6VqoArws2APwVr3U/JcW
njFQj0xX6ZMJwuF55HFC1mNQ3QifcobgWaHdFZK//eK9uT/13r5kB/BeX3X1Ha1xom26otPG
Rl30bVMPLdxi8VyHK65zPIPGNh7FsXG32FS3iKQDhesXgrxh1heiFgyBff3xS1qa0bYcvUCT
F3giJ8KPfQIDAQABo4IBNjCCATIwDAYDVR0TAQH/BAIwADAOBgNVHQ8BAf8EBAMCBLAwHQYD
VR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQWBBQDiUhVzQiNx2h2W9g8mGm4
05Y3wTAfBgNVHSMEGDAWgBTGdckorNEL/Dz/ubUe0187gGISNDAtBgNVHREEJjAkgSJhbnRv
bi5nYW1lbEBwaHlzaWsudW5pLWZyZWlidXJnLmRlMBwGA1UdEgQVMBOBEWdyaWRrYS1jYUBr
aXQuZWR1MDwGA1UdHwQ1MDMwMaAvoC2GK2h0dHA6Ly9ncmlka2EtY2Eua2l0LmVkdS9jcmwv
Z3JpZGthLWNybC5kZXIwKAYDVR0gBCEwHzAPBg0rBgEEAZQ2qywBAQEJMAwGCiqGSIb3TAUC
AgEwDQYJKoZIhvcNAQENBQADggEBANWSgkn5qzIUp5/XZfuQ42OHhuppguXtrbzblWe2gtkf
WOWm4GrX4oRRHaUvIRkjrgOlc7jPHnLRMwccQJf1EMRRNFRqd5RrQeZxetMzxoOG4GxpSxOJ
5wqHoNYThl4c/73Ph2F+dpSBoqsWucUZPbrjcrQTQ0s630uB9XHinDeicidT4WynSAgE13Zl
mr2jXDVGTzA7Ja3CTYCZaDZH5KV7fnOBnAxvZnyGAg24eL65fJhEyQxj5oPDjZsnw78UQevt
r+n1jdSEI0PzlFi/2/7TX1ZmGOejxvBOd0WwFtzl8omz92R0jRUiDXgg5SV1kEAo5lTgiSMY
n92mUIEYlwwxggLOMIICygIBATA8MDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpHZXJtYW5H
cmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAlwKMAkGBSsOAwIaBQCgggFnMBgGCSqGSIb3DQEJ
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDkyNTIwMDEwOFowIwYJKoZIhvcN
AQkEMRYEFJzFWiQ3vyrCLx8pPYc7n4IxnYdoMEsGCSsGAQQBgjcQBDE+MDwwNjELMAkGA1UE
BhMCREUxEzARBgNVBAoTCkdlcm1hbkdyaWQxEjAQBgNVBAMTCUdyaWRLYS1DQQICXAowTQYL
KoZIhvcNAQkQAgsxPqA8MDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpHZXJtYW5HcmlkMRIw
EAYDVQQDEwlHcmlkS2EtQ0ECAlwKMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAw
BwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEAOGxmTOA3SHPdOqIw
qp6IsLVhsqnrOClIQK0mTs9ZlHjwAp9i7rU4dN1dJPXsqIUP8DRtl/i48GGJYd22HcsQjGFf
EnOKeDQVFkn/9bEROyE+p7xeaq0OyXGrITj0OgsOmwQ2U9CzmTyMtg+cXoQiZGz9BOkzxA0N
VOLAGJ/toSYttSl9bB62YRsRUMBFXsS7T59vvxX621KzFxsxtilvH3q0iZpM6jiTtU9Sc/1L
GGQRwXT1U/TuejbKCxotdKT2FeRZKenQcgLjboECN7fsRh3I/BiFslmGeIC/FoZmC00Cc50Y
4kvrKFP5J7qwigExZWb761EDIjJQjRLAZsmY3AAAAAAAAA==
--------------ms060901090108060206010307--


--===============2756650765347030498==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2756650765347030498==--
