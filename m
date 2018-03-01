Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48576 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965697AbeCADzb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Feb 2018 22:55:31 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6DDF31F0B
        for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2018 21:54:32 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to ffe5df5
Message-ID: <bf0e0d9d-cec7-e8c5-460d-5fd37031db07@sandeen.net>
Date: Wed, 28 Feb 2018 21:55:26 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="S9vPaxexSRyWVF5Q3qzNe9odFUdqeW77Z"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S9vPaxexSRyWVF5Q3qzNe9odFUdqeW77Z
Content-Type: multipart/mixed; boundary="7wjZQYUJzBGV63Y4Mw4DppVn5cj3fgnZZ";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <bf0e0d9d-cec7-e8c5-460d-5fd37031db07@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to ffe5df5

--7wjZQYUJzBGV63Y4Mw4DppVn5cj3fgnZZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is just the libxfs-4.16-sync merge; I'll get to pending patches
next.  If you don't see what you hope for after the next update, ping
me or resend.

The new head of the for-next branch is commit:

ffe5df5 xfs: fix u32 type usage in sb validation function

New Commits:

Brian Foster (8):
      [12382cd] xfs: include inobt buffers in ifree tx log reservation
      [727b445] xfs: fix up agi unlinked list reservations
      [ec1b0fd] xfs: truncate transaction does not modify the inobt
      [2025cb0] xfs: include an allocfree res for inobt modifications
      [0b98035] xfs: refactor inode chunk alloc/free tx reservation
      [0197075] xfs: eliminate duplicate icreate tx reservation functions=

      [8504509] xfs: account finobt blocks properly in perag reservation
      [b09294b] xfs: cancel tx on xfs_defer_finish() error during xattr s=
et/remo

Carlos Maiolino (1):
      [37d086c] Split buffer's b_fspriv field

Colin Ian King (1):
      [dfcfc5f] xfs: fix check on struct_version for versions 4 or greate=
r

Darrick J. Wong (38):
      [ecdc52f] xfs: remove XFS_FSB_SANITY_CHECK
      [fb75464] xfs: refactor long-format btree header verification routi=
nes
      [bb2a125] xfs: refactor short form btree pointer verification
      [a7e32f0] xfs: remove XFS_WANT_CORRUPTED_RETURN from dir3 data veri=
fiers
      [7e6c95f] xfs: refactor xfs_verifier_error and xfs_buf_ioerror
      [bc01119] xfs: have buffer verifier functions report failing addres=
s
      [1e69795] xfs: refactor verifier callers to print address of failin=
g check
      [9870340] xfs: verify dinode header first
      [ad42e5a] xfs: move inode fork verifiers to xfs_dinode_verify
      [c7a710b] xfs: create structure verifier function for shortform xat=
trs
      [6db3a80] xfs: create structure verifier function for short form sy=
mlinks
      [1f98251] xfs: refactor short form directory structure verifier fun=
ction
      [20e882d] xfs: provide a centralized method for verifying inline fo=
rk data
      [e9998c6] xfs: fail out of xfs_attr3_leaf_lookup_int if it looks co=
rrupt
      [95d9582] xfs: create a new buf_ops pointer to verify structure met=
adata
      [055b84e] xfs: separate dquot repair into a separate function
      [71ffd55] xfs: standardize quota verification function outputs
      [079e8ef] xfs: trace log reservations at mount time
      [a2a5238] xfs: hoist xfs_fs_geometry to libxfs
      [fdef0e8] xfs: refactor the geometry structure filling function
      [493b46c] xfs: harden directory integrity checks some more
      [ef4109d] xfs: change 0x%p -> %p in print messages
      [d7e7160] xfs: use %px for data pointers when debugging
      [1fe41a7] xfs: add scrub cross-referencing helpers for the free spa=
ce btre
      [9deb7f6] xfs: add scrub cross-referencing helpers for the inode bt=
rees
      [556c739] xfs: add scrub cross-referencing helpers for the rmap btr=
ees
      [1048d0e] xfs: add scrub cross-referencing helpers for the refcount=
 btrees
      [221b1dd] xfs: cross-reference the realtime bitmap
      [b67317e] xfs: directory scrubber must walk through data block to o=
ffset
      [f596a90] xfs: attr leaf verifier needs to check for obviously bad =
count
      [e4b963e] xfs: btree format ifork loader should check for zero numr=
ecs
      [faaad1d] xfs: recheck reflink / dirty page status before freeing C=
oW rese
      [e91df84] xfs: check sb_agblocks and sb_agblklog when validating su=
perbloc
      [1d3bac1] xfs: refactor inode verifier corruption error printing
      [3cb6881] xfs: refactor accounting updates out of xfs_bmap_btalloc
      [d07cc72] xfs: treat CoW fork operations as delalloc for quota acco=
unting
      [c38464f] xfs: don't screw up direct writes when freesp is fragment=
ed
      [ffe5df5] xfs: fix u32 type usage in sb validation function

Jeff Layton (1):
      [d5105a8] xfs: convert to new i_version API

Shan Hai (1):
      [885ba5c] xfs: bmap code cleanup


