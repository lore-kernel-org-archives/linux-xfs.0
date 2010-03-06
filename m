Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o26B74LR080994 for <xfs@oss.sgi.com>; Sat, 6 Mar 2010 05:07:04 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 339D321FC0B
	for <xfs@oss.sgi.com>; Sat,  6 Mar 2010 03:08:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yoIJvSrAx9E52nZQ for
	<xfs@oss.sgi.com>; Sat, 06 Mar 2010 03:08:34 -0800 (PST)
Date: Sat, 6 Mar 2010 06:08:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] xfs: split out iclog writing from xfs_trans_commit()
Message-ID: <20100306110833.GF30376@infradead.org>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
	<1267840284-4652-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267840284-4652-6-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, Mar 06, 2010 at 12:51:20PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Split the the part of xfs_trans_commit() that deals with writing the
> transaction into the iclog into a separate function. This isolates the
> physical commit process from the logical commit operation and makes
> it easier to insert different transaction commit paths without affecting
> the existing algorithm adversely.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good, but some comments below:

> +        if (nvec > XFS_TRANS_LOGVEC_COUNT)
> +                kmem_free(log_vector);

These two lines are indented with whitespaces instead of tabs.

> +shut_us_down:
> +	shutdown = XFS_FORCED_SHUTDOWN(mp) ? EIO : 0;
> +	if (!(tp->t_flags & XFS_TRANS_DIRTY) || shutdown) {
> +		xfs_trans_unreserve_and_mod_sb(tp);
> +		/*

This whole area in _xfs_trans_commit is still a complete mess.


What about throwing the patch below in once you're rewriting it anyway?


Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-03-06 12:03:05.567023865 +0100
+++ xfs/fs/xfs/xfs_trans.c	2010-03-06 12:04:47.610255671 +0100
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
+		error = EIO;
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
+		error = EIO;
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
