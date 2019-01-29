Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:58117 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbfA2XGn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Jan 2019 18:06:43 -0500
Date: Wed, 30 Jan 2019 10:06:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Fixes tag needs some work in the xfs tree
Message-ID: <20190130100640.5c2512a4@canb.auug.org.au>
In-Reply-To: <20190129220802.GC4205@dastard>
References: <20190130075647.53e86078@canb.auug.org.au>
        <20190129220802.GC4205@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/iLFP5jwk9YbZv+n5EqBFhBM"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

--Sig_/iLFP5jwk9YbZv+n5EqBFhBM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 30 Jan 2019 09:08:02 +1100 Dave Chinner <david@fromorbit.com> wrote:
>
> Might be worth adding this to the boiler plate code:
>=20
> 	This can be fixed by adding the following to your ~/.gitconfig file:
>=20
> 	[core]
> 		abbrev =3D 12

Actually, since git v2.11 (released Nov 29, 2016), abbrev =3D auto (which
is the default) means that the default scales with the size of the
repository.  For Linus' tree, that currently produces 12 digit commit
SHA1 abbreviations, but will probably soon become 13.  So the best
currently, is to *not* set core.abbrev (or set it to something above 12
(for future robustness).

See
https://lore.kernel.org/lkml/20181220000112.24891-1-avarab@gmail.com/

--=20
Cheers,
Stephen Rothwell

--Sig_/iLFP5jwk9YbZv+n5EqBFhBM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlxQ3IAACgkQAVBC80lX
0Gx37Qf9FSpK4OGd25bXQtiBYLML04zl/2Do252BnI4Gzn0uuvVPIrqh/d7585gs
nF2aL/pWKIDFXge+WzbD+Ki/J3XKMj3NnTHKw6ODd5b2H2EViO+RRv/6hmRdFRIU
8bD8LwsMIudDw43IF25XvOGTEyIAawjwXJhWplho2nciAg30PgsSMsw7UHp7JFF/
vHP3QTI70IC0xjyVH0PloBbhWbTK451LtqbIuum5JVftmy4w1trpm3QHGWfMUS+a
3Mk3JYgcNofj6d7g3TovqaNDAnMQ/CPMox5T2bUs4JZGMtJVcYyHzYJe40L2UY5T
uTZUQFUBPqwbqPYwKZqBxEbCder43A==
=dZmb
-----END PGP SIGNATURE-----

--Sig_/iLFP5jwk9YbZv+n5EqBFhBM--
