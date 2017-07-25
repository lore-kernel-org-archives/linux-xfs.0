Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:46016 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750855AbdGYRQB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 13:16:01 -0400
Date: Tue, 25 Jul 2017 19:16:04 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Weird xfs_repair error
Message-ID: <20170725191604.43a3691e@harpe.intellique.com>
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
 boundary="Sig_/0T9YP7hZJLyIbg=/haV5PFJ"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

--Sig_/0T9YP7hZJLyIbg=/haV5PFJ
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

BTW to which branch do these apply?

For some reason I've tried xfs_repair 4.12 on another image I had tried
4.7 and 4.9 on, and... it seems to have repaired it. I'm trying to
understand how that happened...=20

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/0T9YP7hZJLyIbg=/haV5PFJ
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAll3fNUACgkQX3jQXNUicVYM0QCeIBPj9VVj5piukO49qm2Bhab+
7nEAoNSy/IUFbKJhnEQmsYJi3Knni4UR
=bSOW
-----END PGP SIGNATURE-----

--Sig_/0T9YP7hZJLyIbg=/haV5PFJ--
