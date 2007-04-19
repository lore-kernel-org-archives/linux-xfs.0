Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 00:37:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3J7bLfB009730
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 00:37:23 -0700
Date: Thu, 19 Apr 2007 17:37:14 +1000
From: David Chinner <dgc@sgi.com>
Subject: review: handle barriers being switched off dynamically.
Message-ID: <20070419073714.GU48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


As pointed out by Neil Brown, MD can switch barriers off
dynamically underneath a mounted filesystem. If this happens
to XFS, it will shutdown the filesystem immediately.

Handle this more sanely by yelling into the syslog, retrying
the I/O without barriers and if that is successful, turn
off barriers.

Also remove an unnecessary check when first checking to
see if the underlying device supports barriers.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_buf.c   |   13 ++++++++++++-
 fs/xfs/linux-2.6/xfs_super.c |    8 --------
 fs/xfs/xfs_log.c             |   13 +++++++++++++
 3 files changed, 25 insertions(+), 9 deletions(-)
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-04-19 13:26:49.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c	2007-04-19 13:27:01.733786992 +1000
@@ -1000,7 +1000,18 @@ xfs_buf_iodone_work(
 	xfs_buf_t		*bp =
 		container_of(work, xfs_buf_t, b_iodone_work);
 
-	if (bp->b_iodone)
+	/*
+	 * We can get an EOPNOTSUPP to ordered writes.  Here we clear the
+	 * ordered flag and reissue them.  Because we can't tell the higher
+	 * layers directly that they should not issue ordered I/O anymore, they
+	 * need to check if the ordered flag was cleared during I/O completion.
+	 */
+	if ((bp->b_error == EOPNOTSUPP) &&
+	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
+		XB_TRACE(bp, "ordered_retry", bp->b_iodone);
+		bp->b_flags &= ~XBF_ORDERED;
+		xfs_buf_iorequest(bp);
+	} else if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
 	else if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_relse(bp);
Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2007-04-19 13:27:00.245980891 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2007-04-19 13:27:01.753784386 +1000
@@ -961,6 +961,19 @@ xlog_iodone(xfs_buf_t *bp)
 	l = iclog->ic_log;
 
 	/*
+	 * If the ordered flag has been removed by a lower
+	 * layer, it means the underlyin device no longer supports
+	 * barrier I/O. Warn loudly and turn off barriers.
+	 */
+	if ((l->l_mp->m_flags & XFS_MOUNT_BARRIER) && !XFS_BUF_ORDERED(bp)) {
+		l->l_mp->m_flags &= ~XFS_MOUNT_BARRIER;
+		xfs_fs_cmn_err(CE_WARN, l->l_mp,
+				"xlog_iodone: Barriers are no longer supported"
+				" by device. Disabling barriers\n");
+		xfs_buftrace("XLOG_IODONE BARRIERS OFF", bp);
+	}
+
+	/*
 	 * Race to shutdown the filesystem if we see an error.
 	 */
 	if (XFS_TEST_ERROR((XFS_BUF_GETERROR(bp)), l->l_mp,
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2007-04-19 13:27:00.277976721 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2007-04-19 13:27:01.757783865 +1000
@@ -314,14 +314,6 @@ xfs_mountfs_check_barriers(xfs_mount_t *
 		return;
 	}
 
-	if (mp->m_ddev_targp->bt_bdev->bd_disk->queue->ordered ==
-					QUEUE_ORDERED_NONE) {
-		xfs_fs_cmn_err(CE_NOTE, mp,
-		  "Disabling barriers, not supported by the underlying device");
-		mp->m_flags &= ~XFS_MOUNT_BARRIER;
-		return;
-	}
-
 	if (xfs_readonly_buftarg(mp->m_ddev_targp)) {
 		xfs_fs_cmn_err(CE_NOTE, mp,
 		  "Disabling barriers, underlying device is readonly");
