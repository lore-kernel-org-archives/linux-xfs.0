Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:52606 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752599AbdHQN3Q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 09:29:16 -0400
Date: Thu, 17 Aug 2017 15:29:19 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_repair fails to clean directory inode
Message-ID: <20170817152919.74346980@harpe.intellique.com>
In-Reply-To: <9c1f39a3-c4cf-e98d-4331-475b037268b7@suse.de>
References: <9c1f39a3-c4cf-e98d-4331-475b037268b7@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/OY1kxYoRFHb5JpoJIf2JwKi"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

--Sig_/OY1kxYoRFHb5JpoJIf2JwKi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 17 Aug 2017 14:13:24 +0200
Hannes Reinecke <hare@suse.de> =C3=A9crivait:

> bogus .. inode number (0) in directory inode 128, clearing inode
> number xfs_repair: dir2.c:1419: process_dir2: Assertion `(ino !=3D
> mp->m_sb.sb_rootino && ino !=3D *parent) || (ino =3D=3D mp->m_sb.sb_rooti=
no
> && (ino =3D=3D *parent || need_root_dotdot =3D=3D 1))' failed.
> Aborted (core dumped)
>=20
> Needless to say, the kernel refuses to mount that fs.
>=20
> The really annoying thing is that this FS hosted my various
> development git trees, and I really would hate to see the data gone.
>=20
> Thanks for any hints.
>=20

Which version of xfs_repair are you using? You should probably try the
latest (4.12) first of all.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/OY1kxYoRFHb5JpoJIf2JwKi
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlmVmi8ACgkQX3jQXNUicVYTswCgk4hwWw/NYYSFRRCobdMfWH/R
N0gAniQyxW+RNiHBWos8yzMD8OwQVgoL
=JY9M
-----END PGP SIGNATURE-----

--Sig_/OY1kxYoRFHb5JpoJIf2JwKi--
