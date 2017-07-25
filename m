Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:19536 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752156AbdGYQoK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 12:44:10 -0400
Date: Tue, 25 Jul 2017 18:44:14 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Weird xfs_repair error
Message-ID: <20170725184414.0fe0a1b8@harpe.intellique.com>
In-Reply-To: <20170724145125.GA12097@bfoster.bfoster>
References: <20170706153020.0ad6dd47@harpe.intellique.com>
        <20170706232803.GF17762@dastard>
        <20170707135009.68c22182@harpe.intellique.com>
        <20170707153633.GG4103@magnolia>
        <20170711152340.4cd5dff9@harpe.intellique.com>
        <20170717171129.GA57771@bfoster.bfoster>
        <20170724162728.2a77797a@harpe.intellique.com>
        <20170724145125.GA12097@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Lr6m/kOPVS.XQmznKcix+pJ"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

--Sig_/Lr6m/kOPVS.XQmznKcix+pJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Mon, 24 Jul 2017 10:51:25 -0400
Brian Foster <bfoster@redhat.com> =C3=A9crivait:

> There are several fixes in-flight for the issues uncovered by this
> metadump. I think you'll want to include the following 3 patches to
> xfsprogs:
>=20
> http://marc.info/?l=3Dlinux-xfs&m=3D150047977108174&w=3D2
> http://marc.info/?l=3Dlinux-xfs&m=3D150040481220074&w=3D2
> http://marc.info/?l=3Dlinux-xfs&m=3D150040481820076&w=3D2
>=20
> Note that the last 2 patches are probably going to be reworked into a
> different implementation. The idea here is ultimately to avoid running
> the verifier in a case where it disrupts xfs_repair, so using this
> intermediate patch series should be good enough to build a custom
> binary that allows xfs_repair to eventually piece the fs back
> together. You could alternatively just hack xfs_dir2_sf_verify() to
> return 0.
>=20
> Note that I would highly recommend to test whatever you build against
> your metadump before the original fs.
>=20

You bet... I would even try salvaging files from the unrepaired fs if
possible, but it's probably not workable.

For info I tried the new 4.12, and it fails reliably like this (after
gazillions of metadata errors, etc):

bad hash table for directory inode 4295385906 (no data entry):
rebuilding rebuilding directory inode 4295385906
7f42b14f8780: Badness in key lookup (length)
bp=3D(bno 0x0, len 4096 bytes) key=3D(bno 0x0, len 512 bytes)
7f42b14f8780: Badness in key lookup (length)
bp=3D(bno 0x0, len 4096 bytes) key=3D(bno 0x0, len 512 bytes)
Invalid inode number 0x0
xfs_dir_ino_validate: XFS_ERROR_REPORT

fatal error -- couldn't map inode 4295400241, err =3D 117

At least it's always the same error (previous versions were ending with
various logs sizes and errors).

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/Lr6m/kOPVS.XQmznKcix+pJ
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAll3dV4ACgkQX3jQXNUicVZaDgCgj2dDKfZxtobOwdpDdf7TUq7s
sWwAoMuUQN3Ry7xwSHASbu1lMbBNgv0P
=hAth
-----END PGP SIGNATURE-----

--Sig_/Lr6m/kOPVS.XQmznKcix+pJ--
