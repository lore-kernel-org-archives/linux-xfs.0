Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 13:46:00 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6FKjubm001357
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 13:45:58 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6FKjwNK017239
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 22:45:58 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6FKjwE8017237
	for xfs@oss.sgi.com; Sun, 15 Jul 2007 22:45:58 +0200
Date: Sun, 15 Jul 2007 22:45:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] cleanup defintions of BMBT_*BITLEN macros
Message-ID: <20070715204558.GD17069@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The BMBT_*BITLEN are currently defined in a complicated way depenending
on XFS_NATIVE_HOST.  But if all the macros are exapanded they
(obviously) expand to the same value for both cases.

This patch defines the macros in the most simple way and updates the
comment describing them to remove outdated bits.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h	2007-07-14 14:17:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h	2007-07-14 14:19:26.000000000 +0200
@@ -35,45 +35,16 @@ typedef struct xfs_bmdr_block {
 
 /*
  * Bmap btree record and extent descriptor.
- * For 32-bit kernels,
- *  l0:31 is an extent flag (value 1 indicates non-normal).
- *  l0:0-30 and l1:9-31 are startoff.
- *  l1:0-8, l2:0-31, and l3:21-31 are startblock.
- *  l3:0-20 are blockcount.
- * For 64-bit kernels,
  *  l0:63 is an extent flag (value 1 indicates non-normal).
  *  l0:9-62 are startoff.
  *  l0:0-8 and l1:21-63 are startblock.
  *  l1:0-20 are blockcount.
  */
-
-#ifndef XFS_NATIVE_HOST
-
-#define BMBT_TOTAL_BITLEN	128	/* 128 bits, 16 bytes */
-#define BMBT_EXNTFLAG_BITOFF	0
 #define BMBT_EXNTFLAG_BITLEN	1
-#define BMBT_STARTOFF_BITOFF	(BMBT_EXNTFLAG_BITOFF + BMBT_EXNTFLAG_BITLEN)
 #define BMBT_STARTOFF_BITLEN	54
-#define BMBT_STARTBLOCK_BITOFF	(BMBT_STARTOFF_BITOFF + BMBT_STARTOFF_BITLEN)
 #define BMBT_STARTBLOCK_BITLEN	52
-#define BMBT_BLOCKCOUNT_BITOFF	\
-	(BMBT_STARTBLOCK_BITOFF + BMBT_STARTBLOCK_BITLEN)
-#define BMBT_BLOCKCOUNT_BITLEN	(BMBT_TOTAL_BITLEN - BMBT_BLOCKCOUNT_BITOFF)
-
-#else
-
-#define BMBT_TOTAL_BITLEN	128	/* 128 bits, 16 bytes */
-#define BMBT_EXNTFLAG_BITOFF	63
-#define BMBT_EXNTFLAG_BITLEN	1
-#define BMBT_STARTOFF_BITOFF	(BMBT_EXNTFLAG_BITOFF - BMBT_STARTOFF_BITLEN)
-#define BMBT_STARTOFF_BITLEN	54
-#define BMBT_STARTBLOCK_BITOFF	85 /* 128 - 43 (other 9 is in first word) */
-#define BMBT_STARTBLOCK_BITLEN	52
-#define BMBT_BLOCKCOUNT_BITOFF	64 /* Start of second 64 bit container */
 #define BMBT_BLOCKCOUNT_BITLEN	21
 
-#endif /* XFS_NATIVE_HOST */
-
 
 #define BMBT_USE_64	1
 
