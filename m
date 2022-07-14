Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AB5C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jul 2022 17:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiGNROY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jul 2022 13:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240090AbiGNROX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jul 2022 13:14:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C606101FF
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jul 2022 10:14:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89129620C9
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jul 2022 17:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0F5C34114
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jul 2022 17:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657818860;
        bh=OJRQxV2jrVHOZmA8aNPuW01/qu0fXgrnWFUaKWcuqKw=;
        h=Date:From:To:Subject:From;
        b=YlzYkTooVAflJgNm/mOSAQqyF/5mVDNFlq0ZimdL+riM/vJ5rAvN2oZ5qOp4VlT1M
         WZZrmR/n2Dt03izPNYm915JdbU/gOe7+0DIvKggsp/sNLTG4EjewzFt441BMZTBtEb
         bFiIBVSX4Zx8RNn+sFl3BqGU4xoi980vIMK9oX7oH3PLf+5ga0xf1ySHRktbR/zfke
         hXTW0GpqdeYAe/zLdvxdVhC5i/NuPwFEelL0RTduCO4HDE5aTZ7YM4HSLM0VgN2+ZH
         wnNP7AacQfixt7YFXd1FuPEuyr/IbgX4eTgsYpQk7duw1z0E699kW9OLVCe33ASKhI
         OOACxQnvtr+nQ==
Date:   Thu, 14 Jul 2022 10:14:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 95ff0363f3f6
Message-ID: <YtBO7MeRIzhyfe8t@magnolia>
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
the next update.  This is it for 5.20/6.0.

The new head of the for-next branch is commit:

95ff0363f3f6 xfs: fix use-after-free in xattr node block inactivation

57 new commits:

Andrey Strachuk (1):
      [0f38063d7a38] xfs: removed useless condition in function xfs_attr_node_get

Darrick J. Wong (11):
      [dd81dc05598c] Merge tag 'xfs-cil-scale-5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.20-mergeA
      [fddb564f62aa] Merge tag 'xfs-perag-conv-5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.20-mergeA
      [732436ef916b] xfs: convert XFS_IFORK_PTR to a static inline helper
      [2ed5b09b3e8f] xfs: make inode attribute forks a permanent part of struct xfs_inode
      [e45d7cb2356e] xfs: use XFS_IFORK_Q to determine the presence of an xattr fork
      [932b42c66cb5] xfs: replace XFS_IFORK_Q with a proper predicate function
      [c01147d92989] xfs: replace inode fork size macros with functions
      [4613b17cc478] Merge tag 'xfs-iunlink-item-5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.20-mergeB
      [35c5a09f5346] Merge tag 'xfs-buf-lockless-lookup-5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.20-mergeB
      [6d200bdc017a] Merge tag 'make-attr-fork-permanent-5.20_2022-07-14' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-5.20-mergeB
      [95ff0363f3f6] xfs: fix use-after-free in xattr node block inactivation

