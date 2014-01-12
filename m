Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76BC17F3F
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 13:54:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0722CAC004
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 11:54:10 -0800 (PST)
Received: from mail.uberzach.com (rondo.uberzach.com [64.22.125.169]) by
	cuda.sgi.com with ESMTP id ExQPusm9XGwC7qR3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Jan 2014 11:54:06 -0800 (PST)
Received: from archer.uberzach.com (unknown
	[IPv6:2602:3f:e50d:7605:60c:ceff:fed3:ff7e])
	(Authenticated sender: profplump)
	by mail.uberzach.com (Postfix) with ESMTPSA id BB7D058019
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 11:54:02 -0800 (PST)
From: Zachary Kotlarek <zach@kotlarek.com>
Message-Id: <CF41F386-E86A-4745-B28D-0DAA8D3CA1DD@kotlarek.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
Date: Sun, 12 Jan 2014 11:53:59 -0800
References: <A40DF90D-5F6B-4595-AA30-B91D8F7972D0@kotlarek.com>
	<52D2E358.6070106@hardwarefreak.com>
In-Reply-To: <52D2E358.6070106@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0198226910502862026=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0198226910502862026==
Content-Type: multipart/signed; boundary="Apple-Mail=_A290B4EA-88F9-4CC2-A8A6-45CE1D43F781"; protocol="application/pkcs7-signature"; micalg=sha1


--Apple-Mail=_A290B4EA-88F9-4CC2-A8A6-45CE1D43F781
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Jan 12, 2014, at 10:47 AM, Stan Hoeppner <stan@hardwarefreak.com> =
wrote:

> =
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when=
_reporting_a_problem.3F
>=20
> If this is due to a bug it may have already been fixed.  Note the =
first
> two things asked for.


Thanks for the pointer.

My kernels a bit old, but xfsprogs is shiny and new:
Linux vera 2.6.39.2 #1 SMP Fri Sep 30 23:55:41 PDT 2011 x86_64 x86_64 =
x86_64 GNU/Linux
xfs_repair version 3.1.11

2x4 core CPUs
8 GB RAM, mostly free (more than 6 GB cached)

Related mount:
/dev/lvmsas/tv /mnt/media/TV xfs =
rw,nosuid,nodev,noexec,relatime,attr2,delaylog,inode64,sunit=3D1024,swidth=
=3D4096,noquota 0 0

Underlying partition:
 254       31 16252928000 dm-31

Which is a no-frills LVM2 volume allocation over mdadm raid-6.

meta-data=3D/dev/lvmsas/tv         isize=3D256    agcount=3D33, =
agsize=3D126975872 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D4063232000, =
imaxpct=3D5
         =3D                       sunit=3D128    swidth=3D512 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D1
log      =3Dinternal               bsize=3D4096   blocks=3D521728, =
version=3D2
         =3D                       sectsz=3D512   sunit=3D8 blks, =
lazy-count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0

Attempts to access the now-busted files/directories with accents in =
their paths result in a kernel log like:
Jan 11 02:05:39 vera XFS (dm-31): I/O error occurred: meta-data dev =
dm-31 block 0x3c8ff73e0       ("xfs_trans_read_buf") error 11 buf count =
4096

Original failure never hit the persistent log so I don=92t have that; =
the system would not shutdown cleanly and I kill it after several errors =
like:
	Filesystem "dm-31": xfs_log_force: error 5 returned.
It claimed to be unmounted at that point (it didn=92t show up in =
/proc/mounts) but the related [xfsbufd/dm-31] process was still running =
and could not be killed.

	Zach


--Apple-Mail=_A290B4EA-88F9-4CC2-A8A6-45CE1D43F781
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGGTCCBhUw
ggP9oAMCAQICAQEwDQYJKoZIhvcNAQEFBQAwgYsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApXYXNo
aW5ndG9uMRAwDgYDVQQHDAdTZWF0dGxlMRwwGgYDVQQKDBNaYWNoYXJ5IFAuIEtvdGxhcmVrMRUw
EwYDVQQDDAx1YmVyemFjaC5jb20xIDAeBgkqhkiG9w0BCQEWEXphY2hAa290bGFyZWsuY29tMB4X
DTEzMDgxMzAwMjMzM1oXDTE4MDgxMjAwMjMzM1owgZIxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApX
YXNoaW5ndG9uMRAwDgYDVQQHDAdTZWF0dGxlMRwwGgYDVQQKDBNaYWNoYXJ5IFAuIEtvdGxhcmVr
MRwwGgYDVQQDDBNaYWNoYXJ5IFAuIEtvdGxhcmVrMSAwHgYJKoZIhvcNAQkBFhF6YWNoQGtvdGxh
cmVrLmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBANL424NB+EzPp7/CqB/kxV+u
7MSpl9A8NlMqLldoPPJjpEwH9+4wfYrx+yUOBddih4WIgCD9NiF41+9tHu9gUqm+PZT8kdGXUIRP
fuQuwKyzAv0rSyydXBQD/Q/gRrFaEJvJ5wVUxgE51K/ugGATmyWTSeMwATOJR4qTs1u2dfxBliyR
xc2LCJCAgvuonwhfP1JprFYz+ycmlb/od3cAC5+8ggof5YJiitsUM6FPQtDykGPNWxhFnBwrVlQ+
vAxA1aT2v33C4MMK3hY3Ik8BUCZrAr4r/eWDSCBmcQydoawrUllAzEsVuozYqOW+EwbFp9RFDAZZ
UZH/pMSEK5v2yQcf2m3zx4+9S5fLbvX660DFY90C1GSt9MyDjfpgx+Mtx7RtJI2abcei2PEXt38p
U2aLypsHWsdloWhouzM4JpTkDXqCyUOm5hkUPgMdOXKHY5jCj0e7ok/Rknty7fJjolo4uyOKfJHQ
cjoU1xuzA8ob0i8zufIL03FUK72dWL7xyAGjRs4Hsa6xd/SbPYGvYHJ2afxLeTDPZwzrLErxn9no
E0wkAPnV0MfYbB+0Y/+Xaa2KIUflawzh3iQVkohrzmE9PU3gjiQJ9UqYtvx8HrUK2eEjCRinnSd5
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
cF3fc1/6gQAAAAAAAA==

--Apple-Mail=_A290B4EA-88F9-4CC2-A8A6-45CE1D43F781--


--===============0198226910502862026==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0198226910502862026==--
