Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:26791 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750827AbeBWMCx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Feb 2018 07:02:53 -0500
Date: Fri, 23 Feb 2018 13:02:54 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_repair questions
Message-ID: <20180223130254.39d32448@harpe.intellique.com>
In-Reply-To: <CACssdW1a=+6Dh=TEV1g13ipfM1TXd29SEHNuz_ar7RfwpmgdFg@mail.gmail.com>
References: <CACssdW1a=+6Dh=TEV1g13ipfM1TXd29SEHNuz_ar7RfwpmgdFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/WyL5gmxzy3bTP6akiasnpbY"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alatun Rom <alatun.rom@gmail.com>
Cc: linux-xfs@vger.kernel.org

--Sig_/WyL5gmxzy3bTP6akiasnpbY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 23 Feb 2018 00:42:11 +0100
Alatun Rom <alatun.rom@gmail.com> =C3=A9crivait:

> As far as I understood, xfs_repair considers the file system
> unfixable, because the secondary superblocks are not found at the
> offsets, where they should be.

I don't think so, as it reports "invalid superblock signature", this is
most probably the culprit. It needs at least one proper, uncorrupted
superblock.

> The blocks found look quite ok.
> My guess: because the VMDK container got damaged, the information of
> the internal partitions is now incorrect, so testdisk did extract a
> file that is somehow broken. But from what I've seen so far, it could
> be possible to fix it up to the point, to extract some files.
>=20

I never knew that testdisk could be used like that. Is the volume of
the right size, matching the original partition?

> What is unclear for me: why are 7 SSB found? Is this a geometry issue?

The adresses are super weird: the 4 first seem OK, the the last three
are bizarrely close to each other:

32204029952
57813565440
64185663488
96412992512
96413164544
96413271040
96419537920

> The found superblocks tell, that a total of 4 superblocks should
> exist. What happens if you grow an XFS file system? Do additional
> stripes generate a layout like this? Is the distance between the
> superblock copies ALWAYS a constant value? In my scenario the distance
> of the first 3 superblocks is not a fixed value. But how can blocks
> get lost? I don't think this is possible with VMDK to "mark blocks as
> deleted" inside a partition and they are skipped when reading a
> partition.

Honestly, AFAIK VMDK are hollow files. If it gets damaged all bets are
off...

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/WyL5gmxzy3bTP6akiasnpbY
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlqQAu4ACgkQX3jQXNUicVYJ8QCgo6Gu7yjIo6NcO5uXa3QHkvrn
nUcAn3YuQRgESHrzRcd/XCD773fHeHp2
=C8ri
-----END PGP SIGNATURE-----

--Sig_/WyL5gmxzy3bTP6akiasnpbY--
