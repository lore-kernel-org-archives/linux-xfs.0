Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:34:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741YTEP001298
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:34:29 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 009F3EF6AC8
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:35:41 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id qxep9kea7fzfFKcC for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:35:41 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741ZgIF009297
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:35:43 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741ZgAN009295
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:35:42 +0200
Date: Mon, 4 Aug 2008 03:35:42 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/26] move xfs_bmbt_killroot to common code
Message-ID: <20080804013542.GW8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-common-btree-root_to_iroot
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_bmbt_killroot is a mostly generic implementation of moving from
a real block based root to an inode based root.  So move it to xfs_btree.c
where it can use all the nice infrastructure there and make it pointer
size agnostic

The new name for it is xfs_btree_root_to_iroot which is not very
nice but at least slightly more descriptive than the old name.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-04 01:15:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-04 01:45:52.000000000 +0200
@@ -2838,3 +2838,109 @@ error0:
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 	return error;
 }
+
+int
+xfs_btree_root_to_iroot(
+	struct xfs_btree_cur	*cur)
+{
+	int			whichfork = cur->bc_private.b.whichfork;
+	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_btree_block	*block;
+	struct xfs_btree_block	*cblock;
+	union xfs_btree_key	*kp;
+	union xfs_btree_key	*ckp;
+	union xfs_btree_ptr	*pp;
+	union xfs_btree_ptr	*cpp;
+	struct xfs_buf		*cbp;
+	int			level;
+	int			index;
+	int			numrecs;
+#ifdef DEBUG
+	union xfs_btree_ptr	ptr;
+	int			i;
+#endif
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	level = cur->bc_nlevels - 1;
+	ASSERT(level >= 1);
+
+	/*
+	 * Don't deal with the root block needs to be a leaf case.
+	 * We're just going to turn the thing back into extents anyway.
+	 */
+	if (level == 1)
+		goto out0;
+
+	block = xfs_btree_get_block(cur, level, &cbp);
+
+	/*
+	 * Give up if the root has multiple children.
+	 */
+	if (xfs_btree_get_numrecs(block) != 1)
+		goto out0;
+
+	/*
+	 * Only do this if the next level will fit.
+	 * Then the data must be copied up to the inode,
+	 * instead of freeing the root you free the next level.
+	 */
+	cblock = xfs_btree_get_block(cur, level - 1, &cbp);
+	numrecs = xfs_btree_get_numrecs(cblock);
+
+	if (numrecs > cur->bc_ops->get_dmaxrecs(cur, level))
+	    	goto out0;
+
+	XFS_BTREE_STATS_INC(cur, killroot);
+
+#ifdef DEBUG
+	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_LEFTSIB);
+	ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
+	xfs_btree_get_sibling(cur, block, &ptr, XFS_BB_RIGHTSIB);
+	ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
+
+	// XXX(hch): this assert is bmap btree specific
+ 	ASSERT(cur->bc_ops->get_maxrecs(cur, level) ==
+	       XFS_BMAP_BROOT_MAXRECS(ifp->if_broot_bytes));
+#endif
+
+	index = numrecs - cur->bc_ops->get_maxrecs(cur, level);
+	if (index) {
+		cur->bc_ops->realloc_root(cur, index);
+		block = (struct xfs_btree_block *)ifp->if_broot;
+	}
+
+	be16_add(&block->bb_numrecs, index);
+	ASSERT(block->bb_numrecs == numrecs);
+
+	kp = cur->bc_ops->key_addr(cur, 1, block);
+	ckp = cur->bc_ops->key_addr(cur, 1, cblock);
+	cur->bc_ops->copy_keys(cur, ckp, kp, numrecs);
+
+	pp = cur->bc_ops->ptr_addr(cur, 1, block);
+	cpp = cur->bc_ops->ptr_addr(cur, 1, cblock);
+#ifdef DEBUG
+	for (i = 0; i < numrecs; i++) {
+		int		error;
+
+		error = xfs_btree_check_ptr(cur, cpp, i, level - 1);
+		if (error) {
+			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+			return error;
+		}
+	}
+#endif
+	xfs_btree_copy_ptrs(cur, cpp, pp, numrecs);
+
+	cur->bc_ops->free_block(cur, cbp, 1);
+	XFS_BTREE_STATS_INC(cur, free);
+
+	cur->bc_bufs[level - 1] = NULL;
+	be16_add(&block->bb_level, -1);
+	xfs_trans_log_inode(cur->bc_tp, ip,
+		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+	cur->bc_nlevels--;
+out0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+}
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-08-04 01:15:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-08-04 01:42:19.000000000 +0200
@@ -781,6 +781,39 @@ xfs_allocbt_alloc_block(
 	return 0;
 }
 
