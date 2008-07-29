Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jul 2008 12:29:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6TJTM59031556
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:29:22 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EEA9ECE21F
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:33 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id JtOqQV0RmepM2dP3 for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 12:30:33 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6TJUYIF019217
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2008 21:30:34 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6TJUYqO019215
	for xfs@oss.sgi.com; Tue, 29 Jul 2008 21:30:34 +0200
Date: Tue, 29 Jul 2008 21:30:34 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/21] refactor btree validation helpers
Message-ID: <20080729193034.GG19104@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-btree-check-refactor
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Move the various btree validation helpers around in xfs_btree.c so that
they are close to each other and in common #ifdef DEBUG sections.

Also add a new xfs_btree_check_ptr helper to check a btree ptr that
can be either long or short form.

Split out from a bigger patch from Dave Chinner with various small
changes applied by me.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-14 18:02:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-14 18:08:27.000000000 +0200
@@ -81,24 +81,6 @@ xfs_btree_maxrecs(
 
 #ifdef DEBUG
 /*
- * Debug routine: check that block header is ok.
- */
-void
-xfs_btree_check_block(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_block_t	*block,	/* generic btree block pointer */
-	int			level,	/* level of the btree block */
-	xfs_buf_t		*bp)	/* buffer containing block, if any */
-{
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		xfs_btree_check_lblock(cur, (xfs_btree_lblock_t *)block, level,
-			bp);
-	else
-		xfs_btree_check_sblock(cur, (xfs_btree_sblock_t *)block, level,
-			bp);
-}
-
-/*
  * Debug routine: check that keys are in the right order.
  */
 void
@@ -150,66 +132,8 @@ xfs_btree_check_key(
 		ASSERT(0);
 	}
 }
-#endif	/* DEBUG */
 
 /*
- * Checking routine: check that long form block header is ok.
- */
-/* ARGSUSED */
-int					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_lblock(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_lblock_t	*block,	/* btree long form block pointer */
-	int			level,	/* level of the btree block */
-	xfs_buf_t		*bp)	/* buffer for block, if any */
-{
-	int			lblock_ok; /* block passes checks */
-	xfs_mount_t		*mp;	/* file system mount point */
-
-	mp = cur->bc_mp;
-	lblock_ok =
-		be32_to_cpu(block->bb_magic) == xfs_magics[cur->bc_btnum] &&
-		be16_to_cpu(block->bb_level) == level &&
-		be16_to_cpu(block->bb_numrecs) <=
-			xfs_btree_maxrecs(cur, (xfs_btree_block_t *)block) &&
-		block->bb_leftsib &&
-		(be64_to_cpu(block->bb_leftsib) == NULLDFSBNO ||
-		 XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_leftsib))) &&
-		block->bb_rightsib &&
-		(be64_to_cpu(block->bb_rightsib) == NULLDFSBNO ||
-		 XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_rightsib)));
-	if (unlikely(XFS_TEST_ERROR(!lblock_ok, mp, XFS_ERRTAG_BTREE_CHECK_LBLOCK,
-			XFS_RANDOM_BTREE_CHECK_LBLOCK))) {
-		if (bp)
-			xfs_buftrace("LBTREE ERROR", bp);
-		XFS_ERROR_REPORT("xfs_btree_check_lblock", XFS_ERRLEVEL_LOW,
-				 mp);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
-	return 0;
-}
-
-/*
- * Checking routine: check that (long) pointer is ok.
- */
-int					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_lptr(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	xfs_dfsbno_t	ptr,		/* btree block disk address */
-	int		level)		/* btree block level */
-{
-	xfs_mount_t	*mp;		/* file system mount point */
-
-	mp = cur->bc_mp;
-	XFS_WANT_CORRUPTED_RETURN(
-		level > 0 &&
-		ptr != NULLDFSBNO &&
-		XFS_FSB_SANITY_CHECK(mp, ptr));
-	return 0;
-}
-
-#ifdef DEBUG
-/*
  * Debug routine: check that records are in the right order.
  */
 void
@@ -268,10 +192,39 @@ xfs_btree_check_rec(
 }
 #endif	/* DEBUG */
 
