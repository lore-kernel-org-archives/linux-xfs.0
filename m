Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1EF1829E06
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 06:13:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0B784304059
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 04:13:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lN5cK4YrHT3jEJp0 for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 04:13:56 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UdIbX-0008SN-HU
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:43 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UdIbX-0005F5-7z
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 18/30] xfs: add buffer types to directory and attribute buffers
Date: Fri, 17 May 2013 21:13:13 +1000
Message-Id: <1368789205-19969-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1368789205-19969-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
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

Add buffer types to the buffer log items so that log recovery can
validate the buffers and calculate CRCs correctly after the buffers
are recovered.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_attr_remote.h |    2 ++
 include/xfs_buf_item.h    |   18 +++++++++++++++++-
 include/xfs_da_btree.h    |    2 ++
 include/xfs_trans.h       |    2 ++
 libxfs/xfs.h              |    1 +
 libxfs/xfs_attr_leaf.c    |    9 ++++++++-
 libxfs/xfs_da_btree.c     |   46 ++++++++++++++++++++++++++++++++++++++++++---
 libxfs/xfs_dir2_block.c   |   12 +++++++++---
 libxfs/xfs_dir2_data.c    |    8 +++++++-
 libxfs/xfs_dir2_leaf.c    |   24 +++++++++++++++++++----
 libxfs/xfs_dir2_node.c    |   17 ++++++++++++++---
 libxfs/xfs_dir2_priv.h    |    2 ++
 12 files changed, 127 insertions(+), 16 deletions(-)

diff --git a/include/xfs_attr_remote.h b/include/xfs_attr_remote.h
index 9e71edf..28f6f10 100644
--- a/include/xfs_attr_remote.h
+++ b/include/xfs_attr_remote.h
@@ -43,6 +43,8 @@ struct xfs_attr3_rmt_hdr {
 	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
 			sizeof(struct xfs_attr3_rmt_hdr) : 0))
 
+extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
+
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
diff --git a/include/xfs_buf_item.h b/include/xfs_buf_item.h
index 09cab4e..640adcf 100644
--- a/include/xfs_buf_item.h
+++ b/include/xfs_buf_item.h
@@ -50,6 +50,14 @@ extern kmem_zone_t	*xfs_buf_item_zone;
 #define XFS_BLF_AGI_BUF		(1<<8)
 #define XFS_BLF_DINO_BUF	(1<<9)
 #define XFS_BLF_SYMLINK_BUF	(1<<10)
+#define XFS_BLF_DIR_BLOCK_BUF	(1<<11)
+#define XFS_BLF_DIR_DATA_BUF	(1<<12)
+#define XFS_BLF_DIR_FREE_BUF	(1<<13)
+#define XFS_BLF_DIR_LEAF1_BUF	(1<<14)
+#define XFS_BLF_DIR_LEAFN_BUF	(1<<15)
+#define XFS_BLF_DA_NODE_BUF	(1<<16)
+#define XFS_BLF_ATTR_LEAF_BUF	(1<<17)
+#define XFS_BLF_ATTR_RMT_BUF	(1<<18)
 
 #define XFS_BLF_TYPE_MASK	\
 		(XFS_BLF_UDQUOT_BUF | \
@@ -60,7 +68,15 @@ extern kmem_zone_t	*xfs_buf_item_zone;
 		 XFS_BLF_AGFL_BUF | \
 		 XFS_BLF_AGI_BUF | \
 		 XFS_BLF_DINO_BUF | \
-		 XFS_BLF_SYMLINK_BUF)
+		 XFS_BLF_SYMLINK_BUF | \
+		 XFS_BLF_DIR_BLOCK_BUF | \
+		 XFS_BLF_DIR_DATA_BUF | \
+		 XFS_BLF_DIR_FREE_BUF | \
+		 XFS_BLF_DIR_LEAF1_BUF | \
+		 XFS_BLF_DIR_LEAFN_BUF | \
+		 XFS_BLF_DA_NODE_BUF | \
+		 XFS_BLF_ATTR_LEAF_BUF | \
+		 XFS_BLF_ATTR_RMT_BUF)
 
 #define	XFS_BLF_CHUNK		128
 #define	XFS_BLF_SHIFT		7
diff --git a/include/xfs_da_btree.h b/include/xfs_da_btree.h
index 0e8182c..6fb3371 100644
--- a/include/xfs_da_btree.h
+++ b/include/xfs_da_btree.h
@@ -301,6 +301,8 @@ int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			 xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			 struct xfs_buf **bpp, int which_fork);
 
