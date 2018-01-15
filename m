Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:41549 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935043AbeAORIX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Jan 2018 12:08:23 -0500
Date: Mon, 15 Jan 2018 18:08:26 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Growing RAID10 with active XFS filesystem
Message-ID: <20180115180826.01665812@harpe.intellique.com>
In-Reply-To: <37abf496-57aa-fd12-26b7-09d43f08e6d5@youngman.org.uk>
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
        <20180108192607.GS5602@magnolia>
        <20180108220139.GB16421@dastard>
        <5A548D31.4000002@youngman.org.uk>
        <20180109222523.GJ16421@dastard>
        <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
        <20180111030723.GU16421@dastard>
        <5A58B901.7080609@youngman.org.uk>
        <20180112152538.2c4d8cd4@harpe.intellique.com>
        <37abf496-57aa-fd12-26b7-09d43f08e6d5@youngman.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cGC7Lu0slVysKYXb2rcXYKI"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wol's lists <antlists@youngman.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

--Sig_/cGC7Lu0slVysKYXb2rcXYKI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Sun, 14 Jan 2018 21:33:17 +0000
"Wol's lists" <antlists@youngman.org.uk> =C3=A9crivait:

> On 12/01/18 14:25, Emmanuel Florac wrote:
> >> My point is that all this causes geometries to change, and ext and
> >> btrfs amongst others can clearly handle this. Can XFS? =20
>=20
> > Neither XFS, ext4 or btrfs can handle this. That's why Dave
> > mentioned the fact that growing your RAID is almost always the
> > wrong solution. A much better solution is to add a new array and
> > use LVM to aggregate it with the existing ones. =20
>=20
> Does the new array need the same geometry as the old one?

That's the best way to preserve performance, yes.
=20
> What happens if my original array is a 4-disk raid-5, and then I add
> a 3-disk raid-5? Can XFS cope with the different optimisations
> required for the different layouts on the different arrays?

No because your array will remain optimised for the initial layout.
However, if you add a new array with the same stripe characteristics you
should at least NOT lose performance. See also the mount options  Stan
mentioned earlier :)

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/cGC7Lu0slVysKYXb2rcXYKI
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlpc4AoACgkQX3jQXNUicVanHgCg43/NQQ0c8KsZWZWDxtSHf6oP
wUAAoJy932P8g04MufkNxCjZIhI8RAbw
=B8gg
-----END PGP SIGNATURE-----

--Sig_/cGC7Lu0slVysKYXb2rcXYKI--
