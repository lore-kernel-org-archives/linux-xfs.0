Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22641 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757302AbcLCBhj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:37:39 -0500
Subject: [PATCH 15/55] xfs: use GPF_NOFS when allocating btree cursors
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:36:49 -0800
Message-ID: <148072900962.12995.1298296248743254244.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
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
 fs/xfs/libxfs/xfs_alloc_btree.c  |    2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c   |    2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index bfbda677..3dad54e 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -498,7 +498,7 @@ xfs_allocbt_init_cursor(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 8007d2b..049fa59 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -796,7 +796,7 @@ xfs_bmbt_init_cursor(
 	struct xfs_btree_cur	*cur;
 	ASSERT(whichfork != XFS_COW_FORK);
 
-	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index eab68ae..6c6b959 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -357,7 +357,7 @@ xfs_inobt_init_cursor(
 	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
 	struct xfs_btree_cur	*cur;
 
-	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;

