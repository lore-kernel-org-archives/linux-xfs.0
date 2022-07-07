Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B93CC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 17:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbiGGRHr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 13:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236550AbiGGRHb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 13:07:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D172E08E
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 10:07:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1559CE25D4
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 17:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455C0C3411E
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 17:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657213647;
        bh=vZRz1BfPeKousmkvJMUyVRwoeTExsZCEhzCfTz+w654=;
        h=Date:From:To:Subject:From;
        b=UMf5WO7OLivCqp5B94C1cVm+FBZDBRpkxuqyLAIBqeNn9fe9dxBbRXSc+mF8XEPr/
         Z9BvXANSSSi9Ku4Avxu5Qv3FyagCLD8cmYH865OXB5lNz+VfsoD6n+SQc9UbMElLX0
         p7qJEJUNyQ69qnvh1BPmsiZ+8TrRP8naqr58mcqUj76Fj0kIzZGt7a4iYUzCFcKEII
         DWLyIW0n7WmtraLc58e9iuL9sdNWcU/p3JCqUCW8DYqBPIiuqMExSJveq3LCmM9wmK
         fi/hGThdHUmeT2u2TXQx/ubmRNNCtwdMV5CoDC6Bb2vZvmLfl/HmHpk3tG+Ykie2MG
         Vcs8vQn0xJeWw==
Date:   Thu, 7 Jul 2022 10:07:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 278271b9f442
Message-ID: <YscSzg0ZToIoRhp/@magnolia>
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
the next update.  This branch contains Dave's CIL scalability
improvements and perag refactoring.

I'm still tracking three patchsets for 5.20: the permanent attr fork[1]
series, the lockless buffer lookups[2] series, and the in-memory iunlink
items[3] series.  The first patchset fixes a use-after-free bug caused
by a race condition in the VFS xattr code, so I would very much like to
finish review on that.  I think the lockless buffer lookups changes
might be simple enough to land in 5.20; and the iunlinks thing might
simply be too late for this merge window.

[1] https://lore.kernel.org/linux-xfs/165705897408.2826746.14673631830829415034.stgit@magnolia/T/#t
[2] https://lore.kernel.org/linux-xfs/YsZHh2ZkopJFmaKx@magnolia/T/#t
[3] https://lore.kernel.org/linux-xfs/20220627004336.217366-1-david@fromorbit.com/T/#t

The new head of the for-next branch is commit:

278271b9f442 xfs: removed useless condition in function xfs_attr_node_get

30 new commits:

Andrey Strachuk (1):
      [278271b9f442] xfs: removed useless condition in function xfs_attr_node_get

Dave Chinner (28):
      [f0ea0c88a09c] xfs: use the CIL space used counter for emptiness checks
      [7b3e269175bf] xfs: lift init CIL reservation out of xc_cil_lock
      [b16aca408234] xfs: rework per-iclog header CIL reservation
      [314a52ad7876] xfs: introduce per-cpu CIL tracking structure
      [d1acf511536a] xfs: implement percpu cil space used calculation
      [1f3181cff6bb] xfs: track CIL ticket reservation in percpu structure
      [7e1fdcdc8b60] xfs: convert CIL busy extents to per-cpu
      [4927947025e7] xfs: Add order IDs to log items in CIL
      [8c2fcb2dc169] xfs: convert CIL to unordered per cpu lists
      [3e427d9f4ef5] xfs: convert log vector chain to use list heads
      [192e263f58d8] xfs: move CIL ordering to the logvec chain
      [d32417f8df90] xfs: avoid cil push lock if possible
      [3a25f844058e] xfs: xlog_sync() manually adjusts grant head space
      [3a7dda0fc7a7] xfs: expanding delayed logging design with background material
      [baf2ea50bcca] xfs: make last AG grow/shrink perag centric
      [cfa9751557ab] xfs: kill xfs_ialloc_pagi_init()
      [e8b86e659018] xfs: pass perag to xfs_ialloc_read_agi()
      [710c94e79f4d] xfs: kill xfs_alloc_pagf_init()
      [c4829aba9c8d] xfs: pass perag to xfs_alloc_read_agf()
      [3b6eed27d448] xfs: pass perag to xfs_read_agi
      [5d95ff050d1f] xfs: pass perag to xfs_read_agf
      [fa5fd855ceb2] xfs: pass perag to xfs_alloc_get_freelist
      [3f853d7cf40e] xfs: pass perag to xfs_alloc_put_freelist
      [f5560f11cca6] xfs: pass perag to xfs_alloc_read_agfl
      [f90bf684e344] xfs: Pre-calculate per-AG agbno geometry
      [eb0db6beb708] xfs: Pre-calculate per-AG agino geometry
      [7d8843ef24b4] xfs: replace xfs_ag_block_count() with perag accesses
      [1ed63729c865] xfs: make is_log_ag() a first class helper