Code Diffstat:

 include/xfs_inode.h         |   1 +
 libxfs/libxfs_io.h          |   3 +-
 libxfs/libxfs_priv.h        |  40 ++++++++-
 libxfs/logitem.c            |   8 +-
 libxfs/rdwr.c               |  37 +++++++-
 libxfs/trans.c              |  38 ++++----
 libxfs/util.c               |  43 +++++++--
 libxfs/xfs_alloc.c          | 124 ++++++++++++++++----------
 libxfs/xfs_alloc.h          |  10 +++
 libxfs/xfs_alloc_btree.c    |  47 ++++++----
 libxfs/xfs_attr.c           |   4 -
 libxfs/xfs_attr_leaf.c      | 148 +++++++++++++++++++++++++------
 libxfs/xfs_attr_leaf.h      |   1 +
 libxfs/xfs_attr_remote.c    | 104 ++++++++++++++--------
 libxfs/xfs_bmap.c           | 120 +++++++++++++++++--------
 libxfs/xfs_bmap_btree.c     |  58 +++++-------
 libxfs/xfs_btree.c          | 117 ++++++++++++++++++++-----
 libxfs/xfs_btree.h          |  16 ++--
 libxfs/xfs_da_btree.c       |  70 ++++++++++-----
 libxfs/xfs_da_format.h      |   6 ++
 libxfs/xfs_dir2.c           |   5 +-
 libxfs/xfs_dir2.h           |   2 +
 libxfs/xfs_dir2_block.c     |  39 +++++----
 libxfs/xfs_dir2_data.c      | 208 ++++++++++++++++++++++++++------------=
------
 libxfs/xfs_dir2_leaf.c      |  89 ++++++++++++-------
 libxfs/xfs_dir2_node.c      |  89 +++++++++++--------
 libxfs/xfs_dir2_priv.h      |  12 +--
 libxfs/xfs_dir2_sf.c        |  30 +++----
 libxfs/xfs_dquot_buf.c      | 174 ++++++++++++++++--------------------
 libxfs/xfs_fs.h             |   7 ++
 libxfs/xfs_ialloc.c         | 143 +++++++++++++++++++++++++-----
 libxfs/xfs_ialloc.h         |   6 ++
 libxfs/xfs_ialloc_btree.c   |  65 ++++++++++----
 libxfs/xfs_inode_buf.c      | 133 +++++++++++++++++++++-------
 libxfs/xfs_inode_buf.h      |   4 +-
 libxfs/xfs_inode_fork.c     | 152 ++++++++++----------------------
 libxfs/xfs_inode_fork.h     |  14 +++
 libxfs/xfs_log_rlimit.c     |   2 +-
 libxfs/xfs_quota_defs.h     |   9 +-
 libxfs/xfs_refcount.c       |  19 ++++
 libxfs/xfs_refcount.h       |   3 +
 libxfs/xfs_refcount_btree.c |  40 +++++----
 libxfs/xfs_rmap.c           |  67 ++++++++++++++
 libxfs/xfs_rmap.h           |   5 ++
 libxfs/xfs_rmap_btree.c     |  40 +++++----
 libxfs/xfs_rtbitmap.c       |  21 +++++
 libxfs/xfs_sb.c             | 113 ++++++++++++++++++++++--
 libxfs/xfs_sb.h             |   4 +
 libxfs/xfs_shared.h         |   4 +
 libxfs/xfs_symlink_remote.c |  75 ++++++++++++----
 libxfs/xfs_trans_resv.c     | 199 ++++++++++++++++++++------------------=
----
 repair/phase5.c             |   2 +-
 52 files changed, 1837 insertions(+), 933 deletions(-)


--7wjZQYUJzBGV63Y4Mw4DppVn5cj3fgnZZ--

--S9vPaxexSRyWVF5Q3qzNe9odFUdqeW77Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlqXebEACgkQIK4WkuE9
3uALYRAAxDjit8hrCQZcSEY0muiG75rnsm1Hw2WkMOvEfBCODhjMFN4fWJqv91g7
R4xyTrvkMKosnzT5UqPa4wlR03vaxPircO70B8Rx6j4rjwSE9CK4pgvV/R5WAfF8
TMOI4QowLhGRySmIdQDFBZmr7LoU8y5KyxcyGXnW2yx7Ak3xWBIj3u7NP1Y2hqJv
YyXScgX/kB8Yd6afCn/W3dIcdl1uWD+XhQ2JfgbCc00jumjUlWydSWiirMoUw8Ej
gQ7aiddQ0dVjcOPOEz79X6eSddy9YnGACoMX5fbyfTPJR023ShqQ4gaUvuDwRf2O
LRw1imGUvCz598KOBgXbKD0UuYEbaUCgdBgGtOCOZ9YYIHKxXwt073CwZj2h1kNY
V9ov/GNMG+pDVP8fn9wQi0EqncqiwIsJUot05JLuGgWAvMQWpwmYexUklJqHq22M
2hEP79pPhawHRdIULT33vL9Uo5VijJt87kJLs4/KSKh62yykiD0z6kEAnk79Q9rN
kv+vPGZSkvI2LagbO6Sf2/n05CNe/RyRaJUpg16T5NYLMdXGp4IiNtEoUPaGDmYY
p346eHkcgwbLXiAVlMKMcwWBvmGrk7FOmDe606D0jT5gmGKFfjs3S5a/+1nG+Zdm
yNegCpxwSN+HVDPNjDLFQ3vlFQJTfCVj3LGsK+GQtUr1+nNBYeY=
=LPw0
-----END PGP SIGNATURE-----

--S9vPaxexSRyWVF5Q3qzNe9odFUdqeW77Z--
