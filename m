Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 01:05:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5J850do016098
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 01:05:02 -0700
Date: Tue, 19 Jun 2007 18:04:54 +1000
From: David Chinner <dgc@sgi.com>
Subject: min/max cleanup
Message-ID: <20070619080454.GQ86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


To finally put this to rest, clean up the open coded macro
min/max macro implementations.

Previous similar patch from Christoph here:

http://oss.sgi.com/archives/xfs/2007-04/msg00076.html

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/xfs_btree.h |   32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_btree.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_btree.h	2007-02-07 13:24:33.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_btree.h	2007-04-23 09:29:25.152573864 +1000
@@ -444,30 +444,14 @@ xfs_btree_setbuf(
 /*
  * Min and max functions for extlen, agblock, fileoff, and filblks types.
  */
-#define	XFS_EXTLEN_MIN(a,b)	\
-	((xfs_extlen_t)(a) < (xfs_extlen_t)(b) ? \
-		(xfs_extlen_t)(a) : (xfs_extlen_t)(b))
-#define	XFS_EXTLEN_MAX(a,b)	\
-	((xfs_extlen_t)(a) > (xfs_extlen_t)(b) ? \
-		(xfs_extlen_t)(a) : (xfs_extlen_t)(b))
-#define	XFS_AGBLOCK_MIN(a,b)	\
-	((xfs_agblock_t)(a) < (xfs_agblock_t)(b) ? \
-		(xfs_agblock_t)(a) : (xfs_agblock_t)(b))
-#define	XFS_AGBLOCK_MAX(a,b)	\
-	((xfs_agblock_t)(a) > (xfs_agblock_t)(b) ? \
-		(xfs_agblock_t)(a) : (xfs_agblock_t)(b))
-#define	XFS_FILEOFF_MIN(a,b)	\
-	((xfs_fileoff_t)(a) < (xfs_fileoff_t)(b) ? \
-		(xfs_fileoff_t)(a) : (xfs_fileoff_t)(b))
-#define	XFS_FILEOFF_MAX(a,b)	\
-	((xfs_fileoff_t)(a) > (xfs_fileoff_t)(b) ? \
-		(xfs_fileoff_t)(a) : (xfs_fileoff_t)(b))
-#define	XFS_FILBLKS_MIN(a,b)	\
-	((xfs_filblks_t)(a) < (xfs_filblks_t)(b) ? \
-		(xfs_filblks_t)(a) : (xfs_filblks_t)(b))
-#define	XFS_FILBLKS_MAX(a,b)	\
-	((xfs_filblks_t)(a) > (xfs_filblks_t)(b) ? \
-		(xfs_filblks_t)(a) : (xfs_filblks_t)(b))
+#define	XFS_EXTLEN_MIN(a,b)	min_t(xfs_extlen_t, (a), (b))
+#define	XFS_EXTLEN_MAX(a,b)	max_t(xfs_extlen_t, (a), (b))
+#define	XFS_AGBLOCK_MIN(a,b)	min_t(xfs_agblock_t, (a), (b))
+#define	XFS_AGBLOCK_MAX(a,b)	max_t(xfs_agblock_t, (a), (b))
+#define	XFS_FILEOFF_MIN(a,b)	min_t(xfs_fileoff_t, (a), (b))
+#define	XFS_FILEOFF_MAX(a,b)	max_t(xfs_fileoff_t, (a), (b))
+#define	XFS_FILBLKS_MIN(a,b)	min_t(xfs_filblks_t, (a), (b))
+#define	XFS_FILBLKS_MAX(a,b)	max_t(xfs_filblks_t, (a), (b))
 
 #define	XFS_FSB_SANITY_CHECK(mp,fsb)	\
 	(XFS_FSB_TO_AGNO(mp, fsb) < mp->m_sb.sb_agcount && \
