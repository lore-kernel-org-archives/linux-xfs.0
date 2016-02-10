Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2DA5529DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 21:21:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0444E8F8033
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 19:21:12 -0800 (PST)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id VGeO90NIdWfdYwSB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 19:21:06 -0800 (PST)
Subject: Bug#766811: spurious library links
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.766811.B766811.14550742356531@bugs.debian.org>
Date: Wed, 10 Feb 2016 04:17:03 +0100
From: Marco d'Itri <md@linux.it>
Message-ID: <20160210031703.GA28092@bongo.bofh.it>
References: <20141026004825.GA27863@bongo.bofh.it>
	<20160124151308.GA7620@jwilk.net>
	<20160206005821.GA11551@bongo.bofh.it>
	<20160206132241.GA2869@jwilk.net>
MIME-Version: 1.0
In-Reply-To: <20160206132241.GA2869@jwilk.net>
Reply-To: Marco d'Itri <md@linux.it>, 766811@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3512549724949970831=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jakub Wilk <jwilk@debian.org>, 766811@bugs.debian.org
Cc: Nathan Scott <nathans@debian.org>


--===============3512549724949970831==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Feb 06, Jakub Wilk <jwilk@debian.org> wrote:

> AFAICS this is the code responsible for creating /lib/libfoo <->
> /usr/lib/libfoo symlinks (see include/buildmacros:79):
>=20
> if [ "x$(shell readlink -f $(PKG_LIB_DIR))" !=3D \
>     "x$(shell readlink -f $(PKG_ROOT_LIB_DIR))" ]; then \
>        ../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).a $(PKG_ROOT_LIB_DIR)/$=
(LIBNAME).a; \
>        ../$(INSTALL) -S $(PKG_LIB_DIR)/$(LIBNAME).la $(PKG_ROOT_LIB_DIR)/=
$(LIBNAME).la; \
>        ../$(INSTALL) -S $(PKG_ROOT_LIB_DIR)/$(LIBNAME).so $(PKG_LIB_DIR)/=
$(LIBNAME).so; \
> fi

Right. Nathan, this code path is not used on Red Hat and SuSE, which=20
already implemented a merged /usr, and it has always been wrong on=20
Debian: I think it should just be removed from the upstream package.
Should I NMU?

--=20
ciao,
Marco

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQGcBAABCAAGBQJWuquuAAoJECv1pcEixPekwqYL/ibZvMwsMHnY/EEQrMZ/dWfS
sxjYZ92PK4lTygL6HhnTOgvoRoYudG9y0RCXHaFt8oorpqVWr9KBXkfPZCrVGDzW
oniT/6Nf3PDv9EeCtdCMLCS1CnjafxMXZZjC0YFj3/gtbnaAe8/X4nEldH4xV6U5
xrecDDqHRPcE+M3Ep+oLs7Bmmh9hBNNXiGZ33S8qCZ2lPzakzhLiqCIPP7X4vfUR
MXI6YxgGJiKl9j1KvYCGnf5CkG1Rs0t3NOCd3bEuZbecFjckWSaqSgdtXZ7GaXCK
02Yh+nWKEe1iSWc8dHt1CocNXAv2zxkD4DnBMhCIWGB05cCWDRCUbYpaiSx7Xblc
xfHv8Cb+QUiNzVIGA20sj4DFAoji6gtMs+Xfcq9ETKQ/utjhAmRyscVuv39Wzgi7
TFShOzeG3RjtEyEIYo5lnNy3QbclMWcQ8f6rv7JiW8uh7ULXameF4X8L3kITOkhw
/AmaI80AFrmYVX1sJfm7GNq0OOkv+gZSvf7e80/rOQ==
=aLcJ
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--


--===============3512549724949970831==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3512549724949970831==--
