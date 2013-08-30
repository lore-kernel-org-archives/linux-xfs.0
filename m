Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 887307F3F
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 19:24:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 78620304048
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 17:24:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9r6Qh8YeSgqJCFpc for <xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 17:24:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VFCVA-0000wV-WB
	for xfs@oss.sgi.com; Fri, 30 Aug 2013 10:23:49 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VFCVA-0004bG-VZ
	for xfs@oss.sgi.com; Fri, 30 Aug 2013 10:23:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: swap extents operations for CRC filesystems
Date: Fri, 30 Aug 2013 10:23:44 +1000
Message-Id: <1377822225-17621-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1377822225-17621-1-git-send-email-david@fromorbit.com>
References: <1377822225-17621-1-git-send-email-david@fromorbit.com>
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

For CRC enabled filesystems, we can't just swap inode forks from one
inode to another when defragmenting a file - the blocks in the inode
fork bmap btree contain pointers back to the owner inode. Hence if
we are to swap the inode forks we have to atomically modify every
block in the btree during the transaction.

We are doing an entire fork swap here, so we could create a new
transaction item type that indicates we are changing the owner of a
certain structure from one value to another. If we combine this with
ordered buffer logging to modify all the buffers in the tree, then
we can change the buffers in the tree without needing log space for
the operation. However, this then requires log recovery to perform
the modification of the owner information of the objects/structures
in question.

This does introduce some interesting ordering details into recovery:
we have to make sure that the owner change replay occurs after the
change that moves the objects is made, not before. Hence we can't
use a separate log item for this as we have no guarantee of strict
ordering between multiple items in the log due to the relogging
action of asynchronous transaction commits. Hence there is no
"generic" method we can use for changing the ownership of arbitrary
metadata structures.

For inode forks, however, there is a simple method of communicating
that the fork contents need the owner rewritten - we can pass a
inode log format flag for the fork for the transaction that does a
fork swap. This flag will then follow the inode fork through
relogging actions so when the swap actually gets replayed the
ownership can be changed immediately by log recovery.  So that gives
us a simple method of "whole fork" exchange between two inodes.

This is relatively simple to implement, so it makes sense to do this
as an initial implementation to support xfs_fsr on CRC enabled
filesytems in the same manner as we do on existing filesystems. This
commit introduces the swapext driven functionality, the recovery
functionality will be in a separate patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_btree.c |  34 ++++++++++
 fs/xfs/xfs_bmap_btree.h |   3 +
 fs/xfs/xfs_bmap_util.c  |  52 +++++++++++-----
 fs/xfs/xfs_btree.c      | 162 ++++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_btree.h      |  18 +++---
 fs/xfs/xfs_log_format.h |   1 +
 6 files changed, 231 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index cf3bc76..aa2eadd 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -925,3 +925,37 @@ xfs_bmdr_maxrecs(
 		return blocklen / sizeof(xfs_bmdr_rec_t);
 	return blocklen / (sizeof(xfs_bmdr_key_t) + sizeof(xfs_bmdr_ptr_t));
 }
+
+/*
+ * Change the owner of a btree format fork fo the inode passed in. Change it to
+ * the owner of that is passed in so that we can change owners before or after
+ * we switch forks between inodes. The operation that the caller is doing will
+ * determine whether is needs to change owner before or after the switch.
+ *
+ * For demand paged modification, the fork switch should be done after reading
+ * in all the blocks, modifying them and pinning them in the transaction. For
+ * modification when the buffers are already pinned in memory, the fork switch
+ * can be done before changing the owner as we won't need to validate the owner
+ * until the btree buffers are unpinned and writes can occur again.
+ */
+int
+xfs_bmbt_change_owner(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	xfs_ino_t		new_owner)
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	if (whichfork == XFS_DATA_FORK)
+		ASSERT(ip->i_d.di_format = XFS_DINODE_FMT_BTREE);
+	else
+		ASSERT(ip->i_d.di_aformat = XFS_DINODE_FMT_BTREE);
+
+	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
+	error = xfs_btree_change_owner(cur, new_owner);
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	return error;
+}
+
diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index 1b726d6..bceac7a 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -236,6 +236,9 @@ extern int xfs_bmbt_get_maxrecs(struct xfs_btree_cur *, int level);
 extern int xfs_bmdr_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 extern int xfs_bmbt_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 
+extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
+				 int whichfork, xfs_ino_t new_owner);
+
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 541d59f..ad8a91d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1789,14 +1789,6 @@ xfs_swap_extents(
 	int		taforkblks = 0;
 	__uint64_t	tmp;
 
-	/*
-	 * We have no way of updating owner information in the BMBT blocks for
-	 * each inode on CRC enabled filesystems, so to avoid corrupting the
-	 * this metadata we simply don't allow extent swaps to occur.
-	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		return XFS_ERROR(EINVAL);
-
 	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
 	if (!tempifp) {
 		error = XFS_ERROR(ENOMEM);
@@ -1920,6 +1912,40 @@ xfs_swap_extents(
 			goto out_trans_cancel;
 	}
 
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_trans_ijoin(tp, tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+
+	/*
+	 * Before we've swapped the forks, lets set the owners of the forks
+	 * appropriately. We have to do this as we are demand paging the btree
+	 * buffers, and so the validation done on read will expect the owner
+	 * field to be correctly set. Once we change the owners, we can swap the
+	 * inode forks.
+	 *
+	 * Note the trickiness in setting the log flags - we set the owner log
+	 * flag on the opposite inode (i.e. the inode we are setting the new
+	 * owner to be) because once we swap the forks and log that, log
+	 * recovery is going to see the fork as owned by the swapped inode,
+	 * not the pre-swapped inodes.
+	 */
+	src_log_flags = XFS_ILOG_CORE;
+	target_log_flags = XFS_ILOG_CORE;
+	if (ip->i_d.di_version == 3 &&
+	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
+		target_log_flags |= XFS_ILOG_OWNER;
+		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK, tip->i_ino);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	if (tip->i_d.di_version == 3 &&
+	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
+		src_log_flags |= XFS_ILOG_OWNER;
+		error = xfs_bmbt_change_owner(tp, tip, XFS_DATA_FORK, ip->i_ino);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * Swap the data forks of the inodes
 	 */
@@ -1957,7 +1983,6 @@ xfs_swap_extents(
 	tip->i_delayed_blks = ip->i_delayed_blks;
 	ip->i_delayed_blks = 0;
 
-	src_log_flags = XFS_ILOG_CORE;
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		/* If the extents fit in the inode, fix the
@@ -1971,11 +1996,12 @@ xfs_swap_extents(
 		src_log_flags |= XFS_ILOG_DEXT;
 		break;
 	case XFS_DINODE_FMT_BTREE:
+		ASSERT(ip->i_d.di_version < 3 ||
+		       (src_log_flags & XFS_ILOG_OWNER));
 		src_log_flags |= XFS_ILOG_DBROOT;
 		break;
 	}
 
-	target_log_flags = XFS_ILOG_CORE;
 	switch (tip->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		/* If the extents fit in the inode, fix the
@@ -1990,13 +2016,11 @@ xfs_swap_extents(
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		target_log_flags |= XFS_ILOG_DBROOT;
+		ASSERT(tip->i_d.di_version < 3 ||
+		       (target_log_flags & XFS_ILOG_OWNER));
 		break;
 	}
 
-
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_trans_ijoin(tp, tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-
 	xfs_trans_log_inode(tp, ip,  src_log_flags);
 	xfs_trans_log_inode(tp, tip, target_log_flags);
 
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 7a2b4da..047573f 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -855,6 +855,41 @@ xfs_btree_readahead(
 	return xfs_btree_readahead_sblock(cur, lr, block);
 }
 
+STATIC xfs_daddr_t
+xfs_btree_ptr_to_daddr(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		ASSERT(ptr->l != cpu_to_be64(NULLDFSBNO));
+
+		return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
+	} else {
+		ASSERT(cur->bc_private.a.agno != NULLAGNUMBER);
+		ASSERT(ptr->s != cpu_to_be32(NULLAGBLOCK));
+
+		return XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
+					be32_to_cpu(ptr->s));
+	}
+}
+
+/*
+ * Readahead @count btree blocks at the given @ptr location.
+ *
+ * We don't need to care about long or short form btrees here as we have a
+ * method of converting the ptr directly to a daddr available to us.
+ */
+STATIC void
+xfs_btree_readahead_ptr(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	xfs_extlen_t		count)
+{
+	xfs_buf_readahead(cur->bc_mp->m_ddev_targp,
+			  xfs_btree_ptr_to_daddr(cur, ptr),
+			  cur->bc_mp->m_bsize * count, cur->bc_ops->buf_ops);
+}
+
 /*
  * Set the buffer for level "lev" in the cursor to bp, releasing
  * any previous buffer.
@@ -1073,24 +1108,6 @@ xfs_btree_buf_to_ptr(
 	}
 }
 
-STATIC xfs_daddr_t
-xfs_btree_ptr_to_daddr(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr)
-{
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		ASSERT(ptr->l != cpu_to_be64(NULLDFSBNO));
-
-		return XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
-	} else {
-		ASSERT(cur->bc_private.a.agno != NULLAGNUMBER);
-		ASSERT(ptr->s != cpu_to_be32(NULLAGBLOCK));
-
-		return XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno,
-					be32_to_cpu(ptr->s));
-	}
-}
-
 STATIC void
 xfs_btree_set_refs(
 	struct xfs_btree_cur	*cur,
@@ -3869,3 +3886,112 @@ xfs_btree_get_rec(
 	*stat = 1;
 	return 0;
 }
+
+/*
+ * Change the owner of a btree.
+ *
+ * The mechanism we use here is ordered buffer logging. Because we don't know
+ * how many buffers were are going to need to modify, we don't really want to
+ * have to make transaction reservations for the worst case of every buffer in a
+ * full size btree as that may be more space that we can fit in the log....
+ *
+ * We do the btree walk in the most optimal manner possible - we have sibling
+ * pointers so we can just walk all the blocks on each level from left to right
+ * in a single pass, and then move to the next level and do the same. We can
+ * also do readahead on the sibling pointers to get IO moving more quickly,
+ * though for slow disks this is unlikely to make much difference to performance
+ * as the amount of CPU work we have to do before moving to the next block is
+ * relatively small.
+ *
+ * For each btree block that we load, modify the owner appropriately, set the
+ * buffer as an ordered buffer and log it appropriately. We need to ensure that
+ * we mark the region we change dirty so that if the buffer is relogged in
+ * a subsequent transaction the changes we make here as an ordered buffer are
+ * correctly relogged in that transaction.
+ */
+static int
+xfs_btree_block_change_owner(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	__uint64_t		new_owner)
+{
+	struct xfs_btree_block	*block;
+	struct xfs_buf		*bp;
+	union xfs_btree_ptr     rptr;
+
+	/* do right sibling readahead */
+	xfs_btree_readahead(cur, level, XFS_BTCUR_RIGHTRA);
+
+	/* modify the owner */
+	block = xfs_btree_get_block(cur, level, &bp);
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		block->bb_u.l.bb_owner = cpu_to_be64(new_owner);
+	else
+		block->bb_u.s.bb_owner = cpu_to_be32(new_owner);
+
+	/*
+	 * Log owner change as an ordered buffer. If the block is a root block
+	 * hosted in an inode, we might not have a buffer pointer here and we
+	 * shouldn't attempt to log the change as the information is already
+	 * held in the inode and discarded when the root block is formatted into
+	 * the on-disk inode fork. We still change it, though, so everything is
+	 * consistent in memory.
+	 */
+	if (bp) {
+		xfs_trans_ordered_buf(cur->bc_tp, bp);
+		xfs_btree_log_block(cur, bp, XFS_BB_OWNER);
+	} else {
+		ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+		ASSERT(level == cur->bc_nlevels - 1);
+	}
+
+	/* now read rh sibling block for next iteration */
+	xfs_btree_get_sibling(cur, block, &rptr, XFS_BB_RIGHTSIB);
+	if (xfs_btree_ptr_is_null(cur, &rptr))
+		return ENOENT;
+
+	return xfs_btree_lookup_get_block(cur, level, &rptr, &block);
+}
+
+int
+xfs_btree_change_owner(
+	struct xfs_btree_cur	*cur,
+	__uint64_t		new_owner)
+{
+	union xfs_btree_ptr     lptr;
+	int			level;
+	struct xfs_btree_block	*block = NULL;
+	int			error = 0;
+
+	cur->bc_ops->init_ptr_from_cur(cur, &lptr);
+
+	/* for each level */
+	for (level = cur->bc_nlevels - 1; level >= 0; level--) {
+		/* grab the left hand block */
+		error = xfs_btree_lookup_get_block(cur, level, &lptr, &block);
+		if (error)
+			return error;
+
+		/* readahead the left most block for the next level down */
+		if (level > 0) {
+			union xfs_btree_ptr     *ptr;
+
+			ptr = xfs_btree_ptr_addr(cur, 1, block);
+			xfs_btree_readahead_ptr(cur, ptr, 1);
+
+			/* save for the next iteration of the loop */
+			lptr = *ptr;
+		}
+
+		/* for each buffer in the level */
+		do {
+			error = xfs_btree_block_change_owner(cur, level,
+							     new_owner);
+		} while (!error);
+
+		if (error != ENOENT)
+			return error;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index c8473c7..544b209 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -121,15 +121,18 @@ union xfs_btree_rec {
 /*
  * For logging record fields.
  */
-#define	XFS_BB_MAGIC		0x01
-#define	XFS_BB_LEVEL		0x02
-#define	XFS_BB_NUMRECS		0x04
-#define	XFS_BB_LEFTSIB		0x08
-#define	XFS_BB_RIGHTSIB		0x10
-#define	XFS_BB_BLKNO		0x20
+#define	XFS_BB_MAGIC		(1 << 0)
+#define	XFS_BB_LEVEL		(1 << 1)
+#define	XFS_BB_NUMRECS		(1 << 2)
+#define	XFS_BB_LEFTSIB		(1 << 3)
+#define	XFS_BB_RIGHTSIB		(1 << 4)
+#define	XFS_BB_BLKNO		(1 << 5)
+#define	XFS_BB_LSN		(1 << 6)
+#define	XFS_BB_UUID		(1 << 7)
+#define	XFS_BB_OWNER		(1 << 8)
 #define	XFS_BB_NUM_BITS		5
 #define	XFS_BB_ALL_BITS		((1 << XFS_BB_NUM_BITS) - 1)
-#define	XFS_BB_NUM_BITS_CRC	8
+#define	XFS_BB_NUM_BITS_CRC	9
 #define	XFS_BB_ALL_BITS_CRC	((1 << XFS_BB_NUM_BITS_CRC) - 1)
 
 /*
@@ -442,6 +445,7 @@ int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
 int xfs_btree_insert(struct xfs_btree_cur *, int *);
 int xfs_btree_delete(struct xfs_btree_cur *, int *);
 int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
+int xfs_btree_change_owner(struct xfs_btree_cur *cur, __uint64_t new_owner);
 
 /*
  * btree block CRC helpers
diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
index a49ab2c..1902c1d 100644
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
@@ -474,6 +474,7 @@ typedef struct xfs_inode_log_format_64 {
 #define	XFS_ILOG_ADATA	0x040	/* log i_af.if_data */
 #define	XFS_ILOG_AEXT	0x080	/* log i_af.if_extents */
 #define	XFS_ILOG_ABROOT	0x100	/* log i_af.i_broot */
+#define XFS_ILOG_OWNER	0x200	/* change the extent tree owner on replay */
 
 
 /*
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
