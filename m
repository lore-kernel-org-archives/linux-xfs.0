Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OL5qPg055577 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 16:05:52 -0500
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id loBU1e2SmDinQFfc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 14:07:37 -0700 (PDT)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 2/3] respect DESTDIR when installing
Date: Wed, 24 Oct 2012 17:07:36 -0400
References: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
	<1348529978-30048-2-git-send-email-vapier@gentoo.org>
	<20121024205140.GR1377@sgi.com>
In-Reply-To: <20121024205140.GR1377@sgi.com>
MIME-Version: 1.0
Message-Id: <201210241707.37499.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6914536068174297409=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

--===============6914536068174297409==
Content-Type: multipart/signed;
  boundary="nextPart2183724.txFiLITac4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2183724.txFiLITac4
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday 24 October 2012 16:51:40 Ben Myers wrote:
> Hey Mike,
>=20
> On Mon, Sep 24, 2012 at 07:39:37PM -0400, Mike Frysinger wrote:
> > This makes the `make install DESTDIR=3D...` form work.  It keeps support
> > for all previous forms too (like DIST_ROOT).
>=20
> This doesn't seem to work for me.  I do a make install
> DESTDIR=3D/some/odd/path and it all still goes into /usr.  What sort of
> system did you try this on? Maybe it just doesn't like opensuse 12.2?

the `make` output makes it look like it's going into / and such, but it isn=
't. =20
the install-sh script rewrites the path silently behind the scenes.

alternatively, maybe you didn't rebuild autotools after applying the patch =
? =20
the code will copy include/install-sh to the top level, and then everything=
=20
executes that rather than the original in the include/ subdir.
=2Dmike

--nextPart2183724.txFiLITac4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQiFiZAAoJEEFjO5/oN/WBh7UP/3YUftRvm+hUf+d2o8XVl9oL
DMfwNDQGiH6eCu1HyuJ8Wyf7E5m3AHBonWXL1eas/eXfyrQTyxd8uTciAoFuEaCZ
tNBLHLqcrYMwLZMZLtGWKSjSwJWGL1RvSJ1eDPud9K/KFIue6mLKRTarKE6AvSKe
5nXM746p+Z206QBUv5ceFxVlUaMVVq6ko5wY5TirhTIQNbh0/7MANd6x4UPUQyZT
QETktTvVZIZT5wDOH6CeFA4gqKEtbUqMcpYsjf9qAsZF3X49/SI+0BnsrwB4Vg4t
6LNxYqmnTvAigf9EXRcCfKCItxHRKutdtSt905BWkxXUVfdfK6cmGfu+hBFsWBLD
HjKeoegUbvkCm4Rz0yAHs/CnVRBMhT13VMfONKKNmRuJAHGC0BEfHo0jGyJw9ynD
msHA83jzinbziL8U6xOkdb3C321JJIoTllbm4DmFq1+vx3TZkiUC5NpXz7FT5Pcm
i0PLXoBEdo6hu7x67k0ZEJEstvD+rLS/kiG2H858n/IQ0fo6D88QAoaEiFGkfgcR
nNKR1Q+w8R1t5RiLX4RAIdQgrloJ9QCXOYExIiqnQcFyvy2t8/lieT1MMyTDsA5A
oZg8UzEL/XeMYesR6j79K1EhYrHbgx4yprsZJftJpG+pSaAQK6a20xl5AyZUw8ZP
dqLPudQzTv1xUJN5PBck
=NAUS
-----END PGP SIGNATURE-----

--nextPart2183724.txFiLITac4--


--===============6914536068174297409==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6914536068174297409==--
