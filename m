Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53LBD135051 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:21 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Htx3kUUQPwbRvczK for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:06 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PaF-0003G9-Ll
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:55 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaA-0003dj-IL
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 032/102] xfs: cleanup xfs_file_aio_write
Date: Thu, 23 Aug 2012 15:01:50 +1000
Message-Id: <1345698180-13612-33-git-send-email-david@fromorbit.com>
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

Upstream commit: d060646436233912178e6b9e3a7f30a41214220f

With all the size field updates out of the way xfs_file_aio_write can
be further simplified by pushing all iolock handling into
xfs_file_dio_aio_write and xfs_file_buffered_aio_write and using
the generic generic_write_sync helper for synchronous writes.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_file.c |   90 +++++++++++++++++++------------------------
 1 file changed, 39 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index b9e3101..d9f5f9f 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -719,8 +719,7 @@ xfs_file_dio_aio_write(
 	const struct iovec	*iovp,
 	unsigned long		nr_segs,
 	loff_t			pos,
-	size_t			ocount,
-	int			*iolock)
+	size_t			ocount)
 {
 	struct file		*file = iocb->ki_filp;
 	struct address_space	*mapping = file->f_mapping;
@@ -730,10 +729,10 @@ xfs_file_dio_aio_write(
 	ssize_t			ret = 0;
 	size_t			count = ocount;
 	int			unaligned_io = 0;
+	int			iolock;
 	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp;
 
-	*iolock = 0;
 	if ((pos & target->bt_smask) || (count & target->bt_smask))
 		return -XFS_ERROR(EINVAL);
 
@@ -748,31 +747,31 @@ xfs_file_dio_aio_write(
 	 * EOF zeroing cases and fill out the new inode size as appropriate.
 	 */
 	if (unaligned_io || mapping->nrpages)
-		*iolock = XFS_IOLOCK_EXCL;
+		iolock = XFS_IOLOCK_EXCL;
 	else
-		*iolock = XFS_IOLOCK_SHARED;
-	xfs_rw_ilock(ip, *iolock);
-
-	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
-	if (ret)
-		return ret;
+		iolock = XFS_IOLOCK_SHARED;
+	xfs_rw_ilock(ip, iolock);
 
 	/*
 	 * Recheck if there are cached pages that need invalidate after we got
 	 * the iolock to protect against other threads adding new pages while
 	 * we were waiting for the iolock.
 	 */
-	if (mapping->nrpages && *iolock == XFS_IOLOCK_SHARED) {
-		xfs_rw_iunlock(ip, *iolock);
-		*iolock = XFS_IOLOCK_EXCL;
-		xfs_rw_ilock(ip, *iolock);
+	if (mapping->nrpages && iolock == XFS_IOLOCK_SHARED) {
+		xfs_rw_iunlock(ip, iolock);
+		iolock = XFS_IOLOCK_EXCL;
+		xfs_rw_ilock(ip, iolock);
 	}
 
+	ret = xfs_file_aio_write_checks(file, &pos, &count, &iolock);
+	if (ret)
+		goto out;
+
 	if (mapping->nrpages) {
 		ret = -xfs_flushinval_pages(ip, (pos & PAGE_CACHE_MASK), -1,
 							FI_REMAPF_LOCKED);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	/*
@@ -781,15 +780,18 @@ xfs_file_dio_aio_write(
 	 */
 	if (unaligned_io)
 		xfs_ioend_wait(ip);
-	else if (*iolock == XFS_IOLOCK_EXCL) {
+	else if (iolock == XFS_IOLOCK_EXCL) {
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
-		*iolock = XFS_IOLOCK_SHARED;
+		iolock = XFS_IOLOCK_SHARED;
 	}
 
 	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
 	ret = generic_file_direct_write(iocb, iovp,
 			&nr_segs, pos, &iocb->ki_pos, count, ocount);
 
+out:
+	xfs_rw_iunlock(ip, iolock);
+
 	/* No fallback to buffered IO on errors for XFS. */
 	ASSERT(ret < 0 || ret == count);
 	return ret;
@@ -801,8 +803,7 @@ xfs_file_buffered_aio_write(
 	const struct iovec	*iovp,
 	unsigned long		nr_segs,
 	loff_t			pos,
-	size_t			ocount,
-	int			*iolock)
+	size_t			ocount)
 {
 	struct file		*file = iocb->ki_filp;
 	struct address_space	*mapping = file->f_mapping;
@@ -810,14 +811,14 @@ xfs_file_buffered_aio_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
 	int			enospc = 0;
+	int			iolock = XFS_IOLOCK_EXCL;
 	size_t			count = ocount;
 
-	*iolock = XFS_IOLOCK_EXCL;
-	xfs_rw_ilock(ip, *iolock);
+	xfs_rw_ilock(ip, iolock);
 
-	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
+	ret = xfs_file_aio_write_checks(file, &pos, &count, &iolock);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
@@ -831,13 +832,15 @@ write_retry:
 	 * page locks and retry *once*
 	 */
 	if (ret == -ENOSPC && !enospc) {
-		ret = -xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
-		if (ret)
-			return ret;
 		enospc = 1;
-		goto write_retry;
+		ret = -xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
+		if (!ret)
+			goto write_retry;
 	}
+
 	current->backing_dev_info = NULL;
+out:
+	xfs_rw_iunlock(ip, iolock);
 	return ret;
 }
 
@@ -853,7 +856,6 @@ xfs_file_aio_write(
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
-	int			iolock;
 	size_t			ocount = 0;
 
 	XFS_STATS_INC(xs_write_calls);
@@ -873,36 +875,22 @@ xfs_file_aio_write(
 		return -EIO;
 
 	if (unlikely(file->f_flags & O_DIRECT))
-		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos,
-						ocount, &iolock);
+		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos, ocount);
 	else
 		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
-						ocount, &iolock);
-
-	if (ret <= 0)
-		goto out_unlock;
+						  ocount);
 
-	XFS_STATS_ADD(xs_write_bytes, ret);
+	if (ret > 0) {
+		ssize_t err;
 
-	/* Handle various SYNC-type writes */
-	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
-		loff_t end = pos + ret - 1;
-		int error, error2;
-
-		xfs_rw_iunlock(ip, iolock);
-		error = filemap_write_and_wait_range(mapping, pos, end);
-		xfs_rw_ilock(ip, iolock);
+		XFS_STATS_ADD(xs_write_bytes, ret);
 
-		error2 = -xfs_file_fsync(file,
-					 (file->f_flags & __O_SYNC) ? 0 : 1);
-		if (error)
-			ret = error;
-		else if (error2)
-			ret = error2;
+		/* Handle various SYNC-type writes */
+		err = generic_write_sync(file, pos, ret);
+		if (err < 0)
+			ret = err;
 	}
 
-out_unlock:
-	xfs_rw_iunlock(ip, iolock);
 	return ret;
 }
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
