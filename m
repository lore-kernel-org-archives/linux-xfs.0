Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:15907 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752364AbdGGLuI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jul 2017 07:50:08 -0400
Date: Fri, 7 Jul 2017 13:50:09 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Weird xfs_repair error
Message-ID: <20170707135009.68c22182@harpe.intellique.com>
In-Reply-To: <20170706232803.GF17762@dastard>
References: <20170706153020.0ad6dd47@harpe.intellique.com>
        <20170706232803.GF17762@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/rg4G=UBxpN2dfhzMB_VuLoi"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

--Sig_/rg4G=UBxpN2dfhzMB_VuLoi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 7 Jul 2017 09:28:03 +1000
Dave Chinner <david@fromorbit.com> =C3=A9crivait:

> > disconnected inode 26417468, moving to lost+found
> > disconnected inode 26417469, moving to lost+found
> > disconnected inode 26417470, moving to lost+found
> >=20
> > fatal error -- name create failed in lost+found (117), filesystem
> > may be out of space =20
>=20
> Error 117. That's EFSCORRUPTED, not ENOSPC.  IOWs, lost+found was
> corrupted as it was being modified by xfs_repair.
>=20
> > Even stranger, after mounting back the image, there is no lost+found
> > anywhere to be found! However the filesystem has lots of free space
> > and free inodes, how come? =20
>=20
> Because lost+found was corrupted.

Actually with xfs_repair 4.11 it's a different error in the end:

disconnected inode 180399699751, moving to lost+found
disconnected inode 180399699752, moving to lost+found

fatal error -- name create failed in lost+found (28), filesystem may be
out of space


--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/rg4G=UBxpN2dfhzMB_VuLoi
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAllfdXIACgkQX3jQXNUicVbCWACgumBufclATt/+mYEOFOPUPwRl
guoAnjxaZjvPj1X7ya/IyIv8MdOOOs9l
=rdVv
-----END PGP SIGNATURE-----

--Sig_/rg4G=UBxpN2dfhzMB_VuLoi--
