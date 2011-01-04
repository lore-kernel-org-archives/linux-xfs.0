Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p044knEC175990 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 22:46:49 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11EC2230E23
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 20:48:55 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	NmlhPCLvePV47pyE for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 20:48:55 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	51169593-1927428
	for <xfs@oss.sgi.com>; Tue, 04 Jan 2011 15:18:54 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PZypJ-0000TF-Au
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:48:53 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PZyp7-0003tj-KN
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:48:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfs: split direct IO write path from xfs_file_aio_write
Date: Tue,  4 Jan 2011 15:48:35 +1100
Message-Id: <1294116518-14908-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1294116518-14908-1-git-send-email-david@fromorbit.com>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
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

The current xfs_file_aio_write code is a mess of locking shenanigans
to handle the different locking requirements of buffered and direct
IO. Start to clean this up by disentangling the direct IO path from
the mess.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_file.c |  168 ++++++++++++++++++++++++++++---------------
 1 files changed, 110 insertions(+), 58 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 0d6111e..d546953 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -619,6 +619,110 @@ out_lock:
 	return error;
 }
 
+/*
+ * xfs_file_dio_aio_write - handle direct IO writes
+ *
+ * Lock the inode appropriately to prepare for and issue a direct IO write.
+ * By spearating it from the buffered write path we remove all the tricky to
+ * follow locking changes and looping. This also clearly indicates that XFS
+ * does not fall back to buffered IO in the direct IO write path.
+ *
+ * Returns with locks held indicated by @iolock and errors indicated by
+ * negative return values.
+ */
+STATIC ssize_t
+xfs_file_dio_aio_write(
+	struct kiocb		*iocb,
+	const struct iovec	*iovp,
+	unsigned long		nr_segs,
+	loff_t			pos,
+	size_t			ocount,
+	int			*iolock)
+{
+	struct file		*file = iocb->ki_filp;
+	struct address_space	*mapping = file->f_mapping;
+	struct inode		*inode = mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	ssize_t			ret = 0;
+	xfs_fsize_t		new_size;
+	size_t			count = ocount;
+	xfs_buftarg_t		*target = XFS_IS_REALTIME_INODE(ip) ?
+					mp->m_rtdev_targp : mp->m_ddev_targp;
+
+	*iolock = 0;
+	if ((pos & target->bt_smask) || (count & target->bt_smask))
+		return -XFS_ERROR(EINVAL);
+
+	if (mapping->nrpages || pos > ip->i_size)
+		*iolock = XFS_IOLOCK_EXCL;
+	else
+		*iolock = XFS_IOLOCK_SHARED;
+	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|*iolock);
+
+	ret = generic_write_checks(file, &pos, &count,
+					S_ISBLK(inode->i_mode));
+	if (ret) {
+		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|*iolock);
+		*iolock = 0;
+		return ret;
+	}
+
+	new_size = pos + count;
+	if (new_size > ip->i_size)
+		ip->i_new_size = new_size;
+
+	if (likely(!(file->f_mode & FMODE_NOCMTIME)))
+		file_update_time(file);
+
+	/*
+	 * If the offset is beyond the size of the file, we have a couple of
+	 * things to do. First, if there is already space allocated we need to
+	 * either create holes or zero the disk or ...
+	 *
+	 * If there is a page where the previous size lands, we need to zero it
+	 * out up to the new size.
+	 */
+	if (pos > ip->i_size) {
+		ret = -xfs_zero_eof(ip, pos, ip->i_size);
+		if (ret) {
+			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
+			return ret;
+		}
+	}
+	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
+
+	/*
+	 * If we're writing the file then make sure to clear the setuid and
+	 * setgid bits if the process is not being run by root.  This keeps
+	 * people from modifying setuid and setgid binaries.
+	 */
+	ret = file_remove_suid(file);
+	if (unlikely(ret))
+		return ret;
+
+	if (mapping->nrpages) {
+		WARN_ON(*iolock != XFS_IOLOCK_EXCL);
+		ret = -xfs_flushinval_pages(ip, (pos & PAGE_CACHE_MASK), -1,
+							FI_REMAPF_LOCKED);
+		if (ret)
+			return ret;
+	}
+
+	if (*iolock == XFS_IOLOCK_EXCL) {
+		/* demote the lock now the cached pages are gone */
+		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
+		*iolock = XFS_IOLOCK_SHARED;
+	}
+
+	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
+	ret = generic_file_direct_write(iocb, iovp,
+			&nr_segs, pos, &iocb->ki_pos, count, ocount);
+
+	/* No fallback to buffered IO on errors for XFS. */
+	return ret;
+}
+
 STATIC ssize_t
 xfs_file_aio_write(
 	struct kiocb		*iocb,
@@ -659,14 +763,13 @@ xfs_file_aio_write(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-relock:
 	if (ioflags & IO_ISDIRECT) {
-		iolock = XFS_IOLOCK_SHARED;
-	} else {
-		iolock = XFS_IOLOCK_EXCL;
+		ret = xfs_file_dio_aio_write(iocb, iovp, nr_segs, pos,
+						ocount, &iolock);
+		goto done_io;
 	}
 
-start:
+	iolock = XFS_IOLOCK_EXCL;
 	ret = generic_write_checks(file, &pos, &count,
 					S_ISBLK(inode->i_mode));
 	if (ret) {
@@ -674,24 +777,6 @@ start:
 		return ret;
 	}
 
-	if (ioflags & IO_ISDIRECT) {
-		xfs_buftarg_t	*target =
-			XFS_IS_REALTIME_INODE(ip) ?
-				mp->m_rtdev_targp : mp->m_ddev_targp;
-
-		if ((pos & target->bt_smask) || (count & target->bt_smask)) {
-			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|iolock);
-			return XFS_ERROR(-EINVAL);
-		}
-
-		if (iolock != XFS_IOLOCK_EXCL &&
-		    (mapping->nrpages || pos > ip->i_size)) {
-			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|iolock);
-			iolock = XFS_IOLOCK_EXCL;
-			goto start;
-		}
-	}
-
 	new_size = pos + count;
 	if (new_size > ip->i_size)
 		ip->i_new_size = new_size;
