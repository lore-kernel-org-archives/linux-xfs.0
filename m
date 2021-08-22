Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B303CC432BE
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Aug 2021 01:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 963AC6128E
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Aug 2021 01:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhHVBSF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Aug 2021 21:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhHVBR7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 21 Aug 2021 21:17:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F4C161262
        for <linux-xfs@vger.kernel.org>; Sun, 22 Aug 2021 01:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629595039;
        bh=YhuGA63sb/3wYMbAB0EiN6EYDzoK3HKxI0bUjmtM0qs=;
        h=Date:From:To:Subject:From;
        b=NHBqzd4TCw0Htwfbp1qm4hvPG2d4k3kqF9wsdeG4xexl2ToSOBLt3QzXhwESjcnyi
         wrAtIoi0NaU0AiTY90UFZBflRsIgw/dHzhFadhQ6HmP0sFXaHRaUfNSPSF6gsi65EM
         TbEiKkX/wx443uJWkdrUtyqfycCF3wQhhW0ta5hsIGoiDIGcUm0qJD6atqw6vQjJcL
         tKAyvYHqvtBN9WRrVtrYUNlxYF+ynULvEzlI48s24TTm/K+d0Kjg5LxXmw7Mhn2N/K
         ytNoDRiJMB93T3Hj1Fk2WOD7vv+6ZWrWGKwRxeDSUFh7ga/hP3eWqw0WF6vF/Of9VH
         9bJDRqNwIPorA==
Date:   Sat, 21 Aug 2021 18:17:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 61e0d0cc51cd
Message-ID: <20210822011718.GX12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  This is it for 5.15, folks!

The new head of the for-next branch is commit:

61e0d0cc51cd xfs: fix perag structure refcounting error when scrub fails

New Commits:

Allison Henderson (2):
      [df0826312a23] xfs: add attr state machine tracepoints
      [5e68b4c7fb64] xfs: Rename __xfs_attr_rmtval_remove

Christoph Hellwig (5):
      [40b52225e58c] xfs: remove support for disabling quota accounting on a mounted file system
      [777eb1fa857e] xfs: remove xfs_dqrele_all_inodes
      [e497dfba6bd7] xfs: remove the flags argument to xfs_qm_dquot_walk
      [149e53afc851] xfs: remove the active vs running quota differentiation
      [a437b9b488e3] xfs: remove support for untagged lookups in xfs_icwalk*

