Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 02:42:37 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1LAgS88000920
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 02:42:30 -0800
Received: from sipsolutions.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD3315FF342
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 02:42:52 -0800 (PST)
Received: from sipsolutions.net (crystal.sipsolutions.net [195.210.38.204]) by cuda.sgi.com with ESMTP id 85EAHrBi2E7yGmdC for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 02:42:52 -0800 (PST)
Received: from [131.234.74.147]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1JS8t7-0008Dg-D1
	for xfs@oss.sgi.com; Thu, 21 Feb 2008 10:42:49 +0000
Subject: possible FS corruption with 2.6.25-rc2
From: Johannes Berg <johannes@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LilG77YVsX/F+4XqIDqD"
Date: Thu, 21 Feb 2008 11:42:44 +0100
Message-Id: <1203590564.17534.163.camel@johannes.berg>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs <xfs@oss.sgi.com>

--=-LilG77YVsX/F+4XqIDqD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[Please CC me, I'm not subscribed to the XFS list]

Hi,

After having upgraded to 2.6.25-rc2 (more precisely
9a4c8546f3e7c893888bccc2b3416d6214f2664a plus wireless-testing) I wanted
to recompile the kernel and ran into weird issues like getting gcc
output to stdout instead of a ccache cache file.

My kernel tree was located on an XFS filesystem and the ccache cache dir
was on another XFS filesystem, both of which were corrupted afterwards,
the kernel tree had some temporary files (.*.d) that were listed in
readdir() but didn't otherwise exist (you could create a file with the
same name but not unlink or even stat the first one).

Also, the ccache cache dir filesystem was corrupted in a way that first
lead to a kernel hang during journal replay, and xfs_repair also hangs
when checking the filesystem even after clearing the journal. I've
uploaded a meta dump of that filesystem to
http://johannes.sipsolutions.net/files/home.part.meta.bz2

First I suspected memory corruption or similar issues but after copying
all (relevant) data (reading the ccache cache dir would hang/oops the
kernel) I can now do the same workload on the same kernel with two ext3
filesystems which leads me to believe that XFS caused the corruption in
some way.

Unfortunately, because the filesystem with the kernel tree on it was so
large, I don't have a copy of that filesystem, nor have I remembered to
make a copy of either filesystem before zeroing the journal.

johannes

--=-LilG77YVsX/F+4XqIDqD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR71VoqVg1VMiehFYAQJXsg//VShpEpFVdvUR78rK3XgKgEwacSAA5/7b
vuH27Ikm3ons+RWObbyFkx+8ojNZkEkImk886yWc7/G67Mo6AxsONuhdTjCR0q3U
fMWKmiwbIPcEfqE6q1Uy58XpeCF3UKeNhZC2JK3I0DUp/jAfoeNFKTGZxP1/utjt
ck2ivQhS4k8upFc61QD8CbHNonHz5m/yzLN2Xt2B7UGy9GjkVSu9od5wujChOt0W
BYZ2He9Ow7lIARllRgu3VCHnqBCABT37fz6TCbrXeC8SZTDlkFOk0Di2VJKjZoUQ
XdylLcpO2DaDHUUdqFgaqgHTNp3DDEGrJ4KURnyD4LSe+mEw8tqSHDCT/dhmPytF
m4NBt82H6ZFxkBtMdZDCUDnI1DYAeJqlzxFPLTQZOZclX70lRrLYgFKjfarV0ijc
9WV8qWC1fPk/0JH6O6eD8r+SMZJgS25J6xZqtxjqFu2y3djhfVK3JtNEw5egAXU3
8Ydrd6eycx+dLEp27QL2yjEmRyIrlJBIGNPXy7xrXuaWGeGk4Zw6ZHLzTGT8lRzc
IPRLkRk/H/xks0aBw8dIvnQMsMr5NtEvT87Q7V7hCqBnbFzka5eLn6fimeaRY8vp
MWTQRDNZybYcalXgEHwF647fbzWXeBQJe4Mvp6n5zaZBPoJaccl7yVlXaDg7jICv
zZbptOls0sQ=
=YqRG
-----END PGP SIGNATURE-----

--=-LilG77YVsX/F+4XqIDqD--
