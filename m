Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Nov 2006 08:26:25 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAMGQHaG017799
	for <xfs@oss.sgi.com>; Wed, 22 Nov 2006 08:26:18 -0800
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
From: Russell Cattelan <cattelan@thebarn.com>
In-Reply-To: <45647042.2040604@sandeen.net>
References: <455CB54F.8080901@sandeen.net> <455CE1E3.7020703@sandeen.net>
	 <45612621.5010404@sandeen.net>  <45627A4D.3020502@sandeen.net>
	 <1164157336.19915.43.camel@xenon.msp.redhat.com>
	 <5A1AC29043EE33BEB778198A@timothy-shimmins-power-mac-g5.local>
	 <45647042.2040604@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OteeeT/tPu66SAzVEb3c"
Date: Wed, 22 Nov 2006 10:24:55 -0600
Message-Id: <1164212695.19915.65.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

--=-OteeeT/tPu66SAzVEb3c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2006-11-22 at 09:44 -0600, Eric Sandeen wrote:
> Timothy Shimmin wrote:
> > Thanks, Russell.
> >=20
> > I've been going thru the irc and just started looking at the patch.
> > I'll get back to you about it tomorrow.
> >=20
> > I agree it would be good to have the fixed forkoff for data btree roots
> > as the first fix. And look into redoing the btree root for a later chan=
ge.
>=20
> My only question is, how much does this defeat the purpose of attr2?
Well from the standpoint that attr2 currently corrupts inodes anything
to prevent that is good, since  currently attr2 can't be used at all.
When the di_u is extent based the attr2 code works as expected, giving
space to which ever segment gets there first.The attr2 code should still
be a big win for most file/dir inodes since they are probably able to do
their block mapping with local or extent mode.

The number of inodes that get pushed to btree mode should be a small %
of the
total number of inodes, especially on a root file system. So while attr2
is
not as efficient as it could be for that segment of the inodes the rest
of inodes
do benefit from attr2

By fixing the initial size calculation at least things like SElinux
which is adding one attr won't cause the attr segment to flip to extents
immediately.
The second attr will cause the flip but not the first one.


>=20
> -Eric
>=20
--=20
Russell Cattelan <cattelan@thebarn.com>

--=-OteeeT/tPu66SAzVEb3c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFZHnXNRmM+OaGhBgRAiUmAJ9EcLBfckkOk8ceY+ZQkapTN3mvAACfXO4x
d898C9V4nXS0QlWhM9wWzU4=
=Wxjo
-----END PGP SIGNATURE-----

--=-OteeeT/tPu66SAzVEb3c--
