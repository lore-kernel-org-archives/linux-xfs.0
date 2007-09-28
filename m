Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 06:16:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8SDFweK012540
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 06:16:03 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id B40321803C910
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 08:15:56 -0500 (CDT)
Message-ID: <46FCFE8C.9020405@sandeen.net>
Date: Fri, 28 Sep 2007 08:15:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2] Use generic routines for xfs_next_bit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

We can use find_next_bit, which is assembly on some arches,
to implement xfs_next_bit.  Tested on x86.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6.22.i386/fs/xfs/xfs_bit.c
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/xfs_bit.c
+++ linux-2.6.22.i386/fs/xfs/xfs_bit.c
@@ -192,32 +192,16 @@ found:
  */
 int xfs_next_bit(uint *map, uint size, uint start_bit)
 {
-	uint * p = ((unsigned int *) map) + (start_bit >> BIT_TO_WORD_SHIFT);
-	uint result = start_bit & ~(NBWORD - 1);
-	uint tmp;
+	int result;
 
-	size <<= BIT_TO_WORD_SHIFT;
+	size <<= BIT_TO_WORD_SHIFT;
+	if (start_bit >= size)	/* beyond end of bitmap */
+		return -1;
 
-	if (start_bit >= size)
-		return -1;
-	size -= result;
-	start_bit &= (NBWORD - 1);
-	if (start_bit) {
-		tmp = *p++;
-		/* set to zero first offset bits prior to start */
-		tmp &= (~0U << start_bit);
-		if (tmp != 0U)
-			goto found;
-		result += NBWORD;
-		size -= NBWORD;
-	}
-	while (size) {
-		if ((tmp = *p++) != 0U)
-			goto found;
-		result += NBWORD;
-		size -= NBWORD;
-	}
-	return -1;
-found:
-	return result + ffs(tmp) - 1;
+	result = find_next_bit((unsigned long *)map, size, start_bit);
+
+	if (result == size)	/* no bits set */
+		return -1;
+
+	return result;
 }