+extern const struct xfs_buf_ops xfs_da3_node_buf_ops;
+
 /*
  * Utility routines.
  */
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index a9bd826..9e145e9 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -502,6 +502,8 @@ void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
 				       uint);
+void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
+					struct xfs_buf *src_bp);
 void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index c69dc4a..6bec18e 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -255,6 +255,7 @@ roundup_pow_of_two(uint v)
 #define	xfs_trans_agflist_delta(tp, d)
 #define	xfs_trans_agbtree_delta(tp, d)
 #define xfs_trans_buf_set_type(tp, bp, t)
+#define xfs_trans_buf_copy_type(dbp, sbp)
 
 #define xfs_buf_readahead(a,b,c,ops)		((void) 0)	/* no readahead */
 #define xfs_buf_readahead_map(a,b,c,ops)	((void) 0)	/* no readahead */
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 9de2244..7724781 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -236,8 +236,13 @@ xfs_attr3_leaf_read(
 	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp)
 {
-	return xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
+	int			err;
+
+	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
 				XFS_ATTR_FORK, &xfs_attr3_leaf_buf_ops);
+	if (!err && tp)
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_ATTR_LEAF_BUF);
+	return err;
 }
 
 /*========================================================================
@@ -867,6 +872,7 @@ xfs_attr3_leaf_to_node(
 		goto out;
 
 	/* copy leaf to new buffer, update identifiers */
+	xfs_trans_buf_set_type(args->trans, bp2, XFS_BLF_ATTR_LEAF_BUF);
 	bp2->b_ops = bp1->b_ops;
 	memcpy(bp2->b_addr, bp1->b_addr, XFS_LBSIZE(mp));
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
@@ -929,6 +935,7 @@ xfs_attr3_leaf_create(
 	if (error)
 		return error;
 	bp->b_ops = &xfs_attr3_leaf_buf_ops;
+	xfs_trans_buf_set_type(args->trans, bp, XFS_BLF_ATTR_LEAF_BUF);
 	leaf = bp->b_addr;
 	memset(leaf, 0, XFS_LBSIZE(mp));
 
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 5db94db..ef443ae 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -270,7 +270,6 @@ const struct xfs_buf_ops xfs_da3_node_buf_ops = {
 	.verify_write = xfs_da3_node_write_verify,
 };
 
-
 int
 xfs_da3_node_read(
 	struct xfs_trans	*tp,
@@ -280,8 +279,35 @@ xfs_da3_node_read(
 	struct xfs_buf		**bpp,
 	int			which_fork)
 {
-	return xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
+	int			err;
+
+	err = xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
 					which_fork, &xfs_da3_node_buf_ops);
+	if (!err && tp) {
+		struct xfs_da_blkinfo	*info = (*bpp)->b_addr;
+		int			type;
+
+		switch (be16_to_cpu(info->magic)) {
+		case XFS_DA3_NODE_MAGIC:
+		case XFS_DA_NODE_MAGIC:
+			type = XFS_BLF_DA_NODE_BUF;
+			break;
+		case XFS_ATTR_LEAF_MAGIC:
+		case XFS_ATTR3_LEAF_MAGIC:
+			type = XFS_BLF_ATTR_LEAF_BUF;
+			break;
+		case XFS_DIR2_LEAFN_MAGIC:
+		case XFS_DIR3_LEAFN_MAGIC:
+			type = XFS_BLF_DIR_LEAFN_BUF;
+			break;
+		default:
+			type = 0;
+			ASSERT(0);
+			break;
+		}
+		xfs_trans_buf_set_type(tp, *bpp, type);
+	}
+	return err;
 }
 
 /*========================================================================
@@ -312,6 +338,8 @@ xfs_da3_node_create(
 	error = xfs_da_get_buf(tp, args->dp, blkno, -1, &bp, whichfork);
 	if (error)
 		return(error);
+	bp->b_ops = &xfs_da3_node_buf_ops;
+	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DA_NODE_BUF);
 	node = bp->b_addr;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
@@ -330,7 +358,6 @@ xfs_da3_node_create(
 	xfs_trans_log_buf(tp, bp,
 		XFS_DA_LOGRANGE(node, &node->hdr, xfs_da3_node_hdr_size(node)));
 
-	bp->b_ops = &xfs_da3_node_buf_ops;
 	*bpp = bp;
 	return(0);
 }
@@ -541,6 +568,12 @@ xfs_da3_root_split(
 		btree = xfs_da3_node_tree_p(oldroot);
 		size = (int)((char *)&btree[nodehdr.count] - (char *)oldroot);
 		level = nodehdr.level;
+
+		/*
+		 * we are about to copy oldroot to bp, so set up the type
+		 * of bp while we know exactly what it will be.
+		 */
+		xfs_trans_buf_set_type(tp, bp, XFS_BLF_DA_NODE_BUF);
 	} else {
 		struct xfs_dir3_icleaf_hdr leafhdr;
 		struct xfs_dir2_leaf_entry *ents;
@@ -553,6 +586,12 @@ xfs_da3_root_split(
 		       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
 		size = (int)((char *)&ents[leafhdr.count] - (char *)leaf);
 		level = 0;
+
+		/*
+		 * we are about to copy oldroot to bp, so set up the type
+		 * of bp while we know exactly what it will be.
+		 */
+		xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_LEAFN_BUF);
 	}
 
 	/*
@@ -1068,6 +1107,7 @@ xfs_da3_root_join(
 	 */
 	memcpy(root_blk->bp->b_addr, bp->b_addr, state->blocksize);
 	root_blk->bp->b_ops = bp->b_ops;
