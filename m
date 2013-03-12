Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB51B7FB3
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:31:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A3478F804B
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:31:40 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	SPfu7MNLzCcJO1z3 for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 05:31:37 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UFOMQ-0001Sa-P4
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:31:18 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UFOMQ-0002NA-Ls
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:31:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 20/21] xfs: add buffer types to directory and attribute buffers
Date: Tue, 12 Mar 2013 23:30:53 +1100
Message-Id: <1363091454-8852-21-git-send-email-david@fromorbit.com>
In-Reply-To: <1363091454-8852-1-git-send-email-david@fromorbit.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_attr_leaf.c   |    9 +-
 fs/xfs/xfs_attr_remote.h |    2 +
 fs/xfs/xfs_buf_item.h    |   18 +++-
 fs/xfs/xfs_da_btree.c    |   46 +++++++-
 fs/xfs/xfs_da_btree.h    |    2 +
 fs/xfs/xfs_dir2_block.c  |   12 ++-
 fs/xfs/xfs_dir2_data.c   |    8 +-
 fs/xfs/xfs_dir2_leaf.c   |   26 ++++-
 fs/xfs/xfs_dir2_node.c   |   15 ++-
 fs/xfs/xfs_dir2_priv.h   |    2 +
 fs/xfs/xfs_log_recover.c |  259 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_trans.h       |    2 +
 fs/xfs/xfs_trans_buf.c   |   17 +++
 13 files changed, 323 insertions(+), 95 deletions(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index a1cb746..7feaf3c 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -271,8 +271,13 @@ xfs_attr3_leaf_read(
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
@@ -1078,6 +1083,7 @@ xfs_attr3_leaf_to_node(
 		goto out;
 
 	/* copy leaf to new buffer, update identifiers */
+	xfs_trans_buf_set_type(args->trans, bp2, XFS_BLF_ATTR_LEAF_BUF);
 	bp2->b_ops = bp1->b_ops;
 	memcpy(bp2->b_addr, bp1->b_addr, XFS_LBSIZE(mp));
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
@@ -1140,6 +1146,7 @@ xfs_attr3_leaf_create(
 	if (error)
 		return error;
 	bp->b_ops = &xfs_attr3_leaf_buf_ops;
+	xfs_trans_buf_set_type(args->trans, bp, XFS_BLF_ATTR_LEAF_BUF);
 	leaf = bp->b_addr;
 	memset(leaf, 0, XFS_LBSIZE(mp));
 
diff --git a/fs/xfs/xfs_attr_remote.h b/fs/xfs/xfs_attr_remote.h
index 0ca8d9a..c7cca60 100644
--- a/fs/xfs/xfs_attr_remote.h
+++ b/fs/xfs/xfs_attr_remote.h
@@ -37,6 +37,8 @@ struct xfs_attr3_rmt_hdr {
 	((bufsize) - (xfs_sb_version_hascrc(&(mp)->m_sb) ? \
 			sizeof(struct xfs_attr3_rmt_hdr) : 0))
 
+extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
+
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 09cab4e..640adcf 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
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
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 9939764..10bfeaa 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -292,7 +292,6 @@ const struct xfs_buf_ops xfs_da3_node_buf_ops = {
 	.verify_write = xfs_da3_node_write_verify,
 };
 
-
 int
 xfs_da3_node_read(
 	struct xfs_trans	*tp,
@@ -302,8 +301,35 @@ xfs_da3_node_read(
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
@@ -334,6 +360,8 @@ xfs_da3_node_create(
 	error = xfs_da_get_buf(tp, args->dp, blkno, -1, &bp, whichfork);
 	if (error)
 		return(error);
+	bp->b_ops = &xfs_da3_node_buf_ops;
+	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DA_NODE_BUF);
 	node = bp->b_addr;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
@@ -352,7 +380,6 @@ xfs_da3_node_create(
 	xfs_trans_log_buf(tp, bp,
 		XFS_DA_LOGRANGE(node, &node->hdr, xfs_da3_node_hdr_size(node)));
 
-	bp->b_ops = &xfs_da3_node_buf_ops;
 	*bpp = bp;
 	return(0);
 }
@@ -563,6 +590,12 @@ xfs_da3_root_split(
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
@@ -575,6 +608,12 @@ xfs_da3_root_split(
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
@@ -1090,6 +1129,7 @@ xfs_da3_root_join(
 	 */
 	memcpy(root_blk->bp->b_addr, bp->b_addr, state->blocksize);
 	root_blk->bp->b_ops = bp->b_ops;
+	xfs_trans_buf_copy_type(root_blk->bp, bp);
 	if (oldroothdr.magic == XFS_DA3_NODE_MAGIC) {
 		struct xfs_da3_blkinfo *da3 = root_blk->bp->b_addr;
 		da3->blkno = cpu_to_be64(root_blk->bp->b_bn);
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 0e8182c..6fb3371 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -301,6 +301,8 @@ int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			 xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			 struct xfs_buf **bpp, int which_fork);
 
+extern const struct xfs_buf_ops xfs_da3_node_buf_ops;
+
 /*
  * Utility routines.
  */
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index dc04537..8c387e4 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -132,20 +132,26 @@ xfs_dir3_block_read(
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
@@ -1080,7 +1086,7 @@ xfs_dir2_leaf_to_block(
 	/*
 	 * Start converting it to block form.
 	 */
-	xfs_dir3_block_init(mp, dbp, dp);
+	xfs_dir3_block_init(mp, tp, dbp, dp);
 
 	needlog = 1;
 	needscan = 0;
@@ -1209,7 +1215,7 @@ xfs_dir2_sf_to_block(
 		kmem_free(sfp);
 		return error;
 	}
-	xfs_dir3_block_init(mp, bp, dp);
+	xfs_dir3_block_init(mp, tp, bp, dp);
 	hdr = bp->b_addr;
 
 	/*
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 86ac9c0..20a4aaf 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -301,8 +301,13 @@ xfs_dir3_data_read(
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
@@ -571,6 +576,7 @@ xfs_dir3_data_init(
 	if (error)
 		return error;
 	bp->b_ops = &xfs_dir3_data_buf_ops;
+	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_DATA_BUF);
 
 	/*
 	 * Initialize the header.
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 71b03fc..015c078 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -277,7 +277,7 @@ xfs_dir3_leafn_write_verify(
 	__write_verify(bp, XFS_DIR2_LEAFN_MAGIC);
 }
 
-static const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
+const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
 	.verify_read = xfs_dir3_leaf1_read_verify,
 	.verify_write = xfs_dir3_leaf1_write_verify,
 };
@@ -295,8 +295,13 @@ xfs_dir3_leaf_read(
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
@@ -307,8 +312,13 @@ xfs_dir3_leafn_read(
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
@@ -317,6 +327,7 @@ xfs_dir3_leafn_read(
 static void
 xfs_dir3_leaf_init(
 	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
 	struct xfs_buf		*bp,
 	xfs_ino_t		owner,
 	__uint16_t		type)
@@ -351,8 +362,11 @@ xfs_dir3_leaf_init(
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
@@ -377,7 +391,7 @@ xfs_dir3_leaf_get_buf(
 	if (error)
 		return error;
 
-	xfs_dir3_leaf_init(mp, bp, dp->i_ino, magic);
+	xfs_dir3_leaf_init(mp, tp, bp, dp->i_ino, magic);
 	xfs_dir3_leaf_log_header(tp, bp);
 	if (magic == XFS_DIR2_LEAF1_MAGIC)
 		xfs_dir3_leaf_log_tail(tp, bp);
@@ -473,6 +487,7 @@ xfs_dir2_block_to_leaf(
 	 * Fix up the block header, make it a data block.
 	 */
 	dbp->b_ops = &xfs_dir3_data_buf_ops;
+	xfs_trans_buf_set_type(tp, dbp, XFS_BLF_DIR_DATA_BUF);
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
 		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 	else
@@ -2181,6 +2196,7 @@ xfs_dir2_node_to_leaf(
 		xfs_dir3_leaf_compact(args, &leafhdr, lbp);
 
 	lbp->b_ops = &xfs_dir3_leaf1_buf_ops;
+	xfs_trans_buf_set_type(tp, lbp, XFS_BLF_DIR_LEAF1_BUF);
 	leafhdr.magic = (leafhdr.magic == XFS_DIR2_LEAFN_MAGIC)
 					? XFS_DIR2_LEAF1_MAGIC
 					: XFS_DIR3_LEAFN_MAGIC;
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 4f9f9cf..7d1ee7d 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -144,7 +144,7 @@ xfs_dir3_free_write_verify(
 	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DIR3_FREE_CRC_OFF);
 }
 
-static const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
+const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
 	.verify_read = xfs_dir3_free_read_verify,
 	.verify_write = xfs_dir3_free_write_verify,
 };
@@ -158,8 +158,15 @@ __xfs_dir3_free_read(
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
@@ -246,6 +253,7 @@ xfs_dir3_free_get_buf(
 	if (error)
 		return error;
 
+	xfs_trans_buf_set_type(tp, bp, XFS_BLF_DIR_FREE_BUF);
 	bp->b_ops = &xfs_dir3_free_buf_ops;;
 
 	/*
@@ -394,6 +402,7 @@ xfs_dir2_leaf_to_node(
 	else
 		leaf->hdr.info.magic = cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
 	lbp->b_ops = &xfs_dir3_leafn_buf_ops;
+	xfs_trans_buf_set_type(tp, lbp, XFS_BLF_DIR_LEAFN_BUF);
 	xfs_dir3_leaf_log_header(tp, lbp);
 	xfs_dir3_leaf_check(mp, lbp);
 	return 0;
@@ -805,6 +814,7 @@ xfs_dir2_leafn_lookup_for_entry(
 							(char *)curbp->b_addr);
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
 			curbp->b_ops = &xfs_dir3_data_buf_ops;
+			xfs_trans_buf_set_type(tp, curbp, XFS_BLF_DIR_DATA_BUF);
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 		}
@@ -819,6 +829,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			state->extrablk.blkno = curdb;
 			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
 			curbp->b_ops = &xfs_dir3_data_buf_ops;
+			xfs_trans_buf_set_type(tp, curbp, XFS_BLF_DIR_DATA_BUF);
 		} else {
 			/* If the curbp is not the CI match block, drop it */
 			if (state->extrablk.bp != curbp)
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 932565d..7cf573c 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
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
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 542aa1e..4cf2cf2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -45,7 +45,14 @@
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+
+/* Need all the magic numbers and buffer ops structures from these headers */
 #include "xfs_symlink.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_attr_remote.h"
 
 STATIC int
 xlog_find_zeroed(
@@ -1860,86 +1867,30 @@ xlog_recover_do_inode_buffer(
 }
 
 /*
- * Perform a 'normal' buffer recovery.  Each logged region of the
- * buffer should be copied over the corresponding region in the
- * given buffer.  The bitmap in the buf log format structure indicates
- * where to place the logged data.
+ * Validate the recovered buffer is of the correct type and attach the
+ * appropriate buffer operations to them for writeback. Magic numbers are in a
+ * few places:
+ *	the first 16 bits of the buffer (inode buffer, dquot buffer),
+ *	the first 32 bits of the buffer (most blocks),
+ *	inside a struct xfs_da_blkinfo at the start of the buffer.
  */
-STATIC void
-xlog_recover_do_reg_buffer(
+static void
+xlog_recovery_validate_buf_type(
 	struct xfs_mount	*mp,
-	xlog_recover_item_t	*item,
 	struct xfs_buf		*bp,
 	xfs_buf_log_format_t	*buf_f)
 {
-	int			i;
-	int			bit;
-	int			nbits;
-	int                     error;
-	struct xfs_da_blkinfo	*info;
-
-	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
-
-	bit = 0;
-	i = 1;  /* 0 is the buf format structure */
-	while (1) {
-		bit = xfs_next_bit(buf_f->blf_data_map,
-				   buf_f->blf_map_size, bit);
-		if (bit == -1)
-			break;
-		nbits = xfs_contig_bits(buf_f->blf_data_map,
-					buf_f->blf_map_size, bit);
-		ASSERT(nbits > 0);
-		ASSERT(item->ri_buf[i].i_addr != NULL);
-		ASSERT(item->ri_buf[i].i_len % XFS_BLF_CHUNK == 0);
-		ASSERT(BBTOB(bp->b_io_length) >=
-		       ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SHIFT));
-
-		/*
-		 * Do a sanity check if this is a dquot buffer. Just checking
-		 * the first dquot in the buffer should do. XXXThis is
-		 * probably a good thing to do for other buf types also.
-		 */
-		error = 0;
-		if (buf_f->blf_flags &
-		   (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
-			if (item->ri_buf[i].i_addr == NULL) {
-				xfs_alert(mp,
-					"XFS: NULL dquot in %s.", __func__);
-				goto next;
-			}
-			if (item->ri_buf[i].i_len < sizeof(xfs_disk_dquot_t)) {
-				xfs_alert(mp,
-					"XFS: dquot too small (%d) in %s.",
-					item->ri_buf[i].i_len, __func__);
-				goto next;
-			}
-			error = xfs_qm_dqcheck(mp, item->ri_buf[i].i_addr,
-					       -1, 0, XFS_QMOPT_DOWARN,
-					       "dquot_buf_recover");
-			if (error)
-				goto next;
-		}
-
-		memcpy(xfs_buf_offset(bp,
-			(uint)bit << XFS_BLF_SHIFT),	/* dest */
-			item->ri_buf[i].i_addr,		/* source */
-			nbits<<XFS_BLF_SHIFT);		/* length */
- next:
-		i++;
-		bit += nbits;
-	}
-
-	/* Shouldn't be any more regions */
-	ASSERT(i == item->ri_total);
-
-	/* Shouldn't be any more regions */
-	ASSERT(i == item->ri_total);
-
-	info = bp->b_addr;
+	struct xfs_da_blkinfo	*info = bp->b_addr;
+	__uint32_t		magic32;
+	__uint16_t		magic16;
+	__uint16_t		magicda;
+
+	magic32 = be32_to_cpu(*(__be32 *)bp->b_addr);
+	magic16 = be16_to_cpu(*(__be16*)bp->b_addr);
+	magicda = be16_to_cpu(info->magic);
 	switch (buf_f->blf_flags & XFS_BLF_TYPE_MASK) {
 	case XFS_BLF_BTREE_BUF:
-		switch (be32_to_cpu(*(__be32 *)bp->b_addr)) {
+		switch (magic32) {
 		case XFS_ABTB_CRC_MAGIC:
 		case XFS_ABTC_CRC_MAGIC:
 		case XFS_ABTB_MAGIC:
@@ -1961,7 +1912,7 @@ xlog_recover_do_reg_buffer(
 		}
 		break;
 	case XFS_BLF_AGF_BUF:
-		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_AGF_MAGIC)) {
+		if (magic32 != XFS_AGF_MAGIC) {
 			xfs_warn(mp, "Bad AGF block magic!");
 			ASSERT(0);
 			break;
@@ -1971,7 +1922,7 @@ xlog_recover_do_reg_buffer(
 	case XFS_BLF_AGFL_BUF:
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			break;
-		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_AGFL_MAGIC)) {
+		if (magic32 != XFS_AGFL_MAGIC) {
 			xfs_warn(mp, "Bad AGFL block magic!");
 			ASSERT(0);
 			break;
@@ -1979,7 +1930,7 @@ xlog_recover_do_reg_buffer(
 		bp->b_ops = &xfs_agfl_buf_ops;
 		break;
 	case XFS_BLF_AGI_BUF:
-		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_AGI_MAGIC)) {
+		if (magic32 != XFS_AGI_MAGIC) {
 			xfs_warn(mp, "Bad AGI block magic!");
 			ASSERT(0);
 			break;
@@ -1989,7 +1940,7 @@ xlog_recover_do_reg_buffer(
 	case XFS_BLF_UDQUOT_BUF:
 	case XFS_BLF_PDQUOT_BUF:
 	case XFS_BLF_GDQUOT_BUF:
-		if (*(__be16 *)bp->b_addr != cpu_to_be16(XFS_DQUOT_MAGIC)) {
+		if (magic16 != XFS_DQUOT_MAGIC) {
 			xfs_warn(mp, "Bad DQUOT block magic!");
 			ASSERT(0);
 			break;
@@ -2001,7 +1952,7 @@ xlog_recover_do_reg_buffer(
 		 * we get here with inode allocation buffers, not buffers that
 		 * track unlinked list changes.
 		 */
-		if (*(__be16 *)bp->b_addr != cpu_to_be16(XFS_DINODE_MAGIC)) {
+		if (magic16 != XFS_DINODE_MAGIC) {
 			xfs_warn(mp, "Bad INODE block magic!");
 			ASSERT(0);
 			break;
@@ -2009,19 +1960,169 @@ xlog_recover_do_reg_buffer(
 		bp->b_ops = &xfs_inode_buf_ops;
 		break;
 	case XFS_BLF_SYMLINK_BUF:
-		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_SYMLINK_MAGIC)) {
+		if (magic32 != XFS_SYMLINK_MAGIC) {
 			xfs_warn(mp, "Bad symlink block magic!");
 			ASSERT(0);
 			break;
 		}
 		bp->b_ops = &xfs_symlink_buf_ops;
 		break;
+	case XFS_BLF_DIR_BLOCK_BUF:
+		if (magic32 != XFS_DIR2_BLOCK_MAGIC &&
+		    magic32 != XFS_DIR3_BLOCK_MAGIC) {
+			xfs_warn(mp, "Bad dir block magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_dir3_block_buf_ops;
+		break;
+	case XFS_BLF_DIR_DATA_BUF:
+		if (magic32 != XFS_DIR2_DATA_MAGIC &&
+		    magic32 != XFS_DIR3_DATA_MAGIC) {
+			xfs_warn(mp, "Bad dir data magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_dir3_data_buf_ops;
+		break;
+	case XFS_BLF_DIR_FREE_BUF:
+		if (magic32 != XFS_DIR2_FREE_MAGIC &&
+		    magic32 != XFS_DIR3_FREE_MAGIC) {
+			xfs_warn(mp, "Bad dir3 free magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_dir3_free_buf_ops;
+		break;
+	case XFS_BLF_DIR_LEAF1_BUF:
+		if (magicda != XFS_DIR2_LEAF1_MAGIC &&
+		    magicda != XFS_DIR3_LEAF1_MAGIC) {
+			xfs_warn(mp, "Bad dir leaf1 magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
+		break;
+	case XFS_BLF_DIR_LEAFN_BUF:
+		if (magicda != XFS_DIR2_LEAFN_MAGIC &&
+		    magicda != XFS_DIR3_LEAFN_MAGIC) {
+			xfs_warn(mp, "Bad dir leafn magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_dir3_leafn_buf_ops;
+		break;
+	case XFS_BLF_DA_NODE_BUF:
+		if (magicda != XFS_DA_NODE_MAGIC &&
+		    magicda != XFS_DA3_NODE_MAGIC) {
+			xfs_warn(mp, "Bad da node magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_da3_node_buf_ops;
+		break;
+	case XFS_BLF_ATTR_LEAF_BUF:
+		if (magicda != XFS_ATTR_LEAF_MAGIC &&
+		    magicda != XFS_ATTR3_LEAF_MAGIC) {
+			xfs_warn(mp, "Bad attr leaf magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_attr3_leaf_buf_ops;
+		break;
+	case XFS_BLF_ATTR_RMT_BUF:
+		if (!xfs_sb_version_hascrc(&mp->m_sb))
+			break;
+		if (magicda != XFS_ATTR3_RMT_MAGIC) {
+			xfs_warn(mp, "Bad attr remote magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_attr3_rmt_buf_ops;
+		break;
 	default:
 		break;
 	}
 }
 
 /*
+ * Perform a 'normal' buffer recovery.  Each logged region of the
+ * buffer should be copied over the corresponding region in the
+ * given buffer.  The bitmap in the buf log format structure indicates
+ * where to place the logged data.
+ */
+STATIC void
+xlog_recover_do_reg_buffer(
+	struct xfs_mount	*mp,
+	xlog_recover_item_t	*item,
+	struct xfs_buf		*bp,
+	xfs_buf_log_format_t	*buf_f)
+{
+	int			i;
+	int			bit;
+	int			nbits;
+	int                     error;
+
+	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
+
+	bit = 0;
+	i = 1;  /* 0 is the buf format structure */
+	while (1) {
+		bit = xfs_next_bit(buf_f->blf_data_map,
+				   buf_f->blf_map_size, bit);
+		if (bit == -1)
+			break;
+		nbits = xfs_contig_bits(buf_f->blf_data_map,
+					buf_f->blf_map_size, bit);
+		ASSERT(nbits > 0);
+		ASSERT(item->ri_buf[i].i_addr != NULL);
+		ASSERT(item->ri_buf[i].i_len % XFS_BLF_CHUNK == 0);
+		ASSERT(BBTOB(bp->b_io_length) >=
+		       ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SHIFT));
+
+		/*
+		 * Do a sanity check if this is a dquot buffer. Just checking
+		 * the first dquot in the buffer should do. XXXThis is
+		 * probably a good thing to do for other buf types also.
+		 */
+		error = 0;
+		if (buf_f->blf_flags &
+		   (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
+			if (item->ri_buf[i].i_addr == NULL) {
+				xfs_alert(mp,
+					"XFS: NULL dquot in %s.", __func__);
+				goto next;
+			}
+			if (item->ri_buf[i].i_len < sizeof(xfs_disk_dquot_t)) {
+				xfs_alert(mp,
+					"XFS: dquot too small (%d) in %s.",
+					item->ri_buf[i].i_len, __func__);
+				goto next;
+			}
+			error = xfs_qm_dqcheck(mp, item->ri_buf[i].i_addr,
+					       -1, 0, XFS_QMOPT_DOWARN,
+					       "dquot_buf_recover");
+			if (error)
+				goto next;
+		}
+
+		memcpy(xfs_buf_offset(bp,
+			(uint)bit << XFS_BLF_SHIFT),	/* dest */
+			item->ri_buf[i].i_addr,		/* source */
+			nbits<<XFS_BLF_SHIFT);		/* length */
+ next:
+		i++;
+		bit += nbits;
+	}
+
+	/* Shouldn't be any more regions */
+	ASSERT(i == item->ri_total);
+
+	xlog_recovery_validate_buf_type(mp, bp, buf_f);
+
+}
+
+/*
  * Do some primitive error checking on ondisk dquot data structures.
  */
 int
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 1b04fe5..fa78a3f 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -507,6 +507,8 @@ void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
 				       uint);
+void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
+					struct xfs_buf *src_bp);
 void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 8a0f6af..40871bf 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -768,6 +768,9 @@ xfs_trans_buf_set_type(
 {
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
+	if (!tp)
+		return;
+
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
@@ -777,6 +780,20 @@ xfs_trans_buf_set_type(
 	bip->__bli_format.blf_flags |= type;
 }
 
+void
+xfs_trans_buf_copy_type(
+	struct xfs_buf		*dst_bp,
+	struct xfs_buf		*src_bp)
+{
+	struct xfs_buf_log_item	*sbip = src_bp->b_fspriv;
+	struct xfs_buf_log_item	*dbip = dst_bp->b_fspriv;
+	uint			type;
+
+	type = sbip->__bli_format.blf_flags & XFS_BLF_TYPE_MASK;
+	dbip->__bli_format.blf_flags &= ~XFS_BLF_TYPE_MASK;
+	dbip->__bli_format.blf_flags |= type;
+}
+
 /*
  * Similar to xfs_trans_inode_buf(), this marks the buffer as a cluster of
  * dquots. However, unlike in inode buffer recovery, dquot buffers get
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
