Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:49570 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754551AbdDKMAH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 08:00:07 -0400
Date: Tue, 11 Apr 2017 14:00:07 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: filesystem dead, xfs_repair won't help
Message-ID: <20170411140007.05af2bcd@harpe.intellique.com>
In-Reply-To: <13452866-4e5e-371c-269b-cee60e0c6b59@scylladb.com>
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
        <612a9d5a-9877-405c-ef7c-dc9632a1d8bc@scylladb.com>
        <20170410153529.GE3991@bfoster.bfoster>
        <974df72a-04fe-fba4-4b48-89426b8783e0@scylladb.com>
        <20170411133033.65c89ee8@harpe.intellique.com>
        <13452866-4e5e-371c-269b-cee60e0c6b59@scylladb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cVf701te7/cjWvKr3Xoac5F"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

--Sig_/cVf701te7/cjWvKr3Xoac5F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 11 Apr 2017 14:40:15 +0300
Avi Kivity <avi@scylladb.com> =C3=A9crivait:

> $ sudo xfs_db -c "sb 0" /tmp/fs
> xfs_db: /tmp/fs is not a valid XFS filesystem (unexpected SB magic=20
> number 0x5846534d)
> Use -F to force a read attempt.
> $ sudo xfs_db -F -c "sb 0" /tmp/fs
> xfs_db: /tmp/fs is not a valid XFS filesystem (unexpected SB magic=20
> number 0x5846534d)
> xfs_db: V1 inodes unsupported. Please try an older xfsprogs.

Oops, I forgot one important part, sorry, you must restore the
meta_dump to a file first:

xfs_mdrestore /tmp/fs /tmp/fsimage

then run xfs_db on the /tmp/fsimage:

xfs_db -c 'sb 0' -c 'p' /tmp/fsimage

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/cVf701te7/cjWvKr3Xoac5F
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAljsxUcACgkQX3jQXNUicVZVQgCeKp5gM8L+WeYKp+ehVRJ3xC7P
LIQAn1CFV2qnUryz9x3WBj2XXoS+i7zq
=QGp0
-----END PGP SIGNATURE-----

--Sig_/cVf701te7/cjWvKr3Xoac5F--
