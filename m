Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 12:31:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6TJUnen000700
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:52 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50F9633F45E
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:31:59 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id zKoYe0byGbx72xPC for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:31:59 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6TJW0IF019435
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:32:00 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6TJW0r0019433
	for xfs@oss.sgi.com; Tue, 29 Jul 2008 21:32:00 +0200
Date: Tue, 29 Jul 2008 21:32:00 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/21] clean up xfs_bmap_btree.c
Message-ID: <20080729193200.GV19104@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-bmap_btree-cleanup
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

From: Dave Chinner <dgc@sgi.com>

Reimplement xfs_bmbt_newroot and xfs_bmbt_kill_root using the new generic
btree helpers and clean out all cruft needed for the old implementations.

This requires exporting some functionality from xfs_btree.c that's only
used locally otherwise.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-07-29 17:04:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-07-29 17:08:43.000000000 +0200
@@ -44,82 +44,6 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 
-/*
- * Prototypes for internal btree functions.
- */
-
-
-STATIC void xfs_bmbt_log_keys(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-STATIC void xfs_bmbt_log_ptrs(xfs_btree_cur_t *, xfs_buf_t *, int, int);
-
-#undef EXIT
-
-#define ENTRY	XBT_ENTRY
-#define ERROR	XBT_ERROR
-#define EXIT	XBT_EXIT
-
-/*
- * Keep the XFS_BMBT_TRACE_ names around for now until all code using them
- * is converted to be generic and thus switches to the XFS_BTREE_TRACE_ names.
- */
-#define	XFS_BMBT_TRACE_ARGBI(c,b,i) \
-	XFS_BTREE_TRACE_ARGBI(c,b,i)
-#define	XFS_BMBT_TRACE_ARGBII(c,b,i,j) \
-	XFS_BTREE_TRACE_ARGBII(c,b,i,j)
-#define	XFS_BMBT_TRACE_ARGFFFI(c,o,b,i,j) \
-	XFS_BTREE_TRACE_ARGFFFI(c,o,b,i,j)
-#define	XFS_BMBT_TRACE_ARGI(c,i) \
-	XFS_BTREE_TRACE_ARGI(c,i)
-#define	XFS_BMBT_TRACE_ARGIFK(c,i,f,s) \
-	XFS_BTREE_TRACE_ARGIPK(c,i,(union xfs_btree_ptr)f,s)
-#define	XFS_BMBT_TRACE_ARGIFR(c,i,f,r) \
-	XFS_BTREE_TRACE_ARGIPR(c,i, \
-		(union xfs_btree_ptr)f, (union xfs_btree_rec *)r)
-#define	XFS_BMBT_TRACE_ARGIK(c,i,k) \
-	XFS_BTREE_TRACE_ARGIK(c,i,(union xfs_btree_key *)k)
-#define	XFS_BMBT_TRACE_CURSOR(c,s) \
-	XFS_BTREE_TRACE_CURSOR(c,s)
-
-
-/*
- * Internal functions.
- */
-
-/*
- * Log pointer values from the btree block.
- */
-STATIC void
-xfs_bmbt_log_ptrs(
-	xfs_btree_cur_t	*cur,
-	xfs_buf_t	*bp,
-	int		pfirst,
-	int		plast)
-{
-	xfs_trans_t	*tp;
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGBII(cur, bp, pfirst, plast);
-	tp = cur->bc_tp;
-	if (bp) {
-		xfs_bmbt_block_t	*block;
-		int			first;
-		int			last;
-		xfs_bmbt_ptr_t		*pp;
-
-		block = XFS_BUF_TO_BMBT_BLOCK(bp);
-		pp = XFS_BMAP_PTR_DADDR(block, 1, cur);
-		first = (int)((xfs_caddr_t)&pp[pfirst - 1] - (xfs_caddr_t)block);
-		last = (int)(((xfs_caddr_t)&pp[plast] - 1) - (xfs_caddr_t)block);
-		xfs_trans_log_buf(tp, bp, first, last);
-	} else {
-		xfs_inode_t		*ip;
-
-		ip = cur->bc_private.b.ip;
-		xfs_trans_log_inode(tp, ip,
-			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	}
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-}
 
 /*
  * Determine the extent state.
@@ -334,151 +258,6 @@ xfs_bmbt_disk_get_startoff(
 }
 
 /*
- * Log fields from the btree block header.
- */
-void
-xfs_bmbt_log_block(
-	xfs_btree_cur_t		*cur,
-	xfs_buf_t		*bp,
-	int			fields)
-{
-	int			first;
-	int			last;
-	xfs_trans_t		*tp;
-	static const short	offsets[] = {
-		offsetof(xfs_bmbt_block_t, bb_magic),
-		offsetof(xfs_bmbt_block_t, bb_level),
-		offsetof(xfs_bmbt_block_t, bb_numrecs),
-		offsetof(xfs_bmbt_block_t, bb_leftsib),
-		offsetof(xfs_bmbt_block_t, bb_rightsib),
-		sizeof(xfs_bmbt_block_t)
-	};
-
-	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
-	XFS_BMBT_TRACE_ARGBI(cur, bp, fields);
-	tp = cur->bc_tp;
-	if (bp) {
-		xfs_btree_offsets(fields, offsets, XFS_BB_NUM_BITS, &first,
-				  &last);
-		xfs_trans_log_buf(tp, bp, first, last);
-	} else
-		xfs_trans_log_inode(tp, cur->bc_private.b.ip,
-			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
-}
-
-/*
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
@@ -875,114 +654,6 @@ xfs_bmbt_get_root_from_inode(
 	return (struct xfs_btree_block *)ifp->if_broot;
 }
 
-STATIC int						/* error */
-xfs_bmbt_new_root(
-	struct xfs_btree_cur	*cur,		/* btree cursor */
-	int			*stat)		/* return status - 0 fail */
-{
-	int			logflags = 0;
-	int			error;
-
-	error = xfs_bmbt_newroot(cur, &logflags, stat);
-	if (error || *stat == 0)
-		return error;
-
-	xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip, logflags);
-	return 0;
-}
-
-STATIC int
-xfs_bmbt_kill_root(
-	struct xfs_btree_cur	*cur,
-	int			level,
-	union xfs_btree_ptr	*newroot)
-{
-	struct xfs_inode	*ip;
-	struct xfs_ifork	*ifp;
-	struct xfs_btree_lblock	*block;
-	struct xfs_btree_lblock	*cblock;
-	struct xfs_buf		*cbp;
-	xfs_bmbt_key_t		*ckp;
-	xfs_bmbt_ptr_t		*cpp;
-	xfs_bmbt_key_t		*kp;
-	xfs_bmbt_ptr_t		*pp;
-	int			i;
-	int			lev;
-
-	ASSERT(newroot == NULL);
-	ASSERT(level == -1);
-
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	lev = cur->bc_nlevels - 1;
-	ASSERT(lev >= 1);
-	/*
-	 * Don't deal with the root block needs to be a leaf case.
-	 * We're just going to turn the thing back into extents anyway.
-	 */
-	if (lev == 1)
-		goto out0;
-
-	block = xfs_bmbt_get_block(cur, lev, &cbp);
-
-	/* Give up if the root has multiple children. */
-	if (be16_to_cpu(block->bb_numrecs) != 1)
-		goto out0;
-	/*
-	 * Only do this if the next level will fit.
-	 * Then the data must be copied up to the inode,
-	 * instead of freeing the root you free the next level.
-	 */
-	cblock = xfs_bmbt_get_block(cur, lev - 1, &cbp);
-	if (be16_to_cpu(cblock->bb_numrecs) > XFS_BMAP_BLOCK_DMAXRECS(level, cur))
-		goto out0;
-	XFS_BTREE_STATS_INC(cur, killroot);
-
-	ASSERT(be64_to_cpu(cblock->bb_leftsib) == NULLDFSBNO);
-	ASSERT(be64_to_cpu(cblock->bb_rightsib) == NULLDFSBNO);
-	ip = cur->bc_private.b.ip;
-	ifp = XFS_IFORK_PTR(ip, cur->bc_private.b.whichfork);
-	ASSERT(XFS_BMAP_BLOCK_IMAXRECS(lev, cur) ==
-	       XFS_BMAP_BROOT_MAXRECS(ifp->if_broot_bytes));
-	i = (int)(be16_to_cpu(cblock->bb_numrecs) -
-		  XFS_BMAP_BLOCK_IMAXRECS(lev, cur));
-	if (i) {
-		xfs_iroot_realloc(ip, i, cur->bc_private.b.whichfork);
-		block = (struct xfs_btree_lblock *)ifp->if_broot;
-	}
-	be16_add(&block->bb_numrecs, i);
-	ASSERT(block->bb_numrecs == cblock->bb_numrecs);
-	kp = XFS_BMAP_KEY_IADDR(block, 1, cur);
-	ckp = XFS_BMAP_KEY_IADDR(cblock, 1, cur);
-	memcpy(kp, ckp, be16_to_cpu(block->bb_numrecs) * sizeof(*kp));
-	pp = XFS_BMAP_PTR_IADDR(block, 1, cur);
-	cpp = XFS_BMAP_PTR_IADDR(cblock, 1, cur);
-
-#ifdef DEBUG
-	for (i = 0; i < be16_to_cpu(cblock->bb_numrecs); i++) {
-		int	error;
-
-		error = xfs_btree_check_lptr_disk(cur, cpp[i], level - 1);
-		if (error) {
-			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
-			return error;
-		}
-	}
-#endif
-
-	memcpy(pp, cpp, be16_to_cpu(block->bb_numrecs) * sizeof(*pp));
-
-	xfs_bmbt_free_block(cur, cbp, 1);
-	XFS_BTREE_STATS_INC(cur, free);
-	cur->bc_bufs[lev - 1] = NULL;
-	be16_add(&block->bb_level, -1);
-	xfs_trans_log_inode(cur->bc_tp, ip,
-		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
-	cur->bc_nlevels--;
-out0:
-	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
-	return 0;
-}
-
 STATIC void
 xfs_bmbt_realloc_root(
 	struct xfs_btree_cur	*cur,
@@ -1231,6 +902,217 @@ xfs_bmbt_log_recs(
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 }
 
+/*
+ * Give the bmap btree a new root block.  Copy the old broot contents
+ * down into a real block and make the broot point to it.
+ */
+int						/* error */
+xfs_bmbt_newroot(
+	struct xfs_btree_cur	*cur,		/* btree cursor */
+	int			*logflags,	/* logging flags for inode */
+	int			*stat)		/* return status - 0 fail */
+{
+	struct xfs_btree_block	*block;		/* bmap btree block */
+	struct xfs_buf		*bp;		/* buffer for block */
+	struct xfs_btree_block	*cblock;	/* child btree block */
+	union xfs_btree_key	*kp;		/* pointer to bmap btree key */
+	union xfs_btree_key	*ckp;		/* child key pointer */
+	union xfs_btree_ptr	*cpp;		/* child ptr pointer */
+	int			error;		/* error return code */
+#ifdef DEBUG
+	int			i;		/* loop counter */
+#endif
+	int			level;		/* btree level */
+	union xfs_btree_ptr	*pp;		/* pointer to bmap block addr */
+	union xfs_btree_ptr	nptr;
+	int			crecs;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	XFS_BTREE_STATS_INC(cur, newroot);
+
+	level = cur->bc_nlevels - 1;
+	block = xfs_btree_get_block(cur, level, &bp);
+	pp = xfs_bmbt_ptr_addr(cur, 1, block);
+
+	error = xfs_bmbt_alloc_block(cur, pp, &nptr, 1, stat);
+	if (error)
+		goto error0;
+
+	if (*stat == 0) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		return 0;
+	}
+
+	XFS_BTREE_STATS_INC(cur, alloc);
+
+	/* Copy the root into a real block. */
+	error = xfs_btree_get_buf_block(cur, &nptr, 0, &cblock, &bp);
+	if (error)
+		goto error0;
+
+	*cblock = *block;
+	be16_add(&block->bb_h.bb_level, 1);
+	xfs_btree_set_numrecs(block, 1);
+	cur->bc_nlevels++;
+	cur->bc_ptrs[level + 1] = 1;
+	kp = xfs_bmbt_key_addr(cur, 1, block);
+	ckp = xfs_bmbt_key_addr(cur, 1, cblock);
+
+	crecs = xfs_btree_get_numrecs(cblock);
+	xfs_bmbt_copy_keys(cur, kp, ckp, crecs);
+
+	cpp = xfs_bmbt_ptr_addr(cur, 1, cblock);
+
+#ifdef DEBUG
+	for (i = 0; i < crecs; i++) {
+		error = xfs_btree_check_ptr(cur, pp, i, level);
+		if (error)
+			goto error0;
+	}
+#endif
+
+	xfs_btree_copy_ptrs(cur, pp, cpp, crecs);
+
+#ifdef DEBUG
+	error = xfs_btree_check_ptr(cur, &nptr, 0, level);
+	if (error)
+		goto error0;
+#endif
+
+	*pp = nptr;
+	xfs_bmbt_realloc_root(cur, 1 - crecs);
+	xfs_btree_setbuf(cur, level, bp);
+
+	/* Log it at the end so that the root is at the right level. */
+	xfs_btree_log_block(cur, bp, XFS_BB_ALL_BITS);
+	xfs_bmbt_log_keys(cur, bp, 1, crecs);
+	xfs_btree_log_ptrs(cur, bp, 1, crecs);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+
+	*logflags |=
+		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork);
+	*stat = 1;
+	return 0;
+error0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+STATIC int						/* error */
+xfs_bmbt_new_root(
+	struct xfs_btree_cur	*cur,		/* btree cursor */
+	int			*stat)		/* return status - 0 fail */
+{
+	int			logflags = 0;
+	int			error;
+
+	error = xfs_bmbt_newroot(cur, &logflags, stat);
+	if (error || *stat == 0)
+		return error;
+
+	xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip, logflags);
+	return 0;
+}
+
+STATIC int
+xfs_bmbt_kill_root(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	union xfs_btree_ptr	*newroot)
+{
+	struct xfs_inode	*ip;
+	struct xfs_ifork	*ifp;
+	struct xfs_btree_block	*block;
+	struct xfs_btree_block	*cblock;
+	struct xfs_buf		*cbp;
+	union xfs_btree_key	*ckp;
+	union xfs_btree_key	*kp;
+	union xfs_btree_ptr	*cpp;
+	union xfs_btree_ptr	*pp;
+	int			i;
+	int			lev;
+	int			nrecs;
+	int			crecs;
+
+	ASSERT(newroot == NULL);
+	ASSERT(level == -1);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+	lev = cur->bc_nlevels - 1;
+	ASSERT(lev >= 1);
+	/*
+	 * Don't deal with the root block needs to be a leaf case.
+	 * We're just going to turn the thing back into extents anyway.
+	 */
+	if (lev == 1)
+		goto out0;
+
+	block = xfs_btree_get_block(cur, lev, &cbp);
+
+	/* Give up if the root has multiple children. */
+	nrecs = xfs_btree_get_numrecs(block);
+	if (nrecs != 1)
+		goto out0;
+	/*
+	 * Only do this if the next level will fit.
+	 * Then the data must be copied up to the inode,
+	 * instead of freeing the root you free the next level.
+	 */
+	cblock = xfs_btree_get_block(cur, lev - 1, &cbp);
+	crecs = xfs_btree_get_numrecs(cblock);
+	if (crecs > XFS_BMAP_BLOCK_DMAXRECS(level, cur))
+		goto out0;
+
+	XFS_BTREE_STATS_INC(cur, killroot);
+
+	ip = cur->bc_private.b.ip;
+	ifp = XFS_IFORK_PTR(ip, cur->bc_private.b.whichfork);
+	ASSERT(XFS_BMAP_BLOCK_IMAXRECS(lev, cur) ==
+	       XFS_BMAP_BROOT_MAXRECS(ifp->if_broot_bytes));
+
+	i = crecs - XFS_BMAP_BLOCK_IMAXRECS(lev, cur);
+	if (i) {
+		xfs_iroot_realloc(ip, i, cur->bc_private.b.whichfork);
+		block = (struct xfs_btree_block *)ifp->if_broot;
+	}
+
+	nrecs += i;
+	xfs_btree_set_numrecs(block, nrecs);
+
+	ASSERT(nrecs == crecs);
+	kp = xfs_bmbt_key_addr(cur, 1, block);
+	ckp = xfs_bmbt_key_addr(cur, 1, cblock);
+	memcpy(kp, ckp, nrecs * sizeof(xfs_bmbt_key_t));
+	pp = xfs_bmbt_ptr_addr(cur, 1, block);
+	cpp = xfs_bmbt_ptr_addr(cur, 1, cblock);
+
+#ifdef DEBUG
+	for (i = 0; i < crecs; i++) {
+		int	error;
+
+		error = xfs_btree_check_ptr(cur, cpp, i, level - 1);
+		if (error) {
+			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+			return error;
+		}
+	}
+#endif
+
+	memcpy(pp, cpp, nrecs * sizeof(xfs_bmbt_key_t));
+
+	xfs_bmbt_free_block(cur, cbp, 1);
+	XFS_BTREE_STATS_INC(cur, free);
+	cur->bc_bufs[lev - 1] = NULL;
+	be16_add(&block->bb_h.bb_level, -1);
+	xfs_trans_log_inode(cur->bc_tp, ip,
+		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+	cur->bc_nlevels--;
+out0:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	return 0;
+}
+
 #ifdef XFS_BTREE_TRACE
 
 ktrace_t	*xfs_bmbt_trace_buf;
Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-29 17:04:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-29 17:04:44.000000000 +0200
@@ -409,7 +409,7 @@ xfs_btree_dup_cursor(
  * Retrieve the block pointer from the cursor at the given level.
  * This may be a bmap btree root or from a buffer.
  */
-STATIC struct xfs_btree_block *		/* generic btree block pointer */
+struct xfs_btree_block *		/* generic btree block pointer */
 xfs_btree_get_block(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	int			level,	/* level in btree */
@@ -987,7 +987,7 @@ xfs_btree_set_refs(
 	}
 }
 
-STATIC int
+int
 xfs_btree_get_buf_block(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr,
@@ -1047,7 +1047,7 @@ xfs_btree_read_buf_block(
 	return xfs_btree_check_block(cur, *block, level, *bpp);
 }
 
-STATIC void
+void
 xfs_btree_set_ptr(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*ptr_addr,
@@ -1088,7 +1088,7 @@ xfs_btree_move_ptrs(
 	}
 }
 
-STATIC void
+void
 xfs_btree_copy_ptrs(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_ptr	*src_ptr,
@@ -1106,7 +1106,7 @@ xfs_btree_copy_ptrs(
 /*
  * Log block pointer fields from a btree block (nonleaf).
  */
-STATIC void
+void
 xfs_btree_log_ptrs(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	struct xfs_buf		*bp,	/* buffer containing btree block */
@@ -1153,7 +1153,7 @@ xfs_btree_log_ptrs(
 /*
  * Log fields from the short from btree block header.
  */
-STATIC void
+void
 xfs_btree_log_block(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	struct xfs_buf		*bp,	/* buffer containing btree block */
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-29 17:04:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-29 17:04:44.000000000 +0200
@@ -612,6 +612,19 @@ int xfs_btree_delete(struct xfs_btree_cu
 
 
 /*
+ * Internal helpers also needed by xfs_bmap_btree.c.
+ */
+struct xfs_btree_block *xfs_btree_get_block(struct xfs_btree_cur *, int,
+		struct xfs_buf **);
+int xfs_btree_get_buf_block(struct xfs_btree_cur *, union xfs_btree_ptr *,
+		int, struct xfs_btree_block **, struct xfs_buf **);
+void xfs_btree_copy_ptrs(struct xfs_btree_cur *, union xfs_btree_ptr *,
+		union xfs_btree_ptr *, int);
+void xfs_btree_log_ptrs(struct xfs_btree_cur *, struct xfs_buf *, int, int);
+void xfs_btree_log_block(struct xfs_btree_cur *, struct xfs_buf *, int);
+
+
+/*
  * Helpers.
  */
 
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-07-29 17:04:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-07-29 17:04:44.000000000 +0200
@@ -3563,7 +3563,7 @@ xfs_bmap_extents_to_btree(
 	 * Do all this logging at the end so that
 	 * the root is at the right level.
 	 */
-	xfs_bmbt_log_block(cur, abp, XFS_BB_ALL_BITS);
+	xfs_btree_log_block(cur, abp, XFS_BB_ALL_BITS);
 	xfs_bmbt_log_recs(cur, abp, 1, be16_to_cpu(ablock->bb_numrecs));
 	ASSERT(*curp == NULL);
 	*curp = cur;

-- 
