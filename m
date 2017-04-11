Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:65355 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752076AbdDKQOA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 12:14:00 -0400
Date: Tue, 11 Apr 2017 18:13:55 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: filesystem dead, xfs_repair won't help
Message-ID: <20170411181355.59c1ee1f@harpe.intellique.com>
In-Reply-To: <68ab8fb6-1cfd-66de-d2f3-eab21796fb16@scylladb.com>
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
        <612a9d5a-9877-405c-ef7c-dc9632a1d8bc@scylladb.com>
        <20170410153529.GE3991@bfoster.bfoster>
        <974df72a-04fe-fba4-4b48-89426b8783e0@scylladb.com>
        <20170411133033.65c89ee8@harpe.intellique.com>
        <13452866-4e5e-371c-269b-cee60e0c6b59@scylladb.com>
        <20170411140007.05af2bcd@harpe.intellique.com>
        <9d2587d5-e1f1-e5bb-d276-bc6731b2fce8@scylladb.com>
        <20170411144906.39323b30@harpe.intellique.com>
        <68ab8fb6-1cfd-66de-d2f3-eab21796fb16@scylladb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ZUmw/NSHpeLMagG1KX8RPH1"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

--Sig_/ZUmw/NSHpeLMagG1KX8RPH1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 11 Apr 2017 16:07:56 +0300
Avi Kivity <avi@scylladb.com> =C3=A9crivait:

> $ sudo xfs_db -c 'sb 0' -c 'check' /tmp/fsimage
> ERROR: The filesystem has valuable metadata changes in a log which
> needs to be replayed.  Mount the filesystem to replay the log, and
> unmount it before re-running xfs_db.  If you are unable to mount the
> filesystem, then use the xfs_repair -L option to destroy the log and
> attempt a repair. Note that destroying the log may cause corruption
> -- please attempt a mount of the filesystem before doing this.
>=20
>=20
> xfs_repair did not recognize the superblock, and started hunting for
> the second one, emitting dots in the process.  I stopped it, since it
> failed on the live disk.
>=20

Can you mount the image, or does it fail immmediately because of the
CRC error?

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/ZUmw/NSHpeLMagG1KX8RPH1
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAljtAMMACgkQX3jQXNUicVYtggCfU0kwW/ZPo2BtZbgvSRges6Ar
smcAoIp2i9NVaAUOZLBnk7ohaHZo/8Gm
=/g7F
-----END PGP SIGNATURE-----

--Sig_/ZUmw/NSHpeLMagG1KX8RPH1--
