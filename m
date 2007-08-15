Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Aug 2007 21:20:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7F4K0bm016532
	for <xfs@oss.sgi.com>; Tue, 14 Aug 2007 21:20:03 -0700
Received: from Liberator.local (unknown [10.0.0.69])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 4EE1B1806FDB9
	for <xfs@oss.sgi.com>; Tue, 14 Aug 2007 23:20:03 -0500 (CDT)
Message-ID: <46C27EF8.2020004@sandeen.net>
Date: Tue, 14 Aug 2007 23:20:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove unused BULKSTAT_FG_INLINE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

I was looking at xfs_bulkstat with an eye towards stack reduction,
and came across this... doesn't help stack, but it doesn't appear
that the BULKSTAT_FG_INLINE bulkstat is ever used... 

Is it there for a reason?  If not here's a patch.

Thanks,
-Eric

 xfs_itable.c |   31 ++++++-------------------------
 xfs_itable.h |    1 -
 2 files changed, 6 insertions(+), 26 deletions(-)

----

Remove unused BULKSTAT_FG_INLINE flag & associated code.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net

Index: linux-2.6.22-rc4/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/xfs/xfs_itable.c
+++ linux-2.6.22-rc4/fs/xfs/xfs_itable.c
@@ -273,6 +273,8 @@ xfs_bulkstat_use_dinode(
 	xfs_dinode_t	*dip;
 	unsigned int	aformat;
 
+	ASSERT(flags & (BULKSTAT_FG_QUICK|BULKSTAT_FG_IGET));
+
 	*dipp = NULL;
 	if (!bp || (flags & BULKSTAT_FG_IGET))
 		return 1;
@@ -282,18 +284,9 @@ xfs_bulkstat_use_dinode(
 	    !XFS_DINODE_GOOD_VERSION(
 			INT_GET(dip->di_core.di_version, ARCH_CONVERT)))
 		return 0;
-	if (flags & BULKSTAT_FG_QUICK) {
-		*dipp = dip;
-		return 1;
-	}
-	/* BULKSTAT_FG_INLINE: if attr fork is local, or not there, use it */
-	aformat = INT_GET(dip->di_core.di_aformat, ARCH_CONVERT);
-	if ((XFS_CFORK_Q(&dip->di_core) == 0) ||
-	    (aformat == XFS_DINODE_FMT_LOCAL) ||
-	    (aformat == XFS_DINODE_FMT_EXTENTS && !dip->di_core.di_anextents)) {
-		*dipp = dip;
-		return 1;
-	}
+
+	/* BULKSTAT_FG_QUICK */
+	*dipp = dip;
 	return 1;
 }
 
@@ -566,8 +559,7 @@ xfs_bulkstat(
 						((chunkidx & nimask) >>
 						 mp->m_sb.sb_inopblog);
 
-					if (flags & (BULKSTAT_FG_QUICK |
-						     BULKSTAT_FG_INLINE)) {
+					if (flags & BULKSTAT_FG_QUICK) {
 						ino = XFS_AGINO_TO_INO(mp, agno,
 								       agino);
 						bno = XFS_AGB_TO_DADDR(mp, agno,
@@ -615,22 +607,11 @@ xfs_bulkstat(
 				if (!xfs_bulkstat_use_dinode(mp, flags, bp,
 							     clustidx, &dip))
 					continue;
-				/*
-				 * If we need to do an iget, cannot hold bp.
-				 * Drop it, until starting the next cluster.
-				 */
-				if ((flags & BULKSTAT_FG_INLINE) && !dip) {
-					if (bp)
-						xfs_buf_relse(bp);
-					bp = NULL;
-				}
 
 				/*
 				 * Get the inode and fill in a single buffer.
 				 * BULKSTAT_FG_QUICK uses dip to fill it in.
 				 * BULKSTAT_FG_IGET uses igets.
-				 * BULKSTAT_FG_INLINE uses dip if we have an
-				 * inline attr fork, else igets.
 				 * See: xfs_bulkstat_one & xfs_dm_bulkstat_one.
 				 * This is also used to count inodes/blks, etc
 				 * in xfs_qm_quotacheck.
Index: linux-2.6.22-rc4/fs/xfs/xfs_itable.h
===================================================================
--- linux-2.6.22-rc4.orig/fs/xfs/xfs_itable.h
+++ linux-2.6.22-rc4/fs/xfs/xfs_itable.h
@@ -45,7 +45,6 @@ typedef int (*bulkstat_one_pf)(struct xf
  */
 #define BULKSTAT_FG_IGET	0x1	/* Go through the buffer cache */
 #define BULKSTAT_FG_QUICK	0x2	/* No iget, walk the dinode cluster */
-#define BULKSTAT_FG_INLINE	0x4	/* No iget if inline attrs */
 
 /*
  * Return stat information in bulk (by-inode) for the filesystem.