+STATIC int
+xfs_allocbt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			size)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+	xfs_agblock_t		bno;
+	int			error;
+
+	bno = XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(bp));
+
+	error = xfs_alloc_put_freelist(cur->bc_tp, cur->bc_private.a.agbp,
+						NULL, bno, size);
+	if (error)
+		return error;
+
+	/*
+	 * Since blocks move to the free list without the coordination used in
+	 * xfs_bmap_finish, we can't allow block to be available for
+	 * reallocation and non-transaction writing (user data) until we know
+	 * that the transaction that moved it to the free list is permanently
+	 * on disk. We track the blocks by declaring these blocks as "busy";
+	 * the busy list is maintained on a per-ag basis and each transaction
+	 * records which entries should be removed when the iclog commits to
+	 * disk. If a busy block is allocated, the iclog is pushed up to the
+	 * LSN that freed the block.
+	 */
+	xfs_alloc_mark_busy(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
+	xfs_trans_agbtree_delta(cur->bc_tp, -1);
+	return 0;
+}
+
 /*
  * Update the longest extent in the AGF
  */
@@ -1153,6 +1186,7 @@ static const struct xfs_btree_ops xfs_al
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
+	.free_block		= xfs_allocbt_free_block,
 	.update_lastrec		= xfs_allocbt_update_lastrec,
 	.get_maxrecs		= xfs_allocbt_get_maxrecs,
 	.init_key_from_rec	= xfs_allocbt_init_key_from_rec,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-08-04 01:15:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-08-04 01:42:19.000000000 +0200
@@ -49,7 +49,6 @@
  */
 
 
-STATIC int xfs_bmbt_killroot(xfs_btree_cur_t *);
 STATIC void xfs_bmbt_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 STATIC void xfs_bmbt_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
 
@@ -194,7 +193,7 @@ xfs_bmbt_delrec(
 	if (level == cur->bc_nlevels - 1) {
 		xfs_iroot_realloc(cur->bc_private.b.ip, -1,
 			cur->bc_private.b.whichfork);
-		if ((error = xfs_bmbt_killroot(cur))) {
+		if ((error = xfs_btree_root_to_iroot(cur))) {
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 			goto error0;
 		}
@@ -228,7 +227,7 @@ xfs_bmbt_delrec(
 	 */
 	if (lbno == NULLFSBLOCK && rbno == NULLFSBLOCK &&
 	    level == cur->bc_nlevels - 2) {
-		if ((error = xfs_bmbt_killroot(cur))) {
+		if ((error = xfs_btree_root_to_iroot(cur))) {
 			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 			goto error0;
 		}
@@ -456,97 +455,6 @@ error0:
 	return error;
 }
 
-STATIC int
-xfs_bmbt_killroot(
-	xfs_btree_cur_t		*cur)
-{
-	xfs_bmbt_block_t	*block;
-	xfs_bmbt_block_t	*cblock;
-	xfs_buf_t		*cbp;
-	xfs_bmbt_key_t		*ckp;
-	xfs_bmbt_ptr_t		*cpp;
-#ifdef DEBUG
-	int			error;
-#endif
-	int			i;
-	xfs_bmbt_key_t		*kp;
-	xfs_inode_t		*ip;
-	xfs_ifork_t		*ifp;
-	int			level;
-	xfs_bmbt_ptr_t		*pp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	level = cur->bc_nlevels - 1;
-	ASSERT(level >= 1);
-	/*
-	 * Don't deal with the root block needs to be a leaf case.
-	 * We're just going to turn the thing back into extents anyway.
-	 */
-	if (level == 1) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		return 0;
-	}
-	block = xfs_bmbt_get_block(cur, level, &cbp);
-	/*
-	 * Give up if the root has multiple children.
-	 */
-	if (be16_to_cpu(block->bb_numrecs) != 1) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		return 0;
-	}
-	/*
-	 * Only do this if the next level will fit.
-	 * Then the data must be copied up to the inode,
-	 * instead of freeing the root you free the next level.
-	 */
-	cbp = cur->bc_bufs[level - 1];
-	cblock = XFS_BUF_TO_BMBT_BLOCK(cbp);
-	if (be16_to_cpu(cblock->bb_numrecs) > XFS_BMAP_BLOCK_DMAXRECS(level, cur)) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		return 0;
-	}
-	ASSERT(be64_to_cpu(cblock->bb_leftsib) == NULLDFSBNO);
-	ASSERT(be64_to_cpu(cblock->bb_rightsib) == NULLDFSBNO);
-	ip = cur->bc_private.b.ip;
-	ifp = XFS_IFORK_PTR(ip, cur->bc_private.b.whichfork);
-	ASSERT(XFS_BMAP_BLOCK_IMAXRECS(level, cur) ==
-	       XFS_BMAP_BROOT_MAXRECS(ifp->if_broot_bytes));
-	i = (int)(be16_to_cpu(cblock->bb_numrecs) - XFS_BMAP_BLOCK_IMAXRECS(level, cur));
-	if (i) {
-		xfs_iroot_realloc(ip, i, cur->bc_private.b.whichfork);
-		block = ifp->if_broot;
-	}
-	be16_add(&block->bb_numrecs, i);
-	ASSERT(block->bb_numrecs == cblock->bb_numrecs);
-	kp = XFS_BMAP_KEY_IADDR(block, 1, cur);
-	ckp = XFS_BMAP_KEY_IADDR(cblock, 1, cur);
-	memcpy(kp, ckp, be16_to_cpu(block->bb_numrecs) * sizeof(*kp));
-	pp = XFS_BMAP_PTR_IADDR(block, 1, cur);
-	cpp = XFS_BMAP_PTR_IADDR(cblock, 1, cur);
-#ifdef DEBUG
-	for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
-		if ((error = xfs_btree_check_lptr_disk(cur, cpp[i], level - 1))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-	}
-#endif
-	memcpy(pp, cpp, be16_to_cpu(block->bb_numrecs) * sizeof(*pp));
-	xfs_bmap_add_free(XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(cbp)), 1,
-			cur->bc_private.b.flist, cur->bc_mp);
-	ip->i_d.di_nblocks--;
-	XFS_TRANS_MOD_DQUOT_BYINO(cur->bc_mp, cur->bc_tp, ip,
-			XFS_TRANS_DQ_BCOUNT, -1L);
-	xfs_trans_binval(cur->bc_tp, cbp);
-	cur->bc_bufs[level - 1] = NULL;
-	be16_add(&block->bb_level, -1);
-	xfs_trans_log_inode(cur->bc_tp, ip,
-		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	cur->bc_nlevels--;
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	return 0;
-}
-
 /*
  * Log pointer values from the btree block.
  */
@@ -1234,6 +1142,24 @@ xfs_bmbt_alloc_block(
 	return error;
 }
 
+STATIC int
+xfs_bmbt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			size)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_inode	*ip = cur->bc_private.b.ip;
+
+	xfs_bmap_add_free(XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp)), 1,
+		cur->bc_private.b.flist, mp);
+	ip->i_d.di_nblocks--;
+	xfs_trans_log_inode(cur->bc_tp, ip, XFS_ILOG_CORE);
+	XFS_TRANS_MOD_DQUOT_BYINO(mp, cur->bc_tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
+	xfs_trans_binval(cur->bc_tp, bp);
+	return 0;
+}
+
 STATIC struct xfs_btree_block *
 xfs_bmbt_get_root_from_inode(
 	struct xfs_btree_cur	*cur)
