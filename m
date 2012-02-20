Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1K2lRZm042480 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 20:47:27 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Fnv85WnD6ArB4z3C (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 18:31:53 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RzJ2e-0005eR-Lu
	for xfs@oss.sgi.com; Mon, 20 Feb 2012 02:31:52 +0000
Message-Id: <20120220023152.624381403@bombadil.infradead.org>
Date: Sun, 19 Feb 2012 21:31:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/12] xfs: cleanup xfs_log_space_wake
References: <20120220023119.435889631@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_log_space_wake
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

Remove the now unused opportunistic parameter, and use the the
xlog_writeq_wake and xlog_reserveq_wake helpers now that we don't have
to care about the opportunistic wakeups.

Reviewed-by: Ben Myers <bpm@sgi.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_log.c       |   35 +++++------------------------------
 fs/xfs/xfs_log.h       |    3 +--
 fs/xfs/xfs_trans_ail.c |    4 ++--
 3 files changed, 8 insertions(+), 34 deletions(-)

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-11-29 08:42:35.235496706 +0100
+++ xfs/fs/xfs/xfs_log.c	2011-11-29 08:44:52.854751157 +0100
@@ -762,18 +762,13 @@ xfs_log_item_init(
 
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
@@ -783,16 +778,7 @@ xfs_log_space_wake(
 
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
 
@@ -801,18 +787,7 @@ xfs_log_space_wake(
 
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
@@ -2748,7 +2723,7 @@ xlog_ungrant_log_space(xlog_t	     *log,
 
 	trace_xfs_log_ungrant_exit(log, ticket);
 
-	xfs_log_space_wake(log->l_mp, false);
+	xfs_log_space_wake(log->l_mp);
 }
 
 /*
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2011-11-29 08:42:35.255496597 +0100
+++ xfs/fs/xfs/xfs_log.h	2011-11-29 08:42:52.682068856 +0100
@@ -161,8 +161,7 @@ int	  xfs_log_mount(struct xfs_mount	*mp
 			int		 	num_bblocks);
 int	  xfs_log_mount_finish(struct xfs_mount *mp);
 xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
-void	  xfs_log_space_wake(struct xfs_mount	*mp,
-			     bool		opportunistic);
+void	  xfs_log_space_wake(struct xfs_mount *mp);
 int	  xfs_log_notify(struct xfs_mount	*mp,
 			 struct xlog_in_core	*iclog,
 			 xfs_log_callback_t	*callback_entry);
Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2011-11-29 08:42:35.275496489 +0100
+++ xfs/fs/xfs/xfs_trans_ail.c	2011-11-29 08:42:44.325447461 +0100
@@ -671,7 +671,7 @@ xfs_trans_ail_update_bulk(
 
 	if (mlip_changed && !XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
 		xlog_assign_tail_lsn(ailp->xa_mount);
-		xfs_log_space_wake(ailp->xa_mount, false);
+		xfs_log_space_wake(ailp->xa_mount);
 	}
 }
 
@@ -733,7 +733,7 @@ xfs_trans_ail_delete_bulk(
 
 	if (mlip_changed && !XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
 		xlog_assign_tail_lsn(ailp->xa_mount);
-		xfs_log_space_wake(ailp->xa_mount, false);
+		xfs_log_space_wake(ailp->xa_mount);
 	}
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
