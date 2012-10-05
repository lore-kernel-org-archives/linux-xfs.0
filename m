Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95HIJ03071528 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 12:18:19 -0500
Message-Id: <20121005171945.888412779@sgi.com>
Date: Fri, 05 Oct 2012 12:18:57 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [patch v4 04/13] [PATCH 04/13] xfs: sync work is now only periodic
	log work
References: <20121005171853.985930109@sgi.com>
Content-Disposition: inline;
	filename=xfs-sync-work-is-now-only-periodic-log-work.patch
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

The only thing the periodic sync work does now is flush the AIL and
idle the log. These are really functions of the log code, so move
the work to xfs_log.c and rename it appropriately.

The only wart that this leaves behind is the xfssyncd_centisecs
sysctl, otherwise the xfssyncd is dead. Clean up any comments that
related to xfssyncd to reflect it's passing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>

---
 fs/xfs/xfs_log.c      |   41 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_log.h      |    3 +++
 fs/xfs/xfs_log_priv.h |    1 +
 fs/xfs/xfs_mount.h    |    1 -
 fs/xfs/xfs_super.c    |   16 ++++------------
 fs/xfs/xfs_sync.c     |   39 +++------------------------------------
 fs/xfs/xfs_sync.h     |    2 --
 7 files changed, 51 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7f4f937..a1fe7a7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -34,6 +34,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_trace.h"
+#include "xfs_fsops.h"
 
 kmem_zone_t	*xfs_log_ticket_zone;
 
@@ -698,6 +699,8 @@ xfs_log_mount_finish(xfs_mount_t *mp)
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 	}
 
+	xfs_log_work_queue(mp);
+
 	return error;
 }
 
@@ -858,7 +861,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 void
 xfs_log_unmount(xfs_mount_t *mp)
 {
-	cancel_delayed_work_sync(&mp->m_sync_work);
+	cancel_delayed_work_sync(&mp->m_log->l_work);
 	xfs_trans_ail_destroy(mp);
 	xlog_dealloc_log(mp->m_log);
 }
@@ -1161,6 +1164,40 @@ done:
 }	/* xlog_get_iclog_buffer_size */
 
 
