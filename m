Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bilbo.ozlabs.org ([203.11.71.1]:45009 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbfGCDTy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Jul 2019 23:19:54 -0400
Date: Wed, 3 Jul 2019 13:19:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the block tree with the xfs tree
Message-ID: <20190703131948.37b05189@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/FYqSM1F0geViJaDykvbS9Vo"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>

--Sig_/FYqSM1F0geViJaDykvbS9Vo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the block tree got a conflict in:

  fs/xfs/xfs_aops.c

between commit:

  a24737359667 ("xfs: simplify xfs_chain_bio")

from the xfs tree and commit:

  79d08f89bb1b ("block: fix .bi_size overflow")

from the block tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc fs/xfs/xfs_aops.c
index bb769d9c5250,11f703d4a605..000000000000
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@@ -790,8 -782,8 +790,8 @@@ xfs_add_to_ioend
  		atomic_inc(&iop->write_count);
 =20
  	if (!merged) {
- 		if (bio_full(wpc->ioend->io_bio))
+ 		if (bio_full(wpc->ioend->io_bio, len))
 -			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
 +			wpc->ioend->io_bio =3D xfs_chain_bio(wpc->ioend->io_bio);
  		bio_add_page(wpc->ioend->io_bio, page, len, poff);
  	}
 =20

--Sig_/FYqSM1F0geViJaDykvbS9Vo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0cHtUACgkQAVBC80lX
0GxjbQf7BHHTZllJ6X240rzOrgZ8DA7+yeR4uy9cFKqJlpTY+2ImMN1UnEVUxLpW
CppMNCEWVQOMSpLMnkFYt7H+VPbj8Z64Ta6Znv0GxXhYlpgz8AiPx8I1e3Ua3vd+
oEG5GPh4wNTzBzXjxnPD/BtezzGwvvyZPYxoCqlvOj8A6KvyxnpfgqET88JC2POb
tvp/BBo8pwVlGhm9vnj5uKPs7YRE4DwC/uWzBZApXLrewdpADXzi3iRAisWclezA
Uv7rIA3t4RXMN3onQAlsEIuECyNNqO8TTvNng5iLwM94Rr0VQieakCaonRPAv9eg
RnPFmW8oA9eR6zK14SmKlJXKebzVlg==
=7nq4
-----END PGP SIGNATURE-----

--Sig_/FYqSM1F0geViJaDykvbS9Vo--