Dave Chinner (43):
      [88591e7f06a4] xfs: use the CIL space used counter for emptiness checks
      [12380d237b81] xfs: lift init CIL reservation out of xc_cil_lock
      [31151cc342dd] xfs: rework per-iclog header CIL reservation
      [af1c2146a50b] xfs: introduce per-cpu CIL tracking structure
      [7c8ade212120] xfs: implement percpu cil space used calculation
      [1dd2a2c18e31] xfs: track CIL ticket reservation in percpu structure
      [df7a4a2134b0] xfs: convert CIL busy extents to per-cpu
      [016a23388cdc] xfs: Add order IDs to log items in CIL
      [c0fb4765c508] xfs: convert CIL to unordered per cpu lists
      [169248536a2b] xfs: convert log vector chain to use list heads
      [4eb56069cb28] xfs: move CIL ordering to the logvec chain
      [1ccb0745a97f] xfs: avoid cil push lock if possible
      [d9f68777b251] xfs: xlog_sync() manually adjusts grant head space
      [51a117edff13] xfs: expanding delayed logging design with background material
      [c6aee2481419] xfs: make last AG grow/shrink perag centric
      [a95fee40e3d4] xfs: kill xfs_ialloc_pagi_init()
      [99b13c7f0bd3] xfs: pass perag to xfs_ialloc_read_agi()
      [76b47e528e3a] xfs: kill xfs_alloc_pagf_init()
      [08d3e84feeb8] xfs: pass perag to xfs_alloc_read_agf()
      [61021deb1faa] xfs: pass perag to xfs_read_agi
      [fa044ae70c64] xfs: pass perag to xfs_read_agf
      [49f0d84ec1db] xfs: pass perag to xfs_alloc_get_freelist
      [8c392eb27f7a] xfs: pass perag to xfs_alloc_put_freelist
      [cec7bb7d58fa] xfs: pass perag to xfs_alloc_read_agfl
      [0800169e3e2c] xfs: Pre-calculate per-AG agbno geometry
      [2d6ca8321c35] xfs: Pre-calculate per-AG agino geometry
      [3829c9a10fc7] xfs: replace xfs_ag_block_count() with perag accesses
      [36029dee382a] xfs: make is_log_ag() a first class helper
      [85c73bf726e4] xfs: rework xfs_buf_incore() API
      [a4454cd69c66] xfs: factor the xfs_iunlink functions
      [4fcc94d65327] xfs: track the iunlink list pointer in the xfs_inode
      [04755d2e5821] xfs: refactor xlog_recover_process_iunlinks()
      [a83d5a8b1d94] xfs: introduce xfs_iunlink_lookup
      [2fd26cc07e9f] xfs: double link the unlinked inode list
      [5301f8701314] xfs: clean up xfs_iunlink_update_inode()
      [062efdb0803a] xfs: combine iunlink inode update functions
      [fad743d7cd8b] xfs: add log item precommit operation
      [784eb7d8dd41] xfs: add in-memory iunlink log item
      [de67dc575434] xfs: break up xfs_buf_find() into individual pieces
      [348000804a0f] xfs: merge xfs_buf_find() and xfs_buf_get_map()
      [d8d9bbb0ee6c] xfs: reduce the number of atomic when locking a buffer after lookup
      [32dd4f9c506b] xfs: remove a superflous hash lookup when inserting new buffers
      [298f34224506] xfs: lockless buffer lookup

Eric Sandeen (1):
      [70b589a37e1a] xfs: add selinux labels to whiteout inodes

Zhang Yi (1):
      [04a98a036cf8] xfs: flush inode gc workqueue before clearing agi bucket

