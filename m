Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 06:16:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8SDGJAp012643
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 06:16:23 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 91D2C1803C910
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 08:16:19 -0500 (CDT)
Message-ID: <46FCFEA3.5030704@sandeen.net>
Date: Fri, 28 Sep 2007 08:16:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] use generic routines for xfs_highbit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

We can use the fls & fls64 routines (many of which have arch-specific
assembly implementations) to implement xfs_highbit and xfs_highbit64.
Tested on x86.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6.22.i386/fs/xfs/xfs_bit.c
===================================================================
--- linux-2.6.22.i386.orig/fs/xfs/xfs_bit.c
+++ linux-2.6.22.i386/fs/xfs/xfs_bit.c
@@ -25,46 +25,6 @@
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
 /*
  * xfs_highbit32: get high bit set out of 32-bit argument, -1 if none set.
  */
@@ -72,25 +32,9 @@ inline int
 xfs_highbit32(
 	__uint32_t	v)
 {
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
+	if (v)
+		return fls(v) - 1;
+	return  -1;
 }
 
 /*
@@ -120,11 +64,9 @@ int
 xfs_highbit64(
 	__uint64_t	v)
 {
-	__uint32_t	h = (__uint32_t)(v >> 32);
-
-	if (h)
-		return xfs_highbit32(h) + 32;
-	return xfs_highbit32((__uint32_t)v);
+	if (v)
+		return fls64(v) - 1;
+	return -1;
 }
 
 
