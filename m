Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4RGfkDW027928 for <xfs@oss.sgi.com>; Fri, 27 May 2011 11:41:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 794481E36638
	for <xfs@oss.sgi.com>; Fri, 27 May 2011 09:41:41 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	hTjCW4jEVMB3n87W for <xfs@oss.sgi.com>;
	Fri, 27 May 2011 09:41:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QQ06T-0001cW-Ca
	for xfs@oss.sgi.com; Fri, 27 May 2011 16:41:37 +0000
Date: Fri, 27 May 2011 12:41:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: make log devices with write back caches work
Message-ID: <20110527164137.GA5833@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

There's no reason not to support cache flushing on external log devices.
The only thing this really requires is flushing the data device first
both in fsync and log commits.  A side effect is that we also have to
remove the barrier write test during mount, which has been superflous
since the new FLUSH+FUA code anyway.  Also use the chance to flush the
RT subvolume write cache before the fsync commit, which is required
for correct semantics.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2011-05-27 13:07:41.260498122 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2011-05-27 17:37:30.152495811 +0200
@@ -131,19 +131,32 @@ xfs_file_fsync(
 {
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	int			error = 0;
 	int			log_flushed = 0;
 
 	trace_xfs_file_fsync(ip);
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (XFS_FORCED_SHUTDOWN(mp))
 		return -XFS_ERROR(EIO);
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 
 	xfs_ioend_wait(ip);
 
+	if (mp->m_flags & XFS_MOUNT_BARRIER) {
+		/*
+		 * If we have an RT and/or log subvolume we need to make sure
+		 * to flush the write cache on the device that the data
+		 * resides before commit the transaction.
+		 */
+		if (XFS_IS_REALTIME_INODE(ip))
+			xfs_blkdev_issue_flush(mp->m_rtdev_targp);
+		else if (mp->m_logdev_targp != mp->m_ddev_targp)
+			xfs_blkdev_issue_flush(mp->m_ddev_targp);
+	}
+
 	/*
 	 * We always need to make sure that the required inode state is safe on
 	 * disk.  The inode might be clean but we still might need to force the
@@ -175,9 +188,9 @@ xfs_file_fsync(
 		 * updates.  The sync transaction will also force the log.
 		 */
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_FSYNC_TS);
+		tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
 		error = xfs_trans_reserve(tp, 0,
-				XFS_FSYNC_TS_LOG_RES(ip->i_mount), 0, 0, 0);
+				XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
 		if (error) {
 			xfs_trans_cancel(tp, 0);
 			return -error;
@@ -209,28 +222,23 @@ xfs_file_fsync(
 		 * force the log.
 		 */
 		if (xfs_ipincount(ip)) {
-			error = _xfs_log_force_lsn(ip->i_mount,
+			error = _xfs_log_force_lsn(mp,
 					ip->i_itemp->ili_last_lsn,
 					XFS_LOG_SYNC, &log_flushed);
 		}
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	}
 
-	if (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) {
-		/*
-		 * If the log write didn't issue an ordered tag we need
-		 * to flush the disk cache for the data device now.
-		 */
-		if (!log_flushed)
-			xfs_blkdev_issue_flush(ip->i_mount->m_ddev_targp);
-
-		/*
-		 * If this inode is on the RT dev we need to flush that
-		 * cache as well.
-		 */
-		if (XFS_IS_REALTIME_INODE(ip))
-			xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
-	}
+	/*
+	 * Flush the write cache on the data volume, if the data for this
+	 * inode actually resides on it, and the transaction commit did
+	 * not flush it yet.
+	 */
+	if ((mp->m_flags & XFS_MOUNT_BARRIER) &&
+	    mp->m_logdev_targp == mp->m_ddev_targp &&
+	    !XFS_IS_REALTIME_INODE(ip) &&
+	    !log_flushed)
+		xfs_blkdev_issue_flush(mp->m_ddev_targp);
 
 	return -error;
 }
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2011-05-27 13:07:41.272495356 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2011-05-27 15:37:11.673496345 +0200
@@ -627,68 +627,6 @@ xfs_blkdev_put(
 		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 }
 
-/*
- * Try to write out the superblock using barriers.
- */
-STATIC int
-xfs_barrier_test(
-	xfs_mount_t	*mp)
-{
-	xfs_buf_t	*sbp = xfs_getsb(mp, 0);
-	int		error;
-
-	XFS_BUF_UNDONE(sbp);
-	XFS_BUF_UNREAD(sbp);
-	XFS_BUF_UNDELAYWRITE(sbp);
-	XFS_BUF_WRITE(sbp);
-	XFS_BUF_UNASYNC(sbp);
-	XFS_BUF_ORDERED(sbp);
-
-	xfsbdstrat(mp, sbp);
-	error = xfs_buf_iowait(sbp);
-
-	/*
-	 * Clear all the flags we set and possible error state in the
-	 * buffer.  We only did the write to try out whether barriers
-	 * worked and shouldn't leave any traces in the superblock
-	 * buffer.
-	 */
-	XFS_BUF_DONE(sbp);
-	XFS_BUF_ERROR(sbp, 0);
-	XFS_BUF_UNORDERED(sbp);
-
-	xfs_buf_relse(sbp);
-	return error;
-}
-
-STATIC void
-xfs_mountfs_check_barriers(xfs_mount_t *mp)
-{
-	int error;
-
-	if (mp->m_logdev_targp != mp->m_ddev_targp) {
-		xfs_notice(mp,
-		  "Disabling barriers, not supported with external log device");
-		mp->m_flags &= ~XFS_MOUNT_BARRIER;
-		return;
-	}
-
-	if (xfs_readonly_buftarg(mp->m_ddev_targp)) {
-		xfs_notice(mp,
-			"Disabling barriers, underlying device is readonly");
-		mp->m_flags &= ~XFS_MOUNT_BARRIER;
-		return;
-	}
-
-	error = xfs_barrier_test(mp);
-	if (error) {
-		xfs_notice(mp,
-			"Disabling barriers, trial barrier write failed");
-		mp->m_flags &= ~XFS_MOUNT_BARRIER;
-		return;
-	}
-}
-
 void
 xfs_blkdev_issue_flush(
 	xfs_buftarg_t		*buftarg)
@@ -1239,14 +1177,6 @@ xfs_fs_remount(
 		switch (token) {
 		case Opt_barrier:
 			mp->m_flags |= XFS_MOUNT_BARRIER;
-
-			/*
-			 * Test if barriers are actually working if we can,
-			 * else delay this check until the filesystem is
-			 * marked writeable.
-			 */
-			if (!(mp->m_flags & XFS_MOUNT_RDONLY))
-				xfs_mountfs_check_barriers(mp);
 			break;
 		case Opt_nobarrier:
 			mp->m_flags &= ~XFS_MOUNT_BARRIER;
@@ -1281,8 +1211,6 @@ xfs_fs_remount(
 	/* ro -> rw */
 	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)) {
 		mp->m_flags &= ~XFS_MOUNT_RDONLY;
-		if (mp->m_flags & XFS_MOUNT_BARRIER)
-			xfs_mountfs_check_barriers(mp);
 
 		/*
 		 * If this is the first remount to writeable state we
@@ -1464,9 +1392,6 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
-	if (mp->m_flags & XFS_MOUNT_BARRIER)
-		xfs_mountfs_check_barriers(mp);
-
 	error = xfs_filestream_mount(mp);
 	if (error)
 		goto out_free_sb;
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-05-27 13:07:41.284496076 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-05-27 15:37:11.681500020 +0200
@@ -1372,8 +1372,15 @@ xlog_sync(xlog_t		*log,
 	XFS_BUF_ASYNC(bp);
 	bp->b_flags |= XBF_LOG_BUFFER;
 
-	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
+	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER) {
+		/*
+		 * If we have an external log device, flush the data device
+		 * before flushing the log.
+		 */
+		if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
+			xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
 		XFS_BUF_ORDERED(bp);
+	}
 
 	ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
 	ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
