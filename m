Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 13:44:20 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6FKiFbm032584
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 13:44:17 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6FKiHNK017200
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 22:44:17 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6FKiHEi017198
	for xfs@oss.sgi.com; Sun, 15 Jul 2007 22:44:17 +0200
Date: Sun, 15 Jul 2007 22:44:17 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] clean up xfs_bmbt_set_all/xfs_bmbt_disk_set_all
Message-ID: <20070715204417.GC17069@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_bmbt_set_all/xfs_bmbt_disk_set_all are indentical to
xfs_bmbt_set_allf/xfs_bmbt_disk_set_allf except that the former take
a xfs_bmbt_irec_t and the latter take the individual extent fields
as scalar values.

This patch reimplements xfs_bmbt_set_all/xfs_bmbt_disk_set_all as
trivial wrappers around xfs_bmbt_set_allf/xfs_bmbt_disk_set_allf and
cleans up the variable naming in xfs_bmbt_set_allf/xfs_bmbt_disk_set_allf
to have some meaning instead of one char variable names.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2007-07-14 19:28:02.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2007-07-14 19:29:11.000000000 +0200
@@ -2291,177 +2291,125 @@ xfs_bmbt_newroot(
 }
 
 /*
- * Set all the fields in a bmap extent record from the uncompressed form.
- */
-void
-xfs_bmbt_set_all(
-	xfs_bmbt_rec_host_t *r,
-	xfs_bmbt_irec_t	*s)
-{
-	int	extent_flag;
-
-	ASSERT((s->br_state == XFS_EXT_NORM) ||
-		(s->br_state == XFS_EXT_UNWRITTEN));
-	extent_flag = (s->br_state == XFS_EXT_NORM) ? 0 : 1;
-	ASSERT((s->br_startoff & XFS_MASK64HI(9)) == 0);
-	ASSERT((s->br_blockcount & XFS_MASK64HI(43)) == 0);
-#if XFS_BIG_BLKNOS
-	ASSERT((s->br_startblock & XFS_MASK64HI(12)) == 0);
-	r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-		 ((xfs_bmbt_rec_base_t)s->br_startoff << 9) |
-		 ((xfs_bmbt_rec_base_t)s->br_startblock >> 43);
-	r->l1 = ((xfs_bmbt_rec_base_t)s->br_startblock << 21) |
-		 ((xfs_bmbt_rec_base_t)s->br_blockcount &
-		 (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
-#else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(s->br_startblock)) {
-		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			((xfs_bmbt_rec_base_t)s->br_startoff << 9) |
-			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
-		r->l1 = XFS_MASK64HI(11) |
-			  ((xfs_bmbt_rec_base_t)s->br_startblock << 21) |
-			  ((xfs_bmbt_rec_base_t)s->br_blockcount &
-			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
-	} else {
-		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			((xfs_bmbt_rec_base_t)s->br_startoff << 9);
-		r->l1 = ((xfs_bmbt_rec_base_t)s->br_startblock << 21) |
-			  ((xfs_bmbt_rec_base_t)s->br_blockcount &
-			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
-	}
-#endif	/* XFS_BIG_BLKNOS */
-}
-
-/*
  * Set all the fields in a bmap extent record from the arguments.
  */
 void
 xfs_bmbt_set_allf(
-	xfs_bmbt_rec_host_t *r,
-	xfs_fileoff_t	o,
-	xfs_fsblock_t	b,
-	xfs_filblks_t	c,
-	xfs_exntst_t	v)
+	xfs_bmbt_rec_host_t	*r,
+	xfs_fileoff_t		startoff,
+	xfs_fsblock_t		startblock,
+	xfs_filblks_t		blockcount,
+	xfs_exntst_t		state)
 {
-	int	extent_flag;
+	int		extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
+
+	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
+	ASSERT((startoff & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
+	ASSERT((blockcount & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
 
-	ASSERT((v == XFS_EXT_NORM) || (v == XFS_EXT_UNWRITTEN));
-	extent_flag = (v == XFS_EXT_NORM) ? 0 : 1;
-	ASSERT((o & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
-	ASSERT((c & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
 #if XFS_BIG_BLKNOS
-	ASSERT((b & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+	ASSERT((startblock & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+
 	r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-		((xfs_bmbt_rec_base_t)o << 9) |
-		((xfs_bmbt_rec_base_t)b >> 43);
-	r->l1 = ((xfs_bmbt_rec_base_t)b << 21) |
-		((xfs_bmbt_rec_base_t)c &
+		((xfs_bmbt_rec_base_t)startoff << 9) |
+		((xfs_bmbt_rec_base_t)startblock >> 43);
+	r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
+		((xfs_bmbt_rec_base_t)blockcount &
 		(xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
 #else	/* !XFS_BIG_BLKNOS */
 	if (ISNULLSTARTBLOCK(b)) {
 		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			((xfs_bmbt_rec_base_t)o << 9) |
+			((xfs_bmbt_rec_base_t)startoff << 9) |
 			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
 		r->l1 = XFS_MASK64HI(11) |
-			  ((xfs_bmbt_rec_base_t)b << 21) |
-			  ((xfs_bmbt_rec_base_t)c &
+			  ((xfs_bmbt_rec_base_t)startblock << 21) |
+			  ((xfs_bmbt_rec_base_t)blockcount &
 			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
 	} else {
 		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			((xfs_bmbt_rec_base_t)o << 9);
-		r->l1 = ((xfs_bmbt_rec_base_t)b << 21) |
-			 ((xfs_bmbt_rec_base_t)c &
+			((xfs_bmbt_rec_base_t)startoff << 9);
+		r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
+			 ((xfs_bmbt_rec_base_t)blockcount &
 			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
 	}
 #endif	/* XFS_BIG_BLKNOS */
 }
 
-#ifndef XFS_NATIVE_HOST
 /*
  * Set all the fields in a bmap extent record from the uncompressed form.
  */
 void
-xfs_bmbt_disk_set_all(
-	xfs_bmbt_rec_t	*r,
-	xfs_bmbt_irec_t *s)
+xfs_bmbt_set_all(
+	xfs_bmbt_rec_host_t *r,
+	xfs_bmbt_irec_t	*s)
 {
-	int	extent_flag;
-
-	ASSERT((s->br_state == XFS_EXT_NORM) ||
-		(s->br_state == XFS_EXT_UNWRITTEN));
-	extent_flag = (s->br_state == XFS_EXT_NORM) ? 0 : 1;
-	ASSERT((s->br_startoff & XFS_MASK64HI(9)) == 0);
-	ASSERT((s->br_blockcount & XFS_MASK64HI(43)) == 0);
-#if XFS_BIG_BLKNOS
-	ASSERT((s->br_startblock & XFS_MASK64HI(12)) == 0);
-	INT_SET(r->l0, ARCH_CONVERT, ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-		  ((xfs_bmbt_rec_base_t)s->br_startoff << 9) |
-		  ((xfs_bmbt_rec_base_t)s->br_startblock >> 43));
-	INT_SET(r->l1, ARCH_CONVERT, ((xfs_bmbt_rec_base_t)s->br_startblock << 21) |
-		  ((xfs_bmbt_rec_base_t)s->br_blockcount &
-		   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
-#else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(s->br_startblock)) {
-		INT_SET(r->l0, ARCH_CONVERT, ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			((xfs_bmbt_rec_base_t)s->br_startoff << 9) |
-			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
-		INT_SET(r->l1, ARCH_CONVERT, XFS_MASK64HI(11) |
-			  ((xfs_bmbt_rec_base_t)s->br_startblock << 21) |
-			  ((xfs_bmbt_rec_base_t)s->br_blockcount &
-			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
-	} else {
-		INT_SET(r->l0, ARCH_CONVERT, ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			((xfs_bmbt_rec_base_t)s->br_startoff << 9));
-		INT_SET(r->l1, ARCH_CONVERT, ((xfs_bmbt_rec_base_t)s->br_startblock << 21) |
-			  ((xfs_bmbt_rec_base_t)s->br_blockcount &
-			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
-	}
-#endif	/* XFS_BIG_BLKNOS */
+	xfs_bmbt_set_allf(r, s->br_startoff, s->br_startblock,
+			     s->br_blockcount, s->br_state);
 }
 
+
+#ifndef XFS_NATIVE_HOST
 /*
  * Set all the fields in a disk format bmap extent record from the arguments.
  */
 void
 xfs_bmbt_disk_set_allf(
-	xfs_bmbt_rec_t	*r,
-	xfs_fileoff_t	o,
-	xfs_fsblock_t	b,
-	xfs_filblks_t	c,
-	xfs_exntst_t	v)
+	xfs_bmbt_rec_t		*r,
+	xfs_fileoff_t		startoff,
+	xfs_fsblock_t		startblock,
+	xfs_filblks_t		blockcount,
+	xfs_exntst_t		state)
 {
-	int	extent_flag;
+	int			extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
+
+	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
+	ASSERT((startoff & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
+	ASSERT((blockcount & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
 
-	ASSERT((v == XFS_EXT_NORM) || (v == XFS_EXT_UNWRITTEN));
-	extent_flag = (v == XFS_EXT_NORM) ? 0 : 1;
-	ASSERT((o & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
-	ASSERT((c & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
 #if XFS_BIG_BLKNOS
-	ASSERT((b & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
-	INT_SET(r->l0, ARCH_CONVERT, ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-		((xfs_bmbt_rec_base_t)o << 9) |
-		((xfs_bmbt_rec_base_t)b >> 43));
-	INT_SET(r->l1, ARCH_CONVERT, ((xfs_bmbt_rec_base_t)b << 21) |
-		  ((xfs_bmbt_rec_base_t)c &
-		   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
+	ASSERT((startblock & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+
+	INT_SET(r->l0, ARCH_CONVERT,
+		((xfs_bmbt_rec_base_t)extent_flag << 63) |
+		 ((xfs_bmbt_rec_base_t)startoff << 9) |
+		 ((xfs_bmbt_rec_base_t)startblock >> 43));
+	INT_SET(r->l1, ARCH_CONVERT,
+		((xfs_bmbt_rec_base_t)startblock << 21) |
+		 ((xfs_bmbt_rec_base_t)blockcount &
+		  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
 #else	/* !XFS_BIG_BLKNOS */
 	if (ISNULLSTARTBLOCK(b)) {
-		INT_SET(r->l0, ARCH_CONVERT, ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			((xfs_bmbt_rec_base_t)o << 9) |
-			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
+		INT_SET(r->l0, ARCH_CONVERT,
+			((xfs_bmbt_rec_base_t)extent_flag << 63) |
+			 ((xfs_bmbt_rec_base_t)startoff << 9) |
+			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
 		INT_SET(r->l1, ARCH_CONVERT, XFS_MASK64HI(11) |
-			  ((xfs_bmbt_rec_base_t)b << 21) |
-			  ((xfs_bmbt_rec_base_t)c &
+			  ((xfs_bmbt_rec_base_t)startblock << 21) |
+			  ((xfs_bmbt_rec_base_t)blockcount &
 			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
 	} else {
-		INT_SET(r->l0, ARCH_CONVERT, ((xfs_bmbt_rec_base_t)extent_flag << 63) |
-			((xfs_bmbt_rec_base_t)o << 9));
-		INT_SET(r->l1, ARCH_CONVERT, ((xfs_bmbt_rec_base_t)b << 21) |
-			  ((xfs_bmbt_rec_base_t)c &
-			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
+		INT_SET(r->l0, ARCH_CONVERT,
+			((xfs_bmbt_rec_base_t)extent_flag << 63) |
+			 ((xfs_bmbt_rec_base_t)startoff << 9));
+		INT_SET(r->l1, ARCH_CONVERT,
+			((xfs_bmbt_rec_base_t)startblock << 21) |
+			 ((xfs_bmbt_rec_base_t)blockcount &
+			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
 	}
 #endif	/* XFS_BIG_BLKNOS */
 }
+
+/*
+ * Set all the fields in a bmap extent record from the uncompressed form.
+ */
+void
+xfs_bmbt_disk_set_all(
+	xfs_bmbt_rec_t	*r,
+	xfs_bmbt_irec_t *s)
+{
+	xfs_bmbt_disk_set_allf(r, s->br_startoff, s->br_startblock,
+				  s->br_blockcount, s->br_state);
+}
 #endif /* XFS_NATIVE_HOST */
 
 /*
