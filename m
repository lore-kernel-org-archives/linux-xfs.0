Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:41971 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727332AbfA2U4x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Jan 2019 15:56:53 -0500
Date: Wed, 30 Jan 2019 07:56:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: Fixes tag needs some work in the xfs tree
Message-ID: <20190130075647.53e86078@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/RicaNw4dIu0b2+hrLAjDX7W"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

--Sig_/RicaNw4dIu0b2+hrLAjDX7W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  4ea899ead278 ("iomap: fix a use after free in iomap_dio_rw")

Fixes tag

  Fixes: ff6a9292e6 ("iomap: implement direct I/O")

has these problem(s):

  - SHA1 should be at least 12 digits long

--=20
Cheers,
Stephen Rothwell

--Sig_/RicaNw4dIu0b2+hrLAjDX7W
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlxQvg8ACgkQAVBC80lX
0GzruQgAjaZIiKEwYGbf7nYMnVQlLn58+AOaEIMAZQsHJPcrzx30mfHWnYI4UbDk
Ay4n4hTFXNBVptN80fqrD5W1gQs6vSFZwq1wIpvf12+TfI7Uz9nSxh3CDCAQ3wmQ
VG9AaYk4YEgThkkyAX5hwEPQFumvfvgFcqf5sFcwiNg++QN7DvN6mosg1nnPFQWO
uhoLj0M8iJLQYPDb2wFWgqorhVm73cpnMgAVlVzPc3ilh5o0N+O0sutEiGIvi0/1
r5alsoQy0MC0KdtXrv+1oCfFXc03EkLNLUnLq742M3FH23peuZPXKX7Pm1wYEdEz
DD2YxPAOgQuF7aD8ezi9Wnwu0L74tg==
=McsE
-----END PGP SIGNATURE-----

--Sig_/RicaNw4dIu0b2+hrLAjDX7W--
