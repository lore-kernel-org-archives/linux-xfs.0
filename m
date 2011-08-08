Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p786ekjx019584 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 01:40:46 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E8175359E0
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2011 23:40:43 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	x228kLYPTAy2dwa7 for <xfs@oss.sgi.com>;
	Sun, 07 Aug 2011 23:40:43 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1QqJVo-000273-BK
	for xfs@oss.sgi.com; Mon, 08 Aug 2011 16:40:32 +1000
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1QqJVo-0002l2-4F
	for xfs@oss.sgi.com; Mon, 08 Aug 2011 16:40:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: don't serialise adjacent concurrent direct IO
	appending writes
Date: Mon,  8 Aug 2011 16:40:28 +1000
Message-Id: <1312785628-10561-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1312785628-10561-1-git-send-email-david@fromorbit.com>
References: <1312785628-10561-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/linux-2.6/xfs_aops.c |    7 ++++
 fs/xfs/linux-2.6/xfs_file.c |   73 +++++++++++++++++++++++++++++++++---------
 2 files changed, 64 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 63e971e..dda9a9e 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -176,6 +176,13 @@ xfs_setfilesize(
 	if (unlikely(ioend->io_error))
 		return 0;
 
+	/*
+	 * If the IO is clearly not beyond the on-disk inode size,
+	 * return before we take locks.
+	 */
+	if (ioend->io_offset + ioend->io_size <= ip->i_d.di_size)
+		return 0;
+
 	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
 		return EAGAIN;
 
diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index a1dea10..62a5022 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
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
 
+restart:
+	*new_sizep = 0;
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
+	 * write. Don't issue zeroing if this IO is adjacent to an IO already in
+	 * flight. If we are currently holding the iolock shared, we need to
+	 * update it to exclusive which involves dropping all locks and
+	 * relocking to maintain correct locking order. If we do this, restart
+	 * the function to ensure all checks and values are still valid.
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
+	 * Now we have zeroed beyond EOF as necessary, update the ip->i_new_size
+	 * only if it is larger than any other concurrent write beyond EOF.
+	 * Regardless of whether we update ip->i_new_size, return the updated
+	 * new_size to the caller.
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
@@ -764,13 +791,25 @@ xfs_file_dio_aio_write(
 	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
 		unaligned_io = 1;
 
-	if (unaligned_io || mapping->nrpages || pos > ip->i_size)
+	/*
+	 * Tricky locking alert: if we are doing multiple concurrent sequential
+	 * writes (e.g. via aio), we don't need to do EOF zeroing if the current
+	 * IO is adjacent to an in-flight IO. That means for such IO we can
+	 * avoid taking the IOLOCK exclusively. Hence we avoid checking for
+	 * writes beyond EOF at this point when deciding what lock to take.
+	 * We will take the IOLOCK exclusive later if necessary.
+	 *
+	 * This, however, means that we need a local copy of the ip->i_new_size
+	 * value from this IO if we change it so that we can determine if we can
+	 * clear the value from the inode when this IO completes.
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
 
@@ -809,6 +848,7 @@ xfs_file_buffered_aio_write(
 	unsigned long		nr_segs,
 	loff_t			pos,
 	size_t			ocount,
+	xfs_fsize_t		*new_size,
 	int			*iolock)
 {
 	struct file		*file = iocb->ki_filp;
@@ -822,7 +862,7 @@ xfs_file_buffered_aio_write(
 	*iolock = XFS_IOLOCK_EXCL;
 	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
 
-	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
+	ret = xfs_file_aio_write_checks(file, &pos, &count, new_size, iolock);
 	if (ret)
 		return ret;
 
@@ -862,6 +902,7 @@ xfs_file_aio_write(
 	ssize_t			ret;
 	int			iolock;
 	size_t			ocount = 0;
+	xfs_fsize_t		new_size = 0;
 
 	XFS_STATS_INC(xs_write_calls);
 
@@ -881,10 +922,10 @@ xfs_file_aio_write(
 
 	if (unlikely(file->f_flags & O_DIRECT))
 		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos,
-						ocount, &iolock);
+						ocount, &new_size, &iolock);
 	else
 		ret = xfs_file_buffered_aio_write(iocb, iovp, nr_segs, pos,
-						ocount, &iolock);
+						ocount, &new_size, &iolock);
 
 	xfs_aio_write_isize_update(inode, &iocb->ki_pos, ret);
 
@@ -905,7 +946,7 @@ xfs_file_aio_write(
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
