Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6AFC433E6
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 03:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7932F64FB3
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 03:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhBEDhx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 22:37:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230527AbhBEDgu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Feb 2021 22:36:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D404B64FB3
        for <linux-xfs@vger.kernel.org>; Fri,  5 Feb 2021 03:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612496154;
        bh=2LwH+QbM8jsMpXtpy7VjNpDTppTZPePaApsmvhqyeaw=;
        h=Date:From:To:Subject:From;
        b=EoSXcAtpJK5i1TAlK9xr1N6BqAfap4pQLk0JYXxd4LMDJSV5rap4dlERjNUfmaCTz
         mU3NIF2FwpLmElwPtvi9V28EKK0PO+4HECJvmffjraAzTeqzXIT3oDc0qrAhetgF34
         iILnf5GHNrSAi6WG9jVlZDCqtqoIZU/96TR2zulvt3F1VKbUPRCRWJuAfBRnfxjKtB
         0iu0nzghjPwyIIYTH9zgK6OACKnQ25wPMXl0ZnjjavZyM/WvI41qTvNI8ywiImY0RC
         dwcYh4F1IkR5YrfjuB7csMvYvcILDBIiBri6WYrb+wocbtWbjfwVsTsQYu902Uxy16
         yQO6IN4vjEUFg==
Date:   Thu, 4 Feb 2021 19:35:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 45068063efb7
Message-ID: <20210205033553.GM7193@magnolia>
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
the next update.  Someone should also fire the maintainer, who mistyped
a git push command and sent the giant branch of changes to the wrong
branch name.

The new head of the for-next branch is commit:

45068063efb7 xfs: fix incorrect root dquot corruption error when switching group/project quota types

New Commits:

Brian Foster (12):
      [10fb9ac1251f] xfs: rename xfs_wait_buftarg() to xfs_buftarg_drain()
      [8321ddb2fa29] xfs: don't drain buffer lru on freeze and read-only remount
      [50d25484bebe] xfs: sync lazy sb accounting on quiesce of read-only mounts
      [37444fc4cc39] xfs: lift writable fs check up into log worker task
      [9e54ee0fc9ef] xfs: separate log cleaning from log quiesce
      [303591a0a947] xfs: cover the log during log quiesce
      [b0eb9e118266] xfs: don't reset log idle state on covering checkpoints
      [f46e5a174655] xfs: fold sbcount quiesce logging into log covering
      [5232b9315034] xfs: remove duplicate wq cancel and log force from attr quiesce
      [ea2064da4592] xfs: remove xfs_quiesce_attr()
      [5b0ad7c2a52d] xfs: cover the log on freeze instead of cleaning it
      [4533fc631547] xfs: fix unused log variable in xfs_log_cover()

Chandan Babu R (17):
      [b9b7e1dc56c5] xfs: Add helper for checking per-inode extent count overflow
      [727e1acd297c] xfs: Check for extent overflow when trivally adding a new extent
      [85ef08b5a667] xfs: Check for extent overflow when punching a hole
      [f5d927491914] xfs: Check for extent overflow when adding dir entries
      [0dbc5cb1a91c] xfs: Check for extent overflow when removing dir entries
      [02092a2f034f] xfs: Check for extent overflow when renaming dir entries
      [3a19bb147c72] xfs: Check for extent overflow when adding/removing xattrs
      [c442f3086d5a] xfs: Check for extent overflow when writing to unwritten extent
      [5f1d5bbfb2e6] xfs: Check for extent overflow when moving extent from cow to data fork
      [ee898d78c354] xfs: Check for extent overflow when remapping an extent
      [bcc561f21f11] xfs: Check for extent overflow when swapping extents
      [f9fa87169d2b] xfs: Introduce error injection to reduce maximum inode fork extent count
      [aff4db57d510] xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
      [0961fddfdd3f] xfs: Compute bmap extent alignments in a separate function
      [07c72e556299] xfs: Process allocated extent in a separate function
      [301519674699] xfs: Introduce error injection to allocate only minlen size extents for files
      [560ab6c0d12e] xfs: Fix 'set but not used' warning in xfs_bmap_compute_alignments()

