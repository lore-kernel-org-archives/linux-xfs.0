Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E4A529E38
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 00:12:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27531AC005
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 22:12:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	aP0gwbqqZVOwRImH for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 22:12:50 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UNFzR-0000Lz-Ln
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:12:05 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UNFzH-0005Bw-Fa
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:11:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/22] xfs: add CRCs to dir2/da node blocks
Date: Wed,  3 Apr 2013 16:11:25 +1100
Message-Id: <1364965892-19623-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1364965892-19623-1-git-send-email-david@fromorbit.com>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_attr.c      |   33 +-
 fs/xfs/xfs_attr_leaf.c |   29 +-
 fs/xfs/xfs_bmap.c      |    1 +
 fs/xfs/xfs_da_btree.c  | 1395 +++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_da_btree.h  |  106 +++-
 fs/xfs/xfs_dir2_node.c |   26 +-
 fs/xfs/xfs_trace.c     |    2 +-
 7 files changed, 972 insertions(+), 620 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 8886838..e03128c 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -15,7 +15,6 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
@@ -25,6 +24,7 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
+#include "xfs_error.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_attr_sf.h"
@@ -35,7 +35,6 @@
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
-#include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_vnodeops.h"
@@ -1236,7 +1235,7 @@ restart:
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	error = xfs_da_node_lookup_int(state, &retval);
+	error = xfs_da3_node_lookup_int(state, &retval);
 	if (error)
 		goto out;
 	blk = &state->path.blk[ state->path.active-1 ];
@@ -1307,7 +1306,7 @@ restart:
 		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
 		 */
 		xfs_bmap_init(args->flist, args->firstblock);
-		error = xfs_da_split(state);
+		error = xfs_da3_split(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
 						&committed);
@@ -1329,7 +1328,7 @@ restart:
 		/*
 		 * Addition succeeded, update Btree hashvals.
 		 */
