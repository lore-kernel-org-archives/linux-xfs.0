Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Mar 2007 20:17:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2K3HO6p023499
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 20:17:25 -0700
Received: from [10.0.0.4] (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 7E660187B8C54
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 22:17:21 -0500 (CDT)
Message-ID: <45FF5241.4000605@sandeen.net>
Date: Mon, 19 Mar 2007 22:17:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] kill off xfs_count_bits
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_count_bits is only called once, and is then compared to 0.
IOW, what it really wants to know is, is the bitmap empty.
This can be done more simply, certainly.

This is compile-tested and quickly unit-tested in userspace,
but feel free to scrutinize & live with it in the patch stack
for a while.  I need to get an xfs test box at home someday. :)

 xfs_bit.c      |   93 ++++++---------------------------------------------------
 xfs_bit.h      |    4 +-
 xfs_buf_item.c |    4 +-
 3 files changed, 14 insertions(+), 87 deletions(-)

===

Remove xfs_count_bits in favor of a much simpler xfs_bitmap_empty, 
because that's how the only caller ever uses it.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/xfs_bit.c
===================================================================
--- linux.orig/fs/xfs/xfs_bit.c
+++ linux/fs/xfs/xfs_bit.c
@@ -66,44 +66,6 @@ static const char xfs_highbit[256] = {
 #endif
 
 /*
- * Count of bits set in byte, 0..8.
- */
-static const char xfs_countbit[256] = {
-	0, 1, 1, 2, 1, 2, 2, 3,			/* 00 .. 07 */
-	1, 2, 2, 3, 2, 3, 3, 4,			/* 08 .. 0f */
-	1, 2, 2, 3, 2, 3, 3, 4,			/* 10 .. 17 */
-	2, 3, 3, 4, 3, 4, 4, 5,			/* 18 .. 1f */
-	1, 2, 2, 3, 2, 3, 3, 4,			/* 20 .. 27 */
-	2, 3, 3, 4, 3, 4, 4, 5,			/* 28 .. 2f */
-	2, 3, 3, 4, 3, 4, 4, 5,			/* 30 .. 37 */
-	3, 4, 4, 5, 4, 5, 5, 6,			/* 38 .. 3f */
-	1, 2, 2, 3, 2, 3, 3, 4,			/* 40 .. 47 */
-	2, 3, 3, 4, 3, 4, 4, 5,			/* 48 .. 4f */
-	2, 3, 3, 4, 3, 4, 4, 5,			/* 50 .. 57 */
-	3, 4, 4, 5, 4, 5, 5, 6,			/* 58 .. 5f */
-	2, 3, 3, 4, 3, 4, 4, 5,			/* 60 .. 67 */
-	3, 4, 4, 5, 4, 5, 5, 6,			/* 68 .. 6f */
-	3, 4, 4, 5, 4, 5, 5, 6,			/* 70 .. 77 */
-	4, 5, 5, 6, 5, 6, 6, 7,			/* 78 .. 7f */
-	1, 2, 2, 3, 2, 3, 3, 4,			/* 80 .. 87 */
-	2, 3, 3, 4, 3, 4, 4, 5,			/* 88 .. 8f */
-	2, 3, 3, 4, 3, 4, 4, 5,			/* 90 .. 97 */
-	3, 4, 4, 5, 4, 5, 5, 6,			/* 98 .. 9f */
-	2, 3, 3, 4, 3, 4, 4, 5,			/* a0 .. a7 */
-	3, 4, 4, 5, 4, 5, 5, 6,			/* a8 .. af */
-	3, 4, 4, 5, 4, 5, 5, 6,			/* b0 .. b7 */
-	4, 5, 5, 6, 5, 6, 6, 7,			/* b8 .. bf */
-	2, 3, 3, 4, 3, 4, 4, 5,			/* c0 .. c7 */
-	3, 4, 4, 5, 4, 5, 5, 6,			/* c8 .. cf */
-	3, 4, 4, 5, 4, 5, 5, 6,			/* d0 .. d7 */
-	4, 5, 5, 6, 5, 6, 6, 7,			/* d8 .. df */
-	3, 4, 4, 5, 4, 5, 5, 6,			/* e0 .. e7 */
-	4, 5, 5, 6, 5, 6, 6, 7,			/* e8 .. ef */
-	4, 5, 5, 6, 5, 6, 6, 7,			/* f0 .. f7 */
-	5, 6, 6, 7, 6, 7, 7, 8,			/* f8 .. ff */
-};
-
-/*
  * xfs_highbit32: get high bit set out of 32-bit argument, -1 if none set.
  */
 inline int
@@ -167,56 +129,21 @@ xfs_highbit64(
 
 
 /*
- * Count the number of bits set in the bitmap starting with bit
- * start_bit.  Size is the size of the bitmap in words.
- *
- * Do the counting by mapping a byte value to the number of set
- * bits for that value using the xfs_countbit array, i.e.
- * xfs_countbit[0] == 0, xfs_countbit[1] == 1, xfs_countbit[2] == 1,
- * xfs_countbit[3] == 2, etc.
+ * Return whether bitmap is empty.
+ * Size is number of words in the bitmap, which is padded to word boundary
+ * Returns 1 for empty, 0 for non-empty.
  */
 int
-xfs_count_bits(uint *map, uint size, uint start_bit)
+xfs_bitmap_empty(uint *map, uint size)
 {
-	register int	bits;
-	register unsigned char	*bytep;
-	register unsigned char	*end_map;
-	int		byte_bit;
-
-	bits = 0;
-	end_map = (char*)(map + size);
-	bytep = (char*)(map + (start_bit & ~0x7));
-	byte_bit = start_bit & 0x7;
-
-	/*
-	 * If the caller fell off the end of the map, return 0.
-	 */
-	if (bytep >= end_map) {
-		return (0);
-	}
-
-	/*
-	 * If start_bit is not byte aligned, then process the
-	 * first byte separately.
-	 */
-	if (byte_bit != 0) {
-		/*
-		 * Shift off the bits we don't want to look at,
-		 * before indexing into xfs_countbit.
-		 */
-		bits += xfs_countbit[(*bytep >> byte_bit)];
-		bytep++;
-	}
-
-	/*
-	 * Count the bits in each byte until the end of the bitmap.
-	 */
-	while (bytep < end_map) {
-		bits += xfs_countbit[*bytep];
-		bytep++;
+	uint i;
+	uint ret = 0;
+
+	for (i = 0; i < size; i++) {
+		ret |= map[i];
 	}
 
-	return (bits);
+	return (ret == 0);
 }
 
 /*
Index: linux/fs/xfs/xfs_bit.h
===================================================================
--- linux.orig/fs/xfs/xfs_bit.h
+++ linux/fs/xfs/xfs_bit.h
@@ -55,8 +55,8 @@ extern int xfs_lowbit64(__uint64_t v);
 /* Get high bit set out of 64-bit argument, -1 if none set */
 extern int xfs_highbit64(__uint64_t);
 
-/* Count set bits in map starting with start_bit */
-extern int xfs_count_bits(uint *map, uint size, uint start_bit);
+/* Return whether bitmap is empty (1 == empty) */
+extern int xfs_bitmap_empty(uint *map, uint size);
 
 /* Count continuous one bits in map starting with start_bit */
 extern int xfs_contig_bits(uint *map, uint size, uint start_bit);
Index: linux/fs/xfs/xfs_buf_item.c
===================================================================
--- linux/fs/xfs/xfs_buf_item.c
+++ linux.orig/fs/xfs/xfs_buf_item.c
@@ -580,8 +580,8 @@ xfs_buf_item_unlock(
 	 * If the buf item isn't tracking any data, free it.
 	 * Otherwise, if XFS_BLI_HOLD is set clear it.
 	 */
-	if (xfs_count_bits(bip->bli_format.blf_data_map,
-			      bip->bli_format.blf_map_size, 0) == 0) {
+	if (xfs_bitmap_empty(bip->bli_format.blf_data_map,
+			     bip->bli_format.blf_map_size)) {
 		xfs_buf_item_relse(bp);
 	} else if (hold) {
 		bip->bli_flags &= ~XFS_BLI_HOLD;
