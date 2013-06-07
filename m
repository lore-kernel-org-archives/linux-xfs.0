Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D6A367F5F
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3A87304087
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:55 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	wlINP4egWZz533RB for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:53 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVm-0003v4-HC
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:34 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVm-0001Ku-9x
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 19/48] xfs: buffer type overruns blf_flags field
Date: Fri,  7 Jun 2013 10:25:42 +1000
Message-Id: <1370564771-4929-20-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The buffer type passed to log recvoery in the buffer log item
overruns the blf_flags field. I had assumed that flags field was a
32 bit value, and it turns out it is a unisgned short. Therefore
having 19 flags doesn't really work.

Convert the buffer type field to numeric value, and use the top 5
bits of the flags field for it. We currently have 17 types of
buffers, so using 5 bits gives us plenty of room for expansion in
future....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_buf_item.h  |   92 +++++++++++++++++++++++++++--------------------
 include/xfs_trans.h     |    4 ---
 libxfs/trans.c          |    2 +-
 libxfs/xfs_alloc.c      |    4 +--
 libxfs/xfs_attr_leaf.c  |    6 ++--
 libxfs/xfs_bmap.c       |    2 +-
 libxfs/xfs_btree.c      |    8 ++---
 libxfs/xfs_da_btree.c   |   12 +++----
 libxfs/xfs_dir2_block.c |    4 +--
 libxfs/xfs_dir2_data.c  |    4 +--
 libxfs/xfs_dir2_leaf.c  |   12 +++----
 libxfs/xfs_dir2_node.c  |   10 +++---
 libxfs/xfs_ialloc.c     |    2 +-
 13 files changed, 86 insertions(+), 76 deletions(-)

diff --git a/include/xfs_buf_item.h b/include/xfs_buf_item.h
index 640adcf..2573d2a 100644
--- a/include/xfs_buf_item.h
+++ b/include/xfs_buf_item.h
@@ -39,45 +39,6 @@ extern kmem_zone_t	*xfs_buf_item_zone;
 #define XFS_BLF_PDQUOT_BUF	(1<<3)
 #define	XFS_BLF_GDQUOT_BUF	(1<<4)
 
-/*
- * all buffers now need flags to tell recovery where the magic number
- * is so that it can verify and calculate the CRCs on the buffer correctly
- * once the changes have been replayed into the buffer.
- */
-#define XFS_BLF_BTREE_BUF	(1<<5)
-#define XFS_BLF_AGF_BUF		(1<<6)
-#define XFS_BLF_AGFL_BUF	(1<<7)
-#define XFS_BLF_AGI_BUF		(1<<8)
-#define XFS_BLF_DINO_BUF	(1<<9)
-#define XFS_BLF_SYMLINK_BUF	(1<<10)
-#define XFS_BLF_DIR_BLOCK_BUF	(1<<11)
-#define XFS_BLF_DIR_DATA_BUF	(1<<12)
-#define XFS_BLF_DIR_FREE_BUF	(1<<13)
-#define XFS_BLF_DIR_LEAF1_BUF	(1<<14)
-#define XFS_BLF_DIR_LEAFN_BUF	(1<<15)
-#define XFS_BLF_DA_NODE_BUF	(1<<16)
-#define XFS_BLF_ATTR_LEAF_BUF	(1<<17)
-#define XFS_BLF_ATTR_RMT_BUF	(1<<18)
-
-#define XFS_BLF_TYPE_MASK	\
-		(XFS_BLF_UDQUOT_BUF | \
-		 XFS_BLF_PDQUOT_BUF | \
-		 XFS_BLF_GDQUOT_BUF | \
-		 XFS_BLF_BTREE_BUF | \
-		 XFS_BLF_AGF_BUF | \
-		 XFS_BLF_AGFL_BUF | \
-		 XFS_BLF_AGI_BUF | \
-		 XFS_BLF_DINO_BUF | \
-		 XFS_BLF_SYMLINK_BUF | \
-		 XFS_BLF_DIR_BLOCK_BUF | \
-		 XFS_BLF_DIR_DATA_BUF | \
-		 XFS_BLF_DIR_FREE_BUF | \
-		 XFS_BLF_DIR_LEAF1_BUF | \
-		 XFS_BLF_DIR_LEAFN_BUF | \
-		 XFS_BLF_DA_NODE_BUF | \
-		 XFS_BLF_ATTR_LEAF_BUF | \
-		 XFS_BLF_ATTR_RMT_BUF)
-
 #define	XFS_BLF_CHUNK		128
 #define	XFS_BLF_SHIFT		7
 #define	BIT_TO_WORD_SHIFT	5