Darrick J. Wong (50):
      [c6c2066db396] xfs: move xfs_inactive call to xfs_inode_mark_reclaimable
      [62af7d54a0ec] xfs: detach dquots from inode if we don't need to inactivate it
      [7d6f07d2c5ad] xfs: queue inactivation immediately when free space is tight
      [108523b8de67] xfs: queue inactivation immediately when quota is nearing enforcement
      [65f03d8652b2] xfs: queue inactivation immediately when free realtime extents are tight
      [2eb665027b65] xfs: inactivate inodes any time we try to free speculative preallocations
      [01e8f379a489] xfs: flush inode inactivation work when compiling usage statistics
      [6f6490914d9b] xfs: don't run speculative preallocation gc when fs is frozen
      [e8d04c2abceb] xfs: use background worker pool when transactions can't get free space
      [a6343e4d9278] xfs: avoid buffer deadlocks when walking fs inodes
      [40b1de007aca] xfs: throttle inode inactivation queuing on memory reclaim
      [b7df7630cccd] xfs: fix silly whitespace problems with kernel libxfs
      [f19ee6bb1a72] xfs: drop experimental warnings for bigtime and inobtcount
      [48c6615cc557] xfs: grab active perag ref when reading AG headers
      [43059d5416c9] xfs: dump log intent items that cannot be recovered due to corruption
      [908ce71e54f8] xfs: allow setting and clearing of log incompat feature flags
      [2b73a2c817be] xfs: clear log incompat feature bits when the log is idle
      [4bc619833f73] xfs: refactor xfs_iget calls from log intent recovery
      [c02f6529864a] xfs: make xfs_rtalloc_query_range input parameters const
      [9ab72f222774] xfs: fix off-by-one error when the last rt extent is in use
      [7e1826e05ba6] xfs: make fsmap backend function key parameters const
      [54406764c6a6] xfs: remove unnecessary agno variable from struct xchk_ag
      [7f89c838396e] xfs: add trace point for fs shutdown
      [d29d5577774d] xfs: make the key parameters to all btree key comparison functions const
      [04dcb47482a9] xfs: make the key parameters to all btree query range functions const
      [159eb69dba8b] xfs: make the record pointer passed to query_range functions const
      [23825cd14876] xfs: mark the record passed into btree init_key functions as const
      [8e38dc88a67b] xfs: make the keys and records passed to btree inorder functions const
      [22ece4e836be] xfs: mark the record passed into xchk_btree functions as const
      [b5a6e5fe0e68] xfs: make the pointer passed to btree set_root functions const
      [deb06b9ab6df] xfs: make the start pointer passed to btree alloc_block functions const
      [60e265f7f85a] xfs: make the start pointer passed to btree update_lastrec functions const
      [32816fd7920b] xfs: constify btree function parameters that are not modified
      [3fd7cb845bee] xfs: fix incorrect unit conversion in scrub tracepoint
      [af6265a008e5] xfs: standardize inode number formatting in ftrace output
      [9febf39dfe5a] xfs: standardize AG number formatting in ftrace output
      [f7b08163b7a9] xfs: standardize AG block number formatting in ftrace output
      [97f4f9153da5] xfs: standardize rmap owner number formatting in ftrace output
      [92eff38665ad] xfs: standardize daddr formatting in ftrace output
      [6f25b211d32b] xfs: disambiguate units for ftrace fields tagged "blkno", "block", or "bno"
      [49e68c91da5e] xfs: disambiguate units for ftrace fields tagged "offset"
      [7989accc6eb0] xfs: disambiguate units for ftrace fields tagged "len"
      [d538cf24c603] xfs: disambiguate units for ftrace fields tagged "count"
      [c23460ebd54c] xfs: rename i_disk_size fields in ftrace output
      [f93f85f77aa8] xfs: resolve fork names in trace output
      [7eac3029a2e5] xfs: standardize remaining xfs_buf length tracepoints
      [b641851cb8e4] xfs: standardize inode generation formatting in ftrace output
      [c03e4b9e6b64] xfs: decode scrub flags in ftrace output
      [e5f2e54a902d] xfs: start documenting common units and tags used in tracepoints
      [61e0d0cc51cd] xfs: fix perag structure refcounting error when scrub fails

