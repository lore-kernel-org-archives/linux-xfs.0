Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p07BTFRj039147 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 05:29:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 170491539BBD
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 03:31:23 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	paCgOC6YIeMOj9mj for <xfs@oss.sgi.com>;
	Fri, 07 Jan 2011 03:31:23 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	6797298-1927428
	for <xfs@oss.sgi.com>; Fri, 07 Jan 2011 22:01:22 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PbAXR-0007i0-52
	for xfs@oss.sgi.com; Fri, 07 Jan 2011 22:31:21 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PbAWw-0000Ji-BV
	for xfs@oss.sgi.com; Fri, 07 Jan 2011 22:30:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] xfs: split buffered IO write path from xfs_file_aio_write
Date: Fri,  7 Jan 2011 22:30:23 +1100
Message-Id: <1294399825-1157-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1294399825-1157-1-git-send-email-david@fromorbit.com>
References: <1294399825-1157-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Complete the split of the different write IO paths by splitting the
buffered IO write path out of xfs_file_aio_write(). This makes the
different mechanisms of the write patchs easier to follow.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_file.c |  146 ++++++++++++++++++++-----------------------
 1 files changed, 69 insertions(+), 77 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 2d55648..9ce5e12 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -730,58 +730,31 @@ xfs_file_dio_aio_write(
 }
 
 STATIC ssize_t
-xfs_file_aio_write(
+xfs_file_buffered_aio_write(
 	struct kiocb		*iocb,
 	const struct iovec	*iovp,
 	unsigned long		nr_segs,
-	loff_t			pos)
+	loff_t			pos,
+	size_t			ocount,
+	int			*iolock)
 {
 	struct file		*file = iocb->ki_filp;
 	struct address_space	*mapping = file->f_mapping;
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	ssize_t			ret = 0;
-	int			ioflags = 0;
+	ssize_t			ret;
+	int			enospc = 0;
 	xfs_fsize_t		new_size;
-	int			iolock;
-	size_t			ocount = 0, count;
-
-	XFS_STATS_INC(xs_write_calls);
-
-	BUG_ON(iocb->ki_pos != pos);
-
-	if (unlikely(file->f_flags & O_DIRECT))
-		ioflags |= IO_ISDIRECT;
-	if (file->f_mode & FMODE_NOCMTIME)
-		ioflags |= IO_INVIS;
-
-	ret = generic_segment_checks(iovp, &nr_segs, &ocount, VERIFY_READ);
-	if (ret)
-		return ret;
-
-	count = ocount;
-	if (count == 0)
-		return 0;
-
-	xfs_wait_for_freeze(mp, SB_FREEZE_WRITE);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
+	size_t			count = ocount;
 
-relock:
-	if (ioflags & IO_ISDIRECT) {
-		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos,
-						ocount, &iolock);
-		goto done_io;
-	}
-	iolock = XFS_IOLOCK_EXCL;
+	*iolock = XFS_IOLOCK_EXCL;
+	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|*iolock);
 
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|iolock);
 	ret = generic_write_checks(file, &pos, &count,
 					S_ISBLK(inode->i_mode));
 	if (ret) {
-		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|iolock);
+		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|*iolock);
+		*iolock = 0;
 		return ret;
 	}
 
@@ -789,67 +762,86 @@ relock:
 	if (new_size > ip->i_size)
 		ip->i_new_size = new_size;
 
-	if (likely(!(ioflags & IO_INVIS)))
+	if (likely(!(file->f_mode & FMODE_NOCMTIME)))
 		file_update_time(file);
 
-	/*
-	 * If the offset is beyond the size of the file, we have a couple
-	 * of things to do. First, if there is already space allocated
-	 * we need to either create holes or zero the disk or ...
-	 *
-	 * If there is a page where the previous size lands, we need
-	 * to zero it out up to the new size.
-	 */
-
 	if (pos > ip->i_size) {
 		ret = -xfs_zero_eof(ip, pos, ip->i_size);
 		if (ret) {
 			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
-			goto out_unlock_internal;
+			return ret;
 		}
 	}
 	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 
-	/*
-	 * If we're writing the file then make sure to clear the
-	 * setuid and setgid bits if the process is not being run
-	 * by root.  This keeps people from modifying setuid and
-	 * setgid binaries.
-	 */
 	ret = file_remove_suid(file);
 	if (unlikely(ret))
-		goto out_unlock_internal;
+		return ret;
 
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
 
-	if (!(ioflags & IO_ISDIRECT)) {
-		int enospc = 0;
-
 write_retry:
-		trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, ioflags);
-		ret = generic_file_buffered_write(iocb, iovp, nr_segs,
-				pos, &iocb->ki_pos, count, ret);
-		/*
-		 * if we just got an ENOSPC, flush the inode now we
-		 * aren't holding any page locks and retry *once*
-		 */
-		if (ret == -ENOSPC && !enospc) {
-			ret = xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
-			if (ret)
-				goto out_unlock_internal;
-			enospc = 1;
-			goto write_retry;
-		}
+	trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, 0);
+	ret = generic_file_buffered_write(iocb, iovp, nr_segs,
+			pos, &iocb->ki_pos, count, ret);
+	/*
+	 * if we just got an ENOSPC, flush the inode now we aren't holding any
+	 * page locks and retry *once*
+	 */
+	if (ret == -ENOSPC && !enospc) {
+		ret = -xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
+		if (ret)
+			return ret;
+		enospc = 1;
+		goto write_retry;
 	}
-
 	current->backing_dev_info = NULL;
+	return ret;
+}
+
+STATIC ssize_t
+xfs_file_aio_write(
+	struct kiocb		*iocb,
+	const struct iovec	*iovp,
+	unsigned long		nr_segs,
+	loff_t			pos)
+{
+	struct file		*file = iocb->ki_filp;
+	struct address_space	*mapping = file->f_mapping;
+	struct inode		*inode = mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	ssize_t			ret;
+	int			iolock;
+	size_t			ocount = 0;
+
+	XFS_STATS_INC(xs_write_calls);
+
+	BUG_ON(iocb->ki_pos != pos);
+
+	ret = generic_segment_checks(iovp, &nr_segs, &ocount, VERIFY_READ);
+	if (ret)
+		return ret;
+
+	if (ocount == 0)
+		return 0;
+
+	xfs_wait_for_freeze(ip->i_mount, SB_FREEZE_WRITE);
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return -EIO;
+
+	if (unlikely(file->f_flags & O_DIRECT))
+		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos,
+						ocount, &iolock);
+	else
+		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
+						ocount, &iolock);
 
-done_io:
 	xfs_aio_write_isize_update(inode, &iocb->ki_pos, ret);
 
 	if (ret <= 0)
-		goto out_unlock_internal;
+		goto out_unlock;
 
 	/* Handle various SYNC-type writes */
 	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
@@ -868,7 +860,7 @@ done_io:
 			ret = error2;
 	}
 
- out_unlock_internal:
+out_unlock:
 	xfs_aio_write_newsize_update(ip);
 	xfs_rw_iunlock(ip, iolock);
 	return ret;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
