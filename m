Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B0CA47FA7
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23702AC001
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:56 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DLQlgZAvuMb0PBSx for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:53 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004Y6-2M
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-00061t-14
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 18/50] xfs: split out attribute
	fork truncation code into separate file
Date: Mon, 12 Aug 2013 20:49:39 +1000
Message-Id: <1376304611-22994-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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

The attribute inactivation code is not used by userspace, so like
the attribute listing, split it out into a separate file to minimise
the differences between the filesystem shared with libxfs in
userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/Makefile            |   1 +
 fs/xfs/xfs_attr.c          |  71 -------
 fs/xfs/xfs_attr_inactive.c | 454 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_leaf.c     | 352 -----------------------------------
 4 files changed, 455 insertions(+), 423 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_inactive.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 94df3ec..a73af1c 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -27,6 +27,7 @@ xfs-y				+= xfs_trace.o
 
 # highlevel code
 xfs-y				+= xfs_aops.o \
+				   xfs_attr_inactive.o \
 				   xfs_attr_list.o \
 				   xfs_bit.o \
 				   xfs_buf.o \
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index e9fd5ac..6ab77e3 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -610,77 +610,6 @@ xfs_attr_remove(
 	return xfs_attr_remove_int(dp, &xname, flags);
 }
 
-int								/* error */
-xfs_attr_inactive(xfs_inode_t *dp)
-{
-	xfs_trans_t *trans;
-	xfs_mount_t *mp;
-	int error;
-
-	mp = dp->i_mount;
-	ASSERT(! XFS_NOT_DQATTACHED(mp, dp));
-
-	xfs_ilock(dp, XFS_ILOCK_SHARED);
-	if (!xfs_inode_hasattr(dp) ||
-	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
-		xfs_iunlock(dp, XFS_ILOCK_SHARED);
-		return 0;
-	}
-	xfs_iunlock(dp, XFS_ILOCK_SHARED);
-
-	/*
-	 * Start our first transaction of the day.
-	 *
-	 * All future transactions during this code must be "chained" off
-	 * this one via the trans_dup() call.  All transactions will contain
-	 * the inode, and the inode will always be marked with trans_ihold().
-	 * Since the inode will be locked in all transactions, we must log
-	 * the inode in every transaction to let it float upward through
-	 * the log.
-	 */
-	trans = xfs_trans_alloc(mp, XFS_TRANS_ATTRINVAL);
-	if ((error = xfs_trans_reserve(trans, 0, XFS_ATTRINVAL_LOG_RES(mp), 0,
-				      XFS_TRANS_PERM_LOG_RES,
-				      XFS_ATTRINVAL_LOG_COUNT))) {
-		xfs_trans_cancel(trans, 0);
-		return(error);
-	}
-	xfs_ilock(dp, XFS_ILOCK_EXCL);
-
-	/*
-	 * No need to make quota reservations here. We expect to release some
-	 * blocks, not allocate, in the common case.
-	 */
-	xfs_trans_ijoin(trans, dp, 0);
-
-	/*
-	 * Decide on what work routines to call based on the inode size.
-	 */
-	if (!xfs_inode_hasattr(dp) ||
-	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
-		error = 0;
-		goto out;
-	}
-	error = xfs_attr3_root_inactive(&trans, dp);
-	if (error)
-		goto out;
-
-	error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
-	if (error)
-		goto out;
-
-	error = xfs_trans_commit(trans, XFS_TRANS_RELEASE_LOG_RES);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
-	return(error);
-
-out:
-	xfs_trans_cancel(trans, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	return(error);
-}
-
-
 
 /*========================================================================
  * External routines when attribute list is inside the inode
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
new file mode 100644
index 0000000..ace95e7
--- /dev/null
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -0,0 +1,454 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * Copyright (c) 2013 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_alloc.h"
+#include "xfs_btree.h"
+#include "xfs_attr_remote.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_inode_item.h"
+#include "xfs_bmap.h"
+#include "xfs_attr.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_error.h"
+#include "xfs_quota.h"
+#include "xfs_trace.h"
+#include "xfs_trans_priv.h"
+
+/*
+ * Look at all the extents for this logical region,
+ * invalidate any buffers that are incore/in transactions.
+ */
+STATIC int
+xfs_attr3_leaf_freextent(
+	struct xfs_trans	**trans,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		blkno,
+	int			blkcnt)
+{
+	struct xfs_bmbt_irec	map;
+	struct xfs_buf		*bp;
+	xfs_dablk_t		tblkno;
+	xfs_daddr_t		dblkno;
+	int			tblkcnt;
+	int			dblkcnt;
+	int			nmap;
+	int			error;
+
+	/*
+	 * Roll through the "value", invalidating the attribute value's
+	 * blocks.
+	 */
+	tblkno = blkno;
+	tblkcnt = blkcnt;
+	while (tblkcnt > 0) {
+		/*
+		 * Try to remember where we decided to put the value.
+		 */
+		nmap = 1;
+		error = xfs_bmapi_read(dp, (xfs_fileoff_t)tblkno, tblkcnt,
+				       &map, &nmap, XFS_BMAPI_ATTRFORK);
+		if (error) {
+			return(error);
+		}
+		ASSERT(nmap == 1);
+		ASSERT(map.br_startblock != DELAYSTARTBLOCK);
+
+		/*
+		 * If it's a hole, these are already unmapped
+		 * so there's nothing to invalidate.
+		 */
+		if (map.br_startblock != HOLESTARTBLOCK) {
+
+			dblkno = XFS_FSB_TO_DADDR(dp->i_mount,
+						  map.br_startblock);
+			dblkcnt = XFS_FSB_TO_BB(dp->i_mount,
+						map.br_blockcount);
+			bp = xfs_trans_get_buf(*trans,
+					dp->i_mount->m_ddev_targp,
+					dblkno, dblkcnt, 0);
+			if (!bp)
+				return ENOMEM;
+			xfs_trans_binval(*trans, bp);
+			/*
+			 * Roll to next transaction.
+			 */
+			error = xfs_trans_roll(trans, dp);
+			if (error)
+				return (error);
+		}
+
+		tblkno += map.br_blockcount;
+		tblkcnt -= map.br_blockcount;
+	}
+
+	return(0);
+}
+
+/*
+ * Invalidate all of the "remote" value regions pointed to by a particular
+ * leaf block.
+ * Note that we must release the lock on the buffer so that we are not
+ * caught holding something that the logging code wants to flush to disk.
+ */
+STATIC int
+xfs_attr3_leaf_inactive(
+	struct xfs_trans	**trans,
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_attr3_icleaf_hdr ichdr;
+	struct xfs_attr_leaf_entry *entry;
+	struct xfs_attr_leaf_name_remote *name_rmt;
+	struct xfs_attr_inactive_list *list;
+	struct xfs_attr_inactive_list *lp;
+	int			error;
+	int			count;
+	int			size;
+	int			tmp;
+	int			i;
+
+	leaf = bp->b_addr;
+	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
+
+	/*
+	 * Count the number of "remote" value extents.
+	 */
+	count = 0;
+	entry = xfs_attr3_leaf_entryp(leaf);
+	for (i = 0; i < ichdr.count; entry++, i++) {
+		if (be16_to_cpu(entry->nameidx) &&
+		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
+			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+			if (name_rmt->valueblk)
+				count++;
+		}
+	}
+
+	/*
+	 * If there are no "remote" values, we're done.
+	 */
+	if (count == 0) {
+		xfs_trans_brelse(*trans, bp);
+		return 0;
+	}
+
+	/*
+	 * Allocate storage for a list of all the "remote" value extents.
+	 */
+	size = count * sizeof(xfs_attr_inactive_list_t);
+	list = kmem_alloc(size, KM_SLEEP);
+
+	/*
+	 * Identify each of the "remote" value extents.
+	 */
+	lp = list;
+	entry = xfs_attr3_leaf_entryp(leaf);
+	for (i = 0; i < ichdr.count; entry++, i++) {
+		if (be16_to_cpu(entry->nameidx) &&
+		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
+			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+			if (name_rmt->valueblk) {
+				lp->valueblk = be32_to_cpu(name_rmt->valueblk);
+				lp->valuelen = xfs_attr3_rmt_blocks(dp->i_mount,
+						    be32_to_cpu(name_rmt->valuelen));
+				lp++;
+			}
+		}
+	}
+	xfs_trans_brelse(*trans, bp);	/* unlock for trans. in freextent() */
+
+	/*
+	 * Invalidate each of the "remote" value extents.
+	 */
+	error = 0;
+	for (lp = list, i = 0; i < count; i++, lp++) {
+		tmp = xfs_attr3_leaf_freextent(trans, dp,
+				lp->valueblk, lp->valuelen);
+
+		if (error == 0)
+			error = tmp;	/* save only the 1st errno */
+	}
+
+	kmem_free(list);
+	return error;
+}
+
+/*
+ * Recurse (gasp!) through the attribute nodes until we find leaves.
+ * We're doing a depth-first traversal in order to invalidate everything.
+ */
+STATIC int
+xfs_attr3_node_inactive(
+	struct xfs_trans **trans,
+	struct xfs_inode *dp,
+	struct xfs_buf	*bp,
+	int		level)
+{
+	xfs_da_blkinfo_t *info;
+	xfs_da_intnode_t *node;
+	xfs_dablk_t child_fsb;
+	xfs_daddr_t parent_blkno, child_blkno;
+	int error, i;
+	struct xfs_buf *child_bp;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr ichdr;
+
+	/*
+	 * Since this code is recursive (gasp!) we must protect ourselves.
+	 */
+	if (level > XFS_DA_NODE_MAXDEPTH) {
+		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
+		return XFS_ERROR(EIO);
+	}
+
+	node = bp->b_addr;
+	xfs_da3_node_hdr_from_disk(&ichdr, node);
+	parent_blkno = bp->b_bn;
+	if (!ichdr.count) {
+		xfs_trans_brelse(*trans, bp);
+		return 0;
+	}
+	btree = xfs_da3_node_tree_p(node);
+	child_fsb = be32_to_cpu(btree[0].before);
+	xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
+
+	/*
+	 * If this is the node level just above the leaves, simply loop
+	 * over the leaves removing all of them.  If this is higher up
+	 * in the tree, recurse downward.
+	 */
+	for (i = 0; i < ichdr.count; i++) {
+		/*
+		 * Read the subsidiary block to see what we have to work with.
+		 * Don't do this in a transaction.  This is a depth-first
+		 * traversal of the tree so we may deal with many blocks
+		 * before we come back to this one.
+		 */
+		error = xfs_da3_node_read(*trans, dp, child_fsb, -2, &child_bp,
+						XFS_ATTR_FORK);
+		if (error)
+			return(error);
+		if (child_bp) {
+						/* save for re-read later */
+			child_blkno = XFS_BUF_ADDR(child_bp);
+
+			/*
+			 * Invalidate the subtree, however we have to.
+			 */
+			info = child_bp->b_addr;
+			switch (info->magic) {
+			case cpu_to_be16(XFS_DA_NODE_MAGIC):
+			case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+				error = xfs_attr3_node_inactive(trans, dp,
+							child_bp, level + 1);
+				break;
+			case cpu_to_be16(XFS_ATTR_LEAF_MAGIC):
+			case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
+				error = xfs_attr3_leaf_inactive(trans, dp,
+							child_bp);
+				break;
+			default:
+				error = XFS_ERROR(EIO);
+				xfs_trans_brelse(*trans, child_bp);
+				break;
+			}
+			if (error)
+				return error;
+
+			/*
+			 * Remove the subsidiary block from the cache
+			 * and from the log.
+			 */
+			error = xfs_da_get_buf(*trans, dp, 0, child_blkno,
+				&child_bp, XFS_ATTR_FORK);
+			if (error)
+				return error;
+			xfs_trans_binval(*trans, child_bp);
+		}
+
+		/*
+		 * If we're not done, re-read the parent to get the next
+		 * child block number.
+		 */
+		if (i + 1 < ichdr.count) {
+			error = xfs_da3_node_read(*trans, dp, 0, parent_blkno,
+						 &bp, XFS_ATTR_FORK);
+			if (error)
+				return error;
+			child_fsb = be32_to_cpu(btree[i + 1].before);
+			xfs_trans_brelse(*trans, bp);
+		}
+		/*
+		 * Atomically commit the whole invalidate stuff.
+		 */
+		error = xfs_trans_roll(trans, dp);
+		if (error)
+			return  error;
+	}
+
+	return 0;
+}
+
+/*
+ * Indiscriminately delete the entire attribute fork
+ *
+ * Recurse (gasp!) through the attribute nodes until we find leaves.
+ * We're doing a depth-first traversal in order to invalidate everything.
+ */
+int
+xfs_attr3_root_inactive(
+	struct xfs_trans	**trans,
+	struct xfs_inode	*dp)
+{
+	struct xfs_da_blkinfo	*info;
+	struct xfs_buf		*bp;
+	xfs_daddr_t		blkno;
+	int			error;
+
+	/*
+	 * Read block 0 to see what we have to work with.
+	 * We only get here if we have extents, since we remove
+	 * the extents in reverse order the extent containing
+	 * block 0 must still be there.
+	 */
+	error = xfs_da3_node_read(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
+	if (error)
+		return error;
+	blkno = bp->b_bn;
+
+	/*
+	 * Invalidate the tree, even if the "tree" is only a single leaf block.
+	 * This is a depth-first traversal!
+	 */
+	info = bp->b_addr;
+	switch (info->magic) {
+	case cpu_to_be16(XFS_DA_NODE_MAGIC):
+	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+		error = xfs_attr3_node_inactive(trans, dp, bp, 1);
+		break;
+	case cpu_to_be16(XFS_ATTR_LEAF_MAGIC):
+	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
+		error = xfs_attr3_leaf_inactive(trans, dp, bp);
+		break;
+	default:
+		error = XFS_ERROR(EIO);
+		xfs_trans_brelse(*trans, bp);
+		break;
+	}
+	if (error)
+		return error;
+
+	/*
+	 * Invalidate the incore copy of the root block.
+	 */
+	error = xfs_da_get_buf(*trans, dp, 0, blkno, &bp, XFS_ATTR_FORK);
+	if (error)
+		return error;
+	xfs_trans_binval(*trans, bp);	/* remove from cache */
+	/*
+	 * Commit the invalidate and start the next transaction.
+	 */
+	error = xfs_trans_roll(trans, dp);
+
+	return error;
+}
+
+int
+xfs_attr_inactive(xfs_inode_t *dp)
+{
+	xfs_trans_t *trans;
+	xfs_mount_t *mp;
+	int error;
+
+	mp = dp->i_mount;
+	ASSERT(! XFS_NOT_DQATTACHED(mp, dp));
+
+	xfs_ilock(dp, XFS_ILOCK_SHARED);
+	if (!xfs_inode_hasattr(dp) ||
+	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		xfs_iunlock(dp, XFS_ILOCK_SHARED);
+		return 0;
+	}
+	xfs_iunlock(dp, XFS_ILOCK_SHARED);
+
+	/*
+	 * Start our first transaction of the day.
+	 *
+	 * All future transactions during this code must be "chained" off
+	 * this one via the trans_dup() call.  All transactions will contain
+	 * the inode, and the inode will always be marked with trans_ihold().
+	 * Since the inode will be locked in all transactions, we must log
+	 * the inode in every transaction to let it float upward through
+	 * the log.
+	 */
+	trans = xfs_trans_alloc(mp, XFS_TRANS_ATTRINVAL);
+	if ((error = xfs_trans_reserve(trans, 0, XFS_ATTRINVAL_LOG_RES(mp), 0,
+				      XFS_TRANS_PERM_LOG_RES,
+				      XFS_ATTRINVAL_LOG_COUNT))) {
+		xfs_trans_cancel(trans, 0);
+		return(error);
+	}
+	xfs_ilock(dp, XFS_ILOCK_EXCL);
+
+	/*
+	 * No need to make quota reservations here. We expect to release some
+	 * blocks, not allocate, in the common case.
+	 */
+	xfs_trans_ijoin(trans, dp, 0);
+
+	/*
+	 * Decide on what work routines to call based on the inode size.
+	 */
+	if (!xfs_inode_hasattr(dp) ||
+	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		error = 0;
+		goto out;
+	}
+	error = xfs_attr3_root_inactive(&trans, dp);
+	if (error)
+		goto out;
+
+	error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
+	if (error)
+		goto out;
+
+	error = xfs_trans_commit(trans, XFS_TRANS_RELEASE_LOG_RES);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+
+	return(error);
+
+out:
+	xfs_trans_cancel(trans, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	return(error);
+}
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 90c033e..fe0ade9 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -79,16 +79,6 @@ STATIC int xfs_attr3_leaf_figure_balance(xfs_da_state_t *state,
 			int *number_usedbytes_in_blk1);
 
 /*
- * Routines used for shrinking the Btree.
- */
-STATIC int xfs_attr3_node_inactive(xfs_trans_t **trans, xfs_inode_t *dp,
-				  struct xfs_buf *bp, int level);
-STATIC int xfs_attr3_leaf_inactive(xfs_trans_t **trans, xfs_inode_t *dp,
-				  struct xfs_buf *bp);
-STATIC int xfs_attr3_leaf_freextent(xfs_trans_t **trans, xfs_inode_t *dp,
-				   xfs_dablk_t blkno, int blkcnt);
-
-/*
  * Utility routines.
  */
 STATIC void xfs_attr3_leaf_moveents(struct xfs_attr_leafblock *src_leaf,
@@ -2712,345 +2702,3 @@ xfs_attr3_leaf_flipflags(
 
 	return error;
 }
-
-/*========================================================================
- * Indiscriminately delete the entire attribute fork
- *========================================================================*/
-
-/*
- * Recurse (gasp!) through the attribute nodes until we find leaves.
- * We're doing a depth-first traversal in order to invalidate everything.
- */
-int
-xfs_attr3_root_inactive(
-	struct xfs_trans	**trans,
-	struct xfs_inode	*dp)
-{
-	struct xfs_da_blkinfo	*info;
-	struct xfs_buf		*bp;
-	xfs_daddr_t		blkno;
-	int			error;
-
-	/*
-	 * Read block 0 to see what we have to work with.
-	 * We only get here if we have extents, since we remove
-	 * the extents in reverse order the extent containing
-	 * block 0 must still be there.
-	 */
-	error = xfs_da3_node_read(*trans, dp, 0, -1, &bp, XFS_ATTR_FORK);
-	if (error)
-		return error;
-	blkno = bp->b_bn;
-
-	/*
-	 * Invalidate the tree, even if the "tree" is only a single leaf block.
-	 * This is a depth-first traversal!
-	 */
-	info = bp->b_addr;
-	switch (info->magic) {
-	case cpu_to_be16(XFS_DA_NODE_MAGIC):
-	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
-		error = xfs_attr3_node_inactive(trans, dp, bp, 1);
-		break;
-	case cpu_to_be16(XFS_ATTR_LEAF_MAGIC):
-	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
-		error = xfs_attr3_leaf_inactive(trans, dp, bp);
-		break;
-	default:
-		error = XFS_ERROR(EIO);
-		xfs_trans_brelse(*trans, bp);
-		break;
-	}
-	if (error)
-		return error;
-
-	/*
-	 * Invalidate the incore copy of the root block.
-	 */
-	error = xfs_da_get_buf(*trans, dp, 0, blkno, &bp, XFS_ATTR_FORK);
-	if (error)
-		return error;
-	xfs_trans_binval(*trans, bp);	/* remove from cache */
-	/*
-	 * Commit the invalidate and start the next transaction.
-	 */
-	error = xfs_trans_roll(trans, dp);
-
-	return error;
-}
-
-/*
- * Recurse (gasp!) through the attribute nodes until we find leaves.
- * We're doing a depth-first traversal in order to invalidate everything.
- */
-STATIC int
-xfs_attr3_node_inactive(
-	struct xfs_trans **trans,
-	struct xfs_inode *dp,
-	struct xfs_buf	*bp,
-	int		level)
-{
-	xfs_da_blkinfo_t *info;
-	xfs_da_intnode_t *node;
-	xfs_dablk_t child_fsb;
-	xfs_daddr_t parent_blkno, child_blkno;
-	int error, i;
-	struct xfs_buf *child_bp;
-	struct xfs_da_node_entry *btree;
-	struct xfs_da3_icnode_hdr ichdr;
-
-	/*
-	 * Since this code is recursive (gasp!) we must protect ourselves.
-	 */
-	if (level > XFS_DA_NODE_MAXDEPTH) {
-		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
-		return XFS_ERROR(EIO);
-	}
-
-	node = bp->b_addr;
-	xfs_da3_node_hdr_from_disk(&ichdr, node);
-	parent_blkno = bp->b_bn;
-	if (!ichdr.count) {
-		xfs_trans_brelse(*trans, bp);
-		return 0;
-	}
-	btree = xfs_da3_node_tree_p(node);
-	child_fsb = be32_to_cpu(btree[0].before);
-	xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
-
-	/*
-	 * If this is the node level just above the leaves, simply loop
-	 * over the leaves removing all of them.  If this is higher up
-	 * in the tree, recurse downward.
-	 */
-	for (i = 0; i < ichdr.count; i++) {
-		/*
-		 * Read the subsidiary block to see what we have to work with.
-		 * Don't do this in a transaction.  This is a depth-first
-		 * traversal of the tree so we may deal with many blocks
-		 * before we come back to this one.
-		 */
-		error = xfs_da3_node_read(*trans, dp, child_fsb, -2, &child_bp,
-						XFS_ATTR_FORK);
-		if (error)
-			return(error);
-		if (child_bp) {
-						/* save for re-read later */
-			child_blkno = XFS_BUF_ADDR(child_bp);
-
-			/*
-			 * Invalidate the subtree, however we have to.
-			 */
-			info = child_bp->b_addr;
-			switch (info->magic) {
-			case cpu_to_be16(XFS_DA_NODE_MAGIC):
-			case cpu_to_be16(XFS_DA3_NODE_MAGIC):
-				error = xfs_attr3_node_inactive(trans, dp,
-							child_bp, level + 1);
-				break;
-			case cpu_to_be16(XFS_ATTR_LEAF_MAGIC):
-			case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
-				error = xfs_attr3_leaf_inactive(trans, dp,
-							child_bp);
-				break;
-			default:
-				error = XFS_ERROR(EIO);
-				xfs_trans_brelse(*trans, child_bp);
-				break;
-			}
-			if (error)
-				return error;
-
-			/*
-			 * Remove the subsidiary block from the cache
-			 * and from the log.
-			 */
-			error = xfs_da_get_buf(*trans, dp, 0, child_blkno,
-				&child_bp, XFS_ATTR_FORK);
-			if (error)
-				return error;
-			xfs_trans_binval(*trans, child_bp);
-		}
-
-		/*
-		 * If we're not done, re-read the parent to get the next
-		 * child block number.
-		 */
-		if (i + 1 < ichdr.count) {
-			error = xfs_da3_node_read(*trans, dp, 0, parent_blkno,
-						 &bp, XFS_ATTR_FORK);
-			if (error)
-				return error;
-			child_fsb = be32_to_cpu(btree[i + 1].before);
-			xfs_trans_brelse(*trans, bp);
-		}
-		/*
-		 * Atomically commit the whole invalidate stuff.
-		 */
-		error = xfs_trans_roll(trans, dp);
-		if (error)
-			return  error;
-	}
-
-	return 0;
-}
-
-/*
- * Invalidate all of the "remote" value regions pointed to by a particular
- * leaf block.
- * Note that we must release the lock on the buffer so that we are not
- * caught holding something that the logging code wants to flush to disk.
- */
-STATIC int
-xfs_attr3_leaf_inactive(
-	struct xfs_trans	**trans,
-	struct xfs_inode	*dp,
-	struct xfs_buf		*bp)
-{
-	struct xfs_attr_leafblock *leaf;
-	struct xfs_attr3_icleaf_hdr ichdr;
-	struct xfs_attr_leaf_entry *entry;
-	struct xfs_attr_leaf_name_remote *name_rmt;
-	struct xfs_attr_inactive_list *list;
-	struct xfs_attr_inactive_list *lp;
-	int			error;
-	int			count;
-	int			size;
-	int			tmp;
-	int			i;
-
-	leaf = bp->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
-
-	/*
-	 * Count the number of "remote" value extents.
-	 */
-	count = 0;
-	entry = xfs_attr3_leaf_entryp(leaf);
-	for (i = 0; i < ichdr.count; entry++, i++) {
-		if (be16_to_cpu(entry->nameidx) &&
-		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
-			if (name_rmt->valueblk)
-				count++;
-		}
-	}
-
-	/*
-	 * If there are no "remote" values, we're done.
-	 */
-	if (count == 0) {
-		xfs_trans_brelse(*trans, bp);
-		return 0;
-	}
-
-	/*
-	 * Allocate storage for a list of all the "remote" value extents.
-	 */
-	size = count * sizeof(xfs_attr_inactive_list_t);
-	list = kmem_alloc(size, KM_SLEEP);
-
-	/*
-	 * Identify each of the "remote" value extents.
-	 */
-	lp = list;
-	entry = xfs_attr3_leaf_entryp(leaf);
-	for (i = 0; i < ichdr.count; entry++, i++) {
-		if (be16_to_cpu(entry->nameidx) &&
-		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
-			if (name_rmt->valueblk) {
-				lp->valueblk = be32_to_cpu(name_rmt->valueblk);
-				lp->valuelen = xfs_attr3_rmt_blocks(dp->i_mount,
-						    be32_to_cpu(name_rmt->valuelen));
-				lp++;
-			}
-		}
-	}
-	xfs_trans_brelse(*trans, bp);	/* unlock for trans. in freextent() */
-
-	/*
-	 * Invalidate each of the "remote" value extents.
-	 */
-	error = 0;
-	for (lp = list, i = 0; i < count; i++, lp++) {
-		tmp = xfs_attr3_leaf_freextent(trans, dp,
-				lp->valueblk, lp->valuelen);
-
-		if (error == 0)
-			error = tmp;	/* save only the 1st errno */
-	}
-
-	kmem_free(list);
-	return error;
-}
-
-/*
- * Look at all the extents for this logical region,
- * invalidate any buffers that are incore/in transactions.
- */
-STATIC int
-xfs_attr3_leaf_freextent(
-	struct xfs_trans	**trans,
-	struct xfs_inode	*dp,
-	xfs_dablk_t		blkno,
-	int			blkcnt)
-{
-	struct xfs_bmbt_irec	map;
-	struct xfs_buf		*bp;
-	xfs_dablk_t		tblkno;
-	xfs_daddr_t		dblkno;
-	int			tblkcnt;
-	int			dblkcnt;
-	int			nmap;
-	int			error;
-
-	/*
-	 * Roll through the "value", invalidating the attribute value's
-	 * blocks.
-	 */
-	tblkno = blkno;
-	tblkcnt = blkcnt;
-	while (tblkcnt > 0) {
-		/*
-		 * Try to remember where we decided to put the value.
-		 */
-		nmap = 1;
-		error = xfs_bmapi_read(dp, (xfs_fileoff_t)tblkno, tblkcnt,
-				       &map, &nmap, XFS_BMAPI_ATTRFORK);
-		if (error) {
-			return(error);
-		}
-		ASSERT(nmap == 1);
-		ASSERT(map.br_startblock != DELAYSTARTBLOCK);
-
-		/*
-		 * If it's a hole, these are already unmapped
-		 * so there's nothing to invalidate.
-		 */
-		if (map.br_startblock != HOLESTARTBLOCK) {
-
-			dblkno = XFS_FSB_TO_DADDR(dp->i_mount,
-						  map.br_startblock);
-			dblkcnt = XFS_FSB_TO_BB(dp->i_mount,
-						map.br_blockcount);
-			bp = xfs_trans_get_buf(*trans,
-					dp->i_mount->m_ddev_targp,
-					dblkno, dblkcnt, 0);
-			if (!bp)
-				return ENOMEM;
-			xfs_trans_binval(*trans, bp);
-			/*
-			 * Roll to next transaction.
-			 */
-			error = xfs_trans_roll(trans, dp);
-			if (error)
-				return (error);
-		}
-
-		tblkno += map.br_blockcount;
-		tblkcnt -= map.br_blockcount;
-	}
-
-	return(0);
-}
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
