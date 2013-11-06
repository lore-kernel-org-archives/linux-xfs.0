Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 50F3C29E2A
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CBF25AC007
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:42 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DB7XuQrwUx4Oot2B for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:40 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdrak-0003Nw-2g
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdrak-0008UT-29
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/37] libxfs: bmap btree owner swap support
Date: Wed,  6 Nov 2013 12:06:53 +1100
Message-Id: <1383700043-32305-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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

This patch brings across the kernel code for doing the owner
swap of an entire fork - something that we are likely to end up
needing in xfs_repair when reparenting stray inodes to lost+found -
without all the associated swap extents transaction and recovery
cruft as those parts are not needed in userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_bmap_btree.h |   4 ++
 include/xfs_btree.h      |  19 ++++--
 include/xfs_inode_buf.h  |  18 ++---
 include/xfs_log_format.h |   8 ++-
 libxfs/xfs_bmap_btree.c  |  44 ++++++++++++
 libxfs/xfs_btree.c       | 170 ++++++++++++++++++++++++++++++++++++++++++-----
 6 files changed, 227 insertions(+), 36 deletions(-)

diff --git a/include/xfs_bmap_btree.h b/include/xfs_bmap_btree.h
index 2379d33..6e42e1e 100644
--- a/include/xfs_bmap_btree.h
+++ b/include/xfs_bmap_btree.h
@@ -133,6 +133,10 @@ extern int xfs_bmbt_get_maxrecs(struct xfs_btree_cur *, int level);
 extern int xfs_bmdr_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 extern int xfs_bmbt_maxrecs(struct xfs_mount *, int blocklen, int leaf);
 
+extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
+				 int whichfork, xfs_ino_t new_owner,
+				 struct list_head *buffer_list);
+
 extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_inode *, int);
 
diff --git a/include/xfs_btree.h b/include/xfs_btree.h
index 227bfa5..6afe0b2 100644
--- a/include/xfs_btree.h
+++ b/include/xfs_btree.h
@@ -41,15 +41,18 @@ extern kmem_zone_t	*xfs_btree_cur_zone;
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
@@ -381,6 +384,8 @@ int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
 int xfs_btree_insert(struct xfs_btree_cur *, int *);
 int xfs_btree_delete(struct xfs_btree_cur *, int *);
 int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
+int xfs_btree_change_owner(struct xfs_btree_cur *cur, __uint64_t new_owner,
+			   struct list_head *buffer_list);
 
 /*
  * btree block CRC helpers
diff --git a/include/xfs_inode_buf.h b/include/xfs_inode_buf.h
index e8fd3bd..9308c47 100644
--- a/include/xfs_inode_buf.h
+++ b/include/xfs_inode_buf.h
@@ -32,17 +32,17 @@ struct xfs_imap {
 	ushort		im_boffset;	/* inode offset in block in bytes */
 };
 
-int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
-			       struct xfs_imap *, struct xfs_dinode **,
-			       struct xfs_buf **, uint, uint);
-int		xfs_iread(struct xfs_mount *, struct xfs_trans *,
-			  struct xfs_inode *, uint);
-void		xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
-void		xfs_dinode_to_disk(struct xfs_dinode *,
-				   struct xfs_icdinode *);
+int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
+		       struct xfs_imap *, struct xfs_dinode **,
+		       struct xfs_buf **, uint, uint);
+int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
+		  struct xfs_inode *, uint);
+void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
+void	xfs_dinode_to_disk(struct xfs_dinode *to, struct xfs_icdinode *from);
+void	xfs_dinode_from_disk(struct xfs_icdinode *to, struct xfs_dinode *from);
 
 #if defined(DEBUG)
-void		xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
+void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #else
 #define	xfs_inobp_check(mp, bp)
 #endif /* DEBUG */