+void
+xfs_log_work_queue(
+	struct xfs_mount        *mp)
+{
+	queue_delayed_work(xfs_syncd_wq, &mp->m_log->l_work,
+				msecs_to_jiffies(xfs_syncd_centisecs * 10));
+}
+
+/*
+ * Every sync period we need to unpin all items in the AIL and push them to
+ * disk. If there is nothing dirty, then we might need to cover the log to
+ * indicate that the filesystem is idle.
+ */
+void
+xfs_log_worker(
+	struct work_struct	*work)
+{
+	struct xlog		*log = container_of(to_delayed_work(work),
+						struct xlog, l_work);
+	struct xfs_mount	*mp = log->l_mp;
+
+	/* dgc: errors ignored - not fatal and nowhere to report them */
+	if (xfs_log_need_covered(mp))
+		xfs_fs_log_dummy(mp);
+	else
+		xfs_log_force(mp, 0);
+
+	/* start pushing all the metadata that is currently dirty */
+	xfs_ail_push_all(mp->m_ail);
+
+	/* queue us up again */
+	xfs_log_work_queue(mp);
+}
+
 /*
  * This routine initializes some of the log structure for a given mount point.
  * Its primary purpose is to fill in enough, so recovery can occur.  However,
@@ -1195,6 +1232,7 @@ xlog_alloc_log(
 	log->l_logBBsize   = num_bblks;
 	log->l_covered_state = XLOG_STATE_COVER_IDLE;
 	log->l_flags	   |= XLOG_ACTIVE_RECOVERY;
+	INIT_DELAYED_WORK(&log->l_work, xfs_log_worker);
 
 	log->l_prev_block  = -1;
 	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
@@ -3700,3 +3738,4 @@ xlog_iclogs_empty(
 	} while (iclog != log->l_iclog);
 	return 1;
 }
+
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 748d312..26ed7de 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -181,5 +181,8 @@ int	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
 				xfs_lsn_t *commit_lsn, int flags);
 bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
+void	xfs_log_work_queue(struct xfs_mount *mp);
+void	xfs_log_worker(struct work_struct *work);
+
 #endif
 #endif	/* __XFS_LOG_H__ */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 18a801d..9a4e0e5 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -495,6 +495,7 @@ struct xlog {
 	struct xfs_buf		*l_xbuf;        /* extra buffer for log
 						 * wrapping */
 	struct xfs_buftarg	*l_targ;        /* buftarg of log */
+	struct delayed_work	l_work;		/* background flush work */
 	uint			l_flags;
 	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
 	struct list_head	*l_buf_cancel_table;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index deee09e..26e46ae 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -197,7 +197,6 @@ typedef struct xfs_mount {
 	struct mutex		m_icsb_mutex;	/* balancer sync lock */
 #endif
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
-	struct delayed_work	m_sync_work;	/* background sync work */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct work_struct	m_flush_work;	/* background inode flush */
 	__int64_t		m_update_flags;	/* sb flags we need to update
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f6147ae..b85ca2d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -918,7 +918,6 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
-	cancel_delayed_work_sync(&mp->m_sync_work);
 	cancel_work_sync(&mp->m_flush_work);
 
 	xfs_filestream_unmount(mp);
@@ -953,10 +952,10 @@ xfs_fs_sync_fs(
 	if (laptop_mode) {
 		/*
 		 * The disk must be active because we're syncing.
-		 * We schedule xfssyncd now (now that the disk is
+		 * We schedule log work now (now that the disk is
 		 * active) instead of later (when it might not be).
 		 */
-		flush_delayed_work_sync(&mp->m_sync_work);
+		flush_delayed_work_sync(&mp->m_log->l_work);
 	}
 
 	return 0;
@@ -1107,7 +1106,7 @@ xfs_fs_remount(
 		 * value if it is non-zero, otherwise go with the default.
 		 */
 		xfs_restore_resvblks(mp);
-		xfs_syncd_queue_sync(mp);
+		xfs_log_work_queue(mp);
 	}
 
 	/* rw -> ro */
@@ -1153,7 +1152,7 @@ xfs_fs_unfreeze(
 	struct xfs_mount	*mp = XFS_M(sb);
 
 	xfs_restore_resvblks(mp);
-	xfs_syncd_queue_sync(mp);
+	xfs_log_work_queue(mp);
 	return 0;
 }
 
@@ -1233,7 +1232,6 @@ xfs_fs_fill_super(
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
-	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 
 	mp->m_super = sb;
@@ -1317,12 +1315,6 @@ xfs_fs_fill_super(
 		goto out_unmount;
 	}
 
-	/*
-	 * The filesystem is successfully mounted, so we can start background
-	 * sync work now.
-	 */
-	xfs_syncd_queue_sync(mp);
-
 	return 0;
 
  out_filestream_unmount:
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 5d69f23..7527610 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -19,6 +19,7 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
@@ -344,8 +345,8 @@ xfs_quiesce_attr(
 	/* flush all pending changes from the AIL */
 	xfs_ail_push_all_sync(mp->m_ail);
 
-	/* stop background sync work */
-	cancel_delayed_work_sync(&mp->m_sync_work);
+	/* stop background log work */
+	cancel_delayed_work_sync(&mp->m_log->l_work);
 
 	/*
 	 * Just warn here till VFS can correctly support
@@ -376,40 +377,6 @@ xfs_quiesce_attr(
 	xfs_buf_unlock(mp->m_sb_bp);
 }
 
-void
-xfs_syncd_queue_sync(
-	struct xfs_mount        *mp)
-{
-	queue_delayed_work(xfs_syncd_wq, &mp->m_sync_work,
-				msecs_to_jiffies(xfs_syncd_centisecs * 10));
-}
-
-/*
- * Every sync period we need to push dirty metadata and try to cover the log
- * to indicate the filesystem is idle and not frozen.
- */
-void
-xfs_sync_worker(
-	struct work_struct *work)
-{
-	struct xfs_mount *mp = container_of(to_delayed_work(work),
-					struct xfs_mount, m_sync_work);
-	int		error;
-
-	/* dgc: errors ignored here */
-	if (mp->m_super->s_writers.frozen == SB_UNFROZEN &&
-	    xfs_log_need_covered(mp))
-		error = xfs_fs_log_dummy(mp);
-	else
-		xfs_log_force(mp, 0);
-
-	/* start pushing all the metadata that is currently dirty */
-	xfs_ail_push_all(mp->m_ail);
-
-	/* queue us up again */
-	xfs_syncd_queue_sync(mp);
-}
-
 /*
  * Queue a new inode reclaim pass if there are reclaimable inodes and there
  * isn't a reclaim pass already in progress. By default it runs every 5s based
diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
index 3f59e5b..8d58fab 100644
--- a/fs/xfs/xfs_sync.h
+++ b/fs/xfs/xfs_sync.h
@@ -26,8 +26,6 @@ struct xfs_perag;
 
 extern struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
 
-void xfs_syncd_queue_sync(struct xfs_mount *mp);
-void xfs_sync_worker(struct work_struct *work);
 void xfs_flush_worker(struct work_struct *work);
 void xfs_reclaim_worker(struct work_struct *work);
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
