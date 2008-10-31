Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Oct 2008 18:15:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9V1FWUg001222
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:15:32 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 057151B6F44C
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:15:32 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id Ea2bEJ5cycyxYRzC for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 18:15:32 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1Kvibp-0007qV-CX
	for xfs@oss.sgi.com; Fri, 31 Oct 2008 12:15:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] XFS: fix spurious uninitialised variable warning in xfs_growfs_rt
Date: Fri, 31 Oct 2008 12:15:28 +1100
Message-Id: <1225415729-26514-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1225415729-26514-1-git-send-email-david@fromorbit.com>
References: <1225415729-26514-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

gcc is warning about an uninitialised variable in xfs_growfs_rt().
This is a false positive. Fix it by changing the scope of the
transaction pointer to wholly within the internal loop inside
the function.

While there, preemptively change xfs_growfs_rt_alloc() in the
same way as it has exactly the same structure as xfs_growfs_rt()
but gcc is not warning about it. Yet.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_rtalloc.c |   39 ++++++++++++++++++---------------------
 1 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e2f68de..f18b9b2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -85,7 +85,6 @@ xfs_growfs_rt_alloc(
 {
 	xfs_fileoff_t	bno;		/* block number in file */
 	xfs_buf_t	*bp;		/* temporary buffer for zeroing */
-	int		cancelflags;	/* flags for xfs_trans_cancel */
 	int		committed;	/* transaction committed flag */
 	xfs_daddr_t	d;		/* disk block address */
 	int		error;		/* error return value */
@@ -96,15 +95,16 @@ xfs_growfs_rt_alloc(
 	xfs_bmbt_irec_t	map;		/* block map output */
 	int		nmap;		/* number of block maps */
 	int		resblks;	/* space reservation */
-	xfs_trans_t	*tp;		/* transaction pointer */
 
 	/*
 	 * Allocate space to the file, as necessary.
 	 */
 	while (oblocks < nblocks) {
+		int		cancelflags = 0;
+		xfs_trans_t	*tp;
+
 		tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFSRT_ALLOC);
 		resblks = XFS_GROWFSRT_SPACE_RES(mp, nblocks - oblocks);
-		cancelflags = 0;
 		/*
 		 * Reserve space & log for one extent added to the file.
 		 */
@@ -171,7 +171,9 @@ xfs_growfs_rt_alloc(
 				mp->m_bsize, 0);
 			if (bp == NULL) {
 				error = XFS_ERROR(EIO);
-				goto error_cancel;
+error_cancel:
+				xfs_trans_cancel(tp, cancelflags);
+				goto error;
 			}
 			memset(XFS_BUF_PTR(bp), 0, mp->m_sb.sb_blocksize);
 			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
@@ -188,8 +190,6 @@ xfs_growfs_rt_alloc(
 		oblocks = map.br_startoff + map.br_blockcount;
 	}
 	return 0;
-error_cancel:
-	xfs_trans_cancel(tp, cancelflags);
 error:
 	return error;
 }
@@ -1856,7 +1856,6 @@ xfs_growfs_rt(
 {
 	xfs_rtblock_t	bmbno;		/* bitmap block number */
 	xfs_buf_t	*bp;		/* temporary buffer */
-	int		cancelflags;	/* flags for xfs_trans_cancel */
 	int		error;		/* error return value */
 	xfs_inode_t	*ip;		/* bitmap inode, used as lock */
 	xfs_mount_t	*nmp;		/* new (fake) mount structure */
@@ -1872,10 +1871,8 @@ xfs_growfs_rt(
 	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
 	xfs_sb_t	*sbp;		/* old superblock */
 	xfs_fsblock_t	sumbno;		/* summary block number */
-	xfs_trans_t	*tp;		/* transaction pointer */
 
 	sbp = &mp->m_sb;
-	cancelflags = 0;
 	/*
 	 * Initial error checking.
 	 */
@@ -1942,6 +1939,9 @@ xfs_growfs_rt(
 		     ((sbp->sb_rextents & ((1 << mp->m_blkbit_log) - 1)) != 0);
 	     bmbno < nrbmblocks;
 	     bmbno++) {
+		xfs_trans_t	*tp;
+		int		cancelflags = 0;
+
 		*nmp = *mp;
 		nsbp = &nmp->m_sb;
 		/*
@@ -1967,16 +1967,15 @@ xfs_growfs_rt(
 		 * Start a transaction, get the log reservation.
 		 */
 		tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFSRT_FREE);
-		cancelflags = 0;
 		if ((error = xfs_trans_reserve(tp, 0,
 				XFS_GROWRTFREE_LOG_RES(nmp), 0, 0, 0)))
-			break;
+			goto error_cancel;
 		/*
 		 * Lock out other callers by grabbing the bitmap inode lock.
 		 */
 		if ((error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0,
 						XFS_ILOCK_EXCL, &ip)))
-			break;
+			goto error_cancel;
 		ASSERT(ip == mp->m_rbmip);
 		/*
 		 * Update the bitmap inode's size.
@@ -1990,7 +1989,7 @@ xfs_growfs_rt(
 		 */
 		if ((error = xfs_trans_iget(mp, tp, mp->m_sb.sb_rsumino, 0,
 						XFS_ILOCK_EXCL, &ip)))
-			break;
+			goto error_cancel;
 		ASSERT(ip == mp->m_rsumip);
 		/*
 		 * Update the summary inode's size.
@@ -2005,7 +2004,7 @@ xfs_growfs_rt(
 		    mp->m_rsumlevels != nmp->m_rsumlevels) {
 			error = xfs_rtcopy_summary(mp, nmp, tp);
 			if (error)
-				break;
+				goto error_cancel;
 		}
 		/*
 		 * Update superblock fields.
@@ -2031,8 +2030,11 @@ xfs_growfs_rt(
 		bp = NULL;
 		error = xfs_rtfree_range(nmp, tp, sbp->sb_rextents,
 			nsbp->sb_rextents - sbp->sb_rextents, &bp, &sumbno);
-		if (error)
+		if (error) {
+error_cancel:
+			xfs_trans_cancel(tp, cancelflags);
 			break;
+		}
 		/*
 		 * Mark more blocks free in the superblock.
 		 */
@@ -2045,15 +2047,10 @@ xfs_growfs_rt(
 		mp->m_rsumsize = nrsumsize;
 
 		error = xfs_trans_commit(tp, 0);
-		if (error) {
-			tp = NULL;
+		if (error)
 			break;
-		}
 	}
 
-	if (error && tp)
-		xfs_trans_cancel(tp, cancelflags);
-
 	/*
 	 * Free the fake mp structure.
 	 */
-- 
1.5.6.5