diff --git a/include/xfs_log_format.h b/include/xfs_log_format.h
index aeaa715..f0969c7 100644
--- a/include/xfs_log_format.h
+++ b/include/xfs_log_format.h
@@ -302,6 +302,8 @@ typedef struct xfs_inode_log_format_64 {
 #define	XFS_ILOG_ADATA	0x040	/* log i_af.if_data */
 #define	XFS_ILOG_AEXT	0x080	/* log i_af.if_extents */
 #define	XFS_ILOG_ABROOT	0x100	/* log i_af.i_broot */
+#define XFS_ILOG_DOWNER	0x200	/* change the data fork owner on replay */
+#define XFS_ILOG_AOWNER	0x400	/* change the attr fork owner on replay */
 
 
 /*
@@ -315,7 +317,8 @@ typedef struct xfs_inode_log_format_64 {
 #define	XFS_ILOG_NONCORE	(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
 				 XFS_ILOG_DBROOT | XFS_ILOG_DEV | \
 				 XFS_ILOG_UUID | XFS_ILOG_ADATA | \
-				 XFS_ILOG_AEXT | XFS_ILOG_ABROOT)
+				 XFS_ILOG_AEXT | XFS_ILOG_ABROOT | \
+				 XFS_ILOG_DOWNER | XFS_ILOG_AOWNER)
 
 #define	XFS_ILOG_DFORK		(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
 				 XFS_ILOG_DBROOT)
@@ -327,7 +330,8 @@ typedef struct xfs_inode_log_format_64 {
 				 XFS_ILOG_DEXT | XFS_ILOG_DBROOT | \
 				 XFS_ILOG_DEV | XFS_ILOG_UUID | \
 				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
-				 XFS_ILOG_ABROOT | XFS_ILOG_TIMESTAMP)
+				 XFS_ILOG_ABROOT | XFS_ILOG_TIMESTAMP | \
+				 XFS_ILOG_DOWNER | XFS_ILOG_AOWNER)
 
 static inline int xfs_ilog_fbroot(int w)
 {
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index bf214cf..2f6b48a 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -999,3 +999,47 @@ xfs_bmdr_maxrecs(
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
+ * For demand paged transactional modification, the fork switch should be done
+ * after reading in all the blocks, modifying them and pinning them in the
+ * transaction. For modification when the buffers are already pinned in memory,
+ * the fork switch can be done before changing the owner as we won't need to
+ * validate the owner until the btree buffers are unpinned and writes can occur
+ * again.
+ *
+ * For recovery based ownership change, there is no transactional context and
+ * so a buffer list must be supplied so that we can record the buffers that we
+ * modified for the caller to issue IO on.
+ */
+int
+xfs_bmbt_change_owner(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	xfs_ino_t		new_owner,
+	struct list_head	*buffer_list)
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	ASSERT(tp || buffer_list);
+	ASSERT(!(tp && buffer_list));
+	if (whichfork == XFS_DATA_FORK)
+		ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_BTREE);
+	else
+		ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_BTREE);
+
+	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
+	if (!cur)
+		return ENOMEM;
+
+	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	return error;
+}
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index ce149ad..2dd6fb7 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -837,6 +837,41 @@ xfs_btree_readahead(
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
@@ -1055,24 +1090,6 @@ xfs_btree_buf_to_ptr(
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
@@ -3851,3 +3868,120 @@ xfs_btree_get_rec(
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
+ * correctly relogged in that transaction.  If we are in recovery context, then
+ * just queue the modified buffer as delayed write buffer so the transaction
+ * recovery completion writes the changes to disk.
+ */
+static int
+xfs_btree_block_change_owner(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	__uint64_t		new_owner,
+	struct list_head	*buffer_list)
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
+	 * If the block is a root block hosted in an inode, we might not have a
+	 * buffer pointer here and we shouldn't attempt to log the change as the
+	 * information is already held in the inode and discarded when the root
+	 * block is formatted into the on-disk inode fork. We still change it,
+	 * though, so everything is consistent in memory.
+	 */
+	if (bp) {
+		if (cur->bc_tp) {
+			xfs_trans_ordered_buf(cur->bc_tp, bp);
+			xfs_btree_log_block(cur, bp, XFS_BB_OWNER);
+		} else {
+			xfs_buf_delwri_queue(bp, buffer_list);
+		}
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
+	__uint64_t		new_owner,
+	struct list_head	*buffer_list)
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
+							     new_owner,
+							     buffer_list);
+		} while (!error);
+
+		if (error != ENOENT)
+			return error;
+	}
+
+	return 0;
+}
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