@@ -1571,6 +1497,7 @@ static const struct xfs_btree_ops xfs_bm
 	.get_root_from_inode	= xfs_bmbt_get_root_from_inode,
 	.realloc_root		= xfs_bmbt_realloc_root,
 	.alloc_block		= xfs_bmbt_alloc_block,
+	.free_block		= xfs_bmbt_free_block,
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.init_rec_from_key	= xfs_bmbt_init_rec_from_key,
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-08-04 01:15:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-04 01:42:19.000000000 +0200
@@ -198,6 +198,8 @@ struct xfs_btree_ops {
 			       union xfs_btree_ptr *start_bno,
 			       union xfs_btree_ptr *new_bno,
 			       int length, int *stat);
+	int	(*free_block)(struct xfs_btree_cur *cur, struct xfs_buf *bp,
+			      int length);
 
 	/* updated last record information */
 	void	(*update_lastrec)(struct xfs_btree_cur *cur,
@@ -596,6 +598,7 @@ int xfs_btree_split(struct xfs_btree_cur
 		union xfs_btree_key *, struct xfs_btree_cur **, int *);
 int xfs_btree_new_root(struct xfs_btree_cur *, int *);
 int xfs_btree_iroot_to_root(struct xfs_btree_cur *, int *, int *);
+int xfs_btree_root_to_iroot(struct xfs_btree_cur *);
 int xfs_btree_insert(struct xfs_btree_cur *, int *);
 
 
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-08-04 01:15:17.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-08-04 01:42:19.000000000 +0200
@@ -710,6 +710,22 @@ xfs_inobt_alloc_block(
 	return 0;
 }
 
+STATIC int
+xfs_inobt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	int			size)
+{
+	int			error;
+
+	error = xfs_free_extent(cur->bc_tp,
+			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1);
+	if (error)
+		return error;
+
+	xfs_trans_binval(cur->bc_tp, bp);
+	return 0;
+}
 
 STATIC int
 xfs_inobt_get_maxrecs(
@@ -1001,6 +1017,7 @@ static const struct xfs_btree_ops xfs_in
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_inobt_set_root,
 	.alloc_block		= xfs_inobt_alloc_block,
+	.free_block		= xfs_inobt_free_block,
 	.get_maxrecs		= xfs_inobt_get_maxrecs,
 	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,

-- 
