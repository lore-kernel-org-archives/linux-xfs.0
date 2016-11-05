Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40069 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754341AbcKEA1x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:27:53 -0400
Subject: [PATCH 31/39] xfs: repair inode btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:27:49 -0700
Message-ID: <147830566914.4165.17086320240433756588.stgit@birch.djwong.org>
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

Use the rmapbt to find inode chunks, query the chunks to compute
hole and free masks, and with that information rebuild the inobt
and finobt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_ialloc.c |    2 +-
 libxfs/xfs_ialloc.h |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 3d02a16..923214a 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -141,7 +141,7 @@ xfs_inobt_get_rec(
 /*
  * Insert a single inobt record. Cursor must already point to desired location.
  */
-STATIC int
+int
 xfs_inobt_insert_rec(
 	struct xfs_btree_cur	*cur,
 	__uint16_t		holemask,
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index f20d958..afcb250 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -175,5 +175,8 @@ int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
 int xfs_ialloc_has_inode_record(struct xfs_btree_cur *cur, xfs_agino_t low,
 		xfs_agino_t high, bool *exists);
+int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, __uint16_t holemask,
+		__uint8_t count, __int32_t freecount, xfs_inofree_t free,
+		int *stat);
 
 #endif	/* __XFS_IALLOC_H__ */

