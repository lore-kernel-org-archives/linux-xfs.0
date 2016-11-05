Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39417 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753736AbcKEAZN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:25:13 -0400
Subject: [PATCH 06/39] xfs: use GPF_NOFS when allocating btree cursors
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:25:10 -0700
Message-ID: <147830551013.4165.1733633613269885550.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Use NOFS for allocating btree cursors, since they can be called
under the ilock.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc_btree.c  |    2 +-
 libxfs/xfs_bmap_btree.c   |    2 +-
 libxfs/xfs_ialloc_btree.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 273ea5b..4f4fecc 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -496,7 +496,7 @@ xfs_allocbt_init_cursor(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 601385d..2997a3a 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -793,7 +793,7 @@ xfs_bmbt_init_cursor(
 	struct xfs_btree_cur	*cur;
 	ASSERT(whichfork != XFS_COW_FORK);
 
-	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 7bf6040..c2d4a5e 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -356,7 +356,7 @@ xfs_inobt_init_cursor(
 	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
 	struct xfs_btree_cur	*cur;
 
-	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;

