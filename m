Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46694 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753890AbdAKCfW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jan 2017 21:35:22 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C5D0661431E
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 20:34:37 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfs: for-next updated to 3fe4a6d
Message-ID: <9cacc38b-ed1a-2954-6d03-99e5570eea12@sandeen.net>
Date: Tue, 10 Jan 2017 20:35:12 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DmfVnwM3aSHH4erWQ8gN5bHcitLPklI8V"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DmfVnwM3aSHH4erWQ8gN5bHcitLPklI8V
Content-Type: multipart/mixed; boundary="XrWtSetAtLQ59tWA4x6B9nSdAAWJEMJUh";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <9cacc38b-ed1a-2954-6d03-99e5570eea12@sandeen.net>
Subject: [ANNOUNCE] xfs: for-next updated to 3fe4a6d

--XrWtSetAtLQ59tWA4x6B9nSdAAWJEMJUh
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is the libxfs syncup for 4.10, along with a few precursor
patches form Darrick to minimize libxfs-diff noise for stuff
that got missed or mismerged in prior syncs, along with the
libxfs-diff patch itself, and Darrick's stgit enhancements
to libxfs-apply.

Yes, you have other outstanding patches!  They are not in this
release!  It is /so/ disappointing!  That update is coming soon.  :)

Meanwhile, please check & test this update.  I've got it only
on for-next for now so that any brown-paper-bag bugs can be
obliterated with a rebase if needed; if things look good, I'll
push to master in a few days.

The new head of the for-next branch is commit:

3fe4a6d xfs: don't rely on ->total in xfs_alloc_space_available

New Commits:

Bhumika Goyal (1):
      [b6b8672] fs: xfs: libxfs: constify xfs_nameops structures

Brian Foster (2):
      [d4fa7e6] xfs: fix btree cursor error cleanups
      [f7b1a8b] xfs: track preallocation separately in xfs_bmapi_reserve_=
delalloc()

Christoph Hellwig (12):
      [41db92d] xfs: new inode extent list lookup helpers
      [b038536] xfs: cleanup xfs_bmap_last_before
      [c2d73ed] xfs: use new extent lookup helpers in xfs_bmapi_read
      [8241194] xfs: use new extent lookup helpers in xfs_bmapi_write
      [246eb90] xfs: use new extent lookup helpers in __xfs_bunmapi
      [d41d230] xfs: remove prev argument to xfs_bmapi_reserve_delalloc
      [9ee1fc5] xfs: remove xfs_bmap_search_extents
      [f5f0bea] xfs: remove NULLEXTNUM
      [8eeb15e] xfs: bump up reserved blocks in xfs_alloc_set_aside
      [a3b4a95] xfs: fix bogus minleft manipulations
      [2c003dc] xfs: adjust allocation length in xfs_alloc_space_availabl=
e
      [3fe4a6d] xfs: don't rely on ->total in xfs_alloc_space_available

Darrick J. Wong (22):
      [11b2abf] tools: create libxfs-diff to compare libxfses
      [1c193cc] libxfs-apply: port to stgit
      [3c73a9a] xfs_io: fix libxfs naming violation
      [3524467] libxfs: remove unnecessary hascrc test in btree verifiers=

      [4ca4eb8] libxfs: refactor btree crc verifier
      [eae096c] libxfs: fix whitespace to match the kernel
      [a29ab3d] libxfs: return bool from sb_version_hasmetauuid
      [bc19946] libxfs: remove useless stuff from the kernel
      [187f8c2] libxfs: fix line lengths
      [135c7b5] libxfs: synchronize dinode_verify with userspace
      [7b111d3] libxfs: clean up _dir2_data_freescan
      [6921638] xfs: check return value of _trans_reserve_quota_nblks
      [342ec63] xfs: check minimum block size for CRC filesystems
      [f0d92f0] xfs: factor rmap btree size into the indlen calculations
      [00795aa] xfs: forbid AG btrees with level =3D=3D 0
      [312eea2] xfs: check for bogus values in btree block headers
      [43a48f6] xfs: complain if we don't get nextents bmap records
      [5f48ab1] xfs: don't crash if reading a directory results in an une=
xpected hole
      [9656ed1] xfs: error out if trying to add attrs and anextents > 0
      [9d85eb4] xfs: don't allow di_size with high bit set
      [762989e] xfs: use GPF_NOFS when allocating btree cursors
      [f21c57e] xfs: use the actual AG length when reserving blocks

Dave Chinner (2):
      [5d8acc4] xfs: make xfs btree stats less huge
      [0bb9021] xfs: optimise CRC updates

Eric Sandeen (8):
      [cd9f2a5] xfs: set XFS_DA_OP_OKNOENT in xfs_attr_get
      [d09d4e5] xfs: provide helper for counting extents from if_bytes
      [ccade85] repair: use new extent lookup helpers in bmap_next_offset=

      [1b52147] xfs: Move AGI buffer type setting to xfs_read_agi
      [b12f5cb] xfs: pass state not whichfork to trace_xfs_extlist
      [8f690d2] xfs: handle cow fork in xfs_bmap_trace_exlist
      [601410b] xfs: several xattr functions can be void
      [a002f1d] xfs: ignore leaf attr ichdr.count in verifier during log =