-/*
- * Checking routine: check that block header is ok.
- */
-/* ARGSUSED */
+int					/* error (0 or EFSCORRUPTED) */
+xfs_btree_check_lblock(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_btree_lblock_t	*block,	/* btree long form block pointer */
+	int			level,	/* level of the btree block */
+	xfs_buf_t		*bp)	/* buffer for block, if any */
+{
+	int			lblock_ok; /* block passes checks */
+	xfs_mount_t		*mp;	/* file system mount point */
+
+	mp = cur->bc_mp;
+	lblock_ok =
+		be32_to_cpu(block->bb_magic) == xfs_magics[cur->bc_btnum] &&
+		be16_to_cpu(block->bb_level) == level &&
+		be16_to_cpu(block->bb_numrecs) <=
+			xfs_btree_maxrecs(cur, (xfs_btree_block_t *)block) &&
+		block->bb_leftsib &&
+		(be64_to_cpu(block->bb_leftsib) == NULLDFSBNO ||
+		 XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_leftsib))) &&
+		block->bb_rightsib &&
+		(be64_to_cpu(block->bb_rightsib) == NULLDFSBNO ||
+		 XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_rightsib)));
+	if (unlikely(XFS_TEST_ERROR(!lblock_ok, mp, XFS_ERRTAG_BTREE_CHECK_LBLOCK,
+			XFS_RANDOM_BTREE_CHECK_LBLOCK))) {
+		if (bp)
+			xfs_buftrace("LBTREE ERROR", bp);
+		XFS_ERROR_REPORT("xfs_btree_check_lblock", XFS_ERRLEVEL_LOW,
+				 mp);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+	return 0;
+}
+
 int					/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_sblock(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
@@ -311,27 +264,81 @@ xfs_btree_check_sblock(
 }
 
 /*
- * Checking routine: check that (short) pointer is ok.
+ * Debug routine: check that block header is ok.
+ */
+int
+xfs_btree_check_block(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_btree_block_t	*block,	/* generic btree block pointer */
+	int			level,	/* level of the btree block */
+	xfs_buf_t		*bp)	/* buffer containing block, if any */
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		return xfs_btree_check_lblock(cur, (xfs_btree_lblock_t *)block,
+					      level, bp);
+	}
+
+	return xfs_btree_check_sblock(cur, (xfs_btree_sblock_t *)block,
+				      level, bp);
+}
+
+/*
+ * Check that (long) pointer is ok.
  */
 int					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_sptr(
+xfs_btree_check_lptr(
 	xfs_btree_cur_t	*cur,		/* btree cursor */
-	xfs_agblock_t	ptr,		/* btree block disk address */
+	xfs_dfsbno_t	bno,		/* btree block disk address */
 	int		level)		/* btree block level */
 {
-	xfs_buf_t	*agbp;		/* buffer for ag. freespace struct */
-	xfs_agf_t	*agf;		/* ag. freespace structure */
+	xfs_mount_t	*mp;		/* file system mount point */
+
+	mp = cur->bc_mp;
+	XFS_WANT_CORRUPTED_RETURN(
+		level > 0 &&
+		bno != NULLDFSBNO &&
+		XFS_FSB_SANITY_CHECK(mp, bno));
+	return 0;
+}
+
+/*
+ * Check that (short) pointer is ok.
+ */
+int					/* error (0 or EFSCORRUPTED) */
+xfs_btree_check_sptr(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* btree block disk address */
+	int			level)	/* btree block level */
+{
+	xfs_agblock_t		agblocks = cur->bc_mp->m_sb.sb_agblocks;
 
-	agbp = cur->bc_private.a.agbp;
-	agf = XFS_BUF_TO_AGF(agbp);
 	XFS_WANT_CORRUPTED_RETURN(
 		level > 0 &&
-		ptr != NULLAGBLOCK && ptr != 0 &&
-		ptr < be32_to_cpu(agf->agf_length));
+		bno != NULLAGBLOCK &&
+		bno != 0 &&
+		bno < agblocks);
 	return 0;
 }
 
 /*
+ * Check that block ptr is ok.
+ */
+int					/* error (0 or EFSCORRUPTED) */
+xfs_btree_check_ptr(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	union xfs_btree_ptr	*ptr,	/* btree block disk address */
+	int			index,	/* offset from ptr to check */
+	int			level)	/* btree block level */
+{
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		return xfs_btree_check_lptr(cur,
+					    be64_to_cpu((&ptr->l)[index]),
+					    level);
+	}
+	return xfs_btree_check_sptr(cur, be32_to_cpu((&ptr->s)[index]), level);
+}
+
+/*
  * Delete the btree cursor.
  */
 void