@@ -730,41 +815,7 @@ start:
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
 
-	if ((ioflags & IO_ISDIRECT)) {
-		if (mapping->nrpages) {
-			WARN_ON(iolock != XFS_IOLOCK_EXCL);
-			ret = -xfs_flushinval_pages(ip,
-					(pos & PAGE_CACHE_MASK),
-					-1, FI_REMAPF_LOCKED);
-			if (ret)
-				goto out_unlock_internal;
-		}
-
-		if (iolock == XFS_IOLOCK_EXCL) {
-			/* demote the lock now the cached pages are gone */
-			xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
-			iolock = XFS_IOLOCK_SHARED;
-		}
-
-		trace_xfs_file_direct_write(ip, count, iocb->ki_pos, ioflags);
-		ret = generic_file_direct_write(iocb, iovp,
-				&nr_segs, pos, &iocb->ki_pos, count, ocount);
-
-		/*
-		 * direct-io write to a hole: fall through to buffered I/O
-		 * for completing the rest of the request.
-		 */
-		if (ret >= 0 && ret != count) {
-			XFS_STATS_ADD(xs_write_bytes, ret);
-
-			pos += ret;
-			count -= ret;
-
-			ioflags &= ~IO_ISDIRECT;
-			xfs_rw_iunlock(ip, iolock);
-			goto relock;
-		}
-	} else {
+	if (!(ioflags & IO_ISDIRECT)) {
 		int enospc = 0;
 
 write_retry:
@@ -788,6 +839,7 @@ write_retry:
 
 	current->backing_dev_info = NULL;
 
+done_io:
 	xfs_aio_write_isize_update(inode, &iocb->ki_pos, ret);
 
 	if (ret <= 0)
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
