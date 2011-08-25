Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P7HOLF172909 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 02:17:24 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E002113356
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 00:17:22 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ylp1Y7igON3bpMuW for <xfs@oss.sgi.com>;
	Thu, 25 Aug 2011 00:17:22 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1QwUBZ-00049T-Um
	for xfs@oss.sgi.com; Thu, 25 Aug 2011 17:17:09 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QwUBZ-0002v1-Mn
	for xfs@oss.sgi.com; Thu, 25 Aug 2011 17:17:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs: don't serialise adjacent concurrent direct IO
	appending writes
Date: Thu, 25 Aug 2011 17:17:02 +1000
Message-Id: <1314256626-11136-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1314256626-11136-1-git-send-email-david@fromorbit.com>
References: <1314256626-11136-1-git-send-email-david@fromorbit.com>
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

For append write workloads, extending the file requires a certain
amount of exclusive locking to be done up front to ensure sanity in
things like ensuring that we've zeroed any allocated regions
between the old EOF and the start of the new IO.

For single threads, this typically isn't a problem, and for large
IOs we don't serialise enough for it to be a problem for two
threads on really fast block devices. However for smaller IO and
larger thread counts we have a problem.

Take 4 concurrent sequential, single block sized and aligned IOs.
After the first IO is submitted but before it completes, we end up
with this state:

        IO 1    IO 2    IO 3    IO 4
      +-------+-------+-------+-------+
      ^       ^
      |       |
      |       |
      |       |
      |       \- ip->i_new_size
      \- ip->i_size

And the IO is done without exclusive locking because offset <=
ip->i_size. When we submit IO 2, we see offset > ip->i_size, and
grab the IO lock exclusive, because there is a chance we need to do
EOF zeroing. However, there is already an IO in progress that avoids
the need for IO zeroing because offset <= ip->i_new_size. hence we
could avoid holding the IO lock exlcusive for this. Hence after
submission of the second IO, we'd end up this state:

        IO 1    IO 2    IO 3    IO 4
      +-------+-------+-------+-------+
      ^               ^
      |               |
      |               |
      |               |
      |               \- ip->i_new_size
      \- ip->i_size

There is no need to grab the i_mutex of the IO lock in exclusive
mode if we don't need to invalidate the page cache. Taking these
locks on every direct IO effective serialises them as taking the IO
lock in exclusive mode has to wait for all shared holders to drop
the lock. That only happens when IO is complete, so effective it
prevents dispatch of concurrent direct IO writes to the same inode.

And so you can see that for the third concurrent IO, we'd avoid
exclusive locking for the same reason we avoided the exclusive lock
for the second IO.

