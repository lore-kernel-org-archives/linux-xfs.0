Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52284 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935410AbeEJQ31 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 12:29:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4AGQe2E087138
        for <linux-xfs@vger.kernel.org>; Thu, 10 May 2018 16:29:26 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2hvs88r3q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 May 2018 16:29:26 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4AGTPSG007212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 May 2018 16:29:25 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4AGTPOX014089
        for <linux-xfs@vger.kernel.org>; Thu, 10 May 2018 16:29:25 GMT
Date: Thu, 10 May 2018 09:29:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 9d93388b0afe
Message-ID: <20180510162923.GC11261@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.  This isn't the final branch for 4.18,
it's merely an interim progress update.

The new head of the for-next branch is commit:

9d93388b0afe iomap: add a swapfile activation function

New Commits:

Brian Foster (9):
      [4223f659dd3e] xfs: create agfl block free helper function
      [f8f2835a9cf3] xfs: defer agfl block frees when dfops is available
      [2bc5eba8b695] xfs: defer agfl block frees from deferred ops processing context
      [658f8f951173] xfs: defer agfl frees from inode inactivation
      [8b922f0e6a7f] xfs: defer frees from common inode allocation paths
      [8804630e1eeb] xfs: defer agfl frees from directory op transactions
      [fcb762f5de2e] xfs: add bmapi nodiscard flag
      [13b86fc33718] xfs: skip online discard during eofblocks trims
      [84ca484ecf2f] xfs: don't discard on free of unwritten extents

Darrick J. Wong (27):
      [cec572561a74] xfs: bmap debugging should never panic the system
      [52101dfe56f7] xfs: add missing rmap error return
      [7b6b50f55c10] xfs: release new dquot buffer on defer_finish error
      [609001bca499] xfs: don't spray logs when dquot flush/purge fail
      [2e330e76e03d] xfs: refactor XFS_QMOPT_DQNEXT out of existence
      [cc2047c4d036] xfs: refactor dquot cache handling
      [d7103eeb0051] xfs: delegate dqget input checks to helper function
      [c14cfccabe2a] xfs: remove unnecessary xfs_qm_dqattach parameter
      [4882c19d2a77] xfs: split out dqget for inodes from regular dqget
      [0fcef1270f30] xfs: fetch dquots directly during quotacheck
      [617cd5c12c3c] xfs: refactor incore dquot initialization functions
      [d63192c89047] xfs: refactor xfs_qm_dqtobp and xfs_qm_dqalloc
      [114e73ccfa2a] xfs: remove direct calls to _qm_dqread
      [30ab2dcf2c06] xfs: replace XFS_QMOPT_DQALLOC with a simple boolean
      [0792c4350060] xfs: rename on-disk dquot counter zap functions
      [7da848e34f42] xfs: refactor dquot iteration
      [15086b747f68] xfs: avoid ilock games in the quota scrubber
      [73328d8ecc10] xfs: clean up scrub usage of KM_NOFS
      [64c2932c29cd] xfs: btree scrub should check minrecs
      [c2f8a0e7f251] xfs: refactor scrub transaction allocation function
      [9782b12f0ba6] xfs: add helpers to calculate btree size
      [c043b686af0f] xfs: expose various functions to repair code
      [b6d5e023a415] xfs: add repair helpers for the reverse mapping btree
      [48bf76d9f7f5] xfs: add repair helpers for the reference count btree
      [4addb5f26604] xfs: add BMAPI_NORMAP flag to perform block remapping without updating rmapbt
      [b2c405070801] xfs: halt auto-reclamation activities while rebuilding rmap
      [9d93388b0afe] iomap: add a swapfile activation function

Dave Chinner (18):
      [afca6c5b2595] xfs: validate cached inodes are free when allocated
      [8b26984dbd81] xfs: validate allocated inode number
      [8925a3dc4771] xfs: make xfs_buf_incore out of line
      [b027d4c97b96] xfs: don't retry xfs_buf_find on XBF_TRYLOCK failure
      [ed5c3e66a328] xfs: move generic_write_sync calls inwards
      [4f8ff44ba0ad] iomap: iomap_dio_rw() handles all sync writes
      [3460cac1ca76] iomap: Use FUA for pure data O_DSYNC DIO writes
      [d0641780940a] xfs: simplify xfs_file_iomap_begin() logic
      [dfa03a5f8076] xfs: clean up locking in xfs_file_iomap_begin
      [22525c17ed13] xfs: log item flags are racy
      [ba18781b9156] xfs: add tracing to high level transaction operations
      [e632a5690c73] xfs: adder caller IP to xfs_defer* tracepoints
      [d686d12d23ae] xfs: don't assert fail with AIL lock held
      [3565b660e56a] xfs: fix double ijoin in xfs_inactive_symlink_rmt()
      [c5295c6aad53] xfs: fix double ijoin in xfs_reflink_cancel_cow_range
      [844e5e74c1a8] xfs: fix double ijoin in xfs_reflink_clear_inode_flag()
      [1a2ebf835a3c] xfs: add some more debug checks to buffer log item reuse
      [e6631f85546c] xfs: get rid of the log item descriptor

Eric Sandeen (6):
      [e443523d1910] xfs: trace ATTR flags in xattr tracepoints
      [e381a0f6c28a] xfs: remove unused flags arg from xfs_dquot_verify
      [57ab324553bb] xfs: check type in quota verifier during quotacheck
      [48fa1db87f73] xfs: pass full xfs_dqblk to repair during quotacheck
      [7224fa482a6d] xfs: add full xfs_dqblk verifier
      [72c5c5f6d01c] xfs: print specific dqblk that failed verifiers


