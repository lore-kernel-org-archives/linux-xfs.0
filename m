Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 06:05:26 -0700 (PDT)
Received: from rubicon.netdirect.ca (nic.NetDirect.CA [216.16.235.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8ED5L4p016133
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 06:05:23 -0700
Received: from [192.168.1.100] (CPE0018396a01fc-CM001225dbafb6.cpe.net.cable.rogers.com [72.143.66.27])
	(authenticated bits=0)
	by rubicon.netdirect.ca (8.13.1/8.13.1) with ESMTP id l8ECsr61011936
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 08:55:04 -0400
Date: Fri, 14 Sep 2007 08:53:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH] XFS: Delete duplicate macro definitions.
Message-ID: <Pine.LNX.4.64.0709140851130.20022@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  something that popped out of a script i have that scans for
redundant macro definitions.  apply or not as you see fit.  not
compile-tested as it was just done visually.

diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index a77b1b7..0173575 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -47,28 +47,25 @@ typedef struct xfs_bmdr_block {
  *  l1:0-20 are blockcount.
  */

+#define BMBT_TOTAL_BITLEN	128	/* 128 bits, 16 bytes */
+#define BMBT_EXNTFLAG_BITLEN	1
+#define BMBT_STARTOFF_BITLEN	54
+#define BMBT_STARTBLOCK_BITLEN	52
+
 #ifndef XFS_NATIVE_HOST

-#define BMBT_TOTAL_BITLEN	128	/* 128 bits, 16 bytes */
 #define BMBT_EXNTFLAG_BITOFF	0
-#define BMBT_EXNTFLAG_BITLEN	1
 #define BMBT_STARTOFF_BITOFF	(BMBT_EXNTFLAG_BITOFF + BMBT_EXNTFLAG_BITLEN)
-#define BMBT_STARTOFF_BITLEN	54
 #define BMBT_STARTBLOCK_BITOFF	(BMBT_STARTOFF_BITOFF + BMBT_STARTOFF_BITLEN)
-#define BMBT_STARTBLOCK_BITLEN	52
 #define BMBT_BLOCKCOUNT_BITOFF	\
 	(BMBT_STARTBLOCK_BITOFF + BMBT_STARTBLOCK_BITLEN)
 #define BMBT_BLOCKCOUNT_BITLEN	(BMBT_TOTAL_BITLEN - BMBT_BLOCKCOUNT_BITOFF)

 #else

-#define BMBT_TOTAL_BITLEN	128	/* 128 bits, 16 bytes */
 #define BMBT_EXNTFLAG_BITOFF	63
-#define BMBT_EXNTFLAG_BITLEN	1
 #define BMBT_STARTOFF_BITOFF	(BMBT_EXNTFLAG_BITOFF - BMBT_STARTOFF_BITLEN)
-#define BMBT_STARTOFF_BITLEN	54
 #define BMBT_STARTBLOCK_BITOFF	85 /* 128 - 43 (other 9 is in first word) */
-#define BMBT_STARTBLOCK_BITLEN	52
 #define BMBT_BLOCKCOUNT_BITOFF	64 /* Start of second 64 bit container */
 #define BMBT_BLOCKCOUNT_BITLEN	21

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
