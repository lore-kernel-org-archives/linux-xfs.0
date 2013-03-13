Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7F0EC7F37
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 20:34:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B3BE8F8033
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 18:34:25 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	o5BvhgGawN3RSUSt for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 18:34:22 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UFaaB-0003E4-Cn
	for xfs@oss.sgi.com; Wed, 13 Mar 2013 12:34:19 +1100
Date: Wed, 13 Mar 2013 12:34:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 24/21] xfs: buffer type overruns blf_flags field
Message-ID: <20130313013419.GT21651@dastard>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363091454-8852-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The buffer type passed to log recvoery in the buffer log item
overruns the blf_flags field. I had assumed that flags field was a
32 bit value, and it turns out it is a unsigned short. Therefore
having 19 flags doesn't really work.

Convert the buffer type field to numeric value, and use the top 5
bits of the flags field for it. We currently have 17 types of
buffers, so using 5 bits gives us plenty of room for expansion in
future....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---

Found by sparse, indicating a value too large being placed into a
16 bit word.

 fs/xfs/xfs_alloc.c       |    4 +--
 fs/xfs/xfs_attr_leaf.c   |    6 ++--
 fs/xfs/xfs_bmap.c        |    2 +-
 fs/xfs/xfs_btree.c       |    8 ++---
 fs/xfs/xfs_buf_item.h    |   90 +++++++++++++++++++++++++---------------------
 fs/xfs/xfs_da_btree.c    |   12 +++----
 fs/xfs/xfs_dir2_block.c  |    4 +--
 fs/xfs/xfs_dir2_data.c   |    4 +--
 fs/xfs/xfs_dir2_leaf.c   |   12 +++----
 fs/xfs/xfs_dir2_node.c   |   10 +++---
 fs/xfs/xfs_ialloc.c      |    2 +-
 fs/xfs/xfs_log_recover.c |   40 +++++++++++----------
 fs/xfs/xfs_mount.c       |    2 +-
 fs/xfs/xfs_trans_buf.c   |   42 +++++++++++++++-------
 14 files changed, 132 insertions(+), 106 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 40d3d57..5673bcf 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2099,7 +2099,7 @@ xfs_alloc_log_agf(
 
 	trace_xfs_agf(tp->t_mountp, XFS_BUF_TO_AGF(bp), fields, _RET_IP_);
 
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_AGF_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_AGF_BUF);
 
 	xfs_btree_offsets(fields, offsets, XFS_AGF_NUM_BITS, &first, &last);
 	xfs_trans_log_buf(tp, bp, (uint)first, (uint)last);
@@ -2179,7 +2179,7 @@ xfs_alloc_put_freelist(
 
 	xfs_alloc_log_agf(tp, agbp, logflags);
 
-	xfs_trans_buf_set_type(tp, agflbp, XFS_BLF_AGFL_BUF);
+	xfs_trans_buf_set_type(tp, agflbp, XFS_BLFT_AGFL_BUF);
 	xfs_trans_log_buf(tp, agflbp, startoff,
 			  startoff + sizeof(xfs_agblock_t) - 1);
 	return 0;
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 7feaf3c..5e708dc 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -276,7 +276,7 @@ xfs_attr3_leaf_read(
 	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
 				XFS_ATTR_FORK, &xfs_attr3_leaf_buf_ops);
 	if (!err && tp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_ATTR_LEAF_BUF);
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_ATTR_LEAF_BUF);
 	return err;
 }
 
