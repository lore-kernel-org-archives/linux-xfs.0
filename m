Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44261 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731284AbfAaPqJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 10:46:09 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7525DC002964
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 15:46:09 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 251D2600C2
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 15:46:09 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/7] xfs: fix [f]inobt magic value verification
Date: Thu, 31 Jan 2019 10:46:01 -0500
Message-Id: <20190131154608.36837-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's v2 of the verifier magic value cleanup. This is generally the
same idea as the previous version. The primary difference is that v2
first converts verifiers that use cpu order magic comparisons to use
on-disk (big endian) order and then stores/compares the verifier magic
values in on-disk order. The purpose of this change is to reduce the
number of byte swaps required at runtime for verifier magic value
checks. Further changes include some cleanups, additional refactoring
and the inclusion of Darrick's scrub ->b_ops fix with some modifications
from the original version.

This survives fstests on v4 and v5 filesystems on both little and big
endian systems without regressions. Thoughts, reviews, flames
appreciated.

Brian

v2:
- Include djwong's ->b_ops patch w/ modifications.
- Added patch to fix up existing cpu endian magic checks, fold in typo
  fix.
- Replace static inline magic verifier helper with out of line variant,
  kill macro.
- Store on-disk byte order magics in ->b_ops.
- Added patch to refactor common xfs_da3_blkinfo checks.
v1: https://marc.info/?l=linux-xfs&m=154878684317178&w=2
- Remove endian conversion from helper.
- Drop finobt bad magic mitigation patch.
- Additional verifier magic fixups.
- Add verifier name typo fixup.
rfcv2: https://marc.info/?l=linux-xfs&m=154868884311668&w=2
- Split off finobt verifier into separate patch, assign it
  appropriately.
- Created helpers for xfs_buf_ops magic value verification.
- Added error mitigation patch for problematic finobt blocks.
rfcv1: https://marc.info/?l=linux-xfs&m=154834528212262&w=2

Brian Foster (6):
  xfs: always check magic values in on-disk byte order
  xfs: create a separate finobt verifier
  xfs: distinguish between inobt and finobt magic values
  xfs: use verifier magic field in dir2 leaf verifiers
  xfs: miscellaneous verifier magic value fixups
  xfs: factor xfs_da3_blkinfo verification into common helper

Darrick J. Wong (1):
  xfs: set buffer ops when repair probes for btree type

 fs/xfs/libxfs/xfs_ag.c             |   2 +-
 fs/xfs/libxfs/xfs_alloc.c          |  12 ++--
 fs/xfs/libxfs/xfs_attr_leaf.c      |  21 ++----
 fs/xfs/libxfs/xfs_attr_remote.c    |   8 ++-
 fs/xfs/libxfs/xfs_bmap_btree.c     |  13 ++--
 fs/xfs/libxfs/xfs_da_btree.c       |  50 ++++++++++-----
 fs/xfs/libxfs/xfs_da_format.h      |   2 +
 fs/xfs/libxfs/xfs_dir2_block.c     |  10 +--
 fs/xfs/libxfs/xfs_dir2_data.c      |  12 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c      | 100 ++++++-----------------------
 fs/xfs/libxfs/xfs_dir2_node.c      |  11 ++--
 fs/xfs/libxfs/xfs_ialloc.c         |   3 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  25 +++++---
 fs/xfs/libxfs/xfs_inode_buf.c      |   2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   3 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |   3 +-
 fs/xfs/libxfs/xfs_sb.c             |   5 +-
 fs/xfs/libxfs/xfs_shared.h         |   1 +
 fs/xfs/libxfs/xfs_symlink_remote.c |   3 +-
 fs/xfs/scrub/agheader_repair.c     |   2 +-
 fs/xfs/scrub/repair.c              |  11 +++-
 fs/xfs/xfs_buf.c                   |  41 ++++++++++--
 fs/xfs/xfs_buf.h                   |   4 +-
 fs/xfs/xfs_log_recover.c           |   6 +-
 fs/xfs/xfs_trans_buf.c             |   2 +-
 25 files changed, 183 insertions(+), 169 deletions(-)

-- 
2.17.2
