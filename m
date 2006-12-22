Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Dec 2006 12:40:06 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBMKdwqw029414
	for <linux-xfs@oss.sgi.com>; Fri, 22 Dec 2006 12:40:00 -0800
Subject: Re: unexpected XFS SB magic number
From: Russell Cattelan <cattelan@thebarn.com>
In-Reply-To: <Pine.SOL.4.58.0612221219570.2514@titan.cfa.harvard.edu>
References: <Pine.SOL.4.58.0612221219570.2514@titan.cfa.harvard.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S/44nacjDr44cG78WNeG"
Date: Fri, 22 Dec 2006 14:12:04 -0600
Message-Id: <1166818324.20632.35.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: gbakos@cfa.harvard.edu
Cc: linux-xfs@oss.sgi.com

--=-S/44nacjDr44cG78WNeG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2006-12-22 at 12:42 -0500, Gaspar Bakos wrote:
> Dear all,
>=20
> I have a 12 x 500Gb RAID-5 hardware RAID array on an ARECA 1130-ML
> controller. There is one single partition on it, exported as /dev/sdc1.
> This configuration used to work fine for 4 months.
> Then the computer crashed a couple of times, and led to a situation where
>=20
> xfs_check /dev/sdc1 output is:
>=20
> xfs_check: unexpected XFS SB magic number 0x45464920
> xfs_check: size check failed
> xfs_check: read failed: Invalid argument
> xfs_check: data size check failed
> xfs_check: failed to alloc 58876353264 bytes: Cannot allocate memory

What does=20
xfs_db /dev/sdc1
sb 0
p=20

look like?
That will print out the contents of the superblock

>=20
> I also checked the RAID, and seemingly the controller is fine; I can
> communicate with it, all 12 disks are visible, their SMART status is
> OK, the RAID-5 is reported to be in 'normal' condition, etc.
>=20
> [root@localhost ~]# xfs_db -r /dev/sdc1
> xfs_db: unexpected XFS SB magic number 0x45464920
> xfs_db: size check failed
> xfs_db: read failed: Invalid argument
> xfs_db: data size check failed
> xfs_db: failed to alloc 58876353264 bytes: Cannot allocate memory
>=20
> --------------------
>=20
> [root@localhost ~]# xfs_repair -nv /dev/sdc1
>=20
> Phase 1 - find and verify superblock...
> bad primary superblock - bad magic number !!!
> attempting to find secondary superblock...
> .........................................................................=
.......
> ...
> ....................found candidate secondary superblock...
> unable to verify superblock, continuing...
> ...
> ....................found candidate secondary superblock...
> verified secondary superblock...
> would write modified primary superblock
> Primary superblock would have been modified.
> Cannot proceed further in no_modify mode.
> Exiting now.
>=20
> ----------------
>=20
>=20
> I would very much appreciate advice on how to proceed in such situation.
> I worry that xfs_repair will repair, but may leave a mess that is hard
> to recover. I am hoping there may be a safer way.
>=20
>=20
> Best regards
> Gaspar
>=20
--=20
Russell Cattelan <cattelan@thebarn.com>

--=-S/44nacjDr44cG78WNeG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFjDwUNRmM+OaGhBgRAg1RAJ96GG3Omlf8Rjprjeoi4hnx/AoolgCffxmq
iSwLuVzDXVrwr85LGEjqqgg=
=lSXr
-----END PGP SIGNATURE-----

--=-S/44nacjDr44cG78WNeG--