@@ -1083,7 +1083,7 @@ xfs_attr3_leaf_to_node(
 		goto out;
 
 	/* copy leaf to new buffer, update identifiers */
-	xfs_trans_buf_set_type(args->trans, bp2, XFS_BLF_ATTR_LEAF_BUF);
+	xfs_trans_buf_set_type(args->trans, bp2, XFS_BLFT_ATTR_LEAF_BUF);
 	bp2->b_ops = bp1->b_ops;
 	memcpy(bp2->b_addr, bp1->b_addr, XFS_LBSIZE(mp));
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
@@ -1146,7 +1146,7 @@ xfs_attr3_leaf_create(
 	if (error)
 		return error;
 	bp->b_ops = &xfs_attr3_leaf_buf_ops;
-	xfs_trans_buf_set_type(args->trans, bp, XFS_BLF_ATTR_LEAF_BUF);
+	xfs_trans_buf_set_type(args->trans, bp, XFS_BLFT_ATTR_LEAF_BUF);
 	leaf = bp->b_addr;
 	memset(leaf, 0, XFS_LBSIZE(mp));
 
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 2844724..8904284 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1338,7 +1338,7 @@ xfs_bmap_local_to_extents_init_fn(
 	ASSERT(0);
 	bp->b_ops = &xfs_bmbt_buf_ops;
 	memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_BTREE_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
 }
 
 /*
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index ec77036..8804b8a 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -1282,7 +1282,7 @@ xfs_btree_log_keys(
 	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
 
 	if (bp) {
-		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLF_BTREE_BUF);
+		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
 		xfs_trans_log_buf(cur->bc_tp, bp,
 				  xfs_btree_key_offset(cur, first),
 				  xfs_btree_key_offset(cur, last + 1) - 1);
@@ -1307,7 +1307,7 @@ xfs_btree_log_recs(
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
 	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
 
-	xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLF_BTREE_BUF);
+	xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
 	xfs_trans_log_buf(cur->bc_tp, bp,
 			  xfs_btree_rec_offset(cur, first),
 			  xfs_btree_rec_offset(cur, last + 1) - 1);
@@ -1332,7 +1332,7 @@ xfs_btree_log_ptrs(
 		struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 		int			level = xfs_btree_get_level(block);
 
-		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLF_BTREE_BUF);
+		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
 		xfs_trans_log_buf(cur->bc_tp, bp,
 				xfs_btree_ptr_offset(cur, first, level),
 				xfs_btree_ptr_offset(cur, last + 1, level) - 1);
@@ -1407,7 +1407,7 @@ xfs_btree_log_block(
 				  (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
 					loffsets : soffsets,
 				  nbits, &first, &last);
-		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLF_BTREE_BUF);
+		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
 		xfs_trans_log_buf(cur->bc_tp, bp, first, last);
 	} else {
 		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index ed259a1..0c8559f 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -39,47 +39,6 @@ extern kmem_zone_t	*xfs_buf_item_zone;
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
-#define XFS_BLF_SB_BUF		(1<<19)
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
-		 XFS_BLF_ATTR_RMT_BUF | \
-		 XFS_BLF_SB_BUF)
-
 #define	XFS_BLF_CHUNK		128
 #define	XFS_BLF_SHIFT		7
 #define	BIT_TO_WORD_SHIFT	5
@@ -103,6 +62,55 @@ typedef struct xfs_buf_log_format {
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
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index a78865e..504e58f 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -312,15 +312,15 @@ xfs_da3_node_read(
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
@@ -361,7 +361,7 @@ xfs_da3_node_create(
 	if (error)
 		return(error);
 	bp->b_ops = &xfs_da3_node_buf_ops;
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DA_NODE_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
 	node = bp->b_addr;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
@@ -595,7 +595,7 @@ xfs_da3_root_split(
 		 * we are about to copy oldroot to bp, so set up the type
 		 * of bp while we know exactly what it will be.
 		 */
-		xfs_trans_buf_set_type(tp, bp, XFS_BLF_DA_NODE_BUF);
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
 	} else {
 		struct xfs_dir3_icleaf_hdr leafhdr;
 		struct xfs_dir2_leaf_entry *ents;
@@ -613,7 +613,7 @@ xfs_da3_root_split(
 		 * we are about to copy oldroot to bp, so set up the type
 		 * of bp while we know exactly what it will be.
 		 */
-		xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_LEAFN_BUF);
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_LEAFN_BUF);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 58816ec..e59f5fc 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -137,7 +137,7 @@ xfs_dir3_block_read(
 	err = xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, bpp,
 				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
 	if (!err && tp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_BLOCK_BUF);
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
 	return err;
 }
 
@@ -151,7 +151,7 @@ xfs_dir3_block_init(
 	struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
 	bp->b_ops = &xfs_dir3_block_buf_ops;
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_BLOCK_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_BLOCK_BUF);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		memset(hdr3, 0, sizeof(*hdr3));
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 5e0c711..c293023 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -306,7 +306,7 @@ xfs_dir3_data_read(
 	err = xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_data_buf_ops);
 	if (!err && tp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_DATA_BUF);
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
 	return err;
 }
 
