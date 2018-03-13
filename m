Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37958 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932885AbeCMKto (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 06:49:44 -0400
Received: from 77.117.139.172.wireless.dyn.drei.com ([77.117.139.172] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evhV1-0006G7-Qj
        for linux-xfs@vger.kernel.org; Tue, 13 Mar 2018 10:49:44 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/8] xfs: merge _xfs_log_force and xfs_log_force
Date: Tue, 13 Mar 2018 11:49:23 +0100
Message-Id: <20180313104927.12926-5-hch@lst.de>
In-Reply-To: <20180313104927.12926-1-hch@lst.de>
References: <20180313104927.12926-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Switch to a single interface for flushing the whole log, which gives
consistent trace point coverage, and removes the unused log_flushed
argument for the previous _xfs_log_force callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c    |  2 +-
 fs/xfs/xfs_extent_busy.c |  3 +--
 fs/xfs/xfs_log.c         | 26 +++++---------------------
 fs/xfs/xfs_log.h         |  6 +-----
 4 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 8033ab9d8f47..ddcdda336402 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -619,7 +619,7 @@ xfs_scrub_checkpoint_log(
 {
 	int			error;
 
-	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
+	error = xfs_log_force(mp, XFS_LOG_SYNC);
 	if (error)
 		return error;
 	xfs_ail_push_all_sync(mp->m_ail);
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 1b439db95634..13e3d1a69e76 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -613,8 +613,7 @@ xfs_extent_busy_flush(
 	DEFINE_WAIT		(wait);
 	int			error;
 
-	trace_xfs_log_force(mp, 0, _THIS_IP_);
-	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
+	error = xfs_log_force(mp, XFS_LOG_SYNC);
 	if (error)
 		return;
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3e5ba1ecc080..dbb0d69445e8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -869,7 +869,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		return 0;
 	}
 
-	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
+	error = xfs_log_force(mp, XFS_LOG_SYNC);
 	ASSERT(error || !(XLOG_FORCED_SHUTDOWN(log)));
 
 #ifdef DEBUG
@@ -3304,16 +3304,16 @@ xlog_state_switch_iclogs(
  *		not in the active nor dirty state.
  */
 int
-_xfs_log_force(
+xfs_log_force(
 	struct xfs_mount	*mp,
-	uint			flags,
-	int			*log_flushed)
+	uint			flags)
 {
 	struct xlog		*log = mp->m_log;
 	struct xlog_in_core	*iclog;
 	xfs_lsn_t		lsn;
 
 	XFS_STATS_INC(mp, xs_log_force);
+	trace_xfs_log_force(mp, 0, _RET_IP_);
 
 	xlog_cil_force(log);
 
@@ -3362,8 +3362,6 @@ _xfs_log_force(
 				if (xlog_state_release_iclog(log, iclog))
 					return -EIO;
 
-				if (log_flushed)
-					*log_flushed = 1;
 				spin_lock(&log->l_icloglock);
 				if (be64_to_cpu(iclog->ic_header.h_lsn) == lsn &&
 				    iclog->ic_state != XLOG_STATE_DIRTY)
@@ -3415,20 +3413,6 @@ _xfs_log_force(
 	return 0;
 }
 
-/*
- * Wrapper for _xfs_log_force(), to be used when caller doesn't care
- * about errors or whether the log was flushed or not. This is the normal
- * interface to use when trying to unpin items or move the log forward.
- */
-void
-xfs_log_force(
-	xfs_mount_t	*mp,
-	uint		flags)
-{
-	trace_xfs_log_force(mp, 0, _RET_IP_);
-	_xfs_log_force(mp, flags, NULL);
-}
-
 /*
  * Force the in-core log to disk for a specific LSN.
  *
@@ -4035,7 +4019,7 @@ xfs_log_force_umount(
 	 * to guarantee this.
 	 */
 	if (!logerror)
-		_xfs_log_force(mp, XFS_LOG_SYNC, NULL);
+		xfs_log_force(mp, XFS_LOG_SYNC);
 
 	/*
 	 * mark the filesystem and the as in a shutdown state and wake
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index bf212772595c..726dd9a330b4 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -129,11 +129,7 @@ xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
 		       struct xlog_ticket *ticket,
 		       struct xlog_in_core **iclog,
 		       bool regrant);
-int	  _xfs_log_force(struct xfs_mount *mp,
-			 uint		flags,
-			 int		*log_forced);
-void	  xfs_log_force(struct xfs_mount	*mp,
-			uint			flags);
+int	  xfs_log_force(struct xfs_mount *mp, uint flags);
 int	  _xfs_log_force_lsn(struct xfs_mount *mp,
 			     xfs_lsn_t		lsn,
 			     uint		flags,
-- 
2.14.2

