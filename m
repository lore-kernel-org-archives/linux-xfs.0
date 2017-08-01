Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:24047 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751199AbdHANfr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Aug 2017 09:35:47 -0400
Date: Tue, 1 Aug 2017 15:35:48 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: metadata I/O error: block 0x575b6d70,("xfs_trans_read_buf_map")
 error 4 numblks 16
Message-ID: <20170801153548.15cf74ef@harpe.intellique.com>
In-Reply-To: <e4606e43-468e-431c-1663-6b167cc5648b@profihost.ag>
References: <e4606e43-468e-431c-1663-6b167cc5648b@profihost.ag>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/g3A9=/TDFwFL9R55iqpcvuW"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-xfs@vger.kernel.org

--Sig_/g3A9=/TDFwFL9R55iqpcvuW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 1 Aug 2017 10:12:57 +0200
Stefan Priebe - Profihost AG <s.priebe@profihost.ag> =C3=A9crivait:

> Hello,
>=20
> under very high load i'm getting the following error on a bcache
> device using XFS:
> XFS (bcache1): metadata I/O error: block 0x575b6d70
> ("xfs_trans_read_buf_map") error 4 numblks 16
> XFS (bcache1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -4.
> XFS (bcache1): xfs_do_force_shutdown(0x8) called from line 3519 of
> file fs/xfs/xfs_inode.c. Return address =3D 0xffffffff993441ff
> XFS (bcache1): Corruption of in-memory data detected. Shutting down
> filesystem
> XFS (bcache1): Please umount the filesystem and rectify the problem(s)
> XFS (bcache1): xfs_log_force: error -5 returned.
> XFS (bcache1): xfs_log_force: error -5 returned.
> XFS (bcache1): xfs_log_force: error -5 returned.
>=20
> The used kernel is 4.4.79 based while using an opensuses patchset. Is
> this something which is a known problem or something suse has broken?

Do you know if the patchset includes Eric Wheeler's stability patches
for bcache?

Also please post the output from dmesg with the complete trace.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/g3A9=/TDFwFL9R55iqpcvuW
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlmAg7QACgkQX3jQXNUicVa0oQCdF1SKVKw97a3+uEJkPzenTXGa
CjUAoOn5Oe5zJzq58D58UtsZ8jedIBg6
=6zHW
-----END PGP SIGNATURE-----

--Sig_/g3A9=/TDFwFL9R55iqpcvuW--