@@ -576,7 +576,7 @@ xfs_dir3_data_init(
 	if (error)
 		return error;
 	bp->b_ops = &xfs_dir3_data_buf_ops;
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_DATA_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_DATA_BUF);
 
 	/*
 	 * Initialize the header.
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 9bf588c..9ba2ade 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -300,7 +300,7 @@ xfs_dir3_leaf_read(
 	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_leaf1_buf_ops);
 	if (!err && tp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_LEAF1_BUF);
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAF1_BUF);
 	return err;
 }
 
@@ -317,7 +317,7 @@ xfs_dir3_leafn_read(
 	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_leafn_buf_ops);
 	if (!err && tp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_LEAFN_BUF);
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAFN_BUF);
 	return err;
 }
 
@@ -362,10 +362,10 @@ xfs_dir3_leaf_init(
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
 
@@ -487,7 +487,7 @@ xfs_dir2_block_to_leaf(
 	 * Fix up the block header, make it a data block.
 	 */
 	dbp->b_ops = &xfs_dir3_data_buf_ops;
-	xfs_trans_buf_set_type(tp, dbp, XFS_BLF_DIR_DATA_BUF);
+	xfs_trans_buf_set_type(tp, dbp, XFS_BLFT_DIR_DATA_BUF);
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
 		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 	else
@@ -2196,7 +2196,7 @@ xfs_dir2_node_to_leaf(
 		xfs_dir3_leaf_compact(args, &leafhdr, lbp);
 
 	lbp->b_ops = &xfs_dir3_leaf1_buf_ops;
-	xfs_trans_buf_set_type(tp, lbp, XFS_BLF_DIR_LEAF1_BUF);
+	xfs_trans_buf_set_type(tp, lbp, XFS_BLFT_DIR_LEAF1_BUF);
 	leafhdr.magic = (leafhdr.magic == XFS_DIR2_LEAFN_MAGIC)
 					? XFS_DIR2_LEAF1_MAGIC
 					: XFS_DIR3_LEAF1_MAGIC;
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 9e542e7..9b0634d 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -165,7 +165,7 @@ __xfs_dir3_free_read(
 
 	/* try read returns without an error or *bpp if it lands in a hole */
 	if (!err && tp && *bpp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_FREE_BUF);
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_FREE_BUF);
 	return err;
 }
 
