Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48056 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933391AbeF1UO5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 16:14:57 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3AB6B8D
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 15:14:42 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to a3204ee
Message-ID: <dc08544d-d65f-e9be-0f7f-5c6ec46c3e08@sandeen.net>
Date: Thu, 28 Jun 2018 15:14:54 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5hmr3CMek5LFTOT20u8YqxOo1I4k9SDoJ"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5hmr3CMek5LFTOT20u8YqxOo1I4k9SDoJ
Content-Type: multipart/mixed; boundary="9WYbPD7YdG3kgeAlsREVWyjSjE0NQfAtV";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <dc08544d-d65f-e9be-0f7f-5c6ec46c3e08@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to a3204ee

--9WYbPD7YdG3kgeAlsREVWyjSjE0NQfAtV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated; this is almost exclusively the libxfs-4.18
syncup, with a pre-fix from Darrick for repair.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

a3204ee xfs: update incore per-AG inode count

New Commits:

Brian Foster (6):
      [30c8be8] xfs: create agfl block free helper function
      [d5c1b46] xfs: defer agfl block frees when dfops is available
      [eb94763] xfs: defer agfl block frees from deferred ops processing =
context
      [3a13f95] xfs: add bmapi nodiscard flag
      [bd04ae3] xfs: don't discard on free of unwritten extents
      [cc5af22] xfs: factor out nodiscard helpers

Darrick J. Wong (34):
      [a65177d] xfs_repair: clear extent size hints when clearing inode c=
ore
      [4d5e288] xfs: bmap debugging should never panic the system
      [cfa7d89] xfs: add missing rmap error return
      [9e99501] xfs: refactor XFS_QMOPT_DQNEXT out of existence
      [43cf369] xfs: remove unnecessary xfs_qm_dqattach parameter
      [cd1a0fd] xfs: replace XFS_QMOPT_DQALLOC with a simple boolean
      [5f72838] xfs: add helpers to calculate btree size
      [aa46519] xfs: expose various functions to repair code
      [d264e39] xfs: add repair helpers for the reverse mapping btree
      [43e73fb] xfs: add repair helpers for the reference count btree
      [5f847f1] xfs: add BMAPI_NORMAP flag to perform block remapping wit=
hout up
      [17d741a] xfs: superblock scrub should use short-lived buffers
      [71a98c6] xfs: hoist xfs_scrub_agfl_walk to libxfs as xfs_agfl_walk=

      [26d6a48] xfs: make xfs_bmapi_remapi work with attribute forks
      [36cfb33] xfs: teach xfs_bmapi_remap to accept some bmapi flags
      [5281884] xfs: implement the metadata repair ioctl flag
      [3464dff] xfs: fix inobt magic number check
      [b153fb4] xfs: repair superblocks
      [a531149] xfs: xfs_rtword_t should be unsigned, not signed
      [5e28c9c] xfs: xfs_rtbuf_get should check the bmapi_read results
      [dc1e090] xfs: strengthen rtalloc query range checks
      [858ae33] xfs: fix xfs_rtalloc_rec units
      [1b49337] xfs: don't assert when reporting on-disk corruption while=
 loadin
      [b831204] xfs: remove redundant ASSERT on insufficient bestfree len=
gth in=20
      [3741f97] xfs: xfs_alloc_get_rec should return EFSCORRUPTED for obv=
ious bn
      [0e64ec0] xfs: btree lookup shouldn't ASSERT on empty btree nodes
      [55fdeb2] xfs: don't ASSERT on short form btree root pointer of zer=
o
      [52581d3] xfs: don't return garbage buffers in xfs_da3_node_read
      [280f5ad] xfs: check directory bestfree information in the verifier=

      [efa7ddd] xfs: introduce xfs_btree_debug_check_ptr
      [7ab54cd] xfs: strengthen btree pointer checks before use
      [7cf9f81] xfs: don't assert when on-disk btree pointers are garbage=

      [3177b91] xfs: explicitly pass buffer size to xfs_corruption_error
      [a3204ee] xfs: update incore per-AG inode count

