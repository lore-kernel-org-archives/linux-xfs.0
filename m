Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:42905 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752078AbcK3Wyv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2016 17:54:51 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1cCDm1-0005Xn-WC
        for linux-xfs@vger.kernel.org; Thu, 01 Dec 2016 09:54:46 +1100
Received: from dave by discord.disaster.area with local (Exim 4.88)
        (envelope-from <david@fromorbit.com>)
        id 1cCDm1-0004Aw-Uc
        for linux-xfs@vger.kernel.org; Thu, 01 Dec 2016 09:54:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: Always flush caches when integrity is required
Date: Thu,  1 Dec 2016 09:54:43 +1100
Message-Id: <20161130225444.15869-2-david@fromorbit.com>
In-Reply-To: <20161130225444.15869-1-david@fromorbit.com>
References: <20161130225444.15869-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There is no reason anymore for not issuing device integrity
operations when teh filesystem requires ordering or data integrity
guarantees. We should always issue cache flushes and FUA writes
where necessary and let the underlying storage optimise them as
necessary for correct integrity operation.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c  |  3 +--
 fs/xfs/xfs_file.c | 29 ++++++++++++-----------------
 fs/xfs/xfs_log.c  | 36 +++++++++++++++---------------------
 3 files changed, 28 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a2f0648743db..1264908ef8f2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1738,8 +1738,7 @@ xfs_free_buftarg(
 	percpu_counter_destroy(&btp->bt_io_count);
 	list_lru_destroy(&btp->bt_lru);
 
-	if (mp->m_flags & XFS_MOUNT_BARRIER)
-		xfs_blkdev_issue_flush(btp);
+	xfs_blkdev_issue_flush(btp);
 
 	kmem_free(btp);
 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f5effa68e037..2951c483b24b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -149,19 +149,16 @@ xfs_file_fsync(
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 
-	if (mp->m_flags & XFS_MOUNT_BARRIER) {
-		/*
-		 * If we have an RT and/or log subvolume we need to make sure
-		 * to flush the write cache the device used for file data
-		 * first.  This is to ensure newly written file data make
-		 * it to disk before logging the new inode size in case of
-		 * an extending write.
-		 */
-		if (XFS_IS_REALTIME_INODE(ip))
-			xfs_blkdev_issue_flush(mp->m_rtdev_targp);
-		else if (mp->m_logdev_targp != mp->m_ddev_targp)
-			xfs_blkdev_issue_flush(mp->m_ddev_targp);
-	}
+	/*
+	 * If we have an RT and/or log subvolume we need to make sure to flush
+	 * the write cache the device used for file data first.  This is to
+	 * ensure newly written file data make it to disk before logging the new
+	 * inode size in case of an extending write.
+	 */
+	if (XFS_IS_REALTIME_INODE(ip))
+		xfs_blkdev_issue_flush(mp->m_rtdev_targp);
+	else if (mp->m_logdev_targp != mp->m_ddev_targp)
+		xfs_blkdev_issue_flush(mp->m_ddev_targp);
 
 	/*
 	 * All metadata updates are logged, which means that we just have to
@@ -196,10 +193,8 @@ xfs_file_fsync(
 	 * an already allocated file and thus do not have any metadata to
 	 * commit.
 	 */
-	if ((mp->m_flags & XFS_MOUNT_BARRIER) &&
-	    mp->m_logdev_targp == mp->m_ddev_targp &&
-	    !XFS_IS_REALTIME_INODE(ip) &&
-	    !log_flushed)
+	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
+	    mp->m_logdev_targp == mp->m_ddev_targp)
 		xfs_blkdev_issue_flush(mp->m_ddev_targp);
 
 	return error;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3ebe444eb60f..573d0841851d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1863,25 +1863,21 @@ xlog_sync(
 	bp->b_io_length = BTOBB(count);
 	bp->b_fspriv = iclog;
 	bp->b_flags &= ~(XBF_FUA | XBF_FLUSH);
-	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE);
+	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
 
-	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER) {
-		bp->b_flags |= XBF_FUA;
-
-		/*
-		 * Flush the data device before flushing the log to make
-		 * sure all meta data written back from the AIL actually made
-		 * it to disk before stamping the new log tail LSN into the
-		 * log buffer.  For an external log we need to issue the
-		 * flush explicitly, and unfortunately synchronously here;
-		 * for an internal log we can simply use the block layer
-		 * state machine for preflushes.
-		 */
-		if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
-			xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
-		else
-			bp->b_flags |= XBF_FLUSH;
-	}
+	/*
+	 * Flush the data device before flushing the log to make
+	 * sure all meta data written back from the AIL actually made
+	 * it to disk before stamping the new log tail LSN into the
+	 * log buffer.  For an external log we need to issue the
+	 * flush explicitly, and unfortunately synchronously here;
+	 * for an internal log we can simply use the block layer
+	 * state machine for preflushes.
+	 */
+	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
+		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
+	else
+		bp->b_flags |= XBF_FLUSH;
 
 	ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
 	ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);
@@ -1907,9 +1903,7 @@ xlog_sync(
 				(char *)&iclog->ic_header + count, split);
 		bp->b_fspriv = iclog;
 		bp->b_flags &= ~(XBF_FUA | XBF_FLUSH);
-		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE);
-		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
-			bp->b_flags |= XBF_FUA;
+		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
 
 		ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
 		ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);
-- 
2.10.2

