Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:60373 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbeGLEsv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Jul 2018 00:48:51 -0400
Date: Thu, 12 Jul 2018 14:41:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: duplicate patches in the gfs2 and xfs trees
Message-ID: <20180712144102.746cb560@canb.auug.org.au>
In-Reply-To: <CAHc6FU7jM=j6c028ycJS_NiaeOYMH3ofNeTJZxJ78iphujL0WQ@mail.gmail.com>
References: <20180712113724.413e4a3f@canb.auug.org.au>
        <CAHc6FU7jM=j6c028ycJS_NiaeOYMH3ofNeTJZxJ78iphujL0WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/jhMm70LNM30K3D1riPCApi3"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>, Bob Peterson <rpeterso@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

--Sig_/jhMm70LNM30K3D1riPCApi3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andreas,

On Thu, 12 Jul 2018 04:30:07 +0200 Andreas Gruenbacher <agruenba@redhat.com=
> wrote:
>
> this is what I'm seeing (git log --pretty=3Doneline --abbrev-commit
> --graph ^origin/master gfs2/for-next):
>=20
> * f79caf101801 (gfs2/for-next) gfs2: use iomap_readpage for blocksize
> =3D=3D PAGE_SIZE
> * af58827ee500 gfs2: Use iomap for stuffed direct I/O reads
> *   c38e838abe42 Merge branch 'iomap-4.19-merge' into linux-gfs2/for-next
> |\
> | * 806a1477b10a (xfs/iomap-4.19-merge) iomap: add inline data support
> to iomap_readpage_actor
> | * ec181f6782d8 iomap: support direct I/O to inline data
> | * 09230435dffd iomap: refactor iomap_dio_actor
> | * c03cea42149d iomap: add initial support for writes without buffer hea=
ds
> | * 72b4daa24129 iomap: add an iomap-based readpage and readpages impleme=
ntation
> * | 9ab5aa4f4e10 gfs2: fallocate_chunk: Always initialize struct iomap
> * | 2e2834ef1797 GFS2: Fix recovery issues for spectators
> * |   5db0147b887e Merge branch 'iomap-write' into linux-gfs2/for-next
> |\ \
> | * | 025d0e7f73c6 (gfs2/iomap-write) gfs2: Remove gfs2_write_{begin,end}
> | * | 967bcc91b044 gfs2: iomap direct I/O support
> | * | bcfe94139a45 gfs2: gfs2_extent_length cleanup
> | * | 64bc06bb32ee gfs2: iomap buffered write support
> | * | d505a96a3b16 gfs2: Further iomap cleanups
> | |/
> | * e184fde6f3f5 iomap: add private pointer to struct iomap
> | * 63899c6f8851 iomap: add a page_done callback
> | * 19e0c58f6552 iomap: generic inline data handling
> | * ebf00be37de3 iomap: complete partial direct I/O writes synchronously
> | * 3d7b6b21f6c5 iomap: mark newly allocated buffer heads as new
> | * a6d639da63ae fs: factor out a __generic_write_end helper
> * 3beacef8093b fs: gfs2: Adding new return type vm_fault_t
> * d80ff78468e4 gfs2: using posix_acl_xattr_size instead of posix_acl_to_x=
attr
> * e904f3d486f9 gfs2: Don't reject a supposedly full bitmap if we have
> blocks reserved
> * d1475c07f7ce GFS2: rgrp free blocks used incorrectly
> * b7eba890a228 gfs2: Eliminate redundant ip->i_rgd
> * 03f8c41c73da gfs2: Stop messing with ip->i_rgd in the rlist code
> * ee9c7f9ae3d4 gfs2: call ktime_get_coarse_real_ts64() directly
> * 00251a16d7f9 gfs2: Minor clarification to __gfs2_punch_hole
> * 9e1a9ecd13b9 gfs2: Don't withdraw under a spin lock
> * f85c10e24ab9 gfs2: eliminate rs_inum and reduce the size of gfs2 inodes
>=20
> Commit e184fde6f3f5 "iomap: add private pointer to struct iomap" is on
> xfs/iomap-4.19-merge. That was my initial merge from
> xfs/iomap-4.19-merge, but it was a fast-forward so there is no merge
> commit. I've then merged our iomap-write branch into for-next, with
> two additional commits on top. Then comes the rest of
> xfs/iomap-4.19-merge (that branch has moved ahead in the meantime),
> again with two more commits on top.
>=20
> There are no rebased commits, you're looking at the exact same commits.

The problem is that commits

  a6d639da63ae fs: factor out a __generic_write_end helper

to

  806a1477b10a (xfs/iomap-4.19-merge) iomap: add inline data support

have been rebased in the xfs tree from a base of v4.18-rc1 to
v4.18-rc4, so that those patches now appear twice in linux-next where I
have merged the gfs2 tree and the xfs tree.  This has caused a few
conflicts today as there are more changes to the same files affected by
those commits in the xfs tree. to iomap_readpage_actor

What should have happened is that those commits should not have been
rebased, so either the xfs tree needs rebuilding to use the old
commits, or your tree needs to be rebuilt using the new commits from
the xfs tree.  This is why we do not like the rebasing of published
trees (especially when a subset of the tree is shared with other
developers).

Also, if you are going to merge (part of) another tree you need to make
sure that the other maintainer will not do a rebase of it (I assume
that this was probably talked about).
--=20
Cheers,
Stephen Rothwell

--Sig_/jhMm70LNM30K3D1riPCApi3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAltG294ACgkQAVBC80lX
0GyUpwf/ZYLDkZlEhcLCK65duwS+huCeaHmMqTbVMkfRQSkREJ3l28H9jlOB1wKu
oZRMxHK9yFt4WKIJs8+yGNI9jrOr757O9O3736m0voCyf2rBCtKE2PJY6P/Ukyy6
LGlE9l7WMR5NwJbzpLovte7TnwEM+Oj8WTlXPhjLuiaWl52BOGeDNfKCXfCXjH4r
q0LNg7VfbpFhNRqy9omd+MEw4gESJxjaTQR+m+6WWgEDSKmM4n6qbHla3QEDa7q4
cCdI52S6jx2GijZ5VYWpaN7/mkIvRY/UJ2ErEq104FeTNMTOHfoZ2OlL2rw4sQKw
U41Lx1TCGwryvWuZmtxXm60EdYHLCg==
=jOXv
-----END PGP SIGNATURE-----

--Sig_/jhMm70LNM30K3D1riPCApi3--
