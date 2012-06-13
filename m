Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5DCDRWe134819 for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 07:13:27 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id vXgcVfxcuiOZgjak (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Jun 2012 05:13:25 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106014.dyn.cm.kabsi.at [81.217.106.14])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id E417F1828D98
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 14:13:23 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	by mailsrv.i.zmi.at (Postfix) with ESMTP id 49371CD7C8C
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 14:14:47 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
Date: Wed, 13 Jun 2012 14:13:23 +0200
Message-ID: <6637532.ZKYiNbq2uo@saturn>
In-Reply-To: <20120613115934.GX32601@systemlinux.org>
References: <4FD66513.2000108@xsnews.nl> <4FD8552C.4090208@xsnews.nl>
	<20120613115934.GX32601@systemlinux.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6877154422066869220=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6877154422066869220==
Content-Type: multipart/signed; boundary="nextPart3606948.QQg65BAJD3"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart3606948.QQg65BAJD3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Mittwoch, 13. Juni 2012, 13:59:34 schrieb Andre Noll:
> Here's what gives best performance. Of course these are also the most=

> risky settings, so use with care:
>=20
>         Current Cache Policy: WriteBack, ReadAdaptive, Cached, Write
> Cache OK if Bad BBU, Disk Cache Policy: Enabled

I wanted to comment on the original posting, but it fits here too. Asid=
e=20
from this performance perspective, in order to have a system that=20
survives crashes and powerouts, better use:
Disk (Write) Cache: disabled (is that Disk Cache Policy for writes, or=20=

read+writes?)
Write Cache DISABLED if Bad BBU=20
While turning off disk write caches costs some performance always,=20
disabling the controller write cache if the bbu is dead makes the serve=
r=20
only slower during bbu outages, but at least it will survive a crash=20=

then.
It depends on your needs, but I don't know an admin with a +40TB storag=
e=20
that says "doesn't matter if it breaks, I'll restore from backup", as=20=

even with disk2disk backup that takes some time.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart3606948.QQg65BAJD3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk/Yg+MACgkQzhSR9xwSCbTiJgCeK+LL0uYu5+fp7lYo01JDYhLE
IMEAoOcdGbG5G2JvTGcF+bwLaV/nSErA
=elRq
-----END PGP SIGNATURE-----

--nextPart3606948.QQg65BAJD3--


--===============6877154422066869220==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6877154422066869220==--