Dave Chinner (16):
      [ce50fc0] xfs: make xfs_buf_incore out of line
      [f11d5ed] xfs: adder caller IP to xfs_defer* tracepoints
      [2fdd378] xfs: get rid of the log item descriptor
      [971ce25] xfs: move growfs core to libxfs
      [8a89542] xfs: factor the ag length extension code into libxfs
      [02afaae] xfs: fix error handling in xfs_refcount_insert()
      [2d65306] xfs: verify AGI unlinked list contains valid blocks
      [595add5] xfs: catch bad stripe alignment configurations
      [316d5a9] xfs: verify extent size hint is valid in inode verifier
      [77e17d5] xfs: verify COW extent size hint is valid in inode verifi=
er
      [32b30f1] xfs: push corruption -> ESTALE conversion to xfs_nfs_get_=
inode()
      [ec29198] xfs: validate btree records on retrieval
      [37b3b4d] xfs: convert to SPDX license tags
      [1727fd1] xfs: move various type verifiers to common file
      [d7ff12b] xfs: clean up MIN/MAX
      [5a59509] xfs: replace do_mod with native operations

Eric Sandeen (7):
      [160942b] xfs: remove unused flags arg from xfs_dquot_verify
      [c87d912] xfs: check type in quota verifier during quotacheck
      [e1d3178] xfs: pass full xfs_dqblk to repair during quotacheck
      [887223d] xfs: add full xfs_dqblk verifier
      [bf762eb] xfs: print specific dqblk that failed verifiers
      [691fdd7] xfs: implement online get/set fs label
      [b4b56fc] xfs: don't call xfs_da_shrink_inode with NULL bp


Code Diffstat:

 include/xfs_trace.h         |  14 +-
 include/xfs_trans.h         |   9 +-
 io/inject.c                 |   1 +
 libxfs/Makefile             |   4 +-
 libxfs/init.c               |   4 -
 libxfs/libxfs_api_defs.h    |   2 +-
 libxfs/libxfs_priv.h        |  57 +++++-
 libxfs/logitem.c            |  18 +-
 libxfs/trans.c              |  58 ++----
 libxfs/util.c               |  18 ++
 libxfs/xfs_ag.c             | 465 ++++++++++++++++++++++++++++++++++++++=
++++++
 libxfs/xfs_ag.h             |  30 +++
 libxfs/xfs_ag_resv.c        |  16 +-
 libxfs/xfs_ag_resv.h        |  16 +-
 libxfs/xfs_alloc.c          | 224 +++++++++++++--------
 libxfs/xfs_alloc.h          |  41 ++--
 libxfs/xfs_alloc_btree.c    |  24 +--
 libxfs/xfs_alloc_btree.h    |  16 +-
 libxfs/xfs_attr.c           |  18 +-
 libxfs/xfs_attr_leaf.c      |  21 +-
 libxfs/xfs_attr_leaf.h      |  14 +-
 libxfs/xfs_attr_remote.c    |  16 +-
 libxfs/xfs_attr_remote.h    |  14 +-
 libxfs/xfs_attr_sf.h        |  14 +-
 libxfs/xfs_bit.c            |  14 +-
 libxfs/xfs_bit.h            |  14 +-
 libxfs/xfs_bmap.c           | 146 ++++++++------
 libxfs/xfs_bmap.h           |  44 +++--
 libxfs/xfs_bmap_btree.c     |  23 +--
 libxfs/xfs_bmap_btree.h     |  17 +-
 libxfs/xfs_btree.c          | 196 +++++++++++--------
 libxfs/xfs_btree.h          |  17 +-
 libxfs/xfs_da_btree.c       |  24 +--
 libxfs/xfs_da_btree.h       |  14 +-
 libxfs/xfs_da_format.c      |  14 +-
 libxfs/xfs_da_format.h      |  14 +-
 libxfs/xfs_defer.c          |  40 ++--
 libxfs/xfs_defer.h          |  17 +-
 libxfs/xfs_dir2.c           |  14 +-
 libxfs/xfs_dir2.h           |  14 +-
 libxfs/xfs_dir2_block.c     |  22 +--
 libxfs/xfs_dir2_data.c      | 122 +++++++-----
 libxfs/xfs_dir2_leaf.c      |  26 +--
 libxfs/xfs_dir2_node.c      |  17 +-
 libxfs/xfs_dir2_priv.h      |  14 +-
 libxfs/xfs_dir2_sf.c        |  14 +-
 libxfs/xfs_dquot_buf.c      | 108 +++++-----
 libxfs/xfs_errortag.h       |  19 +-
 libxfs/xfs_format.h         |  21 +-
 libxfs/xfs_fs.h             |  23 +--
 libxfs/xfs_ialloc.c         | 162 ++++-----------
 libxfs/xfs_ialloc.h         |  24 +--
 libxfs/xfs_ialloc_btree.c   |  25 ++-
 libxfs/xfs_ialloc_btree.h   |  16 +-
 libxfs/xfs_iext_tree.c      |  10 +-
 libxfs/xfs_inode_buf.c      |  34 ++--
 libxfs/xfs_inode_buf.h      |  14 +-
 libxfs/xfs_inode_fork.c     |  14 +-
 libxfs/xfs_inode_fork.h     |  14 +-
 libxfs/xfs_log_format.h     |  14 +-
 libxfs/xfs_log_rlimit.c     |  14 +-
 libxfs/xfs_quota_defs.h     |  23 +--
 libxfs/xfs_refcount.c       |  87 ++++++---
 libxfs/xfs_refcount.h       |  23 +--
 libxfs/xfs_refcount_btree.c |  17 +-
 libxfs/xfs_refcount_btree.h |  16 +-
 libxfs/xfs_rmap.c           | 138 +++++++++++--
 libxfs/xfs_rmap.h           |  20 +-
 libxfs/xfs_rmap_btree.c     |  15 +-
 libxfs/xfs_rmap_btree.h     |  14 +-
 libxfs/xfs_rtbitmap.c       |  52 ++---
 libxfs/xfs_sb.c             | 181 +++++++++++++++--
 libxfs/xfs_sb.h             |  30 +--
 libxfs/xfs_shared.h         |  30 +--
 libxfs/xfs_symlink_remote.c |  14 +-
 libxfs/xfs_trans_resv.c     |  30 +--
 libxfs/xfs_trans_resv.h     |  14 +-
 libxfs/xfs_trans_space.h    |  14 +-
 libxfs/xfs_types.c          | 173 ++++++++++++++++
 libxfs/xfs_types.h          |  35 ++--
 repair/dinode.c             |  14 +-
 81 files changed, 1950 insertions(+), 1453 deletions(-)
 create mode 100644 libxfs/xfs_ag.c
 create mode 100644 libxfs/xfs_ag.h
 create mode 100644 libxfs/xfs_types.c


