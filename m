Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 06:47:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9SDl92s028506
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 06:47:10 -0700
Received: from rproxy.teamix.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A518551B0D
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 06:46:53 -0700 (PDT)
Received: from rproxy.teamix.net (postman.teamix.net [194.150.191.120]) by cuda.sgi.com with ESMTP id Ch4waPUVmiokWReG for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 06:46:53 -0700 (PDT)
From: Martin Steigerwald <ms@teamix.de>
Subject: Debian Etch Backport of xfsprogs 2.9.8-1
Date: Tue, 28 Oct 2008 14:46:34 +0100
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1349160.xvHALXmB7a";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810281446.45521.ms@teamix.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: backports-users@lists.backports.org
Cc: xfs@oss.sgi.com

--nextPart1349160.xvHALXmB7a
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Hi!

I made a xfsprogs-Backports for Debian Etch, since the xfsprogs for Etch is=
 at=20
version 2.8.11 - so fairly outdated:

http://people.teamix.net/~ms/backports/etch-backports/xfsprogs/

I would be willing to maintain this - at least until Debian Lenny is out. S=
o=20
if someone wants to sponsor an upload please tell me in case any changes ar=
e=20
needed.

Important: You may need a newer kernel than the one in Debian Etch (2.6.18)=
 in=20
order to access XFS partitions that you formatted with mkfs.xfs from this=
=20
backport. But I since it does not set lazy superblock counters by default=
=20
since xfsprogs 2.9.7 it might just work. Otherwise better use EtchNHalf ode=
r=20
current backport kernel with it.

Ciao,
--=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart1349160.xvHALXmB7a
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkHF7sACgkQHhDFkwOZrpAvOQCeI5OSWNB2vIDXJAXYqJKxCQGY
tK4An2/TBa/B7QVVoIyXkueF2GdQT5km
=CW2M
-----END PGP SIGNATURE-----

--nextPart1349160.xvHALXmB7a--
