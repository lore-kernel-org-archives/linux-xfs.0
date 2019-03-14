Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52372 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbfCNVGd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:06:33 -0400
Subject: [PATCH 26/36] xfs_repair: refactor buffer ops assignments during
 phase 5
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:06:29 -0700
Message-ID: <155259758961.31886.4826767055567611572.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the buffer ops assignments in phase 5 to use a helper function
to determine the correct buf_ops instead of open-coding them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 367c3ab9..0c53096f 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -615,6 +615,24 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	return(extra_blocks);
 }
 
+/* Map btnum to buffer ops for the types that need it. */
+static const struct xfs_buf_ops *
+btnum_to_ops(
+	xfs_btnum_t	btnum)
+{
+	switch (btnum) {
+	case XFS_BTNUM_BNO:
+	case XFS_BTNUM_CNT:
+		return &xfs_allocbt_buf_ops;
+	case XFS_BTNUM_INO:
+	case XFS_BTNUM_FINO:
+		return &xfs_inobt_buf_ops;
+	default:
+		ASSERT(0);
+		return NULL;
+	}
+}
+
 static void
 prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_status_t *btree_curs, xfs_agblock_t startblock,
@@ -625,6 +643,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	xfs_alloc_ptr_t		*bt_ptr;
 	xfs_agblock_t		agbno;
 	bt_stat_level_t		*lptr;
+	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
@@ -675,7 +694,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 		/*
 		 * initialize block header
 		 */
-		lptr->buf_p->b_ops = &xfs_allocbt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, btnum, level,
@@ -723,6 +742,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	extent_tree_node_t	*ext_ptr;
 	bt_stat_level_t		*lptr;
 	xfs_extlen_t		freeblks;
+	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
@@ -754,7 +774,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		/*
 		 * initialize block header
 		 */
-		lptr->buf_p->b_ops = &xfs_allocbt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno, 0);
@@ -781,7 +801,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		/*
 		 * block initialization, lay in block header
 		 */
-		lptr->buf_p->b_ops = &xfs_allocbt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno, 0);
@@ -990,6 +1010,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 	xfs_inobt_ptr_t		*bt_ptr;
 	xfs_agblock_t		agbno;
 	bt_stat_level_t		*lptr;
+	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
 
 	level++;
 
@@ -1038,7 +1059,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		/*
 		 * initialize block header
 		 */
-		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, btnum,
@@ -1130,6 +1151,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	xfs_inobt_rec_t		*bt_rec;
 	ino_tree_node_t		*ino_rec;
 	bt_stat_level_t		*lptr;
+	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
 	xfs_agino_t		count = 0;
 	xfs_agino_t		freecount = 0;
 	int			inocnt;
@@ -1160,7 +1182,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		 * initialize block header
 		 */
 
-		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno, 0);
@@ -1188,7 +1210,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		/*
 		 * block initialization, lay in block header
 		 */
-		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno, 0);
