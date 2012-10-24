Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OMKRlR058757 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 17:20:27 -0500
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id EFku4hYGUa0fkzFo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 15:22:08 -0700 (PDT)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 1/3] rename configure.in to configure.ac
Date: Wed, 24 Oct 2012 18:22:08 -0400
References: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
	<20121024220616.GT1377@sgi.com>
In-Reply-To: <20121024220616.GT1377@sgi.com>
MIME-Version: 1.0
Message-Id: <201210241822.09175.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3409157419777059254=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

--===============3409157419777059254==
Content-Type: multipart/signed;
  boundary="nextPart3425262.cxrDjrcstJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3425262.cxrDjrcstJ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday 24 October 2012 18:06:17 Ben Myers wrote:
> On Mon, Sep 24, 2012 at 07:39:36PM -0400, Mike Frysinger wrote:
> > Newer autotools warn and start to error with the older name.
> >=20
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>=20
> I have pulled this series into xfsdump and xfsprogs repos on oss.  xfstes=
ts
> has a little hiccup that I need to sort through first:
>=20
> ~/xfstests # make
> make: *** No rule to make target `configure.in', needed by `configure'.=20
> Stop.

yeah, i forgot to update Makefile to look for configure.ac.  i think all th=
e=20
repos will need that fix.  xfsprogs for example:
diff --git a/Makefile b/Makefile
index 80fec1e..7ef3e84 100644
=2D-- a/Makefile
+++ b/Makefile
@@ -28,7 +28,7 @@ SRCDIR =3D $(PKG_NAME)-$(PKG_VERSION)
 SRCTAR =3D $(PKG_NAME)-$(PKG_VERSION).tar.gz
=20
 CONFIGURE =3D aclocal.m4 configure config.guess config.sub install-sh ltma=
in.sh
=2DLSRCFILES =3D configure.in release.sh README VERSION $(CONFIGURE)
+LSRCFILES =3D configure.ac release.sh README VERSION $(CONFIGURE)
=20
 LDIRT =3D config.log .ltdep .dep config.status config.cache confdefs.h \
 	conftest* built .census install.* install-dev.* *.gz \
=2Dmike

--nextPart3425262.cxrDjrcstJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQiGoRAAoJEEFjO5/oN/WBdDMQAIammOhkFO81DylN+xA0Irzo
jvUaH5JkgSG2plYYjSRXZviBiGkXU3OEbnK70hmiIPDoQk0ZUb5tcu9oWZVaOpWw
PUJAE2DBryGVB/W+t8aFzIzCm8xAV06CO63qBTRCfUoMUEsxktN+j7AW3PMKQPSA
JX8UqSizt2mxyfmUqNIGXNJfFjzhGUeudAodiCyWgYDUSI8ReoQQ2CnQiYA42uel
yIrdXNBj+qjbffDU5ySds/xOeJpdh04UVIuNAUACDxq9Uj60LkGgEpg4lnFFA3tf
ed4x4174fffis6gCGiNWXSsAcJ/8wqCspNZMBYoadKr1sTVSkVS4dz7GliLGpcMZ
RUI84P89lPeRue+CkcNpAiWqPaULZzt5ri4CQ2wtMh9uqPbks+W0NMmJNb4T63LY
9UuxEnXeTnFwkuAr2AfJZqw0E5PAP6BzKJ7eMgjosKtRaJxSdb5TsvIAHx6d49sP
zogDrQdsv9V3j5+mo+jILIlcLAM4mlTEIXBV+UaMlU2BnZlJBgMUZSl/Vi1Bf+3Z
q6M/J1aD8VdDNyN0vnDxqIlwAPO2lhY0naDAXJgeRoaJVlPKvUhwXBwsOnZDliXM
oqLzRJXwlsMQGtfyjtXXs+eYFXQYXOIA79c9mTyF0bj1uMmUM3vN2zXpcTrZPj12
qdX147Ob/WqH8MssHRES
=s6uo
-----END PGP SIGNATURE-----

--nextPart3425262.cxrDjrcstJ--


--===============3409157419777059254==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3409157419777059254==--
