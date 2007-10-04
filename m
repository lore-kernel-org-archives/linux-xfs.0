Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 16:09:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l94N93KZ026749
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 16:09:06 -0700
Date: Fri, 5 Oct 2007 09:08:50 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] XFS bitops to Linux again
Message-ID: <20071004230850.GI23367404@sgi.com>
References: <200710040027.16926.ak@suse.de> <60338.192.168.3.1.1191452291.squirrel@mail.aconex.com> <200710041014.22936.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710041014.22936.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <ak@suse.de>
Cc: nscott@aconex.com, xfs@oss.sgi.com

On Thu, Oct 04, 2007 at 10:14:22AM +0200, Andi Kleen wrote:
> Ok I got the message. I retract the patch. Sorry for bothering you
> with lowly cleanups.

Andi, please don't walk away with that attitude. I like the fact
your patch makes use of generic code, I just didn't like the way it
changed the core XFS code.

I've said exactly the same thing in the past about the removal
of the min/max wrapper macros in XFS. we still have the wrapper
macros because they help make the code readable, consistent and
more maintainable from an _XFS perspective_.

What I'm saying here is consistent with that view - leave the
wrappers, replace the implementation. (untested patch that does
that below.)

Sorry if I didn't make that clear, but your patches and ideas
are appreciated and sometimes we all fall down into being
nasty coding style cops. :(

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_bit.c     |  103 ---------------------------------------------------
 fs/xfs/xfs_bit.h     |   27 ++++++++++---
 fs/xfs/xfs_rtalloc.c |   20 +++------
 3 files changed, 30 insertions(+), 120 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_bit.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bit.c	2007-06-20 15:54:59.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_bit.c	2007-10-05 08:48:48.107390247 +1000
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
Index: 2.6.x-xfs-new/fs/xfs/xfs_bit.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bit.h	2007-06-20 15:54:59.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_bit.h	2007-10-05 08:56:53.180459657 +1000
@@ -47,13 +47,30 @@ static inline __uint64_t xfs_mask64lo(in
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
+	unsigned long	t = v;
+	return (v) ? find_first_bit(&t, 64) : -1;
+}
 
 /* Return whether bitmap is empty (1 == empty) */
 extern int xfs_bitmap_empty(uint *map, uint size);
Index: 2.6.x-xfs-new/fs/xfs/xfs_rtalloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_rtalloc.c	2007-08-24 22:24:45.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_rtalloc.c	2007-10-05 09:02:27.376952907 +1000
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
@@ -444,6 +433,7 @@ xfs_rtallocate_extent_near(
 	}
 	bbno = XFS_BITTOBLOCK(mp, bno);
 	i = 0;
+	ASSERT(minlen != 0);
 	log2len = xfs_highbit32(minlen);
 	/*
 	 * Loop over all bitmap blocks (bbno + i is current block).
@@ -612,6 +602,8 @@ xfs_rtallocate_extent_size(
 	xfs_suminfo_t	sum;		/* summary information for extents */
 
 	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(maxlen != 0);
+
 	/*
 	 * Loop over all the levels starting with maxlen.
 	 * At each level, look at all the bitmap blocks, to see if there
@@ -669,6 +661,9 @@ xfs_rtallocate_extent_size(
 		*rtblock = NULLRTBLOCK;
 		return 0;
 	}
+	ASSERT(minlen != 0);
+	ASSERT(maxlen != 0);
+
 	/*
 	 * Loop over sizes, from maxlen down to minlen.
 	 * This time, when we do the allocations, allow smaller ones
@@ -1954,6 +1949,7 @@ xfs_growfs_rt(
 				  nsbp->sb_blocksize * nsbp->sb_rextsize);
 		nsbp->sb_rextents = nsbp->sb_rblocks;
 		do_div(nsbp->sb_rextents, nsbp->sb_rextsize);
+		ASSERT(nsbp->sb_rextents != 0);
 		nsbp->sb_rextslog = xfs_highbit32(nsbp->sb_rextents);
 		nrsumlevels = nmp->m_rsumlevels = nsbp->sb_rextslog + 1;
 		nrsumsize =
