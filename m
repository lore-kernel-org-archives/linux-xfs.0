Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBF1NaRg159599 for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 19:23:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B45971EC8A0
	for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 17:25:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	LD9I4yWVSWnw1BNX for <xfs@oss.sgi.com>;
	Tue, 14 Dec 2010 17:25:28 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50369427-1927428
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 11:55:27 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PSg7I-00064M-2e
	for xfs@oss.sgi.com; Wed, 15 Dec 2010 12:25:16 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PSg5d-0004HK-Qd
	for xfs@oss.sgi.com; Wed, 15 Dec 2010 12:23:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/7] xfs: split buffered IO write path from xfs_file_aio_write
Date: Wed, 15 Dec 2010 12:23:26 +1100
Message-Id: <1292376208-16282-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1292376208-16282-1-git-send-email-david@fromorbit.com>
References: <1292376208-16282-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/linux-2.6/xfs_file.c |  160 ++++++++++++++++++++-----------------------
 1 files changed, 75 insertions(+), 85 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index d70a249..e10e703 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -698,132 +698,123 @@ xfs_file_dio_aio_write(
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
+	int			*need_i_mutex,
+	int			*iolock)
 {
 	struct file		*file = iocb->ki_filp;
 	struct address_space	*mapping = file->f_mapping;
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0, error = 0;
-	int			ioflags = 0;
+	int			enospc = 0;
 	xfs_fsize_t		new_size;
-	int			iolock;
-	size_t			ocount = 0, count;
-	int			need_i_mutex;
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
-	error = generic_segment_checks(iovp, &nr_segs, &ocount, VERIFY_READ);
-	if (error)
-		return error;
-
-	count = ocount;
-	if (count == 0)
-		return 0;
-
-	xfs_wait_for_freeze(mp, SB_FREEZE_WRITE);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
-
-	if (ioflags & IO_ISDIRECT) {
-		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos,
-					ocount, &need_i_mutex, &iolock);
-		goto done_io;
-	}
+	size_t			count = ocount;
 
-	iolock = XFS_IOLOCK_EXCL;
-	need_i_mutex = 1;
+	*iolock = XFS_IOLOCK_EXCL;
+	*need_i_mutex = 1;
 	mutex_lock(&inode->i_mutex);
-	xfs_ilock(ip, XFS_ILOCK_EXCL|iolock);
+	xfs_ilock(ip, XFS_ILOCK_EXCL|*iolock);
 
-	error = -generic_write_checks(file, &pos, &count,
+	error = generic_write_checks(file, &pos, &count,
 					S_ISBLK(inode->i_mode));
 	if (error) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
-		goto out_unlock_mutex;
+		xfs_iunlock(ip, XFS_ILOCK_EXCL|*iolock);
+		*iolock = 0;
+		return error;
 	}
 
 	new_size = pos + count;
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
-		error = xfs_zero_eof(ip, pos, ip->i_size);
+		error = -xfs_zero_eof(ip, pos, ip->i_size);
 		if (error) {
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			goto out_unlock_internal;
+			return error;
 		}
 	}
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
-	/*
-	 * If we're writing the file then make sure to clear the
-	 * setuid and setgid bits if the process is not being run
-	 * by root.  This keeps people from modifying setuid and
-	 * setgid binaries.
-	 */
-	error = -file_remove_suid(file);
+	error = file_remove_suid(file);
 	if (unlikely(error))
-		goto out_unlock_internal;
+		return error;
 
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
 
-	if (!(ioflags & IO_ISDIRECT)) {
-		int enospc = 0;
-		ssize_t ret2 = 0;
-
 write_retry:
-		trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, ioflags);
-		ret2 = generic_file_buffered_write(iocb, iovp, nr_segs,
-				pos, &iocb->ki_pos, count, ret);
-		/*
-		 * if we just got an ENOSPC, flush the inode now we
-		 * aren't holding any page locks and retry *once*
-		 */
-		if (ret2 == -ENOSPC && !enospc) {
-			error = xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
-			if (error)
-				goto out_unlock_internal;
-			enospc = 1;
-			goto write_retry;
-		}
-		ret = ret2;
+	trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, 0);
+	error = generic_file_buffered_write(iocb, iovp, nr_segs,
+			pos, &iocb->ki_pos, count, ret);
+	/*
+	 * if we just got an ENOSPC, flush the inode now we aren't holding any
+	 * page locks and retry *once*
+	 */
+	if (error == -ENOSPC && !enospc) {
+		error = -xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
+		if (error)
+			return error;
+		enospc = 1;
+		goto write_retry;
 	}
-
 	current->backing_dev_info = NULL;
+	return error;
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
+	ssize_t			ret = 0, error = 0;
+	int			iolock;
+	size_t			ocount = 0;
+	int			need_i_mutex;
+
+	XFS_STATS_INC(xs_write_calls);
+
+	BUG_ON(iocb->ki_pos != pos);
+
+	error = generic_segment_checks(iovp, &nr_segs, &ocount, VERIFY_READ);
+	if (error)
+		return error;
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
+					ocount, &need_i_mutex, &iolock);
+	else
+		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
+					ocount, &need_i_mutex, &iolock);
 
-done_io:
 	xfs_aio_write_isize_update(inode, &iocb->ki_pos, ret);
 
 	error = -ret;
 	if (ret <= 0)
-		goto out_unlock_internal;
+		goto out_unlock;
 
 	XFS_STATS_ADD(xs_write_bytes, ret);
 
@@ -849,10 +840,9 @@ done_io:
 			error = error2;
 	}
 
- out_unlock_internal:
+ out_unlock:
 	xfs_aio_write_newsize_update(ip);
 	xfs_iunlock(ip, iolock);
- out_unlock_mutex:
 	if (need_i_mutex)
 		mutex_unlock(&inode->i_mutex);
 	return -error;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