@@ -101,6 +62,55 @@ typedef struct xfs_buf_log_format {
 } xfs_buf_log_format_t;
 
 /*
+ * All buffers now need to tell recovery where the magic number
+ * is so that it can verify and calculate the CRCs on the buffer correctly
+ * once the changes have been replayed into the buffer.
+ *
+ * The type value is held in the upper 5 bits of the blf_flags field, which is
+ * an unsigned 16 bit field. Hence we need to shift it 11 bits up and down.
+ */
+#define XFS_BLFT_BITS	5
+#define XFS_BLFT_SHIFT	11
+#define XFS_BLFT_MASK	(((1 << XFS_BLFT_BITS) - 1) << XFS_BLFT_SHIFT)
+
+enum xfs_blft {
+	XFS_BLFT_UNKNOWN_BUF = 0,
+	XFS_BLFT_UDQUOT_BUF,
+	XFS_BLFT_PDQUOT_BUF,
+	XFS_BLFT_GDQUOT_BUF,
+	XFS_BLFT_BTREE_BUF,
+	XFS_BLFT_AGF_BUF,
+	XFS_BLFT_AGFL_BUF,
+	XFS_BLFT_AGI_BUF,
+	XFS_BLFT_DINO_BUF,
+	XFS_BLFT_SYMLINK_BUF,
+	XFS_BLFT_DIR_BLOCK_BUF,
+	XFS_BLFT_DIR_DATA_BUF,
+	XFS_BLFT_DIR_FREE_BUF,
+	XFS_BLFT_DIR_LEAF1_BUF,
+	XFS_BLFT_DIR_LEAFN_BUF,
+	XFS_BLFT_DA_NODE_BUF,
+	XFS_BLFT_ATTR_LEAF_BUF,
+	XFS_BLFT_ATTR_RMT_BUF,
+	XFS_BLFT_SB_BUF,
+	XFS_BLFT_MAX_BUF = (1 << XFS_BLFT_BITS),
+};
+
+static inline void
+xfs_blft_to_flags(struct xfs_buf_log_format *blf, enum xfs_blft type)
+{
+	ASSERT(type > XFS_BLFT_UNKNOWN_BUF && type < XFS_BLFT_MAX_BUF);
+	blf->blf_flags &= ~XFS_BLFT_MASK;
+	blf->blf_flags |= ((type << XFS_BLFT_SHIFT) & XFS_BLFT_MASK);
+}
+
+static inline __uint16_t
+xfs_blft_from_flags(struct xfs_buf_log_format *blf)
+{
+	return (blf->blf_flags & XFS_BLFT_MASK) >> XFS_BLFT_SHIFT;
+}
+
+/*
  * buf log item flags
  */
 #define	XFS_BLI_HOLD		0x01