Code Diffstat:

 fs/iomap.c                       | 232 +++++++++++-
 fs/xfs/libxfs/xfs_alloc.c        |  92 ++++-
 fs/xfs/libxfs/xfs_alloc.h        |  29 +-
 fs/xfs/libxfs/xfs_alloc_btree.c  |   9 +
 fs/xfs/libxfs/xfs_alloc_btree.h  |   2 +
 fs/xfs/libxfs/xfs_attr.c         |   4 +-
 fs/xfs/libxfs/xfs_attr_remote.c  |   2 +-
 fs/xfs/libxfs/xfs_bmap.c         |  61 +--
 fs/xfs/libxfs/xfs_bmap.h         |  37 +-
 fs/xfs/libxfs/xfs_bmap_btree.c   |   9 +
 fs/xfs/libxfs/xfs_bmap_btree.h   |   3 +
 fs/xfs/libxfs/xfs_btree.c        |  25 +-
 fs/xfs/libxfs/xfs_btree.h        |   3 +-
 fs/xfs/libxfs/xfs_defer.c        |  24 +-
 fs/xfs/libxfs/xfs_defer.h        |   1 +
 fs/xfs/libxfs/xfs_dquot_buf.c    |  94 +++--
 fs/xfs/libxfs/xfs_ialloc.c       |   2 +-
 fs/xfs/libxfs/xfs_ialloc.h       |   3 +
 fs/xfs/libxfs/xfs_ialloc_btree.c |   9 +
 fs/xfs/libxfs/xfs_ialloc_btree.h |   2 +
 fs/xfs/libxfs/xfs_quota_defs.h   |   9 +-
 fs/xfs/libxfs/xfs_refcount.c     |  21 +-
 fs/xfs/libxfs/xfs_refcount.h     |   7 +
 fs/xfs/libxfs/xfs_rmap.c         |  83 +++++
 fs/xfs/libxfs/xfs_rmap.h         |   4 +
 fs/xfs/libxfs/xfs_shared.h       |  15 -
 fs/xfs/scrub/agheader.c          |   3 +-
 fs/xfs/scrub/bmap.c              |   3 +-
 fs/xfs/scrub/btree.c             |  42 ++-
 fs/xfs/scrub/common.c            |  16 +-
 fs/xfs/scrub/common.h            |  14 +-
 fs/xfs/scrub/inode.c             |   5 +-
 fs/xfs/scrub/quota.c             | 110 +++---
 fs/xfs/scrub/refcount.c          |   2 +-
 fs/xfs/scrub/scrub.c             |   4 +
 fs/xfs/scrub/scrub.h             |   1 +
 fs/xfs/xfs_aops.c                |  12 +
 fs/xfs/xfs_bmap_item.c           |   4 +-
 fs/xfs/xfs_bmap_util.c           |  10 +-
 fs/xfs/xfs_buf.c                 | 100 +++--
 fs/xfs/xfs_buf.h                 |  17 +-
 fs/xfs/xfs_buf_item.c            |  10 +-
 fs/xfs/xfs_dquot.c               | 780 ++++++++++++++++++++++++---------------
 fs/xfs/xfs_dquot.h               |  22 +-
 fs/xfs/xfs_dquot_item.c          |   7 +-
 fs/xfs/xfs_extfree_item.c        |   6 +-
 fs/xfs/xfs_file.c                |  43 ++-
 fs/xfs/xfs_icache.c              |  94 +++--
 fs/xfs/xfs_icache.h              |   3 +
 fs/xfs/xfs_icreate_item.c        |   4 +-
 fs/xfs/xfs_inode.c               |  50 ++-
 fs/xfs/xfs_inode.h               |  24 +-
 fs/xfs/xfs_inode_item.c          |   8 +-
 fs/xfs/xfs_iomap.c               | 186 ++++++----
 fs/xfs/xfs_iops.c                |   2 +-
 fs/xfs/xfs_log.c                 |  12 +-
 fs/xfs/xfs_log_cil.c             |  22 +-
 fs/xfs/xfs_log_recover.c         |   4 +-
 fs/xfs/xfs_mount.c               |   4 +-
 fs/xfs/xfs_qm.c                  | 132 +++----
 fs/xfs/xfs_qm.h                  |   6 +-
 fs/xfs/xfs_qm_bhv.c              |   2 +-
 fs/xfs/xfs_qm_syscalls.c         |  97 +++--
 fs/xfs/xfs_quota.h               |   6 +-
 fs/xfs/xfs_quotaops.c            |   8 +-
 fs/xfs/xfs_refcount_item.c       |   4 +-
 fs/xfs/xfs_reflink.c             |  18 +-
 fs/xfs/xfs_rmap_item.c           |   4 +-
 fs/xfs/xfs_super.c               |  28 +-
 fs/xfs/xfs_symlink.c             |  10 +-
 fs/xfs/xfs_trace.h               |  72 +++-
 fs/xfs/xfs_trans.c               |  89 +++--
 fs/xfs/xfs_trans.h               |  29 +-
 fs/xfs/xfs_trans_ail.c           |  50 ++-
 fs/xfs/xfs_trans_bmap.c          |   4 +-
 fs/xfs/xfs_trans_buf.c           |  24 +-
 fs/xfs/xfs_trans_dquot.c         |   4 +-
 fs/xfs/xfs_trans_extfree.c       |  87 ++++-
 fs/xfs/xfs_trans_inode.c         |   3 +-
 fs/xfs/xfs_trans_priv.h          |  11 +-
 fs/xfs/xfs_trans_refcount.c      |   4 +-
 fs/xfs/xfs_trans_rmap.c          |   4 +-
 include/linux/iomap.h            |  11 +
 83 files changed, 2103 insertions(+), 1010 deletions(-)