+	xfs_trans_buf_copy_type(root_blk->bp, bp);
 	if (oldroothdr.magic == XFS_DA3_NODE_MAGIC) {
 		struct xfs_da3_blkinfo *da3 = root_blk->bp->b_addr;
 		da3->blkno = cpu_to_be64(root_blk->bp->b_bn);
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index b98b749..574e414 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -114,20 +114,26 @@ xfs_dir3_block_read(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	int			err;
 
-	return xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, bpp,
+	err = xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, bpp,
 				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
+	if (!err && tp)
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_BLOCK_BUF);
+	return err;
 }
 
 static void
 xfs_dir3_block_init(
 	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
 	struct xfs_buf		*bp,
 	struct xfs_inode	*dp)
 {
 	struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
 	bp->b_ops = &xfs_dir3_block_buf_ops;
+	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_BLOCK_BUF);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		memset(hdr3, 0, sizeof(*hdr3));
@@ -964,7 +970,7 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Start converting it to block form.
 	 */
-	xfs_dir3_block_init(mp, dbp, dp);
+	xfs_dir3_block_init(mp, tp, dbp, dp);
 
 	needlog = 1;
 	needscan = 0;
@@ -1093,7 +1099,7 @@ xfs_dir2_sf_to_block(
 		kmem_free(sfp);
 		return error;
 	}
-	xfs_dir3_block_init(mp, bp, dp);
+	xfs_dir3_block_init(mp, tp, bp, dp);
 	hdr = bp->b_addr;
 
 	/*
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 69841df..9752ae3 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -283,8 +283,13 @@ xfs_dir3_data_read(
 	xfs_daddr_t		mapped_bno,
 	struct xfs_buf		**bpp)
 {
-	return xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
+	int			err;
+
+	err = xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_data_buf_ops);
+	if (!err && tp)
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_DATA_BUF);
+	return err;
 }
 
 int
@@ -553,6 +558,7 @@ xfs_dir3_data_init(
 	if (error)
 		return error;
 	bp->b_ops = &xfs_dir3_data_buf_ops;
+	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_DATA_BUF);
 
 	/*
 	 * Initialize the header.
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index f00b23c..3d1ec23 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -279,8 +279,13 @@ xfs_dir3_leaf_read(
 	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp)
 {
-	return xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
+	int			err;
+
+	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_leaf1_buf_ops);
+	if (!err && tp)
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_LEAF1_BUF);
+	return err;
 }
 
 int
@@ -291,8 +296,13 @@ xfs_dir3_leafn_read(
 	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp)
 {
-	return xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
+	int			err;
+
+	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_leafn_buf_ops);
+	if (!err && tp)
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_LEAFN_BUF);
+	return err;
 }
 
 /*
@@ -301,6 +311,7 @@ xfs_dir3_leafn_read(
 static void
 xfs_dir3_leaf_init(
 	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
 	struct xfs_buf		*bp,
 	xfs_ino_t		owner,
 	__uint16_t		type)
@@ -335,8 +346,11 @@ xfs_dir3_leaf_init(
 		ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 		ltp->bestcount = 0;
 		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
-	} else
+		xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_LEAF1_BUF);
+	} else {
 		bp->b_ops = &xfs_dir3_leafn_buf_ops;
+		xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_LEAFN_BUF);
+	}
 }
 
 int
@@ -361,7 +375,7 @@ xfs_dir3_leaf_get_buf(
 	if (error)
 		return error;
 
-	xfs_dir3_leaf_init(mp, bp, dp->i_ino, magic);
+	xfs_dir3_leaf_init(mp, tp, bp, dp->i_ino, magic);
 	xfs_dir3_leaf_log_header(tp, bp);
 	if (magic == XFS_DIR2_LEAF1_MAGIC)
 		xfs_dir3_leaf_log_tail(tp, bp);
@@ -456,6 +470,7 @@ xfs_dir2_block_to_leaf(
 	 * Fix up the block header, make it a data block.
 	 */
 	dbp->b_ops = &xfs_dir3_data_buf_ops;
