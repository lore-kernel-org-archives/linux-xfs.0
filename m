Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2F2XtnV004779 for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 21:33:55 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F1E32402C2
	for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 19:35:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	hZb3J0zpeOcjEtth for <xfs@oss.sgi.com>;
	Sun, 14 Mar 2010 19:35:29 -0700 (PDT)
Received: from dastard (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	17049944-1927428
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 13:05:27 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Nr09O-00016X-EL
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:26 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nr09B-0002pf-Qa
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/9] xfs: clean up xfs_trans_commit logic even more
Date: Mon, 15 Mar 2010 13:35:03 +1100
Message-Id: <1268620506-10799-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1268620506-10799-1-git-send-email-david@fromorbit.com>
References: <1268620506-10799-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Christoph Hellwig <hch@infradead.org>

> +shut_us_down:
> +	shutdown = XFS_FORCED_SHUTDOWN(mp) ? EIO : 0;
> +	if (!(tp->t_flags & XFS_TRANS_DIRTY) || shutdown) {
> +		xfs_trans_unreserve_and_mod_sb(tp);
> +		/*

This whole area in _xfs_trans_commit is still a complete mess.

So while touching this code, unravel this mess as well to make the
whole flow of the function simpler and clearer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_trans.c |   69 ++++++++++++++++++++++++++++------------------------
 1 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index e07b329..2bff229 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1020,19 +1020,17 @@ xfs_trans_commit_iclog(
  * have already been unlocked as if the commit had succeeded.
  * Do not reference the transaction structure after this call.
  */
- /*ARGSUSED*/
 int
 _xfs_trans_commit(
-	xfs_trans_t	*tp,
-	uint		flags,
-	int		*log_flushed)
+	struct xfs_trans	*tp,
+	uint			flags,
+	int			*log_flushed)
 {
-	xfs_mount_t		*mp = tp->t_mountp;
+	struct xfs_mount	*mp = tp->t_mountp;
 	xfs_lsn_t		commit_lsn = -1;
-	int			error;
+	int			error = 0;
 	int			log_flags = 0;
 	int			sync = tp->t_flags & XFS_TRANS_SYNC;
-	int			shutdown;
 
 	/*
 	 * Determine whether this commit is releasing a permanent
@@ -1050,30 +1048,14 @@ _xfs_trans_commit(
 	 * Also make sure to return any reserved blocks to
 	 * the free pool.
 	 */
-shut_us_down:
-	shutdown = XFS_FORCED_SHUTDOWN(mp) ? EIO : 0;
-	if (!(tp->t_flags & XFS_TRANS_DIRTY) || shutdown) {
-		xfs_trans_unreserve_and_mod_sb(tp);
-		/*
-		 * It is indeed possible for the transaction to be
-		 * not dirty but the dqinfo portion to be. All that
-		 * means is that we have some (non-persistent) quota
-		 * reservations that need to be unreserved.
-		 */
-		xfs_trans_unreserve_and_mod_dquots(tp);
-		if (tp->t_ticket) {
-			commit_lsn = xfs_log_done(mp, tp->t_ticket,
-							NULL, log_flags);
-			if (commit_lsn == -1 && !shutdown)
-				shutdown = XFS_ERROR(EIO);
-		}
-		current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
-		xfs_trans_free_items(tp, shutdown? XFS_TRANS_ABORT : 0);
-		xfs_trans_free_busy(tp);
-		xfs_trans_free(tp);
-		XFS_STATS_INC(xs_trans_empty);
-		return (shutdown);
+	if (!(tp->t_flags & XFS_TRANS_DIRTY))
+		goto out_unreserve;
+
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		error = XFS_ERROR(EIO);
+		goto out_unreserve;
 	}
+
 	ASSERT(tp->t_ticket != NULL);
 
 	/*
@@ -1086,7 +1068,8 @@ shut_us_down:
 	error = xfs_trans_commit_iclog(mp, tp, &commit_lsn, flags);
 	if (error == ENOMEM) {
 		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
-		goto shut_us_down;
+		error = XFS_ERROR(EIO);
+		goto out_unreserve;
 	}
 
 	/*
@@ -1103,7 +1086,29 @@ shut_us_down:
 		XFS_STATS_INC(xs_trans_async);
 	}
 
-	return (error);
+	return error;
+
+out_unreserve:
+	xfs_trans_unreserve_and_mod_sb(tp);
+
+	/*
+	 * It is indeed possible for the transaction to be not dirty but
+	 * the dqinfo portion to be.  All that means is that we have some
+	 * (non-persistent) quota reservations that need to be unreserved.
+	 */
+	xfs_trans_unreserve_and_mod_dquots(tp);
+	if (tp->t_ticket) {
+		commit_lsn = xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
+		if (commit_lsn == -1 && !error)
+			error = XFS_ERROR(EIO);
+	}
+	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
+	xfs_trans_free_items(tp, error ? XFS_TRANS_ABORT : 0);
+	xfs_trans_free_busy(tp);
+	xfs_trans_free(tp);
+
+	XFS_STATS_INC(xs_trans_empty);
+	return error;
 }
 
 /*
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
