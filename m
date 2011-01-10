Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ANZsGY052921 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 17:35:55 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D2F5153CFFF
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 15:38:02 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	HOmWpwANNMgiAbZW for <xfs@oss.sgi.com>;
	Mon, 10 Jan 2011 15:38:02 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52135506-1927428
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 10:08:01 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcRJH-0006VL-Ue
	for xfs@oss.sgi.com; Tue, 11 Jan 2011 10:37:59 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PcRJ9-0003yM-N5
	for xfs@oss.sgi.com; Tue, 11 Jan 2011 10:37:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] xfs: ensure sync write errors are returned
Date: Tue, 11 Jan 2011 10:37:41 +1100
Message-Id: <1294702668-15216-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1294702668-15216-1-git-send-email-david@fromorbit.com>
References: <1294702668-15216-1-git-send-email-david@fromorbit.com>
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

xfs_file_aio_write() only returns the error from synchronous
flushing of the data and inode if error == 0. At the point where
error is being checked, it is guaranteed to be > 0. Therefore any
errors returned by the data or fsync flush will never be returned.
Fix the checks so we overwrite the current error once and only if an
error really occurred.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_file.c |   49 ++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index ba8ad42..10b7fb4 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -574,7 +574,7 @@ xfs_file_aio_write(
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	ssize_t			ret = 0, error = 0;
+	ssize_t			ret = 0;
 	int			ioflags = 0;
 	xfs_fsize_t		isize, new_size;
 	int			iolock;
@@ -590,9 +590,9 @@ xfs_file_aio_write(
 	if (file->f_mode & FMODE_NOCMTIME)
 		ioflags |= IO_INVIS;
 
-	error = generic_segment_checks(iovp, &nr_segs, &ocount, VERIFY_READ);
-	if (error)
-		return error;
+	ret = generic_segment_checks(iovp, &nr_segs, &ocount, VERIFY_READ);
+	if (ret)
+		return ret;
 
 	count = ocount;
 	if (count == 0)
@@ -616,9 +616,9 @@ relock:
 	xfs_ilock(ip, XFS_ILOCK_EXCL|iolock);
 
 start:
-	error = -generic_write_checks(file, &pos, &count,
+	ret = generic_write_checks(file, &pos, &count,
 					S_ISBLK(inode->i_mode));
-	if (error) {
+	if (ret) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 		goto out_unlock_mutex;
 	}
@@ -660,8 +660,8 @@ start:
 	 */
 
 	if (pos > ip->i_size) {
-		error = xfs_zero_eof(ip, pos, ip->i_size);
-		if (error) {
+		ret = -xfs_zero_eof(ip, pos, ip->i_size);
+		if (ret) {
 			xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			goto out_unlock_internal;
 		}
@@ -674,8 +674,8 @@ start:
 	 * by root.  This keeps people from modifying setuid and
 	 * setgid binaries.
 	 */
-	error = -file_remove_suid(file);
-	if (unlikely(error))
+	ret = file_remove_suid(file);
+	if (unlikely(ret))
 		goto out_unlock_internal;
 
 	/* We can write back this queue in page reclaim */
@@ -684,10 +684,10 @@ start:
 	if ((ioflags & IO_ISDIRECT)) {
 		if (mapping->nrpages) {
 			WARN_ON(need_i_mutex == 0);
-			error = xfs_flushinval_pages(ip,
+			ret = -xfs_flushinval_pages(ip,
 					(pos & PAGE_CACHE_MASK),
 					-1, FI_REMAPF_LOCKED);
-			if (error)
+			if (ret)
 				goto out_unlock_internal;
 		}
 
@@ -720,24 +720,22 @@ start:
 		}
 	} else {
 		int enospc = 0;
-		ssize_t ret2 = 0;
 
 write_retry:
 		trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, ioflags);
-		ret2 = generic_file_buffered_write(iocb, iovp, nr_segs,
+		ret = generic_file_buffered_write(iocb, iovp, nr_segs,
 				pos, &iocb->ki_pos, count, ret);
 		/*
 		 * if we just got an ENOSPC, flush the inode now we
 		 * aren't holding any page locks and retry *once*
 		 */
-		if (ret2 == -ENOSPC && !enospc) {
-			error = xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
-			if (error)
+		if (ret == -ENOSPC && !enospc) {
+			ret = xfs_flush_pages(ip, 0, -1, 0, FI_NONE);
+			if (ret)
 				goto out_unlock_internal;
 			enospc = 1;
 			goto write_retry;
 		}
-		ret = ret2;
 	}
 
 	current->backing_dev_info = NULL;
@@ -753,7 +751,6 @@ write_retry:
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
-	error = -ret;
 	if (ret <= 0)
 		goto out_unlock_internal;
 
@@ -762,23 +759,23 @@ write_retry:
 	/* Handle various SYNC-type writes */
 	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
 		loff_t end = pos + ret - 1;
-		int error2;
+		int error, error2;
 
 		xfs_iunlock(ip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
 
-		error2 = filemap_write_and_wait_range(mapping, pos, end);
-		if (!error)
-			error = error2;
+		error = filemap_write_and_wait_range(mapping, pos, end);
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
 		xfs_ilock(ip, iolock);
 
 		error2 = -xfs_file_fsync(file,
 					 (file->f_flags & __O_SYNC) ? 0 : 1);
-		if (!error)
-			error = error2;
+		if (error)
+			ret = error;
+		else if (error2)
+			ret = error2;
 	}
 
  out_unlock_internal:
@@ -800,7 +797,7 @@ write_retry:
  out_unlock_mutex:
 	if (need_i_mutex)
 		mutex_unlock(&inode->i_mutex);
-	return -error;
+	return ret;
 }
 
 STATIC int
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