replay


Code Diffstat:

 db/io.c                     |   2 +-
 fs/xfs/xfs_rmap_item.c      |   0
 fs/xfs/xfs_rmap_item.h      |   0
 libxfs/libxfs_api_defs.h    |   3 +-
 libxfs/libxfs_priv.h        |  18 +--
 libxfs/xfs_ag_resv.c        |   3 +
 libxfs/xfs_alloc.c          | 125 +++++------------
 libxfs/xfs_alloc.h          |   2 +-
 libxfs/xfs_alloc_btree.c    |  10 +-
 libxfs/xfs_attr.c           |   2 +
 libxfs/xfs_attr_leaf.c      |   8 +-
 libxfs/xfs_attr_leaf.h      |   2 +-
 libxfs/xfs_bmap.c           | 335 +++++++++++++++++---------------------=
------
 libxfs/xfs_bmap.h           |  16 +--
 libxfs/xfs_bmap_btree.c     |   6 +-
 libxfs/xfs_btree.c          |  24 +++-
 libxfs/xfs_btree.h          |  43 +-----
 libxfs/xfs_cksum.h          |  26 +++-
 libxfs/xfs_dir2.c           |   2 +-
 libxfs/xfs_dir2.h           |   4 +-
 libxfs/xfs_dir2_data.c      |  14 +-
 libxfs/xfs_dir2_node.c      |   2 +
 libxfs/xfs_format.h         |   3 +-
 libxfs/xfs_ialloc.c         |  18 ++-
 libxfs/xfs_ialloc_btree.c   |   6 +-
 libxfs/xfs_inode_buf.c      |  13 +-
 libxfs/xfs_inode_buf.h      |   2 -
 libxfs/xfs_inode_fork.c     |  78 +++++++++--
 libxfs/xfs_inode_fork.h     |   7 +
 libxfs/xfs_refcount_btree.c |  10 +-
 libxfs/xfs_refcount_btree.h |   3 +-
 libxfs/xfs_rmap_btree.c     |  15 +-
 libxfs/xfs_rmap_btree.h     |   3 +-
 libxfs/xfs_sb.c             |   6 +
 libxfs/xfs_types.h          |   1 -
 repair/dir2.c               |   4 +-
 repair/phase6.c             |  11 +-
 tools/libxfs-apply          |  29 +++-
 tools/libxfs-diff           |  25 ++++
 39 files changed, 454 insertions(+), 427 deletions(-)
 delete mode 100644 fs/xfs/xfs_rmap_item.c
 delete mode 100644 fs/xfs/xfs_rmap_item.h
 create mode 100755 tools/libxfs-diff



--XrWtSetAtLQ59tWA4x6B9nSdAAWJEMJUh--

--DmfVnwM3aSHH4erWQ8gN5bHcitLPklI8V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYdZnoAAoJECCuFpLhPd7gAkQP/j31BjwCpTr4FEfBbZ0LOmfA
AzMj8xN0yZQSNInq3T8hEUx5h2fFC1Jx9BYSLRR1RuouQ1ivavkgCkMJbEThurHH
dK+qzIeI6hD8muy2FQ3i6DmbdXcDAiRQ06xmZwe43zOGLD30iAb9PmwYKTbRN+82
WOFEh1SCnH02SSHKtdye0TMTNwzg7rLf+HvMLgchG617LpQkdUbO0ncY147nbnjl
lqDyqDAxwvz8YFpFSQz7K3Ph5kPVNgCgxafC6YuYvtefmwRbLkpJZ9JUtNhS2oVj
JCUgW5b+RO47YtlBggshdNiu8gAmGOTXL7VS9o4B4pg1JNP5P9LHKs52QaDSdRIs
bwF9wp2O6aGnHXEvfp/UWOlhCcK3qVMJcJbzJqz4KnUEDXFDT/cZR63R3UbmtCVI
pMnnjY3UkZZg619Yb1LHNNrwKLqPLyJyxB5sHU8IohYhOXcw9ucWd8f+vPKbupZ8
dNuY04Dq48bYOT3LpkhI/OhRvX4w4gOXSPF73JOuFs/UGLbKhpufdbUp0uDKAF7D
PRE4WNtlb8GTgQoNEkpSbeJm+gI7u0wAmECwO8ta2jaakWynavBDtwf4Be7bkIIU
Pa8NQ7StHWrteogoYWsshm2WTTQNYvueVi30/lqNj77k4ukKK9LD3Jp81irgB3RI
kqzFBox3LyfQ67mm4ucJ
=IVIg
-----END PGP SIGNATURE-----

--DmfVnwM3aSHH4erWQ8gN5bHcitLPklI8V--