@@ -153,6 +163,10 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
 void	xfs_buf_iodone_callbacks(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
 
+void	xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
+			       enum xfs_blft);
+void	xfs_trans_buf_copy_type(struct xfs_buf *dst_bp, struct xfs_buf *src_bp);
+
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_BUF_ITEM_H__ */
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 9e145e9..acf1381 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -500,10 +500,6 @@ void		xfs_trans_inode_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
-void		xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
-				       uint);
-void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
-					struct xfs_buf *src_bp);
 void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 619aad1..831e42a 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -218,7 +218,7 @@ libxfs_trans_inode_alloc_buf(
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DINO_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
 }
 
 /*
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 30fc5f4..1041f8f 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2079,7 +2079,7 @@ xfs_alloc_log_agf(
 
 	trace_xfs_agf(tp->t_mountp, XFS_BUF_TO_AGF(bp), fields, _RET_IP_);
 
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_AGF_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_AGF_BUF);
 
 	xfs_btree_offsets(fields, offsets, XFS_AGF_NUM_BITS, &first, &last);
 	xfs_trans_log_buf(tp, bp, (uint)first, (uint)last);
@@ -2159,7 +2159,7 @@ xfs_alloc_put_freelist(
 
 	xfs_alloc_log_agf(tp, agbp, logflags);
 
-	xfs_trans_buf_set_type(tp, agflbp, XFS_BLF_AGFL_BUF);
+	xfs_trans_buf_set_type(tp, agflbp, XFS_BLFT_AGFL_BUF);
 	xfs_trans_log_buf(tp, agflbp, startoff,
 			  startoff + sizeof(xfs_agblock_t) - 1);
 	return 0;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 7724781..b28266a 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -241,7 +241,7 @@ xfs_attr3_leaf_read(
 	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
 				XFS_ATTR_FORK, &xfs_attr3_leaf_buf_ops);
 	if (!err && tp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_ATTR_LEAF_BUF);
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_ATTR_LEAF_BUF);
 	return err;
 }
 
@@ -872,7 +872,7 @@ xfs_attr3_leaf_to_node(
 		goto out;
 
 	/* copy leaf to new buffer, update identifiers */
