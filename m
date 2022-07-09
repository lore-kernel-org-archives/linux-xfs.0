Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C9CC433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jul 2022 22:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiGIWmb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jul 2022 18:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiGIWma (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jul 2022 18:42:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D096611C37
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 15:42:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D10A60FEE
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 22:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFA0C3411C
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 22:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657406548;
        bh=UsW4wIGcK1pCQOAeXavyKcm+UyDDyjujrWXC3A+IVII=;
        h=Date:From:To:Subject:From;
        b=LVUyknIS79lZ39CCNtwLjZ+21Vw5CqIA2LqV0CmmBPk+a33fO7cflgpjjVLYdhyHR
         5a2hrA7fWSQr9fqSqI2b8jlpKfMxpQeUJwqOnB1tF4Sohg7bpiMkGne38xV2Pg1+kt
         /cZT0On/8CIdwG+eEHWUtuwbW5SNSJX3LpJoVHiBb7KRT3Qu6BJL/t9vUWgdtE8JtY
         ABRr7kUfPb1cXb/1GEGuqBAR4esakC65L9sdkLq8U7elIPCrxtZkBSoR1+FWrqQFFA
         2yuR6eEJCq9Y6J5OZ0vC1nDq05z0mX+BS3cYeubMUfkQOYD0b8Bjftt+1TPav2qipu
         KR5kOP1L7fq8g==
Date:   Sat, 9 Jul 2022 15:42:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next **rebased** to 0f38063d7a38
Message-ID: <YsoEVAFinB9Q6IKk@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been **REBASED**.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

This is a rebase of the for-next push from earlier in the week to
use Dave's pull requests to incorporate signed tags into the merge
branch.  This preserves the commit messages from those patchsets.
There should be no other changes.

The new head of the for-next branch is commit:

0f38063d7a38 xfs: removed useless condition in function xfs_attr_node_get

32 new commits:

Andrey Strachuk (1):
      [0f38063d7a38] xfs: removed useless condition in function xfs_attr_node_get

Darrick J. Wong (2):
      [dd81dc05598c] Merge tag 'xfs-cil-scale-5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.20-mergeA
      [fddb564f62aa] Merge tag 'xfs-perag-conv-5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.20-mergeA

Dave Chinner (28):
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

Eric Sandeen (1):
      [70b589a37e1a] xfs: add selinux labels to whiteout inodes

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
 52 files changed, 1278 insertions(+), 722 deletions(-)
