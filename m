Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 18:34:58 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m741YlLE001575
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 18:34:47 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1A3A197645B
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2008 18:36:01 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Uj1KT8Zht7HxsS4f for <xfs@oss.sgi.com>; Sun, 03 Aug 2008 18:36:01 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m741a2IF009347
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 03:36:02 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m741a2Ji009345
	for xfs@oss.sgi.com; Mon, 4 Aug 2008 03:36:02 +0200
Date: Mon, 4 Aug 2008 03:36:02 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 25/26] kill xfs_bmbt_log_block
Message-ID: <20080804013602.GZ8819@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-kill-xfs_bmbt_log_block
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Only one caller left, which can just use xfs_btree_log_block if we export it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2008-08-04 01:20:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2008-08-04 01:21:46.000000000 +0200
@@ -44,34 +44,6 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 
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
 
 /*
  * Determine the extent state.
@@ -261,40 +233,6 @@ xfs_bmbt_disk_get_startoff(
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
  * Set all the fields in a bmap extent record from the arguments.
  */
 void
Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-04 01:20:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-04 01:21:46.000000000 +0200
@@ -1139,7 +1139,7 @@ xfs_btree_log_ptrs(
 /*
  * Log fields from the short from btree block header.
  */
-STATIC void
+void
 xfs_btree_log_block(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	struct xfs_buf		*bp,	/* buffer containing btree block */
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-08-04 01:20:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-08-04 01:21:46.000000000 +0200
@@ -3563,7 +3563,7 @@ xfs_bmap_extents_to_btree(
 	 * Do all this logging at the end so that
 	 * the root is at the right level.
 	 */
-	xfs_bmbt_log_block(cur, abp, XFS_BB_ALL_BITS);
+	xfs_btree_log_block(cur, abp, XFS_BB_ALL_BITS);
 	xfs_bmbt_log_recs(cur, abp, 1, be16_to_cpu(ablock->bb_numrecs));
 	ASSERT(*curp == NULL);
 	*curp = cur;
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-08-04 01:21:53.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-08-04 01:22:37.000000000 +0200
@@ -605,6 +605,11 @@ int xfs_btree_insert(struct xfs_btree_cu
 int xfs_btree_delete(struct xfs_btree_cur *, int *);
 int xfs_btree_getrec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
 
+/*
+ * Internal btree helpers also used by xfs_bmap.c.
+ */
+void xfs_btree_log_block(struct xfs_btree_cur *, struct xfs_buf *, int);
+
 
 /*
  * Helpers.

-- 
