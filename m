Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:34:54 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741YfFT001461
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:34:42 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 807841976459
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:35:54 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id WeSwpHcTvPlmJLtx for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:35:54 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741ZuIF009327
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:35:56 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741ZuD0009325
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:35:56 +0200
Date: Mon, 4 Aug 2008 03:35:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/26] implement generic xfs_btree_getrec
Message-ID: <20080804013556.GY8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-common-btree-get_rec
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Not really much reason to make it generic given that it's so small,
but this is the last non-method in xfs_alloc_btree.c and xfs_ialloc_btree.c,
so it makes the whole btree implementation more structured.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-04 01:07:19.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-04 01:11:38.000000000 +0200
@@ -3579,3 +3579,43 @@ error0:
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 	return error;
 }
+
+/*
+ * Get the data from the pointed-to record.
+ */
+int					/* error */
+xfs_btree_getrec(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	union xfs_btree_rec	**recp,	/* output: btree record */
+	int			*stat)	/* output: success/failure */
+{
+	struct xfs_btree_block	*block;	/* btree block */
+	int			ptr;	/* record number */
+#ifdef DEBUG
+	int			error;	/* error return value */
+#endif
+
+	ptr = cur->bc_ptrs[0];
+	block = XFS_BUF_TO_BLOCK(cur->bc_bufs[0]);
+
+#ifdef DEBUG
+	error = xfs_btree_check_block(cur, block, 0, cur->bc_bufs[0]);
+	if (error)
+		return error;
+#endif
+
+	/*
+	 * Off the right end or left end, return failure.
+	 */
+	if (ptr > xfs_btree_get_numrecs(block) || ptr <= 0) {
+		*stat = 0;
+		return 0;
+	}
+
+	/*
+	 * Point to the record and extract its data.
+	 */
+	*recp = cur->bc_ops->rec_addr(cur, ptr, block);
+	*stat = 1;
+	return 0;
+}
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-08-04 01:04:14.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-04 01:11:38.000000000 +0200
@@ -603,6 +603,7 @@ int xfs_btree_iroot_to_root(struct xfs_b
 int xfs_btree_root_to_iroot(struct xfs_btree_cur *);
 int xfs_btree_insert(struct xfs_btree_cur *, int *);
 int xfs_btree_delete(struct xfs_btree_cur *, int *);
+int xfs_btree_getrec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
 
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c	2008-08-04 01:03:15.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c	2008-08-04 01:11:38.000000000 +0200
@@ -41,50 +41,6 @@
 #include "xfs_error.h"
 
 
-/*
- * Get the data from the pointed-to record.
- */
-int					/* error */
-xfs_alloc_get_rec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agblock_t		*bno,	/* output: starting block of extent */
-	xfs_extlen_t		*len,	/* output: length of extent */
-	int			*stat)	/* output: success/failure */
-{
-	xfs_alloc_block_t	*block;	/* btree block */
-#ifdef DEBUG
-	int			error;	/* error return value */
-#endif
-	int			ptr;	/* record number */
-
-	ptr = cur->bc_ptrs[0];
-	block = XFS_BUF_TO_ALLOC_BLOCK(cur->bc_bufs[0]);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, 0, cur->bc_bufs[0])))
-		return error;
-#endif
-	/*
-	 * Off the right end or left end, return failure.
-	 */
-	if (ptr > be16_to_cpu(block->bb_numrecs) || ptr <= 0) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Point to the record and extract its data.
-	 */
-	{
-		xfs_alloc_rec_t		*rec;	/* record data */
-
-		rec = XFS_ALLOC_REC_ADDR(block, ptr, cur);
-		*bno = be32_to_cpu(rec->ar_startblock);
-		*len = be32_to_cpu(rec->ar_blockcount);
-	}
-	*stat = 1;
-	return 0;
-}
-
-
 STATIC struct xfs_btree_cur *
 xfs_allocbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
Index: linux-2.6-xfs/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c	2008-08-04 01:03:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc.c	2008-08-04 01:11:38.000000000 +0200
@@ -155,6 +155,27 @@ xfs_alloc_update(
 }
 
 /*
+ * Get the data from the pointed-to record.
+ */
+STATIC int				/* error */
+xfs_alloc_get_rec(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		*bno,	/* output: starting block of extent */
+	xfs_extlen_t		*len,	/* output: length of extent */
+	int			*stat)	/* output: success/failure */
+{
+	union xfs_btree_rec	*rec;
+	int			error;
+
+	error = xfs_btree_getrec(cur, &rec, stat);
+	if (!error && *stat == 1) {
+		*bno = be32_to_cpu(rec->alloc.ar_startblock);
+		*len = be32_to_cpu(rec->alloc.ar_blockcount);
+	}
+	return error;
+}
+
+/*
  * Compute aligned version of the found extent.
  * Takes alignment and min length into account.
  */
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.h	2008-08-04 01:03:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.h	2008-08-04 01:11:38.000000000 +0200
@@ -94,12 +94,6 @@ typedef	struct xfs_btree_sblock xfs_allo
 #define	XFS_ALLOC_PTR_ADDR(bb,i,cur)	\
 	XFS_BTREE_PTR_ADDR(xfs_alloc, bb, i, XFS_ALLOC_BLOCK_MAXRECS(1, cur))
 