-		xfs_da_fixhashpath(state, &state->path);
+		xfs_da3_fixhashpath(state, &state->path);
 	}
 
 	/*
@@ -1400,7 +1399,7 @@ restart:
 		state->blocksize = state->mp->m_sb.sb_blocksize;
 		state->node_ents = state->mp->m_attr_node_ents;
 		state->inleaf = 0;
-		error = xfs_da_node_lookup_int(state, &retval);
+		error = xfs_da3_node_lookup_int(state, &retval);
 		if (error)
 			goto out;
 
@@ -1410,14 +1409,14 @@ restart:
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
@@ -1495,7 +1494,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
-	error = xfs_da_node_lookup_int(state, &retval);
+	error = xfs_da3_node_lookup_int(state, &retval);
 	if (error || (retval != EEXIST)) {
 		if (error == 0)
 			error = retval;
@@ -1546,14 +1545,14 @@ xfs_attr_node_removename(xfs_da_args_t *args)
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
@@ -1699,7 +1698,7 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->disk_blkno) {
-			error = xfs_da_node_read(state->args->trans,
+			error = xfs_da3_node_read(state->args->trans,
 						state->args->dp,
 						blk->blkno, blk->disk_blkno,
 						&blk->bp, XFS_ATTR_FORK);
@@ -1718,7 +1717,7 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
 		if (blk->disk_blkno) {
-			error = xfs_da_node_read(state->args->trans,
+			error = xfs_da3_node_read(state->args->trans,
 						state->args->dp,
 						blk->blkno, blk->disk_blkno,
 						&blk->bp, XFS_ATTR_FORK);
@@ -1758,7 +1757,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
-	error = xfs_da_node_lookup_int(state, &retval);
+	error = xfs_da3_node_lookup_int(state, &retval);
 	if (error) {
 		retval = error;
 	} else if (retval == EEXIST) {
@@ -1810,7 +1809,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	 */
 	bp = NULL;
 	if (cursor->blkno > 0) {
-		error = xfs_da_node_read(NULL, context->dp, cursor->blkno, -1,
+		error = xfs_da3_node_read(NULL, context->dp, cursor->blkno, -1,
 					      &bp, XFS_ATTR_FORK);
 		if ((error != 0) && (error != EFSCORRUPTED))
 			return(error);
@@ -1852,7 +1851,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 	if (bp == NULL) {
 		cursor->blkno = 0;
 		for (;;) {
-			error = xfs_da_node_read(NULL, context->dp,
+			error = xfs_da3_node_read(NULL, context->dp,
 						      cursor->blkno, -1, &bp,
 						      XFS_ATTR_FORK);
 			if (error)
@@ -1870,7 +1869,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 				xfs_trans_brelse(NULL, bp);
 				return(XFS_ERROR(EFSCORRUPTED));
 			}
-			btree = node->btree;
+			btree = xfs_da3_node_tree_p(node);
 			for (i = 0; i < be16_to_cpu(node->hdr.count);
 								btree++, i++) {
 				if (cursor->hashval
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index aa4765f..54b0dc8 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -910,6 +910,7 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
 	struct xfs_buf *bp1, *bp2;
 	xfs_dablk_t blkno;
 	int error;
+	struct xfs_da_node_entry *btree;
 
 	trace_xfs_attr_leaf_to_node(args);
 
@@ -935,16 +936,16 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
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
@@ -1032,7 +1033,7 @@ xfs_attr_leaf_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	 * NOTE: rebalance() currently depends on the 2nd block being empty.
 	 */
 	xfs_attr_leaf_rebalance(state, oldblk, newblk);
-	error = xfs_da_blk_link(state, oldblk, newblk);
+	error = xfs_da3_blk_link(state, oldblk, newblk);
 	if (error)
 		return(error);
 
@@ -1660,7 +1661,7 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
 		 */
 		forward = (info->forw != 0);
 		memcpy(&state->altpath, &state->path, sizeof(state->path));
-		error = xfs_da_path_shift(state, &state->altpath, forward,
+		error = xfs_da3_path_shift(state, &state->altpath, forward,
 						 0, &retval);
 		if (error)
 			return(error);
@@ -1717,10 +1718,10 @@ xfs_attr_leaf_toosmall(xfs_da_state_t *state, int *action)
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
@@ -2783,7 +2784,7 @@ xfs_attr_root_inactive(xfs_trans_t **trans, xfs_inode_t *dp)
 	 * the extents in reverse order the extent containing
 	 * block 0 must still be there.
 	 */
-	error = xfs_da_node_read(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
+	error = xfs_da3_node_read(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
 	if (error)
 		return(error);
 	blkno = XFS_BUF_ADDR(bp);
@@ -2836,6 +2837,7 @@ xfs_attr_node_inactive(
 	xfs_daddr_t parent_blkno, child_blkno;
 	int error, count, i;
 	struct xfs_buf *child_bp;
+	struct xfs_da_node_entry *btree;
 
 	/*
 	 * Since this code is recursive (gasp!) we must protect ourselves.
@@ -2853,7 +2855,8 @@ xfs_attr_node_inactive(
 		xfs_trans_brelse(*trans, bp);
 		return(0);
 	}
-	child_fsb = be32_to_cpu(node->btree[0].before);
+	btree = xfs_da3_node_tree_p(node);
+	child_fsb = be32_to_cpu(btree[0].before);
 	xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 
 	/*
@@ -2868,7 +2871,7 @@ xfs_attr_node_inactive(
 		 * traversal of the tree so we may deal with many blocks
 		 * before we come back to this one.
 		 */
-		error = xfs_da_node_read(*trans, dp, child_fsb, -2, &child_bp,
+		error = xfs_da3_node_read(*trans, dp, child_fsb, -2, &child_bp,
 						XFS_ATTR_FORK);
 		if (error)
 			return(error);
@@ -2909,11 +2912,11 @@ xfs_attr_node_inactive(
 		 * child block number.
 		 */
 		if ((i+1) < count) {
-			error = xfs_da_node_read(*trans, dp, 0, parent_blkno,
+			error = xfs_da3_node_read(*trans, dp, 0, parent_blkno,
 						 &bp, XFS_ATTR_FORK);
 			if (error)
 				return(error);
-			child_fsb = be32_to_cpu(node->btree[i+1].before);
+			child_fsb = be32_to_cpu(btree[i+1].before);
 			xfs_trans_brelse(*trans, bp);
 		}
 		/*
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 0fcb7f4..2844724 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -25,6 +25,7 @@
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
+#include "xfs_mount.h"
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 2f23b14..2274994 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -38,6 +39,8 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_buf_item.h"
 
 /*
  * xfs_da_btree.c
@@ -52,69 +55,195 @@
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
@@ -124,16 +253,22 @@ xfs_da_node_write_verify(
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
@@ -144,21 +279,22 @@ xfs_da_node_read_verify(
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
@@ -167,7 +303,7 @@ xfs_da_node_read(
 	int			which_fork)
 {
 	return xfs_da_read_buf(tp, dp, bno, mappedbno, bpp,
-					which_fork, &xfs_da_node_buf_ops);
+					which_fork, &xfs_da3_node_buf_ops);
 }
 
 /*========================================================================
@@ -178,33 +314,45 @@ xfs_da_node_read(
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
@@ -214,12 +362,18 @@ xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,
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
 
@@ -281,7 +435,7 @@ xfs_da_split(xfs_da_state_t *state)
 			addblk = newblk;
 			break;
 		case XFS_DA_NODE_MAGIC:
-			error = xfs_da_node_split(state, oldblk, newblk, addblk,
+			error = xfs_da3_node_split(state, oldblk, newblk, addblk,
 							 max - i, &action);
 			addblk->bp = NULL;
 			if (error)
@@ -299,7 +453,7 @@ xfs_da_split(xfs_da_state_t *state)
 		/*
 		 * Update the btree to show the new hashval for this child.
 		 */
-		xfs_da_fixhashpath(state, &state->path);
+		xfs_da3_fixhashpath(state, &state->path);
 	}
 	if (!addblk)
 		return(0);
@@ -309,7 +463,7 @@ xfs_da_split(xfs_da_state_t *state)
 	 */
 	ASSERT(state->path.active == 0);
 	oldblk = &state->path.blk[0];
-	error = xfs_da_root_split(state, oldblk, addblk);
+	error = xfs_da3_root_split(state, oldblk, addblk);
 	if (error) {
 		addblk->bp = NULL;
 		return(error);	/* GROT: dir is inconsistent */
@@ -320,8 +474,10 @@ xfs_da_split(xfs_da_state_t *state)
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
@@ -360,18 +516,25 @@ xfs_da_split(xfs_da_state_t *state)
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
 
@@ -380,22 +543,26 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
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
@@ -407,9 +574,22 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
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
@@ -419,17 +599,21 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
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
@@ -443,30 +627,34 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 
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
@@ -476,7 +664,7 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	/*
 	 * Do we have to split the node?
 	 */
-	if ((be16_to_cpu(node->hdr.count) + newcount) > state->node_ents) {
+	if (nodehdr.count + newcount > state->node_ents) {
 		/*
 		 * Allocate a new node, add to the doubly linked chain of
 		 * nodes, then move some of our excess entries into it.
@@ -485,14 +673,14 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
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
@@ -504,7 +692,7 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	 * Insert the new entry(s) into the correct block
 	 * (updating last hashval in the process).
 	 *
-	 * xfs_da_node_add() inserts BEFORE the given index,
+	 * xfs_da3_node_add() inserts BEFORE the given index,
 	 * and as a result of using node_lookup_int() we always
 	 * point to a valid entry (not after one), but a split
 	 * operation always results in a new block whose hashvals
@@ -513,22 +701,23 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
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
@@ -543,33 +732,53 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
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
@@ -580,10 +789,11 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
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
 
@@ -591,12 +801,12 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
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
@@ -604,49 +814,60 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
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
 
@@ -654,18 +875,23 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
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
@@ -675,23 +901,25 @@ xfs_da_node_add(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
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
@@ -703,14 +931,16 @@ xfs_da_node_add(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
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
@@ -751,18 +981,18 @@ xfs_da_join(xfs_da_state_t *state)
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
@@ -777,9 +1007,9 @@ xfs_da_join(xfs_da_state_t *state)
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
 
@@ -793,8 +1023,10 @@ xfs_da_blkinfo_onlychild_validate(struct xfs_da_blkinfo *blkinfo, __u16 level)
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
@@ -807,52 +1039,60 @@ xfs_da_blkinfo_onlychild_validate(struct xfs_da_blkinfo *blkinfo, __u16 level)
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
@@ -868,14 +1108,21 @@ xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
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
 
@@ -886,10 +1133,9 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
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
@@ -900,14 +1146,14 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
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
@@ -926,35 +1172,34 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
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
@@ -963,28 +1208,42 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
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
@@ -992,13 +1251,16 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
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
 
@@ -1016,23 +1278,26 @@ xfs_da_fixhashpath(xfs_da_state_t *state, xfs_da_state_path_t *path)
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
 
@@ -1040,104 +1305,119 @@ xfs_da_fixhashpath(xfs_da_state_t *state, xfs_da_state_path_t *path)
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
@@ -1156,16 +1436,24 @@ xfs_da_node_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
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
 
@@ -1181,7 +1469,7 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
 		 * Read the next node down in the tree.
 		 */
 		blk->blkno = blkno;
-		error = xfs_da_node_read(args->trans, args->dp, blkno,
+		error = xfs_da3_node_read(args->trans, args->dp, blkno,
 					-1, &blk->bp, args->whichfork);
 		if (error) {
 			blk->blkno = 0;
@@ -1190,66 +1478,73 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
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
 
@@ -1273,7 +1568,7 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
 		}
 		if (((retval == ENOENT) || (retval == ENOATTR)) &&
 		    (blk->hashval == args->hashval)) {
-			error = xfs_da_path_shift(state, &state->path, 1, 1,
+			error = xfs_da3_path_shift(state, &state->path, 1, 1,
 							 &retval);
 			if (error)
 				return(error);
@@ -1295,16 +1590,52 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
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
@@ -1316,9 +1647,6 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 	ASSERT(old_blk->magic == XFS_DA_NODE_MAGIC ||
 	       old_blk->magic == XFS_DIR2_LEAFN_MAGIC ||
 	       old_blk->magic == XFS_ATTR_LEAF_MAGIC);
-	ASSERT(old_blk->magic == be16_to_cpu(old_info->magic));
-	ASSERT(new_blk->magic == be16_to_cpu(new_info->magic));
-	ASSERT(old_blk->magic == new_blk->magic);
 
 	switch (old_blk->magic) {
 	case XFS_ATTR_LEAF_MAGIC:
@@ -1328,7 +1656,7 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 		before = xfs_dir2_leafn_order(old_blk->bp, new_blk->bp);
 		break;
 	case XFS_DA_NODE_MAGIC:
-		before = xfs_da_node_order(old_blk->bp, new_blk->bp);
+		before = xfs_da3_node_order(old_blk->bp, new_blk->bp);
 		break;
 	}
 
@@ -1343,14 +1671,14 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
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
@@ -1364,7 +1692,7 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
 		new_info->forw = old_info->forw;
 		new_info->back = cpu_to_be32(old_blk->blkno);
 		if (old_info->forw) {
-			error = xfs_da_node_read(args->trans, args->dp,
+			error = xfs_da3_node_read(args->trans, args->dp,
 						be32_to_cpu(old_info->forw),
 						-1, &bp, args->whichfork);
 			if (error)
@@ -1385,59 +1713,20 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
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
@@ -1449,8 +1738,6 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 	ASSERT(save_blk->magic == XFS_DA_NODE_MAGIC ||
 	       save_blk->magic == XFS_DIR2_LEAFN_MAGIC ||
 	       save_blk->magic == XFS_ATTR_LEAF_MAGIC);
-	ASSERT(save_blk->magic == be16_to_cpu(save_info->magic));
-	ASSERT(drop_blk->magic == be16_to_cpu(drop_info->magic));
 	ASSERT(save_blk->magic == drop_blk->magic);
 	ASSERT((be32_to_cpu(save_info->forw) == drop_blk->blkno) ||
 	       (be32_to_cpu(save_info->back) == drop_blk->blkno));
@@ -1464,7 +1751,7 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 		trace_xfs_da_unlink_back(args);
 		save_info->back = drop_info->back;
 		if (drop_info->back) {
-			error = xfs_da_node_read(args->trans, args->dp,
+			error = xfs_da3_node_read(args->trans, args->dp,
 						be32_to_cpu(drop_info->back),
 						-1, &bp, args->whichfork);
 			if (error)
@@ -1481,7 +1768,7 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 		trace_xfs_da_unlink_forward(args);
 		save_info->forw = drop_info->forw;
 		if (drop_info->forw) {
-			error = xfs_da_node_read(args->trans, args->dp,
+			error = xfs_da3_node_read(args->trans, args->dp,
 						be32_to_cpu(drop_info->forw),
 						-1, &bp, args->whichfork);
 			if (error)
@@ -1509,15 +1796,22 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
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
 
@@ -1532,16 +1826,17 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
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
@@ -1567,47 +1862,58 @@ xfs_da_path_shift(xfs_da_state_t *state, xfs_da_state_path_t *path,
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
 
 
@@ -1794,22 +2100,36 @@ xfs_da_grow_inode(
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
 
@@ -1833,7 +2153,7 @@ xfs_da_swap_lastblock(
 	 * Read the last block in the btree space.
 	 */
 	last_blkno = (xfs_dablk_t)lastoff - mp->m_dirblkfsbs;
-	error = xfs_da_node_read(tp, ip, last_blkno, -1, &last_buf, w);
+	error = xfs_da3_node_read(tp, ip, last_blkno, -1, &last_buf, w);
 	if (error)
 		return error;
 	/*
@@ -1856,17 +2176,22 @@ xfs_da_swap_lastblock(
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
@@ -1888,7 +2213,7 @@ xfs_da_swap_lastblock(
 	 * If the moved block has a right sibling, fix up the pointers.
 	 */
 	if ((sib_blkno = be32_to_cpu(dead_info->forw))) {
-		error = xfs_da_node_read(tp, ip, sib_blkno, -1, &sib_buf, w);
+		error = xfs_da3_node_read(tp, ip, sib_blkno, -1, &sib_buf, w);
 		if (error)
 			goto done;
 		sib_info = sib_buf->b_addr;
@@ -1912,31 +2237,31 @@ xfs_da_swap_lastblock(
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
@@ -1948,13 +2273,13 @@ xfs_da_swap_lastblock(
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
@@ -1963,27 +2288,27 @@ xfs_da_swap_lastblock(
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
@@ -2025,14 +2350,15 @@ xfs_da_shrink_inode(
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
@@ -2297,6 +2623,7 @@ xfs_da_read_buf(
 		magic1 = be32_to_cpu(hdr->magic);
 		if (unlikely(
 		    XFS_TEST_ERROR((magic != XFS_DA_NODE_MAGIC) &&
+				   (magic != XFS_DA3_NODE_MAGIC) &&
 				   (magic != XFS_ATTR_LEAF_MAGIC) &&
 				   (magic != XFS_DIR2_LEAF1_MAGIC) &&
 				   (magic != XFS_DIR3_LEAF1_MAGIC) &&
@@ -2367,41 +2694,3 @@ out_free:
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
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 0854b95..6bedb3c 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
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
 
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index e9421cb..876991f 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1367,7 +1367,7 @@ xfs_dir2_leafn_split(
 	 * block into the leaves.
 	 */
 	xfs_dir2_leafn_rebalance(state, oldblk, newblk);
-	error = xfs_da_blk_link(state, oldblk, newblk);
+	error = xfs_da3_blk_link(state, oldblk, newblk);
 	if (error) {
 		return error;
 	}
@@ -1449,7 +1449,7 @@ xfs_dir2_leafn_toosmall(
 		 */
 		forward = (leafhdr.forw != 0);
 		memcpy(&state->altpath, &state->path, sizeof(state->path));
-		error = xfs_da_path_shift(state, &state->altpath, forward, 0,
+		error = xfs_da3_path_shift(state, &state->altpath, forward, 0,
 			&rval);
 		if (error)
 			return error;
@@ -1511,10 +1511,10 @@ xfs_dir2_leafn_toosmall(
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
@@ -1610,7 +1610,7 @@ xfs_dir2_node_addname(
 	 * Look up the name.  We're not supposed to find it, but
 	 * this gives us the insertion point.
 	 */
-	error = xfs_da_node_lookup_int(state, &rval);
+	error = xfs_da3_node_lookup_int(state, &rval);
 	if (error)
 		rval = error;
 	if (rval != ENOENT) {
@@ -1636,7 +1636,7 @@ xfs_dir2_node_addname(
 		 * It worked, fix the hash values up the btree.
 		 */
 		if (!(args->op_flags & XFS_DA_OP_JUSTCHECK))
-			xfs_da_fixhashpath(state, &state->path);
+			xfs_da3_fixhashpath(state, &state->path);
 	} else {
 		/*
 		 * It didn't work, we need to split the leaf block.
@@ -1648,7 +1648,7 @@ xfs_dir2_node_addname(
 		/*
 		 * Split the leaf block and insert the new entry.
 		 */
-		rval = xfs_da_split(state);
+		rval = xfs_da3_split(state);
 	}
 done:
 	xfs_da_state_free(state);
@@ -2026,7 +2026,7 @@ xfs_dir2_node_addname_int(
 
 /*
  * Lookup an entry in a node-format directory.
- * All the real work happens in xfs_da_node_lookup_int.
+ * All the real work happens in xfs_da3_node_lookup_int.
  * The only real output is the inode number of the entry.
  */
 int						/* error */
@@ -2051,7 +2051,7 @@ xfs_dir2_node_lookup(
 	/*
 	 * Fill in the path to the entry in the cursor.
 	 */
-	error = xfs_da_node_lookup_int(state, &rval);
+	error = xfs_da3_node_lookup_int(state, &rval);
 	if (error)
 		rval = error;
 	else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE) {
@@ -2106,7 +2106,7 @@ xfs_dir2_node_removename(
 	/*
 	 * Look up the entry we're deleting, set up the cursor.
 	 */
-	error = xfs_da_node_lookup_int(state, &rval);
+	error = xfs_da3_node_lookup_int(state, &rval);
 	if (error)
 		rval = error;
 	/*
@@ -2130,12 +2130,12 @@ xfs_dir2_node_removename(
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
@@ -2177,7 +2177,7 @@ xfs_dir2_node_replace(
 	/*
 	 * Lookup the entry to change in the btree.
 	 */
-	error = xfs_da_node_lookup_int(state, &rval);
+	error = xfs_da3_node_lookup_int(state, &rval);
 	if (error) {
 		rval = error;
 	}
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 624bedd..b6e3897 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -22,7 +22,6 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
-#include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
@@ -30,6 +29,7 @@
 #include "xfs_inode.h"
 #include "xfs_btree.h"
 #include "xfs_mount.h"
+#include "xfs_da_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_itable.h"
 #include "xfs_alloc.h"
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
