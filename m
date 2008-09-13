Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 06:55:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DDtk6s012319
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:55:46 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C2EB7A7394
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:57:16 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id B3q0uIjbRVcgoDwo for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:57:16 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeVcc-0007Tw-Th
	for xfs@oss.sgi.com; Sat, 13 Sep 2008 23:57:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/10] XFS: split out two helpers from xfs_syncsub
Date: Sat, 13 Sep 2008 23:57:01 +1000
Message-Id: <1221314230-28618-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1221314230-28618-1-git-send-email-david@fromorbit.com>
References: <1221314230-28618-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

From: Christoph Hellwig <hch@lst.de>

Split out two helpers from xfs_syncsub for the dummy log commit
and the superblock writeout.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |  162 +++++++++++++++++++++++++------------------
 1 files changed, 93 insertions(+), 69 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 53d85ec..59da332 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -315,6 +315,93 @@ xfs_sync_inodes(
 	return XFS_ERROR(last_error);
 }
 
+STATIC int
+xfs_commit_dummy_trans(
+	struct xfs_mount	*mp,
+	uint			log_flags)
+{
+	struct xfs_inode	*ip = mp->m_rootip;
+	struct xfs_trans	*tp;
+	int			error;
+
+	/*
+	 * Put a dummy transaction in the log to tell recovery
+	 * that all others are OK.
+	 */
+	tp = xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
+	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ihold(tp, ip);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	/* XXX(hch): ignoring the error here.. */
+	error = xfs_trans_commit(tp, 0);
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	xfs_log_force(mp, 0, log_flags);
+	return 0;
+}
+
+STATIC int
+xfs_sync_fsdata(
+	struct xfs_mount	*mp,
+	int			flags)
+{
+	struct xfs_buf		*bp;
+	struct xfs_buf_log_item	*bip;
+	int			error = 0;
+
+	/*
+	 * If this is xfssyncd() then only sync the superblock if we can
+	 * lock it without sleeping and it is not pinned.
+	 */
+	if (flags & SYNC_BDFLUSH) {
+		ASSERT(!(flags & SYNC_WAIT));
+
+		bp = xfs_getsb(mp, XFS_BUF_TRYLOCK);
+		if (!bp)
+			goto out;
+
+		bip = XFS_BUF_FSPRIVATE(bp, struct xfs_buf_log_item *);
+		if (!bip || !xfs_buf_item_dirty(bip) || XFS_BUF_ISPINNED(bp))
+			goto out_brelse;
+	} else {
+		bp = xfs_getsb(mp, 0);
+
+		/*
+		 * If the buffer is pinned then push on the log so we won't
+		 * get stuck waiting in the write for someone, maybe
+		 * ourselves, to flush the log.
+		 *
+		 * Even though we just pushed the log above, we did not have
+		 * the superblock buffer locked at that point so it can
+		 * become pinned in between there and here.
+		 */
+		if (XFS_BUF_ISPINNED(bp))
+			xfs_log_force(mp, 0, XFS_LOG_FORCE);
+	}
+
+
+	if (flags & SYNC_WAIT)
+		XFS_BUF_UNASYNC(bp);
+	else
+		XFS_BUF_ASYNC(bp);
+
+	return xfs_bwrite(mp, bp);
+
+ out_brelse:
+	xfs_buf_relse(bp);
+ out:
+	return error;
+}
+
 /*
  * xfs sync routine for internal use
  *
@@ -331,8 +418,6 @@ xfs_syncsub(
 	int		error = 0;
 	int		last_error = 0;
 	uint		log_flags = XFS_LOG_FORCE;
-	xfs_buf_t	*bp;
-	xfs_buf_log_item_t	*bip;
 
 	/*
 	 * Sync out the log.  This ensures that the log is periodically
@@ -355,83 +440,22 @@ xfs_syncsub(
 	 * log activity, so if this isn't vfs_sync() then flush
 	 * the log again.
 	 */
-	if (flags & SYNC_DELWRI) {
-		xfs_log_force(mp, (xfs_lsn_t)0, log_flags);
-	}
+	if (flags & SYNC_DELWRI)
+		xfs_log_force(mp, 0, log_flags);
 
 	if (flags & SYNC_FSDATA) {
-		/*
-		 * If this is vfs_sync() then only sync the superblock
-		 * if we can lock it without sleeping and it is not pinned.
-		 */
-		if (flags & SYNC_BDFLUSH) {
-			bp = xfs_getsb(mp, XFS_BUF_TRYLOCK);
-			if (bp != NULL) {
-				bip = XFS_BUF_FSPRIVATE(bp,xfs_buf_log_item_t*);
-				if ((bip != NULL) &&
-				    xfs_buf_item_dirty(bip)) {
-					if (!(XFS_BUF_ISPINNED(bp))) {
-						XFS_BUF_ASYNC(bp);
-						error = xfs_bwrite(mp, bp);
-					} else {
-						xfs_buf_relse(bp);
-					}
-				} else {
-					xfs_buf_relse(bp);
-				}
-			}
-		} else {
-			bp = xfs_getsb(mp, 0);
-			/*
-			 * If the buffer is pinned then push on the log so
-			 * we won't get stuck waiting in the write for
-			 * someone, maybe ourselves, to flush the log.
-			 * Even though we just pushed the log above, we
-			 * did not have the superblock buffer locked at
-			 * that point so it can become pinned in between
-			 * there and here.
-			 */
-			if (XFS_BUF_ISPINNED(bp))
-				xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
-			if (flags & SYNC_WAIT)
-				XFS_BUF_UNASYNC(bp);
-			else
-				XFS_BUF_ASYNC(bp);
-			error = xfs_bwrite(mp, bp);
-		}
-		if (error) {
+		error = xfs_sync_fsdata(mp, flags);
+		if (error)
 			last_error = error;
-		}
 	}
 
 	/*
 	 * Now check to see if the log needs a "dummy" transaction.
 	 */
 	if (!(flags & SYNC_REMOUNT) && xfs_log_need_covered(mp)) {
-		xfs_trans_t *tp;
-		xfs_inode_t *ip;
-
-		/*
-		 * Put a dummy transaction in the log to tell
-		 * recovery that all others are OK.
-		 */
-		tp = xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
-		if ((error = xfs_trans_reserve(tp, 0,
-				XFS_ICHANGE_LOG_RES(mp),
-				0, 0, 0)))  {
-			xfs_trans_cancel(tp, 0);
+		error = xfs_commit_dummy_trans(mp, log_flags);
+		if (error)
 			return error;
-		}
-
-		ip = mp->m_rootip;
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-		xfs_trans_ihold(tp, ip);
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		error = xfs_trans_commit(tp, 0);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_log_force(mp, (xfs_lsn_t)0, log_flags);
 	}
 
 	/*
-- 
1.5.6
