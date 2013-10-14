Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B51DD7F6D
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 17:18:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A0BD304059
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 15:18:24 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lPW10GcXyb0uj81g for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 15:18:21 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VVqSm-0004xM-HD
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 09:18:08 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VVqSm-0005jz-GB
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 09:18:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 19/19] xfs: convert directory vector functions to constants
Date: Tue, 15 Oct 2013 09:18:05 +1100
Message-Id: <1381789085-21923-20-git-send-email-david@fromorbit.com>
In-Reply-To: <1381789085-21923-1-git-send-email-david@fromorbit.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
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

Many of the vectorised function calls now take no parameters and
return a constant value. There is no reason for these to be vectored
functions, so convert them to constants

Binary sizes:

   text    data     bss     dec     hex filename
 794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
 792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
 792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
 789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
 789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
 789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
 789733   96802    1096  887631   d8b4f fs/xfs/xfs.o.p6
 791421   96802    1096  889319   d91e7 fs/xfs/xfs.o.p7
 791701   96802    1096  889599   d92ff fs/xfs/xfs.o.p8
 791205   96802    1096  889103   d91cf fs/xfs/xfs.o.p9

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_btree.c     |  14 ++-
 fs/xfs/xfs_da_format.c    | 222 +++++++++++++++++-----------------------------
 fs/xfs/xfs_dir2.c         |   2 +-
 fs/xfs/xfs_dir2.h         |  14 +--
 fs/xfs/xfs_dir2_block.c   |   4 +-
 fs/xfs/xfs_dir2_data.c    |   8 +-
 fs/xfs/xfs_dir2_leaf.c    |   6 +-
 fs/xfs/xfs_dir2_node.c    |   8 +-
 fs/xfs/xfs_dir2_readdir.c |   6 +-
 fs/xfs/xfs_dir2_sf.c      |   6 +-
 10 files changed, 113 insertions(+), 177 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index a51762d..796272a 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -333,8 +333,7 @@ xfs_da3_node_create(
 
 	dp->d_ops->node_hdr_to_disk(node, &ichdr);
 	xfs_trans_log_buf(tp, bp,
-		XFS_DA_LOGRANGE(node, &node->hdr,
-				dp->d_ops->node_hdr_size()));
+		XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
 
 	*bpp = bp;
 	return(0);
@@ -838,13 +837,12 @@ xfs_da3_node_rebalance(
 	 */
 	dp->d_ops->node_hdr_to_disk(node1, &nodehdr1);
 	xfs_trans_log_buf(tp, blk1->bp,
-		XFS_DA_LOGRANGE(node1, &node1->hdr,
-				dp->d_ops->node_hdr_size()));
+		XFS_DA_LOGRANGE(node1, &node1->hdr, dp->d_ops->node_hdr_size));
 
 	dp->d_ops->node_hdr_to_disk(node2, &nodehdr2);
 	xfs_trans_log_buf(tp, blk2->bp,
 		XFS_DA_LOGRANGE(node2, &node2->hdr,
-				dp->d_ops->node_hdr_size() +
+				dp->d_ops->node_hdr_size +
 				(sizeof(btree2[0]) * nodehdr2.count)));
 
 	/*
@@ -915,7 +913,7 @@ xfs_da3_node_add(
 	nodehdr.count += 1;
 	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
 	xfs_trans_log_buf(state->args->trans, oldblk->bp,
-		XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size()));
+		XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
 
 	/*
 	 * Copy the last hash value from the oldblk to propagate upwards.
@@ -1350,7 +1348,7 @@ xfs_da3_node_remove(
 	nodehdr.count -= 1;
 	dp->d_ops->node_hdr_to_disk(node, &nodehdr);
 	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
-	    XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size()));
+	    XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
 
 	/*
 	 * Copy the last hash value from the block to propagate upwards.
@@ -1423,7 +1421,7 @@ xfs_da3_node_unbalance(
 	dp->d_ops->node_hdr_to_disk(save_node, &save_hdr);
 	xfs_trans_log_buf(tp, save_blk->bp,
 		XFS_DA_LOGRANGE(save_node, &save_node->hdr,
-				dp->d_ops->node_hdr_size()));
+				dp->d_ops->node_hdr_size));
 
 	/*
 	 * Save the last hashval in the remaining block for upward propagation.
diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
index a76b044e..5991b26 100644
--- a/fs/xfs/xfs_da_format.c
+++ b/fs/xfs/xfs_da_format.c
@@ -209,31 +209,41 @@ xfs_dir3_sfe_put_ino(
 /*
  * Directory data block operations
  */
-static int
-__xfs_dir3_data_entsize(
-	bool	ftype,
-	int	n)
-{
-	int	size = offsetof(struct xfs_dir2_data_entry, name[0]);
 
-	size += n;
-	size += sizeof(xfs_dir2_data_off_t);
-	if (ftype)
-		size += sizeof(__uint8_t);
-	return roundup(size, XFS_DIR2_DATA_ALIGN);
-}
+/*
+ * For special situations, the dirent size ends up fixed because we always know
+ * what the size of the entry is. That's true for the "." and "..", and
+ * therefore we know that they are a fixed size and hence their offsets are
+ * constant, as is the first entry.
+ *
+ * Hence, this calculation is written as a macro to be able to be calculated at
+ * compile time and so certain offsets can be calculated directly in the
+ * structure initaliser via the macro. There are two macros - one for dirents
+ * with ftype and without so there are no unresolvable conditionals in the
+ * calculations. We also use round_up() as XFS_DIR2_DATA_ALIGN is always a power
+ * of 2 and the compiler doesn't reject it (unlike roundup()).
+ */
+#define XFS_DIR2_DATA_ENTSIZE(n)					\
+	round_up((offsetof(struct xfs_dir2_data_entry, name[0]) + (n) +	\
+		 sizeof(xfs_dir2_data_off_t)), XFS_DIR2_DATA_ALIGN)
+
+#define XFS_DIR3_DATA_ENTSIZE(n)					\
+	round_up((offsetof(struct xfs_dir2_data_entry, name[0]) + (n) +	\
+		 sizeof(xfs_dir2_data_off_t) + sizeof(__uint8_t)),	\
+		XFS_DIR2_DATA_ALIGN)
 
 static int
 xfs_dir2_data_entsize(
 	int			n)
 {
-	return __xfs_dir3_data_entsize(false, n);
+	return XFS_DIR2_DATA_ENTSIZE(n);
 }
+
 static int
 xfs_dir3_data_entsize(
 	int			n)
 {
-	return __xfs_dir3_data_entsize(true, n);
+	return XFS_DIR3_DATA_ENTSIZE(n);
 }
 
 static __uint8_t
@@ -294,45 +304,6 @@ xfs_dir3_data_entry_tag_p(
 }
 
 /*
- * Offsets of . and .. in data space (always block 0)
- */
-static xfs_dir2_data_aoff_t
-xfs_dir2_data_dot_offset(void)
-{
-	return sizeof(struct xfs_dir2_data_hdr);
-}
-
-static xfs_dir2_data_aoff_t
-xfs_dir2_data_dotdot_offset(void)
-{
-	return xfs_dir2_data_dot_offset() + xfs_dir2_data_entsize(1);
-}
-
-static xfs_dir2_data_aoff_t
-xfs_dir2_data_first_offset(void)
-{
-	return xfs_dir2_data_dotdot_offset() + xfs_dir2_data_entsize(2);
-}
-
-static xfs_dir2_data_aoff_t
-xfs_dir3_data_dot_offset(void)
-{
-	return sizeof(struct xfs_dir3_data_hdr);
-}
-
-static xfs_dir2_data_aoff_t
-xfs_dir3_data_dotdot_offset(void)
-{
-	return xfs_dir3_data_dot_offset() + xfs_dir3_data_entsize(1);
-}
-
-static xfs_dir2_data_aoff_t
-xfs_dir3_data_first_offset(void)
-{
-	return xfs_dir3_data_dotdot_offset() + xfs_dir3_data_entsize(2);
-}
-
-/*
  * location of . and .. in data space (always block 0)
  */
 static struct xfs_dir2_data_entry *
@@ -340,7 +311,7 @@ xfs_dir2_data_dot_entry_p(
 	struct xfs_dir2_data_hdr *hdr)
 {
 	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir2_data_dot_offset());
+		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
 }
 
 static struct xfs_dir2_data_entry *
