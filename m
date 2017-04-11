Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:17553 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752901AbdDKLae (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 07:30:34 -0400
Date: Tue, 11 Apr 2017 13:30:33 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: filesystem dead, xfs_repair won't help
Message-ID: <20170411133033.65c89ee8@harpe.intellique.com>
In-Reply-To: <974df72a-04fe-fba4-4b48-89426b8783e0@scylladb.com>
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
        <612a9d5a-9877-405c-ef7c-dc9632a1d8bc@scylladb.com>
        <20170410153529.GE3991@bfoster.bfoster>
        <974df72a-04fe-fba4-4b48-89426b8783e0@scylladb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/004zl8gYvAEc5d/wEH=BuP9"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

--Sig_/004zl8gYvAEc5d/wEH=BuP9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 11 Apr 2017 10:46:07 +0300
Avi Kivity <avi@scylladb.com> =C3=A9crivait:

> $ sudo xfs_repair /dev/nvme0n1
> Phase 1 - find and verify superblock...
> couldn't verify primary superblock - not enough secondary superblocks=20
> with matching geometry !!!

Which version of xfs_repair is this?

Try to export the FS structure with xfs_metadump, something like

xfs_metadump /dev/nvme0n1 /some/file.dmp

And check the errors it reports, they may be informative.=20

In the case where metadump works out fine, you should then try to have a
look at the FS structure using the dump (to avoid wrecking it more that
it already is):

xfs_db -c "sb 0" /some/file.dmp

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/004zl8gYvAEc5d/wEH=BuP9
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAljsvloACgkQX3jQXNUicVZ9IQCg2e+xe49RzL54Km+wq3OLmcCn
sl8An1y1C35VXpfn7DebR3rdEe3KzR4/
=8u0j
-----END PGP SIGNATURE-----

--Sig_/004zl8gYvAEc5d/wEH=BuP9--
