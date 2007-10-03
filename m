Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Oct 2007 15:27:28 -0700 (PDT)
Received: from mx1.suse.de (ns1.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l93MRLGg030154
	for <xfs@oss.sgi.com>; Wed, 3 Oct 2007 15:27:23 -0700
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 258A2150E1
	for <xfs@oss.sgi.com>; Thu,  4 Oct 2007 00:27:21 +0200 (CEST)
From: Andi Kleen <ak@suse.de>
Subject: [PATCH] XFS bitops to Linux again
Date: Thu, 4 Oct 2007 00:27:16 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710040027.16926.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


This time against CVS 

Replace XFS bit functions with call Linux functions

XFS had some own functions to find high and low bits.

This patch replaces them with a call to the respective Linux functions.
The semantics of the Linux functions differ a little, but i checked
all call sites that they can deal with that.

The resulting xfs.ko is about 500 bytes smaller on x86-64

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6-xfs/fs/xfs/xfs_bit.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bit.c
+++ linux-2.6-xfs/fs/xfs/xfs_bit.c
@@ -22,112 +22,9 @@
 #include "xfs_buf_item.h"
 
 /*
- * XFS bit manipulation routines, used in non-realtime code.
+ * XFS bit manipulation routines
  */
 
-#ifndef HAVE_ARCH_HIGHBIT
-/*
- * Index of high bit number in byte, -1 for none set, 0..7 otherwise.
- */
-static const char xfs_highbit[256] = {
-       -1, 0, 1, 1, 2, 2, 2, 2,			/* 00 .. 07 */
-	3, 3, 3, 3, 3, 3, 3, 3,			/* 08 .. 0f */
-	4, 4, 4, 4, 4, 4, 4, 4,			/* 10 .. 17 */
-	4, 4, 4, 4, 4, 4, 4, 4,			/* 18 .. 1f */
-	5, 5, 5, 5, 5, 5, 5, 5,			/* 20 .. 27 */
-	5, 5, 5, 5, 5, 5, 5, 5,			/* 28 .. 2f */
-	5, 5, 5, 5, 5, 5, 5, 5,			/* 30 .. 37 */
-	5, 5, 5, 5, 5, 5, 5, 5,			/* 38 .. 3f */
-	6, 6, 6, 6, 6, 6, 6, 6,			/* 40 .. 47 */
-	6, 6, 6, 6, 6, 6, 6, 6,			/* 48 .. 4f */
-	6, 6, 6, 6, 6, 6, 6, 6,			/* 50 .. 57 */
-	6, 6, 6, 6, 6, 6, 6, 6,			/* 58 .. 5f */
-	6, 6, 6, 6, 6, 6, 6, 6,			/* 60 .. 67 */
-	6, 6, 6, 6, 6, 6, 6, 6,			/* 68 .. 6f */
-	6, 6, 6, 6, 6, 6, 6, 6,			/* 70 .. 77 */
-	6, 6, 6, 6, 6, 6, 6, 6,			/* 78 .. 7f */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* 80 .. 87 */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* 88 .. 8f */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* 90 .. 97 */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* 98 .. 9f */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* a0 .. a7 */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* a8 .. af */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* b0 .. b7 */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* b8 .. bf */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* c0 .. c7 */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* c8 .. cf */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* d0 .. d7 */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* d8 .. df */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* e0 .. e7 */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* e8 .. ef */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* f0 .. f7 */
-	7, 7, 7, 7, 7, 7, 7, 7,			/* f8 .. ff */
-};
-#endif
-
-/*
- * xfs_highbit32: get high bit set out of 32-bit argument, -1 if none set.
- */
-inline int
-xfs_highbit32(
-	__uint32_t	v)
-{
-#ifdef HAVE_ARCH_HIGHBIT
-	return highbit32(v);
-#else
-	int		i;
-
-	if (v & 0xffff0000)
-		if (v & 0xff000000)
-			i = 24;
-		else
-			i = 16;
-	else if (v & 0x0000ffff)
-		if (v & 0x0000ff00)
-			i = 8;
-		else
-			i = 0;
-	else
-		return -1;
-	return i + xfs_highbit[(v >> i) & 0xff];
-#endif
-}
-
-/*
- * xfs_lowbit64: get low bit set out of 64-bit argument, -1 if none set.
- */
-int
-xfs_lowbit64(
-	__uint64_t	v)
-{
-	__uint32_t	w = (__uint32_t)v;
-	int		n = 0;
-
-	if (w) {	/* lower bits */
-		n = ffs(w);
-	} else {	/* upper bits */
-		w = (__uint32_t)(v >> 32);
-		if (w && (n = ffs(w)))
-			n += 32;
-	}
-	return n - 1;
-}
-
-/*
- * xfs_highbit64: get high bit set out of 64-bit argument, -1 if none set.
- */
-int
-xfs_highbit64(
-	__uint64_t	v)
-{
-	__uint32_t	h = (__uint32_t)(v >> 32);
-
-	if (h)
-		return xfs_highbit32(h) + 32;
-	return xfs_highbit32((__uint32_t)v);
-}
-
-
 /*
  * Return whether bitmap is empty.
  * Size is number of words in the bitmap, which is padded to word boundary
Index: linux-2.6-xfs/fs/xfs/xfs_bit.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bit.h
+++ linux-2.6-xfs/fs/xfs/xfs_bit.h
@@ -46,15 +46,6 @@ static inline __uint64_t xfs_mask64lo(in
 	return ((__uint64_t)1 << (n)) - 1;
 }
 
-/* Get high bit set out of 32-bit argument, -1 if none set */
-extern int xfs_highbit32(__uint32_t v);
-
-/* Get low bit set out of 64-bit argument, -1 if none set */
-extern int xfs_lowbit64(__uint64_t v);
-
-/* Get high bit set out of 64-bit argument, -1 if none set */
-extern int xfs_highbit64(__uint64_t);
-
 /* Return whether bitmap is empty (1 == empty) */
 extern int xfs_bitmap_empty(uint *map, uint size);
 
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c
@@ -479,7 +479,7 @@ xfs_sb_to_disk(
 		return;
 
 	while (fields) {
-		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
+		f = (xfs_sb_field_t)find_first_bit((unsigned long *)&fields,64);
 		first = xfs_sb_info[f].offset;
 		size = xfs_sb_info[f + 1].offset - first;
 
@@ -621,7 +621,7 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
 	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
-	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
+	mp->m_agno_log = fls(sbp->sb_agcount - 1);
 	mp->m_agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
 	mp->m_litino = sbp->sb_inodesize -
 		((uint)sizeof(xfs_dinode_core_t) + (uint)sizeof(xfs_agino_t));
@@ -1420,11 +1420,11 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fi
 
 	/* find modified range */
 
-	f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
+	f = (xfs_sb_field_t)find_first_bit((unsigned long *)&fields, 64);
 	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
 	first = xfs_sb_info[f].offset;
 
-	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
+	f = (xfs_sb_field_t)fls64((__uint64_t)fields) - 1;
 	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
 	last = xfs_sb_info[f + 1].offset - 1;
 
Index: linux-2.6-xfs/fs/xfs/xfs_rtalloc.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rtalloc.h
+++ linux-2.6-xfs/fs/xfs/xfs_rtalloc.h
@@ -60,13 +60,19 @@ struct xfs_trans;
 #define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
 #define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
 
-#define	XFS_RTLOBIT(w)	xfs_lowbit32(w)
-#define	XFS_RTHIBIT(w)	xfs_highbit32(w)
+/* All callers check for 0 arguments already; so no -1 handling */
+static inline int xfs_rtlobit(unsigned long v)
+{
+	return find_first_bit(&v, 32);
+}
+
+#define	XFS_RTLOBIT(w)  xfs_rtlobit(w)
+#define	XFS_RTHIBIT(w)  (fls(w) - 1)
 
 #if XFS_BIG_BLKNOS
-#define	XFS_RTBLOCKLOG(b)	xfs_highbit64(b)
+#define	XFS_RTBLOCKLOG(b)	(fls64(b) - 1)
 #else
-#define	XFS_RTBLOCKLOG(b)	xfs_highbit32(b)
+#define	XFS_RTBLOCKLOG(b)	(fls(b) - 1)
 #endif
 
 
Index: linux-2.6-xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rtalloc.c
+++ linux-2.6-xfs/fs/xfs/xfs_rtalloc.c
@@ -73,18 +73,6 @@ STATIC int xfs_rtmodify_summary(xfs_moun
  */
 
 /*
- * xfs_lowbit32: get low bit set out of 32-bit argument, -1 if none set.
- */
-STATIC int
-xfs_lowbit32(
-	__uint32_t	v)
-{
-	if (v)
-		return ffs(v) - 1;
-	return -1;
-}
-
-/*
  * Allocate space to the bitmap or summary file, and zero it, for growfs.
  */
 STATIC int				/* error */
@@ -444,7 +432,8 @@ xfs_rtallocate_extent_near(
 	}
 	bbno = XFS_BITTOBLOCK(mp, bno);
 	i = 0;
-	log2len = xfs_highbit32(minlen);
+	ASSERT(minlen != 0);
+	log2len = fls(minlen) - 1;
 	/*
 	 * Loop over all bitmap blocks (bbno + i is current block).
 	 */
@@ -607,11 +596,13 @@ xfs_rtallocate_extent_size(
 	int		error;		/* error value */
 	int		i;		/* bitmap block number */
 	int		l;		/* level number (loop control) */
+	int 		end;
 	xfs_rtblock_t	n;		/* next block to be tried */
 	xfs_rtblock_t	r;		/* result block number */
 	xfs_suminfo_t	sum;		/* summary information for extents */
 
 	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(maxlen != 0);
 	/*
 	 * Loop over all the levels starting with maxlen.
 	 * At each level, look at all the bitmap blocks, to see if there
@@ -619,7 +610,7 @@ xfs_rtallocate_extent_size(
 	 * Note, only on the initial level can the allocation fail if
 	 * the summary says there's an extent.
 	 */
-	for (l = xfs_highbit32(maxlen); l < mp->m_rsumlevels; l++) {
+	for (l = fls(maxlen) - 1; l < mp->m_rsumlevels; l++) {
 		/*
 		 * Loop over all the bitmap blocks.
 		 */
@@ -669,12 +660,15 @@ xfs_rtallocate_extent_size(
 		*rtblock = NULLRTBLOCK;
 		return 0;
 	}
+	ASSERT(maxlen != 0);
+	ASSERT(minlen != 0);
 	/*
 	 * Loop over sizes, from maxlen down to minlen.
 	 * This time, when we do the allocations, allow smaller ones
 	 * to succeed.
 	 */
-	for (l = xfs_highbit32(maxlen); l >= xfs_highbit32(minlen); l--) {
+	end = fls(minlen) - 1;
+	for (l = fls(maxlen) - 1; l >= end; l--) {
 		/*
 		 * Loop over all the bitmap blocks, try an allocation
 		 * starting in that block.
@@ -1863,7 +1857,6 @@ xfs_growfs_rt(
 	xfs_drfsbno_t	nrblocks;	/* new number of realtime blocks */
 	xfs_extlen_t	nrbmblocks;	/* new number of rt bitmap blocks */
 	xfs_drtbno_t	nrextents;	/* new number of realtime extents */
-	uint8_t		nrextslog;	/* new log2 of sb_rextents */
 	xfs_extlen_t	nrsumblocks;	/* new number of summary blocks */
 	uint		nrsumlevels;	/* new rt summary levels */
 	uint		nrsumsize;	/* new size of rt summary, bytes */
@@ -1900,8 +1893,7 @@ xfs_growfs_rt(
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
 	nrbmblocks = howmany_64(nrextents, NBBY * sbp->sb_blocksize);
-	nrextslog = xfs_highbit32(nrextents);
-	nrsumlevels = nrextslog + 1;
+	nrsumlevels = fls(nrextents);
 	nrsumsize = (uint)sizeof(xfs_suminfo_t) * nrsumlevels * nrbmblocks;
 	nrsumblocks = XFS_B_TO_FSB(mp, nrsumsize);
 	nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
@@ -1954,7 +1946,8 @@ xfs_growfs_rt(
 				  nsbp->sb_blocksize * nsbp->sb_rextsize);
 		nsbp->sb_rextents = nsbp->sb_rblocks;
 		do_div(nsbp->sb_rextents, nsbp->sb_rextsize);
-		nsbp->sb_rextslog = xfs_highbit32(nsbp->sb_rextents);
+		ASSERT(nsbp->sb_rextents != 0);
+		nsbp->sb_rextslog = fls(nsbp->sb_rextents) - 1;
 		nrsumlevels = nmp->m_rsumlevels = nsbp->sb_rextslog + 1;
 		nrsumsize =
 			(uint)sizeof(xfs_suminfo_t) * nrsumlevels *
@@ -2317,9 +2310,10 @@ xfs_rtpick_extent(
 		*seqp = 0;
 	}
 	seq = *seqp;
-	if ((log2 = xfs_highbit64(seq)) == -1)
+	if ((log2 = fls64(seq)) == 0)
 		b = 0;
 	else {
+		log2--;
 		resid = seq - (1ULL << log2);
 		b = (mp->m_sb.sb_rextents * ((resid << 1) + 1ULL)) >>
 		    (log2 + 1);
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.h
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.h
@@ -52,10 +52,10 @@ xfs_make_iptr(struct xfs_mount *mp, stru
 #define	XFS_IALLOC_FIND_FREE(fp)	xfs_ialloc_find_free(fp)
 static inline int xfs_ialloc_find_free(xfs_inofree_t *fp)
 {
-	return xfs_lowbit64(*fp);
+	unsigned long v = *fp; /* Guarantee alignment */
+	return find_first_bit(&v, 64);
 }
 
-
 #ifdef __KERNEL__
 /*
  * Allocate an inode on disk.
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
@@ -222,8 +222,6 @@ EXPORT_SYMBOL(xfs_file_last_byte);
 EXPORT_SYMBOL(xfs_finish_reclaim_all);
 EXPORT_SYMBOL(xfs_freesb);
 EXPORT_SYMBOL(xfs_fs_cmn_err);
-EXPORT_SYMBOL(xfs_highbit32);
-EXPORT_SYMBOL(xfs_highbit64);
 EXPORT_SYMBOL(xfs_idestroy);
 EXPORT_SYMBOL(xfs_iaccess);
 EXPORT_SYMBOL(xfs_iextract);