@@ -253,7 +253,7 @@ xfs_dir3_free_get_buf(
 	if (error)
 		return error;
 
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_FREE_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_FREE_BUF);
 	bp->b_ops = &xfs_dir3_free_buf_ops;;
 
 	/*
@@ -402,7 +402,7 @@ xfs_dir2_leaf_to_node(
 	else
 		leaf->hdr.info.magic = cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
 	lbp->b_ops = &xfs_dir3_leafn_buf_ops;
-	xfs_trans_buf_set_type(tp, lbp, XFS_BLF_DIR_LEAFN_BUF);
+	xfs_trans_buf_set_type(tp, lbp, XFS_BLFT_DIR_LEAFN_BUF);
 	xfs_dir3_leaf_log_header(tp, lbp);
 	xfs_dir3_leaf_check(mp, lbp);
 	return 0;
@@ -814,7 +814,7 @@ xfs_dir2_leafn_lookup_for_entry(
 							(char *)curbp->b_addr);
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
 			curbp->b_ops = &xfs_dir3_data_buf_ops;
-			xfs_trans_buf_set_type(tp, curbp, XFS_BLF_DIR_DATA_BUF);
+			xfs_trans_buf_set_type(tp, curbp, XFS_BLFT_DIR_DATA_BUF);
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 		}
@@ -829,7 +829,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			state->extrablk.blkno = curdb;
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
 			curbp->b_ops = &xfs_dir3_data_buf_ops;
-			xfs_trans_buf_set_type(tp, curbp, XFS_BLF_DIR_DATA_BUF);
+			xfs_trans_buf_set_type(tp, curbp, XFS_BLFT_DIR_DATA_BUF);
 		} else {
 			/* If the curbp is not the CI match block, drop it */
 			if (state->extrablk.bp != curbp)
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 8ceaa11..d82071d 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1474,7 +1474,7 @@ xfs_ialloc_log_agi(
 	/*
 	 * Log the allocation group inode header buffer.
 	 */
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_AGI_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_AGI_BUF);
 	xfs_trans_log_buf(tp, bp, first, last);
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6410d43..c686bff 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1888,8 +1888,8 @@ xlog_recovery_validate_buf_type(
 	magic32 = be32_to_cpu(*(__be32 *)bp->b_addr);
 	magic16 = be16_to_cpu(*(__be16*)bp->b_addr);
 	magicda = be16_to_cpu(info->magic);
-	switch (buf_f->blf_flags & XFS_BLF_TYPE_MASK) {
-	case XFS_BLF_BTREE_BUF:
+	switch (xfs_blft_from_flags(buf_f)) {
+	case XFS_BLFT_BTREE_BUF:
 		switch (magic32) {
 		case XFS_ABTB_CRC_MAGIC:
 		case XFS_ABTC_CRC_MAGIC:
@@ -1911,7 +1911,7 @@ xlog_recovery_validate_buf_type(
 			break;
 		}
 		break;
-	case XFS_BLF_AGF_BUF:
+	case XFS_BLFT_AGF_BUF:
 		if (magic32 != XFS_AGF_MAGIC) {
 			xfs_warn(mp, "Bad AGF block magic!");
 			ASSERT(0);
@@ -1919,7 +1919,7 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_agf_buf_ops;
 		break;
-	case XFS_BLF_AGFL_BUF:
+	case XFS_BLFT_AGFL_BUF:
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			break;
 		if (magic32 != XFS_AGFL_MAGIC) {
@@ -1929,7 +1929,7 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_agfl_buf_ops;
 		break;
-	case XFS_BLF_AGI_BUF:
+	case XFS_BLFT_AGI_BUF:
 		if (magic32 != XFS_AGI_MAGIC) {
 			xfs_warn(mp, "Bad AGI block magic!");
 			ASSERT(0);
@@ -1937,9 +1937,9 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_agi_buf_ops;
 		break;
-	case XFS_BLF_UDQUOT_BUF:
-	case XFS_BLF_PDQUOT_BUF:
-	case XFS_BLF_GDQUOT_BUF:
+	case XFS_BLFT_UDQUOT_BUF:
+	case XFS_BLFT_PDQUOT_BUF:
+	case XFS_BLFT_GDQUOT_BUF:
 		if (magic16 != XFS_DQUOT_MAGIC) {
 			xfs_warn(mp, "Bad DQUOT block magic!");
 			ASSERT(0);
@@ -1947,7 +1947,7 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_dquot_buf_ops;
 		break;
-	case XFS_BLF_DINO_BUF:
+	case XFS_BLFT_DINO_BUF:
 		/*
 		 * we get here with inode allocation buffers, not buffers that
 		 * track unlinked list changes.
@@ -1959,7 +1959,7 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_inode_buf_ops;
 		break;
-	case XFS_BLF_SYMLINK_BUF:
+	case XFS_BLFT_SYMLINK_BUF:
 		if (magic32 != XFS_SYMLINK_MAGIC) {
 			xfs_warn(mp, "Bad symlink block magic!");
 			ASSERT(0);
@@ -1967,7 +1967,7 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_symlink_buf_ops;
 		break;
-	case XFS_BLF_DIR_BLOCK_BUF:
+	case XFS_BLFT_DIR_BLOCK_BUF:
 		if (magic32 != XFS_DIR2_BLOCK_MAGIC &&
 		    magic32 != XFS_DIR3_BLOCK_MAGIC) {
 			xfs_warn(mp, "Bad dir block magic!");
@@ -1976,7 +1976,7 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_dir3_block_buf_ops;
 		break;
-	case XFS_BLF_DIR_DATA_BUF:
+	case XFS_BLFT_DIR_DATA_BUF:
 		if (magic32 != XFS_DIR2_DATA_MAGIC &&
 		    magic32 != XFS_DIR3_DATA_MAGIC) {
 			xfs_warn(mp, "Bad dir data magic!");
@@ -1985,7 +1985,7 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_dir3_data_buf_ops;
 		break;
-	case XFS_BLF_DIR_FREE_BUF:
+	case XFS_BLFT_DIR_FREE_BUF:
 		if (magic32 != XFS_DIR2_FREE_MAGIC &&
 		    magic32 != XFS_DIR3_FREE_MAGIC) {
 			xfs_warn(mp, "Bad dir3 free magic!");
@@ -1994,7 +1994,7 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_dir3_free_buf_ops;
 		break;
-	case XFS_BLF_DIR_LEAF1_BUF:
+	case XFS_BLFT_DIR_LEAF1_BUF:
 		if (magicda != XFS_DIR2_LEAF1_MAGIC &&
 		    magicda != XFS_DIR3_LEAF1_MAGIC) {
 			xfs_warn(mp, "Bad dir leaf1 magic!");
@@ -2003,7 +2003,7 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
 		break;
-	case XFS_BLF_DIR_LEAFN_BUF:
+	case XFS_BLFT_DIR_LEAFN_BUF:
 		if (magicda != XFS_DIR2_LEAFN_MAGIC &&
 		    magicda != XFS_DIR3_LEAFN_MAGIC) {
 			xfs_warn(mp, "Bad dir leafn magic!");
@@ -2012,7 +2012,7 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_dir3_leafn_buf_ops;
 		break;
-	case XFS_BLF_DA_NODE_BUF:
+	case XFS_BLFT_DA_NODE_BUF:
 		if (magicda != XFS_DA_NODE_MAGIC &&
 		    magicda != XFS_DA3_NODE_MAGIC) {
 			xfs_warn(mp, "Bad da node magic!");
@@ -2021,7 +2021,7 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_da3_node_buf_ops;
 		break;
-	case XFS_BLF_ATTR_LEAF_BUF:
+	case XFS_BLFT_ATTR_LEAF_BUF:
 		if (magicda != XFS_ATTR_LEAF_MAGIC &&
 		    magicda != XFS_ATTR3_LEAF_MAGIC) {
 			xfs_warn(mp, "Bad attr leaf magic!");
@@ -2030,7 +2030,7 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_attr3_leaf_buf_ops;
 		break;
-	case XFS_BLF_ATTR_RMT_BUF:
+	case XFS_BLFT_ATTR_RMT_BUF:
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			break;
 		if (magicda != XFS_ATTR3_RMT_MAGIC) {
@@ -2040,7 +2040,7 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
 		break;
-	case XFS_BLF_SB_BUF:
+	case XFS_BLFT_SB_BUF:
 		if (magic32 != XFS_SB_MAGIC) {
 			xfs_warn(mp, "Bad SB block magic!");
 			ASSERT(0);
@@ -2049,6 +2049,8 @@ xlog_recovery_validate_buf_type(
 		bp->b_ops = &xfs_sb_buf_ops;
 		break;
 	default:
+		xfs_warn(mp, "Unknown buffer type %d!",
+			 xfs_blft_from_flags(buf_f));
 		break;
 	}
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index cbef607..562ae16 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1696,7 +1696,7 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
 	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
 	first = xfs_sb_info[f].offset;
 
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_SB_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(tp, bp, first, last);
 }
 
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 40871bf..73a5fa4 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -659,7 +659,7 @@ xfs_trans_binval(
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		ASSERT(!(bip->bli_flags & (XFS_BLI_LOGGED | XFS_BLI_DIRTY)));
 		ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_INODE_BUF));
-		ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_TYPE_MASK));
+		ASSERT(!(bip->__bli_format.blf_flags & XFS_BLFT_MASK));
 		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
 		ASSERT(bip->bli_item.li_desc->lid_flags & XFS_LID_DIRTY);
 		ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
@@ -672,7 +672,7 @@ xfs_trans_binval(
 	bip->bli_flags &= ~(XFS_BLI_INODE_BUF | XFS_BLI_LOGGED | XFS_BLI_DIRTY);
 	bip->__bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
 	bip->__bli_format.blf_flags |= XFS_BLF_CANCEL;
-	bip->__bli_format.blf_flags &= ~XFS_BLF_TYPE_MASK;
+	bip->__bli_format.blf_flags &= ~XFS_BLFT_MASK;
 	for (i = 0; i < bip->bli_format_count; i++) {
 		memset(bip->bli_formats[i].blf_data_map, 0,
 		       (bip->bli_formats[i].blf_map_size * sizeof(uint)));
@@ -704,7 +704,7 @@ xfs_trans_inode_buf(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_INODE_BUF;
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DINO_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
 }
 
 /*
@@ -729,7 +729,7 @@ xfs_trans_stale_inode_buf(
 
 	bip->bli_flags |= XFS_BLI_STALE_INODE;
 	bip->bli_item.li_cb = xfs_buf_iodone;
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DINO_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
 }
 
 /*
@@ -753,7 +753,7 @@ xfs_trans_inode_alloc_buf(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
-	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DINO_BUF);
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
 }
 
 /*
@@ -764,7 +764,7 @@ void
 xfs_trans_buf_set_type(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp,
-	uint			type)
+	enum xfs_blft		type)
 {
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
@@ -774,10 +774,8 @@ xfs_trans_buf_set_type(
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
-	ASSERT((type & XFS_BLF_TYPE_MASK) != 0);
 
-	bip->__bli_format.blf_flags &= ~XFS_BLF_TYPE_MASK;
-	bip->__bli_format.blf_flags |= type;
+	xfs_blft_to_flags(&bip->__bli_format, type);
 }
 
 void
@@ -787,11 +785,10 @@ xfs_trans_buf_copy_type(
 {
 	struct xfs_buf_log_item	*sbip = src_bp->b_fspriv;
 	struct xfs_buf_log_item	*dbip = dst_bp->b_fspriv;
-	uint			type;
+	enum xfs_blft		type;
 
-	type = sbip->__bli_format.blf_flags & XFS_BLF_TYPE_MASK;
-	dbip->__bli_format.blf_flags &= ~XFS_BLF_TYPE_MASK;
-	dbip->__bli_format.blf_flags |= type;
+	type = xfs_blft_from_flags(&sbip->__bli_format);
+	xfs_blft_to_flags(&dbip->__bli_format, type);
 }
 
 /*
@@ -811,9 +808,28 @@ xfs_trans_dquot_buf(
 	xfs_buf_t	*bp,
 	uint		type)
 {
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+
 	ASSERT(type == XFS_BLF_UDQUOT_BUF ||
 	       type == XFS_BLF_PDQUOT_BUF ||
 	       type == XFS_BLF_GDQUOT_BUF);
 
+	bip->__bli_format.blf_flags |= type;
+
+	switch (type) {
+	case XFS_BLF_UDQUOT_BUF:
+		type = XFS_BLFT_UDQUOT_BUF;
+		break;
+	case XFS_BLF_PDQUOT_BUF:
+		type = XFS_BLFT_PDQUOT_BUF;
+		break;
+	case XFS_BLF_GDQUOT_BUF:
+		type = XFS_BLFT_GDQUOT_BUF;
+		break;
+	default:
+		type = XFS_BLFT_UNKNOWN_BUF;
+		break;
+	}
+
 	xfs_trans_buf_set_type(tp, bp, type);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