Eric Sandeen (1):
      [ffea91261882] xfs: add selinux labels to whiteout inodes

Code Diffstat:

 .../filesystems/xfs-delayed-logging-design.rst     | 361 ++++++++++++++--
 fs/xfs/libxfs/xfs_ag.c                             | 165 ++++---
 fs/xfs/libxfs/xfs_ag.h                             |  69 ++-
 fs/xfs/libxfs/xfs_ag_resv.c                        |   2 +-
 fs/xfs/libxfs/xfs_alloc.c                          | 143 +++----
 fs/xfs/libxfs/xfs_alloc.h                          |  58 +--
 fs/xfs/libxfs/xfs_alloc_btree.c                    |   9 +-
 fs/xfs/libxfs/xfs_attr.c                           |   2 +-
 fs/xfs/libxfs/xfs_bmap.c                           |   3 +-
 fs/xfs/libxfs/xfs_btree.c                          |  25 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |  86 ++--
 fs/xfs/libxfs/xfs_ialloc.h                         |  25 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c                   |  20 +-
 fs/xfs/libxfs/xfs_inode_buf.c                      |   5 +-
 fs/xfs/libxfs/xfs_refcount.c                       |  19 +-
 fs/xfs/libxfs/xfs_refcount_btree.c                 |   5 +-
 fs/xfs/libxfs/xfs_rmap.c                           |   8 +-
 fs/xfs/libxfs/xfs_rmap_btree.c                     |   9 +-
 fs/xfs/libxfs/xfs_sb.c                             |   9 +
 fs/xfs/libxfs/xfs_types.c                          |  73 +---
 fs/xfs/libxfs/xfs_types.h                          |   9 -
 fs/xfs/scrub/agheader.c                            |  25 +-
 fs/xfs/scrub/agheader_repair.c                     |  21 +-
 fs/xfs/scrub/alloc.c                               |   7 +-
 fs/xfs/scrub/bmap.c                                |   2 +-
 fs/xfs/scrub/common.c                              |   6 +-
 fs/xfs/scrub/fscounters.c                          |   4 +-
 fs/xfs/scrub/health.c                              |   2 +
 fs/xfs/scrub/ialloc.c                              |  12 +-
 fs/xfs/scrub/refcount.c                            |   9 +-
 fs/xfs/scrub/repair.c                              |  32 +-
 fs/xfs/scrub/rmap.c                                |   6 +-
 fs/xfs/xfs_discard.c                               |   2 +-
 fs/xfs/xfs_extfree_item.c                          |   6 +-
 fs/xfs/xfs_filestream.c                            |   4 +-
 fs/xfs/xfs_fsmap.c                                 |   3 +-
 fs/xfs/xfs_fsops.c                                 |  13 +-
 fs/xfs/xfs_inode.c                                 |  42 +-
 fs/xfs/xfs_ioctl.c                                 |   8 +-
 fs/xfs/xfs_iops.c                                  |  11 +-
 fs/xfs/xfs_iops.h                                  |   3 +
 fs/xfs/xfs_log.c                                   |  55 ++-
 fs/xfs/xfs_log.h                                   |   3 +-
 fs/xfs/xfs_log_cil.c                               | 474 ++++++++++++++++-----
 fs/xfs/xfs_log_priv.h                              |  58 ++-
 fs/xfs/xfs_log_recover.c                           |  41 +-
 fs/xfs/xfs_mount.c                                 |   3 +-
 fs/xfs/xfs_reflink.c                               |  40 +-
 fs/xfs/xfs_reflink.h                               |   3 -
 fs/xfs/xfs_super.c                                 |   1 +
 fs/xfs/xfs_trans.c                                 |   4 +-
 fs/xfs/xfs_trans.h                                 |   1 +
 fs/xfs/xfs_trans_priv.h                            |   3 +-
 53 files changed, 1287 insertions(+), 722 deletions(-)
