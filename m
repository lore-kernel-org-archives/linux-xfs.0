Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999B9C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 673D1610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhIOXS1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXS0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:18:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D073610A4;
        Wed, 15 Sep 2021 23:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747827;
        bh=h0IXZM6PySNnpP9da/MtXfu/WO/etZD/ksU0TFHA8Lg=;
        h=Date:From:To:Subject:From;
        b=nG/TmBjHqJKxwECw+I+JhJKfMxTeHITJFJPTulELGPIxOeFkCNoVtLNuznyjVfTxW
         JpXRAB6U3QkjdHyhoxjLDQ8WGF01F5ABpkvzbM/SocVcpq6waFnBdWBScFtqd1Us/O
         PbEqNtbqmzzuTkav9e5a/M1WGbBsNKbihtEWn101Jm91BqVYxzgukOxQtMyzdZxFNK
         l8mzip3GiZCSnSpaMvZYHtZZxZ8L/dY9IQxlV1sh6lbDsGPc5sNI2BGJ3MamdzCfja
         qM0PrOcaKzpPvi38b39Cdr9TwJxD1gufXL2NIsypQx4dTFM+YJNTpachkOHnL/csyo
         EDVdEdqncVA/A==
Date:   Wed, 15 Sep 2021 16:17:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfsprogs: synchronize with kernel 5.14
Message-ID: <20210915231706.GA34899@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Eric,

Please pull this branch containing all the libxfs backporting work for
Linux 5.14.  It merges cleanly with upstream head and (AFAICT) I haven't
seen any fstests regressions since I imported this pile shortly after
5.14-rc1 and -rc4 dropped.

--D

