Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 854797F96
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 74062304087
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:57 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PFOAtHgW4AXqUliD for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:49 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVm-0003uY-8H
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:34 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVc-0001KW-3y
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/48] xfs: add CRCs to dir2/da node blocks
Date: Fri,  7 Jun 2013 10:25:37 +1000
Message-Id: <1370564771-4929-15-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/attr.c              |    4 +-
 db/check.c             |    8 +-
 db/dir2.c              |    4 +-
 include/xfs_da_btree.h |  106 +++-
 libxfs/xfs_attr.c      |   24 +-
 libxfs/xfs_attr_leaf.c |   17 +-
 libxfs/xfs_da_btree.c  | 1393 +++++++++++++++++++++++++++++-------------------
 libxfs/xfs_dir2_node.c |   26 +-
 repair/attr_repair.c   |   88 +--
 repair/dir2.c          |   96 ++--
 10 files changed, 1066 insertions(+), 700 deletions(-)

diff --git a/db/attr.c b/db/attr.c
index 74bf411..a5087b8 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -54,7 +54,7 @@ const field_t	attr_flds[] = {
 	  FLD_COUNT, TYP_NONE },
 	{ "entries", FLDT_ATTR_LEAF_ENTRY, OI(LOFF(entries)),
 	  attr_leaf_entries_count, FLD_ARRAY|FLD_COUNT, TYP_NONE },