Christoph Hellwig (3):
      [01ea173e103e] xfs: fix up non-directory creation in SGID directories
      [f22c7f877773] xfs: refactor xfs_file_fsync
      [ae29e4220fd3] xfs: reduce ilock acquisitions in xfs_file_fsync

Darrick J. Wong (43):
      [6da1b4b1ab36] xfs: fix an ABBA deadlock in xfs_rename
      [1aecf3734a95] xfs: fix chown leaking delalloc quota blocks when fssetxattr fails
      [b8055ed6779d] xfs: reduce quota reservation when doing a dax unwritten extent conversion
      [4abe21ad67a7] xfs: clean up quota reservation callsites
      [8554650003b8] xfs: create convenience wrappers for incore quota block reservations
      [35b1101099e8] xfs: remove xfs_trans_unreserve_quota_nblks completely
      [ad4a74739708] xfs: clean up icreate quota reservation calls
      [7ac6eb46c9f3] xfs: fix up build warnings when quotas are disabled
      [02b7ee4eb613] xfs: reserve data and rt quota at the same time
      [3a1af6c317d0] xfs: refactor common transaction/inode/quota allocation idiom
      [3de4eb106fcc] xfs: allow reservation of rtblocks with xfs_trans_alloc_inode
      [f273387b0485] xfs: refactor reflink functions to use xfs_trans_alloc_inode
      [f2f7b9ff62a2] xfs: refactor inode creation transaction/inode/quota allocation idiom
      [7317a03df703] xfs: refactor inode ownership change transaction/inode/quota allocation idiom
      [5c615f0feb9a] xfs: remove xfs_qm_vop_chown_reserve
      [fea7aae6cecf] xfs: rename code to error in xfs_ioctl_setattr
      [2a4bdfa8558c] xfs: shut down the filesystem if we screw up quota reservation
      [a636b1d1cf73] xfs: trigger all block gc scans when low on quota space
      [f41a0716f4b0] xfs: don't stall cowblocks scan if we can't take locks
      [9a537de3b009] xfs: xfs_inode_free_quota_blocks should scan project quota
      [3d4feec00673] xfs: move and rename xfs_inode_free_quota_blocks to avoid conflicts
      [111068f80eac] xfs: pass flags and return gc errors from xfs_blockgc_free_quota
      [4ca74205685e] xfs: try worst case space reservation upfront in xfs_reflink_remap_extent
      [766aabd59929] xfs: flush eof/cowblocks if we can't reserve quota for file blocks
      [c237dd7c7094] xfs: flush eof/cowblocks if we can't reserve quota for inode creation
      [758303d14499] xfs: flush eof/cowblocks if we can't reserve quota for chown
      [38899f809994] xfs: add a tracepoint for blockgc scans
      [85c5b27075ba] xfs: refactor xfs_icache_free_{eof,cow}blocks call sites
      [a1a7d05a0576] xfs: flush speculative space allocations when we run out of space
      [f83d436aef5d] xfs: increase the default parallelism levels of pwork clients
      [05a302a17062] xfs: set WQ_SYSFS on all workqueues in debug mode
      [f9296569837c] xfs: relocate the eofb/cowb workqueue functions
      [0461a320e33a] xfs: hide xfs_icache_free_eofblocks
      [b943c0cd5615] xfs: hide xfs_icache_free_cowblocks
      [865ac8e253c9] xfs: remove trivial eof/cowblocks functions
      [ce2d3bbe0647] xfs: consolidate incore inode radix tree posteof/cowblocks tags
      [9669f51de5c0] xfs: consolidate the eofblocks and cowblocks workers
      [419567534e16] xfs: only walk the incore inode tree once per blockgc scan
      [c9a6526fe7ae] xfs: rename block gc start and stop functions
      [894ecacf0f27] xfs: parallelize block preallocation garbage collection
      [47bd6d3457fb] xfs: expose the blockgc workqueue knobs publicly
      [0fa4a10a2f5f] xfs: don't bounce the iolock between free_{eof,cow}blocks
      [45068063efb7] xfs: fix incorrect root dquot corruption error when switching group/project quota types

Eric Biggers (1):
      [eaf92540a918] xfs: remove a stale comment from xfs_file_aio_write_checks()

