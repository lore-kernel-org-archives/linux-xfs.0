Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 20:56:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3N3uYbr015824
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 20:56:36 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB46D15BA1E3
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 20:57:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 1tHZOyTmQA68OETM for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 20:57:12 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 7CA3018004B68
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 22:57:12 -0500 (CDT)
Message-ID: <480EB397.1040304@sandeen.net>
Date: Tue, 22 Apr 2008 22:57:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] re-remove xfs custom bitops
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Once more, with feeling!

This re-instates the reverted mod after the ppc panic of
Feb '08.  You guys do have ppc boxes in the test farm now right? :)

This keeps xfs_lowbit64 as it was since there aren't good
generic helpers there ...

This should probably keep Dave's signed-off line, there's
a bit of my (userspace) testing here but no original work. 

This exact patch isn't tested but it's based on a conglomeration
of prior testing...

Thanks,
-Eric

Index: linux-2.6-xfs/fs/xfs/xfs_bit.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bit.c
+++ linux-2.6-xfs/fs/xfs/xfs_bit.c
@@ -25,109 +25,6 @@
  * XFS bit manipulation routines, used in non-realtime code.
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
@@ -47,13 +47,39 @@ static inline __uint64_t xfs_mask64lo(in
 }
 
 /* Get high bit set out of 32-bit argument, -1 if none set */
-extern int xfs_highbit32(__uint32_t v);
-
-/* Get low bit set out of 64-bit argument, -1 if none set */
-extern int xfs_lowbit64(__uint64_t v);
+static inline int xfs_highbit32(__uint32_t v)
+{
+	return fls(v) - 1;
+}
 
 /* Get high bit set out of 64-bit argument, -1 if none set */
-extern int xfs_highbit64(__uint64_t);
+static inline int xfs_highbit64(__uint64_t v)
+{
+	return fls64(v) - 1;
+}
+
+/* Get low bit set out of 32-bit argument, -1 if none set */
+static inline int xfs_lowbit32(__uint32_t v)
+{
+	unsigned long	t = v;
+	return (v) ? find_first_bit(&t, 32) : -1;
+}
+
+/* Get low bit set out of 64-bit argument, -1 if none set */
+static inline int xfs_lowbit64(__uint64_t v)
+{
+	__uint32_t	w = (__uint32_t)v;
+	int		n = 0;
+
+	if (w) {	/* lower bits */
+		n = ffs(w);
+	} else {	/* upper bits */
+		w = (__uint32_t)(v >> 32);
+		if (w && (n = ffs(w)))
+		n += 32;
+	}
+	return n - 1;
+}
 
 /* Return whether bitmap is empty (1 == empty) */
 extern int xfs_bitmap_empty(uint *map, uint size);
Index: linux-2.6-xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rtalloc.c
+++ linux-2.6-xfs/fs/xfs/xfs_rtalloc.c
@@ -74,18 +74,6 @@ STATIC int xfs_rtmodify_summary(xfs_moun
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
@@ -450,6 +438,7 @@ xfs_rtallocate_extent_near(
 	}
 	bbno = XFS_BITTOBLOCK(mp, bno);
 	i = 0;
+	ASSERT(minlen != 0);
 	log2len = xfs_highbit32(minlen);
 	/*
 	 * Loop over all bitmap blocks (bbno + i is current block).
@@ -618,6 +607,8 @@ xfs_rtallocate_extent_size(
 	xfs_suminfo_t	sum;		/* summary information for extents */
 
 	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(maxlen != 0);
+
 	/*
 	 * Loop over all the levels starting with maxlen.
 	 * At each level, look at all the bitmap blocks, to see if there
@@ -675,6 +666,9 @@ xfs_rtallocate_extent_size(
 		*rtblock = NULLRTBLOCK;
 		return 0;
 	}
+	ASSERT(minlen != 0);
+	ASSERT(maxlen != 0);
+
 	/*
 	 * Loop over sizes, from maxlen down to minlen.
 	 * This time, when we do the allocations, allow smaller ones
@@ -1961,6 +1955,7 @@ xfs_growfs_rt(
 				  nsbp->sb_blocksize * nsbp->sb_rextsize);
 		nsbp->sb_rextents = nsbp->sb_rblocks;
 		do_div(nsbp->sb_rextents, nsbp->sb_rextsize);
+		ASSERT(nsbp->sb_rextents != 0);
 		nsbp->sb_rextslog = xfs_highbit32(nsbp->sb_rextents);
 		nrsumlevels = nmp->m_rsumlevels = nsbp->sb_rextslog + 1;
 		nrsumsize =