Dave Chinner (43):
      [f1653c2e2831] xfs: introduce CPU hotplug infrastructure
      [0ed17f01c854] xfs: introduce all-mounts list for cpu hotplug notifications
      [ab23a7768739] xfs: per-cpu deferred inode inactivation queues
      [de2860f46362] mm: Add kvrealloc()
      [98fe2c3cef21] xfs: remove kmem_alloc_io()
      [d634525db63e] xfs: replace kmem_alloc_large() with kvmalloc()
      [2039a272300b] xfs: convert XLOG_FORCED_SHUTDOWN() to xlog_is_shutdown()
      [5112e2067bd9] xfs: XLOG_STATE_IOERROR must die
      [fd67d8a07208] xfs: move recovery needed state updates to xfs_log_mount_finish
      [e1d06e5f668a] xfs: convert log flags to an operational state field
      [b36d4651e165] xfs: make forced shutdown processing atomic
      [8bb92005b0e4] xfs: rework xlog_state_do_callback()
      [aad7272a9208] xfs: separate out log shutdown callback processing
      [502a01fac098] xfs: don't run shutdown callbacks on active iclogs
      [2562c322404d] xfs: log head and tail aren't reliable during shutdown
      [2ce82b722de9] xfs: move xlog_commit_record to xfs_log_cil.c
      [c45aba40cf5b] xfs: pass a CIL context to xlog_write()
      [bf034bc82780] xfs: factor out log write ordering from xlog_cil_push_work()
      [caa80090d17c] xfs: attach iclog callbacks in xlog_cil_set_ctx_write_state()
      [68a74dcae673] xfs: order CIL checkpoint start records
      [0020a190cf3e] xfs: AIL needs asynchronous CIL forcing
      [39823d0fac94] xfs: CIL work is serialised, not pipelined
      [33c0dd7898a1] xfs: move the CIL workqueue to the CIL
      [21b4ee7029c9] xfs: drop ->writepage completely
      [8cf07f3dd561] xfs: sb verifier doesn't handle uncached sb buffer
      [51b495eba84d] xfs: rename xfs_has_attr()
      [e23b55d537c9] xfs: rework attr2 feature and mount options
      [a1d86e8dec8c] xfs: reflect sb features in xfs_mount
      [38c26bfd90e1] xfs: replace xfs_sb_version checks with feature flag checks
      [8970a5b8a46c] xfs: consolidate mount option features in m_features
      [0560f31a09e5] xfs: convert mount flags to features
      [2e973b2cd4cd] xfs: convert remaining mount flags to state flags
      [75c8c50fa16a] xfs: replace XFS_FORCED_SHUTDOWN with xfs_is_shutdown
      [03288b19093b] xfs: convert xfs_fs_geometry to use mount feature checks
      [fe08cc504448] xfs: open code sb verifier feature checks
      [55fafb31f9e9] xfs: convert scrub to use mount-based feature checks
      [ebd9027d088b] xfs: convert xfs_sb_version_has checks to use mount features
      [2beb7b50ddd4] xfs: remove unused xfs_sb_version_has wrappers
      [d6837c1aab42] xfs: introduce xfs_sb_is_v5 helper
      [cf28e17c9186] xfs: kill xfs_sb_version_has_v3inode()
      [04fcad80cd06] xfs: introduce xfs_buf_daddr()
      [9343ee76909e] xfs: convert bp->b_bn references to xfs_buf_daddr()
      [4c7f65aea7b7] xfs: rename buffer cache index variable b_bn

Dwaipayan Ray (1):
      [edf27485eb56] xfs: cleanup __FUNCTION__ usage


