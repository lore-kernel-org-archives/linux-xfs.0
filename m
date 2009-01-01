Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01MfUTl032023 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 16:41:30 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94EFE58688
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 14:41:28 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id zLONI8CiHB0F0zLA for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 14:41:28 -0800 (PST)
Message-Id: <20090101224057.464622607@sandeen.net>
References: <20090101224009.616367334@sandeen.net>
Date: Thu, 01 Jan 2009 16:40:12 -0600
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [patch 3/4] Remove macro-to-function indirections in the mask code
Content-Disposition: inline; filename=XFS_MASK_SHOUTING
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs/fs/xfs/xfs_bit.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bit.h
+++ xfs/fs/xfs/xfs_bit.h
@@ -23,24 +23,16 @@
  */
 
 /*
- * masks with n high/low bits set, 32-bit values & 64-bit values
+ * masks with n high/low bits set, 64-bit values
  */
-#define	XFS_MASK32HI(n)		xfs_mask32hi(n)
-static inline __uint32_t xfs_mask32hi(int n)
-{
-	return (__uint32_t)-1 << (32 - (n));
-}
-#define	XFS_MASK64HI(n)		xfs_mask64hi(n)
 static inline __uint64_t xfs_mask64hi(int n)
 {
 	return (__uint64_t)-1 << (64 - (n));
 }
-#define	XFS_MASK32LO(n)		xfs_mask32lo(n)
 static inline __uint32_t xfs_mask32lo(int n)
 {
 	return ((__uint32_t)1 << (n)) - 1;
 }