@@ -348,7 +319,8 @@ xfs_dir2_data_dotdot_entry_p(
 	struct xfs_dir2_data_hdr *hdr)
 {
 	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir2_data_dotdot_offset());
+		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
+				XFS_DIR2_DATA_ENTSIZE(1));
 }
 
 static struct xfs_dir2_data_entry *
@@ -356,7 +328,9 @@ xfs_dir2_data_first_entry_p(
 	struct xfs_dir2_data_hdr *hdr)
 {
 	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir2_data_first_offset());
+		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
+				XFS_DIR2_DATA_ENTSIZE(1) +
+				XFS_DIR2_DATA_ENTSIZE(2));
 }
 
 static struct xfs_dir2_data_entry *
@@ -364,7 +338,7 @@ xfs_dir3_data_dot_entry_p(
 	struct xfs_dir2_data_hdr *hdr)
 {
 	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir3_data_dot_offset());
+		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
 }
 
 static struct xfs_dir2_data_entry *
@@ -372,7 +346,8 @@ xfs_dir3_data_dotdot_entry_p(
 	struct xfs_dir2_data_hdr *hdr)
 {
 	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir3_data_dotdot_offset());
+		((char *)hdr + sizeof(struct xfs_dir3_data_hdr) +
+				XFS_DIR2_DATA_ENTSIZE(1));
 }
 
 static struct xfs_dir2_data_entry *
