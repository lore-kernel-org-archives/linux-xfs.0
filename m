Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:51438 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbeJBXO1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Oct 2018 19:14:27 -0400
Date: Tue, 2 Oct 2018 18:30:18 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: [somewhat OT] I just discovered that Stratis uses XFS.
Message-ID: <20181002183018.37343c26@harpe.intellique.com>
In-Reply-To: <6eb79c7b-4f15-28af-44b5-03488008a897@sandeen.net>
References: <20181002162530.42b30c11@harpe.intellique.com>
        <20181002163707.5452307c@harpe.intellique.com>
        <6eb79c7b-4f15-28af-44b5-03488008a897@sandeen.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Ngv+8CMLZaTpxEPBy3DrmBY"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs <linux-xfs@vger.kernel.org>

--Sig_/Ngv+8CMLZaTpxEPBy3DrmBY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 2 Oct 2018 10:05:42 -0500
Eric Sandeen <sandeen@sandeen.net> =C3=A9crivait:

> But if Stratis starts at 1TB it's not terrible; I'd need to look and
> see how many AGs get created (probably 4?) and if so, 250G AGs are
> not /too/ granular. If it's creating a lot more smaller AGs, that
> could become an issue if it gets grown to a very large size.  IOWs
> the growfs concern is mostly about the resulting AG size & AG count.
>=20

You're right, I've looked through the source code and no option ever
gets passed to mkfs.xfs nor xfs_growfs related to FS size. That means
that it creates the FS with the default 4 AGs for a start.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/Ngv+8CMLZaTpxEPBy3DrmBY
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAluznRoACgkQX3jQXNUicVYzsACgh9AmK/W2sytT9AWebCGLEuZd
13oAn13CLxO+f+w7Bi80jcLBwSV9LDsg
=MZFq
-----END PGP SIGNATURE-----

--Sig_/Ngv+8CMLZaTpxEPBy3DrmBY--