--9WYbPD7YdG3kgeAlsREVWyjSjE0NQfAtV--

--5hmr3CMek5LFTOT20u8YqxOo1I4k9SDoJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAls1QcAACgkQIK4WkuE9
3uDb8Q/9F9xBAr9kw8Zrn44zDjxgGC3rovzYkXXiSce4ulvBmTqArNarC9SvLaTk
uLvHZupJoyrq2sNrL154kQ+NXGexgj3bUXgoK/pDc6J4cXR8ocJXSnjfPyZitwz+
Zw5SBqmgeSpH+EjX87OQJEdPrY7yghfR+Lwp5Gt7mK3w6xsceuONTOITokoLnN7x
v2fCJAiX8LJXz9mj4OvitVIQ7f7qsceJHP0s9mq/JH4XuRQrbFGOeBlA8FL/MrmI
qs6BCANHdGXiTTpUOS3sZF6IECfVLUkvJp29u0b4Oh5yM5yyIIudh5+SqtpEmHbP
SbspnrX4+K9r2m5JW4RqVaPYdmJofwsiUrZ/i6AWs36WkGotbRRuTmGzy88qeTZr
ZU18aepaC+jqUMjU7kAQrZwn0OwzmG5lk1V/T4TVbj8it6pR31k9+fokvD6gAER+
sJm01dZ5YULRCya5dnI62MW7oR5hqQqh99ChjHJdK0TDXE1j57L2/BR8FrXKlU99
ifFjDF77QOhpsNrJj+hoJ7Qsm/rzT1r5/pvXzpzq7DZCM1NrXIHaj1a2t4otUUN0
eGwmWbxZoCbahOuG/9CFrNRdVwXmpLierjkJofSl5jFQiFzc94hzFumo80gUsJo4
xTLcbsRehyL8BGRtrN+WH0GRPgiccCiBncrmjcF02rkdebDFcWo=
=ldBv
-----END PGP SIGNATURE-----

--5hmr3CMek5LFTOT20u8YqxOo1I4k9SDoJ--