Fixing this is a bit more complex than that, because we need to hold
a write-submission local value of ip->i_new_size to that clearing
the value is only done if no other thread has updated it before our
IO completes.....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c |   68 ++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a1dea10..4c64eb0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -418,11 +418,13 @@ xfs_aio_write_isize_update(
  */
 STATIC void
 xfs_aio_write_newsize_update(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	xfs_fsize_t		new_size)
 {
-	if (ip->i_new_size) {
+	if (new_size == ip->i_new_size) {
 		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
-		ip->i_new_size = 0;
+		if (new_size == ip->i_new_size)
+			ip->i_new_size = 0;
 		if (ip->i_d.di_size > ip->i_size)
 			ip->i_d.di_size = ip->i_size;
 		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
@@ -473,7 +475,7 @@ xfs_file_splice_write(
 	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
 
 	xfs_aio_write_isize_update(inode, ppos, ret);
-	xfs_aio_write_newsize_update(ip);
+	xfs_aio_write_newsize_update(ip, new_size);
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	return ret;
 }
@@ -670,6 +672,7 @@ xfs_file_aio_write_checks(
 	struct file		*file,
 	loff_t			*pos,
 	size_t			*count,
+	xfs_fsize_t		*new_sizep,
 	int			*iolock)
 {
 	struct inode		*inode = file->f_mapping->host;
@@ -677,6 +680,8 @@ xfs_file_aio_write_checks(
 	xfs_fsize_t		new_size;
 	int			error = 0;
 
+	*new_sizep = 0;
+restart:
 	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
 	if (error) {
 		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
@@ -684,20 +689,41 @@ xfs_file_aio_write_checks(
 		return error;
 	}
 
-	new_size = *pos + *count;
-	if (new_size > ip->i_size)
-		ip->i_new_size = new_size;
-
 	if (likely(!(file->f_mode & FMODE_NOCMTIME)))
 		file_update_time(file);
 
 	/*
 	 * If the offset is beyond the size of the file, we need to zero any
 	 * blocks that fall between the existing EOF and the start of this
-	 * write.
+	 * write. There is no need to issue zeroing if another in-flght IO ends
+	 * at or before this one If zeronig is needed and we are currently
+	 * holding the iolock shared, we need to update it to exclusive which
+	 * involves dropping all locks and relocking to maintain correct locking
+	 * order. If we do this, restart the function to ensure all checks and
+	 * values are still valid.
 	 */
-	if (*pos > ip->i_size)
+	if ((ip->i_new_size && *pos > ip->i_new_size) ||
+	    (!ip->i_new_size && *pos > ip->i_size)) {
+		if (*iolock == XFS_IOLOCK_SHARED) {
+			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
+			*iolock = XFS_IOLOCK_EXCL;
+			xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
+			goto restart;
+		}
 		error = -xfs_zero_eof(ip, *pos, ip->i_size);
+	}
+
+	/*
+	 * If this IO extends beyond EOF, we may need to update ip->i_new_size.
+	 * We have already zeroed space beyond EOF (if necessary).  Only update
+	 * ip->i_new_size if this IO ends beyond any other in-flight writes.
+	 */
+	new_size = *pos + *count;
+	if (new_size > ip->i_size) {
+		if (new_size > ip->i_new_size)
+			ip->i_new_size = new_size;
+		*new_sizep = new_size;
+	}
 
 	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 	if (error)
@@ -744,6 +770,7 @@ xfs_file_dio_aio_write(
 	unsigned long		nr_segs,
 	loff_t			pos,
 	size_t			ocount,
+	xfs_fsize_t		*new_size,
 	int			*iolock)
 {
 	struct file		*file = iocb->ki_filp;
@@ -764,13 +791,20 @@ xfs_file_dio_aio_write(
 	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
 		unaligned_io = 1;
 
-	if (unaligned_io || mapping->nrpages || pos > ip->i_size)
+	/*
+	 * We don't need to take an exclusive lock unless there page cache needs
+	 * to be invalidated or unaligned IO is being executed. We don't need to
+	 * consider the EOF extension case here because
+	 * xfs_file_aio_write_checks() will relock the inode as necessary for
+	 * EOF zeroing cases and fill out the new inode size as appropriate.
+	 */
+	if (unaligned_io || mapping->nrpages)
 		*iolock = XFS_IOLOCK_EXCL;
 	else
 		*iolock = XFS_IOLOCK_SHARED;
 	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
 
-	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
+	ret = xfs_file_aio_write_checks(file, &pos, &count, new_size, iolock);
 	if (ret)
 		return ret;
 
@@ -809,6 +843,7 @@ xfs_file_buffered_aio_write(
 	unsigned long		nr_segs,
 	loff_t			pos,
 	size_t			ocount,
+	xfs_fsize_t		*new_size,
 	int			*iolock)
 {
 	struct file		*file = iocb->ki_filp;
@@ -822,7 +857,7 @@ xfs_file_buffered_aio_write(
 	*iolock = XFS_IOLOCK_EXCL;
 	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
 
-	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
+	ret = xfs_file_aio_write_checks(file, &pos, &count, new_size, iolock);
 	if (ret)
 		return ret;
 
@@ -862,6 +897,7 @@ xfs_file_aio_write(
 	ssize_t			ret;
 	int			iolock;
 	size_t			ocount = 0;
+	xfs_fsize_t		new_size = 0;
 
 	XFS_STATS_INC(xs_write_calls);
 
@@ -881,10 +917,10 @@ xfs_file_aio_write(
 
 	if (unlikely(file->f_flags & O_DIRECT))
 		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos,
-						ocount, &iolock);
+						ocount, &new_size, &iolock);
 	else
 		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
-						ocount, &iolock);
+						ocount, &new_size, &iolock);
 
 	xfs_aio_write_isize_update(inode, &iocb->ki_pos, ret);
 
@@ -905,7 +941,7 @@ xfs_file_aio_write(
 	}
 
 out_unlock:
-	xfs_aio_write_newsize_update(ip);
+	xfs_aio_write_newsize_update(ip, new_size);
 	xfs_rw_iunlock(ip, iolock);
 	return ret;
 }
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
