Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 13:46:58 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6FKksbm002110
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 13:46:56 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6FKkuNK017270
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 22:46:56 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6FKkuPK017268
	for xfs@oss.sgi.com; Sun, 15 Jul 2007 22:46:56 +0200
Date: Sun, 15 Jul 2007 22:46:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] endianess annotations for xfs_bmbt_rec_t
Message-ID: <20070715204656.GE17069@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2007-07-15 16:39:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2007-07-15 16:39:58.000000000 +0200
@@ -3492,8 +3492,8 @@ xfs_bmap_extents_to_btree(
 	for (cnt = i = 0; i < nextents; i++) {
 		ep = xfs_iext_get_ext(ifp, i);
 		if (!ISNULLSTARTBLOCK(xfs_bmbt_get_startblock(ep))) {
-			arp->l0 = INT_GET(ep->l0, ARCH_CONVERT);
-			arp->l1 = INT_GET(ep->l1, ARCH_CONVERT);
+			arp->l0 = cpu_to_be64(ep->l0);
+			arp->l1 = cpu_to_be64(ep->l1);
 			arp++; cnt++;
 		}
 	}
@@ -4566,8 +4566,8 @@ xfs_bmap_read_extents(
 		start = i;
 		for (j = 0; j < num_recs; j++, i++, frp++) {
 			xfs_bmbt_rec_host_t *trp = xfs_iext_get_ext(ifp, i);
-			trp->l0 = INT_GET(frp->l0, ARCH_CONVERT);
-			trp->l1 = INT_GET(frp->l1, ARCH_CONVERT);
+			trp->l0 = be64_to_cpu(frp->l0);
+			trp->l1 = be64_to_cpu(frp->l1);
 		}
 		if (exntf == XFS_EXTFMT_NOSTATE) {
 			/*
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c	2007-07-15 16:39:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c	2007-07-15 16:42:47.000000000 +0200
@@ -1914,19 +1914,13 @@ xfs_bmbt_get_state(
 				ext_flag);
 }
 
-#ifndef XFS_NATIVE_HOST
 /* Endian flipping versions of the bmbt extraction functions */
 void
 xfs_bmbt_disk_get_all(
 	xfs_bmbt_rec_t	*r,
 	xfs_bmbt_irec_t *s)
 {
-	__uint64_t	l0, l1;
-
-	l0 = INT_GET(r->l0, ARCH_CONVERT);
-	l1 = INT_GET(r->l1, ARCH_CONVERT);
-
-	__xfs_bmbt_get_all(l0, l1, s);
+	__xfs_bmbt_get_all(be64_to_cpu(r->l0), be64_to_cpu(r->l1), s);
 }
 
 /*
@@ -1936,7 +1930,7 @@ xfs_filblks_t
 xfs_bmbt_disk_get_blockcount(
 	xfs_bmbt_rec_t	*r)
 {
-	return (xfs_filblks_t)(INT_GET(r->l1, ARCH_CONVERT) & XFS_MASK64LO(21));
+	return (xfs_filblks_t)(be64_to_cpu(r->l1) & XFS_MASK64LO(21));
 }
 
 /*
@@ -1946,11 +1940,9 @@ xfs_fileoff_t
 xfs_bmbt_disk_get_startoff(
 	xfs_bmbt_rec_t	*r)
 {
-	return ((xfs_fileoff_t)INT_GET(r->l0, ARCH_CONVERT) &
+	return ((xfs_fileoff_t)be64_to_cpu(r->l0) &
 		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 }
-#endif /* XFS_NATIVE_HOST */
-
 
 /*
  * Increment cursor by one record at the level.
@@ -2348,7 +2340,6 @@ xfs_bmbt_set_all(
 }
 
 
-#ifndef XFS_NATIVE_HOST
 /*
  * Set all the fields in a disk format bmap extent record from the arguments.
  */
@@ -2369,29 +2360,29 @@ xfs_bmbt_disk_set_allf(
 #if XFS_BIG_BLKNOS
 	ASSERT((startblock & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
 
-	INT_SET(r->l0, ARCH_CONVERT,
+	r->l0 = cpu_to_be64(
 		((xfs_bmbt_rec_base_t)extent_flag << 63) |
 		 ((xfs_bmbt_rec_base_t)startoff << 9) |
 		 ((xfs_bmbt_rec_base_t)startblock >> 43));
-	INT_SET(r->l1, ARCH_CONVERT,
+	r->l1 = cpu_to_be64(
 		((xfs_bmbt_rec_base_t)startblock << 21) |
 		 ((xfs_bmbt_rec_base_t)blockcount &
 		  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
 #else	/* !XFS_BIG_BLKNOS */
 	if (ISNULLSTARTBLOCK(b)) {
-		INT_SET(r->l0, ARCH_CONVERT,
+		r->l0 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			 ((xfs_bmbt_rec_base_t)startoff << 9) |
 			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
-		INT_SET(r->l1, ARCH_CONVERT, XFS_MASK64HI(11) |
+		r->l1 = cpu_to_be64(XFS_MASK64HI(11) |
 			  ((xfs_bmbt_rec_base_t)startblock << 21) |
 			  ((xfs_bmbt_rec_base_t)blockcount &
 			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
 	} else {
-		INT_SET(r->l0, ARCH_CONVERT,
+		r->l0 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			 ((xfs_bmbt_rec_base_t)startoff << 9));
-		INT_SET(r->l1, ARCH_CONVERT,
+		r->l1 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)startblock << 21) |
 			 ((xfs_bmbt_rec_base_t)blockcount &
 			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
@@ -2410,7 +2401,6 @@ xfs_bmbt_disk_set_all(
 	xfs_bmbt_disk_set_allf(r, s->br_startoff, s->br_startblock,
 				  s->br_blockcount, s->br_state);
 }
-#endif /* XFS_NATIVE_HOST */
 
 /*
  * Set the blockcount field in a bmap extent record.
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2007-07-15 16:39:57.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2007-07-15 16:39:58.000000000 +0200
@@ -54,7 +54,7 @@ typedef struct xfs_bmbt_rec_32
 } xfs_bmbt_rec_32_t;
 typedef struct xfs_bmbt_rec_64
 {
-	__uint64_t		l0, l1;
+	__be64			l0, l1;
 } xfs_bmbt_rec_64_t;
 
 typedef __uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
@@ -264,15 +264,9 @@ extern xfs_fsblock_t xfs_bmbt_get_startb
 extern xfs_fileoff_t xfs_bmbt_get_startoff(xfs_bmbt_rec_host_t *r);
 extern xfs_exntst_t xfs_bmbt_get_state(xfs_bmbt_rec_host_t *r);
 
-#ifndef XFS_NATIVE_HOST
 extern void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
-#else
-#define xfs_bmbt_disk_get_all(r, s)	xfs_bmbt_get_all(r, s)
-#define xfs_bmbt_disk_get_blockcount(r)	xfs_bmbt_get_blockcount(r)
-#define xfs_bmbt_disk_get_startoff(r)	xfs_bmbt_get_startoff(r)
-#endif /* XFS_NATIVE_HOST */
 
 extern int xfs_bmbt_increment(struct xfs_btree_cur *, int, int *);
 extern int xfs_bmbt_insert(struct xfs_btree_cur *, int *);
@@ -298,14 +292,9 @@ extern void xfs_bmbt_set_startblock(xfs_
 extern void xfs_bmbt_set_startoff(xfs_bmbt_rec_host_t *r, xfs_fileoff_t v);
 extern void xfs_bmbt_set_state(xfs_bmbt_rec_host_t *r, xfs_exntst_t v);
 
-#ifndef XFS_NATIVE_HOST
 extern void xfs_bmbt_disk_set_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
 extern void xfs_bmbt_disk_set_allf(xfs_bmbt_rec_t *r, xfs_fileoff_t o,
 			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
-#else
-#define xfs_bmbt_disk_set_all(r, s)		xfs_bmbt_set_all(r, s)
-#define xfs_bmbt_disk_set_allf(r, o, b, c, v)	xfs_bmbt_set_allf(r, o, b, c, v)
-#endif /* XFS_NATIVE_HOST */
 
 extern void xfs_bmbt_to_bmdr(xfs_bmbt_block_t *, int, xfs_bmdr_block_t *, int);
 extern int xfs_bmbt_update(struct xfs_btree_cur *, xfs_fileoff_t,
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2007-07-15 16:39:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2007-07-15 16:39:58.000000000 +0200
@@ -634,10 +634,8 @@ xfs_iformat_extents(
 		xfs_validate_extents(ifp, nex, XFS_EXTFMT_INODE(ip));
 		for (i = 0; i < nex; i++, dp++) {
 			xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
-			ep->l0 = INT_GET(get_unaligned((__uint64_t*)&dp->l0),
-								ARCH_CONVERT);
-			ep->l1 = INT_GET(get_unaligned((__uint64_t*)&dp->l1),
-								ARCH_CONVERT);
+			ep->l0 = be64_to_cpu(get_unaligned(&dp->l0));
+			ep->l1 = be64_to_cpu(get_unaligned(&dp->l1));
 		}
 		XFS_BMAP_TRACE_EXLIST(ip, nex, whichfork);
 		if (whichfork != XFS_DATA_FORK ||
@@ -2916,10 +2914,8 @@ xfs_iextents_copy(
 		}
 
 		/* Translate to on disk format */
-		put_unaligned(INT_GET(ep->l0, ARCH_CONVERT),
-			      (__uint64_t*)&dp->l0);
-		put_unaligned(INT_GET(ep->l1, ARCH_CONVERT),
-			      (__uint64_t*)&dp->l1);
+		put_unaligned(cpu_to_be64(ep->l0), &dp->l0);
+		put_unaligned(cpu_to_be64(ep->l1), &dp->l1);
 		dp++;
 		copied++;
 	}
