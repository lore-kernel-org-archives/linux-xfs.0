Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:34:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741YHKQ001058
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:34:17 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21391EF6ABA
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:35:28 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id X86ZcbO7M0l71UhA for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:35:28 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741ZUIF009261
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:35:30 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741ZU7i009259
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:35:30 +0200
Date: Mon, 4 Aug 2008 03:35:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/26] move xfs_bmbt_newroot to common code
Message-ID: <20080804013530.GU8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-common-btree-iroot_to_root
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_bmbt_newroot is a mostly generic implementation of moving from
an inode root to a real block based root.  So move it to xfs_btree.c
where it can use all the nice infrastructure there and make it pointer
size agnostic

The new name for it is xfs_btree_iroot_to_root which is not very
nice but at least slightly more descriptive than the old name.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-03 15:34:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-03 22:42:26.000000000 +0200
@@ -2250,6 +2250,106 @@ error0:
 }
 
 /*
+ * Give the btree a real root block.  Copy the old broot contents
+ * down into a real block and make the broot point to it.
+ */
+int						/* error */
+xfs_btree_iroot_to_root(
+	struct xfs_btree_cur	*cur,		/* btree cursor */
+	int			*logflags,	/* logging flags for inode */
+	int			*stat)		/* return status - 0 fail */
+{
+	struct xfs_buf		*bp;		/* buffer for block */
+	struct xfs_buf		*cbp;		/* buffer for cblock */
+	struct xfs_btree_block	*block;		/* btree block */
+	struct xfs_btree_block	*cblock;	/* child btree block */
+	union xfs_btree_key	*ckp;		/* child key pointer */
+	union xfs_btree_ptr	*cpp;		/* child ptr pointer */
+	union xfs_btree_key	*kp;		/* pointer to btree key */
+	union xfs_btree_ptr	*pp;		/* pointer to block addr */
+	union xfs_btree_ptr	nptr;		/* new block addr */
+	int			level;		/* btree level */
+	int			error;		/* error return code */
+#ifdef DEBUG
+	int			i;		/* loop counter */
+#endif
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_STATS_INC(cur, newroot);
+
+	level = cur->bc_nlevels - 1;
+	/* XXX(hch): this should be an get_inode_from_root, right? */
+	block = xfs_btree_get_block(cur, level, &bp);
+	pp = cur->bc_ops->ptr_addr(cur, 1, block);
+
+	/* Allocate the new block. If we can't do it, we're toast. Give up. */
+	error = cur->bc_ops->alloc_block(cur, pp, &nptr, 1, stat);
+	if (error)
+		goto error0;
+	if (*stat == 0) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		return 0;
+	}
+	XFS_BTREE_STATS_INC(cur, alloc);
+
+	/* Copy the root into a real block. */
+	error = xfs_btree_get_buf_block(cur, &nptr, 0, &cblock, &cbp);
+	if (error)
+		goto error0;
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		memcpy(cblock, block, sizeof(struct xfs_btree_lblock));
+	else
+		memcpy(cblock, block, sizeof(struct xfs_btree_sblock));
+
+	be16_add(&block->bb_level, 1);
+	xfs_btree_set_numrecs(block, 1);
+	cur->bc_nlevels++;
+	cur->bc_ptrs[level + 1] = 1;
+
+	kp = cur->bc_ops->key_addr(cur, 1, block);
+	ckp = cur->bc_ops->key_addr(cur, 1, cblock);
+	cur->bc_ops->copy_keys(cur, kp, ckp, xfs_btree_get_numrecs(cblock));
+
+	cpp = cur->bc_ops->ptr_addr(cur, 1, cblock);
+#ifdef DEBUG
+	for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
+		error = xfs_btree_check_ptr(cur, pp, i, level);
+		if (error)
+			goto error0;
+	}
+#endif
+	xfs_btree_copy_ptrs(cur, pp, cpp, xfs_btree_get_numrecs(cblock));
+
+#ifdef DEBUG
+	error = xfs_btree_check_ptr(cur, &nptr, 0, level);
+	if (error)
+		goto error0;
+#endif
+	xfs_btree_set_ptr(cur, pp, 0, &nptr);
+
+	cur->bc_ops->realloc_root(cur, 1 - xfs_btree_get_numrecs(cblock));
+	xfs_btree_setbuf(cur, level, cbp);
+
+	/*
+	 * Do all this logging at the end so that
+	 * the root is at the right level.
+	 */
+	xfs_btree_log_block(cur, cbp, XFS_BB_ALL_BITS);
+	cur->bc_ops->log_keys(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
+	xfs_btree_log_ptrs(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
+
+	*logflags |=
+		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork);
+	*stat = 1;
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+/*
  * Allocate a new root block, fill it in.
  */
 int				/* error */
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-08-03 16:02:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-08-03 22:42:26.000000000 +0200
@@ -476,7 +476,7 @@ xfs_bmap_add_attrfork_btree(
 			goto error0;
 		/* must be at least one entry */
 		XFS_WANT_CORRUPTED_GOTO(stat == 1, error0);
-		if ((error = xfs_bmbt_newroot(cur, flags, &stat)))
+		if ((error = xfs_btree_iroot_to_root(cur, flags, &stat)))
 			goto error0;
 		if (stat == 0) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-08-03 15:34:19.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-08-03 22:42:25.000000000 +0200
@@ -525,7 +525,7 @@ xfs_bmbt_insrec(
 				cur->bc_private.b.whichfork);
 			block = xfs_bmbt_get_block(cur, level, &bp);
 		} else if (level == cur->bc_nlevels - 1) {
-			if ((error = xfs_bmbt_newroot(cur, &logflags, stat)) ||
+			if ((error = xfs_btree_iroot_to_root(cur, &logflags, stat)) ||
 			    *stat == 0) {
 				XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 				return error;
@@ -1119,117 +1119,6 @@ xfs_bmbt_log_block(
 }
 
 /*
- * Give the bmap btree a new root block.  Copy the old broot contents
- * down into a real block and make the broot point to it.
- */
-int						/* error */
-xfs_bmbt_newroot(
-	xfs_btree_cur_t		*cur,		/* btree cursor */
-	int			*logflags,	/* logging flags for inode */
-	int			*stat)		/* return status - 0 fail */
-{
-	xfs_alloc_arg_t		args;		/* allocation arguments */
-	xfs_bmbt_block_t	*block;		/* bmap btree block */
-	xfs_buf_t		*bp;		/* buffer for block */
-	xfs_bmbt_block_t	*cblock;	/* child btree block */
-	xfs_bmbt_key_t		*ckp;		/* child key pointer */
-	xfs_bmbt_ptr_t		*cpp;		/* child ptr pointer */
-	int			error;		/* error return code */
-#ifdef DEBUG
-	int			i;		/* loop counter */
-#endif
-	xfs_bmbt_key_t		*kp;		/* pointer to bmap btree key */
-	int			level;		/* btree level */
-	xfs_bmbt_ptr_t		*pp;		/* pointer to bmap block addr */
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	level = cur->bc_nlevels - 1;
-	block = xfs_bmbt_get_block(cur, level, &bp);
-	/*
-	 * Copy the root into a real block.
-	 */
-	args.mp = cur->bc_mp;
-	pp = XFS_BMAP_PTR_IADDR(block, 1, cur);
-	args.tp = cur->bc_tp;
-	args.fsbno = cur->bc_private.b.firstblock;
-	args.mod = args.minleft = args.alignment = args.total = args.isfl =
-		args.userdata = args.minalignslop = 0;
-	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
-	args.firstblock = args.fsbno;
-	if (args.fsbno == NULLFSBLOCK) {
-#ifdef DEBUG
-		if ((error = xfs_btree_check_lptr_disk(cur, *pp, level))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-#endif
-		args.fsbno = be64_to_cpu(*pp);
-		args.type = XFS_ALLOCTYPE_START_BNO;
-	} else if (cur->bc_private.b.flist->xbf_low)
-		args.type = XFS_ALLOCTYPE_START_BNO;
-	else
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	if ((error = xfs_alloc_vextent(&args))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-	if (args.fsbno == NULLFSBLOCK) {
-		XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-		*stat = 0;
-		return 0;
-	}
-	ASSERT(args.len == 1);
-	cur->bc_private.b.firstblock = args.fsbno;
-	cur->bc_private.b.allocated++;
-	cur->bc_private.b.ip->i_d.di_nblocks++;
-	XFS_TRANS_MOD_DQUOT_BYINO(args.mp, args.tp, cur->bc_private.b.ip,
-			  XFS_TRANS_DQ_BCOUNT, 1L);
-	bp = xfs_btree_get_bufl(args.mp, cur->bc_tp, args.fsbno, 0);
-	cblock = XFS_BUF_TO_BMBT_BLOCK(bp);
-	*cblock = *block;
-	be16_add(&block->bb_level, 1);
-	block->bb_numrecs = cpu_to_be16(1);
-	cur->bc_nlevels++;
-	cur->bc_ptrs[level + 1] = 1;
-	kp = XFS_BMAP_KEY_IADDR(block, 1, cur);
-	ckp = XFS_BMAP_KEY_IADDR(cblock, 1, cur);
-	memcpy(ckp, kp, be16_to_cpu(cblock->bb_numrecs) * sizeof(*kp));
-	cpp = XFS_BMAP_PTR_IADDR(cblock, 1, cur);
-#ifdef DEBUG
-	for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
-		if ((error = xfs_btree_check_lptr_disk(cur, pp[i], level))) {
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
-		}
-	}
-#endif
-	memcpy(cpp, pp, be16_to_cpu(cblock->bb_numrecs) * sizeof(*pp));
-#ifdef DEBUG
-	if ((error = xfs_btree_check_lptr(cur, args.fsbno, level))) {
-		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-		return error;
-	}
-#endif
-	*pp = cpu_to_be64(args.fsbno);
-	xfs_iroot_realloc(cur->bc_private.b.ip, 1 - be16_to_cpu(cblock->bb_numrecs),
-		cur->bc_private.b.whichfork);
-	xfs_btree_setbuf(cur, level, bp);
-	/*
-	 * Do all this logging at the end so that
-	 * the root is at the right level.
-	 */
-	xfs_bmbt_log_block(cur, bp, XFS_BB_ALL_BITS);
-	xfs_bmbt_log_keys(cur, bp, 1, be16_to_cpu(cblock->bb_numrecs));
-	xfs_bmbt_log_ptrs(cur, bp, 1, be16_to_cpu(cblock->bb_numrecs));
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-	*logflags |=
-		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork);
-	*stat = 1;
-	return 0;
-}
-
-/*
  * Set all the fields in a bmap extent record from the arguments.
  */
 void
@@ -1593,6 +1482,15 @@ xfs_bmbt_get_root_from_inode(
 	return (struct xfs_btree_block *)ifp->if_broot;
 }
 
+STATIC void
+xfs_bmbt_realloc_root(
+	struct xfs_btree_cur	*cur,
+	int			index)
+{
+	xfs_iroot_realloc(cur->bc_private.b.ip, index,
+			  cur->bc_private.b.whichfork);
+}
+
 STATIC int
 xfs_bmbt_get_maxrecs(
 	struct xfs_btree_cur	*cur,
@@ -1881,6 +1779,7 @@ xfs_bmbt_trace_record(
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.dup_cursor		= xfs_bmbt_dup_cursor,
 	.get_root_from_inode	= xfs_bmbt_get_root_from_inode,
+	.realloc_root		= xfs_bmbt_realloc_root,
 	.alloc_block		= xfs_bmbt_alloc_block,
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2008-08-03 16:01:23.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2008-08-03 22:42:26.000000000 +0200
@@ -255,12 +255,6 @@ extern void xfs_bmbt_log_block(struct xf
 extern void xfs_bmbt_log_recs(struct xfs_btree_cur *, struct xfs_buf *, int,
 				int);
 
-/*
- * Give the bmap btree a new root block.  Copy the old broot contents
- * down into a real block and make the broot point to it.
- */
-extern int xfs_bmbt_newroot(struct xfs_btree_cur *cur, int *lflags, int *stat);
-
 extern void xfs_bmbt_set_all(xfs_bmbt_rec_host_t *r, xfs_bmbt_irec_t *s);
 extern void xfs_bmbt_set_allf(xfs_bmbt_rec_host_t *r, xfs_fileoff_t o,
 			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-08-03 15:59:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-03 22:42:25.000000000 +0200
@@ -183,8 +183,9 @@ struct xfs_btree_ops {
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 
-	/* get inode rooted btree root */
+	/* btree root in inode support */
 	struct xfs_btree_block *(*get_root_from_inode)(struct xfs_btree_cur *);
+	void	(*realloc_root)(struct xfs_btree_cur *cur, int index);
 
 	/* btree root operations */
 	void	(*set_root)(struct xfs_btree_cur *cur,
@@ -586,6 +587,7 @@ int xfs_btree_rshift(struct xfs_btree_cu
 int xfs_btree_split(struct xfs_btree_cur *, int, union xfs_btree_ptr *,
 		union xfs_btree_key *, struct xfs_btree_cur **, int *);
 int xfs_btree_new_root(struct xfs_btree_cur *, int *);
+int xfs_btree_iroot_to_root(struct xfs_btree_cur *, int *, int *);
 
 
 /*

-- 
