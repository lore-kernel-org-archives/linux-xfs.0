Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:18385 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727109AbeJDRUM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Oct 2018 13:20:12 -0400
Date: Thu, 4 Oct 2018 12:27:00 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: [somewhat OT] I just discovered that Stratis uses XFS.
Message-ID: <20181004122639.330a6243@harpe.intellique.com>
In-Reply-To: <CAJCQCtQyXjB1bzOWuj8f+cd-WgFkxDY8xpZ8YhVoTC72rPLThA@mail.gmail.com>
References: <20181002162530.42b30c11@harpe.intellique.com>
        <20181002163707.5452307c@harpe.intellique.com>
        <6eb79c7b-4f15-28af-44b5-03488008a897@sandeen.net>
        <20181002183018.37343c26@harpe.intellique.com>
        <CAJCQCtQyXjB1bzOWuj8f+cd-WgFkxDY8xpZ8YhVoTC72rPLThA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//5+3Ka2eUlVH2WcZ/ZLBZ.J"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>

--Sig_//5+3Ka2eUlVH2WcZ/ZLBZ.J
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Wed, 3 Oct 2018 16:47:05 -0600
Chris Murphy <lists@colorremedies.com> =C3=A9crivait:

> >
> > You're right, I've looked through the source code and no option ever
> > gets passed to mkfs.xfs nor xfs_growfs related to FS size. That
> > means that it creates the FS with the default 4 AGs for a start. =20
>=20
> Stratis volumes are always built on dm-thin so I'd expect default
> mkfs.xfs to create ~33 AG's, which is what I get when running mkfs.xfs
> on LVM thin volumes.
>=20

Ah yes, interesting. I've created a 1TB thin volume and mkfs.xfs makes
32 AGs indeed.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_//5+3Ka2eUlVH2WcZ/ZLBZ.J
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAlu16xcACgkQX3jQXNUicVYBFACghw03VkmEErrw0yXkBdtFDPKD
v5kAoMaMQtWbTktL1qsXreZXWV12L+VQ
=pN6j
-----END PGP SIGNATURE-----

--Sig_//5+3Ka2eUlVH2WcZ/ZLBZ.J--
