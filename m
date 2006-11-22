Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Nov 2006 13:43:11 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAMLh3aG025337
	for <xfs@oss.sgi.com>; Wed, 22 Nov 2006 13:43:05 -0800
Subject: Re: XFS CORRUPTION 2.6.17.13?
From: Russell Cattelan <cattelan@thebarn.com>
In-Reply-To: <Pine.LNX.4.64.0611201459420.17165@p34.internal.lan>
References: <Pine.LNX.4.64.0611201459420.17165@p34.internal.lan>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3cgue0QeGJhKbvmyNhDp"
Date: Wed, 22 Nov 2006 15:41:56 -0600
Message-Id: <1164231716.19915.68.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

--=-3cgue0QeGJhKbvmyNhDp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2006-11-20 at 15:00 -0500, Justin Piszcz wrote:
> Anyone know what could cause this?
> Is the last good kernel to use 2.6.17.6 w/XFS bugfix patch?
>=20
> Was a new bug introduced from 2.6.16.6 -> 2.6.17.13?

you must have missed the "new bugs introduced in this release" :-)

There is no info here to go on.

run xfs_repair -n=20
if it looks like an existing bug add to it
if not open a new bug and attach repair output to it.

> Nov 20 13:16:58 box [4299533.469000] 0x0: 00 00 00 00 00 00 00 00 00 00 0=
0=20
> 00 00
> 00 00 00
> Nov 20 13:16:58 box [4299533.469000] Filesystem "hda2": XFS internal error
> xfs_da_do_buf(2) at line 2212 of file fs/xfs/xfs_da_btree.c.  Caller=20
> 0xc01ffcad
> Nov 20 13:16:58 box [4299533.469000]  <c02126fd>
> Nov 20 13:16:58 box xfs_corruption_error+0xf2/0x11a
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c01ffcad>
> Nov 20 13:16:58 box xfs_da_read_buf+0x3b/0x3f
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.469000]  <c0241320>
> Nov 20 13:16:58 box kmem_zone_alloc+0x60/0xdd
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c01ff227>
> Nov 20 13:16:58 box xfs_da_buf_make+0xf7/0x14c
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.469000]  <c01ffbb1>
> Nov 20 13:16:58 box xfs_da_do_buf+0x935/0x98d
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c01ffcad>
> Nov 20 13:16:58 box xfs_da_read_buf+0x3b/0x3f
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.469000]  <c013dd54>
> Nov 20 13:16:58 box __alloc_pages+0x53/0x2d6
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c01ffcad>
> Nov 20 13:16:58 box xfs_da_read_buf+0x3b/0x3f
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.469000]  <c0202a79>
> Nov 20 13:16:58 box xfs_da_node_lookup_int+0xd0/0x399
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c0202a79>
> Nov 20 13:16:58 box xfs_da_node_lookup_int+0xd0/0x399
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.469000]  <c020a921>
> Nov 20 13:16:58 box xfs_dir2_node_lookup+0x3f/0xb9
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c020549a>
> Nov 20 13:16:58 box xfs_dir2_lookup+0x137/0x139
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.470000]  <c013dd54>
> Nov 20 13:16:58 box __alloc_pages+0x53/0x2d6
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c0236080>
> Nov 20 13:16:58 box xfs_dir_lookup_int+0x40/0x125
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.470000]  <c023a72f>
> Nov 20 13:16:58 box xfs_lookup+0x5f/0x88
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c0248d0f>
> Nov 20 13:16:58 box xfs_vn_lookup+0x4f/0x93
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box [4299533.470000]  <c0164009>
> Nov 20 13:16:58 box do_lookup+0x12d/0x15f
> Nov 20 13:16:58 box
> Nov 20 13:16:58 box  <c0165387>
>=20
--=20
Russell Cattelan <cattelan@thebarn.com>

--=-3cgue0QeGJhKbvmyNhDp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFZMQkNRmM+OaGhBgRAgWQAJ4ljO7Kbak+LBup0wq3v0CYJPQIgACeIF53
9RsS/dHd/gUbWCH9TE+ubE8=
=H/TL
-----END PGP SIGNATURE-----

--=-3cgue0QeGJhKbvmyNhDp--
