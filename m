Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47446 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751699AbeE3RWX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 13:22:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4UHLCAU092500
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 17:22:21 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2j9x4h8nes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 17:22:21 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4UHMKHn027649
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 17:22:20 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4UHMJfo018675
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 17:22:19 GMT
Date: Wed, 30 May 2018 10:22:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to d25522f10cfa
Message-ID: <20180530172217.GW12940@magnolia>
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
picked up in the next update.  I'm still reviewing Christoph's buffer
head semi-removal, fwiw.

The new head of the for-next branch is commit:

d25522f10cfa xfs: repair superblocks

New Commits:

Brian Foster (10):
      [4223f659dd3e] xfs: create agfl block free helper function
      [f8f2835a9cf3] xfs: defer agfl block frees when dfops is available
      [2bc5eba8b695] xfs: defer agfl block frees from deferred ops processing context
      [658f8f951173] xfs: defer agfl frees from inode inactivation
      [8b922f0e6a7f] xfs: defer frees from common inode allocation paths
      [8804630e1eeb] xfs: defer agfl frees from directory op transactions
      [fcb762f5de2e] xfs: add bmapi nodiscard flag
      [13b86fc33718] xfs: skip online discard during eofblocks trims
      [84ca484ecf2f] xfs: don't discard on free of unwritten extents
      [4e529339af15] xfs: factor out nodiscard helpers

Darrick J. Wong (49):
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
      [28b9060bd808] xfs: rename on-disk dquot counter zap functions
      [554ba965407e] xfs: refactor dquot iteration
      [eb41c93fef19] xfs: avoid ilock games in the quota scrubber
      [631fc955bdc8] xfs: clean up scrub usage of KM_NOFS
      [08a3a692ef58] xfs: btree scrub should check minrecs
      [9d9c90286a74] xfs: refactor scrub transaction allocation function
      [14861c47400b] xfs: add helpers to calculate btree size
      [7f8f1313d91a] xfs: expose various functions to repair code
      [4d4f86b49fd0] xfs: add repair helpers for the reverse mapping btree
      [08daa3ccf541] xfs: add repair helpers for the reference count btree
      [95eb308caa0f] xfs: add BMAPI_NORMAP flag to perform block remapping without updating rmapbt
      [d6b636ebb1c9] xfs: halt auto-reclamation activities while rebuilding rmap
      [67482129cdab] iomap: add a swapfile activation function
      [8389f3ffa22a] xfs: skip scrub xref if corruption already noted
      [689e11c84b15] xfs: superblock scrub should use short-lived buffers
      [eac69e167665] xfs: refactor quota limits initialization
      [8bc763c24de7] xfs: don't continue scrub if already corrupt
      [87d9d609c22d] xfs: quota scrub should use bmapbtd scrubber
      [517b32b7fa0e] xfs: scrub the data fork of the realtime inodes
      [ddd10c2fe20e] xfs: avoid ABBA deadlock when scrubbing parent pointers
      [9f3a080ef19b] xfs: hoist xfs_scrub_agfl_walk to libxfs as xfs_agfl_walk
      [7cf199ba5a70] xfs: make xfs_bmapi_remapi work with attribute forks
      [7644bd988d91] xfs: teach xfs_bmapi_remap to accept some bmapi flags
      [718fa74b153f] xfs: create tracepoints for online repair
      [84d42ea6b626] xfs: implement the metadata repair ioctl flag
      [aee9a4a555b3] fs: clear writeback errors in inode_init_always
      [2e050e648ad6] xfs: fix inobt magic number check
      [51863d7dd77d] xfs: grab the per-ag structure whenever relevant
      [0a9633fa2f9a] xfs: add helpers to deal with transaction allocation and rolling
      [73d6b42aa4dc] xfs: add helpers to allocate and initialize fresh btree roots
      [64a39d876e77] xfs: add helpers to collect and sift btree block pointers during repair
      [12c6510e2ff1] xfs: add helpers to dispose of old btree blocks after a repair
      [04a2b7b254f9] xfs: recover AG btree roots from rmap data
      [7e85bc6c8732] xfs: add helpers to attach quotas to inodes
      [d25522f10cfa] xfs: repair superblocks

Dave Chinner (30):
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
      [dae5cd811852] xfs: add mount delay debug option
      [c9fbd7bbc23d] xfs: clear sb->s_fs_info on mount failure
      [879de98ead51] xfs: one-shot cached buffers
      [cce77bcf48f5] xfs: factor out AG header initialisation from growfs core
      [9aebe805a58b] xfs: convert growfs AG header init to use buffer lists
      [0410c3bb2b88] xfs: factor ag btree root block initialisation
      [532ff647d830] xfs: turn ag header initialisation into a table driven operation
      [87444b8c267a] xfs: make imaxpct changes in growfs separate
      [83a7f86e39ff] xfs: separate secondary sb update in growfs
      [8125147288db] xfs: rework secondary superblock updates in growfs
      [b16817b66b6c] xfs: move growfs core to libxfs
      [49dd56f26ea7] xfs: factor the ag length extension code into libxfs

