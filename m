Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37978 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932885AbeCMKts (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 06:49:48 -0400
Received: from 77.117.139.172.wireless.dyn.drei.com ([77.117.139.172] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evhV5-0006H2-TJ
        for linux-xfs@vger.kernel.org; Tue, 13 Mar 2018 10:49:48 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/8] xfs: merge _xfs_log_force_lsn and xfs_log_force_lsn
Date: Tue, 13 Mar 2018 11:49:24 +0100
Message-Id: <20180313104927.12926-6-hch@lst.de>
In-Reply-To: <20180313104927.12926-1-hch@lst.de>
References: <20180313104927.12926-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Switch to a single interface for flushing the log to a specific LSN, which
gives consistent trace point coverage and a less confusing interface.

The was only a single user of the previous xfs_log_force_lsn function,
which now also passes a NULL log_flushed argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_export.c |  2 +-
 fs/xfs/xfs_file.c   |  4 ++--
 fs/xfs/xfs_inode.c  |  2 +-
 fs/xfs/xfs_log.c    | 18 ++----------------
 fs/xfs/xfs_log.h    |  9 ++-------
 fs/xfs/xfs_trans.c  |  2 +-
 6 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index fe1bfee35898..761f3189eff2 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -237,7 +237,7 @@ xfs_fs_nfs_commit_metadata(
 
 	if (!lsn)
 		return 0;
-	return _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
+	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
 }
 
 const struct export_operations xfs_export_operations = {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9ea08326f876..f5c5dbbf1792 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -122,7 +122,7 @@ xfs_dir_fsync(
 
 	if (!lsn)
 		return 0;
-	return _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
+	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
 }
 
 STATIC int
@@ -182,7 +182,7 @@ xfs_file_fsync(
 	}
 
 	if (lsn) {
-		error = _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
+		error = xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
 		ip->i_itemp->ili_fsync_fields = 0;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 604ee384a00a..b7872e82fdad 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2497,7 +2497,7 @@ xfs_iunpin(
 	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
 
 	/* Give the log a push to start the unpinning I/O */
-	xfs_log_force_lsn(ip->i_mount, ip->i_itemp->ili_last_lsn, 0);
+	xfs_log_force_lsn(ip->i_mount, ip->i_itemp->ili_last_lsn, 0, NULL);
 
 }
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index dbb0d69445e8..14ab660a0bae 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3429,7 +3429,7 @@ xfs_log_force(
  * sv.
  */
 int
-_xfs_log_force_lsn(
+xfs_log_force_lsn(
 	struct xfs_mount	*mp,
 	xfs_lsn_t		lsn,
 	uint			flags,
@@ -3442,6 +3442,7 @@ _xfs_log_force_lsn(
 	ASSERT(lsn != 0);
 
 	XFS_STATS_INC(mp, xs_log_force);
+	trace_xfs_log_force(mp, lsn, _RET_IP_);
 
 	lsn = xlog_cil_force_lsn(log, lsn);
 	if (lsn == NULLCOMMITLSN)
@@ -3538,21 +3539,6 @@ _xfs_log_force_lsn(
 	return 0;
 }
 
-/*
- * Wrapper for _xfs_log_force_lsn(), to be used when caller doesn't care
- * about errors or whether the log was flushed or not. This is the normal
- * interface to use when trying to unpin items or move the log forward.
- */
-void
-xfs_log_force_lsn(
-	xfs_mount_t	*mp,
-	xfs_lsn_t	lsn,
-	uint		flags)
-{
-	trace_xfs_log_force(mp, lsn, _RET_IP_);
-	_xfs_log_force_lsn(mp, lsn, flags, NULL);
-}
-
 /*
  * Called when we want to mark the current iclog as being ready to sync to
  * disk.
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 726dd9a330b4..7e2d62922a16 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -130,13 +130,8 @@ xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
 		       struct xlog_in_core **iclog,
 		       bool regrant);
 int	  xfs_log_force(struct xfs_mount *mp, uint flags);
-int	  _xfs_log_force_lsn(struct xfs_mount *mp,
-			     xfs_lsn_t		lsn,
-			     uint		flags,
-			     int		*log_forced);
-void	  xfs_log_force_lsn(struct xfs_mount	*mp,
-			    xfs_lsn_t		lsn,
-			    uint		flags);
+int	  xfs_log_force_lsn(struct xfs_mount *mp, xfs_lsn_t lsn, uint flags,
+		int *log_forced);
 int	  xfs_log_mount(struct xfs_mount	*mp,
 			struct xfs_buftarg	*log_target,
 			xfs_daddr_t		start_block,
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 86f92df32c42..97d18bafe556 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -966,7 +966,7 @@ __xfs_trans_commit(
 	 * log out now and wait for it.
 	 */
 	if (sync) {
-		error = _xfs_log_force_lsn(mp, commit_lsn, XFS_LOG_SYNC, NULL);
+		error = xfs_log_force_lsn(mp, commit_lsn, XFS_LOG_SYNC, NULL);
 		XFS_STATS_INC(mp, xs_trans_sync);
 	} else {
 		XFS_STATS_INC(mp, xs_trans_async);
-- 
2.14.2