-/*
- * Get the data from the pointed-to record.
- */
-extern int xfs_alloc_get_rec(struct xfs_btree_cur *cur,	xfs_agblock_t *bno,
-				xfs_extlen_t *len, int *stat);
-
 
 extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *,
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2008-08-04 01:03:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2008-08-04 01:11:38.000000000 +0200
@@ -192,6 +192,29 @@ xfs_inobt_update(
 }
 
 /*
+ * Get the data from the pointed-to record.
+ */
+int					/* error */
+xfs_inobt_get_rec(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agino_t		*ino,	/* output: starting inode of chunk */
+	__int32_t		*fcnt,	/* output: number of free inodes */
+	xfs_inofree_t		*free,	/* output: free inode mask */
+	int			*stat)	/* output: success/failure */
+{
+	union xfs_btree_rec	*rec;
+	int			error;
+
+	error = xfs_btree_getrec(cur, &rec, stat);
+	if (!error && *stat == 1) {
+		*ino = be32_to_cpu(rec->inobt.ir_startino);
+		*fcnt = be32_to_cpu(rec->inobt.ir_freecount);
+		*free = be64_to_cpu(rec->inobt.ir_free);
+	}
+	return error;
+}
+
+/*
  * Allocate new inodes in the allocation group specified by agbp.
  * Return 0 for success, else error code.
  */
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c	2008-08-04 01:03:31.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c	2008-08-04 01:11:38.000000000 +0200
@@ -41,51 +41,6 @@
 #include "xfs_error.h"
 
 
-/*
- * Get the data from the pointed-to record.
- */
-int					/* error */
-xfs_inobt_get_rec(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agino_t		*ino,	/* output: starting inode of chunk */
-	__int32_t		*fcnt,	/* output: number of free inodes */
-	xfs_inofree_t		*free,	/* output: free inode mask */
-	int			*stat)	/* output: success/failure */
-{
-	xfs_inobt_block_t	*block;	/* btree block */
-	xfs_buf_t		*bp;	/* buffer containing btree block */
-#ifdef DEBUG
-	int			error;	/* error return value */
-#endif
-	int			ptr;	/* record number */
-	xfs_inobt_rec_t		*rec;	/* record data */
-
-	bp = cur->bc_bufs[0];
-	ptr = cur->bc_ptrs[0];
-	block = XFS_BUF_TO_INOBT_BLOCK(bp);
-#ifdef DEBUG
-	if ((error = xfs_btree_check_sblock(cur, block, 0, bp)))
-		return error;
-#endif
-	/*
-	 * Off the right end or left end, return failure.
-	 */
-	if (ptr > be16_to_cpu(block->bb_numrecs) || ptr <= 0) {
-		*stat = 0;
-		return 0;
-	}
-	/*
-	 * Point to the record and extract its data.
-	 */
-	rec = XFS_INOBT_REC_ADDR(block, ptr, cur);
-	*ino = be32_to_cpu(rec->ir_startino);
-	*fcnt = be32_to_cpu(rec->ir_freecount);
-	*free = be64_to_cpu(rec->ir_free);
-	*stat = 1;
-	return 0;
-}
-
-
 STATIC struct xfs_btree_cur *
 xfs_inobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.h	2008-08-04 01:03:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h	2008-08-04 01:11:38.000000000 +0200
@@ -116,13 +116,6 @@ typedef	struct xfs_btree_sblock xfs_inob
 	(XFS_BTREE_PTR_ADDR(xfs_inobt, bb, \
 				i, XFS_INOBT_BLOCK_MAXRECS(1, cur)))
 
-/*
- * Get the data from the pointed-to record.
- */
-extern int xfs_inobt_get_rec(struct xfs_btree_cur *cur, xfs_agino_t *ino,
-			     __int32_t *fcnt, xfs_inofree_t *free, int *stat);
-
-
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t);
 
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.h	2008-08-04 00:11:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.h	2008-08-04 01:11:38.000000000 +0200
@@ -168,6 +168,11 @@ int xfs_inobt_lookup_ge(struct xfs_btree
 int xfs_inobt_lookup_le(struct xfs_btree_cur *cur, xfs_agino_t ino,
 		__int32_t fcnt,	xfs_inofree_t free, int *stat);
 
+/*
+ * Get the data from the pointed-to record.
+ */
+extern int xfs_inobt_get_rec(struct xfs_btree_cur *cur, xfs_agino_t *ino,
+			     __int32_t *fcnt, xfs_inofree_t *free, int *stat);
 
 #endif	/* __KERNEL__ */
 

-- 