Code Diffstat:

 fs/xfs/kmem.c                      |  64 ----
 fs/xfs/kmem.h                      |   2 -
 fs/xfs/libxfs/xfs_ag.c             |  25 +-
 fs/xfs/libxfs/xfs_alloc.c          |  56 +--
 fs/xfs/libxfs/xfs_alloc.h          |  12 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    | 100 ++---
 fs/xfs/libxfs/xfs_alloc_btree.h    |   2 +-
 fs/xfs/libxfs/xfs_attr.c           |  56 ++-
 fs/xfs/libxfs/xfs_attr.h           |   1 -
 fs/xfs/libxfs/xfs_attr_leaf.c      |  57 +--
 fs/xfs/libxfs/xfs_attr_remote.c    |  21 +-
 fs/xfs/libxfs/xfs_attr_remote.h    |   2 +-
 fs/xfs/libxfs/xfs_bmap.c           |  38 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |  56 +--
 fs/xfs/libxfs/xfs_bmap_btree.h     |   9 +-
 fs/xfs/libxfs/xfs_btree.c          | 141 +++----
 fs/xfs/libxfs/xfs_btree.h          |  56 +--
 fs/xfs/libxfs/xfs_btree_staging.c  |  14 +-
 fs/xfs/libxfs/xfs_da_btree.c       |  18 +-
 fs/xfs/libxfs/xfs_da_format.h      |   2 +-
 fs/xfs/libxfs/xfs_dir2.c           |   6 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |  14 +-
 fs/xfs/libxfs/xfs_dir2_data.c      |  20 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  14 +-
 fs/xfs/libxfs/xfs_dir2_node.c      |  20 +-
 fs/xfs/libxfs/xfs_dir2_priv.h      |   2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c        |  12 +-
 fs/xfs/libxfs/xfs_dquot_buf.c      |   8 +-
 fs/xfs/libxfs/xfs_format.h         | 226 ++---------
 fs/xfs/libxfs/xfs_ialloc.c         |  69 ++--
 fs/xfs/libxfs/xfs_ialloc.h         |   3 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  88 ++---
 fs/xfs/libxfs/xfs_ialloc_btree.h   |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |  22 +-
 fs/xfs/libxfs/xfs_inode_buf.h      |  11 +-
 fs/xfs/libxfs/xfs_log_format.h     |   6 +-
 fs/xfs/libxfs/xfs_log_recover.h    |   2 +
 fs/xfs/libxfs/xfs_log_rlimit.c     |   2 +-
 fs/xfs/libxfs/xfs_quota_defs.h     |  30 +-
 fs/xfs/libxfs/xfs_refcount.c       |  12 +-
 fs/xfs/libxfs/xfs_refcount.h       |   2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  54 +--
 fs/xfs/libxfs/xfs_rmap.c           |  34 +-
 fs/xfs/libxfs/xfs_rmap.h           |  11 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  72 ++--
 fs/xfs/libxfs/xfs_rmap_btree.h     |   2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c       |  14 +-
 fs/xfs/libxfs/xfs_sb.c             | 263 +++++++++----
 fs/xfs/libxfs/xfs_sb.h             |   4 +-
 fs/xfs/libxfs/xfs_symlink_remote.c |  14 +-
 fs/xfs/libxfs/xfs_trans_inode.c    |   2 +-
 fs/xfs/libxfs/xfs_trans_resv.c     |  48 +--
 fs/xfs/libxfs/xfs_trans_resv.h     |   2 -
 fs/xfs/libxfs/xfs_trans_space.h    |   6 +-
 fs/xfs/libxfs/xfs_types.c          |   2 +-
 fs/xfs/libxfs/xfs_types.h          |   5 +
 fs/xfs/scrub/agheader.c            |  47 ++-
 fs/xfs/scrub/agheader_repair.c     |  66 ++--
 fs/xfs/scrub/alloc.c               |   2 +-
 fs/xfs/scrub/attr.c                |  16 +-
 fs/xfs/scrub/attr.h                |   3 -
 fs/xfs/scrub/bitmap.c              |   4 +-
 fs/xfs/scrub/bmap.c                |  41 +-
 fs/xfs/scrub/btree.c               |   9 +-
 fs/xfs/scrub/btree.h               |   4 +-
 fs/xfs/scrub/common.c              |  77 ++--
 fs/xfs/scrub/common.h              |  18 +-
 fs/xfs/scrub/dabtree.c             |   4 +-
 fs/xfs/scrub/dir.c                 |  10 +-
 fs/xfs/scrub/fscounters.c          |   6 +-
 fs/xfs/scrub/ialloc.c              |   4 +-
 fs/xfs/scrub/inode.c               |  14 +-
 fs/xfs/scrub/quota.c               |   4 +-
 fs/xfs/scrub/refcount.c            |   4 +-
 fs/xfs/scrub/repair.c              |  32 +-
 fs/xfs/scrub/rmap.c                |   2 +-
 fs/xfs/scrub/rtbitmap.c            |   2 +-
 fs/xfs/scrub/scrub.c               |  23 +-
 fs/xfs/scrub/scrub.h               |   3 +-
 fs/xfs/scrub/trace.c               |   8 +-
 fs/xfs/scrub/trace.h               |  78 ++--
 fs/xfs/xfs_acl.c                   |   2 +-
 fs/xfs/xfs_aops.c                  |  25 +-
 fs/xfs/xfs_attr_inactive.c         |   6 +-
 fs/xfs/xfs_attr_list.c             |   2 +-
 fs/xfs/xfs_bmap_item.c             |  14 +-
 fs/xfs/xfs_bmap_util.c             |  20 +-
 fs/xfs/xfs_buf.c                   |  40 +-
 fs/xfs/xfs_buf.h                   |  25 +-
 fs/xfs/xfs_buf_item.c              |   6 +-
 fs/xfs/xfs_buf_item_recover.c      |  10 +-
 fs/xfs/xfs_dir2_readdir.c          |   4 +-
 fs/xfs/xfs_discard.c               |   2 +-
 fs/xfs/xfs_dquot.c                 |  13 +-
 fs/xfs/xfs_dquot.h                 |  10 +
 fs/xfs/xfs_dquot_item.c            | 134 -------
 fs/xfs/xfs_dquot_item.h            |  17 -
 fs/xfs/xfs_dquot_item_recover.c    |   4 +-
 fs/xfs/xfs_error.c                 |   4 +-
 fs/xfs/xfs_error.h                 |  12 +
 fs/xfs/xfs_export.c                |   4 +-
 fs/xfs/xfs_extfree_item.c          |   3 +
 fs/xfs/xfs_file.c                  |  18 +-
 fs/xfs/xfs_filestream.c            |   2 +-
 fs/xfs/xfs_filestream.h            |   2 +-
 fs/xfs/xfs_fsmap.c                 |  68 ++--
 fs/xfs/xfs_fsops.c                 |  63 ++--
 fs/xfs/xfs_health.c                |   2 +-
 fs/xfs/xfs_icache.c                | 751 ++++++++++++++++++++++++++++---------
 fs/xfs/xfs_icache.h                |  14 +-
 fs/xfs/xfs_icreate_item.c          |   4 +-
 fs/xfs/xfs_inode.c                 | 102 +++--
 fs/xfs/xfs_inode.h                 |  25 +-
 fs/xfs/xfs_inode_item.c            |   2 +-
 fs/xfs/xfs_inode_item_recover.c    |   2 +-
 fs/xfs/xfs_ioctl.c                 |  33 +-
 fs/xfs/xfs_ioctl32.c               |   4 +-
 fs/xfs/xfs_iomap.c                 |  16 +-
 fs/xfs/xfs_iops.c                  |  30 +-
 fs/xfs/xfs_itable.c                |  44 ++-
 fs/xfs/xfs_iwalk.c                 |  33 +-
 fs/xfs/xfs_log.c                   | 723 ++++++++++++++++++-----------------
 fs/xfs/xfs_log.h                   |   7 +-
 fs/xfs/xfs_log_cil.c               | 450 +++++++++++++++-------
 fs/xfs/xfs_log_priv.h              |  66 ++--
 fs/xfs/xfs_log_recover.c           | 161 ++++----
 fs/xfs/xfs_mount.c                 | 233 +++++++++---
 fs/xfs/xfs_mount.h                 | 248 ++++++++++--
 fs/xfs/xfs_pnfs.c                  |   2 +-
 fs/xfs/xfs_qm.c                    |  96 +++--
 fs/xfs/xfs_qm.h                    |   3 -
 fs/xfs/xfs_qm_bhv.c                |   2 +-
 fs/xfs/xfs_qm_syscalls.c           | 253 ++-----------
 fs/xfs/xfs_quota.h                 |   2 +
 fs/xfs/xfs_quotaops.c              |  30 +-
 fs/xfs/xfs_refcount_item.c         |   5 +-
 fs/xfs/xfs_reflink.c               |   4 +-
 fs/xfs/xfs_reflink.h               |   3 +-
 fs/xfs/xfs_rmap_item.c             |   5 +-
 fs/xfs/xfs_rtalloc.c               |   6 +-
 fs/xfs/xfs_rtalloc.h               |  13 +-
 fs/xfs/xfs_super.c                 | 538 +++++++++++++++-----------
 fs/xfs/xfs_symlink.c               |  13 +-
 fs/xfs/xfs_sysfs.c                 |   1 +
 fs/xfs/xfs_trace.c                 |   2 +
 fs/xfs/xfs_trace.h                 | 386 +++++++++++++------
 fs/xfs/xfs_trans.c                 |  33 +-
 fs/xfs/xfs_trans_ail.c             |  19 +-
 fs/xfs/xfs_trans_buf.c             |   8 +-
 fs/xfs/xfs_trans_dquot.c           |  51 +--
 include/linux/cpuhotplug.h         |   1 +
 include/linux/mm.h                 |   2 +
 mm/util.c                          |  15 +
 153 files changed, 4075 insertions(+), 3195 deletions(-)
