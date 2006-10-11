Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Oct 2006 15:31:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9BMVjaG028886
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 15:31:47 -0700
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C68FD1892CF
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 15:31:02 -0700 (PDT)
Subject: Re: GRIO in Linux XFS?
From: Russell Cattelan <cattelan@thebarn.com>
In-Reply-To: <452D5F49.70808@sandeen.net>
References: 
	 <CAEAF2308EEED149B26C2C164DFB20F4DDE78B@ALPMLVEM06.e2k.ad.ge.com>
	 <Pine.LNX.4.61.0610112129060.9822@yvahk01.tjqt.qr>
	 <452D5F49.70808@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rUgm4z/onJn8nYmw2vy1"
Date: Wed, 11 Oct 2006 17:29:55 -0500
Message-Id: <1160605795.5723.5.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, "Phetteplace, Thad (GE Healthcare, consultant)" <Thad.Phetteplace@ge.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

--=-rUgm4z/onJn8nYmw2vy1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2006-10-11 at 16:16 -0500, Eric Sandeen wrote:
> Jan Engelhardt wrote:
> >> what is the status of GRIO support in the Linux port of XFS?
> >=20
> > Called realtime volume.
> > (http://en.wikipedia.org/wiki/XFS section 2.11)
>=20
> Well, not really.  realtime was a part of the old griov1 setup on Irix,
> but realtime !=3D GRIO.

the realtime allocator really should be renamed bitmap.

griov1 relied on an fs allocator that would return in bounded time=20
so it could satisfy irix realtime requirements thus it was
called "realtime".




> -Eric
>=20
--=20
Russell Cattelan <cattelan@thebarn.com>

--=-rUgm4z/onJn8nYmw2vy1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFLXBiNRmM+OaGhBgRAnbxAJ98+dCC9c/n0ot67PX+JWsvf4IligCfcVN7
kx1fmBgydgnlWB1luXh4Tp8=
=jtpP
-----END PGP SIGNATURE-----

--=-rUgm4z/onJn8nYmw2vy1--