Code Diffstat:

 .../filesystems/xfs-delayed-logging-design.rst     | 361 ++++++++++--
 fs/xfs/Makefile                                    |   1 +
 fs/xfs/libxfs/xfs_ag.c                             | 173 ++++--
 fs/xfs/libxfs/xfs_ag.h                             |  75 ++-
 fs/xfs/libxfs/xfs_ag_resv.c                        |   2 +-
 fs/xfs/libxfs/xfs_alloc.c                          | 143 ++---
 fs/xfs/libxfs/xfs_alloc.h                          |  58 +-
 fs/xfs/libxfs/xfs_alloc_btree.c                    |   9 +-
 fs/xfs/libxfs/xfs_attr.c                           |  22 +-
 fs/xfs/libxfs/xfs_attr.h                           |  10 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |  29 +-
 fs/xfs/libxfs/xfs_attr_remote.c                    |  15 +-
 fs/xfs/libxfs/xfs_bmap.c                           |  84 +--
 fs/xfs/libxfs/xfs_bmap_btree.c                     |  10 +-
 fs/xfs/libxfs/xfs_btree.c                          |  29 +-
 fs/xfs/libxfs/xfs_dir2.c                           |   2 +-
 fs/xfs/libxfs/xfs_dir2_block.c                     |   6 +-
 fs/xfs/libxfs/xfs_dir2_sf.c                        |   8 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |  86 ++-
 fs/xfs/libxfs/xfs_ialloc.h                         |  25 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c                   |  20 +-
 fs/xfs/libxfs/xfs_inode_buf.c                      |  15 +-
 fs/xfs/libxfs/xfs_inode_fork.c                     |  65 ++-
 fs/xfs/libxfs/xfs_inode_fork.h                     |  27 +-
 fs/xfs/libxfs/xfs_refcount.c                       |  19 +-
 fs/xfs/libxfs/xfs_refcount_btree.c                 |   5 +-
 fs/xfs/libxfs/xfs_rmap.c                           |   8 +-
 fs/xfs/libxfs/xfs_rmap_btree.c                     |   9 +-
 fs/xfs/libxfs/xfs_symlink_remote.c                 |   2 +-
 fs/xfs/libxfs/xfs_types.c                          |  73 +--
 fs/xfs/libxfs/xfs_types.h                          |   9 -
 fs/xfs/scrub/agheader.c                            |  25 +-
 fs/xfs/scrub/agheader_repair.c                     |  21 +-
 fs/xfs/scrub/alloc.c                               |   7 +-
 fs/xfs/scrub/bmap.c                                |  16 +-
 fs/xfs/scrub/btree.c                               |   2 +-
 fs/xfs/scrub/common.c                              |   6 +-
 fs/xfs/scrub/dabtree.c                             |   2 +-
 fs/xfs/scrub/dir.c                                 |   2 +-
 fs/xfs/scrub/fscounters.c                          |   4 +-
 fs/xfs/scrub/health.c                              |   2 +
 fs/xfs/scrub/ialloc.c                              |  12 +-
 fs/xfs/scrub/quota.c                               |   2 +-
 fs/xfs/scrub/refcount.c                            |   9 +-
 fs/xfs/scrub/repair.c                              |  47 +-
 fs/xfs/scrub/rmap.c                                |   6 +-
 fs/xfs/scrub/symlink.c                             |   6 +-
 fs/xfs/xfs_attr_inactive.c                         |  24 +-
 fs/xfs/xfs_attr_list.c                             |   9 +-
 fs/xfs/xfs_bmap_util.c                             |  22 +-
 fs/xfs/xfs_buf.c                                   | 269 +++++----
 fs/xfs/xfs_buf.h                                   |  21 +-
 fs/xfs/xfs_dir2_readdir.c                          |   2 +-
 fs/xfs/xfs_discard.c                               |   2 +-
 fs/xfs/xfs_extfree_item.c                          |   6 +-
 fs/xfs/xfs_filestream.c                            |   4 +-
 fs/xfs/xfs_fsmap.c                                 |   3 +-
 fs/xfs/xfs_fsops.c                                 |  13 +-
 fs/xfs/xfs_icache.c                                |  15 +-
 fs/xfs/xfs_inode.c                                 | 648 ++++++---------------
 fs/xfs/xfs_inode.h                                 |  69 ++-
 fs/xfs/xfs_inode_item.c                            |  58 +-
 fs/xfs/xfs_ioctl.c                                 |  10 +-
 fs/xfs/xfs_iomap.c                                 |   8 +-
 fs/xfs/xfs_iops.c                                  |  13 +-
 fs/xfs/xfs_iops.h                                  |   3 +
 fs/xfs/xfs_itable.c                                |   4 +-
 fs/xfs/xfs_iunlink_item.c                          | 180 ++++++
 fs/xfs/xfs_iunlink_item.h                          |  27 +
 fs/xfs/xfs_log.c                                   |  55 +-
 fs/xfs/xfs_log.h                                   |   3 +-
 fs/xfs/xfs_log_cil.c                               | 474 +++++++++++----
 fs/xfs/xfs_log_priv.h                              |  58 +-
 fs/xfs/xfs_log_recover.c                           | 204 ++++---
 fs/xfs/xfs_mount.c                                 |   3 +-
 fs/xfs/xfs_qm.c                                    |  11 +-
 fs/xfs/xfs_reflink.c                               |  46 +-
 fs/xfs/xfs_reflink.h                               |   3 -
 fs/xfs/xfs_super.c                                 |  11 +
 fs/xfs/xfs_symlink.c                               |   2 +-
 fs/xfs/xfs_trace.h                                 |   3 +-
 fs/xfs/xfs_trans.c                                 |  95 ++-
 fs/xfs/xfs_trans.h                                 |   7 +-
 fs/xfs/xfs_trans_priv.h                            |   3 +-
 84 files changed, 2298 insertions(+), 1659 deletions(-)
 create mode 100644 fs/xfs/xfs_iunlink_item.c
 create mode 100644 fs/xfs/xfs_iunlink_item.h