@@ -380,7 +355,9 @@ xfs_dir3_data_first_entry_p(
 	struct xfs_dir2_data_hdr *hdr)
 {
 	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir3_data_first_offset());
+		((char *)hdr + sizeof(struct xfs_dir3_data_hdr) +
+				XFS_DIR2_DATA_ENTSIZE(1) +
+				XFS_DIR2_DATA_ENTSIZE(2));
 }
 
 static struct xfs_dir2_data_free *
@@ -395,44 +372,32 @@ xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
 	return ((struct xfs_dir3_data_hdr *)hdr)->best_free;
 }
 
-static size_t
-xfs_dir2_data_entry_offset(void)
-{
-	return sizeof(struct xfs_dir2_data_hdr);
-}
-
 static struct xfs_dir2_data_entry *
 xfs_dir2_data_entry_p(struct xfs_dir2_data_hdr *hdr)
 {
 	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir2_data_entry_offset());
+		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
 }
 
 static struct xfs_dir2_data_unused *
 xfs_dir2_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 {
 	return (struct xfs_dir2_data_unused *)
-		((char *)hdr + xfs_dir2_data_entry_offset());
-}
-
-static size_t
-xfs_dir3_data_entry_offset(void)
-{
-	return sizeof(struct xfs_dir3_data_hdr);
+		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
 }
 
 static struct xfs_dir2_data_entry *
 xfs_dir3_data_entry_p(struct xfs_dir2_data_hdr *hdr)
 {
 	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir3_data_entry_offset());
+		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
 }
 
 static struct xfs_dir2_data_unused *
 xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 {
 	return (struct xfs_dir2_data_unused *)
-		((char *)hdr + xfs_dir3_data_entry_offset());
+		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
 }
 
 
@@ -440,15 +405,9 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
  * Directory Leaf block operations
  */
 static int
-xfs_dir2_leaf_hdr_size(void)
-{
-	return sizeof(struct xfs_dir2_leaf_hdr);
-}
-
-static int
 xfs_dir2_max_leaf_ents(struct xfs_mount *mp)
 {
-	return (mp->m_dirblksize - xfs_dir2_leaf_hdr_size()) /
+	return (mp->m_dirblksize - sizeof(struct xfs_dir2_leaf_hdr)) /
 		(uint)sizeof(struct xfs_dir2_leaf_entry);
 }
 