-	xfs_trans_buf_set_type(args->trans, bp2, XFS_BLF_ATTR_LEAF_BUF);
+	xfs_trans_buf_set_type(args->trans, bp2, XFS_BLFT_ATTR_LEAF_BUF);
 	bp2->b_ops = bp1->b_ops;
 	memcpy(bp2->b_addr, bp1->b_addr, XFS_LBSIZE(mp));
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
@@ -935,7 +935,7 @@ xfs_attr3_leaf_create(
 	if (error)
 		return error;
 	bp->b_ops = &xfs_attr3_leaf_buf_ops;
-	xfs_trans_buf_set_type(args->trans, bp, XFS_BLF_ATTR_LEAF_BUF);
+	xfs_trans_buf_set_type(args->trans, bp, XFS_BLFT_ATTR_LEAF_BUF);
 	leaf = bp->b_addr;
 	memset(leaf, 0, XFS_LBSIZE(mp));
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5e736a5..6664265 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1217,7 +1217,7 @@ xfs_bmap_local_to_extents_init_fn(
 {
 	bp->b_ops = &xfs_bmbt_buf_ops;
 	memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_BTREE_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
 }
 
 STATIC void
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index a7c19e9..a613294 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1227,7 +1227,7 @@ xfs_btree_log_keys(
 	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
 
 	if (bp) {
-		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLF_BTREE_BUF);
+		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
 		xfs_trans_log_buf(cur->bc_tp, bp,
 				  xfs_btree_key_offset(cur, first),
 				  xfs_btree_key_offset(cur, last + 1) - 1);
@@ -1252,7 +1252,7 @@ xfs_btree_log_recs(
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
 	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
 
-	xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLF_BTREE_BUF);
+	xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
 	xfs_trans_log_buf(cur->bc_tp, bp,
 			  xfs_btree_rec_offset(cur, first),
 			  xfs_btree_rec_offset(cur, last + 1) - 1);
@@ -1277,7 +1277,7 @@ xfs_btree_log_ptrs(
 		struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 		int			level = xfs_btree_get_level(block);
 
-		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLF_BTREE_BUF);
+		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
 		xfs_trans_log_buf(cur->bc_tp, bp,
 				xfs_btree_ptr_offset(cur, first, level),
 				xfs_btree_ptr_offset(cur, last + 1, level) - 1);
@@ -1352,7 +1352,7 @@ xfs_btree_log_block(
 				  (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
 					loffsets : soffsets,
 				  nbits, &first, &last);
-		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLF_BTREE_BUF);
+		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
 		xfs_trans_log_buf(cur->bc_tp, bp, first, last);
 	} else {
 		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index ef443ae..a76962d 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -290,15 +290,15 @@ xfs_da3_node_read(
 		switch (be16_to_cpu(info->magic)) {
 		case XFS_DA3_NODE_MAGIC:
 		case XFS_DA_NODE_MAGIC:
-			type = XFS_BLF_DA_NODE_BUF;
+			type = XFS_BLFT_DA_NODE_BUF;
 			break;
 		case XFS_ATTR_LEAF_MAGIC:
 		case XFS_ATTR3_LEAF_MAGIC:
-			type = XFS_BLF_ATTR_LEAF_BUF;
+			type = XFS_BLFT_ATTR_LEAF_BUF;
 			break;
 		case XFS_DIR2_LEAFN_MAGIC:
 		case XFS_DIR3_LEAFN_MAGIC:
-			type = XFS_BLF_DIR_LEAFN_BUF;
+			type = XFS_BLFT_DIR_LEAFN_BUF;
 			break;
 		default:
 			type = 0;
@@ -339,7 +339,7 @@ xfs_da3_node_create(
 	if (error)
 		return(error);
 	bp->b_ops = &xfs_da3_node_buf_ops;
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DA_NODE_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
 	node = bp->b_addr;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
@@ -573,7 +573,7 @@ xfs_da3_root_split(
 		 * we are about to copy oldroot to bp, so set up the type
 		 * of bp while we know exactly what it will be.
 		 */
-		xfs_trans_buf_set_type(tp, bp, XFS_BLF_DA_NODE_BUF);
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
 	} else {
 		struct xfs_dir3_icleaf_hdr leafhdr;
 		struct xfs_dir2_leaf_entry *ents;
@@ -591,7 +591,7 @@ xfs_da3_root_split(
 		 * we are about to copy oldroot to bp, so set up the type
 		 * of bp while we know exactly what it will be.
 		 */
-		xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_LEAFN_BUF);
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_LEAFN_BUF);
 	}
 
 	/*
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 574e414..dc69394 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -119,7 +119,7 @@ xfs_dir3_block_read(
 	err = xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, bpp,
 				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
 	if (!err && tp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_BLOCK_BUF);
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
 	return err;
 }
 
@@ -133,7 +133,7 @@ xfs_dir3_block_init(
 	struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
 	bp->b_ops = &xfs_dir3_block_buf_ops;
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_BLOCK_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_BLOCK_BUF);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		memset(hdr3, 0, sizeof(*hdr3));
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 9752ae3..155352c 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -288,7 +288,7 @@ xfs_dir3_data_read(
 	err = xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_data_buf_ops);
 	if (!err && tp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_DATA_BUF);
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
 	return err;
 }
 
@@ -558,7 +558,7 @@ xfs_dir3_data_init(
 	if (error)
 		return error;
 	bp->b_ops = &xfs_dir3_data_buf_ops;
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_DATA_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_DATA_BUF);
 
 	/*
 	 * Initialize the header.
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 3d1ec23..a287bb1 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -284,7 +284,7 @@ xfs_dir3_leaf_read(
 	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_leaf1_buf_ops);
 	if (!err && tp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_LEAF1_BUF);
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAF1_BUF);
 	return err;
 }
 
@@ -301,7 +301,7 @@ xfs_dir3_leafn_read(
 	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_leafn_buf_ops);
 	if (!err && tp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_LEAFN_BUF);
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAFN_BUF);
 	return err;
 }
 
@@ -346,10 +346,10 @@ xfs_dir3_leaf_init(
 		ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 		ltp->bestcount = 0;
 		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
-		xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_LEAF1_BUF);
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_LEAF1_BUF);
 	} else {
 		bp->b_ops = &xfs_dir3_leafn_buf_ops;
-		xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_LEAFN_BUF);
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_LEAFN_BUF);
 	}
 }
 
@@ -470,7 +470,7 @@ xfs_dir2_block_to_leaf(
 	 * Fix up the block header, make it a data block.
 	 */
 	dbp->b_ops = &xfs_dir3_data_buf_ops;
-	xfs_trans_buf_set_type(tp, dbp, XFS_BLF_DIR_DATA_BUF);
+	xfs_trans_buf_set_type(tp, dbp, XFS_BLFT_DIR_DATA_BUF);
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
 		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 	else
@@ -1791,7 +1791,7 @@ xfs_dir2_node_to_leaf(
 		xfs_dir3_leaf_compact(args, &leafhdr, lbp);
 
 	lbp->b_ops = &xfs_dir3_leaf1_buf_ops;
-	xfs_trans_buf_set_type(tp, lbp, XFS_BLF_DIR_LEAF1_BUF);
+	xfs_trans_buf_set_type(tp, lbp, XFS_BLFT_DIR_LEAF1_BUF);
 	leafhdr.magic = (leafhdr.magic == XFS_DIR2_LEAFN_MAGIC)
 					? XFS_DIR2_LEAF1_MAGIC
 					: XFS_DIR3_LEAF1_MAGIC;
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index a88049b..be955bf 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -151,7 +151,7 @@ __xfs_dir3_free_read(
 
 	/* try read returns without an error or *bpp if it lands in a hole */
 	if (!err && tp && *bpp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_FREE_BUF);
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_FREE_BUF);
 	return err;
 }
 
@@ -239,7 +239,7 @@ xfs_dir3_free_get_buf(
 	if (error)
 		return error;
 
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_FREE_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_FREE_BUF);
 	bp->b_ops = &xfs_dir3_free_buf_ops;
 
 	/*
@@ -388,7 +388,7 @@ xfs_dir2_leaf_to_node(
 	else
 		leaf->hdr.info.magic = cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
 	lbp->b_ops = &xfs_dir3_leafn_buf_ops;
-	xfs_trans_buf_set_type(tp, lbp, XFS_BLF_DIR_LEAFN_BUF);
+	xfs_trans_buf_set_type(tp, lbp, XFS_BLFT_DIR_LEAFN_BUF);
 	xfs_dir3_leaf_log_header(tp, lbp);
 	xfs_dir3_leaf_check(mp, lbp);
 	return 0;
@@ -804,7 +804,7 @@ xfs_dir2_leafn_lookup_for_entry(
 							(char *)curbp->b_addr);
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
 			curbp->b_ops = &xfs_dir3_data_buf_ops;
-			xfs_trans_buf_set_type(tp, curbp, XFS_BLF_DIR_DATA_BUF);
+			xfs_trans_buf_set_type(tp, curbp, XFS_BLFT_DIR_DATA_BUF);
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 		}
@@ -819,7 +819,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			state->extrablk.blkno = curdb;
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
 			curbp->b_ops = &xfs_dir3_data_buf_ops;
-			xfs_trans_buf_set_type(tp, curbp, XFS_BLF_DIR_DATA_BUF);
+			xfs_trans_buf_set_type(tp, curbp, XFS_BLFT_DIR_DATA_BUF);
 		} else {
 			/* If the curbp is not the CI match block, drop it */
 			if (state->extrablk.bp != curbp)
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 57fbae2..76fdcea 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1286,7 +1286,7 @@ xfs_ialloc_log_agi(
 	/*
 	 * Log the allocation group inode header buffer.
 	 */
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_AGI_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_AGI_BUF);
 	xfs_trans_log_buf(tp, bp, first, last);
 }
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
