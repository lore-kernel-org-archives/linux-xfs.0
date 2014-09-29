Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B5F7A7FFA
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 11:47:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A458C8F8035
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 09:47:46 -0700 (PDT)
Received: from mailgateway3.uni-freiburg.de (mailgateway3.uni-freiburg.de
	[132.230.2.213]) by cuda.sgi.com with ESMTP id 4dnNvnsqy4AqW6N2
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Sep 2014 09:47:44 -0700 (PDT)
Message-ID: <54298D29.5000702@physik.uni-freiburg.de>
Date: Mon, 29 Sep 2014 18:47:37 +0200
From: "Gamel Anton J." <anton.gamel@physik.uni-freiburg.de>
MIME-Version: 1.0
Subject: Re: irregular mkfs.xfs results on identical HW
References: <54247484.2030808@physik.uni-freiburg.de>
	<20140925211901.GH4945@dastard>
In-Reply-To: <20140925211901.GH4945@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8237355026958158564=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: sandeen@sandeen.net, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is a cryptographically signed message in MIME format.

--===============8237355026958158564==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030808090600060105090303"

This is a cryptographically signed message in MIME format.

--------------ms030808090600060105090303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Re Dave, Eric and all,

thanks a lot for the quick answers. This is definitely a version
issue I did not take into account at first. We ran into it when
slurm found small differences in scratch space. All (diskless)
SL6.5 computenodes have xfsprogs-3.1.1-10.el6.x86_64 installed,
but creation of xfs was done with older versions on SL5.
Recreation of xfs after disk problems changed the xfs outcome
as seen.

 From the beginning the plan was to recreate xfs at every boot
time. For some reason this did not work for (all) the diskless
machines and we dropped that in favour of a find+rm.
Now I reconsider a format at boot time again.

Cheers

Anton

On 09/25/2014 11:19 PM, Dave Chinner wrote:
> On Thu, Sep 25, 2014 at 10:01:08PM +0200, Gamel Anton J. wrote:
>> Dear all,
>>
>> servers with identical disk setup (HW RAID0 H310a):
>>
>> Disk /dev/sda: 598.9 GB, 598879502336 bytes
>> /dev/sda1               1       49152   394813439+  82  Linux swap / S=
olaris
>> /dev/sda2           49153       50176     8225280   83  Linux
>> /dev/sda3            6399       72809   533446357+  44  Unknown
>>
>> mkfs.xfs creates on 28 of them:
>> meta-data=3D/dev/sda3              isize=3D256    agcount=3D16, agsize=
=3D8335099 blks
>>           =3D                       sectsz=3D512   attr=3D1, projid32b=
it=3D0
>> data     =3D                       bsize=3D4096   blocks=3D133361584, =
imaxpct=3D25
>>           =3D                       sunit=3D0      swidth=3D0 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
>> log      =3Dinternal               bsize=3D4096   blocks=3D32768, vers=
ion=3D1
>>           =3D                       sectsz=3D512   sunit=3D0 blks, laz=
y-count=3D1
>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextent=
s=3D0
>
> THat's clearly an old version of mkfs - it's selected version 1 logs
> and attr1 by default and a log size of only 128MB. mkfs.xfs has
> defaulted to v2 logs since 3.0.0 (2007).
>
>> but on four out of them:
>> meta-data=3D/dev/sda3              isize=3D256    agcount=3D4, agsize=3D=
33340398 blks
>>           =3D                       sectsz=3D512   attr=3D2, projid32b=
it=3D0
>> data     =3D                       bsize=3D4096   blocks=3D133361589, =
imaxpct=3D25
>>           =3D                       sunit=3D0      swidth=3D0 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
>> log      =3Dinternal               bsize=3D4096   blocks=3D65117, vers=
ion=3D2
>>           =3D                       sectsz=3D512   sunit=3D0 blks, laz=
y-count=3D1
>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextent=
s=3D0
>
> Clearly much newer - attr2, log v2, log larger than 128MB...
>
> mkfs.xfs -V on each of the nodes will tell you that they are running
> different versions of mkfs, I think.
>
>> The only way it worked was to dump nodeA:/dev/sda3 to nodeB:/dev/sda3
>> Is there an explanation? May be I missed something ... hints?
>
> If you are building a new storage system, then I'd highly recommend
> all the nodes run the same software and that software is the newest
> possible release you can get....
>
> Cheers,
>
> Dave.
>


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


--------------ms030808090600060105090303
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
AzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDkyOTE2NDczN1owIwYJKoZIhvcN
AQkEMRYEFFQnp/Gn1Jsw9C388JbrK/cYtUATMEsGCSsGAQQBgjcQBDE+MDwwNjELMAkGA1UE
BhMCREUxEzARBgNVBAoTCkdlcm1hbkdyaWQxEjAQBgNVBAMTCUdyaWRLYS1DQQICXAowTQYL
KoZIhvcNAQkQAgsxPqA8MDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpHZXJtYW5HcmlkMRIw
EAYDVQQDEwlHcmlkS2EtQ0ECAlwKMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAw
BwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEAkPdKzmVyUHGLVEbB
DAopF+2mcL1Fj+tLRkibbsZnqMmqxlx9tO4HKQyCy+/y3dP9YrN3EWvTJLeXPGz+UjR8BL5+
KjPKv0zFMFKoumR2m1ndUbkUMJ44QmItw91TkauiSyldMb+D2ZiaJsiBf1SE0qmDKyt5CBqS
rmwun/EhGKSMbHLSEY48dLXcpChFZ6jNf8M+uvENDvjp7VW6Wu2Fvn76zZGH7fJUEEsYvJVL
9KpazpQ+WvTcN7sUlFv26FEnOW0HWNOnXfNBLW7dwFbMmTSudM8RuNoZyExgzwcVsWH1+iWT
RLYigApbqNDKTxxNf1uNd9Yjl3ksiabeCZ+f9gAAAAAAAA==
--------------ms030808090600060105090303--


--===============8237355026958158564==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8237355026958158564==--