Index: linux-2.6-xfs/fs/xfs/xfs_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_btree.h	2008-07-14 18:02:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_btree.h	2008-07-14 18:07:55.000000000 +0200
@@ -223,52 +223,38 @@ typedef struct xfs_btree_cur
 
 #ifdef __KERNEL__
 
-#ifdef DEBUG
 /*
- * Debug routine: check that block header is ok.
+ * Check that long form block header is ok.
  */
-void
-xfs_btree_check_block(
+int					/* error (0 or EFSCORRUPTED) */
+xfs_btree_check_lblock(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_block_t	*block,	/* generic btree block pointer */
+	xfs_btree_lblock_t	*block,	/* btree long form block pointer */
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp);	/* buffer containing block, if any */
 
 /*
- * Debug routine: check that keys are in the right order.
- */
-void
-xfs_btree_check_key(
-	xfs_btnum_t		btnum,	/* btree identifier */
-	void			*ak1,	/* pointer to left (lower) key */
-	void			*ak2);	/* pointer to right (higher) key */
-
-/*
- * Debug routine: check that records are in the right order.
+ * Check that short form block header is ok.
  */
-void
-xfs_btree_check_rec(
-	xfs_btnum_t		btnum,	/* btree identifier */
-	void			*ar1,	/* pointer to left (lower) record */
-	void			*ar2);	/* pointer to right (higher) record */
-#else
-#define	xfs_btree_check_block(a,b,c,d)
-#define	xfs_btree_check_key(a,b,c)
-#define	xfs_btree_check_rec(a,b,c)
-#endif	/* DEBUG */
+int					/* error (0 or EFSCORRUPTED) */
+xfs_btree_check_sblock(
+	xfs_btree_cur_t		*cur,	/* btree cursor */
+	xfs_btree_sblock_t	*block,	/* btree short form block pointer */
+	int			level,	/* level of the btree block */
+	struct xfs_buf		*bp);	/* buffer containing block */
 
 /*
- * Checking routine: check that long form block header is ok.
+ * Check that block header is ok.
  */
-int					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_lblock(
+int
+xfs_btree_check_block(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_lblock_t	*block,	/* btree long form block pointer */
+	xfs_btree_block_t	*block,	/* generic btree block pointer */
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp);	/* buffer containing block, if any */
 
 /*
- * Checking routine: check that (long) pointer is ok.
+ * Check that (long) pointer is ok.
  */
 int					/* error (0 or EFSCORRUPTED) */
 xfs_btree_check_lptr(
@@ -279,25 +265,50 @@ xfs_btree_check_lptr(
 #define xfs_btree_check_lptr_disk(cur, ptr, level) \
 	xfs_btree_check_lptr(cur, be64_to_cpu(ptr), level)
 
+
 /*
- * Checking routine: check that short form block header is ok.
+ * Check that (short) pointer is ok.
  */
 int					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_sblock(
+xfs_btree_check_sptr(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_btree_sblock_t	*block,	/* btree short form block pointer */
-	int			level,	/* level of the btree block */
-	struct xfs_buf		*bp);	/* buffer containing block */
+	xfs_agblock_t		ptr,	/* btree block disk address */
+	int			level);	/* btree block level */
 
 /*
- * Checking routine: check that (short) pointer is ok.
+ * Check that (short) pointer is ok.
  */
 int					/* error (0 or EFSCORRUPTED) */
-xfs_btree_check_sptr(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	xfs_agblock_t		ptr,	/* btree block disk address */
+xfs_btree_check_ptr(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	union xfs_btree_ptr	*ptr,	/* btree block disk address */
+	int			index,	/* offset from ptr to check */
 	int			level);	/* btree block level */
 
+#ifdef DEBUG
+
+/*
+ * Debug routine: check that keys are in the right order.
+ */
+void
+xfs_btree_check_key(
+	xfs_btnum_t		btnum,	/* btree identifier */
+	void			*ak1,	/* pointer to left (lower) key */
+	void			*ak2);	/* pointer to right (higher) key */
+
+/*
+ * Debug routine: check that records are in the right order.
+ */
+void
+xfs_btree_check_rec(
+	xfs_btnum_t		btnum,	/* btree identifier */
+	void			*ar1,	/* pointer to left (lower) record */
+	void			*ar2);	/* pointer to right (higher) record */
+#else
+#define	xfs_btree_check_key(a,b,c)
+#define	xfs_btree_check_rec(a,b,c)
+#endif	/* DEBUG */
+
 /*
  * Delete the btree cursor.
  */

-- 
