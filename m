Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:10942 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751770AbdDKMtR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 08:49:17 -0400
Date: Tue, 11 Apr 2017 14:49:06 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: filesystem dead, xfs_repair won't help
Message-ID: <20170411144906.39323b30@harpe.intellique.com>
In-Reply-To: <9d2587d5-e1f1-e5bb-d276-bc6731b2fce8@scylladb.com>
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
        <612a9d5a-9877-405c-ef7c-dc9632a1d8bc@scylladb.com>
        <20170410153529.GE3991@bfoster.bfoster>
        <974df72a-04fe-fba4-4b48-89426b8783e0@scylladb.com>
        <20170411133033.65c89ee8@harpe.intellique.com>
        <13452866-4e5e-371c-269b-cee60e0c6b59@scylladb.com>
        <20170411140007.05af2bcd@harpe.intellique.com>
        <9d2587d5-e1f1-e5bb-d276-bc6731b2fce8@scylladb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/UoFqv2Yb+AantUlv=cxsaFs"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

--Sig_/UoFqv2Yb+AantUlv=cxsaFs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 11 Apr 2017 15:03:12 +0300
Avi Kivity <avi@scylladb.com> =C3=A9crivait:

> On 04/11/2017 03:00 PM, Emmanuel Florac wrote:
> > Le Tue, 11 Apr 2017 14:40:15 +0300
> > Avi Kivity <avi@scylladb.com> =C3=A9crivait:
> > =20
> >> $ sudo xfs_db -c "sb 0" /tmp/fs
> >> xfs_db: /tmp/fs is not a valid XFS filesystem (unexpected SB magic
> >> number 0x5846534d)
> >> Use -F to force a read attempt.
> >> $ sudo xfs_db -F -c "sb 0" /tmp/fs
> >> xfs_db: /tmp/fs is not a valid XFS filesystem (unexpected SB magic
> >> number 0x5846534d)
> >> xfs_db: V1 inodes unsupported. Please try an older xfsprogs. =20
> > Oops, I forgot one important part, sorry, you must restore the
> > meta_dump to a file first:
> >
> > xfs_mdrestore /tmp/fs /tmp/fsimage
> >
> > then run xfs_db on the /tmp/fsimage:
> >
> > xfs_db -c 'sb 0' -c 'p' /tmp/fsimage
> > =20
>=20
> magicnum =3D 0x58465342
> blocksize =3D 4096
> dblocks =3D 125026902
> rblocks =3D 0
> rextents =3D 0
> uuid =3D 50b25ad8-3eb9-4273-b7f2-d0a435b3a08f
> logstart =3D 67108869
> rootino =3D 96
> rbmino =3D 97
> rsumino =3D 98
> rextsize =3D 1
> agblocks =3D 31256726
> agcount =3D 4
> rbmblocks =3D 0
> logblocks =3D 61048
> versionnum =3D 0xb4b5
> sectsize =3D 512
> inodesize =3D 512
> inopblock =3D 8
> fname =3D "\000\000\000\000\000\000\000\000\000\000\000\000"
> blocklog =3D 12
> sectlog =3D 9
> inodelog =3D 9
> inopblog =3D 3
> agblklog =3D 25
> rextslog =3D 0
> inprogress =3D 0
> imax_pct =3D 25
> icount =3D 1959744
> ifree =3D 89
> fdblocks =3D 91586587
> frextents =3D 0
> uquotino =3D null
> gquotino =3D null
> qflags =3D 0
> flags =3D 0
> shared_vn =3D 0
> inoalignmt =3D 4
> unit =3D 0
> width =3D 0
> dirblklog =3D 0
> logsectlog =3D 0
> logsectsize =3D 0
> logsunit =3D 1
> features2 =3D 0x18a
> bad_features2 =3D 0x18a
> features_compat =3D 0
> features_ro_compat =3D 0x1
> features_incompat =3D 0x1
> features_log_incompat =3D 0
> crc =3D 0x3ebf41de (correct)
> spino_align =3D 0
> pquotino =3D null
> lsn =3D 0x70002828b
> meta_uuid =3D 00000000-0000-0000-0000-000000000000
>=20
>=20

Tha looks reasonable enough... Heck, what's happening? You could try
to run an integrity check from xfs_db (still using the dump) to locate
the error:

xfs_db -c 'sb 0' -c 'check' /tmp/fsimage

What does it report?

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/UoFqv2Yb+AantUlv=cxsaFs
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAljs0MMACgkQX3jQXNUicVa4MQCgw1cUiq8wPO6HYnr0ATIdPqxI
ci4AoKQrFPO2znUNLrsaMLWEhizwnZo7
=1lmE
-----END PGP SIGNATURE-----

--Sig_/UoFqv2Yb+AantUlv=cxsaFs--
