Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C99B67F82
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:07:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6359F304053
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:07:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ODarFl2uc8ajtkVo for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:07:35 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTpO-0006Lm-Qm
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTpO-0002CL-Pf
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/16] xfs: vectorise directory leaf operations
Date: Mon, 30 Sep 2013 13:07:08 +1000
Message-Id: <1380510433-8353-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510433-8353-1-git-send-email-david@fromorbit.com>
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
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

Next step in the vectorisation process is the leaf block
encode/decode operations. Most of the operations on leaves are
handled by the data block vectors, so there are relatively few of
them here.

Because of all the shuffling of code and having to pass more state
to some functions, this patch doesn't directly reduce the size of
the binary. It does open up many more opportunities for factoring
and optimisation, however.

   text    data     bss     dec     hex filename
 794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
 792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
 792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
 789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
 789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
 789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_btree.c   |  19 ++++----
 fs/xfs/xfs_da_format.c  |  75 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_da_format.h  |  30 -------------
 fs/xfs/xfs_dir2.c       |   7 +--
 fs/xfs/xfs_dir2.h       |  10 +++--
 fs/xfs/xfs_dir2_block.c |   2 +-
 fs/xfs/xfs_dir2_data.c  |  13 ++----
 fs/xfs/xfs_dir2_leaf.c  |  91 +++++++++++++++++++++-----------------
 fs/xfs/xfs_dir2_node.c  | 115 ++++++++++++++++++++++++++----------------------
 fs/xfs/xfs_dir2_priv.h  |  13 +++---
 10 files changed, 217 insertions(+), 158 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index eb65c54..df3759c 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -605,7 +605,7 @@ xfs_da3_root_split(
 
 		leaf = (xfs_dir2_leaf_t *)oldroot;
 		xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
-		ents = xfs_dir3_leaf_ents_p(leaf);
+		ents = dp->d_ops->leaf_ents_p(leaf);
 
 		ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
 		       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
@@ -1319,7 +1319,8 @@ xfs_da3_fixhashpath(
 			return;
 		break;
 	case XFS_DIR2_LEAFN_MAGIC:
-		lasthash = xfs_dir2_leafn_lasthash(blk->bp, &count);
+		lasthash = xfs_dir2_leafn_lasthash(state->args->dp,
+						   blk->bp, &count);
 		if (count == 0)
 			return;
 		break;
@@ -1536,7 +1537,8 @@ xfs_da3_node_lookup_int(
 		if (blk->magic == XFS_DIR2_LEAFN_MAGIC ||
 		    blk->magic == XFS_DIR3_LEAFN_MAGIC) {
 			blk->magic = XFS_DIR2_LEAFN_MAGIC;
-			blk->hashval = xfs_dir2_leafn_lasthash(blk->bp, NULL);
+			blk->hashval = xfs_dir2_leafn_lasthash(args->dp,
+							       blk->bp, NULL);
 			break;
 		}
 
@@ -1702,7 +1704,7 @@ xfs_da3_blk_link(
 		before = xfs_attr_leaf_order(old_blk->bp, new_blk->bp);
 		break;
 	case XFS_DIR2_LEAFN_MAGIC:
-		before = xfs_dir2_leafn_order(old_blk->bp, new_blk->bp);
+		before = xfs_dir2_leafn_order(args->dp, old_blk->bp, new_blk->bp);
 		break;
 	case XFS_DA_NODE_MAGIC:
 		before = xfs_da3_node_order(old_blk->bp, new_blk->bp);
@@ -1947,16 +1949,15 @@ xfs_da3_path_shift(
 			blk->magic = XFS_ATTR_LEAF_MAGIC;
 			ASSERT(level == path->active-1);
 			blk->index = 0;
-			blk->hashval = xfs_attr_leaf_lasthash(blk->bp,
-							      NULL);
+			blk->hashval = xfs_attr_leaf_lasthash(blk->bp, NULL);
 			break;
 		case XFS_DIR2_LEAFN_MAGIC:
 		case XFS_DIR3_LEAFN_MAGIC:
 			blk->magic = XFS_DIR2_LEAFN_MAGIC;
 			ASSERT(level == path->active-1);
 			blk->index = 0;
-			blk->hashval = xfs_dir2_leafn_lasthash(blk->bp,
-							       NULL);
+			blk->hashval = xfs_dir2_leafn_lasthash(args->dp,
+							       blk->bp, NULL);
 			break;
 		default:
 			ASSERT(0);
@@ -2223,7 +2224,7 @@ xfs_da3_swap_lastblock(
 
 		dead_leaf2 = (xfs_dir2_leaf_t *)dead_info;
 		xfs_dir3_leaf_hdr_from_disk(&leafhdr, dead_leaf2);
-		ents = xfs_dir3_leaf_ents_p(dead_leaf2);
+		ents = ip->d_ops->leaf_ents_p(dead_leaf2);
 		dead_level = 0;
 		dead_hash = be32_to_cpu(ents[leafhdr.count - 1].hashval);
 	} else {
diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
index 1e92a24..ff8b503 100644
--- a/fs/xfs/xfs_da_format.c
+++ b/fs/xfs/xfs_da_format.c
@@ -435,6 +435,48 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 		((char *)hdr + xfs_dir3_data_entry_offset());
 }
 
+
+/*
+ * Directory Leaf block operations
+ */
+static int
+xfs_dir2_leaf_hdr_size(void)
+{
+	return sizeof(struct xfs_dir2_leaf_hdr);
+}
+
+static int
+xfs_dir2_max_leaf_ents(struct xfs_mount *mp)
+{
+	return (mp->m_dirblksize - xfs_dir2_leaf_hdr_size()) /
+		(uint)sizeof(struct xfs_dir2_leaf_entry);
+}
+
+static struct xfs_dir2_leaf_entry *
+xfs_dir2_leaf_ents_p(struct xfs_dir2_leaf *lp)
+{
+	return lp->__ents;
+}
+
+static int
+xfs_dir3_leaf_hdr_size(void)
+{
+	return sizeof(struct xfs_dir3_leaf_hdr);
+}
+
+static inline int
+xfs_dir3_max_leaf_ents(struct xfs_mount *mp)
+{
+	return (mp->m_dirblksize - xfs_dir3_leaf_hdr_size()) /
+		(uint)sizeof(struct xfs_dir2_leaf_entry);
+}
+
+static inline struct xfs_dir2_leaf_entry *
+xfs_dir3_leaf_ents_p(struct xfs_dir2_leaf *lp)
+{
+	return ((struct xfs_dir3_leaf *)lp)->__ents;
+}
+
 const struct xfs_dir_ops xfs_dir2_ops = {
 	.sf_entsize = xfs_dir2_sf_entsize,
 	.sf_nextentry = xfs_dir2_sf_nextentry,
@@ -462,6 +504,10 @@ const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
+	.leaf_hdr_size = xfs_dir2_leaf_hdr_size,
+	.leaf_max_ents = xfs_dir2_max_leaf_ents,
+	.leaf_ents_p = xfs_dir2_leaf_ents_p,
+
 };
 
 const struct xfs_dir_ops xfs_dir2_ftype_ops = {
@@ -490,6 +536,10 @@ const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_first_entry_p = xfs_dir2_data_first_entry_p,
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
+
+	.leaf_hdr_size = xfs_dir2_leaf_hdr_size,
+	.leaf_max_ents = xfs_dir2_max_leaf_ents,
+	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 };
 
 const struct xfs_dir_ops xfs_dir3_ops = {
@@ -518,4 +568,29 @@ const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_first_entry_p = xfs_dir3_data_first_entry_p,
 	.data_entry_p = xfs_dir3_data_entry_p,
 	.data_unused_p = xfs_dir3_data_unused_p,
+
+	.leaf_hdr_size = xfs_dir3_leaf_hdr_size,
+	.leaf_max_ents = xfs_dir3_max_leaf_ents,
+	.leaf_ents_p = xfs_dir3_leaf_ents_p,
 };
+
+/*
+ * Return the ops structure according to the current config.  If we are passed
+ * an inode, then that overrides the default config we use which is based on
+ * feature bits.
+ */
+const struct xfs_dir_ops *
+xfs_dir_get_ops(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*dp)
+{
+	if (dp)
+		return dp->d_ops;
+	if (mp->m_dir_inode_ops)
+		return mp->m_dir_inode_ops;
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		return &xfs_dir3_ops;
+	if (xfs_sb_version_hasftype(&mp->m_sb))
+		return &xfs_dir2_ftype_ops;
+	return &xfs_dir2_ops;
+}
diff --git a/fs/xfs/xfs_da_format.h b/fs/xfs/xfs_da_format.h
index aeca003..0a567e2 100644
--- a/fs/xfs/xfs_da_format.h
+++ b/fs/xfs/xfs_da_format.h
@@ -551,36 +551,6 @@ struct xfs_dir3_leaf {
 extern void xfs_dir3_leaf_hdr_from_disk(struct xfs_dir3_icleaf_hdr *to,
 					struct xfs_dir2_leaf *from);
 
-static inline int
-xfs_dir3_leaf_hdr_size(struct xfs_dir2_leaf *lp)
-{
-	if (lp->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
-	    lp->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC))
-		return sizeof(struct xfs_dir3_leaf_hdr);
-	return sizeof(struct xfs_dir2_leaf_hdr);
-}
-
-static inline int
-xfs_dir3_max_leaf_ents(struct xfs_mount *mp, struct xfs_dir2_leaf *lp)
-{
-	return (mp->m_dirblksize - xfs_dir3_leaf_hdr_size(lp)) /
-		(uint)sizeof(struct xfs_dir2_leaf_entry);
-}
-
-/*
- * Get address of the bestcount field in the single-leaf block.
- */
-static inline struct xfs_dir2_leaf_entry *
-xfs_dir3_leaf_ents_p(struct xfs_dir2_leaf *lp)
-{
-	if (lp->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
-	    lp->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
-		struct xfs_dir3_leaf *lp3 = (struct xfs_dir3_leaf *)lp;
-		return lp3->__ents;
-	}
-	return lp->__ents;
-}
-
 /*
  * Get address of the bestcount field in the single-leaf block.
  */
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 7911136..2b98a33 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -113,12 +113,7 @@ xfs_dir_mount(
 	else
 		mp->m_dirnameops = &xfs_default_nameops;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		mp->m_dir_inode_ops = &xfs_dir3_ops;
-	else if (xfs_sb_version_hasftype(&mp->m_sb))
-		mp->m_dir_inode_ops = &xfs_dir2_ftype_ops;
-	else
-		mp->m_dir_inode_ops = &xfs_dir2_ops;
+	mp->m_dir_inode_ops = xfs_dir_get_ops(mp, NULL);
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 076010a..9ba9db7 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -74,11 +74,15 @@ struct xfs_dir_ops {
 		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
 	struct xfs_dir2_data_unused *
 		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
+
+	int	(*leaf_hdr_size)(void);
+	int	(*leaf_max_ents)(struct xfs_mount *mp);
+	struct xfs_dir2_leaf_entry *
+		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
 };
 
-extern const struct xfs_dir_ops xfs_dir2_ops;
-extern const struct xfs_dir_ops xfs_dir2_ftype_ops;
-extern const struct xfs_dir_ops xfs_dir3_ops;
+extern const struct xfs_dir_ops *
+	xfs_dir_get_ops(struct xfs_mount *mp, struct xfs_inode *dp);
 
 /*
  * Generic directory interface routines
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index e6f1784..03015f5 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -937,7 +937,7 @@ xfs_dir2_leaf_to_block(
 	mp = dp->i_mount;
 	leaf = lbp->b_addr;
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 
 	ASSERT(leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 0b58a07..16aa76e 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -68,17 +68,10 @@ __xfs_dir3_data_check(
 	hdr = bp->b_addr;
 
 	/*
-	 * we can be passed a null dp here froma verifier, so manually configure
-	 * the ops here in that case.
+	 * we can be passed a null dp here from a verifier, so we need to go the
+	 * hard way to get them.
 	 */
-	if (dp)
-		ops = dp->d_ops;
-	else if (xfs_sb_version_hascrc(&mp->m_sb))
-		ops = &xfs_dir3_ops;
-	else if (xfs_sb_version_hasftype(&mp->m_sb))
-		ops = &xfs_dir2_ftype_ops;
-	else
-		ops = &xfs_dir2_ops;
+	ops = xfs_dir_get_ops(mp, dp);
 
 	switch (hdr->magic) {
 	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index f35b394..16fdc0e 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -50,15 +50,15 @@ static void xfs_dir3_leaf_log_tail(struct xfs_trans *tp, struct xfs_buf *bp);
  * Pop an assert if something is wrong.
  */
 #ifdef DEBUG
-#define	xfs_dir3_leaf_check(mp, bp) \
+#define	xfs_dir3_leaf_check(dp, bp) \
 do { \
-	if (!xfs_dir3_leaf1_check((mp), (bp))) \
+	if (!xfs_dir3_leaf1_check((dp), (bp))) \
 		ASSERT(0); \
 } while (0);
 
 STATIC bool
 xfs_dir3_leaf1_check(
-	struct xfs_mount	*mp,
+	struct xfs_inode	*dp,
 	struct xfs_buf		*bp)
 {
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
@@ -73,10 +73,10 @@ xfs_dir3_leaf1_check(
 	} else if (leafhdr.magic != XFS_DIR2_LEAF1_MAGIC)
 		return false;
 
-	return xfs_dir3_leaf_check_int(mp, &leafhdr, leaf);
+	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf);
 }
 #else
-#define	xfs_dir3_leaf_check(mp, bp)
+#define	xfs_dir3_leaf_check(dp, bp)
 #endif
 
 void
@@ -138,6 +138,7 @@ xfs_dir3_leaf_hdr_to_disk(
 bool
 xfs_dir3_leaf_check_int(
 	struct xfs_mount	*mp,
+	struct xfs_inode	*dp,
 	struct xfs_dir3_icleaf_hdr *hdr,
 	struct xfs_dir2_leaf	*leaf)
 {
@@ -145,8 +146,15 @@ xfs_dir3_leaf_check_int(
 	xfs_dir2_leaf_tail_t	*ltp;
 	int			stale;
 	int			i;
+	const struct xfs_dir_ops *ops;
 
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	/*
+	 * we can be passed a null dp here from a verifier, so we need to go the
+	 * hard way to get them.
+	 */
+	ops = xfs_dir_get_ops(mp, dp);
+
+	ents = ops->leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
 
 	/*
@@ -154,7 +162,7 @@ xfs_dir3_leaf_check_int(
 	 * Should factor in the size of the bests table as well.
 	 * We can deduce a value for that from di_size.
 	 */
-	if (hdr->count > xfs_dir3_max_leaf_ents(mp, leaf))
+	if (hdr->count > ops->leaf_max_ents(mp))
 		return false;
 
 	/* Leaves and bests don't overlap in leaf format. */
@@ -213,7 +221,7 @@ xfs_dir3_leaf_verify(
 	}
 
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
-	return xfs_dir3_leaf_check_int(mp, &leafhdr, leaf);
+	return xfs_dir3_leaf_check_int(mp, NULL, &leafhdr, leaf);
 }
 
 static void
@@ -399,7 +407,7 @@ xfs_dir3_leaf_get_buf(
 		return error;
 
 	xfs_dir3_leaf_init(mp, tp, bp, dp->i_ino, magic);
-	xfs_dir3_leaf_log_header(tp, bp);
+	xfs_dir3_leaf_log_header(tp, dp, bp);
 	if (magic == XFS_DIR2_LEAF1_MAGIC)
 		xfs_dir3_leaf_log_tail(tp, bp);
 	*bpp = bp;
@@ -461,7 +469,7 @@ xfs_dir2_block_to_leaf(
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	bf = dp->d_ops->data_bestfree_p(hdr);
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	/*
 	 * Set the counts in the leaf header.
@@ -470,14 +478,14 @@ xfs_dir2_block_to_leaf(
 	leafhdr.count = be32_to_cpu(btp->count);
 	leafhdr.stale = be32_to_cpu(btp->stale);
 	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
-	xfs_dir3_leaf_log_header(tp, lbp);
+	xfs_dir3_leaf_log_header(tp, dp, lbp);
 
 	/*
 	 * Could compact these but I think we always do the conversion
 	 * after squeezing out stale entries.
 	 */
 	memcpy(ents, blp, be32_to_cpu(btp->count) * sizeof(xfs_dir2_leaf_entry_t));
-	xfs_dir3_leaf_log_ents(tp, lbp, 0, leafhdr.count - 1);
+	xfs_dir3_leaf_log_ents(tp, dp, lbp, 0, leafhdr.count - 1);
 	needscan = 0;
 	needlog = 1;
 	/*
@@ -513,7 +521,7 @@ xfs_dir2_block_to_leaf(
 	 */
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dp, dbp);
-	xfs_dir3_leaf_check(mp, lbp);
+	xfs_dir3_leaf_check(dp, lbp);
 	xfs_dir3_data_check(dp, dbp);
 	xfs_dir3_leaf_log_bests(tp, lbp, 0, 0);
 	return 0;
@@ -697,7 +705,7 @@ xfs_dir2_leaf_addname(
 	index = xfs_dir2_leaf_search_hash(args, lbp);
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(mp, leaf);
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	length = dp->d_ops->data_entsize(args->namelen);
@@ -938,9 +946,9 @@ xfs_dir2_leaf_addname(
 	 * Log the leaf fields and give up the buffers.
 	 */
 	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
-	xfs_dir3_leaf_log_header(tp, lbp);
-	xfs_dir3_leaf_log_ents(tp, lbp, lfloglow, lfloghigh);
-	xfs_dir3_leaf_check(mp, lbp);
+	xfs_dir3_leaf_log_header(tp, dp, lbp);
+	xfs_dir3_leaf_log_ents(tp, dp, lbp, lfloglow, lfloghigh);
+	xfs_dir3_leaf_check(dp, lbp);
 	xfs_dir3_data_check(dp, dbp);
 	return 0;
 }
@@ -968,7 +976,7 @@ xfs_dir3_leaf_compact(
 	/*
 	 * Compress out the stale entries in place.
 	 */
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = args->dp->d_ops->leaf_ents_p(leaf);
 	for (from = to = 0, loglow = -1; from < leafhdr->count; from++) {
 		if (ents[from].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			continue;
@@ -990,9 +998,10 @@ xfs_dir3_leaf_compact(
 	leafhdr->stale = 0;
 
 	xfs_dir3_leaf_hdr_to_disk(leaf, leafhdr);
-	xfs_dir3_leaf_log_header(args->trans, bp);
+	xfs_dir3_leaf_log_header(args->trans, args->dp, bp);
 	if (loglow != -1)
-		xfs_dir3_leaf_log_ents(args->trans, bp, loglow, to - 1);
+		xfs_dir3_leaf_log_ents(args->trans, args->dp, bp,
+				       loglow, to - 1);
 }
 
 /*
@@ -1119,10 +1128,11 @@ xfs_dir3_leaf_log_bests(
  */
 void
 xfs_dir3_leaf_log_ents(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	struct xfs_buf		*bp,		/* leaf buffer */
-	int			first,		/* first entry to log */
-	int			last)		/* last entry to log */
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp,
+	int			first,
+	int			last)
 {
 	xfs_dir2_leaf_entry_t	*firstlep;	/* pointer to first entry */
 	xfs_dir2_leaf_entry_t	*lastlep;	/* pointer to last entry */
@@ -1134,7 +1144,7 @@ xfs_dir3_leaf_log_ents(
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
 
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 	firstlep = &ents[first];
 	lastlep = &ents[last];
 	xfs_trans_log_buf(tp, bp, (uint)((char *)firstlep - (char *)leaf),
@@ -1147,6 +1157,7 @@ xfs_dir3_leaf_log_ents(
 void
 xfs_dir3_leaf_log_header(
 	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
 	struct xfs_buf		*bp)
 {
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
@@ -1157,7 +1168,7 @@ xfs_dir3_leaf_log_header(
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
 
 	xfs_trans_log_buf(tp, bp, (uint)((char *)&leaf->hdr - (char *)leaf),
-			  xfs_dir3_leaf_hdr_size(leaf) - 1);
+			  dp->d_ops->leaf_hdr_size() - 1);
 }
 
 /*
@@ -1212,9 +1223,9 @@ xfs_dir2_leaf_lookup(
 	}
 	tp = args->trans;
 	dp = args->dp;
-	xfs_dir3_leaf_check(dp->i_mount, lbp);
+	xfs_dir3_leaf_check(dp, lbp);
 	leaf = lbp->b_addr;
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 	/*
 	 * Get to the leaf entry and contained data entry address.
 	 */
@@ -1277,8 +1288,8 @@ xfs_dir2_leaf_lookup_int(
 
 	*lbpp = lbp;
 	leaf = lbp->b_addr;
-	xfs_dir3_leaf_check(mp, lbp);
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	xfs_dir3_leaf_check(dp, lbp);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 
 	/*
@@ -1415,7 +1426,7 @@ xfs_dir2_leaf_removename(
 	xfs_dir3_data_check(dp, dbp);
 	bf = dp->d_ops->data_bestfree_p(hdr);
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 	/*
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
@@ -1439,10 +1450,10 @@ xfs_dir2_leaf_removename(
 	 */
 	leafhdr.stale++;
 	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
-	xfs_dir3_leaf_log_header(tp, lbp);
+	xfs_dir3_leaf_log_header(tp, dp, lbp);
 
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
-	xfs_dir3_leaf_log_ents(tp, lbp, index, index);
+	xfs_dir3_leaf_log_ents(tp, dp, lbp, index, index);
 
 	/*
 	 * Scan the freespace in the data block again if necessary,
@@ -1476,7 +1487,7 @@ xfs_dir2_leaf_removename(
 			 */
 			if (error == ENOSPC && args->total == 0)
 				error = 0;
-			xfs_dir3_leaf_check(mp, lbp);
+			xfs_dir3_leaf_check(dp, lbp);
 			return error;
 		}
 		dbp = NULL;
@@ -1510,7 +1521,7 @@ xfs_dir2_leaf_removename(
 	else if (db != mp->m_dirdatablk)
 		dbp = NULL;
 
-	xfs_dir3_leaf_check(mp, lbp);
+	xfs_dir3_leaf_check(dp, lbp);
 	/*
 	 * See if we can convert to block form.
 	 */
@@ -1545,7 +1556,7 @@ xfs_dir2_leaf_replace(
 	}
 	dp = args->dp;
 	leaf = lbp->b_addr;
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 	/*
 	 * Point to the leaf entry, get data address from it.
 	 */
@@ -1564,7 +1575,7 @@ xfs_dir2_leaf_replace(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tp = args->trans;
 	xfs_dir2_data_log_entry(tp, dp, dbp, dep);
-	xfs_dir3_leaf_check(dp->i_mount, lbp);
+	xfs_dir3_leaf_check(dp, lbp);
 	xfs_trans_brelse(tp, lbp);
 	return 0;
 }
@@ -1590,7 +1601,7 @@ xfs_dir2_leaf_search_hash(
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
 	leaf = lbp->b_addr;
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = args->dp->d_ops->leaf_ents_p(leaf);
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 
 	/*
@@ -1830,10 +1841,10 @@ xfs_dir2_node_to_leaf(
 		freehdr.nvalid * sizeof(xfs_dir2_data_off_t));
 
 	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
-	xfs_dir3_leaf_log_header(tp, lbp);
+	xfs_dir3_leaf_log_header(tp, dp, lbp);
 	xfs_dir3_leaf_log_bests(tp, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
 	xfs_dir3_leaf_log_tail(tp, lbp);
-	xfs_dir3_leaf_check(mp, lbp);
+	xfs_dir3_leaf_check(dp, lbp);
 
 	/*
 	 * Get rid of the freespace block.
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 6644ed6..17e65c7 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -54,15 +54,15 @@ static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
  * Check internal consistency of a leafn block.
  */
 #ifdef DEBUG
-#define	xfs_dir3_leaf_check(mp, bp) \
+#define	xfs_dir3_leaf_check(dp, bp) \
 do { \
-	if (!xfs_dir3_leafn_check((mp), (bp))) \
+	if (!xfs_dir3_leafn_check((dp), (bp))) \
 		ASSERT(0); \
 } while (0);
 
 static bool
 xfs_dir3_leafn_check(
-	struct xfs_mount	*mp,
+	struct xfs_inode	*dp,
 	struct xfs_buf		*bp)
 {
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
@@ -77,10 +77,10 @@ xfs_dir3_leafn_check(
 	} else if (leafhdr.magic != XFS_DIR2_LEAFN_MAGIC)
 		return false;
 
-	return xfs_dir3_leaf_check_int(mp, &leafhdr, leaf);
+	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf);
 }
 #else
-#define	xfs_dir3_leaf_check(mp, bp)
+#define	xfs_dir3_leaf_check(dp, bp)
 #endif
 
 static bool
@@ -408,8 +408,8 @@ xfs_dir2_leaf_to_node(
 		leaf->hdr.info.magic = cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
 	lbp->b_ops = &xfs_dir3_leafn_buf_ops;
 	xfs_trans_buf_set_type(tp, lbp, XFS_BLFT_DIR_LEAFN_BUF);
-	xfs_dir3_leaf_log_header(tp, lbp);
-	xfs_dir3_leaf_check(mp, lbp);
+	xfs_dir3_leaf_log_header(tp, dp, lbp);
+	xfs_dir3_leaf_check(dp, lbp);
 	return 0;
 }
 
@@ -443,7 +443,7 @@ xfs_dir2_leafn_add(
 	tp = args->trans;
 	leaf = bp->b_addr;
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	/*
 	 * Quick check just to make sure we are not going to index
@@ -459,7 +459,7 @@ xfs_dir2_leafn_add(
 	 * a compact.
 	 */
 
-	if (leafhdr.count == xfs_dir3_max_leaf_ents(mp, leaf)) {
+	if (leafhdr.count == dp->d_ops->leaf_max_ents(mp)) {
 		if (!leafhdr.stale)
 			return XFS_ERROR(ENOSPC);
 		compact = leafhdr.stale > 1;
@@ -498,9 +498,9 @@ xfs_dir2_leafn_add(
 				args->blkno, args->index));
 
 	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
-	xfs_dir3_leaf_log_header(tp, bp);
-	xfs_dir3_leaf_log_ents(tp, bp, lfloglow, lfloghigh);
-	xfs_dir3_leaf_check(mp, bp);
+	xfs_dir3_leaf_log_header(tp, dp, bp);
+	xfs_dir3_leaf_log_ents(tp, dp, bp, lfloglow, lfloghigh);
+	xfs_dir3_leaf_check(dp, bp);
 	return 0;
 }
 
@@ -529,6 +529,7 @@ xfs_dir2_free_hdr_check(
  */
 xfs_dahash_t					/* hash value */
 xfs_dir2_leafn_lasthash(
+	struct xfs_inode *dp,
 	struct xfs_buf	*bp,			/* leaf buffer */
 	int		*count)			/* count of entries in leaf */
 {
@@ -546,7 +547,7 @@ xfs_dir2_leafn_lasthash(
 	if (!leafhdr.count)
 		return 0;
 
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 	return be32_to_cpu(ents[leafhdr.count - 1].hashval);
 }
 
@@ -584,9 +585,9 @@ xfs_dir2_leafn_lookup_for_addname(
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 
-	xfs_dir3_leaf_check(mp, bp);
+	xfs_dir3_leaf_check(dp, bp);
 	ASSERT(leafhdr.count > 0);
 
 	/*
@@ -734,9 +735,9 @@ xfs_dir2_leafn_lookup_for_entry(
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 
-	xfs_dir3_leaf_check(mp, bp);
+	xfs_dir3_leaf_check(dp, bp);
 	ASSERT(leafhdr.count > 0);
 
 	/*
@@ -906,7 +907,7 @@ xfs_dir3_leafn_moveents(
 	if (start_d < dhdr->count) {
 		memmove(&dents[start_d + count], &dents[start_d],
 			(dhdr->count - start_d) * sizeof(xfs_dir2_leaf_entry_t));
-		xfs_dir3_leaf_log_ents(tp, bp_d, start_d + count,
+		xfs_dir3_leaf_log_ents(tp, args->dp, bp_d, start_d + count,
 				       count + dhdr->count - 1);
 	}
 	/*
@@ -928,7 +929,8 @@ xfs_dir3_leafn_moveents(
 	 */
 	memcpy(&dents[start_d], &sents[start_s],
 		count * sizeof(xfs_dir2_leaf_entry_t));
-	xfs_dir3_leaf_log_ents(tp, bp_d, start_d, start_d + count - 1);
+	xfs_dir3_leaf_log_ents(tp, args->dp, bp_d,
+			       start_d, start_d + count - 1);
 
 	/*
 	 * If there are source entries after the ones we copied,
@@ -937,7 +939,8 @@ xfs_dir3_leafn_moveents(
 	if (start_s + count < shdr->count) {
 		memmove(&sents[start_s], &sents[start_s + count],
 			count * sizeof(xfs_dir2_leaf_entry_t));
-		xfs_dir3_leaf_log_ents(tp, bp_s, start_s, start_s + count - 1);
+		xfs_dir3_leaf_log_ents(tp, args->dp, bp_s,
+				       start_s, start_s + count - 1);
 	}
 
 	/*
@@ -955,6 +958,7 @@ xfs_dir3_leafn_moveents(
  */
 int						/* sort order */
 xfs_dir2_leafn_order(
+	struct xfs_inode	*dp,
 	struct xfs_buf		*leaf1_bp,		/* leaf1 buffer */
 	struct xfs_buf		*leaf2_bp)		/* leaf2 buffer */
 {
@@ -967,8 +971,8 @@ xfs_dir2_leafn_order(
 
 	xfs_dir3_leaf_hdr_from_disk(&hdr1, leaf1);
 	xfs_dir3_leaf_hdr_from_disk(&hdr2, leaf2);
-	ents1 = xfs_dir3_leaf_ents_p(leaf1);
-	ents2 = xfs_dir3_leaf_ents_p(leaf2);
+	ents1 = dp->d_ops->leaf_ents_p(leaf1);
+	ents2 = dp->d_ops->leaf_ents_p(leaf2);
 
 	if (hdr1.count > 0 && hdr2.count > 0 &&
 	    (be32_to_cpu(ents2[0].hashval) < be32_to_cpu(ents1[0].hashval) ||
@@ -1006,12 +1010,13 @@ xfs_dir2_leafn_rebalance(
 	struct xfs_dir2_leaf_entry *ents2;
 	struct xfs_dir3_icleaf_hdr hdr1;
 	struct xfs_dir3_icleaf_hdr hdr2;
+	struct xfs_inode	*dp = state->args->dp;
 
 	args = state->args;
 	/*
 	 * If the block order is wrong, swap the arguments.
 	 */
-	if ((swap = xfs_dir2_leafn_order(blk1->bp, blk2->bp))) {
+	if ((swap = xfs_dir2_leafn_order(dp, blk1->bp, blk2->bp))) {
 		xfs_da_state_blk_t	*tmp;	/* temp for block swap */
 
 		tmp = blk1;
@@ -1022,8 +1027,8 @@ xfs_dir2_leafn_rebalance(
 	leaf2 = blk2->bp->b_addr;
 	xfs_dir3_leaf_hdr_from_disk(&hdr1, leaf1);
 	xfs_dir3_leaf_hdr_from_disk(&hdr2, leaf2);
-	ents1 = xfs_dir3_leaf_ents_p(leaf1);
-	ents2 = xfs_dir3_leaf_ents_p(leaf2);
+	ents1 = dp->d_ops->leaf_ents_p(leaf1);
+	ents2 = dp->d_ops->leaf_ents_p(leaf2);
 
 	oldsum = hdr1.count + hdr2.count;
 #if defined(DEBUG) || defined(XFS_WARN)
@@ -1071,11 +1076,11 @@ xfs_dir2_leafn_rebalance(
 	/* log the changes made when moving the entries */
 	xfs_dir3_leaf_hdr_to_disk(leaf1, &hdr1);
 	xfs_dir3_leaf_hdr_to_disk(leaf2, &hdr2);
-	xfs_dir3_leaf_log_header(args->trans, blk1->bp);
-	xfs_dir3_leaf_log_header(args->trans, blk2->bp);
+	xfs_dir3_leaf_log_header(args->trans, dp, blk1->bp);
+	xfs_dir3_leaf_log_header(args->trans, dp, blk2->bp);
 
-	xfs_dir3_leaf_check(args->dp->i_mount, blk1->bp);
-	xfs_dir3_leaf_check(args->dp->i_mount, blk2->bp);
+	xfs_dir3_leaf_check(dp, blk1->bp);
+	xfs_dir3_leaf_check(dp, blk2->bp);
 
 	/*
 	 * Mark whether we're inserting into the old or new leaf.
@@ -1099,7 +1104,7 @@ xfs_dir2_leafn_rebalance(
 	if(blk2->index < 0) {
 		state->inleaf = 1;
 		blk2->index = 0;
-		xfs_alert(args->dp->i_mount,
+		xfs_alert(dp->i_mount,
 	"%s: picked the wrong leaf? reverting original leaf: blk1->index %d\n",
 			__func__, blk1->index);
 	}
@@ -1222,7 +1227,7 @@ xfs_dir2_leafn_remove(
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
-	ents = xfs_dir3_leaf_ents_p(leaf);
+	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	/*
 	 * Point to the entry we're removing.
@@ -1243,10 +1248,10 @@ xfs_dir2_leafn_remove(
 	 */
 	leafhdr.stale++;
 	xfs_dir3_leaf_hdr_to_disk(leaf, &leafhdr);
-	xfs_dir3_leaf_log_header(tp, bp);
+	xfs_dir3_leaf_log_header(tp, dp, bp);
 
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
-	xfs_dir3_leaf_log_ents(tp, bp, index, index);
+	xfs_dir3_leaf_log_ents(tp, dp, bp, index, index);
 
 	/*
 	 * Make the data entry free.  Keep track of the longest freespace
@@ -1335,12 +1340,12 @@ xfs_dir2_leafn_remove(
 			return error;
 	}
 
-	xfs_dir3_leaf_check(mp, bp);
+	xfs_dir3_leaf_check(dp, bp);
 	/*
 	 * Return indication of whether this leaf block is empty enough
 	 * to justify trying to join it with a neighbor.
 	 */
-	*rval = (xfs_dir3_leaf_hdr_size(leaf) +
+	*rval = (dp->d_ops->leaf_hdr_size() +
 		 (uint)sizeof(ents[0]) * (leafhdr.count - leafhdr.stale)) <
 		mp->m_dir_magicpct;
 	return 0;
@@ -1359,12 +1364,14 @@ xfs_dir2_leafn_split(
 	xfs_dablk_t		blkno;		/* new leaf block number */
 	int			error;		/* error return value */
 	xfs_mount_t		*mp;		/* filesystem mount point */
+	struct xfs_inode	*dp;
 
 	/*
 	 * Allocate space for a new leaf node.
 	 */
 	args = state->args;
-	mp = args->dp->i_mount;
+	dp = args->dp;
+	mp = dp->i_mount;
 	ASSERT(args != NULL);
 	ASSERT(oldblk->magic == XFS_DIR2_LEAFN_MAGIC);
 	error = xfs_da_grow_inode(args, &blkno);
@@ -1400,10 +1407,10 @@ xfs_dir2_leafn_split(
 	/*
 	 * Update last hashval in each block since we added the name.
 	 */
-	oldblk->hashval = xfs_dir2_leafn_lasthash(oldblk->bp, NULL);
-	newblk->hashval = xfs_dir2_leafn_lasthash(newblk->bp, NULL);
-	xfs_dir3_leaf_check(mp, oldblk->bp);
-	xfs_dir3_leaf_check(mp, newblk->bp);
+	oldblk->hashval = xfs_dir2_leafn_lasthash(dp, oldblk->bp, NULL);
+	newblk->hashval = xfs_dir2_leafn_lasthash(dp, newblk->bp, NULL);
+	xfs_dir3_leaf_check(dp, oldblk->bp);
+	xfs_dir3_leaf_check(dp, newblk->bp);
 	return error;
 }
 
@@ -1433,6 +1440,7 @@ xfs_dir2_leafn_toosmall(
 	int			rval;		/* result from path_shift */
 	struct xfs_dir3_icleaf_hdr leafhdr;
 	struct xfs_dir2_leaf_entry *ents;
+	struct xfs_inode	*dp = state->args->dp;
 
 	/*
 	 * Check for the degenerate case of the block being over 50% full.
@@ -1442,11 +1450,11 @@ xfs_dir2_leafn_toosmall(
 	blk = &state->path.blk[state->path.active - 1];
 	leaf = blk->bp->b_addr;
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
-	ents = xfs_dir3_leaf_ents_p(leaf);
-	xfs_dir3_leaf_check(state->args->dp->i_mount, blk->bp);
+	ents = dp->d_ops->leaf_ents_p(leaf);
+	xfs_dir3_leaf_check(dp, blk->bp);
 
 	count = leafhdr.count - leafhdr.stale;
-	bytes = xfs_dir3_leaf_hdr_size(leaf) + count * sizeof(ents[0]);
+	bytes = dp->d_ops->leaf_hdr_size() + count * sizeof(ents[0]);
 	if (bytes > (state->blocksize >> 1)) {
 		/*
 		 * Blk over 50%, don't try to join.
@@ -1491,7 +1499,7 @@ xfs_dir2_leafn_toosmall(
 		/*
 		 * Read the sibling leaf block.
 		 */
-		error = xfs_dir3_leafn_read(state->args->trans, state->args->dp,
+		error = xfs_dir3_leafn_read(state->args->trans, dp,
 					    blkno, -1, &bp);
 		if (error)
 			return error;
@@ -1504,7 +1512,7 @@ xfs_dir2_leafn_toosmall(
 
 		leaf = bp->b_addr;
 		xfs_dir3_leaf_hdr_from_disk(&hdr2, leaf);
-		ents = xfs_dir3_leaf_ents_p(leaf);
+		ents = dp->d_ops->leaf_ents_p(leaf);
 		count += hdr2.count - hdr2.stale;
 		bytes -= count * sizeof(ents[0]);
 
@@ -1558,6 +1566,7 @@ xfs_dir2_leafn_unbalance(
 	struct xfs_dir3_icleaf_hdr drophdr;
 	struct xfs_dir2_leaf_entry *sents;
 	struct xfs_dir2_leaf_entry *dents;
+	struct xfs_inode	*dp = state->args->dp;
 
 	args = state->args;
 	ASSERT(drop_blk->magic == XFS_DIR2_LEAFN_MAGIC);
@@ -1567,8 +1576,8 @@ xfs_dir2_leafn_unbalance(
 
 	xfs_dir3_leaf_hdr_from_disk(&savehdr, save_leaf);
 	xfs_dir3_leaf_hdr_from_disk(&drophdr, drop_leaf);
-	sents = xfs_dir3_leaf_ents_p(save_leaf);
-	dents = xfs_dir3_leaf_ents_p(drop_leaf);
+	sents = args->dp->d_ops->leaf_ents_p(save_leaf);
+	dents = args->dp->d_ops->leaf_ents_p(drop_leaf);
 
 	/*
 	 * If there are any stale leaf entries, take this opportunity
@@ -1583,7 +1592,7 @@ xfs_dir2_leafn_unbalance(
 	 * Move the entries from drop to the appropriate end of save.
 	 */
 	drop_blk->hashval = be32_to_cpu(dents[drophdr.count - 1].hashval);
-	if (xfs_dir2_leafn_order(save_blk->bp, drop_blk->bp))
+	if (xfs_dir2_leafn_order(dp, save_blk->bp, drop_blk->bp))
 		xfs_dir3_leafn_moveents(args, drop_blk->bp, &drophdr, dents, 0,
 					save_blk->bp, &savehdr, sents, 0,
 					drophdr.count);
@@ -1596,11 +1605,11 @@ xfs_dir2_leafn_unbalance(
 	/* log the changes made when moving the entries */
 	xfs_dir3_leaf_hdr_to_disk(save_leaf, &savehdr);
 	xfs_dir3_leaf_hdr_to_disk(drop_leaf, &drophdr);
-	xfs_dir3_leaf_log_header(args->trans, save_blk->bp);
-	xfs_dir3_leaf_log_header(args->trans, drop_blk->bp);
+	xfs_dir3_leaf_log_header(args->trans, dp, save_blk->bp);
+	xfs_dir3_leaf_log_header(args->trans, dp, drop_blk->bp);
 
-	xfs_dir3_leaf_check(args->dp->i_mount, save_blk->bp);
-	xfs_dir3_leaf_check(args->dp->i_mount, drop_blk->bp);
+	xfs_dir3_leaf_check(dp, save_blk->bp);
+	xfs_dir3_leaf_check(dp, drop_blk->bp);
 }
 
 /*
@@ -2211,7 +2220,7 @@ xfs_dir2_node_replace(
 		blk = &state->path.blk[state->path.active - 1];
 		ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
 		leaf = blk->bp->b_addr;
-		ents = xfs_dir3_leaf_ents_p(leaf);
+		ents = args->dp->d_ops->leaf_ents_p(leaf);
 		lep = &ents[blk->index];
 		ASSERT(state->extravalid);
 		/*
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 9a69f20..3e4b5ba 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -77,9 +77,9 @@ extern void xfs_dir3_leaf_compact_x1(struct xfs_dir3_icleaf_hdr *leafhdr,
 		int *lowstalep, int *highstalep, int *lowlogp, int *highlogp);
 extern int xfs_dir3_leaf_get_buf(struct xfs_da_args *args, xfs_dir2_db_t bno,
 		struct xfs_buf **bpp, __uint16_t magic);
-extern void xfs_dir3_leaf_log_ents(struct xfs_trans *tp, struct xfs_buf *bp,
-		int first, int last);
-extern void xfs_dir3_leaf_log_header(struct xfs_trans *tp,
+extern void xfs_dir3_leaf_log_ents(struct xfs_trans *tp, struct xfs_inode *dp,
+		struct xfs_buf *bp, int first, int last);
+extern void xfs_dir3_leaf_log_header(struct xfs_trans *tp, struct xfs_inode *dp,
 		struct xfs_buf *bp);
 extern int xfs_dir2_leaf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_leaf_removename(struct xfs_da_args *args);
@@ -98,17 +98,18 @@ extern void xfs_dir3_leaf_hdr_from_disk(struct xfs_dir3_icleaf_hdr *to,
 		struct xfs_dir2_leaf *from);
 extern void xfs_dir3_leaf_hdr_to_disk(struct xfs_dir2_leaf *to,
 		struct xfs_dir3_icleaf_hdr *from);
-extern bool xfs_dir3_leaf_check_int(struct xfs_mount *mp,
+extern bool xfs_dir3_leaf_check_int(struct xfs_mount *mp, struct xfs_inode *dp,
 		struct xfs_dir3_icleaf_hdr *hdr, struct xfs_dir2_leaf *leaf);
 
 /* xfs_dir2_node.c */
 extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
 		struct xfs_buf *lbp);
-extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_buf *bp, int *count);
+extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_inode *dp,
+		struct xfs_buf *bp, int *count);
 extern int xfs_dir2_leafn_lookup_int(struct xfs_buf *bp,
 		struct xfs_da_args *args, int *indexp,
 		struct xfs_da_state *state);
-extern int xfs_dir2_leafn_order(struct xfs_buf *leaf1_bp,
+extern int xfs_dir2_leafn_order(struct xfs_inode *dp, struct xfs_buf *leaf1_bp,
 		struct xfs_buf *leaf2_bp);
 extern int xfs_dir2_leafn_split(struct xfs_da_state *state,
 	struct xfs_da_state_blk *oldblk, struct xfs_da_state_blk *newblk);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