Gao Xiang (2):
      [ce5e1062e253] xfs: rename `new' to `delta' in xfs_growfs_data_private()
      [07aabd9c4a88] xfs: get rid of xfs_growfs_{data,log}_t

Jeffrey Mitchell (1):
      [8aa921a95335] xfs: set inode size after creating symlink

Yumei Huang (1):
      [88a9e03beef2] xfs: Fix assert failure in xfs_setattr_size()

Zorro Lang (1):
      [bc41fa5321f9] libxfs: expose inobtcount in xfs geometry


Code Diffstat:

 Documentation/admin-guide/xfs.rst |  41 ++++
 fs/xfs/libxfs/xfs_alloc.c         |  50 +++++
 fs/xfs/libxfs/xfs_alloc.h         |   3 +
 fs/xfs/libxfs/xfs_attr.c          |  22 +-
 fs/xfs/libxfs/xfs_bmap.c          | 315 ++++++++++++++++++---------
 fs/xfs/libxfs/xfs_dir2.h          |   2 -
 fs/xfs/libxfs/xfs_dir2_sf.c       |   2 +-
 fs/xfs/libxfs/xfs_errortag.h      |   6 +-
 fs/xfs/libxfs/xfs_fs.h            |   1 +
 fs/xfs/libxfs/xfs_inode_fork.c    |  27 +++
 fs/xfs/libxfs/xfs_inode_fork.h    |  63 ++++++
 fs/xfs/libxfs/xfs_sb.c            |   2 +
 fs/xfs/scrub/common.c             |   4 +-
 fs/xfs/xfs_bmap_item.c            |  10 +
 fs/xfs/xfs_bmap_util.c            |  81 ++++---
 fs/xfs/xfs_buf.c                  |  30 ++-
 fs/xfs/xfs_buf.h                  |  11 +-
 fs/xfs/xfs_dquot.c                |  47 +++-
 fs/xfs/xfs_error.c                |   6 +
 fs/xfs/xfs_file.c                 | 114 +++++-----
 fs/xfs/xfs_fsops.c                |  32 +--
 fs/xfs/xfs_fsops.h                |   4 +-
 fs/xfs/xfs_globals.c              |   7 +-
 fs/xfs/xfs_icache.c               | 438 ++++++++++++++++++++------------------
 fs/xfs/xfs_icache.h               |  24 +--
 fs/xfs/xfs_inode.c                | 134 ++++++++----
 fs/xfs/xfs_ioctl.c                |  75 +++----
 fs/xfs/xfs_iomap.c                |  50 ++---
 fs/xfs/xfs_iops.c                 |  28 +--
 fs/xfs/xfs_iwalk.c                |   5 +-
 fs/xfs/xfs_linux.h                |   3 +-
 fs/xfs/xfs_log.c                  | 140 +++++++++---
 fs/xfs/xfs_log.h                  |   4 +-
 fs/xfs/xfs_mount.c                |  43 +---
 fs/xfs/xfs_mount.h                |  10 +-
 fs/xfs/xfs_mru_cache.c            |   2 +-
 fs/xfs/xfs_pwork.c                |  25 +--
 fs/xfs/xfs_pwork.h                |   4 +-
 fs/xfs/xfs_qm.c                   | 116 ++--------
 fs/xfs/xfs_quota.h                |  49 +++--
 fs/xfs/xfs_reflink.c              | 109 ++++++----
 fs/xfs/xfs_rtalloc.c              |   5 +
 fs/xfs/xfs_super.c                |  82 +++----
 fs/xfs/xfs_super.h                |   6 +
 fs/xfs/xfs_symlink.c              |  15 +-
 fs/xfs/xfs_sysctl.c               |  15 +-
 fs/xfs/xfs_sysctl.h               |   3 +-
 fs/xfs/xfs_trace.c                |   1 +
 fs/xfs/xfs_trace.h                |  50 ++++-
 fs/xfs/xfs_trans.c                | 195 +++++++++++++++++
 fs/xfs/xfs_trans.h                |  13 ++
 fs/xfs/xfs_trans_dquot.c          |  73 +++++--
 52 files changed, 1637 insertions(+), 960 deletions(-)