-	{ "btree", FLDT_ATTR_NODE_ENTRY, OI(NOFF(btree)), attr_node_btree_count,
+	{ "btree", FLDT_ATTR_NODE_ENTRY, OI(NOFF(__btree)), attr_node_btree_count,
 	  FLD_ARRAY|FLD_COUNT, TYP_NONE },
 	{ "nvlist", FLDT_ATTR_LEAF_NAME, attr_leaf_nvlist_offset,
 	  attr_leaf_nvlist_count, FLD_ARRAY|FLD_OFFSET|FLD_COUNT, TYP_NONE },
@@ -144,7 +144,7 @@ const field_t	attr_node_entry_flds[] = {
 const field_t	attr_node_hdr_flds[] = {
 	{ "info", FLDT_ATTR_BLKINFO, OI(HOFF(info)), C1, 0, TYP_NONE },
 	{ "count", FLDT_UINT16D, OI(HOFF(count)), C1, 0, TYP_NONE },
-	{ "level", FLDT_UINT16D, OI(HOFF(level)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(HOFF(__level)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/check.c b/db/check.c
index 27107a0..5b7498f 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3072,6 +3072,7 @@ process_leaf_node_dir_v2_int(
 	xfs_dir2_leaf_tail_t	*ltp;
 	xfs_da_intnode_t	*node;
 	int			stale;
+	struct xfs_da3_icnode_hdr nodehdr;
 
 	leaf = iocur_top->data;
 	switch (be16_to_cpu(leaf->hdr.info.magic)) {
@@ -3120,13 +3121,12 @@ process_leaf_node_dir_v2_int(
 		break;
 	case XFS_DA_NODE_MAGIC:
 		node = iocur_top->data;
-		if (be16_to_cpu(node->hdr.level) < 1 ||
-					be16_to_cpu(node->hdr.level) > 
-							XFS_DA_NODE_MAXDEPTH) {
+		xfs_da3_node_hdr_from_disk(&nodehdr, node);
+		if (nodehdr.level < 1 || nodehdr.level > XFS_DA_NODE_MAXDEPTH) {
 			if (!sflag || v)
 				dbprintf(_("bad node block level %d for dir ino "
 					 "%lld block %d\n"),
-					be16_to_cpu(node->hdr.level), id->ino, 
+					nodehdr.level, id->ino, 
 					dabno);
 			error++;
 		}
diff --git a/db/dir2.c b/db/dir2.c
index 176bdab..590e993 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -86,7 +86,7 @@ const field_t	dir2_flds[] = {
 	  dir2_leaf_tail_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
 	{ "nhdr", FLDT_DA_NODE_HDR, OI(NOFF(hdr)), dir2_node_hdr_count,
 	  FLD_COUNT, TYP_NONE },
-	{ "nbtree", FLDT_DA_NODE_ENTRY, OI(NOFF(btree)), dir2_node_btree_count,
+	{ "nbtree", FLDT_DA_NODE_ENTRY, OI(NOFF(__btree)), dir2_node_btree_count,
 	  FLD_ARRAY|FLD_COUNT, TYP_NONE },
 	{ "fhdr", FLDT_DIR2_FREE_HDR, OI(FOFF(hdr)), dir2_free_hdr_count,
 	  FLD_COUNT, TYP_NONE },
@@ -185,7 +185,7 @@ const field_t	da_node_entry_flds[] = {
 const field_t	da_node_hdr_flds[] = {
 	{ "info", FLDT_DA_BLKINFO, OI(HOFF(info)), C1, 0, TYP_NONE },
 	{ "count", FLDT_UINT16D, OI(HOFF(count)), C1, 0, TYP_NONE },
-	{ "level", FLDT_UINT16D, OI(HOFF(level)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(HOFF(__level)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/include/xfs_da_btree.h b/include/xfs_da_btree.h
index 0854b95..6bedb3c 100644
--- a/include/xfs_da_btree.h
+++ b/include/xfs_da_btree.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000,2002,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -20,7 +21,6 @@
 
 struct xfs_bmap_free;
 struct xfs_inode;
-struct xfs_mount;
 struct xfs_trans;
 struct zone;
 
@@ -50,8 +50,11 @@ typedef struct xfs_da_blkinfo {
  * CRC enabled directory structure types
  *
  * The headers change size for the additional verification information, but
- * otherwise the tree layouts and contents are unchanged.
+ * otherwise the tree layouts and contents are unchanged. Hence the da btree
+ * code can use the struct xfs_da_blkinfo for manipulating the tree links and
+ * magic numbers without modification for both v2 and v3 nodes.
  */
+#define XFS_DA3_NODE_MAGIC	0x3ebe	/* magic number: non-leaf blocks */
 #define	XFS_DIR3_LEAF1_MAGIC	0x3df1	/* magic number: v2 dirlf single blks */
 #define	XFS_DIR3_LEAFN_MAGIC	0x3dff	/* magic number: v2 dirlf multi blks */
 
@@ -80,19 +83,76 @@ struct xfs_da3_blkinfo {
  */
 #define	XFS_DA_NODE_MAXDEPTH	5	/* max depth of Btree */
 
+typedef struct xfs_da_node_hdr {
+	struct xfs_da_blkinfo	info;	/* block type, links, etc. */
+	__be16			count; /* count of active entries */
+	__be16			__level; /* level above leaves (leaf == 0) */
+} xfs_da_node_hdr_t;
+
+struct xfs_da3_node_hdr {
+	struct xfs_da3_blkinfo	info;	/* block type, links, etc. */
+	__be16			count; /* count of active entries */
+	__be16			__level; /* level above leaves (leaf == 0) */
+	__be32			__pad32;
+};
+
+#define XFS_DA3_NODE_CRC_OFF	(offsetof(struct xfs_da3_node_hdr, info.crc))
+
+typedef struct xfs_da_node_entry {
+	__be32	hashval;	/* hash value for this descendant */
+	__be32	before;		/* Btree block before this key */
+} xfs_da_node_entry_t;
+
 typedef struct xfs_da_intnode {
-	struct xfs_da_node_hdr {	/* constant-structure header block */
-		xfs_da_blkinfo_t info;	/* block type, links, etc. */
-		__be16	count;		/* count of active entries */
-		__be16	level;		/* level above leaves (leaf == 0) */
-	} hdr;
-	struct xfs_da_node_entry {
-		__be32	hashval;	/* hash value for this descendant */
-		__be32	before;		/* Btree block before this key */
-	} btree[1];			/* variable sized array of keys */
+	struct xfs_da_node_hdr	hdr;
+	struct xfs_da_node_entry __btree[];
 } xfs_da_intnode_t;
-typedef struct xfs_da_node_hdr xfs_da_node_hdr_t;
-typedef struct xfs_da_node_entry xfs_da_node_entry_t;
+
+struct xfs_da3_intnode {
+	struct xfs_da3_node_hdr	hdr;
+	struct xfs_da_node_entry __btree[];
+};
+
+/*
+ * In-core version of the node header to abstract the differences in the v2 and
+ * v3 disk format of the headers. Callers need to convert to/from disk format as
+ * appropriate.
+ */
+struct xfs_da3_icnode_hdr {
+	__uint32_t	forw;
+	__uint32_t	back;
+	__uint16_t	magic;
+	__uint16_t	count;
+	__uint16_t	level;
+};
+
+extern void xfs_da3_node_hdr_from_disk(struct xfs_da3_icnode_hdr *to,
+				       struct xfs_da_intnode *from);
+extern void xfs_da3_node_hdr_to_disk(struct xfs_da_intnode *to,
+				     struct xfs_da3_icnode_hdr *from);
+
+static inline int
+xfs_da3_node_hdr_size(struct xfs_da_intnode *dap)
+{
+	if (dap->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC))
+		return sizeof(struct xfs_da3_node_hdr);
+	return sizeof(struct xfs_da_node_hdr);
+}
+
+static inline struct xfs_da_node_entry *
+xfs_da3_node_tree_p(struct xfs_da_intnode *dap)
+{
+	if (dap->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC)) {
+		struct xfs_da3_intnode *dap3 = (struct xfs_da3_intnode *)dap;
+		return dap3->__btree;
+	}
+	return dap->__btree;
+}
+
+extern void xfs_da3_intnode_from_disk(struct xfs_da3_icnode_hdr *to,
+				      struct xfs_da_intnode *from);
+extern void xfs_da3_intnode_to_disk(struct xfs_da_intnode *to,
+				    struct xfs_da3_icnode_hdr *from);
 
 #define	XFS_LBSIZE(mp)	(mp)->m_sb.sb_blocksize
 
@@ -214,29 +274,29 @@ struct xfs_nameops {
 /*
  * Routines used for growing the Btree.
  */
-int	xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,
-					 struct xfs_buf **bpp, int whichfork);
-int	xfs_da_split(xfs_da_state_t *state);
+int	xfs_da3_node_create(struct xfs_da_args *args, xfs_dablk_t blkno,
+			    int level, struct xfs_buf **bpp, int whichfork);
+int	xfs_da3_split(xfs_da_state_t *state);
 
 /*
  * Routines used for shrinking the Btree.
  */
-int	xfs_da_join(xfs_da_state_t *state);
-void	xfs_da_fixhashpath(xfs_da_state_t *state,
-					  xfs_da_state_path_t *path_to_to_fix);
+int	xfs_da3_join(xfs_da_state_t *state);
+void	xfs_da3_fixhashpath(struct xfs_da_state *state,
+			    struct xfs_da_state_path *path_to_to_fix);
 
 /*
  * Routines used for finding things in the Btree.
  */
-int	xfs_da_node_lookup_int(xfs_da_state_t *state, int *result);
-int	xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
+int	xfs_da3_node_lookup_int(xfs_da_state_t *state, int *result);
+int	xfs_da3_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
 					 int forward, int release, int *result);
 /*
  * Utility routines.
  */
-int	xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
+int	xfs_da3_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 				       xfs_da_state_blk_t *new_blk);
-int	xfs_da_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
+int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			 xfs_dablk_t bno, xfs_daddr_t mappedbno,
 			 struct xfs_buf **bpp, int which_fork);
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2adf92b..bb2ccf2 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -967,7 +967,7 @@ restart:
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	error = xfs_da_node_lookup_int(state, &retval);
+	error = xfs_da3_node_lookup_int(state, &retval);
 	if (error)
 		goto out;
 	blk = &state->path.blk[ state->path.active-1 ];
@@ -1038,7 +1038,7 @@ restart:
 		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
 		 */
 		xfs_bmap_init(args->flist, args->firstblock);
-		error = xfs_da_split(state);
+		error = xfs_da3_split(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
 						&committed);
@@ -1060,7 +1060,7 @@ restart:
 		/*
 		 * Addition succeeded, update Btree hashvals.
 		 */
-		xfs_da_fixhashpath(state, &state->path);
+		xfs_da3_fixhashpath(state, &state->path);
 	}
 
 	/*
@@ -1131,7 +1131,7 @@ restart:
 		state->blocksize = state->mp->m_sb.sb_blocksize;
 		state->node_ents = state->mp->m_attr_node_ents;
 		state->inleaf = 0;
-		error = xfs_da_node_lookup_int(state, &retval);
+		error = xfs_da3_node_lookup_int(state, &retval);
 		if (error)
 			goto out;
 
@@ -1141,14 +1141,14 @@ restart:
 		blk = &state->path.blk[ state->path.active-1 ];
 		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 		error = xfs_attr_leaf_remove(blk->bp, args);
-		xfs_da_fixhashpath(state, &state->path);
+		xfs_da3_fixhashpath(state, &state->path);
 
 		/*
 		 * Check to see if the tree needs to be collapsed.
 		 */
 		if (retval && (state->path.active > 1)) {
 			xfs_bmap_init(args->flist, args->firstblock);
-			error = xfs_da_join(state);
+			error = xfs_da3_join(state);
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
 							args->flist,
@@ -1226,7 +1226,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
-	error = xfs_da_node_lookup_int(state, &retval);
+	error = xfs_da3_node_lookup_int(state, &retval);
 	if (error || (retval != EEXIST)) {
 		if (error == 0)
 			error = retval;
@@ -1277,14 +1277,14 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 	retval = xfs_attr_leaf_remove(blk->bp, args);
-	xfs_da_fixhashpath(state, &state->path);
+	xfs_da3_fixhashpath(state, &state->path);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
 	 */
 	if (retval && (state->path.active > 1)) {
 		xfs_bmap_init(args->flist, args->firstblock);
-		error = xfs_da_join(state);
+		error = xfs_da3_join(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
 						&committed);
@@ -1430,7 +1430,7 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->disk_blkno) {
-			error = xfs_da_node_read(state->args->trans,
+			error = xfs_da3_node_read(state->args->trans,
 						state->args->dp,
 						blk->blkno, blk->disk_blkno,
 						&blk->bp, XFS_ATTR_FORK);
@@ -1449,7 +1449,7 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->disk_blkno) {
-			error = xfs_da_node_read(state->args->trans,
+			error = xfs_da3_node_read(state->args->trans,
 						state->args->dp,
 						blk->blkno, blk->disk_blkno,
 						&blk->bp, XFS_ATTR_FORK);
@@ -1489,7 +1489,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
-	error = xfs_da_node_lookup_int(state, &retval);
+	error = xfs_da3_node_lookup_int(state, &retval);
 	if (error) {
 		retval = error;
 	} else if (retval == EEXIST) {
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 85cb31d..cb37198 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -703,6 +703,7 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
 	struct xfs_buf *bp1, *bp2;
 	xfs_dablk_t blkno;
 	int error;
+	struct xfs_da_node_entry *btree;
 
 	trace_xfs_attr_leaf_to_node(args);
 
@@ -728,16 +729,16 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
 	/*
 	 * Set up the new root node.
 	 */
-	error = xfs_da_node_create(args, 0, 1, &bp1, XFS_ATTR_FORK);
+	error = xfs_da3_node_create(args, 0, 1, &bp1, XFS_ATTR_FORK);
 	if (error)
 		goto out;
 	node = bp1->b_addr;
 	leaf = bp2->b_addr;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	/* both on-disk, don't endian-flip twice */
-	node->btree[0].hashval =
-		leaf->entries[be16_to_cpu(leaf->hdr.count)-1 ].hashval;
-	node->btree[0].before = cpu_to_be32(blkno);
+	btree = xfs_da3_node_tree_p(node);
+	btree[0].hashval = leaf->entries[be16_to_cpu(leaf->hdr.count)-1 ].hashval;
+	btree[0].before = cpu_to_be32(blkno);
 	node->hdr.count = cpu_to_be16(1);
 	xfs_trans_log_buf(args->trans, bp1, 0, XFS_LBSIZE(dp->i_mount) - 1);
 	error = 0;
@@ -825,7 +826,7 @@ xfs_attr_leaf_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	 * NOTE: rebalance() currently depends on the 2nd block being empty.
 	 */
 	xfs_attr_leaf_rebalance(state, oldblk, newblk);
-	error = xfs_da_blk_link(state, oldblk, newblk);
+	error = xfs_da3_blk_link(state, oldblk, newblk);
 	if (error)
 		return(error);
 
@@ -1453,7 +1454,7 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
 		 */
 		forward = (info->forw != 0);
 		memcpy(&state->altpath, &state->path, sizeof(state->path));
-		error = xfs_da_path_shift(state, &state->altpath, forward,
+		error = xfs_da3_path_shift(state, &state->altpath, forward,
 						 0, &retval);
 		if (error)
 			return(error);
@@ -1510,10 +1511,10 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
 	 */
 	memcpy(&state->altpath, &state->path, sizeof(state->path));
 	if (blkno < blk->blkno) {
-		error = xfs_da_path_shift(state, &state->altpath, forward,
+		error = xfs_da3_path_shift(state, &state->altpath, forward,
 						 0, &retval);
 	} else {
-		error = xfs_da_path_shift(state, &state->path, forward,
+		error = xfs_da3_path_shift(state, &state->path, forward,
 						 0, &retval);
 	}
 	if (error)
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 63cd299..3176626 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -31,69 +32,195 @@
 /*
  * Routines used for growing the Btree.
  */
-STATIC int xfs_da_root_split(xfs_da_state_t *state,
+STATIC int xfs_da3_root_split(xfs_da_state_t *state,
 					    xfs_da_state_blk_t *existing_root,
 					    xfs_da_state_blk_t *new_child);
-STATIC int xfs_da_node_split(xfs_da_state_t *state,
+STATIC int xfs_da3_node_split(xfs_da_state_t *state,
 					    xfs_da_state_blk_t *existing_blk,
 					    xfs_da_state_blk_t *split_blk,
 					    xfs_da_state_blk_t *blk_to_add,
 					    int treelevel,
 					    int *result);
-STATIC void xfs_da_node_rebalance(xfs_da_state_t *state,
+STATIC void xfs_da3_node_rebalance(xfs_da_state_t *state,
 					 xfs_da_state_blk_t *node_blk_1,
 					 xfs_da_state_blk_t *node_blk_2);
-STATIC void xfs_da_node_add(xfs_da_state_t *state,
+STATIC void xfs_da3_node_add(xfs_da_state_t *state,
 				   xfs_da_state_blk_t *old_node_blk,
 				   xfs_da_state_blk_t *new_node_blk);
 
 /*
  * Routines used for shrinking the Btree.
  */
-STATIC int xfs_da_root_join(xfs_da_state_t *state,
+STATIC int xfs_da3_root_join(xfs_da_state_t *state,
 					   xfs_da_state_blk_t *root_blk);
-STATIC int xfs_da_node_toosmall(xfs_da_state_t *state, int *retval);
-STATIC void xfs_da_node_remove(xfs_da_state_t *state,
+STATIC int xfs_da3_node_toosmall(xfs_da_state_t *state, int *retval);
+STATIC void xfs_da3_node_remove(xfs_da_state_t *state,
 					      xfs_da_state_blk_t *drop_blk);
-STATIC void xfs_da_node_unbalance(xfs_da_state_t *state,
+STATIC void xfs_da3_node_unbalance(xfs_da_state_t *state,
 					 xfs_da_state_blk_t *src_node_blk,
 					 xfs_da_state_blk_t *dst_node_blk);
 
 /*
  * Utility routines.
  */
-STATIC uint	xfs_da_node_lasthash(struct xfs_buf *bp, int *count);
-STATIC int	xfs_da_node_order(struct xfs_buf *node1_bp,
-				  struct xfs_buf *node2_bp);
-STATIC int	xfs_da_blk_unlink(xfs_da_state_t *state,
+STATIC int	xfs_da3_blk_unlink(xfs_da_state_t *state,
 				  xfs_da_state_blk_t *drop_blk,
 				  xfs_da_state_blk_t *save_blk);
-STATIC void	xfs_da_state_kill_altpath(xfs_da_state_t *state);
 
-static void
-xfs_da_node_verify(
+
+kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
+
+/*
+ * Allocate a dir-state structure.
+ * We don't put them on the stack since they're large.
+ */
+xfs_da_state_t *
+xfs_da_state_alloc(void)
+{
+	return kmem_zone_zalloc(xfs_da_state_zone, KM_NOFS);
+}
+
+/*
+ * Kill the altpath contents of a da-state structure.
+ */
+STATIC void
+xfs_da_state_kill_altpath(xfs_da_state_t *state)
+{
+	int	i;
+
+	for (i = 0; i < state->altpath.active; i++)
+		state->altpath.blk[i].bp = NULL;
+	state->altpath.active = 0;
+}
+
+/*
+ * Free a da-state structure.
+ */
+void
+xfs_da_state_free(xfs_da_state_t *state)
+{
+	xfs_da_state_kill_altpath(state);
+#ifdef DEBUG
+	memset((char *)state, 0, sizeof(*state));
+#endif /* DEBUG */
+	kmem_zone_free(xfs_da_state_zone, state);
+}
+
+void
+xfs_da3_node_hdr_from_disk(
+	struct xfs_da3_icnode_hdr	*to,
+	struct xfs_da_intnode		*from)
+{
+	ASSERT(from->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
+	       from->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC));
+
+	if (from->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC)) {
+		struct xfs_da3_node_hdr *hdr3 = (struct xfs_da3_node_hdr *)from;
+
+		to->forw = be32_to_cpu(hdr3->info.hdr.forw);
+		to->back = be32_to_cpu(hdr3->info.hdr.back);
+		to->magic = be16_to_cpu(hdr3->info.hdr.magic);
+		to->count = be16_to_cpu(hdr3->count);
+		to->level = be16_to_cpu(hdr3->__level);
+		return;
+	}
+	to->forw = be32_to_cpu(from->hdr.info.forw);
+	to->back = be32_to_cpu(from->hdr.info.back);
+	to->magic = be16_to_cpu(from->hdr.info.magic);
+	to->count = be16_to_cpu(from->hdr.count);
+	to->level = be16_to_cpu(from->hdr.__level);
+}
+
+void
+xfs_da3_node_hdr_to_disk(
+	struct xfs_da_intnode		*to,
+	struct xfs_da3_icnode_hdr	*from)
+{
+	ASSERT(from->magic == XFS_DA_NODE_MAGIC ||
+	       from->magic == XFS_DA3_NODE_MAGIC);
+
+	if (from->magic == XFS_DA3_NODE_MAGIC) {
+		struct xfs_da3_node_hdr *hdr3 = (struct xfs_da3_node_hdr *)to;
+
+		hdr3->info.hdr.forw = cpu_to_be32(from->forw);
+		hdr3->info.hdr.back = cpu_to_be32(from->back);
+		hdr3->info.hdr.magic = cpu_to_be16(from->magic);
+		hdr3->count = cpu_to_be16(from->count);
+		hdr3->__level = cpu_to_be16(from->level);
+		return;
+	}
+	to->hdr.info.forw = cpu_to_be32(from->forw);
+	to->hdr.info.back = cpu_to_be32(from->back);
+	to->hdr.info.magic = cpu_to_be16(from->magic);
+	to->hdr.count = cpu_to_be16(from->count);
+	to->hdr.__level = cpu_to_be16(from->level);
+}
+
+static bool
+xfs_da3_node_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_da_node_hdr *hdr = bp->b_addr;
-	int			block_ok = 0;
-
-	block_ok = hdr->info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC);
-	block_ok = block_ok &&
-			be16_to_cpu(hdr->level) > 0 &&
-			be16_to_cpu(hdr->count) > 0 ;
-	if (!block_ok) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	struct xfs_da_intnode	*hdr = bp->b_addr;
+	struct xfs_da3_icnode_hdr ichdr;
+
+	xfs_da3_node_hdr_from_disk(&ichdr, hdr);
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
+
+		if (ichdr.magic != XFS_DA3_NODE_MAGIC)
+			return false;
+
+		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_uuid))
+			return false;
+		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
+			return false;
+	} else {
+		if (ichdr.magic != XFS_DA_NODE_MAGIC)
+			return false;
 	}
+	if (ichdr.level == 0)
+		return false;
+	if (ichdr.level > XFS_DA_NODE_MAXDEPTH)
+		return false;
+	if (ichdr.count == 0)
+		return false;
+
+	/*
+	 * we don't know if the node is for and attribute or directory tree,
+	 * so only fail if the count is outside both bounds
+	 */
+	if (ichdr.count > mp->m_dir_node_ents &&
+	    ichdr.count > mp->m_attr_node_ents)
+		return false;
+
+	/* XXX: hash order check? */
 
+	return true;
 }
 
 static void
-xfs_da_node_write_verify(
+xfs_da3_node_write_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_da_node_verify(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
+
+	if (!xfs_da3_node_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (bip)
+		hdr3->info.lsn = cpu_to_be64(bip->bli_item.li_lsn);
+
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_DA3_NODE_CRC_OFF);
 }
 
 /*
@@ -103,16 +230,22 @@ xfs_da_node_write_verify(
  * format of the block being read.
  */
 static void
-xfs_da_node_read_verify(
+xfs_da3_node_read_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_da_blkinfo	*info = bp->b_addr;
 
 	switch (be16_to_cpu(info->magic)) {
+		case XFS_DA3_NODE_MAGIC:
+			if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+					      XFS_DA3_NODE_CRC_OFF))
+				break;
+			/* fall through */
 		case XFS_DA_NODE_MAGIC:
-			xfs_da_node_verify(bp);
-			break;
+			if (!xfs_da3_node_verify(bp))
+				break;
+			return;
 		case XFS_ATTR_LEAF_MAGIC:
 			bp->b_ops = &xfs_attr_leaf_buf_ops;
 			bp->b_ops->verify_read(bp);
@@ -123,21 +256,22 @@ xfs_da_node_read_verify(
 			bp->b_ops->verify_read(bp);
 			return;
 		default:
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-					     mp, info);
-			xfs_buf_ioerror(bp, EFSCORRUPTED);
 			break;
 	}
+
+	/* corrupt block */
+	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+	xfs_buf_ioerror(bp, EFSCORRUPTED);
 }
 
-const struct xfs_buf_ops xfs_da_node_buf_ops = {
-	.verify_read = xfs_da_node_read_verify,
-	.verify_write = xfs_da_node_write_verify,
+const struct xfs_buf_ops xfs_da3_node_buf_ops = {
+	.verify_read = xfs_da3_node_read_verify,
+	.verify_write = xfs_da3_node_write_verify,
 };
 
 
 int
-xfs_da_node_read(
+xfs_da3_node_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
@@ -146,7 +280,7 @@ xfs_da_node_read(
 	int			which_fork)
 {
 	return xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
-					which_fork, &xfs_da_node_buf_ops);
+					which_fork, &xfs_da3_node_buf_ops);
 }
 
 /*========================================================================
@@ -157,33 +291,45 @@ xfs_da_node_read(
  * Create the initial contents of an intermediate node.
  */
 int
-xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,
-				 struct xfs_buf **bpp, int whichfork)
+xfs_da3_node_create(
+	struct xfs_da_args	*args,
+	xfs_dablk_t		blkno,
+	int			level,
+	struct xfs_buf		**bpp,
+	int			whichfork)
 {
-	xfs_da_intnode_t *node;
-	struct xfs_buf *bp;
-	int error;
-	xfs_trans_t *tp;
+	struct xfs_da_intnode	*node;
+	struct xfs_trans	*tp = args->trans;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_da3_icnode_hdr ichdr = {0};
+	struct xfs_buf		*bp;
+	int			error;
 
 	trace_xfs_da_node_create(args);
+	ASSERT(level <= XFS_DA_NODE_MAXDEPTH);
 
-	tp = args->trans;
 	error = xfs_da_get_buf(tp, args->dp, blkno, -1, &bp, whichfork);
 	if (error)
 		return(error);
-	ASSERT(bp != NULL);
 	node = bp->b_addr;
-	node->hdr.info.forw = 0;
-	node->hdr.info.back = 0;
-	node->hdr.info.magic = cpu_to_be16(XFS_DA_NODE_MAGIC);
-	node->hdr.info.pad = 0;
-	node->hdr.count = 0;
-	node->hdr.level = cpu_to_be16(level);
 
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
+
+		ichdr.magic = XFS_DA3_NODE_MAGIC;
+		hdr3->info.blkno = cpu_to_be64(bp->b_bn);
+		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
+		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_uuid);
+	} else {
+		ichdr.magic = XFS_DA_NODE_MAGIC;
+	}
+	ichdr.level = level;
+
+	xfs_da3_node_hdr_to_disk(node, &ichdr);
 	xfs_trans_log_buf(tp, bp,
-		XFS_DA_LOGRANGE(node, &node->hdr, sizeof(node->hdr)));
+		XFS_DA_LOGRANGE(node, &node->hdr, xfs_da3_node_hdr_size(node)));
 
-	bp->b_ops = &xfs_da_node_buf_ops;
+	bp->b_ops = &xfs_da3_node_buf_ops;
 	*bpp = bp;
 	return(0);
 }
@@ -193,12 +339,18 @@ xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,
  * intermediate nodes, rebalance, etc.
  */
 int							/* error */
-xfs_da_split(xfs_da_state_t *state)
+xfs_da3_split(
+	struct xfs_da_state	*state)
 {
-	xfs_da_state_blk_t *oldblk, *newblk, *addblk;
-	xfs_da_intnode_t *node;
-	struct xfs_buf *bp;
-	int max, action, error, i;
+	struct xfs_da_state_blk	*oldblk;
+	struct xfs_da_state_blk	*newblk;
+	struct xfs_da_state_blk	*addblk;
+	struct xfs_da_intnode	*node;
+	struct xfs_buf		*bp;
+	int			max;
+	int			action;
+	int			error;
+	int			i;
 
 	trace_xfs_da_split(state->args);
 
@@ -260,7 +412,7 @@ xfs_da_split(xfs_da_state_t *state)
 			addblk = newblk;
 			break;
 		case XFS_DA_NODE_MAGIC:
-			error = xfs_da_node_split(state, oldblk, newblk, addblk,
+			error = xfs_da3_node_split(state, oldblk, newblk, addblk,
 							 max - i, &action);
 			addblk->bp = NULL;
 			if (error)
@@ -278,7 +430,7 @@ xfs_da_split(xfs_da_state_t *state)
 		/*
 		 * Update the btree to show the new hashval for this child.
 		 */
-		xfs_da_fixhashpath(state, &state->path);
+		xfs_da3_fixhashpath(state, &state->path);
 	}
 	if (!addblk)
 		return(0);
@@ -288,7 +440,7 @@ xfs_da_split(xfs_da_state_t *state)
 	 */
 	ASSERT(state->path.active == 0);
 	oldblk = &state->path.blk[0];
-	error = xfs_da_root_split(state, oldblk, addblk);
+	error = xfs_da3_root_split(state, oldblk, addblk);
 	if (error) {
 		addblk->bp = NULL;
 		return(error);	/* GROT: dir is inconsistent */
@@ -299,8 +451,10 @@ xfs_da_split(xfs_da_state_t *state)
 	 * just got bumped because of the addition of a new root node.
 	 * There might be three blocks involved if a double split occurred,
 	 * and the original block 0 could be at any position in the list.
+	 *
+	 * Note: the info structures being modified here for both v2 and v3 da
+	 * headers, so we can do this linkage just using the v2 structures.
 	 */
-
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) == addblk->blkno) {
@@ -339,18 +493,25 @@ xfs_da_split(xfs_da_state_t *state)
  * the EOF, extending the inode in process.
  */
 STATIC int						/* error */
-xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
-				 xfs_da_state_blk_t *blk2)
+xfs_da3_root_split(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*blk1,
+	struct xfs_da_state_blk	*blk2)
 {
-	xfs_da_intnode_t *node, *oldroot;
-	xfs_da_args_t *args;
-	xfs_dablk_t blkno;
-	struct xfs_buf *bp;
-	int error, size;
-	xfs_inode_t *dp;
-	xfs_trans_t *tp;
-	xfs_mount_t *mp;
-	xfs_dir2_leaf_t *leaf;
+	struct xfs_da_intnode	*node;
+	struct xfs_da_intnode	*oldroot;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr nodehdr;
+	struct xfs_da_args	*args;
+	struct xfs_buf		*bp;
+	struct xfs_inode	*dp;
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp;
+	struct xfs_dir2_leaf	*leaf;
+	xfs_dablk_t		blkno;
+	int			level;
+	int			error;
+	int			size;
 
 	trace_xfs_da_root_split(state->args);
 
@@ -359,22 +520,26 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	 * to a free space somewhere.
 	 */
 	args = state->args;
-	ASSERT(args != NULL);
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
-		return(error);
+		return error;
+
 	dp = args->dp;
 	tp = args->trans;
 	mp = state->mp;
 	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, args->whichfork);
 	if (error)
-		return(error);
-	ASSERT(bp != NULL);
+		return error;
 	node = bp->b_addr;
 	oldroot = blk1->bp->b_addr;
-	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC)) {
-		size = (int)((char *)&oldroot->btree[be16_to_cpu(oldroot->hdr.count)] -
-			     (char *)oldroot);
+	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
+	    oldroot->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC)) {
+		struct xfs_da3_icnode_hdr nodehdr;
+
+		xfs_da3_node_hdr_from_disk(&nodehdr, oldroot);
+		btree = xfs_da3_node_tree_p(oldroot);
+		size = (int)((char *)&btree[nodehdr.count] - (char *)oldroot);
+		level = nodehdr.level;
 	} else {
 		struct xfs_dir3_icleaf_hdr leafhdr;
 		struct xfs_dir2_leaf_entry *ents;
@@ -386,9 +551,22 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
 		       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
 		size = (int)((char *)&ents[leafhdr.count] - (char *)leaf);
+		level = 0;
 	}
-	/* XXX: can't just copy CRC headers from one block to another */
+
+	/*
+	 * we can copy most of the information in the node from one block to
+	 * another, but for CRC enabled headers we have to make sure that the
+	 * block specific identifiers are kept intact. We update the buffer
+	 * directly for this.
+	 */
 	memcpy(node, oldroot, size);
+	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC) ||
+	    oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
+		struct xfs_da3_intnode *node3 = (struct xfs_da3_intnode *)node;
+
+		node3->hdr.info.blkno = cpu_to_be64(bp->b_bn);
+	}
 	xfs_trans_log_buf(tp, bp, 0, size - 1);
 
 	bp->b_ops = blk1->bp->b_ops;
@@ -398,17 +576,21 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	/*
 	 * Set up the new root node.
 	 */
-	error = xfs_da_node_create(args,
+	error = xfs_da3_node_create(args,
 		(args->whichfork == XFS_DATA_FORK) ? mp->m_dirleafblk : 0,
-		be16_to_cpu(node->hdr.level) + 1, &bp, args->whichfork);
+		level + 1, &bp, args->whichfork);
 	if (error)
-		return(error);
+		return error;
+
 	node = bp->b_addr;
-	node->btree[0].hashval = cpu_to_be32(blk1->hashval);
-	node->btree[0].before = cpu_to_be32(blk1->blkno);
-	node->btree[1].hashval = cpu_to_be32(blk2->hashval);
-	node->btree[1].before = cpu_to_be32(blk2->blkno);
-	node->hdr.count = cpu_to_be16(2);
+	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+	btree = xfs_da3_node_tree_p(node);
+	btree[0].hashval = cpu_to_be32(blk1->hashval);
+	btree[0].before = cpu_to_be32(blk1->blkno);
+	btree[1].hashval = cpu_to_be32(blk2->hashval);
+	btree[1].before = cpu_to_be32(blk2->blkno);
+	nodehdr.count = 2;
+	xfs_da3_node_hdr_to_disk(node, &nodehdr);
 
 #ifdef DEBUG
 	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
@@ -422,30 +604,34 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 
 	/* Header is already logged by xfs_da_node_create */
 	xfs_trans_log_buf(tp, bp,
-		XFS_DA_LOGRANGE(node, node->btree,
-			sizeof(xfs_da_node_entry_t) * 2));
+		XFS_DA_LOGRANGE(node, btree, sizeof(xfs_da_node_entry_t) * 2));
 
-	return(0);
+	return 0;
 }
 
 /*
  * Split the node, rebalance, then add the new entry.
  */
 STATIC int						/* error */
-xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
-				 xfs_da_state_blk_t *newblk,
-				 xfs_da_state_blk_t *addblk,
-				 int treelevel, int *result)
+xfs_da3_node_split(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*oldblk,
+	struct xfs_da_state_blk	*newblk,
+	struct xfs_da_state_blk	*addblk,
+	int			treelevel,
+	int			*result)
 {
-	xfs_da_intnode_t *node;
-	xfs_dablk_t blkno;
-	int newcount, error;
-	int useextra;
+	struct xfs_da_intnode	*node;
+	struct xfs_da3_icnode_hdr nodehdr;
+	xfs_dablk_t		blkno;
+	int			newcount;
+	int			error;
+	int			useextra;
 
 	trace_xfs_da_node_split(state->args);
 
 	node = oldblk->bp->b_addr;
-	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
+	xfs_da3_node_hdr_from_disk(&nodehdr, node);
 
 	/*
 	 * With V2 dirs the extra block is data or freespace.
@@ -455,7 +641,7 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	/*
 	 * Do we have to split the node?
 	 */
-	if ((be16_to_cpu(node->hdr.count) + newcount) > state->node_ents) {
+	if (nodehdr.count + newcount > state->node_ents) {
 		/*
 		 * Allocate a new node, add to the doubly linked chain of
 		 * nodes, then move some of our excess entries into it.
@@ -464,14 +650,14 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 		if (error)
 			return(error);	/* GROT: dir is inconsistent */
 
-		error = xfs_da_node_create(state->args, blkno, treelevel,
+		error = xfs_da3_node_create(state->args, blkno, treelevel,
 					   &newblk->bp, state->args->whichfork);
 		if (error)
 			return(error);	/* GROT: dir is inconsistent */
 		newblk->blkno = blkno;
 		newblk->magic = XFS_DA_NODE_MAGIC;
-		xfs_da_node_rebalance(state, oldblk, newblk);
-		error = xfs_da_blk_link(state, oldblk, newblk);
+		xfs_da3_node_rebalance(state, oldblk, newblk);
+		error = xfs_da3_blk_link(state, oldblk, newblk);
 		if (error)
 			return(error);
 		*result = 1;
@@ -483,7 +669,7 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	 * Insert the new entry(s) into the correct block
 	 * (updating last hashval in the process).
 	 *
-	 * xfs_da_node_add() inserts BEFORE the given index,
+	 * xfs_da3_node_add() inserts BEFORE the given index,
 	 * and as a result of using node_lookup_int() we always
 	 * point to a valid entry (not after one), but a split
 	 * operation always results in a new block whose hashvals
@@ -492,22 +678,23 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	 * If we had double-split op below us, then add the extra block too.
 	 */
 	node = oldblk->bp->b_addr;
-	if (oldblk->index <= be16_to_cpu(node->hdr.count)) {
+	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+	if (oldblk->index <= nodehdr.count) {
 		oldblk->index++;
-		xfs_da_node_add(state, oldblk, addblk);
+		xfs_da3_node_add(state, oldblk, addblk);
 		if (useextra) {
 			if (state->extraafter)
 				oldblk->index++;
-			xfs_da_node_add(state, oldblk, &state->extrablk);
+			xfs_da3_node_add(state, oldblk, &state->extrablk);
 			state->extravalid = 0;
 		}
 	} else {
 		newblk->index++;
-		xfs_da_node_add(state, newblk, addblk);
+		xfs_da3_node_add(state, newblk, addblk);
 		if (useextra) {
 			if (state->extraafter)
 				newblk->index++;
-			xfs_da_node_add(state, newblk, &state->extrablk);
+			xfs_da3_node_add(state, newblk, &state->extrablk);
 			state->extravalid = 0;
 		}
 	}
@@ -522,33 +709,53 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
  * NOTE: if blk2 is empty, then it will get the upper half of blk1.
  */
 STATIC void
-xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
-				     xfs_da_state_blk_t *blk2)
+xfs_da3_node_rebalance(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*blk1,
+	struct xfs_da_state_blk	*blk2)
 {
-	xfs_da_intnode_t *node1, *node2, *tmpnode;
-	xfs_da_node_entry_t *btree_s, *btree_d;
-	int count, tmp;
-	xfs_trans_t *tp;
+	struct xfs_da_intnode	*node1;
+	struct xfs_da_intnode	*node2;
+	struct xfs_da_intnode	*tmpnode;
+	struct xfs_da_node_entry *btree1;
+	struct xfs_da_node_entry *btree2;
+	struct xfs_da_node_entry *btree_s;
+	struct xfs_da_node_entry *btree_d;
+	struct xfs_da3_icnode_hdr nodehdr1;
+	struct xfs_da3_icnode_hdr nodehdr2;
+	struct xfs_trans	*tp;
+	int			count;
+	int			tmp;
+	int			swap = 0;
 
 	trace_xfs_da_node_rebalance(state->args);
 
 	node1 = blk1->bp->b_addr;
 	node2 = blk2->bp->b_addr;
+	xfs_da3_node_hdr_from_disk(&nodehdr1, node1);
+	xfs_da3_node_hdr_from_disk(&nodehdr2, node2);
+	btree1 = xfs_da3_node_tree_p(node1);
+	btree2 = xfs_da3_node_tree_p(node2);
+
 	/*
 	 * Figure out how many entries need to move, and in which direction.
 	 * Swap the nodes around if that makes it simpler.
 	 */
-	if ((be16_to_cpu(node1->hdr.count) > 0) && (be16_to_cpu(node2->hdr.count) > 0) &&
-	    ((be32_to_cpu(node2->btree[0].hashval) < be32_to_cpu(node1->btree[0].hashval)) ||
-	     (be32_to_cpu(node2->btree[be16_to_cpu(node2->hdr.count)-1].hashval) <
-	      be32_to_cpu(node1->btree[be16_to_cpu(node1->hdr.count)-1].hashval)))) {
+	if (nodehdr1.count > 0 && nodehdr2.count > 0 &&
+	    ((be32_to_cpu(btree2[0].hashval) < be32_to_cpu(btree1[0].hashval)) ||
+	     (be32_to_cpu(btree2[nodehdr2.count - 1].hashval) <
+			be32_to_cpu(btree1[nodehdr1.count - 1].hashval)))) {
 		tmpnode = node1;
 		node1 = node2;
 		node2 = tmpnode;
+		xfs_da3_node_hdr_from_disk(&nodehdr1, node1);
+		xfs_da3_node_hdr_from_disk(&nodehdr2, node2);
+		btree1 = xfs_da3_node_tree_p(node1);
+		btree2 = xfs_da3_node_tree_p(node2);
+		swap = 1;
 	}
-	ASSERT(node1->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
-	ASSERT(node2->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
-	count = (be16_to_cpu(node1->hdr.count) - be16_to_cpu(node2->hdr.count)) / 2;
+
+	count = (nodehdr1.count - nodehdr2.count) / 2;
 	if (count == 0)
 		return;
 	tp = state->args->trans;
@@ -559,10 +766,11 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		/*
 		 * Move elements in node2 up to make a hole.
 		 */
-		if ((tmp = be16_to_cpu(node2->hdr.count)) > 0) {
+		tmp = nodehdr2.count;
+		if (tmp > 0) {
 			tmp *= (uint)sizeof(xfs_da_node_entry_t);
-			btree_s = &node2->btree[0];
-			btree_d = &node2->btree[count];
+			btree_s = &btree2[0];
+			btree_d = &btree2[count];
 			memmove(btree_d, btree_s, tmp);
 		}
 
@@ -570,12 +778,12 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		 * Move the req'd B-tree elements from high in node1 to
 		 * low in node2.
 		 */
-		be16_add_cpu(&node2->hdr.count, count);
+		nodehdr2.count += count;
 		tmp = count * (uint)sizeof(xfs_da_node_entry_t);
-		btree_s = &node1->btree[be16_to_cpu(node1->hdr.count) - count];
-		btree_d = &node2->btree[0];
+		btree_s = &btree1[nodehdr1.count- count];
+		btree_d = &btree2[0];
 		memcpy(btree_d, btree_s, tmp);
-		be16_add_cpu(&node1->hdr.count, -count);
+		nodehdr1.count -= count;
 	} else {
 		/*
 		 * Move the req'd B-tree elements from low in node2 to
@@ -583,49 +791,60 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 		 */
 		count = -count;
 		tmp = count * (uint)sizeof(xfs_da_node_entry_t);
-		btree_s = &node2->btree[0];
-		btree_d = &node1->btree[be16_to_cpu(node1->hdr.count)];
+		btree_s = &btree2[0];
+		btree_d = &btree1[nodehdr1.count];
 		memcpy(btree_d, btree_s, tmp);
-		be16_add_cpu(&node1->hdr.count, count);
+		nodehdr1.count += count;
+
 		xfs_trans_log_buf(tp, blk1->bp,
 			XFS_DA_LOGRANGE(node1, btree_d, tmp));
 
 		/*
 		 * Move elements in node2 down to fill the hole.
 		 */
-		tmp  = be16_to_cpu(node2->hdr.count) - count;
+		tmp  = nodehdr2.count - count;
 		tmp *= (uint)sizeof(xfs_da_node_entry_t);
-		btree_s = &node2->btree[count];
-		btree_d = &node2->btree[0];
+		btree_s = &btree2[count];
+		btree_d = &btree2[0];
 		memmove(btree_d, btree_s, tmp);
-		be16_add_cpu(&node2->hdr.count, -count);
+		nodehdr2.count -= count;
 	}
 
 	/*
 	 * Log header of node 1 and all current bits of node 2.
 	 */
+	xfs_da3_node_hdr_to_disk(node1, &nodehdr1);
 	xfs_trans_log_buf(tp, blk1->bp,
-		XFS_DA_LOGRANGE(node1, &node1->hdr, sizeof(node1->hdr)));
+		XFS_DA_LOGRANGE(node1, &node1->hdr,
+				xfs_da3_node_hdr_size(node1)));
+
+	xfs_da3_node_hdr_to_disk(node2, &nodehdr2);
 	xfs_trans_log_buf(tp, blk2->bp,
 		XFS_DA_LOGRANGE(node2, &node2->hdr,
-			sizeof(node2->hdr) +
-			sizeof(node2->btree[0]) * be16_to_cpu(node2->hdr.count)));
+				xfs_da3_node_hdr_size(node2) +
+				(sizeof(btree2[0]) * nodehdr2.count)));
 
 	/*
 	 * Record the last hashval from each block for upward propagation.
 	 * (note: don't use the swapped node pointers)
 	 */
-	node1 = blk1->bp->b_addr;
-	node2 = blk2->bp->b_addr;
-	blk1->hashval = be32_to_cpu(node1->btree[be16_to_cpu(node1->hdr.count)-1].hashval);
-	blk2->hashval = be32_to_cpu(node2->btree[be16_to_cpu(node2->hdr.count)-1].hashval);
+	if (swap) {
+		node1 = blk1->bp->b_addr;
+		node2 = blk2->bp->b_addr;
+		xfs_da3_node_hdr_from_disk(&nodehdr1, node1);
+		xfs_da3_node_hdr_from_disk(&nodehdr2, node2);
+		btree1 = xfs_da3_node_tree_p(node1);
+		btree2 = xfs_da3_node_tree_p(node2);
+	}
+	blk1->hashval = be32_to_cpu(btree1[nodehdr1.count - 1].hashval);
+	blk2->hashval = be32_to_cpu(btree2[nodehdr2.count - 1].hashval);
 
 	/*
 	 * Adjust the expected index for insertion.
 	 */
-	if (blk1->index >= be16_to_cpu(node1->hdr.count)) {
-		blk2->index = blk1->index - be16_to_cpu(node1->hdr.count);
-		blk1->index = be16_to_cpu(node1->hdr.count) + 1;	/* make it invalid */
+	if (blk1->index >= nodehdr1.count) {
+		blk2->index = blk1->index - nodehdr1.count;
+		blk1->index = nodehdr1.count + 1;	/* make it invalid */
 	}
 }
 
@@ -633,18 +852,23 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
  * Add a new entry to an intermediate node.
  */
 STATIC void
-xfs_da_node_add(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
-			       xfs_da_state_blk_t *newblk)
+xfs_da3_node_add(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*oldblk,
+	struct xfs_da_state_blk	*newblk)
 {
-	xfs_da_intnode_t *node;
-	xfs_da_node_entry_t *btree;
-	int tmp;
+	struct xfs_da_intnode	*node;
+	struct xfs_da3_icnode_hdr nodehdr;
+	struct xfs_da_node_entry *btree;
+	int			tmp;
 
 	trace_xfs_da_node_add(state->args);
 
 	node = oldblk->bp->b_addr;
-	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
-	ASSERT((oldblk->index >= 0) && (oldblk->index <= be16_to_cpu(node->hdr.count)));
+	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+	btree = xfs_da3_node_tree_p(node);
+
+	ASSERT(oldblk->index >= 0 && oldblk->index <= nodehdr.count);
 	ASSERT(newblk->blkno != 0);
 	if (state->args->whichfork == XFS_DATA_FORK)
 		ASSERT(newblk->blkno >= state->mp->m_dirleafblk &&
@@ -654,23 +878,25 @@ xfs_da_node_add(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	 * We may need to make some room before we insert the new node.
 	 */
 	tmp = 0;
-	btree = &node->btree[ oldblk->index ];
-	if (oldblk->index < be16_to_cpu(node->hdr.count)) {
-		tmp = (be16_to_cpu(node->hdr.count) - oldblk->index) * (uint)sizeof(*btree);
-		memmove(btree + 1, btree, tmp);
+	if (oldblk->index < nodehdr.count) {
+		tmp = (nodehdr.count - oldblk->index) * (uint)sizeof(*btree);
+		memmove(&btree[oldblk->index + 1], &btree[oldblk->index], tmp);
 	}
-	btree->hashval = cpu_to_be32(newblk->hashval);
-	btree->before = cpu_to_be32(newblk->blkno);
+	btree[oldblk->index].hashval = cpu_to_be32(newblk->hashval);
+	btree[oldblk->index].before = cpu_to_be32(newblk->blkno);
 	xfs_trans_log_buf(state->args->trans, oldblk->bp,
-		XFS_DA_LOGRANGE(node, btree, tmp + sizeof(*btree)));
-	be16_add_cpu(&node->hdr.count, 1);
+		XFS_DA_LOGRANGE(node, &btree[oldblk->index],
+				tmp + sizeof(*btree)));
+
+	nodehdr.count += 1;
+	xfs_da3_node_hdr_to_disk(node, &nodehdr);
 	xfs_trans_log_buf(state->args->trans, oldblk->bp,
-		XFS_DA_LOGRANGE(node, &node->hdr, sizeof(node->hdr)));
+		XFS_DA_LOGRANGE(node, &node->hdr, xfs_da3_node_hdr_size(node)));
 
 	/*
 	 * Copy the last hash value from the oldblk to propagate upwards.
 	 */
-	oldblk->hashval = be32_to_cpu(node->btree[be16_to_cpu(node->hdr.count)-1 ].hashval);
+	oldblk->hashval = be32_to_cpu(btree[nodehdr.count - 1].hashval);
 }
 
 /*========================================================================
@@ -682,14 +908,16 @@ xfs_da_node_add(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
  * possibly deallocating that block, etc...
  */
 int
-xfs_da_join(xfs_da_state_t *state)
+xfs_da3_join(
+	struct xfs_da_state	*state)
 {
-	xfs_da_state_blk_t *drop_blk, *save_blk;
-	int action, error;
+	struct xfs_da_state_blk	*drop_blk;
+	struct xfs_da_state_blk	*save_blk;
+	int			action = 0;
+	int			error;
 
 	trace_xfs_da_join(state->args);
 
-	action = 0;
 	drop_blk = &state->path.blk[ state->path.active-1 ];
 	save_blk = &state->altpath.blk[ state->path.active-1 ];
 	ASSERT(state->path.blk[0].magic == XFS_DA_NODE_MAGIC);
@@ -730,18 +958,18 @@ xfs_da_join(xfs_da_state_t *state)
 			 * Remove the offending node, fixup hashvals,
 			 * check for a toosmall neighbor.
 			 */
-			xfs_da_node_remove(state, drop_blk);
-			xfs_da_fixhashpath(state, &state->path);
-			error = xfs_da_node_toosmall(state, &action);
+			xfs_da3_node_remove(state, drop_blk);
+			xfs_da3_fixhashpath(state, &state->path);
+			error = xfs_da3_node_toosmall(state, &action);
 			if (error)
 				return(error);
 			if (action == 0)
 				return 0;
-			xfs_da_node_unbalance(state, drop_blk, save_blk);
+			xfs_da3_node_unbalance(state, drop_blk, save_blk);
 			break;
 		}
-		xfs_da_fixhashpath(state, &state->altpath);
-		error = xfs_da_blk_unlink(state, drop_blk, save_blk);
+		xfs_da3_fixhashpath(state, &state->altpath);
+		error = xfs_da3_blk_unlink(state, drop_blk, save_blk);
 		xfs_da_state_kill_altpath(state);
 		if (error)
 			return(error);
@@ -756,9 +984,9 @@ xfs_da_join(xfs_da_state_t *state)
 	 * we only have one entry in the root, make the child block
 	 * the new root.
 	 */
-	xfs_da_node_remove(state, drop_blk);
-	xfs_da_fixhashpath(state, &state->path);
-	error = xfs_da_root_join(state, &state->path.blk[0]);
+	xfs_da3_node_remove(state, drop_blk);
+	xfs_da3_fixhashpath(state, &state->path);
+	error = xfs_da3_root_join(state, &state->path.blk[0]);
 	return(error);
 }
 
@@ -772,8 +1000,10 @@ xfs_da_blkinfo_onlychild_validate(struct xfs_da_blkinfo *blkinfo, __u16 level)
 		ASSERT(magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
 		       magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) ||
 		       magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-	} else
-		ASSERT(magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
+	} else {
+		ASSERT(magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
+		       magic == cpu_to_be16(XFS_DA3_NODE_MAGIC));
+	}
 	ASSERT(!blkinfo->forw);
 	ASSERT(!blkinfo->back);
 }
@@ -786,52 +1016,60 @@ xfs_da_blkinfo_onlychild_validate(struct xfs_da_blkinfo *blkinfo, __u16 level)
  * the old root to block 0 as the new root node.
  */
 STATIC int
-xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
+xfs_da3_root_join(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*root_blk)
 {
-	xfs_da_intnode_t *oldroot;
-	xfs_da_args_t *args;
-	xfs_dablk_t child;
-	struct xfs_buf *bp;
-	int error;
+	struct xfs_da_intnode	*oldroot;
+	struct xfs_da_args	*args;
+	xfs_dablk_t		child;
+	struct xfs_buf		*bp;
+	struct xfs_da3_icnode_hdr oldroothdr;
+	struct xfs_da_node_entry *btree;
+	int			error;
 
 	trace_xfs_da_root_join(state->args);
 
-	args = state->args;
-	ASSERT(args != NULL);
 	ASSERT(root_blk->magic == XFS_DA_NODE_MAGIC);
+
+	args = state->args;
 	oldroot = root_blk->bp->b_addr;
-	ASSERT(oldroot->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
-	ASSERT(!oldroot->hdr.info.forw);
-	ASSERT(!oldroot->hdr.info.back);
+	xfs_da3_node_hdr_from_disk(&oldroothdr, oldroot);
+	ASSERT(oldroothdr.forw == 0);
+	ASSERT(oldroothdr.back == 0);
 
 	/*
 	 * If the root has more than one child, then don't do anything.
 	 */
-	if (be16_to_cpu(oldroot->hdr.count) > 1)
-		return(0);
+	if (oldroothdr.count > 1)
+		return 0;
 
 	/*
 	 * Read in the (only) child block, then copy those bytes into
 	 * the root block's buffer and free the original child block.
 	 */
-	child = be32_to_cpu(oldroot->btree[0].before);
+	btree = xfs_da3_node_tree_p(oldroot);
+	child = be32_to_cpu(btree[0].before);
 	ASSERT(child != 0);
-	error = xfs_da_node_read(args->trans, args->dp, child, -1, &bp,
+	error = xfs_da3_node_read(args->trans, args->dp, child, -1, &bp,
 					     args->whichfork);
 	if (error)
-		return(error);
-	ASSERT(bp != NULL);
-	xfs_da_blkinfo_onlychild_validate(bp->b_addr,
-					be16_to_cpu(oldroot->hdr.level));
+		return error;
+	xfs_da_blkinfo_onlychild_validate(bp->b_addr, oldroothdr.level);
 
 	/*
 	 * This could be copying a leaf back into the root block in the case of
 	 * there only being a single leaf block left in the tree. Hence we have
 	 * to update the b_ops pointer as well to match the buffer type change
-	 * that could occur.
+	 * that could occur. For dir3 blocks we also need to update the block
+	 * number in the buffer header.
 	 */
 	memcpy(root_blk->bp->b_addr, bp->b_addr, state->blocksize);
 	root_blk->bp->b_ops = bp->b_ops;
+	if (oldroothdr.magic == XFS_DA3_NODE_MAGIC) {
+		struct xfs_da3_blkinfo *da3 = root_blk->bp->b_addr;
+		da3->blkno = cpu_to_be64(root_blk->bp->b_bn);
+	}
 	xfs_trans_log_buf(args->trans, root_blk->bp, 0, state->blocksize - 1);
 	error = xfs_da_shrink_inode(args, child, bp);
 	return(error);
@@ -847,14 +1085,21 @@ xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
  * If nothing can be done, return 0.
  */
 STATIC int
-xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
+xfs_da3_node_toosmall(
+	struct xfs_da_state	*state,
+	int			*action)
 {
-	xfs_da_intnode_t *node;
-	xfs_da_state_blk_t *blk;
-	xfs_da_blkinfo_t *info;
-	int count, forward, error, retval, i;
-	xfs_dablk_t blkno;
-	struct xfs_buf *bp;
+	struct xfs_da_intnode	*node;
+	struct xfs_da_state_blk	*blk;
+	struct xfs_da_blkinfo	*info;
+	xfs_dablk_t		blkno;
+	struct xfs_buf		*bp;
+	struct xfs_da3_icnode_hdr nodehdr;
+	int			count;
+	int			forward;
+	int			error;
+	int			retval;
+	int			i;
 
 	trace_xfs_da_node_toosmall(state->args);
 
@@ -865,10 +1110,9 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
 	 */
 	blk = &state->path.blk[ state->path.active-1 ];
 	info = blk->bp->b_addr;
-	ASSERT(info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	node = (xfs_da_intnode_t *)info;
-	count = be16_to_cpu(node->hdr.count);
-	if (count > (state->node_ents >> 1)) {
+	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+	if (nodehdr.count > (state->node_ents >> 1)) {
 		*action = 0;	/* blk over 50%, don't try to join */
 		return(0);	/* blk over 50%, don't try to join */
 	}
@@ -879,14 +1123,14 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
 	 * coalesce it with a sibling block.  We choose (arbitrarily)
 	 * to merge with the forward block unless it is NULL.
 	 */
-	if (count == 0) {
+	if (nodehdr.count == 0) {
 		/*
 		 * Make altpath point to the block we want to keep and
 		 * path point to the block we want to drop (this one).
 		 */
 		forward = (info->forw != 0);
 		memcpy(&state->altpath, &state->path, sizeof(state->path));
-		error = xfs_da_path_shift(state, &state->altpath, forward,
+		error = xfs_da3_path_shift(state, &state->altpath, forward,
 						 0, &retval);
 		if (error)
 			return(error);
@@ -905,35 +1149,34 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
 	 * We prefer coalescing with the lower numbered sibling so as
 	 * to shrink a directory over time.
 	 */
+	count  = state->node_ents;
+	count -= state->node_ents >> 2;
+	count -= nodehdr.count;
+
 	/* start with smaller blk num */
-	forward = (be32_to_cpu(info->forw) < be32_to_cpu(info->back));
+	forward = nodehdr.forw < nodehdr.back;
 	for (i = 0; i < 2; forward = !forward, i++) {
 		if (forward)
-			blkno = be32_to_cpu(info->forw);
+			blkno = nodehdr.forw;
 		else
-			blkno = be32_to_cpu(info->back);
+			blkno = nodehdr.back;
 		if (blkno == 0)
 			continue;
-		error = xfs_da_node_read(state->args->trans, state->args->dp,
+		error = xfs_da3_node_read(state->args->trans, state->args->dp,
 					blkno, -1, &bp, state->args->whichfork);
 		if (error)
 			return(error);
-		ASSERT(bp != NULL);
 
-		node = (xfs_da_intnode_t *)info;
-		count  = state->node_ents;
-		count -= state->node_ents >> 2;
-		count -= be16_to_cpu(node->hdr.count);
 		node = bp->b_addr;
-		ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
-		count -= be16_to_cpu(node->hdr.count);
+		xfs_da3_node_hdr_from_disk(&nodehdr, node);
 		xfs_trans_brelse(state->args->trans, bp);
-		if (count >= 0)
+
+		if (count - nodehdr.count >= 0)
 			break;	/* fits with at least 25% to spare */
 	}
 	if (i >= 2) {
 		*action = 0;
-		return(0);
+		return 0;
 	}
 
 	/*
@@ -942,28 +1185,42 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
 	 */
 	memcpy(&state->altpath, &state->path, sizeof(state->path));
 	if (blkno < blk->blkno) {
-		error = xfs_da_path_shift(state, &state->altpath, forward,
+		error = xfs_da3_path_shift(state, &state->altpath, forward,
 						 0, &retval);
-		if (error) {
-			return(error);
-		}
-		if (retval) {
-			*action = 0;
-			return(0);
-		}
 	} else {
-		error = xfs_da_path_shift(state, &state->path, forward,
+		error = xfs_da3_path_shift(state, &state->path, forward,
 						 0, &retval);
-		if (error) {
-			return(error);
-		}
-		if (retval) {
-			*action = 0;
-			return(0);
-		}
+	}
+	if (error)
+		return error;
+	if (retval) {
+		*action = 0;
+		return 0;
 	}
 	*action = 1;
-	return(0);
+	return 0;
+}
+
+/*
+ * Pick up the last hashvalue from an intermediate node.
+ */
+STATIC uint
+xfs_da3_node_lasthash(
+	struct xfs_buf		*bp,
+	int			*count)
+{
+	struct xfs_da_intnode	 *node;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr nodehdr;
+
+	node = bp->b_addr;
+	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+	if (count)
+		*count = nodehdr.count;
+	if (!nodehdr.count)
+		return 0;
+	btree = xfs_da3_node_tree_p(node);
+	return be32_to_cpu(btree[nodehdr.count - 1].hashval);
 }
 
 /*
@@ -971,13 +1228,16 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
  * when we stop making changes, return.
  */
 void
-xfs_da_fixhashpath(xfs_da_state_t *state, xfs_da_state_path_t *path)
+xfs_da3_fixhashpath(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_path *path)
 {
-	xfs_da_state_blk_t *blk;
-	xfs_da_intnode_t *node;
-	xfs_da_node_entry_t *btree;
-	xfs_dahash_t lasthash=0;
-	int level, count;
+	struct xfs_da_state_blk	*blk;
+	struct xfs_da_intnode	*node;
+	struct xfs_da_node_entry *btree;
+	xfs_dahash_t		lasthash=0;
+	int			level;
+	int			count;
 
 	trace_xfs_da_fixhashpath(state->args);
 
@@ -995,23 +1255,26 @@ xfs_da_fixhashpath(xfs_da_state_t *state, xfs_da_state_path_t *path)
 			return;
 		break;
 	case XFS_DA_NODE_MAGIC:
-		lasthash = xfs_da_node_lasthash(blk->bp, &count);
+		lasthash = xfs_da3_node_lasthash(blk->bp, &count);
 		if (count == 0)
 			return;
 		break;
 	}
 	for (blk--, level--; level >= 0; blk--, level--) {
+		struct xfs_da3_icnode_hdr nodehdr;
+
 		node = blk->bp->b_addr;
-		ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
-		btree = &node->btree[ blk->index ];
+		xfs_da3_node_hdr_from_disk(&nodehdr, node);
+		btree = xfs_da3_node_tree_p(node);
 		if (be32_to_cpu(btree->hashval) == lasthash)
 			break;
 		blk->hashval = lasthash;
-		btree->hashval = cpu_to_be32(lasthash);
+		btree[blk->index].hashval = cpu_to_be32(lasthash);
 		xfs_trans_log_buf(state->args->trans, blk->bp,
-				  XFS_DA_LOGRANGE(node, btree, sizeof(*btree)));
+				  XFS_DA_LOGRANGE(node, &btree[blk->index],
+						  sizeof(*btree)));
 
-		lasthash = be32_to_cpu(node->btree[be16_to_cpu(node->hdr.count)-1].hashval);
+		lasthash = be32_to_cpu(btree[nodehdr.count - 1].hashval);
 	}
 }
 
@@ -1019,104 +1282,119 @@ xfs_da_fixhashpath(xfs_da_state_t *state, xfs_da_state_path_t *path)
  * Remove an entry from an intermediate node.
  */
 STATIC void
-xfs_da_node_remove(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk)
+xfs_da3_node_remove(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*drop_blk)
 {
-	xfs_da_intnode_t *node;
-	xfs_da_node_entry_t *btree;
-	int tmp;
+	struct xfs_da_intnode	*node;
+	struct xfs_da3_icnode_hdr nodehdr;
+	struct xfs_da_node_entry *btree;
+	int			index;
+	int			tmp;
 
 	trace_xfs_da_node_remove(state->args);
 
 	node = drop_blk->bp->b_addr;
-	ASSERT(drop_blk->index < be16_to_cpu(node->hdr.count));
+	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+	ASSERT(drop_blk->index < nodehdr.count);
 	ASSERT(drop_blk->index >= 0);
 
 	/*
 	 * Copy over the offending entry, or just zero it out.
 	 */
-	btree = &node->btree[drop_blk->index];
-	if (drop_blk->index < (be16_to_cpu(node->hdr.count)-1)) {
-		tmp  = be16_to_cpu(node->hdr.count) - drop_blk->index - 1;
+	index = drop_blk->index;
+	btree = xfs_da3_node_tree_p(node);
+	if (index < nodehdr.count - 1) {
+		tmp  = nodehdr.count - index - 1;
 		tmp *= (uint)sizeof(xfs_da_node_entry_t);
-		memmove(btree, btree + 1, tmp);
+		memmove(&btree[index], &btree[index + 1], tmp);
 		xfs_trans_log_buf(state->args->trans, drop_blk->bp,
-		    XFS_DA_LOGRANGE(node, btree, tmp));
-		btree = &node->btree[be16_to_cpu(node->hdr.count)-1];
+		    XFS_DA_LOGRANGE(node, &btree[index], tmp));
+		index = nodehdr.count - 1;
 	}
-	memset((char *)btree, 0, sizeof(xfs_da_node_entry_t));
+	memset(&btree[index], 0, sizeof(xfs_da_node_entry_t));
 	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
-	    XFS_DA_LOGRANGE(node, btree, sizeof(*btree)));
-	be16_add_cpu(&node->hdr.count, -1);
+	    XFS_DA_LOGRANGE(node, &btree[index], sizeof(btree[index])));
+	nodehdr.count -= 1;
+	xfs_da3_node_hdr_to_disk(node, &nodehdr);
 	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
-	    XFS_DA_LOGRANGE(node, &node->hdr, sizeof(node->hdr)));
+	    XFS_DA_LOGRANGE(node, &node->hdr, xfs_da3_node_hdr_size(node)));
 
 	/*
 	 * Copy the last hash value from the block to propagate upwards.
 	 */
-	btree--;
-	drop_blk->hashval = be32_to_cpu(btree->hashval);
+	drop_blk->hashval = be32_to_cpu(btree[index - 1].hashval);
 }
 
 /*
- * Unbalance the btree elements between two intermediate nodes,
+ * Unbalance the elements between two intermediate nodes,
  * move all Btree elements from one node into another.
  */
 STATIC void
-xfs_da_node_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
-				     xfs_da_state_blk_t *save_blk)
+xfs_da3_node_unbalance(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*drop_blk,
+	struct xfs_da_state_blk	*save_blk)
 {
-	xfs_da_intnode_t *drop_node, *save_node;
-	xfs_da_node_entry_t *btree;
-	int tmp;
-	xfs_trans_t *tp;
+	struct xfs_da_intnode	*drop_node;
+	struct xfs_da_intnode	*save_node;
+	struct xfs_da_node_entry *dbtree;
+	struct xfs_da_node_entry *sbtree;
+	struct xfs_da3_icnode_hdr dhdr;
+	struct xfs_da3_icnode_hdr shdr;
+	struct xfs_trans	*tp;
+	int			sindex;
+	int			tmp;
 
 	trace_xfs_da_node_unbalance(state->args);
 
 	drop_node = drop_blk->bp->b_addr;
 	save_node = save_blk->bp->b_addr;
-	ASSERT(drop_node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
-	ASSERT(save_node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
+	xfs_da3_node_hdr_from_disk(&dhdr, drop_node);
+	xfs_da3_node_hdr_from_disk(&shdr, save_node);
+	dbtree = xfs_da3_node_tree_p(drop_node);
+	sbtree = xfs_da3_node_tree_p(save_node);
 	tp = state->args->trans;
 
 	/*
 	 * If the dying block has lower hashvals, then move all the
 	 * elements in the remaining block up to make a hole.
 	 */
-	if ((be32_to_cpu(drop_node->btree[0].hashval) < be32_to_cpu(save_node->btree[ 0 ].hashval)) ||
-	    (be32_to_cpu(drop_node->btree[be16_to_cpu(drop_node->hdr.count)-1].hashval) <
-	     be32_to_cpu(save_node->btree[be16_to_cpu(save_node->hdr.count)-1].hashval)))
-	{
-		btree = &save_node->btree[be16_to_cpu(drop_node->hdr.count)];
-		tmp = be16_to_cpu(save_node->hdr.count) * (uint)sizeof(xfs_da_node_entry_t);
-		memmove(btree, &save_node->btree[0], tmp);
-		btree = &save_node->btree[0];
+	if ((be32_to_cpu(dbtree[0].hashval) < be32_to_cpu(sbtree[ 0 ].hashval)) ||
+	    (be32_to_cpu(dbtree[dhdr.count - 1].hashval) <
+				be32_to_cpu(sbtree[shdr.count - 1].hashval))) {
+		/* XXX: check this - is memmove dst correct? */
+		tmp = shdr.count * (uint)sizeof(xfs_da_node_entry_t);
+		memmove(&sbtree[dhdr.count], &sbtree[0], tmp);
+
+		sindex = 0;
 		xfs_trans_log_buf(tp, save_blk->bp,
-			XFS_DA_LOGRANGE(save_node, btree,
-				(be16_to_cpu(save_node->hdr.count) + be16_to_cpu(drop_node->hdr.count)) *
-				sizeof(xfs_da_node_entry_t)));
+			XFS_DA_LOGRANGE(save_node, &sbtree[0],
+				(shdr.count + dhdr.count) *
+						sizeof(xfs_da_node_entry_t)));
 	} else {
-		btree = &save_node->btree[be16_to_cpu(save_node->hdr.count)];
+		sindex = shdr.count;
 		xfs_trans_log_buf(tp, save_blk->bp,
-			XFS_DA_LOGRANGE(save_node, btree,
-				be16_to_cpu(drop_node->hdr.count) *
-				sizeof(xfs_da_node_entry_t)));
+			XFS_DA_LOGRANGE(save_node, &sbtree[sindex],
+				dhdr.count * sizeof(xfs_da_node_entry_t)));
 	}
 
 	/*
 	 * Move all the B-tree elements from drop_blk to save_blk.
 	 */
-	tmp = be16_to_cpu(drop_node->hdr.count) * (uint)sizeof(xfs_da_node_entry_t);
-	memcpy(btree, &drop_node->btree[0], tmp);
-	be16_add_cpu(&save_node->hdr.count, be16_to_cpu(drop_node->hdr.count));
+	tmp = dhdr.count * (uint)sizeof(xfs_da_node_entry_t);
+	memcpy(&sbtree[sindex], &dbtree[0], tmp);
+	shdr.count += dhdr.count;
 
+	xfs_da3_node_hdr_to_disk(save_node, &shdr);
 	xfs_trans_log_buf(tp, save_blk->bp,
 		XFS_DA_LOGRANGE(save_node, &save_node->hdr,
-			sizeof(save_node->hdr)));
+				xfs_da3_node_hdr_size(save_node)));
 
 	/*
 	 * Save the last hashval in the remaining block for upward propagation.
 	 */
-	save_blk->hashval = be32_to_cpu(save_node->btree[be16_to_cpu(save_node->hdr.count)-1].hashval);
+	save_blk->hashval = be32_to_cpu(sbtree[shdr.count - 1].hashval);
 }
 
 /*========================================================================
@@ -1135,16 +1413,24 @@ xfs_da_node_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
  * pruned depth-first tree search.
  */
 int							/* error */
-xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
+xfs_da3_node_lookup_int(
+	struct xfs_da_state	*state,
+	int			*result)
 {
-	xfs_da_state_blk_t *blk;
-	xfs_da_blkinfo_t *curr;
-	xfs_da_intnode_t *node;
-	xfs_da_node_entry_t *btree;
-	xfs_dablk_t blkno;
-	int probe, span, max, error, retval;
-	xfs_dahash_t hashval, btreehashval;
-	xfs_da_args_t *args;
+	struct xfs_da_state_blk	*blk;
+	struct xfs_da_blkinfo	*curr;
+	struct xfs_da_intnode	*node;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr nodehdr;
+	struct xfs_da_args	*args;
+	xfs_dablk_t		blkno;
+	xfs_dahash_t		hashval;
+	xfs_dahash_t		btreehashval;
+	int			probe;
+	int			span;
+	int			max;
+	int			error;
+	int			retval;
 
 	args = state->args;
 
@@ -1160,7 +1446,7 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
 		 * Read the next node down in the tree.
 		 */
 		blk->blkno = blkno;
-		error = xfs_da_node_read(args->trans, args->dp, blkno,
+		error = xfs_da3_node_read(args->trans, args->dp, blkno,
 					-1, &blk->bp, args->whichfork);
 		if (error) {
 			blk->blkno = 0;
@@ -1169,66 +1455,73 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
 		}
 		curr = blk->bp->b_addr;
 		blk->magic = be16_to_cpu(curr->magic);
-		ASSERT(blk->magic == XFS_DA_NODE_MAGIC ||
-		       blk->magic == XFS_DIR2_LEAFN_MAGIC ||
-		       blk->magic == XFS_ATTR_LEAF_MAGIC);
+
+		if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
+			blk->hashval = xfs_attr_leaf_lasthash(blk->bp, NULL);
+			break;
+		}
+
+		if (blk->magic == XFS_DIR2_LEAFN_MAGIC ||
+		    blk->magic == XFS_DIR3_LEAFN_MAGIC) {
+			blk->magic = XFS_DIR2_LEAFN_MAGIC;
+			blk->hashval = xfs_dir2_leafn_lasthash(blk->bp, NULL);
+			break;
+		}
+
+		blk->magic = XFS_DA_NODE_MAGIC;
+
 
 		/*
 		 * Search an intermediate node for a match.
 		 */
-		if (blk->magic == XFS_DA_NODE_MAGIC) {
-			node = blk->bp->b_addr;
-			max = be16_to_cpu(node->hdr.count);
-			blk->hashval = be32_to_cpu(node->btree[max-1].hashval);
+		node = blk->bp->b_addr;
+		xfs_da3_node_hdr_from_disk(&nodehdr, node);
+		btree = xfs_da3_node_tree_p(node);
 
-			/*
-			 * Binary search.  (note: small blocks will skip loop)
-			 */
-			probe = span = max / 2;
-			hashval = args->hashval;
-			for (btree = &node->btree[probe]; span > 4;
-				   btree = &node->btree[probe]) {
-				span /= 2;
-				btreehashval = be32_to_cpu(btree->hashval);
-				if (btreehashval < hashval)
-					probe += span;
-				else if (btreehashval > hashval)
-					probe -= span;
-				else
-					break;
-			}
-			ASSERT((probe >= 0) && (probe < max));
-			ASSERT((span <= 4) || (be32_to_cpu(btree->hashval) == hashval));
+		max = nodehdr.count;
+		blk->hashval = be32_to_cpu(btree[max - 1].hashval);
 
-			/*
-			 * Since we may have duplicate hashval's, find the first
-			 * matching hashval in the node.
-			 */
-			while ((probe > 0) && (be32_to_cpu(btree->hashval) >= hashval)) {
-				btree--;
-				probe--;
-			}
-			while ((probe < max) && (be32_to_cpu(btree->hashval) < hashval)) {
-				btree++;
-				probe++;
-			}
+		/*
+		 * Binary search.  (note: small blocks will skip loop)
+		 */
+		probe = span = max / 2;
+		hashval = args->hashval;
+		while (span > 4) {
+			span /= 2;
+			btreehashval = be32_to_cpu(btree[probe].hashval);
+			if (btreehashval < hashval)
+				probe += span;
+			else if (btreehashval > hashval)
+				probe -= span;
+			else
+				break;
+		}
+		ASSERT((probe >= 0) && (probe < max));
+		ASSERT((span <= 4) ||
+			(be32_to_cpu(btree[probe].hashval) == hashval));
 
-			/*
-			 * Pick the right block to descend on.
-			 */
-			if (probe == max) {
-				blk->index = max-1;
-				blkno = be32_to_cpu(node->btree[max-1].before);
-			} else {
-				blk->index = probe;
-				blkno = be32_to_cpu(btree->before);
-			}
-		} else if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
-			blk->hashval = xfs_attr_leaf_lasthash(blk->bp, NULL);
-			break;
-		} else if (blk->magic == XFS_DIR2_LEAFN_MAGIC) {
-			blk->hashval = xfs_dir2_leafn_lasthash(blk->bp, NULL);
-			break;
+		/*
+		 * Since we may have duplicate hashval's, find the first
+		 * matching hashval in the node.
+		 */
+		while (probe > 0 &&
+		       be32_to_cpu(btree[probe].hashval) >= hashval) {
+			probe--;
+		}
+		while (probe < max &&
+		       be32_to_cpu(btree[probe].hashval) < hashval) {
+			probe++;
+		}
+
+		/*
+		 * Pick the right block to descend on.
+		 */
+		if (probe == max) {
+			blk->index = max - 1;
+			blkno = be32_to_cpu(btree[max - 1].before);
+		} else {
+			blk->index = probe;
+			blkno = be32_to_cpu(btree[probe].before);
 		}
 	}
 
@@ -1252,7 +1545,7 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
 		}
 		if (((retval == ENOENT) || (retval == ENOATTR)) &&
 		    (blk->hashval == args->hashval)) {
-			error = xfs_da_path_shift(state, &state->path, 1, 1,
+			error = xfs_da3_path_shift(state, &state->path, 1, 1,
 							 &retval);
 			if (error)
 				return(error);
@@ -1274,16 +1567,52 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
  *========================================================================*/
 
 /*
+ * Compare two intermediate nodes for "order".
+ */
+STATIC int
+xfs_da3_node_order(
+	struct xfs_buf	*node1_bp,
+	struct xfs_buf	*node2_bp)
+{
+	struct xfs_da_intnode	*node1;
+	struct xfs_da_intnode	*node2;
+	struct xfs_da_node_entry *btree1;
+	struct xfs_da_node_entry *btree2;
+	struct xfs_da3_icnode_hdr node1hdr;
+	struct xfs_da3_icnode_hdr node2hdr;
+
+	node1 = node1_bp->b_addr;
+	node2 = node2_bp->b_addr;
+	xfs_da3_node_hdr_from_disk(&node1hdr, node1);
+	xfs_da3_node_hdr_from_disk(&node2hdr, node2);
+	btree1 = xfs_da3_node_tree_p(node1);
+	btree2 = xfs_da3_node_tree_p(node2);
+
+	if (node1hdr.count > 0 && node2hdr.count > 0 &&
+	    ((be32_to_cpu(btree2[0].hashval) < be32_to_cpu(btree1[0].hashval)) ||
+	     (be32_to_cpu(btree2[node2hdr.count - 1].hashval) <
+	      be32_to_cpu(btree1[node1hdr.count - 1].hashval)))) {
+		return 1;
+	}
+	return 0;
+}
+
+/*
  * Link a new block into a doubly linked list of blocks (of whatever type).
  */
 int							/* error */
-xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
-			       xfs_da_state_blk_t *new_blk)
+xfs_da3_blk_link(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*old_blk,
+	struct xfs_da_state_blk	*new_blk)
 {
-	xfs_da_blkinfo_t *old_info, *new_info, *tmp_info;
-	xfs_da_args_t *args;
-	int before=0, error;
-	struct xfs_buf *bp;
+	struct xfs_da_blkinfo	*old_info;
+	struct xfs_da_blkinfo	*new_info;
+	struct xfs_da_blkinfo	*tmp_info;
+	struct xfs_da_args	*args;
+	struct xfs_buf		*bp;
+	int			before = 0;
+	int			error;
 
 	/*
 	 * Set up environment.
@@ -1295,9 +1624,6 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 	ASSERT(old_blk->magic == XFS_DA_NODE_MAGIC ||
 	       old_blk->magic == XFS_DIR2_LEAFN_MAGIC ||
 	       old_blk->magic == XFS_ATTR_LEAF_MAGIC);
-	ASSERT(old_blk->magic == be16_to_cpu(old_info->magic));
-	ASSERT(new_blk->magic == be16_to_cpu(new_info->magic));
-	ASSERT(old_blk->magic == new_blk->magic);
 
 	switch (old_blk->magic) {
 	case XFS_ATTR_LEAF_MAGIC:
@@ -1307,7 +1633,7 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 		before = xfs_dir2_leafn_order(old_blk->bp, new_blk->bp);
 		break;
 	case XFS_DA_NODE_MAGIC:
-		before = xfs_da_node_order(old_blk->bp, new_blk->bp);
+		before = xfs_da3_node_order(old_blk->bp, new_blk->bp);
 		break;
 	}
 
@@ -1322,14 +1648,14 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 		new_info->forw = cpu_to_be32(old_blk->blkno);
 		new_info->back = old_info->back;
 		if (old_info->back) {
-			error = xfs_da_node_read(args->trans, args->dp,
+			error = xfs_da3_node_read(args->trans, args->dp,
 						be32_to_cpu(old_info->back),
 						-1, &bp, args->whichfork);
 			if (error)
 				return(error);
 			ASSERT(bp != NULL);
 			tmp_info = bp->b_addr;
-			ASSERT(be16_to_cpu(tmp_info->magic) == be16_to_cpu(old_info->magic));
+			ASSERT(tmp_info->magic == old_info->magic);
 			ASSERT(be32_to_cpu(tmp_info->forw) == old_blk->blkno);
 			tmp_info->forw = cpu_to_be32(new_blk->blkno);
 			xfs_trans_log_buf(args->trans, bp, 0, sizeof(*tmp_info)-1);
@@ -1343,7 +1669,7 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 		new_info->forw = old_info->forw;
 		new_info->back = cpu_to_be32(old_blk->blkno);
 		if (old_info->forw) {
-			error = xfs_da_node_read(args->trans, args->dp,
+			error = xfs_da3_node_read(args->trans, args->dp,
 						be32_to_cpu(old_info->forw),
 						-1, &bp, args->whichfork);
 			if (error)
@@ -1364,59 +1690,20 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 }
 
 /*
- * Compare two intermediate nodes for "order".
- */
-STATIC int
-xfs_da_node_order(
-	struct xfs_buf	*node1_bp,
-	struct xfs_buf	*node2_bp)
-{
-	xfs_da_intnode_t *node1, *node2;
-
-	node1 = node1_bp->b_addr;
-	node2 = node2_bp->b_addr;
-	ASSERT(node1->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC) &&
-	       node2->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
-	if ((be16_to_cpu(node1->hdr.count) > 0) && (be16_to_cpu(node2->hdr.count) > 0) &&
-	    ((be32_to_cpu(node2->btree[0].hashval) <
-	      be32_to_cpu(node1->btree[0].hashval)) ||
-	     (be32_to_cpu(node2->btree[be16_to_cpu(node2->hdr.count)-1].hashval) <
-	      be32_to_cpu(node1->btree[be16_to_cpu(node1->hdr.count)-1].hashval)))) {
-		return(1);
-	}
-	return(0);
-}
-
-/*
- * Pick up the last hashvalue from an intermediate node.
- */
-STATIC uint
-xfs_da_node_lasthash(
-	struct xfs_buf	*bp,
-	int		*count)
-{
-	xfs_da_intnode_t *node;
-
-	node = bp->b_addr;
-	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
-	if (count)
-		*count = be16_to_cpu(node->hdr.count);
-	if (!node->hdr.count)
-		return(0);
-	return be32_to_cpu(node->btree[be16_to_cpu(node->hdr.count)-1].hashval);
-}
-
-/*
  * Unlink a block from a doubly linked list of blocks.
  */
 STATIC int						/* error */
-xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
-				 xfs_da_state_blk_t *save_blk)
+xfs_da3_blk_unlink(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*drop_blk,
+	struct xfs_da_state_blk	*save_blk)
 {
-	xfs_da_blkinfo_t *drop_info, *save_info, *tmp_info;
-	xfs_da_args_t *args;
-	struct xfs_buf *bp;
-	int error;
+	struct xfs_da_blkinfo	*drop_info;
+	struct xfs_da_blkinfo	*save_info;
+	struct xfs_da_blkinfo	*tmp_info;
+	struct xfs_da_args	*args;
+	struct xfs_buf		*bp;
+	int			error;
 
 	/*
 	 * Set up environment.
@@ -1428,8 +1715,6 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 	ASSERT(save_blk->magic == XFS_DA_NODE_MAGIC ||
 	       save_blk->magic == XFS_DIR2_LEAFN_MAGIC ||
 	       save_blk->magic == XFS_ATTR_LEAF_MAGIC);
-	ASSERT(save_blk->magic == be16_to_cpu(save_info->magic));
-	ASSERT(drop_blk->magic == be16_to_cpu(drop_info->magic));
 	ASSERT(save_blk->magic == drop_blk->magic);
 	ASSERT((be32_to_cpu(save_info->forw) == drop_blk->blkno) ||
 	       (be32_to_cpu(save_info->back) == drop_blk->blkno));
@@ -1443,7 +1728,7 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 		trace_xfs_da_unlink_back(args);
 		save_info->back = drop_info->back;
 		if (drop_info->back) {
-			error = xfs_da_node_read(args->trans, args->dp,
+			error = xfs_da3_node_read(args->trans, args->dp,
 						be32_to_cpu(drop_info->back),
 						-1, &bp, args->whichfork);
 			if (error)
@@ -1460,7 +1745,7 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 		trace_xfs_da_unlink_forward(args);
 		save_info->forw = drop_info->forw;
 		if (drop_info->forw) {
-			error = xfs_da_node_read(args->trans, args->dp,
+			error = xfs_da3_node_read(args->trans, args->dp,
 						be32_to_cpu(drop_info->forw),
 						-1, &bp, args->whichfork);
 			if (error)
@@ -1488,15 +1773,22 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
  * the new bottom and the root.
  */
 int							/* error */
-xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
-				 int forward, int release, int *result)
+xfs_da3_path_shift(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_path *path,
+	int			forward,
+	int			release,
+	int			*result)
 {
-	xfs_da_state_blk_t *blk;
-	xfs_da_blkinfo_t *info;
-	xfs_da_intnode_t *node;
-	xfs_da_args_t *args;
-	xfs_dablk_t blkno=0;
-	int level, error;
+	struct xfs_da_state_blk	*blk;
+	struct xfs_da_blkinfo	*info;
+	struct xfs_da_intnode	*node;
+	struct xfs_da_args	*args;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr nodehdr;
+	xfs_dablk_t		blkno = 0;
+	int			level;
+	int			error;
 
 	trace_xfs_da_path_shift(state->args);
 
@@ -1511,16 +1803,17 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
 	ASSERT((path->active > 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	level = (path->active-1) - 1;	/* skip bottom layer in path */
 	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
-		ASSERT(blk->bp != NULL);
 		node = blk->bp->b_addr;
-		ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
-		if (forward && (blk->index < be16_to_cpu(node->hdr.count)-1)) {
+		xfs_da3_node_hdr_from_disk(&nodehdr, node);
+		btree = xfs_da3_node_tree_p(node);
+
+		if (forward && (blk->index < nodehdr.count - 1)) {
 			blk->index++;
-			blkno = be32_to_cpu(node->btree[blk->index].before);
+			blkno = be32_to_cpu(btree[blk->index].before);
 			break;
 		} else if (!forward && (blk->index > 0)) {
 			blk->index--;
-			blkno = be32_to_cpu(node->btree[blk->index].before);
+			blkno = be32_to_cpu(btree[blk->index].before);
 			break;
 		}
 	}
@@ -1546,47 +1839,58 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
 		 * Read the next child block.
 		 */
 		blk->blkno = blkno;
-		error = xfs_da_node_read(args->trans, args->dp, blkno, -1,
+		error = xfs_da3_node_read(args->trans, args->dp, blkno, -1,
 					&blk->bp, args->whichfork);
 		if (error)
 			return(error);
-		ASSERT(blk->bp != NULL);
 		info = blk->bp->b_addr;
 		ASSERT(info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
+		       info->magic == cpu_to_be16(XFS_DA3_NODE_MAGIC) ||
 		       info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
 		       info->magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) ||
 		       info->magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
-		blk->magic = be16_to_cpu(info->magic);
-		if (blk->magic == XFS_DA_NODE_MAGIC) {
+
+
+		/*
+		 * Note: we flatten the magic number to a single type so we
+		 * don't have to compare against crc/non-crc types elsewhere.
+		 */
+		switch (be16_to_cpu(info->magic)) {
+		case XFS_DA_NODE_MAGIC:
+		case XFS_DA3_NODE_MAGIC:
+			blk->magic = XFS_DA_NODE_MAGIC;
 			node = (xfs_da_intnode_t *)info;
-			blk->hashval = be32_to_cpu(node->btree[be16_to_cpu(node->hdr.count)-1].hashval);
+			xfs_da3_node_hdr_from_disk(&nodehdr, node);
+			btree = xfs_da3_node_tree_p(node);
+			blk->hashval = be32_to_cpu(btree[nodehdr.count - 1].hashval);
 			if (forward)
 				blk->index = 0;
 			else
-				blk->index = be16_to_cpu(node->hdr.count)-1;
-			blkno = be32_to_cpu(node->btree[blk->index].before);
-		} else {
+				blk->index = nodehdr.count - 1;
+			blkno = be32_to_cpu(btree[blk->index].before);
+			break;
+		case XFS_ATTR_LEAF_MAGIC:
+			blk->magic = XFS_ATTR_LEAF_MAGIC;
 			ASSERT(level == path->active-1);
 			blk->index = 0;
-			switch(blk->magic) {
-			case XFS_ATTR_LEAF_MAGIC:
-				blk->hashval = xfs_attr_leaf_lasthash(blk->bp,
-								      NULL);
-				break;
-			case XFS_DIR2_LEAFN_MAGIC:
-			case XFS_DIR3_LEAFN_MAGIC:
-				blk->magic = XFS_DIR2_LEAFN_MAGIC;
-				blk->hashval = xfs_dir2_leafn_lasthash(blk->bp,
-								       NULL);
-				break;
-			default:
-				ASSERT(0);
-				break;
-			}
+			blk->hashval = xfs_attr_leaf_lasthash(blk->bp,
+							      NULL);
+			break;
+		case XFS_DIR2_LEAFN_MAGIC:
+		case XFS_DIR3_LEAFN_MAGIC:
+			blk->magic = XFS_DIR2_LEAFN_MAGIC;
+			ASSERT(level == path->active-1);
+			blk->index = 0;
+			blk->hashval = xfs_dir2_leafn_lasthash(blk->bp,
+							       NULL);
+			break;
+		default:
+			ASSERT(0);
+			break;
 		}
 	}
 	*result = 0;
-	return(0);
+	return 0;
 }
 
 
@@ -1773,22 +2077,36 @@ xfs_da_grow_inode(
  * a bmap btree split to do that.
  */
 STATIC int
-xfs_da_swap_lastblock(
-	xfs_da_args_t	*args,
-	xfs_dablk_t	*dead_blknop,
-	struct xfs_buf	**dead_bufp)
+xfs_da3_swap_lastblock(
+	struct xfs_da_args	*args,
+	xfs_dablk_t		*dead_blknop,
+	struct xfs_buf		**dead_bufp)
 {
-	xfs_dablk_t dead_blkno, last_blkno, sib_blkno, par_blkno;
-	struct xfs_buf *dead_buf, *last_buf, *sib_buf, *par_buf;
-	xfs_fileoff_t lastoff;
-	xfs_inode_t *ip;
-	xfs_trans_t *tp;
-	xfs_mount_t *mp;
-	int error, w, entno, level, dead_level;
-	xfs_da_blkinfo_t *dead_info, *sib_info;
-	xfs_da_intnode_t *par_node, *dead_node;
-	xfs_dir2_leaf_t *dead_leaf2;
-	xfs_dahash_t dead_hash;
+	struct xfs_da_blkinfo	*dead_info;
+	struct xfs_da_blkinfo	*sib_info;
+	struct xfs_da_intnode	*par_node;
+	struct xfs_da_intnode	*dead_node;
+	struct xfs_dir2_leaf	*dead_leaf2;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr par_hdr;
+	struct xfs_inode	*ip;
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp;
+	struct xfs_buf		*dead_buf;
+	struct xfs_buf		*last_buf;
+	struct xfs_buf		*sib_buf;
+	struct xfs_buf		*par_buf;
+	xfs_dahash_t		dead_hash;
+	xfs_fileoff_t		lastoff;
+	xfs_dablk_t		dead_blkno;
+	xfs_dablk_t		last_blkno;
+	xfs_dablk_t		sib_blkno;
+	xfs_dablk_t		par_blkno;
+	int			error;
+	int			w;
+	int			entno;
+	int			level;
+	int			dead_level;
 
 	trace_xfs_da_swap_lastblock(args);
 
@@ -1812,7 +2130,7 @@ xfs_da_swap_lastblock(
 	 * Read the last block in the btree space.
 	 */
 	last_blkno = (xfs_dablk_t)lastoff - mp->m_dirblkfsbs;
-	error = xfs_da_node_read(tp, ip, last_blkno, -1, &last_buf, w);
+	error = xfs_da3_node_read(tp, ip, last_blkno, -1, &last_buf, w);
 	if (error)
 		return error;
 	/*
@@ -1835,17 +2153,22 @@ xfs_da_swap_lastblock(
 		dead_level = 0;
 		dead_hash = be32_to_cpu(ents[leafhdr.count - 1].hashval);
 	} else {
-		ASSERT(dead_info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
+		struct xfs_da3_icnode_hdr deadhdr;
+
+		ASSERT(dead_info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
+		       dead_info->magic == cpu_to_be16(XFS_DA3_NODE_MAGIC));
 		dead_node = (xfs_da_intnode_t *)dead_info;
-		dead_level = be16_to_cpu(dead_node->hdr.level);
-		dead_hash = be32_to_cpu(dead_node->btree[be16_to_cpu(dead_node->hdr.count) - 1].hashval);
+		xfs_da3_node_hdr_from_disk(&deadhdr, dead_node);
+		btree = xfs_da3_node_tree_p(dead_node);
+		dead_level = deadhdr.level;
+		dead_hash = be32_to_cpu(btree[deadhdr.count - 1].hashval);
 	}
 	sib_buf = par_buf = NULL;
 	/*
 	 * If the moved block has a left sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->back))) {
-		error = xfs_da_node_read(tp, ip, sib_blkno, -1, &sib_buf, w);
+		error = xfs_da3_node_read(tp, ip, sib_blkno, -1, &sib_buf, w);
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
@@ -1867,7 +2190,7 @@ xfs_da_swap_lastblock(
 	 * If the moved block has a right sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->forw))) {
-		error = xfs_da_node_read(tp, ip, sib_blkno, -1, &sib_buf, w);
+		error = xfs_da3_node_read(tp, ip, sib_blkno, -1, &sib_buf, w);
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
@@ -1891,31 +2214,31 @@ xfs_da_swap_lastblock(
 	 * Walk down the tree looking for the parent of the moved block.
 	 */
 	for (;;) {
-		error = xfs_da_node_read(tp, ip, par_blkno, -1, &par_buf, w);
+		error = xfs_da3_node_read(tp, ip, par_blkno, -1, &par_buf, w);
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
-		if (unlikely(par_node->hdr.info.magic !=
-		    cpu_to_be16(XFS_DA_NODE_MAGIC) ||
-		    (level >= 0 && level != be16_to_cpu(par_node->hdr.level) + 1))) {
+		xfs_da3_node_hdr_from_disk(&par_hdr, par_node);
+		if (level >= 0 && level != par_hdr.level + 1) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(4)",
 					 XFS_ERRLEVEL_LOW, mp);
 			error = XFS_ERROR(EFSCORRUPTED);
 			goto done;
 		}
-		level = be16_to_cpu(par_node->hdr.level);
+		level = par_hdr.level;
+		btree = xfs_da3_node_tree_p(par_node);
 		for (entno = 0;
-		     entno < be16_to_cpu(par_node->hdr.count) &&
-		     be32_to_cpu(par_node->btree[entno].hashval) < dead_hash;
+		     entno < par_hdr.count &&
+		     be32_to_cpu(btree[entno].hashval) < dead_hash;
 		     entno++)
 			continue;
-		if (unlikely(entno == be16_to_cpu(par_node->hdr.count))) {
+		if (entno == par_hdr.count) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(5)",
 					 XFS_ERRLEVEL_LOW, mp);
 			error = XFS_ERROR(EFSCORRUPTED);
 			goto done;
 		}
-		par_blkno = be32_to_cpu(par_node->btree[entno].before);
+		par_blkno = be32_to_cpu(btree[entno].before);
 		if (level == dead_level + 1)
 			break;
 		xfs_trans_brelse(tp, par_buf);
@@ -1927,13 +2250,13 @@ xfs_da_swap_lastblock(
 	 */
 	for (;;) {
 		for (;
-		     entno < be16_to_cpu(par_node->hdr.count) &&
-		     be32_to_cpu(par_node->btree[entno].before) != last_blkno;
+		     entno < par_hdr.count &&
+		     be32_to_cpu(btree[entno].before) != last_blkno;
 		     entno++)
 			continue;
-		if (entno < be16_to_cpu(par_node->hdr.count))
+		if (entno < par_hdr.count)
 			break;
-		par_blkno = be32_to_cpu(par_node->hdr.info.forw);
+		par_blkno = par_hdr.forw;
 		xfs_trans_brelse(tp, par_buf);
 		par_buf = NULL;
 		if (unlikely(par_blkno == 0)) {
@@ -1942,27 +2265,27 @@ xfs_da_swap_lastblock(
 			error = XFS_ERROR(EFSCORRUPTED);
 			goto done;
 		}
-		error = xfs_da_node_read(tp, ip, par_blkno, -1, &par_buf, w);
+		error = xfs_da3_node_read(tp, ip, par_blkno, -1, &par_buf, w);
 		if (error)
 			goto done;
 		par_node = par_buf->b_addr;
-		if (unlikely(
-		    be16_to_cpu(par_node->hdr.level) != level ||
-		    par_node->hdr.info.magic != cpu_to_be16(XFS_DA_NODE_MAGIC))) {
+		xfs_da3_node_hdr_from_disk(&par_hdr, par_node);
+		if (par_hdr.level != level) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(7)",
 					 XFS_ERRLEVEL_LOW, mp);
 			error = XFS_ERROR(EFSCORRUPTED);
 			goto done;
 		}
+		btree = xfs_da3_node_tree_p(par_node);
 		entno = 0;
 	}
 	/*
 	 * Update the parent entry pointing to the moved block.
 	 */
-	par_node->btree[entno].before = cpu_to_be32(dead_blkno);
+	btree[entno].before = cpu_to_be32(dead_blkno);
 	xfs_trans_log_buf(tp, par_buf,
-		XFS_DA_LOGRANGE(par_node, &par_node->btree[entno].before,
-				sizeof(par_node->btree[entno].before)));
+		XFS_DA_LOGRANGE(par_node, &btree[entno].before,
+				sizeof(btree[entno].before)));
 	*dead_blknop = last_blkno;
 	*dead_bufp = last_buf;
 	return 0;
@@ -2004,14 +2327,15 @@ xfs_da_shrink_inode(
 		 * Remove extents.  If we get ENOSPC for a dir we have to move
 		 * the last block to the place we want to kill.
 		 */
-		if ((error = xfs_bunmapi(tp, dp, dead_blkno, count,
-				xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
-				0, args->firstblock, args->flist,
-				&done)) == ENOSPC) {
+		error = xfs_bunmapi(tp, dp, dead_blkno, count,
+				    xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
+				    0, args->firstblock, args->flist, &done);
+		if (error == ENOSPC) {
 			if (w != XFS_DATA_FORK)
 				break;
-			if ((error = xfs_da_swap_lastblock(args, &dead_blkno,
-					&dead_buf)))
+			error = xfs_da3_swap_lastblock(args, &dead_blkno,
+						      &dead_buf);
+			if (error)
 				break;
 		} else {
 			break;
@@ -2276,6 +2600,7 @@ xfs_da_read_buf(
 		magic1 = be32_to_cpu(hdr->magic);
 		if (unlikely(
 		    XFS_TEST_ERROR((magic != XFS_DA_NODE_MAGIC) &&
+				   (magic != XFS_DA3_NODE_MAGIC) &&
 				   (magic != XFS_ATTR_LEAF_MAGIC) &&
 				   (magic != XFS_DIR2_LEAF1_MAGIC) &&
 				   (magic != XFS_DIR3_LEAF1_MAGIC) &&
@@ -2346,41 +2671,3 @@ out_free:
 		return -1;
 	return mappedbno;
 }
-
-kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
-
-/*
- * Allocate a dir-state structure.
- * We don't put them on the stack since they're large.
- */
-xfs_da_state_t *
-xfs_da_state_alloc(void)
-{
-	return kmem_zone_zalloc(xfs_da_state_zone, KM_NOFS);
-}
-
-/*
- * Kill the altpath contents of a da-state structure.
- */
-STATIC void
-xfs_da_state_kill_altpath(xfs_da_state_t *state)
-{
-	int	i;
-
-	for (i = 0; i < state->altpath.active; i++)
-		state->altpath.blk[i].bp = NULL;
-	state->altpath.active = 0;
-}
-
-/*
- * Free a da-state structure.
- */
-void
-xfs_da_state_free(xfs_da_state_t *state)
-{
-	xfs_da_state_kill_altpath(state);
-#ifdef DEBUG
-	memset((char *)state, 0, sizeof(*state));
-#endif /* DEBUG */
-	kmem_zone_free(xfs_da_state_zone, state);
-}
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 9b93816..9e75553 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -1356,7 +1356,7 @@ xfs_dir2_leafn_split(
 	 * block into the leaves.
 	 */
 	xfs_dir2_leafn_rebalance(state, oldblk, newblk);
-	error = xfs_da_blk_link(state, oldblk, newblk);
+	error = xfs_da3_blk_link(state, oldblk, newblk);
 	if (error) {
 		return error;
 	}
@@ -1437,7 +1437,7 @@ xfs_dir2_leafn_toosmall(
 		 */
 		forward = (leafhdr.forw != 0);
 		memcpy(&state->altpath, &state->path, sizeof(state->path));
-		error = xfs_da_path_shift(state, &state->altpath, forward, 0,
+		error = xfs_da3_path_shift(state, &state->altpath, forward, 0,
 			&rval);
 		if (error)
 			return error;
@@ -1499,10 +1499,10 @@ xfs_dir2_leafn_toosmall(
 	 */
 	memcpy(&state->altpath, &state->path, sizeof(state->path));
 	if (blkno < blk->blkno)
-		error = xfs_da_path_shift(state, &state->altpath, forward, 0,
+		error = xfs_da3_path_shift(state, &state->altpath, forward, 0,
 			&rval);
 	else
-		error = xfs_da_path_shift(state, &state->path, forward, 0,
+		error = xfs_da3_path_shift(state, &state->path, forward, 0,
 			&rval);
 	if (error) {
 		return error;
@@ -1599,7 +1599,7 @@ xfs_dir2_node_addname(
 	 * Look up the name.  We're not supposed to find it, but
 	 * this gives us the insertion point.
 	 */
-	error = xfs_da_node_lookup_int(state, &rval);
+	error = xfs_da3_node_lookup_int(state, &rval);
 	if (error)
 		rval = error;
 	if (rval != ENOENT) {
@@ -1625,7 +1625,7 @@ xfs_dir2_node_addname(
 		 * It worked, fix the hash values up the btree.
 		 */
 		if (!(args->op_flags & XFS_DA_OP_JUSTCHECK))
-			xfs_da_fixhashpath(state, &state->path);
+			xfs_da3_fixhashpath(state, &state->path);
 	} else {
 		/*
 		 * It didn't work, we need to split the leaf block.
@@ -1637,7 +1637,7 @@ xfs_dir2_node_addname(
 		/*
 		 * Split the leaf block and insert the new entry.
 		 */
-		rval = xfs_da_split(state);
+		rval = xfs_da3_split(state);
 	}
 done:
 	xfs_da_state_free(state);
@@ -2015,7 +2015,7 @@ xfs_dir2_node_addname_int(
 
 /*
  * Lookup an entry in a node-format directory.
- * All the real work happens in xfs_da_node_lookup_int.
+ * All the real work happens in xfs_da3_node_lookup_int.
  * The only real output is the inode number of the entry.
  */
 int						/* error */
@@ -2040,7 +2040,7 @@ xfs_dir2_node_lookup(
 	/*
 	 * Fill in the path to the entry in the cursor.
 	 */
-	error = xfs_da_node_lookup_int(state, &rval);
+	error = xfs_da3_node_lookup_int(state, &rval);
 	if (error)
 		rval = error;
 	else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE) {
@@ -2095,7 +2095,7 @@ xfs_dir2_node_removename(
 	/*
 	 * Look up the entry we're deleting, set up the cursor.
 	 */
-	error = xfs_da_node_lookup_int(state, &rval);
+	error = xfs_da3_node_lookup_int(state, &rval);
 	if (error)
 		rval = error;
 	/*
@@ -2119,12 +2119,12 @@ xfs_dir2_node_removename(
 	/*
 	 * Fix the hash values up the btree.
 	 */
-	xfs_da_fixhashpath(state, &state->path);
+	xfs_da3_fixhashpath(state, &state->path);
 	/*
 	 * If we need to join leaf blocks, do it.
 	 */
 	if (rval && state->path.active > 1)
-		error = xfs_da_join(state);
+		error = xfs_da3_join(state);
 	/*
 	 * If no errors so far, try conversion to leaf format.
 	 */
@@ -2166,7 +2166,7 @@ xfs_dir2_node_replace(
 	/*
 	 * Lookup the entry to change in the btree.
 	 */
-	error = xfs_da_node_lookup_int(state, &rval);
+	error = xfs_da3_node_lookup_int(state, &rval);
 	if (error) {
 		rval = error;
 	}
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 758e492..4897fba 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -147,6 +147,8 @@ traverse_int_dablock(xfs_mount_t	*mp,
 	xfs_da_intnode_t	*node;
 	xfs_dfsbno_t		fsbno;
 	xfs_buf_t		*bp;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr nodehdr;
 
 	/*
 	 * traverse down left-side of tree until we hit the
@@ -182,20 +184,22 @@ traverse_int_dablock(xfs_mount_t	*mp,
 		}
 
 		node = (xfs_da_intnode_t *)XFS_BUF_PTR(bp);
+		btree = xfs_da3_node_tree_p(node);
+		xfs_da3_node_hdr_from_disk(&nodehdr, node);
 
-		if (be16_to_cpu(node->hdr.info.magic) != XFS_DA_NODE_MAGIC)  {
+		if (nodehdr.magic != XFS_DA_NODE_MAGIC)  {
 			do_warn(_("bad dir/attr magic number in inode %" PRIu64 ", "
 				  "file bno = %u, fsbno = %" PRIu64 "\n"),
 				da_cursor->ino, bno, fsbno);
 			libxfs_putbuf(bp);
 			goto error_out;
 		}
-		if (be16_to_cpu(node->hdr.count) >
-						mp->m_dir_node_ents)  {
+
+		if (nodehdr.count > mp->m_dir_node_ents)  {
 			do_warn(_("bad record count in inode %" PRIu64 ", "
 				  "count = %d, max = %d\n"),
 				da_cursor->ino,
-				be16_to_cpu(node->hdr.count),
+				nodehdr.count,
 				mp->m_dir_node_ents);
 			libxfs_putbuf(bp);
 			goto error_out;
@@ -205,9 +209,9 @@ traverse_int_dablock(xfs_mount_t	*mp,
 		 * maintain level counter
 		 */
 		if (i == -1)
-			i = da_cursor->active = be16_to_cpu(node->hdr.level);
+			i = da_cursor->active = nodehdr.level;
 		else  {
-			if (be16_to_cpu(node->hdr.level) == i - 1)  {
+			if (nodehdr.level == i - 1)  {
 				i--;
 			} else  {
 				if (whichfork == XFS_DATA_FORK)
@@ -223,8 +227,7 @@ traverse_int_dablock(xfs_mount_t	*mp,
 			}
 		}
 
-		da_cursor->level[i].hashval = be32_to_cpu(
-							node->btree[0].hashval);
+		da_cursor->level[i].hashval = be32_to_cpu(btree[0].hashval);
 		da_cursor->level[i].bp = bp;
 		da_cursor->level[i].bno = bno;
 		da_cursor->level[i].index = 0;
@@ -235,7 +238,7 @@ traverse_int_dablock(xfs_mount_t	*mp,
 		/*
 		 * set up new bno for next level down
 		 */
-		bno = be32_to_cpu(node->btree[0].before);
+		bno = be32_to_cpu(btree[0].before);
 	} while (node != NULL && i > 1);
 
 	/*
@@ -319,6 +322,8 @@ verify_final_da_path(xfs_mount_t	*mp,
 	int			bad = 0;
 	int			entry;
 	int			this_level = p_level + 1;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr nodehdr;
 
 #ifdef XR_DIR_TRACE
 	fprintf(stderr, "in verify_final_da_path, this_level = %d\n",
@@ -330,32 +335,35 @@ verify_final_da_path(xfs_mount_t	*mp,
 	 */
 	entry = cursor->level[this_level].index;
 	node = (xfs_da_intnode_t *)XFS_BUF_PTR(cursor->level[this_level].bp);
+	btree = xfs_da3_node_tree_p(node);
+	xfs_da3_node_hdr_from_disk(&nodehdr, node);
+
 	/*
 	 * check internal block consistency on this level -- ensure
 	 * that all entries are used, encountered and expected hashvals
 	 * match, etc.
 	 */
-	if (entry != be16_to_cpu(node->hdr.count) - 1)  {
+	if (entry != nodehdr.count - 1)  {
 		do_warn(_("directory/attribute block used/count "
 			  "inconsistency - %d/%hu\n"),
-			entry, be16_to_cpu(node->hdr.count));
+			entry, nodehdr.count);
 		bad++;
 	}
 	/*
 	 * hash values monotonically increasing ???
 	 */
 	if (cursor->level[this_level].hashval >= 
-				be32_to_cpu(node->btree[entry].hashval)) {
+				be32_to_cpu(btree[entry].hashval)) {
 		do_warn(_("directory/attribute block hashvalue inconsistency, "
 			  "expected > %u / saw %u\n"),
 			cursor->level[this_level].hashval,
-			be32_to_cpu(node->btree[entry].hashval));
+			be32_to_cpu(btree[entry].hashval));
 		bad++;
 	}
-	if (be32_to_cpu(node->hdr.info.forw) != 0)  {
+	if (nodehdr.forw != 0)  {
 		do_warn(_("bad directory/attribute forward block pointer, "
 			  "expected 0, saw %u\n"),
-			be32_to_cpu(node->hdr.info.forw));
+			nodehdr.forw);
 		bad++;
 	}
 	if (bad) {
@@ -373,12 +381,11 @@ verify_final_da_path(xfs_mount_t	*mp,
 	/*
 	 * ok, now check descendant block number against this level
 	 */
-	if (cursor->level[p_level].bno != be32_to_cpu(
-						node->btree[entry].before)) {
+	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before)) {
 #ifdef XR_DIR_TRACE
 		fprintf(stderr, "bad directory btree pointer, child bno should "
 				"be %d, block bno is %d, hashval is %u\n",
-			be16_to_cpu(node->btree[entry].before),
+			be16_to_cpu(btree[entry].before),
 			cursor->level[p_level].bno,
 			cursor->level[p_level].hashval);
 		fprintf(stderr, "verify_final_da_path returns 1 (bad) #1a\n");
@@ -386,14 +393,13 @@ verify_final_da_path(xfs_mount_t	*mp,
 		return(1);
 	}
 
-	if (cursor->level[p_level].hashval != be32_to_cpu(
-						node->btree[entry].hashval)) {
+	if (cursor->level[p_level].hashval != be32_to_cpu(btree[entry].hashval)) {
 		if (!no_modify)  {
 			do_warn(_("correcting bad hashval in non-leaf "
 				  "dir/attr block\n\tin (level %d) in "
 				  "inode %" PRIu64 ".\n"),
 				this_level, cursor->ino);
-			node->btree[entry].hashval = cpu_to_be32(
+			btree[entry].hashval = cpu_to_be32(
 						cursor->level[p_level].hashval);
 			cursor->level[this_level].dirty++;
 		} else  {
@@ -408,7 +414,7 @@ verify_final_da_path(xfs_mount_t	*mp,
 	 * Note: squirrel hashval away _before_ releasing the
 	 * buffer, preventing a use-after-free problem.
 	 */
-	hashval = be32_to_cpu(node->btree[entry].hashval);
+	hashval = be32_to_cpu(btree[entry].hashval);
 
 	/*
 	 * release/write buffer
@@ -492,6 +498,8 @@ verify_da_path(xfs_mount_t	*mp,
 	int			bad;
 	int			entry;
 	int			this_level = p_level + 1;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr nodehdr;
 
 	/*
 	 * index is currently set to point to the entry that
@@ -499,20 +507,22 @@ verify_da_path(xfs_mount_t	*mp,
 	 */
 	entry = cursor->level[this_level].index;
 	node = (xfs_da_intnode_t *)XFS_BUF_PTR(cursor->level[this_level].bp);
+	btree = xfs_da3_node_tree_p(node);
+	xfs_da3_node_hdr_from_disk(&nodehdr, node);
 
 	/*
 	 * if this block is out of entries, validate this
 	 * block and move on to the next block.
 	 * and update cursor value for said level
 	 */
-	if (entry >= be16_to_cpu(node->hdr.count))  {
+	if (entry >= nodehdr.count)  {
 		/*
 		 * update the hash value for this level before
 		 * validating it.  bno value should be ok since
 		 * it was set when the block was first read in.
 		 */
 		cursor->level[this_level].hashval =
-				be32_to_cpu(node->btree[entry - 1].hashval);
+				be32_to_cpu(btree[entry - 1].hashval);
 
 		/*
 		 * keep track of greatest block # -- that gets
@@ -530,7 +540,7 @@ verify_da_path(xfs_mount_t	*mp,
 		/*
 		 * ok, now get the next buffer and check sibling pointers
 		 */
-		dabno = be32_to_cpu(node->hdr.info.forw);
+		dabno = nodehdr.forw;
 		ASSERT(dabno != 0);
 		fsbno = blkmap_get(cursor->blkmap, dabno);
 
@@ -551,36 +561,37 @@ verify_da_path(xfs_mount_t	*mp,
 		}
 
 		newnode = (xfs_da_intnode_t *)XFS_BUF_PTR(bp);
+		btree = xfs_da3_node_tree_p(node);
+		xfs_da3_node_hdr_from_disk(&nodehdr, newnode);
 		/*
 		 * verify magic number and back pointer, sanity-check
 		 * entry count, verify level
 		 */
 		bad = 0;
-		if (XFS_DA_NODE_MAGIC != be16_to_cpu(newnode->hdr.info.magic)) {
+		if (XFS_DA_NODE_MAGIC != nodehdr.magic) {
 			do_warn(
 	_("bad magic number %x in block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
-				be16_to_cpu(newnode->hdr.info.magic),
+				nodehdr.magic,
 				dabno, fsbno, cursor->ino);
 			bad++;
 		}
-		if (be32_to_cpu(newnode->hdr.info.back) != 
-						cursor->level[this_level].bno) {
+		if (nodehdr.back != cursor->level[this_level].bno) {
 			do_warn(
 	_("bad back pointer in block %u (%"PRIu64 ") for directory inode %" PRIu64 "\n"),
 				dabno, fsbno, cursor->ino);
 			bad++;
 		}
-		if (be16_to_cpu(newnode->hdr.count) > mp->m_dir_node_ents) {
+		if (nodehdr.count > mp->m_dir_node_ents) {
 			do_warn(
 	_("entry count %d too large in block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
-				be16_to_cpu(newnode->hdr.count),
+				nodehdr.count,
 				dabno, fsbno, cursor->ino);
 			bad++;
 		}
-		if (be16_to_cpu(newnode->hdr.level) != this_level) {
+		if (nodehdr.level != this_level) {
 			do_warn(
 	_("bad level %d in block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
-				be16_to_cpu(newnode->hdr.level),
+				nodehdr.level,
 				dabno, fsbno, cursor->ino);
 			bad++;
 		}
@@ -606,7 +617,7 @@ verify_da_path(xfs_mount_t	*mp,
 		cursor->level[this_level].dirty = 0;
 		cursor->level[this_level].bno = dabno;
 		cursor->level[this_level].hashval =
-					be32_to_cpu(newnode->btree[0].hashval);
+					be32_to_cpu(btree[0].hashval);
 #ifdef XR_DIR_TRACE
 		cursor->level[this_level].n = newnode;
 #endif
@@ -617,12 +628,11 @@ verify_da_path(xfs_mount_t	*mp,
 	/*
 	 * ditto for block numbers
 	 */
-	if (cursor->level[p_level].bno !=
-				be32_to_cpu(node->btree[entry].before))  {
+	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before))  {
 #ifdef XR_DIR_TRACE
 		fprintf(stderr, "bad directory btree pointer, child bno "
 			"should be %d, block bno is %d, hashval is %u\n",
-			be32_to_cpu(node->btree[entry].before),
+			be32_to_cpu(btree[entry].before),
 			cursor->level[p_level].bno,
 			cursor->level[p_level].hashval);
 		fprintf(stderr, "verify_da_path returns 1 (bad) #1a\n");
@@ -634,13 +644,13 @@ verify_da_path(xfs_mount_t	*mp,
 	 * block against the hashval in the current entry
 	 */
 	if (cursor->level[p_level].hashval !=
-				be32_to_cpu(node->btree[entry].hashval))  {
+				be32_to_cpu(btree[entry].hashval))  {
 		if (!no_modify)  {
 			do_warn(_("correcting bad hashval in interior "
 				  "dir/attr block\n\tin (level %d) in "
 				  "inode %" PRIu64 ".\n"),
 				this_level, cursor->ino);
-			node->btree[entry].hashval = cpu_to_be32(
+			btree[entry].hashval = cpu_to_be32(
 						cursor->level[p_level].hashval);
 			cursor->level[this_level].dirty++;
 		} else  {
diff --git a/repair/dir2.c b/repair/dir2.c
index 2f13864..ae80a6b 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -147,9 +147,10 @@ traverse_int_dir2block(xfs_mount_t	*mp,
 	struct xfs_buf		*bp;
 	int			i;
 	int			nex;
-	xfs_da_blkinfo_t	*info;
 	xfs_da_intnode_t	*node;
 	bmap_ext_t		lbmp;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr nodehdr;
 
 	/*
 	 * traverse down left-side of tree until we hit the
@@ -158,7 +159,7 @@ traverse_int_dir2block(xfs_mount_t	*mp,
 	 */
 	bno = mp->m_dirleafblk;
 	i = -1;
-	info = NULL;
+	node = NULL;
 	da_cursor->active = 0;
 
 	do {
@@ -181,9 +182,10 @@ _("can't read block %u for directory inode %" PRIu64 "\n"),
 			goto error_out;
 		}
 
-		info = bp->b_addr;
+		node = bp->b_addr;
+		xfs_da3_node_hdr_from_disk(&nodehdr, node);
 
-		if (be16_to_cpu(info->magic) == XFS_DIR2_LEAFN_MAGIC)  {
+		if (nodehdr.magic == XFS_DIR2_LEAFN_MAGIC)  {
 			if ( i != -1 ) {
 				do_warn(
 _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
@@ -192,20 +194,21 @@ _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
 			*rbno = 0;
 			libxfs_putbuf(bp);
 			return(1);
-		} else if (be16_to_cpu(info->magic) != XFS_DA_NODE_MAGIC)  {
+		} else if (nodehdr.magic != XFS_DA_NODE_MAGIC)  {
 			libxfs_putbuf(bp);
 			do_warn(
 _("bad dir magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
-				be16_to_cpu(info->magic),
+					nodehdr.magic,
 					da_cursor->ino, bno);
 			goto error_out;
 		}
-		node = (xfs_da_intnode_t*)info;
-		if (be16_to_cpu(node->hdr.count) > mp->m_dir_node_ents)  {
+		btree = xfs_da3_node_tree_p(node);
+		if (nodehdr.count > mp->m_dir_node_ents)  {
 			libxfs_putbuf(bp);
 			do_warn(
-_("bad record count in inode %" PRIu64 ", count = %d, max = %d\n"), da_cursor->ino,
-				be16_to_cpu(node->hdr.count),
+_("bad record count in inode %" PRIu64 ", count = %d, max = %d\n"),
+				da_cursor->ino,
+				nodehdr.count,
 				mp->m_dir_node_ents);
 			goto error_out;
 		}
@@ -213,7 +216,7 @@ _("bad record count in inode %" PRIu64 ", count = %d, max = %d\n"), da_cursor->i
 		 * maintain level counter
 		 */
 		if (i == -1) {
-			i = da_cursor->active = be16_to_cpu(node->hdr.level);
+			i = da_cursor->active = nodehdr.level;
 			if (i >= XFS_DA_NODE_MAXDEPTH) {
 				do_warn(
 _("bad header depth for directory inode %" PRIu64 "\n"),
@@ -223,7 +226,7 @@ _("bad header depth for directory inode %" PRIu64 "\n"),
 				goto error_out;
 			}
 		} else {
-			if (be16_to_cpu(node->hdr.level) == i - 1)  {
+			if (nodehdr.level == i - 1)  {
 				i--;
 			} else  {
 				do_warn(
@@ -234,8 +237,7 @@ _("bad directory btree for directory inode %" PRIu64 "\n"),
 			}
 		}
 
-		da_cursor->level[i].hashval =
-					be32_to_cpu(node->btree[0].hashval);
+		da_cursor->level[i].hashval = be32_to_cpu(btree[0].hashval);
 		da_cursor->level[i].bp = bp;
 		da_cursor->level[i].bno = bno;
 		da_cursor->level[i].index = 0;
@@ -243,8 +245,8 @@ _("bad directory btree for directory inode %" PRIu64 "\n"),
 		/*
 		 * set up new bno for next level down
 		 */
-		bno = be32_to_cpu(node->btree[0].before);
-	} while (info != NULL && i > 1);
+		bno = be32_to_cpu(btree[0].before);
+	} while (node != NULL && i > 1);
 
 	/*
 	 * now return block number and get out
@@ -326,6 +328,8 @@ verify_final_dir2_path(xfs_mount_t	*mp,
 	int			bad = 0;
 	int			entry;
 	int			this_level = p_level + 1;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr nodehdr;
 
 	/*
 	 * the index should point to the next "unprocessed" entry
@@ -333,32 +337,34 @@ verify_final_dir2_path(xfs_mount_t	*mp,
 	 */
 	entry = cursor->level[this_level].index;
 	node = (xfs_da_intnode_t *)(cursor->level[this_level].bp->b_addr);
+	btree = xfs_da3_node_tree_p(node);
+	xfs_da3_node_hdr_from_disk(&nodehdr, node);
 	/*
 	 * check internal block consistency on this level -- ensure
 	 * that all entries are used, encountered and expected hashvals
 	 * match, etc.
 	 */
-	if (entry != be16_to_cpu(node->hdr.count) - 1)  {
+	if (entry != nodehdr.count - 1)  {
 		do_warn(
 		_("directory block used/count inconsistency - %d / %hu\n"),
-			entry, be16_to_cpu(node->hdr.count));
+			entry, nodehdr.count);
 		bad++;
 	}
 	/*
 	 * hash values monotonically increasing ???
 	 */
 	if (cursor->level[this_level].hashval >=
-				be32_to_cpu(node->btree[entry].hashval))  {
+				be32_to_cpu(btree[entry].hashval))  {
 		do_warn(_("directory/attribute block hashvalue inconsistency, "
 			  "expected > %u / saw %u\n"),
 			cursor->level[this_level].hashval,
-			be32_to_cpu(node->btree[entry].hashval));
+			be32_to_cpu(btree[entry].hashval));
 		bad++;
 	}
-	if (be32_to_cpu(node->hdr.info.forw) != 0)  {
+	if (nodehdr.forw != 0)  {
 		do_warn(_("bad directory/attribute forward block pointer, "
 			  "expected 0, saw %u\n"),
-			be32_to_cpu(node->hdr.info.forw));
+			nodehdr.forw);
 		bad++;
 	}
 	if (bad)  {
@@ -375,18 +381,17 @@ verify_final_dir2_path(xfs_mount_t	*mp,
 	/*
 	 * ok, now check descendant block number against this level
 	 */
-	if (cursor->level[p_level].bno !=
-				be32_to_cpu(node->btree[entry].before))
+	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before))
 		return(1);
 
 	if (cursor->level[p_level].hashval !=
-				be32_to_cpu(node->btree[entry].hashval))  {
+				be32_to_cpu(btree[entry].hashval))  {
 		if (!no_modify)  {
 			do_warn(
 _("correcting bad hashval in non-leaf dir block\n"
   "\tin (level %d) in inode %" PRIu64 ".\n"),
 				this_level, cursor->ino);
-			node->btree[entry].hashval = cpu_to_be32(
+			btree[entry].hashval = cpu_to_be32(
 						cursor->level[p_level].hashval);
 			cursor->level[this_level].dirty++;
 		} else  {
@@ -419,8 +424,7 @@ _("would correct bad hashval in non-leaf dir block\n"
 	 * set hashvalue to correctl reflect the now-validated
 	 * last entry in this block and continue upwards validation
 	 */
-	cursor->level[this_level].hashval =
-		be32_to_cpu(node->btree[entry].hashval);
+	cursor->level[this_level].hashval = be32_to_cpu(btree[entry].hashval);
 
 	return(verify_final_dir2_path(mp, cursor, this_level));
 }
@@ -479,6 +483,8 @@ verify_dir2_path(xfs_mount_t	*mp,
 	bmap_ext_t		*bmp;
 	int			nex;
 	bmap_ext_t		lbmp;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr nodehdr;
 
 	/*
 	 * index is currently set to point to the entry that
@@ -486,20 +492,22 @@ verify_dir2_path(xfs_mount_t	*mp,
 	 */
 	entry = cursor->level[this_level].index;
 	node = cursor->level[this_level].bp->b_addr;
+	btree = xfs_da3_node_tree_p(node);
+	xfs_da3_node_hdr_from_disk(&nodehdr, node);
 
 	/*
 	 * if this block is out of entries, validate this
 	 * block and move on to the next block.
 	 * and update cursor value for said level
 	 */
-	if (entry >= be16_to_cpu(node->hdr.count))  {
+	if (entry >= nodehdr.count)  {
 		/*
 		 * update the hash value for this level before
 		 * validating it.  bno value should be ok since
 		 * it was set when the block was first read in.
 		 */
 		cursor->level[this_level].hashval =
-			be32_to_cpu(node->btree[entry - 1].hashval);
+			be32_to_cpu(btree[entry - 1].hashval);
 
 		/*
 		 * keep track of greatest block # -- that gets
@@ -517,7 +525,7 @@ verify_dir2_path(xfs_mount_t	*mp,
 		/*
 		 * ok, now get the next buffer and check sibling pointers
 		 */
-		dabno = be32_to_cpu(node->hdr.info.forw);
+		dabno = nodehdr.forw;
 		ASSERT(dabno != 0);
 		nex = blkmap_getn(cursor->blkmap, dabno, mp->m_dirblkfsbs,
 			&bmp, &lbmp);
@@ -540,36 +548,37 @@ _("can't read block %u for directory inode %" PRIu64 "\n"),
 		}
 
 		newnode = bp->b_addr;
+		btree = xfs_da3_node_tree_p(newnode);
+		xfs_da3_node_hdr_from_disk(&nodehdr, node);
 		/*
 		 * verify magic number and back pointer, sanity-check
 		 * entry count, verify level
 		 */
 		bad = 0;
-		if (XFS_DA_NODE_MAGIC != be16_to_cpu(newnode->hdr.info.magic)) {
+		if (XFS_DA_NODE_MAGIC != nodehdr.magic) {
 			do_warn(
 _("bad magic number %x in block %u for directory inode %" PRIu64 "\n"),
-				be16_to_cpu(newnode->hdr.info.magic),
+				nodehdr.magic,
 				dabno, cursor->ino);
 			bad++;
 		}
-		if (be32_to_cpu(newnode->hdr.info.back) !=
-					cursor->level[this_level].bno)  {
+		if (nodehdr.back != cursor->level[this_level].bno)  {
 			do_warn(
 _("bad back pointer in block %u for directory inode %" PRIu64 "\n"),
 				dabno, cursor->ino);
 			bad++;
 		}
-		if (be16_to_cpu(newnode->hdr.count) > mp->m_dir_node_ents)  {
+		if (nodehdr.count > mp->m_dir_node_ents)  {
 			do_warn(
 _("entry count %d too large in block %u for directory inode %" PRIu64 "\n"),
-				be16_to_cpu(newnode->hdr.count),
+				nodehdr.count,
 				dabno, cursor->ino);
 			bad++;
 		}
-		if (be16_to_cpu(newnode->hdr.level) != this_level)  {
+		if (nodehdr.level != this_level)  {
 			do_warn(
 _("bad level %d in block %u for directory inode %" PRIu64 "\n"),
-				be16_to_cpu(newnode->hdr.level),
+				nodehdr.level,
 				dabno, cursor->ino);
 			bad++;
 		}
@@ -592,7 +601,7 @@ _("bad level %d in block %u for directory inode %" PRIu64 "\n"),
 		cursor->level[this_level].dirty = 0;
 		cursor->level[this_level].bno = dabno;
 		cursor->level[this_level].hashval =
-			be32_to_cpu(newnode->btree[0].hashval);
+			be32_to_cpu(btree[0].hashval);
 		node = newnode;
 
 		entry = cursor->level[this_level].index = 0;
@@ -600,21 +609,20 @@ _("bad level %d in block %u for directory inode %" PRIu64 "\n"),
 	/*
 	 * ditto for block numbers
 	 */
-	if (cursor->level[p_level].bno !=
-				be32_to_cpu(node->btree[entry].before))
+	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before))
 		return(1);
 	/*
 	 * ok, now validate last hashvalue in the descendant
 	 * block against the hashval in the current entry
 	 */
 	if (cursor->level[p_level].hashval !=
-				be32_to_cpu(node->btree[entry].hashval))  {
+				be32_to_cpu(btree[entry].hashval))  {
 		if (!no_modify)  {
 			do_warn(
 _("correcting bad hashval in interior dir block\n"
   "\tin (level %d) in inode %" PRIu64 ".\n"),
 				this_level, cursor->ino);
-			node->btree[entry].hashval = cpu_to_be32(
+			btree[entry].hashval = cpu_to_be32(
 					cursor->level[p_level].hashval);
 			cursor->level[this_level].dirty++;
 		} else  {
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