The following changes since commit b42033308360655616fc9bd77678c46bf518b7c8:

  xfsprogs: Release v5.13.0 (2021-08-20 12:03:57 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/libxfs-5.14-sync_2021-09-15

for you to fetch changes up to bb41d9321b83b0800eaef5696778b6a6c9a5ffd9:

  mkfs: warn about V4 deprecation when creating new V4 filesystems (2021-09-15 16:00:04 -0700)

----------------------------------------------------------------
xfs: sync libxfs with 5.14

This patchset backports all the libxfs changes from kernel 5.14, as well
as all the related for_each_perag and fallthrough; cleanups that went
with it.  I've prepared this series and pull request per Eric's request.

----------------------------------------------------------------
Allison Henderson (15):
      xfs: Reverse apply 72b97ea40d
      xfs: Add xfs_attr_node_remove_name
      xfs: Refactor xfs_attr_set_shortform
      xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_clear_incomplete
      xfs: Add helper xfs_attr_node_addname_find_attr
      xfs: Hoist xfs_attr_node_addname
      xfs: Hoist xfs_attr_leaf_addname
      xfs: Hoist node transaction handling
      xfs: Add delay ready attr remove routines
      xfs: Add delay ready attr set routines
      xfs: Remove xfs_attr_rmtval_set
      xfs: Clean up xfs_attr_node_addname_clear_incomplete
      xfs: Fix default ASSERT in xfs_attr_set_iter
      xfs: Make attr name schemes consistent
      xfs: Initialize error in xfs_attr_remove_iter

Christoph Hellwig (1):
      xfs: mark xfs_bmap_set_attrforkoff static

Darrick J. Wong (13):
      mkfs: move mkfs/proto.c declarations to mkfs/proto.h
      libfrog: move topology.[ch] to libxfs
      libfrog: create header file for mocked-up kernel data structures
      libxfs: port xfs_set_inode_alloc from the kernel
      libxfs: fix whitespace inconsistencies with kernel
      misc: convert utilities to use "fallthrough;"
      xfs: clean up open-coded fs block unit conversions
      xfs: fix radix tree tag signs
      xfs: fix endianness issue in xfs_ag_shrink_space
      xfs: check for sparse inode clusters that cross new EOAG when shrinking
      xfs: correct the narrative around misaligned rtinherit/extszinherit dirs
      xfs_db: convert the agresv command to use for_each_perag
      mkfs: warn about V4 deprecation when creating new V4 filesystems

Dave Chinner (28):
      xfs: use xfs_buf_alloc_pages for uncached buffers
      xfs: move xfs_perag_get/put to xfs_ag.[ch]
      xfs: move perag structure and setup to libxfs/xfs_ag.[ch]
      xfs: make for_each_perag... a first class citizen
      xfs: convert raw ag walks to use for_each_perag
      xfs: convert xfs_iwalk to use perag references
      xfs: convert secondary superblock walk to use perags
      xfs: pass perags through to the busy extent code
      xfs: push perags through the ag reservation callouts
      xfs: pass perags around in fsmap data dev functions
      xfs: add a perag to the btree cursor
      xfs: convert rmap btree cursor to using a perag
      xfs: convert refcount btree cursor to use perags
      xfs: convert allocbt cursors to use perags
      xfs: use perag for ialloc btree cursors
      xfs: remove agno from btree cursor
      xfs: simplify xfs_dialloc_select_ag() return values
      xfs: collapse AG selection for inode allocation
      xfs: get rid of xfs_dir_ialloc()
      xfs: inode allocation can use a single perag instance
      xfs: clean up and simplify xfs_dialloc()
      xfs: use perag through unlink processing
      xfs: remove xfs_perag_t
      xfs: drop the AGI being passed to xfs_check_agi_freecount
      xfs: perag may be null in xfs_imap()
      xfs: log stripe roundoff is a property of the log
      xfs: xfs_log_force_lsn isn't passed a LSN
      xfs: logging the on disk inode LSN can make it go backwards

Gustavo A. R. Silva (2):
      xfs: Fix fall-through warnings for Clang
      xfs: Fix multiple fall-through warnings for Clang

Jiapeng Chong (1):
      xfs: Remove redundant assignment to busy

Shaokun Zhang (1):
      xfs: sort variable alphabetically to avoid repeated declaration

 db/fsmap.c                     |  17 +-
 db/info.c                      |  18 +-
 db/type.c                      |   2 +-
 growfs/xfs_growfs.c            |   6 +-
 include/atomic.h               |   1 +
 include/libxfs.h               |   3 +
 include/linux.h                |  17 +
 include/xfs_mount.h            |  65 ---
 include/xfs_multidisk.h        |   5 -
 libfrog/Makefile               |   3 +-
 libfrog/mockups.h              |  43 ++
 libfrog/radix-tree.h           |   3 +
 libxfs/Makefile                |  10 +-
 libxfs/init.c                  | 147 +++----
 libxfs/libxfs_api_defs.h       |   2 +
 libxfs/libxfs_priv.h           |  18 +-
 {libfrog => libxfs}/topology.c |   5 +-
 {libfrog => libxfs}/topology.h |   6 +-
 libxfs/util.c                  |  12 +-
 libxfs/xfs_ag.c                | 287 ++++++++++++-
 libxfs/xfs_ag.h                | 136 ++++++
 libxfs/xfs_ag_resv.c           |  15 +-
 libxfs/xfs_ag_resv.h           |  15 +
 libxfs/xfs_alloc.c             | 113 ++---
 libxfs/xfs_alloc.h             |   2 +-
 libxfs/xfs_alloc_btree.c       |  31 +-
 libxfs/xfs_alloc_btree.h       |   9 +-
 libxfs/xfs_attr.c              | 956 ++++++++++++++++++++++++-----------------
 libxfs/xfs_attr.h              | 403 +++++++++++++++++
 libxfs/xfs_attr_leaf.c         |   5 +-
 libxfs/xfs_attr_leaf.h         |   2 +-
 libxfs/xfs_attr_remote.c       | 167 +++----
 libxfs/xfs_attr_remote.h       |   8 +-
 libxfs/xfs_bmap.c              |   3 +-
 libxfs/xfs_bmap.h              |   1 -
 libxfs/xfs_btree.c             |  15 +-
 libxfs/xfs_btree.h             |  12 +-
 libxfs/xfs_da_btree.c          |   2 +-
 libxfs/xfs_ialloc.c            | 696 +++++++++++++++---------------
 libxfs/xfs_ialloc.h            |  43 +-
 libxfs/xfs_ialloc_btree.c      |  46 +-
 libxfs/xfs_ialloc_btree.h      |  13 +-
 libxfs/xfs_inode_buf.c         |  30 +-
 libxfs/xfs_log_format.h        |  14 +-
 libxfs/xfs_refcount.c          | 122 +++---
 libxfs/xfs_refcount.h          |   9 +-
 libxfs/xfs_refcount_btree.c    |  39 +-
 libxfs/xfs_refcount_btree.h    |   7 +-
 libxfs/xfs_rmap.c              | 147 ++++---
 libxfs/xfs_rmap.h              |   6 +-
 libxfs/xfs_rmap_btree.c        |  46 +-
 libxfs/xfs_rmap_btree.h        |   8 +-
 libxfs/xfs_sb.c                | 145 +------
 libxfs/xfs_sb.h                |   9 -
 libxfs/xfs_shared.h            |  20 +-
 libxfs/xfs_trans_inode.c       |  10 +-
 libxfs/xfs_types.c             |   4 +-
 libxfs/xfs_types.h             |   1 +
 mkfs/proto.c                   |   1 +
 mkfs/proto.h                   |  13 +
 mkfs/xfs_mkfs.c                |  11 +-
 repair/agbtree.c               |  28 +-
 repair/agbtree.h               |   8 +-
 repair/dinode.c                |  18 +-
 repair/phase4.c                |   4 +-
 repair/phase5.c                |  16 +-
 repair/rmap.c                  |  43 +-
 repair/sb.c                    |   1 -
 repair/scan.c                  |   4 +-
 scrub/inodes.c                 |   2 +-
 scrub/repair.c                 |   2 +-
 scrub/scrub.c                  |   8 +-
 72 files changed, 2520 insertions(+), 1619 deletions(-)
 create mode 100644 libfrog/mockups.h
 rename {libfrog => libxfs}/topology.c (99%)
 rename {libfrog => libxfs}/topology.h (88%)
 create mode 100644 mkfs/proto.h
