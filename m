Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbfBGSlH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 13:41:07 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 913E3C05D40D
        for <linux-xfs@vger.kernel.org>; Thu,  7 Feb 2019 18:41:06 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CDC667621
        for <linux-xfs@vger.kernel.org>; Thu,  7 Feb 2019 18:41:06 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 0/8] xfs: fix [f]inobt magic value verification
Date: Thu,  7 Feb 2019 13:40:57 -0500
Message-Id: <20190207184105.17064-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is v4 of the buffer verifier magic value rework. The only changes
in this version are that patch 1 of v3 has been dropped as it is already
merged and that the magic value asserts that were added to several of
the refactored verifiers are replaced with compile-time magic value
offset checks starting from the top-level structures used in the
associated verifiers.

Brian

v4:
- Dropped set buf ops patch (already merged).
- Replace magic value asserts with build-time magic offset checks.
v3: https://marc.info/?l=linux-xfs&m=154929197225225&w=2
- Fix function declarations to include parameter names.
- Convert allocbt buffer verifier.
v2: https://marc.info/?l=linux-xfs&m=154894958207167&w=2
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

Brian Foster (8):
  xfs: always check magic values in on-disk byte order
  xfs: create a separate finobt verifier
  xfs: distinguish between inobt and finobt magic values
  xfs: split up allocation btree verifier
  xfs: distinguish between bnobt and cntbt magic values
  xfs: use verifier magic field in dir2 leaf verifiers
  xfs: miscellaneous verifier magic value fixups
  xfs: factor xfs_da3_blkinfo verification into common helper

 fs/xfs/libxfs/xfs_ag.c             |   6 +-
 fs/xfs/libxfs/xfs_alloc.c          |  12 ++--
 fs/xfs/libxfs/xfs_alloc_btree.c    |  74 ++++++++++-----------
 fs/xfs/libxfs/xfs_attr_leaf.c      |  21 ++----
 fs/xfs/libxfs/xfs_attr_remote.c    |   8 ++-
 fs/xfs/libxfs/xfs_bmap_btree.c     |  13 ++--
 fs/xfs/libxfs/xfs_da_btree.c       |  49 +++++++++-----
 fs/xfs/libxfs/xfs_da_format.h      |   3 +
 fs/xfs/libxfs/xfs_dir2_block.c     |  10 +--
 fs/xfs/libxfs/xfs_dir2_data.c      |  12 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c      | 100 ++++++-----------------------
 fs/xfs/libxfs/xfs_dir2_node.c      |  10 +--
 fs/xfs/libxfs/xfs_ialloc.c         |   3 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  25 +++++---
 fs/xfs/libxfs/xfs_inode_buf.c      |   2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   3 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |   3 +-
 fs/xfs/libxfs/xfs_sb.c             |   5 +-
 fs/xfs/libxfs/xfs_shared.h         |   4 +-
 fs/xfs/libxfs/xfs_symlink_remote.c |   3 +-
 fs/xfs/scrub/agheader_repair.c     |   6 +-
 fs/xfs/xfs_buf.c                   |  19 ++++++
 fs/xfs/xfs_buf.h                   |   2 +
 fs/xfs/xfs_log_recover.c           |  12 ++--
 fs/xfs/xfs_ondisk.h                |  17 +++++
 25 files changed, 218 insertions(+), 204 deletions(-)

-- 
2.17.2