@@ -459,15 +418,9 @@ xfs_dir2_leaf_ents_p(struct xfs_dir2_leaf *lp)
 }
 
 static int
-xfs_dir3_leaf_hdr_size(void)
-{
-	return sizeof(struct xfs_dir3_leaf_hdr);
-}
-
-static int
 xfs_dir3_max_leaf_ents(struct xfs_mount *mp)
 {
-	return (mp->m_dirblksize - xfs_dir3_leaf_hdr_size()) /
+	return (mp->m_dirblksize - sizeof(struct xfs_dir3_leaf_hdr)) /
 		(uint)sizeof(struct xfs_dir2_leaf_entry);
 }
 
@@ -545,25 +498,13 @@ xfs_dir3_leaf_hdr_to_disk(
 /*
  * Directory/Attribute Node block operations
  */
-static inline int
-xfs_da2_node_hdr_size(void)
-{
-	return sizeof(struct xfs_da_node_hdr);
-}
-
 static struct xfs_da_node_entry *
 xfs_da2_node_tree_p(struct xfs_da_intnode *dap)
 {
 	return dap->__btree;
 }
 
-static inline int
-xfs_da3_node_hdr_size(void)
-{
-	return sizeof(struct xfs_da3_node_hdr);
-}
-
-static inline struct xfs_da_node_entry *
+static struct xfs_da_node_entry *
 xfs_da3_node_tree_p(struct xfs_da_intnode *dap)
 {
 	return ((struct xfs_da3_intnode *)dap)->__btree;
@@ -630,22 +571,16 @@ xfs_da3_node_hdr_to_disk(
  * Directory free space block operations
  */
 static int
-xfs_dir2_free_hdr_size(void)
-{
-	return sizeof(struct xfs_dir2_free_hdr);
-}
-
-static int
 xfs_dir2_free_max_bests(struct xfs_mount *mp)
 {
-	return (mp->m_dirblksize - xfs_dir2_free_hdr_size()) /
+	return (mp->m_dirblksize - sizeof(struct xfs_dir2_free_hdr)) /
 		sizeof(xfs_dir2_data_off_t);
 }
 
 static __be16 *
 xfs_dir2_free_bests_p(struct xfs_dir2_free *free)
 {
-	return (__be16 *)((char *)free + xfs_dir2_free_hdr_size());
+	return (__be16 *)((char *)free + sizeof(struct xfs_dir2_free_hdr));
 }
 
 /*
@@ -667,22 +602,16 @@ xfs_dir2_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
 }
 
 static int
-xfs_dir3_free_hdr_size(void)
-{
-	return sizeof(struct xfs_dir3_free_hdr);
-}
-
-static int
 xfs_dir3_free_max_bests(struct xfs_mount *mp)
 {
-	return (mp->m_dirblksize - xfs_dir3_free_hdr_size()) /
+	return (mp->m_dirblksize - sizeof(struct xfs_dir3_free_hdr)) /
 		sizeof(xfs_dir2_data_off_t);
 }
 
 static __be16 *
 xfs_dir3_free_bests_p(struct xfs_dir2_free *free)
 {
-	return (__be16 *)((char *)free + xfs_dir3_free_hdr_size());
+	return (__be16 *)((char *)free + sizeof(struct xfs_dir3_free_hdr));
 }
 
 /*
@@ -774,10 +703,13 @@ const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_entry_tag_p = xfs_dir2_data_entry_tag_p,
 	.data_bestfree_p = xfs_dir2_data_bestfree_p,
 
-	.data_dot_offset = xfs_dir2_data_dot_offset,
-	.data_dotdot_offset = xfs_dir2_data_dotdot_offset,
-	.data_first_offset = xfs_dir2_data_first_offset,
-	.data_entry_offset = xfs_dir2_data_entry_offset,
+	.data_dot_offset = sizeof(struct xfs_dir2_data_hdr),
+	.data_dotdot_offset = sizeof(struct xfs_dir2_data_hdr) +
+				XFS_DIR2_DATA_ENTSIZE(1),
+	.data_first_offset =  sizeof(struct xfs_dir2_data_hdr) +
+				XFS_DIR2_DATA_ENTSIZE(1) +
+				XFS_DIR2_DATA_ENTSIZE(2),
+	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
 
 	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
 	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
@@ -785,18 +717,18 @@ const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
-	.leaf_hdr_size = xfs_dir2_leaf_hdr_size,
+	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
 	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
 	.leaf_hdr_from_disk = xfs_dir2_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
-	.node_hdr_size = xfs_da2_node_hdr_size,
+	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
 	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
 	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
 
-	.free_hdr_size = xfs_dir2_free_hdr_size,
+	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
 	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
 	.free_max_bests = xfs_dir2_free_max_bests,
@@ -821,10 +753,13 @@ const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
 	.data_bestfree_p = xfs_dir2_data_bestfree_p,
 
-	.data_dot_offset = xfs_dir2_data_dot_offset,
-	.data_dotdot_offset = xfs_dir2_data_dotdot_offset,
-	.data_first_offset = xfs_dir2_data_first_offset,
-	.data_entry_offset = xfs_dir2_data_entry_offset,
+	.data_dot_offset = sizeof(struct xfs_dir2_data_hdr),
+	.data_dotdot_offset = sizeof(struct xfs_dir2_data_hdr) +
+				XFS_DIR3_DATA_ENTSIZE(1),
+	.data_first_offset =  sizeof(struct xfs_dir2_data_hdr) +
+				XFS_DIR3_DATA_ENTSIZE(1) +
+				XFS_DIR3_DATA_ENTSIZE(2),
+	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
 
 	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
 	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
@@ -832,18 +767,18 @@ const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
-	.leaf_hdr_size = xfs_dir2_leaf_hdr_size,
+	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
 	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
 	.leaf_hdr_from_disk = xfs_dir2_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
-	.node_hdr_size = xfs_da2_node_hdr_size,
+	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
 	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
 	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
 
-	.free_hdr_size = xfs_dir2_free_hdr_size,
+	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
 	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
 	.free_max_bests = xfs_dir2_free_max_bests,
@@ -868,10 +803,13 @@ const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
 	.data_bestfree_p = xfs_dir3_data_bestfree_p,
 
-	.data_dot_offset = xfs_dir3_data_dot_offset,
-	.data_dotdot_offset = xfs_dir3_data_dotdot_offset,
-	.data_first_offset = xfs_dir3_data_first_offset,
-	.data_entry_offset = xfs_dir3_data_entry_offset,
+	.data_dot_offset = sizeof(struct xfs_dir3_data_hdr),
+	.data_dotdot_offset = sizeof(struct xfs_dir3_data_hdr) +
+				XFS_DIR3_DATA_ENTSIZE(1),
+	.data_first_offset =  sizeof(struct xfs_dir3_data_hdr) +
+				XFS_DIR3_DATA_ENTSIZE(1) +
+				XFS_DIR3_DATA_ENTSIZE(2),
+	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
 
 	.data_dot_entry_p = xfs_dir3_data_dot_entry_p,
 	.data_dotdot_entry_p = xfs_dir3_data_dotdot_entry_p,
@@ -879,35 +817,35 @@ const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_entry_p = xfs_dir3_data_entry_p,
 	.data_unused_p = xfs_dir3_data_unused_p,
 
-	.leaf_hdr_size = xfs_dir3_leaf_hdr_size,
+	.leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr),
 	.leaf_hdr_to_disk = xfs_dir3_leaf_hdr_to_disk,
 	.leaf_hdr_from_disk = xfs_dir3_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir3_max_leaf_ents,
 	.leaf_ents_p = xfs_dir3_leaf_ents_p,
 
-	.node_hdr_size = xfs_da3_node_hdr_size,
+	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
 	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
 	.node_hdr_from_disk = xfs_da3_node_hdr_from_disk,
 	.node_tree_p = xfs_da3_node_tree_p,
 
-	.free_hdr_size = xfs_dir3_free_hdr_size,
+	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
 	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
 	.free_hdr_from_disk = xfs_dir3_free_hdr_from_disk,
-	.free_max_bests = xfs_dir2_free_max_bests,
+	.free_max_bests = xfs_dir3_free_max_bests,
 	.free_bests_p = xfs_dir3_free_bests_p,
 	.db_to_fdb = xfs_dir3_db_to_fdb,
 	.db_to_fdindex = xfs_dir3_db_to_fdindex,
 };
 
 const struct xfs_dir_ops xfs_dir2_nondir_ops = {
-	.node_hdr_size = xfs_da2_node_hdr_size,
+	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
 	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
 	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
 };
 
 const struct xfs_dir_ops xfs_dir3_nondir_ops = {
-	.node_hdr_size = xfs_da3_node_hdr_size,
+	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
 	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
 	.node_hdr_from_disk = xfs_da3_node_hdr_from_disk,
 	.node_tree_p = xfs_da3_node_tree_p,
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 1b44e83..ce16ef0 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -105,7 +105,7 @@ xfs_dir_mount(
 	mp->m_dirleafblk = xfs_dir2_db_to_da(mp, XFS_DIR2_LEAF_FIRSTDB(mp));
 	mp->m_dirfreeblk = xfs_dir2_db_to_da(mp, XFS_DIR2_FREE_FIRSTDB(mp));
 
-	nodehdr_size = mp->m_dir_inode_ops->node_hdr_size();
+	nodehdr_size = mp->m_dir_inode_ops->node_hdr_size;
 	mp->m_attr_node_ents = (mp->m_sb.sb_blocksize - nodehdr_size) /
 				(uint)sizeof(xfs_da_node_entry_t);
 	mp->m_dir_node_ents = (mp->m_dirblksize - nodehdr_size) /
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 4264cb9..cec70e0 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -59,10 +59,10 @@ struct xfs_dir_ops {
 	struct xfs_dir2_data_free *
 		(*data_bestfree_p)(struct xfs_dir2_data_hdr *hdr);
 
-	xfs_dir2_data_aoff_t (*data_dot_offset)(void);
-	xfs_dir2_data_aoff_t (*data_dotdot_offset)(void);
-	xfs_dir2_data_aoff_t (*data_first_offset)(void);
-	size_t	(*data_entry_offset)(void);
+	xfs_dir2_data_aoff_t data_dot_offset;
+	xfs_dir2_data_aoff_t data_dotdot_offset;
+	xfs_dir2_data_aoff_t data_first_offset;
+	size_t	data_entry_offset;
 
 	struct xfs_dir2_data_entry *
 		(*data_dot_entry_p)(struct xfs_dir2_data_hdr *hdr);
@@ -75,7 +75,7 @@ struct xfs_dir_ops {
 	struct xfs_dir2_data_unused *
 		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
 
-	int	(*leaf_hdr_size)(void);
+	int	leaf_hdr_size;
 	void	(*leaf_hdr_to_disk)(struct xfs_dir2_leaf *to,
 				    struct xfs_dir3_icleaf_hdr *from);
 	void	(*leaf_hdr_from_disk)(struct xfs_dir3_icleaf_hdr *to,
@@ -84,7 +84,7 @@ struct xfs_dir_ops {
 	struct xfs_dir2_leaf_entry *
 		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
 
-	int	(*node_hdr_size)(void);
+	int	node_hdr_size;
 	void	(*node_hdr_to_disk)(struct xfs_da_intnode *to,
 				    struct xfs_da3_icnode_hdr *from);
 	void	(*node_hdr_from_disk)(struct xfs_da3_icnode_hdr *to,
@@ -92,7 +92,7 @@ struct xfs_dir_ops {
 	struct xfs_da_node_entry *
 		(*node_tree_p)(struct xfs_da_intnode *dap);
 
-	int	(*free_hdr_size)(void);
+	int	free_hdr_size;
 	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
 				    struct xfs_dir3_icfree_hdr *from);
 	void	(*free_hdr_from_disk)(struct xfs_dir3_icfree_hdr *to,
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 364fe3a..96b515b 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -951,7 +951,7 @@ xfs_dir2_leaf_to_block(
 	while (dp->i_d.di_size > mp->m_dirblksize) {
 		int hdrsz;
 
-		hdrsz = dp->d_ops->data_entry_offset();
+		hdrsz = dp->d_ops->data_entry_offset;
 		bestsp = xfs_dir2_leaf_bests_p(ltp);
 		if (be16_to_cpu(bestsp[be32_to_cpu(ltp->bestcount) - 1]) ==
 					    mp->m_dirblksize - hdrsz) {
@@ -1185,7 +1185,7 @@ xfs_dir2_sf_to_block(
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
 	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 				(char *)dep - (char *)hdr));
-	offset = dp->d_ops->data_first_offset();
+	offset = dp->d_ops->data_first_offset;
 	/*
 	 * Loop over existing entries, stuff them in.
 	 */
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index b4c482a..014fa6a 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -598,7 +598,7 @@ xfs_dir3_data_init(
 		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
 
 	bf = dp->d_ops->data_bestfree_p(hdr);
-	bf[0].offset = cpu_to_be16(dp->d_ops->data_entry_offset());
+	bf[0].offset = cpu_to_be16(dp->d_ops->data_entry_offset);
 	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
 		bf[i].length = 0;
 		bf[i].offset = 0;
@@ -610,7 +610,7 @@ xfs_dir3_data_init(
 	dup = dp->d_ops->data_unused_p(hdr);
 	dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 
-	t = mp->m_dirblksize - (uint)dp->d_ops->data_entry_offset();
+	t = mp->m_dirblksize - (uint)dp->d_ops->data_entry_offset;
 	bf[0].length = cpu_to_be16(t);
 	dup->length = cpu_to_be16(t);
 	*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16((char *)dup - (char *)hdr);
@@ -663,7 +663,7 @@ xfs_dir2_data_log_header(
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 #endif
 
-	xfs_trans_log_buf(tp, bp, 0, dp->d_ops->data_entry_offset() - 1);
+	xfs_trans_log_buf(tp, bp, 0, dp->d_ops->data_entry_offset - 1);
 }
 
 /*
@@ -742,7 +742,7 @@ xfs_dir2_data_make_free(
 	 * If this isn't the start of the block, then back up to
 	 * the previous entry and see if it's free.
 	 */
-	if (offset > dp->d_ops->data_entry_offset()) {
+	if (offset > dp->d_ops->data_entry_offset) {
 		__be16			*tagp;	/* tag just before us */
 
 		tagp = (__be16 *)((char *)hdr + offset) - 1;
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index a3c21b1..ae47ec6 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1116,7 +1116,7 @@ xfs_dir3_leaf_log_header(
 	       leaf->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC));
 
 	xfs_trans_log_buf(tp, bp, (uint)((char *)&leaf->hdr - (char *)leaf),
-			  dp->d_ops->leaf_hdr_size() - 1);
+			  dp->d_ops->leaf_hdr_size - 1);
 }
 
 /*
@@ -1424,7 +1424,7 @@ xfs_dir2_leaf_removename(
 	 * If the data block is now empty then get rid of the data block.
 	 */
 	if (be16_to_cpu(bf[0].length) ==
-			mp->m_dirblksize - dp->d_ops->data_entry_offset()) {
+			mp->m_dirblksize - dp->d_ops->data_entry_offset) {
 		ASSERT(db != mp->m_dirdatablk);
 		if ((error = xfs_dir2_shrink_inode(args, db, dbp))) {
 			/*
@@ -1623,7 +1623,7 @@ xfs_dir2_leaf_trim_data(
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
 	ASSERT(be16_to_cpu(bf[0].length) ==
-	       mp->m_dirblksize - dp->d_ops->data_entry_offset());
+	       mp->m_dirblksize - dp->d_ops->data_entry_offset);
 	ASSERT(db == be32_to_cpu(ltp->bestcount) - 1);
 }
 #endif
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 4bfdb79..30cbf10 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -274,7 +274,7 @@ xfs_dir2_free_log_header(
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 	       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 #endif
-	xfs_trans_log_buf(tp, bp, 0, dp->d_ops->free_hdr_size() - 1);
+	xfs_trans_log_buf(tp, bp, 0, dp->d_ops->free_hdr_size - 1);
 }
 
 /*
@@ -1268,7 +1268,7 @@ xfs_dir2_leafn_remove(
 		 * (usually).
 		 */
 		if (longest == mp->m_dirblksize -
-			       dp->d_ops->data_entry_offset()) {
+			       dp->d_ops->data_entry_offset) {
 			/*
 			 * Try to punch out the data block.
 			 */
@@ -1300,7 +1300,7 @@ xfs_dir2_leafn_remove(
 	 * Return indication of whether this leaf block is empty enough
 	 * to justify trying to join it with a neighbor.
 	 */
-	*rval = (dp->d_ops->leaf_hdr_size() +
+	*rval = (dp->d_ops->leaf_hdr_size +
 		 (uint)sizeof(ents[0]) * (leafhdr.count - leafhdr.stale)) <
 		mp->m_dir_magicpct;
 	return 0;
@@ -1409,7 +1409,7 @@ xfs_dir2_leafn_toosmall(
 	xfs_dir3_leaf_check(dp, blk->bp);
 
 	count = leafhdr.count - leafhdr.stale;
-	bytes = dp->d_ops->leaf_hdr_size() + count * sizeof(ents[0]);
+	bytes = dp->d_ops->leaf_hdr_size + count * sizeof(ents[0]);
 	if (bytes > (state->blocksize >> 1)) {
 		/*
 		 * Blk over 50%, don't try to join.
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index f45ecac..c4e50c6 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -119,9 +119,9 @@ xfs_dir2_sf_getdents(
 	 * mp->m_dirdatablk.
 	 */
 	dot_offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
-						dp->d_ops->data_dot_offset());
+						dp->d_ops->data_dot_offset);
 	dotdot_offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
-						dp->d_ops->data_dotdot_offset());
+						dp->d_ops->data_dotdot_offset);
 
 	/*
 	 * Put . entry unless we're starting past it.
@@ -584,7 +584,7 @@ xfs_dir2_leaf_getdents(
 			 * Skip past the header.
 			 */
 			if (byteoff == 0)
-				curoff += dp->d_ops->data_entry_offset();
+				curoff += dp->d_ops->data_entry_offset;
 			/*
 			 * Skip past entries until we reach our offset.
 			 */
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 42bbcff..aafc6e4 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -473,7 +473,7 @@ xfs_dir2_sf_addname_hard(
 	 * to insert the new entry.
 	 * If it's going to end up at the end then oldsfep will point there.
 	 */
-	for (offset = dp->d_ops->data_first_offset(),
+	for (offset = dp->d_ops->data_first_offset,
 	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
 	      add_datasize = dp->d_ops->data_entsize(args->namelen),
 	      eof = (char *)oldsfep == &buf[old_isize];
@@ -556,7 +556,7 @@ xfs_dir2_sf_addname_pick(
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	size = dp->d_ops->data_entsize(args->namelen);
-	offset = dp->d_ops->data_first_offset();
+	offset = dp->d_ops->data_first_offset;
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	holefit = 0;
 	/*
@@ -629,7 +629,7 @@ xfs_dir2_sf_check(
 	mp = dp->i_mount;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	offset = dp->d_ops->data_first_offset();
+	offset = dp->d_ops->data_first_offset;
 	ino = dp->d_ops->sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
