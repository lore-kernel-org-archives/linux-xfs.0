Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B629C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 17:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CF3F6109E
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 17:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhHSRga (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 13:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhHSRg3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Aug 2021 13:36:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D788610A1
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 17:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629394553;
        bh=8NwaSFZ01odmbdsej92yDoxIW3xjs/hu5sBv5qQqmoI=;
        h=Date:From:To:Subject:From;
        b=DFeI62GSqksF3q11cSj0Tt0k6N83suZmHZiyCTHa1wGGsXxJ5NPXt3CUGnZrb2Fpl
         OHFMSddED6ADy6Y/Zb3WAioi7XCnlgqBk+MBGEN+k00+VcvN0fX+h25VewY3F/48yV
         OAsiws1dTpRZp4cjV2Ua1oKfCBD35LcrZSptd18guSC45DwDoU94N5PzMalNbNGDiX
         ORdYgUJfGB95CVVQISQMEuUk0H6x22KfR9HPLuC/hR6nHI/gE6c5jWnEpKo9MeRgBq
         1ZBpoLOTh7ZUA0PgAIwhMoPDNyBLkob8DSJP8/28Q8WYQPwa0GLDGJ0p0Cdn9Z9g+w
         b1cPqw067t8ig==
Date:   Thu, 19 Aug 2021 10:35:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to a437b9b488e3
Message-ID: <20210819173552.GV12640@magnolia>
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
the next update.

This isn't the final branch push for 5.15 (the tracepoint and opstate
cleanups are still in review) but I wanted to get the last of Dave's
logging fixes and performance improvements out for testing in for-next
this week.

The new head of the for-next branch is commit:

a437b9b488e3 xfs: remove support for untagged lookups in xfs_icwalk*

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

Darrick J. Wong (33):
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

Dave Chinner (24):
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

Dwaipayan Ray (1):
      [edf27485eb56] xfs: cleanup __FUNCTION__ usage