-#define	XFS_MASK64LO(n)		xfs_mask64lo(n)
 static inline __uint64_t xfs_mask64lo(int n)
 {
 	return ((__uint64_t)1 << (n)) - 1;
Index: xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_btree.c
+++ xfs/fs/xfs/xfs_bmap_btree.c
@@ -1827,16 +1827,16 @@ __xfs_bmbt_get_all(
 
 	ext_flag = (int)(l0 >> (64 - BMBT_EXNTFLAG_BITLEN));
 	s->br_startoff = ((xfs_fileoff_t)l0 &
-			   XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
+			   xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 #if XFS_BIG_BLKNOS
-	s->br_startblock = (((xfs_fsblock_t)l0 & XFS_MASK64LO(9)) << 43) |
+	s->br_startblock = (((xfs_fsblock_t)l0 & xfs_mask64lo(9)) << 43) |
 			   (((xfs_fsblock_t)l1) >> 21);
 #else
 #ifdef DEBUG
 	{
 		xfs_dfsbno_t	b;
 
-		b = (((xfs_dfsbno_t)l0 & XFS_MASK64LO(9)) << 43) |
+		b = (((xfs_dfsbno_t)l0 & xfs_mask64lo(9)) << 43) |
 		    (((xfs_dfsbno_t)l1) >> 21);
 		ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
 		s->br_startblock = (xfs_fsblock_t)b;
@@ -1845,7 +1845,7 @@ __xfs_bmbt_get_all(
 	s->br_startblock = (xfs_fsblock_t)(((xfs_dfsbno_t)l1) >> 21);
 #endif	/* DEBUG */
 #endif	/* XFS_BIG_BLKNOS */
-	s->br_blockcount = (xfs_filblks_t)(l1 & XFS_MASK64LO(21));
+	s->br_blockcount = (xfs_filblks_t)(l1 & xfs_mask64lo(21));
 	/* This is xfs_extent_state() in-line */
 	if (ext_flag) {
 		ASSERT(s->br_blockcount != 0);	/* saved for DMIG */
@@ -1895,7 +1895,7 @@ xfs_filblks_t
 xfs_bmbt_get_blockcount(
 	xfs_bmbt_rec_host_t	*r)
 {
-	return (xfs_filblks_t)(r->l1 & XFS_MASK64LO(21));
+	return (xfs_filblks_t)(r->l1 & xfs_mask64lo(21));
 }
 
 /*
@@ -1906,13 +1906,13 @@ xfs_bmbt_get_startblock(
 	xfs_bmbt_rec_host_t	*r)
 {
 #if XFS_BIG_BLKNOS
-	return (((xfs_fsblock_t)r->l0 & XFS_MASK64LO(9)) << 43) |
+	return (((xfs_fsblock_t)r->l0 & xfs_mask64lo(9)) << 43) |
 	       (((xfs_fsblock_t)r->l1) >> 21);
 #else
 #ifdef DEBUG
 	xfs_dfsbno_t	b;
 
-	b = (((xfs_dfsbno_t)r->l0 & XFS_MASK64LO(9)) << 43) |
+	b = (((xfs_dfsbno_t)r->l0 & xfs_mask64lo(9)) << 43) |
 	    (((xfs_dfsbno_t)r->l1) >> 21);
 	ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
 	return (xfs_fsblock_t)b;
@@ -1930,7 +1930,7 @@ xfs_bmbt_get_startoff(
 	xfs_bmbt_rec_host_t	*r)
 {
 	return ((xfs_fileoff_t)r->l0 &
-		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
+		 xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 }
 
 xfs_exntst_t
@@ -1960,7 +1960,7 @@ xfs_filblks_t
 xfs_bmbt_disk_get_blockcount(
 	xfs_bmbt_rec_t	*r)
 {
-	return (xfs_filblks_t)(be64_to_cpu(r->l1) & XFS_MASK64LO(21));
+	return (xfs_filblks_t)(be64_to_cpu(r->l1) & xfs_mask64lo(21));
 }
 
 /*
@@ -1971,7 +1971,7 @@ xfs_bmbt_disk_get_startoff(
 	xfs_bmbt_rec_t	*r)
 {
 	return ((xfs_fileoff_t)be64_to_cpu(r->l0) &
-		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
+		 xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 }
 
 /*
@@ -2331,33 +2331,33 @@ xfs_bmbt_set_allf(
 	int		extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
 
 	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
-	ASSERT((startoff & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
-	ASSERT((blockcount & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
+	ASSERT((startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)) == 0);
+	ASSERT((blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
 
 #if XFS_BIG_BLKNOS
-	ASSERT((startblock & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+	ASSERT((startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)) == 0);
 
 	r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
 		((xfs_bmbt_rec_base_t)startoff << 9) |
 		((xfs_bmbt_rec_base_t)startblock >> 43);
 	r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
 		((xfs_bmbt_rec_base_t)blockcount &
-		(xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+		(xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 #else	/* !XFS_BIG_BLKNOS */
 	if (ISNULLSTARTBLOCK(startblock)) {
 		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			((xfs_bmbt_rec_base_t)startoff << 9) |
-			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
-		r->l1 = XFS_MASK64HI(11) |
+			 (xfs_bmbt_rec_base_t)xfs_mask64lo(9);
+		r->l1 = xfs_mask64hi(11) |
 			  ((xfs_bmbt_rec_base_t)startblock << 21) |
 			  ((xfs_bmbt_rec_base_t)blockcount &
-			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+			   (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 	} else {
 		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			((xfs_bmbt_rec_base_t)startoff << 9);
 		r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
 			 ((xfs_bmbt_rec_base_t)blockcount &
-			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+			 (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 	}
 #endif	/* XFS_BIG_BLKNOS */
 }
@@ -2389,11 +2389,11 @@ xfs_bmbt_disk_set_allf(
 	int			extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
 
 	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
-	ASSERT((startoff & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
-	ASSERT((blockcount & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
+	ASSERT((startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)) == 0);
+	ASSERT((blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
 
 #if XFS_BIG_BLKNOS
-	ASSERT((startblock & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+	ASSERT((startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)) == 0);
 
 	r->l0 = cpu_to_be64(
 		((xfs_bmbt_rec_base_t)extent_flag << 63) |
@@ -2402,17 +2402,17 @@ xfs_bmbt_disk_set_allf(
 	r->l1 = cpu_to_be64(
 		((xfs_bmbt_rec_base_t)startblock << 21) |
 		 ((xfs_bmbt_rec_base_t)blockcount &
-		  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
+		  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
 #else	/* !XFS_BIG_BLKNOS */
 	if (ISNULLSTARTBLOCK(startblock)) {
 		r->l0 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			 ((xfs_bmbt_rec_base_t)startoff << 9) |
-			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
-		r->l1 = cpu_to_be64(XFS_MASK64HI(11) |
+			  (xfs_bmbt_rec_base_t)xfs_mask64lo(9));
+		r->l1 = cpu_to_be64(xfs_mask64hi(11) |
 			  ((xfs_bmbt_rec_base_t)startblock << 21) |
 			  ((xfs_bmbt_rec_base_t)blockcount &
-			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
+			   (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
 	} else {
 		r->l0 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)extent_flag << 63) |
@@ -2420,7 +2420,7 @@ xfs_bmbt_disk_set_allf(
 		r->l1 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)startblock << 21) |
 			 ((xfs_bmbt_rec_base_t)blockcount &
-			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
+			  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
 	}
 #endif	/* XFS_BIG_BLKNOS */
 }
@@ -2445,9 +2445,9 @@ xfs_bmbt_set_blockcount(
 	xfs_bmbt_rec_host_t *r,
 	xfs_filblks_t	v)
 {
-	ASSERT((v & XFS_MASK64HI(43)) == 0);
-	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64HI(43)) |
-		  (xfs_bmbt_rec_base_t)(v & XFS_MASK64LO(21));
+	ASSERT((v & xfs_mask64hi(43)) == 0);
+	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64hi(43)) |
+		  (xfs_bmbt_rec_base_t)(v & xfs_mask64lo(21));
 }
 
 /*
@@ -2459,21 +2459,21 @@ xfs_bmbt_set_startblock(
 	xfs_fsblock_t	v)
 {
 #if XFS_BIG_BLKNOS
-	ASSERT((v & XFS_MASK64HI(12)) == 0);
-	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t)XFS_MASK64HI(55)) |
+	ASSERT((v & xfs_mask64hi(12)) == 0);
+	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t)xfs_mask64hi(55)) |
 		  (xfs_bmbt_rec_base_t)(v >> 43);
-	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)) |
+	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21)) |
 		  (xfs_bmbt_rec_base_t)(v << 21);
 #else	/* !XFS_BIG_BLKNOS */
 	if (ISNULLSTARTBLOCK(v)) {
-		r->l0 |= (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
-		r->l1 = (xfs_bmbt_rec_base_t)XFS_MASK64HI(11) |
+		r->l0 |= (xfs_bmbt_rec_base_t)xfs_mask64lo(9);
+		r->l1 = (xfs_bmbt_rec_base_t)xfs_mask64hi(11) |
 			  ((xfs_bmbt_rec_base_t)v << 21) |
-			  (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+			  (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 	} else {
-		r->l0 &= ~(xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
+		r->l0 &= ~(xfs_bmbt_rec_base_t)xfs_mask64lo(9);
 		r->l1 = ((xfs_bmbt_rec_base_t)v << 21) |
-			  (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+			  (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 	}
 #endif	/* XFS_BIG_BLKNOS */
 }
@@ -2486,10 +2486,10 @@ xfs_bmbt_set_startoff(
 	xfs_bmbt_rec_host_t *r,
 	xfs_fileoff_t	v)
 {
-	ASSERT((v & XFS_MASK64HI(9)) == 0);
-	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t) XFS_MASK64HI(1)) |
+	ASSERT((v & xfs_mask64hi(9)) == 0);
+	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t) xfs_mask64hi(1)) |
 		((xfs_bmbt_rec_base_t)v << 9) |
-		  (r->l0 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
+		  (r->l0 & (xfs_bmbt_rec_base_t)xfs_mask64lo(9));
 }
 
 /*
@@ -2502,9 +2502,9 @@ xfs_bmbt_set_state(
 {
 	ASSERT(v == XFS_EXT_NORM || v == XFS_EXT_UNWRITTEN);
 	if (v == XFS_EXT_NORM)
-		r->l0 &= XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN);
+		r->l0 &= xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN);
 	else
-		r->l0 |= XFS_MASK64HI(BMBT_EXNTFLAG_BITLEN);
+		r->l0 |= xfs_mask64hi(BMBT_EXNTFLAG_BITLEN);
 }
 
 /*
Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h
+++ xfs/fs/xfs/xfs_ag.h
@@ -220,7 +220,7 @@ typedef struct xfs_perag
 #define	XFS_FSB_TO_AGNO(mp,fsbno)	\
 	((xfs_agnumber_t)((fsbno) >> (mp)->m_sb.sb_agblklog))
 #define	XFS_FSB_TO_AGBNO(mp,fsbno)	\
-	((xfs_agblock_t)((fsbno) & XFS_MASK32LO((mp)->m_sb.sb_agblklog)))
+	((xfs_agblock_t)((fsbno) & xfs_mask32lo((mp)->m_sb.sb_agblklog)))
 #define	XFS_AGB_TO_DADDR(mp,agno,agbno)	\
 	((xfs_daddr_t)XFS_FSB_TO_BB(mp, \
 		(xfs_fsblock_t)(agno) * (mp)->m_sb.sb_agblocks + (agbno)))

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
