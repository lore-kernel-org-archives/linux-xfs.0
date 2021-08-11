Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD700C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 16:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85FFC60551
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 16:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhHKQhX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 12:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229484AbhHKQhX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 12:37:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3234561019
        for <linux-xfs@vger.kernel.org>; Wed, 11 Aug 2021 16:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628699819;
        bh=63jqUcuQ4XhrSifPq9IqmhC3kuERj43pNEdvEPEbqeY=;
        h=Date:From:To:Subject:From;
        b=oQ2Mrt88/FpaxWSoByWuz9KyZaqXfhKtkxlkC8pqDW7nqRdlFyG31AdhxMlRK+dlb
         oAlr9fNNcs14BqQXNjPdiBW+5k5Am8Omu0y5UaYoCM9ZBxjCY/ODwp6V21a2tQF6tv
         UbCLTi04iaGA55ZKrzq/J/NfEtPqhAnC1Cyn4yw7g4HqA1BP7mwuYQv+8jUMAtwk2K
         VbmdmP6rfQFqK2GIdTFygO44lDlSR4ArjIXv+oHcZbdnCvCJrOngRZNUcHYuCdhJhK
         GDtNt7oaxeDCmYznPsAspeJ33Br6P136pRdRpFf+834Ast81CVWI3jnI8ljG2zKo/A
         +gtOsK0mHTrHg==
Date:   Wed, 11 Aug 2021 09:36:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next **REBASED** to edf27485eb56
Message-ID: <20210811163658.GE3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been rebased to fix a couple of missing SOB tags.  There have
not been any changes to the code itself.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  Dave's logging changes, flag handling changes, and
buffer cleanups are still out for review, and I will be sending some
bugfixes and cleanups of my own later this afternoon.

The new head of the for-next branch is commit:

edf27485eb56 xfs: cleanup __FUNCTION__ usage

New Commits:

Allison Henderson (2):
      [df0826312a23] xfs: add attr state machine tracepoints
      [5e68b4c7fb64] xfs: Rename __xfs_attr_rmtval_remove

Christoph Hellwig (4):
      [40b52225e58c] xfs: remove support for disabling quota accounting on a mounted file system
      [777eb1fa857e] xfs: remove xfs_dqrele_all_inodes
      [e497dfba6bd7] xfs: remove the flags argument to xfs_qm_dquot_walk
      [149e53afc851] xfs: remove the active vs running quota differentiation

Darrick J. Wong (18):
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

Dave Chinner (6):
      [f1653c2e2831] xfs: introduce CPU hotplug infrastructure
      [0ed17f01c854] xfs: introduce all-mounts list for cpu hotplug notifications
      [ab23a7768739] xfs: per-cpu deferred inode inactivation queues
      [de2860f46362] mm: Add kvrealloc()
      [98fe2c3cef21] xfs: remove kmem_alloc_io()
      [d634525db63e] xfs: replace kmem_alloc_large() with kvmalloc()

Dwaipayan Ray (1):
      [edf27485eb56] xfs: cleanup __FUNCTION__ usage


Code Diffstat:

 fs/xfs/kmem.c                   |  64 ----
 fs/xfs/kmem.h                   |   2 -
 fs/xfs/libxfs/xfs_attr.c        |  37 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   4 +-
 fs/xfs/libxfs/xfs_attr_remote.c |   3 +-
 fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
 fs/xfs/libxfs/xfs_format.h      |  17 +-
 fs/xfs/libxfs/xfs_ialloc.c      |   2 +-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/libxfs/xfs_quota_defs.h  |  30 +-
 fs/xfs/libxfs/xfs_rmap_btree.h  |   2 +-
 fs/xfs/libxfs/xfs_trans_resv.c  |  30 --
 fs/xfs/libxfs/xfs_trans_resv.h  |   2 -
 fs/xfs/scrub/agheader.c         |  23 +-
 fs/xfs/scrub/agheader_repair.c  |   3 -
 fs/xfs/scrub/attr.c             |  14 +-
 fs/xfs/scrub/attr.h             |   3 -
 fs/xfs/scrub/bmap.c             |   2 +-
 fs/xfs/scrub/btree.c            |   2 +-
 fs/xfs/scrub/common.c           |  58 ++--
 fs/xfs/scrub/common.h           |  18 +-
 fs/xfs/scrub/fscounters.c       |   2 +-
 fs/xfs/scrub/inode.c            |   2 +-
 fs/xfs/scrub/quota.c            |   2 +-
 fs/xfs/xfs_bmap_item.c          |  14 +-
 fs/xfs/xfs_buf.c                |   3 +-
 fs/xfs/xfs_buf.h                |   6 -
 fs/xfs/xfs_dquot.c              |   3 -
 fs/xfs/xfs_dquot.h              |  10 +
 fs/xfs/xfs_dquot_item.c         | 134 --------
 fs/xfs/xfs_dquot_item.h         |  17 -
 fs/xfs/xfs_extfree_item.c       |   3 +
 fs/xfs/xfs_icache.c             | 689 ++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_icache.h             |  14 +-
 fs/xfs/xfs_icreate_item.c       |   4 +-
 fs/xfs/xfs_inode.c              |  53 ++++
 fs/xfs/xfs_inode.h              |  22 +-
 fs/xfs/xfs_ioctl.c              |   2 +-
 fs/xfs/xfs_iops.c               |   4 +-
 fs/xfs/xfs_itable.c             |  42 ++-
 fs/xfs/xfs_iwalk.c              |  33 +-
 fs/xfs/xfs_log.c                |  68 +++-
 fs/xfs/xfs_log.h                |   3 +
 fs/xfs/xfs_log_cil.c            |  10 +-
 fs/xfs/xfs_log_priv.h           |   3 +
 fs/xfs/xfs_log_recover.c        |  57 +++-
 fs/xfs/xfs_mount.c              | 171 ++++++++--
 fs/xfs/xfs_mount.h              |  69 +++-
 fs/xfs/xfs_qm.c                 |  78 +++--
 fs/xfs/xfs_qm.h                 |   3 -
 fs/xfs/xfs_qm_syscalls.c        | 251 ++-------------
 fs/xfs/xfs_quota.h              |   2 +
 fs/xfs/xfs_quotaops.c           |  30 +-
 fs/xfs/xfs_refcount_item.c      |   3 +
 fs/xfs/xfs_rmap_item.c          |   3 +
 fs/xfs/xfs_super.c              | 315 ++++++++++++------
 fs/xfs/xfs_trace.h              | 115 ++++++-
 fs/xfs/xfs_trans.c              |   5 +-
 fs/xfs/xfs_trans_dquot.c        |  49 +--
 include/linux/cpuhotplug.h      |   1 +
 include/linux/mm.h              |   2 +
 mm/util.c                       |  15 +
 62 files changed, 1651 insertions(+), 981 deletions(-)