+	xfs_trans_buf_set_type(tp, dbp, XFS_BLF_DIR_DATA_BUF);
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
 		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 	else
@@ -1776,6 +1791,7 @@ xfs_dir2_node_to_leaf(
 		xfs_dir3_leaf_compact(args, &leafhdr, lbp);
 
 	lbp->b_ops = &xfs_dir3_leaf1_buf_ops;
+	xfs_trans_buf_set_type(tp, lbp, XFS_BLF_DIR_LEAF1_BUF);
 	leafhdr.magic = (leafhdr.magic == XFS_DIR2_LEAFN_MAGIC)
 					? XFS_DIR2_LEAF1_MAGIC
 					: XFS_DIR3_LEAF1_MAGIC;
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 9e75553..a88049b 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -130,7 +130,7 @@ xfs_dir3_free_write_verify(
 	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_FREE_CRC_OFF);
 }
 
-static const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
+const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
 	.verify_read = xfs_dir3_free_read_verify,
 	.verify_write = xfs_dir3_free_write_verify,
 };
@@ -144,8 +144,15 @@ __xfs_dir3_free_read(
 	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp)
 {
-	return xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
+	int			err;
+
+	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_free_buf_ops);
+
+	/* try read returns without an error or *bpp if it lands in a hole */
+	if (!err && tp && *bpp)
+		xfs_trans_buf_set_type(tp, *bpp, XFS_BLF_DIR_FREE_BUF);
+	return err;
 }
 
 int
@@ -232,7 +239,8 @@ xfs_dir3_free_get_buf(
 	if (error)
 		return error;
 
-	bp->b_ops = &xfs_dir3_free_buf_ops;;
+	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_FREE_BUF);
+	bp->b_ops = &xfs_dir3_free_buf_ops;
 
 	/*
 	 * Initialize the new block to be empty, and remember
@@ -380,6 +388,7 @@ xfs_dir2_leaf_to_node(
 	else
 		leaf->hdr.info.magic = cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
 	lbp->b_ops = &xfs_dir3_leafn_buf_ops;
+	xfs_trans_buf_set_type(tp, lbp, XFS_BLF_DIR_LEAFN_BUF);
 	xfs_dir3_leaf_log_header(tp, lbp);
 	xfs_dir3_leaf_check(mp, lbp);
 	return 0;
@@ -795,6 +804,7 @@ xfs_dir2_leafn_lookup_for_entry(
 							(char *)curbp->b_addr);
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
 			curbp->b_ops = &xfs_dir3_data_buf_ops;
+			xfs_trans_buf_set_type(tp, curbp, XFS_BLF_DIR_DATA_BUF);
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 		}
@@ -809,6 +819,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			state->extrablk.blkno = curdb;
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
 			curbp->b_ops = &xfs_dir3_data_buf_ops;
+			xfs_trans_buf_set_type(tp, curbp, XFS_BLF_DIR_DATA_BUF);
 		} else {
 			/* If the curbp is not the CI match block, drop it */
 			if (state->extrablk.bp != curbp)
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 932565d..7cf573c 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -49,6 +49,7 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 #endif
 
 extern const struct xfs_buf_ops xfs_dir3_data_buf_ops;
+extern const struct xfs_buf_ops xfs_dir3_free_buf_ops;
 
 extern int __xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
@@ -77,6 +78,7 @@ extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
 		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
 
 /* xfs_dir2_leaf.c */
+extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
 
 extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