Eric Sandeen (8):
      [e443523d1910] xfs: trace ATTR flags in xattr tracepoints
      [e381a0f6c28a] xfs: remove unused flags arg from xfs_dquot_verify
      [57ab324553bb] xfs: check type in quota verifier during quotacheck
      [48fa1db87f73] xfs: pass full xfs_dqblk to repair during quotacheck
      [7224fa482a6d] xfs: add full xfs_dqblk verifier
      [72c5c5f6d01c] xfs: print specific dqblk that failed verifiers
      [62750d040bd1] fs: copy BTRFS_IOC_[SG]ET_FSLABEL to vfs
      [f7664b31975b] xfs: implement online get/set fs label

Omar Sandoval (2):
      [ec601924df0f] iomap: provide more useful errors for invalid swap files
      [19e129618d47] iomap: don't allow holes in swapfiles

Souptick Joarder (1):
      [05edd888d1b2] fs: xfs: Change return type to vm_fault_t


Code Diffstat:

 Documentation/ioctl/ioctl-number.txt |    3 +-
 fs/inode.c                           |    1 +
 fs/iomap.c                           |  235 +++++++-
 fs/xfs/Kconfig                       |   18 +
 fs/xfs/Makefile                      |    9 +
 fs/xfs/libxfs/xfs_ag.c               |  464 +++++++++++++++
 fs/xfs/libxfs/xfs_ag.h               |   30 +
 fs/xfs/libxfs/xfs_alloc.c            |  129 +++-
 fs/xfs/libxfs/xfs_alloc.h            |   23 +-
 fs/xfs/libxfs/xfs_alloc_btree.c      |    9 +
 fs/xfs/libxfs/xfs_alloc_btree.h      |    2 +
 fs/xfs/libxfs/xfs_attr.c             |    4 +-
 fs/xfs/libxfs/xfs_attr_remote.c      |    2 +-
 fs/xfs/libxfs/xfs_bmap.c             |   92 +--
 fs/xfs/libxfs/xfs_bmap.h             |   30 +-
 fs/xfs/libxfs/xfs_bmap_btree.c       |    9 +
 fs/xfs/libxfs/xfs_bmap_btree.h       |    3 +
 fs/xfs/libxfs/xfs_btree.c            |   25 +-
 fs/xfs/libxfs/xfs_btree.h            |    3 +-
 fs/xfs/libxfs/xfs_defer.c            |   24 +-
 fs/xfs/libxfs/xfs_defer.h            |    1 +
 fs/xfs/libxfs/xfs_dquot_buf.c        |   94 +--
 fs/xfs/libxfs/xfs_errortag.h         |    4 +-
 fs/xfs/libxfs/xfs_format.h           |    7 +-
 fs/xfs/libxfs/xfs_fs.h               |    9 +-
 fs/xfs/libxfs/xfs_ialloc.c           |    2 +-
 fs/xfs/libxfs/xfs_ialloc.h           |    3 +
 fs/xfs/libxfs/xfs_ialloc_btree.c     |   11 +-
 fs/xfs/libxfs/xfs_ialloc_btree.h     |    2 +
 fs/xfs/libxfs/xfs_quota_defs.h       |    9 +-
 fs/xfs/libxfs/xfs_refcount.c         |   21 +-
 fs/xfs/libxfs/xfs_refcount.h         |    7 +
 fs/xfs/libxfs/xfs_rmap.c             |   83 +++
 fs/xfs/libxfs/xfs_rmap.h             |    4 +
 fs/xfs/libxfs/xfs_sb.c               |  147 +++++
 fs/xfs/libxfs/xfs_sb.h               |   16 +
 fs/xfs/libxfs/xfs_shared.h           |   16 +-
 fs/xfs/scrub/agheader.c              |   85 +--
 fs/xfs/scrub/agheader_repair.c       |   70 +++
 fs/xfs/scrub/alloc.c                 |    4 +-
 fs/xfs/scrub/attr.c                  |    3 +-
 fs/xfs/scrub/bmap.c                  |    8 +-
 fs/xfs/scrub/btree.c                 |   42 +-
 fs/xfs/scrub/common.c                |  131 +++-
 fs/xfs/scrub/common.h                |   32 +-
 fs/xfs/scrub/dir.c                   |   35 +-
 fs/xfs/scrub/ialloc.c                |    7 +-
 fs/xfs/scrub/inode.c                 |   10 +-
 fs/xfs/scrub/parent.c                |   19 +-
 fs/xfs/scrub/quota.c                 |  181 +++---
 fs/xfs/scrub/refcount.c              |   10 +-
 fs/xfs/scrub/repair.c                | 1089 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h                |  132 +++++
 fs/xfs/scrub/rmap.c                  |    6 +-
 fs/xfs/scrub/rtbitmap.c              |   37 +-
 fs/xfs/scrub/scrub.c                 |  142 ++++-
 fs/xfs/scrub/scrub.h                 |    5 +
 fs/xfs/scrub/trace.h                 |  258 ++++++++
 fs/xfs/xfs_aops.c                    |   12 +
 fs/xfs/xfs_bmap_item.c               |    4 +-
 fs/xfs/xfs_bmap_util.c               |   10 +-
 fs/xfs/xfs_buf.c                     |  100 +++-
 fs/xfs/xfs_buf.h                     |   29 +-
 fs/xfs/xfs_buf_item.c                |   10 +-
 fs/xfs/xfs_dquot.c                   |  780 ++++++++++++++----------
 fs/xfs/xfs_dquot.h                   |   22 +-
 fs/xfs/xfs_dquot_item.c              |    7 +-
 fs/xfs/xfs_error.c                   |    3 +
 fs/xfs/xfs_extfree_item.c            |    6 +-
 fs/xfs/xfs_file.c                    |   55 +-
 fs/xfs/xfs_fsops.c                   |  587 ++++--------------
 fs/xfs/xfs_globals.c                 |    1 +
 fs/xfs/xfs_icache.c                  |   94 ++-
 fs/xfs/xfs_icache.h                  |    3 +
 fs/xfs/xfs_icreate_item.c            |    4 +-
 fs/xfs/xfs_inode.c                   |   47 +-
 fs/xfs/xfs_inode.h                   |   14 +-
 fs/xfs/xfs_inode_item.c              |    8 +-
 fs/xfs/xfs_ioctl.c                   |   86 +++
 fs/xfs/xfs_iomap.c                   |  186 +++---
 fs/xfs/xfs_iops.c                    |    2 +-
 fs/xfs/xfs_log.c                     |   12 +-
 fs/xfs/xfs_log_cil.c                 |   22 +-
 fs/xfs/xfs_log_recover.c             |    4 +-
 fs/xfs/xfs_mount.c                   |    4 +-
 fs/xfs/xfs_qm.c                      |  254 ++++----
 fs/xfs/xfs_qm.h                      |    6 +-
 fs/xfs/xfs_qm_bhv.c                  |    2 +-
 fs/xfs/xfs_qm_syscalls.c             |   97 ++-
 fs/xfs/xfs_quota.h                   |   22 +-
 fs/xfs/xfs_quotaops.c                |    8 +-
 fs/xfs/xfs_refcount_item.c           |    4 +-
 fs/xfs/xfs_reflink.c                 |   18 +-
 fs/xfs/xfs_rmap_item.c               |    4 +-
 fs/xfs/xfs_super.c                   |   49 +-
 fs/xfs/xfs_symlink.c                 |   10 +-
 fs/xfs/xfs_sysctl.h                  |    1 +
 fs/xfs/xfs_sysfs.c                   |   31 +
 fs/xfs/xfs_trace.h                   |   72 ++-
 fs/xfs/xfs_trans.c                   |   89 ++-
 fs/xfs/xfs_trans.h                   |   29 +-
 fs/xfs/xfs_trans_ail.c               |   50 +-
 fs/xfs/xfs_trans_bmap.c              |    4 +-
 fs/xfs/xfs_trans_buf.c               |   24 +-
 fs/xfs/xfs_trans_dquot.c             |    4 +-
 fs/xfs/xfs_trans_extfree.c           |   84 ++-
 fs/xfs/xfs_trans_inode.c             |    3 +-
 fs/xfs/xfs_trans_priv.h              |   11 +-
 fs/xfs/xfs_trans_refcount.c          |    4 +-
 fs/xfs/xfs_trans_rmap.c              |    4 +-
 include/linux/iomap.h                |   11 +
 include/uapi/linux/fs.h              |    8 +-
 112 files changed, 5151 insertions(+), 1721 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_ag.c
 create mode 100644 fs/xfs/libxfs/xfs_ag.h
 create mode 100644 fs/xfs/scrub/agheader_repair.c
 create mode 100644 fs/xfs/scrub/repair.c
 create mode 100644 fs/xfs/scrub/repair.h
