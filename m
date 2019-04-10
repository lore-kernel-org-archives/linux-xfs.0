Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40662 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730974AbfDJP0A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Apr 2019 11:26:00 -0400
Date: Wed, 10 Apr 2019 08:25:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 26/36] xfs_repair: refactor buffer ops assignments during
 phase 5
Message-ID: <20190410152554.GB1019523@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259758961.31886.4826767055567611572.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155259758961.31886.4826767055567611572.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the buffer ops assignments in phase 5 to use a helper function
to determine the correct buf_ops instead of open-coding them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: convert all the ag btree types
---
 repair/phase5.c |   54 ++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 367c3ab9..5d9c542a 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -615,6 +615,28 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
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
+	case XFS_BTNUM_RMAP:
+		return &xfs_rmapbt_buf_ops;
+	case XFS_BTNUM_REFC:
+		return &xfs_refcountbt_buf_ops;
+	default:
+		ASSERT(0);
+		return NULL;
+	}
+}
+
 static void
 prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_status_t *btree_curs, xfs_agblock_t startblock,
@@ -625,6 +647,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	xfs_alloc_ptr_t		*bt_ptr;
 	xfs_agblock_t		agbno;
 	bt_stat_level_t		*lptr;
+	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
@@ -675,7 +698,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 		/*
 		 * initialize block header
 		 */
-		lptr->buf_p->b_ops = &xfs_allocbt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, btnum, level,
@@ -723,6 +746,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	extent_tree_node_t	*ext_ptr;
 	bt_stat_level_t		*lptr;
 	xfs_extlen_t		freeblks;
+	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
@@ -754,7 +778,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		/*
 		 * initialize block header
 		 */
-		lptr->buf_p->b_ops = &xfs_allocbt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno, 0);
@@ -781,7 +805,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		/*
 		 * block initialization, lay in block header
 		 */
-		lptr->buf_p->b_ops = &xfs_allocbt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno, 0);
@@ -990,6 +1014,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 	xfs_inobt_ptr_t		*bt_ptr;
 	xfs_agblock_t		agbno;
 	bt_stat_level_t		*lptr;
+	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
 
 	level++;
 
@@ -1038,7 +1063,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		/*
 		 * initialize block header
 		 */
-		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, btnum,
@@ -1130,6 +1155,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	xfs_inobt_rec_t		*bt_rec;
 	ino_tree_node_t		*ino_rec;
 	bt_stat_level_t		*lptr;
+	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
 	xfs_agino_t		count = 0;
 	xfs_agino_t		freecount = 0;
 	int			inocnt;
@@ -1160,7 +1186,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		 * initialize block header
 		 */
 
-		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno, 0);
@@ -1188,7 +1214,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		/*
 		 * block initialization, lay in block header
 		 */
-		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno, 0);
@@ -1393,6 +1419,7 @@ prop_rmap_cursor(
 	xfs_rmap_ptr_t		*bt_ptr;
 	xfs_agblock_t		agbno;
 	struct bt_stat_level	*lptr;
+	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_RMAP);
 
 	level++;
 
@@ -1441,7 +1468,7 @@ prop_rmap_cursor(
 		/*
 		 * initialize block header
 		 */
-		lptr->buf_p->b_ops = &xfs_rmapbt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
@@ -1530,6 +1557,7 @@ build_rmap_tree(
 	struct xfs_rmap_irec	highest_key = {0};
 	struct xfs_rmap_irec	hi_key = {0};
 	struct bt_stat_level	*lptr;
+	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_RMAP);
 	int			numrecs;
 	int			level = btree_curs->num_levels;
 	int			error;
@@ -1553,7 +1581,7 @@ build_rmap_tree(
 		 * initialize block header
 		 */
 
-		lptr->buf_p->b_ops = &xfs_rmapbt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
@@ -1580,7 +1608,7 @@ _("Insufficient memory to construct reverse-map cursor."));
 		/*
 		 * block initialization, lay in block header
 		 */
-		lptr->buf_p->b_ops = &xfs_rmapbt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
@@ -1741,6 +1769,7 @@ prop_refc_cursor(
 	xfs_refcount_ptr_t	*bt_ptr;
 	xfs_agblock_t		agbno;
 	struct bt_stat_level	*lptr;
+	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_REFC);
 
 	level++;
 
@@ -1789,7 +1818,7 @@ prop_refc_cursor(
 		/*
 		 * initialize block header
 		 */
-		lptr->buf_p->b_ops = &xfs_refcountbt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_REFC,
@@ -1834,6 +1863,7 @@ build_refcount_tree(
 	struct xfs_slab_cursor	*refc_cur;
 	struct xfs_refcount_rec	*bt_rec;
 	struct bt_stat_level	*lptr;
+	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_REFC);
 	int			numrecs;
 	int			level = btree_curs->num_levels;
 	int			error;
@@ -1856,7 +1886,7 @@ build_refcount_tree(
 		 * initialize block header
 		 */
 
-		lptr->buf_p->b_ops = &xfs_refcountbt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_REFC,
@@ -1883,7 +1913,7 @@ _("Insufficient memory to construct refcount cursor."));
 		/*
 		 * block initialization, lay in block header
 		 */
-		lptr->buf_p->b_ops = &xfs_refcountbt_buf_ops;
+		lptr->buf_p->b_ops = ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
 		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_REFC,
