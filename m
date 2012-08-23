Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53UPP135113 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:30 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	XGpKPTL99ml14Mrc for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:15 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PaU-0003GT-Tp
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:10 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaK-0003eM-Qn
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 039/102] xfs: cleanup xfs_log_space_wake
Date: Thu, 23 Aug 2012 15:01:57 +1000
Message-Id: <1345698180-13612-40-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

Upstream commit: cfb7cdca0aca5ee2e2ef491284bf1edc3b581885

Remove the now unused opportunistic parameter, and use the the
xlog_writeq_wake and xlog_reserveq_wake helpers now that we don't have
to care about the opportunistic wakeups.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_log.c       |   35 +++++------------------------------
 fs/xfs/xfs_log.h       |    3 +--
 fs/xfs/xfs_trans_ail.c |    4 ++--
 3 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ccb6199..d299223 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -794,18 +794,13 @@ xfs_log_write(
 
 /*
  * Wake up processes waiting for log space after we have moved the log tail.
- *
- * If opportunistic is set wake up one waiter even if we do not have enough
- * free space by our strict accounting.
  */
 void
 xfs_log_space_wake(
-	struct xfs_mount	*mp,
-	bool			opportunistic)
+	struct xfs_mount	*mp)
 {
-	struct xlog_ticket	*tic;
 	struct log		*log = mp->m_log;
-	int			need_bytes, free_bytes;
+	int			free_bytes;
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
@@ -815,16 +810,7 @@ xfs_log_space_wake(
 
 		spin_lock(&log->l_grant_write_lock);
 		free_bytes = xlog_space_left(log, &log->l_grant_write_head);
-		list_for_each_entry(tic, &log->l_writeq, t_queue) {
-			ASSERT(tic->t_flags & XLOG_TIC_PERM_RESERV);
-
-			if (free_bytes < tic->t_unit_res && !opportunistic)
-				break;
-			opportunistic = false;
-			free_bytes -= tic->t_unit_res;
-			trace_xfs_log_regrant_write_wake_up(log, tic);
-			wake_up(&tic->t_wait);
-		}
+		xlog_writeq_wake(log, &free_bytes);
 		spin_unlock(&log->l_grant_write_lock);
 	}
 
@@ -833,18 +819,7 @@ xfs_log_space_wake(
 
 		spin_lock(&log->l_grant_reserve_lock);
 		free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
-		list_for_each_entry(tic, &log->l_reserveq, t_queue) {
-			if (tic->t_flags & XLOG_TIC_PERM_RESERV)
-				need_bytes = tic->t_unit_res*tic->t_cnt;
-			else
-				need_bytes = tic->t_unit_res;
-			if (free_bytes < need_bytes && !opportunistic)
-				break;
-			opportunistic = false;
-			free_bytes -= need_bytes;
-			trace_xfs_log_grant_wake_up(log, tic);
-			wake_up(&tic->t_wait);
-		}
+		xlog_reserveq_wake(log, &free_bytes);
 		spin_unlock(&log->l_grant_reserve_lock);
 	}
 }
@@ -2796,7 +2771,7 @@ xlog_ungrant_log_space(xlog_t	     *log,
 
 	trace_xfs_log_ungrant_exit(log, ticket);
 
-	xfs_log_space_wake(log->l_mp, false);
+	xfs_log_space_wake(log->l_mp);
 }
 
 /*
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index e9ef054..953358b 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -161,8 +161,7 @@ int	  xfs_log_mount(struct xfs_mount	*mp,
 			int		 	num_bblocks);
 int	  xfs_log_mount_finish(struct xfs_mount *mp);
 xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
-void	  xfs_log_space_wake(struct xfs_mount	*mp,
-			     bool		opportunistic);
+void	  xfs_log_space_wake(struct xfs_mount *mp);
 int	  xfs_log_notify(struct xfs_mount	*mp,
 			 struct xlog_in_core	*iclog,
 			 xfs_log_callback_t	*callback_entry);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 3934d97..a0ee8c8 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -720,7 +720,7 @@ xfs_trans_ail_update_bulk(
 
 	if (mlip_changed && !XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
 		xlog_assign_tail_lsn(ailp->xa_mount);
-		xfs_log_space_wake(ailp->xa_mount, false);
+		xfs_log_space_wake(ailp->xa_mount);
 	}
 }
 
@@ -782,7 +782,7 @@ xfs_trans_ail_delete_bulk(
 
 	if (mlip_changed && !XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
 		xlog_assign_tail_lsn(ailp->xa_mount);
-		xfs_log_space_wake(ailp->xa_mount, false);
+		xfs_log_space_wake(ailp->xa_mount);
 	}
 }
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