Code Diffstat:

 fs/xfs/kmem.c                      |  64 ----
 fs/xfs/kmem.h                      |   2 -
 fs/xfs/libxfs/xfs_alloc.c          |   6 +-
 fs/xfs/libxfs/xfs_alloc.h          |  10 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |  94 ++---
 fs/xfs/libxfs/xfs_attr.c           |  37 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |   4 +-
 fs/xfs/libxfs/xfs_attr_remote.c    |   3 +-
 fs/xfs/libxfs/xfs_attr_remote.h    |   2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |  48 +--
 fs/xfs/libxfs/xfs_bmap_btree.h     |   7 +-
 fs/xfs/libxfs/xfs_btree.c          |  84 ++---
 fs/xfs/libxfs/xfs_btree.h          |  56 +--
 fs/xfs/libxfs/xfs_btree_staging.c  |  14 +-
 fs/xfs/libxfs/xfs_format.h         |  17 +-
 fs/xfs/libxfs/xfs_ialloc.c         |   6 +-
 fs/xfs/libxfs/xfs_ialloc.h         |   3 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  70 ++--
 fs/xfs/libxfs/xfs_log_recover.h    |   2 +
 fs/xfs/libxfs/xfs_quota_defs.h     |  30 +-
 fs/xfs/libxfs/xfs_refcount.c       |   4 +-
 fs/xfs/libxfs/xfs_refcount.h       |   2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  48 +--
 fs/xfs/libxfs/xfs_rmap.c           |  28 +-
 fs/xfs/libxfs/xfs_rmap.h           |  11 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  64 ++--
 fs/xfs/libxfs/xfs_rmap_btree.h     |   2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c       |  14 +-
 fs/xfs/libxfs/xfs_trans_resv.c     |  30 --
 fs/xfs/libxfs/xfs_trans_resv.h     |   2 -
 fs/xfs/scrub/agheader.c            |  27 +-
 fs/xfs/scrub/agheader_repair.c     |  41 ++-
 fs/xfs/scrub/alloc.c               |   2 +-
 fs/xfs/scrub/attr.c                |  14 +-
 fs/xfs/scrub/attr.h                |   3 -
 fs/xfs/scrub/bmap.c                |  31 +-
 fs/xfs/scrub/btree.c               |   2 +-
 fs/xfs/scrub/btree.h               |   4 +-
 fs/xfs/scrub/common.c              |  61 ++-
 fs/xfs/scrub/common.h              |  18 +-
 fs/xfs/scrub/fscounters.c          |   2 +-
 fs/xfs/scrub/ialloc.c              |   2 +-
 fs/xfs/scrub/inode.c               |   2 +-
 fs/xfs/scrub/quota.c               |   2 +-
 fs/xfs/scrub/refcount.c            |   4 +-
 fs/xfs/scrub/repair.c              |  20 +-
 fs/xfs/scrub/rmap.c                |   2 +-
 fs/xfs/scrub/rtbitmap.c            |   2 +-
 fs/xfs/scrub/scrub.c               |   3 -
 fs/xfs/scrub/scrub.h               |   1 -
 fs/xfs/xfs_aops.c                  |  17 -
 fs/xfs/xfs_bmap_item.c             |  14 +-
 fs/xfs/xfs_buf.c                   |   3 +-
 fs/xfs/xfs_buf.h                   |   6 -
 fs/xfs/xfs_dquot.c                 |   3 -
 fs/xfs/xfs_dquot.h                 |  10 +
 fs/xfs/xfs_dquot_item.c            | 134 -------
 fs/xfs/xfs_dquot_item.h            |  17 -
 fs/xfs/xfs_error.h                 |  12 +
 fs/xfs/xfs_extfree_item.c          |   3 +
 fs/xfs/xfs_fsmap.c                 |  64 ++--
 fs/xfs/xfs_fsops.c                 |  66 ++--
 fs/xfs/xfs_icache.c                | 736 ++++++++++++++++++++++++++++---------
 fs/xfs/xfs_icache.h                |  14 +-
 fs/xfs/xfs_icreate_item.c          |   4 +-
 fs/xfs/xfs_inode.c                 |  53 +++
 fs/xfs/xfs_inode.h                 |  22 +-
 fs/xfs/xfs_ioctl.c                 |   2 +-
 fs/xfs/xfs_iops.c                  |   4 +-
 fs/xfs/xfs_itable.c                |  42 ++-
 fs/xfs/xfs_iwalk.c                 |  33 +-
 fs/xfs/xfs_log.c                   | 666 +++++++++++++++++----------------
 fs/xfs/xfs_log.h                   |   7 +-
 fs/xfs/xfs_log_cil.c               | 446 +++++++++++++++-------
 fs/xfs/xfs_log_priv.h              |  66 ++--
 fs/xfs/xfs_log_recover.c           | 142 ++++---
 fs/xfs/xfs_mount.c                 | 171 ++++++++-
 fs/xfs/xfs_mount.h                 |  76 +++-
 fs/xfs/xfs_qm.c                    |  78 ++--
 fs/xfs/xfs_qm.h                    |   3 -
 fs/xfs/xfs_qm_syscalls.c           | 251 ++-----------
 fs/xfs/xfs_quota.h                 |   2 +
 fs/xfs/xfs_quotaops.c              |  30 +-
 fs/xfs/xfs_refcount_item.c         |   3 +
 fs/xfs/xfs_rmap_item.c             |   3 +
 fs/xfs/xfs_rtalloc.h               |  13 +-
 fs/xfs/xfs_super.c                 | 328 +++++++++++------
 fs/xfs/xfs_sysfs.c                 |   1 +
 fs/xfs/xfs_trace.c                 |   2 +
 fs/xfs/xfs_trace.h                 | 147 +++++++-
 fs/xfs/xfs_trans.c                 |   9 +-
 fs/xfs/xfs_trans_ail.c             |  11 +-
 fs/xfs/xfs_trans_dquot.c           |  49 +--
 include/linux/cpuhotplug.h         |   1 +
 include/linux/mm.h                 |   2 +
 mm/util.c                          |  15 +
 96 files changed, 2807 insertions(+), 1981 deletions(-)
