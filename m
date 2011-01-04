Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p044kxMN176064 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 22:46:59 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC4241D0828E
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 20:49:05 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	mUyYbGgSLTHfgxpx for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 20:49:05 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	51169613-1927428
	for <xfs@oss.sgi.com>; Tue, 04 Jan 2011 15:19:04 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PZypJ-0000TH-E4
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:48:53 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PZypH-0003tp-NG
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:48:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] xfs: factor common write setup code
Date: Tue,  4 Jan 2011 15:48:37 +1100
Message-Id: <1294116518-14908-8-git-send-email-david@fromorbit.com>
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

The buffered IO and direct Io write paths share a common set of
checks and limiting code prior to issuing the write. Factor that
into a common helper function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_file.c |  129 ++++++++++++++++++++-----------------------
 1 files changed, 59 insertions(+), 70 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 7e7805c..f21b6ad 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -620,6 +620,61 @@ out_lock:
 }
 
 /*
+ * Common pre-write limit and setup checks.
+ *
+ * Returns with iolock held according to @iolock.
+ */
+STATIC ssize_t
+xfs_file_aio_write_checks(
+	struct file		*file,
+	loff_t			*pos,
+	size_t			*count,
+	int			*iolock)
+{
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	xfs_fsize_t		new_size;
+	int			error = 0;
+
+	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|*iolock);
+
+	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
+	if (error) {
+		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|*iolock);
+		*iolock = 0;
+		return error;
+	}
+
+	new_size = *pos + *count;
+	if (new_size > ip->i_size)
+		ip->i_new_size = new_size;
+
+	if (likely(!(file->f_mode & FMODE_NOCMTIME)))
+		file_update_time(file);
+
+	/*
+	 * If the offset is beyond the size of the file, we need to zero any
+	 * blocks that fall between the existing EOF and the start of this
+	 * write.
+	 */
+	if (*pos > ip->i_size)
+		error = -xfs_zero_eof(ip, *pos, ip->i_size);
+
+	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		return error;
+
+	/*
+	 * If we're writing the file then make sure to clear the setuid and
+	 * setgid bits if the process is not being run by root.  This keeps
+	 * people from modifying setuid and setgid binaries.
+	 */
+	error = file_remove_suid(file);
+	return error;
+
+}
+
+/*
  * xfs_file_dio_aio_write - handle direct IO writes
  *
  * Lock the inode appropriately to prepare for and issue a direct IO write.
@@ -645,7 +700,6 @@ xfs_file_dio_aio_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0;
-	xfs_fsize_t		new_size;
 	size_t			count = ocount;
 	xfs_buftarg_t		*target = XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp;
@@ -658,47 +712,9 @@ xfs_file_dio_aio_write(
 		*iolock = XFS_IOLOCK_EXCL;
 	else
 		*iolock = XFS_IOLOCK_SHARED;
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|*iolock);
 
-	ret = generic_write_checks(file, &pos, &count,
-					S_ISBLK(inode->i_mode));
-	if (ret) {
-		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|*iolock);
-		*iolock = 0;
-		return ret;
-	}
-
-	new_size = pos + count;
-	if (new_size > ip->i_size)
-		ip->i_new_size = new_size;
-
-	if (likely(!(file->f_mode & FMODE_NOCMTIME)))
-		file_update_time(file);
-
-	/*
-	 * If the offset is beyond the size of the file, we have a couple of
-	 * things to do. First, if there is already space allocated we need to
-	 * either create holes or zero the disk or ...
-	 *
-	 * If there is a page where the previous size lands, we need to zero it
-	 * out up to the new size.
-	 */
-	if (pos > ip->i_size) {
-		ret = -xfs_zero_eof(ip, pos, ip->i_size);
-		if (ret) {
-			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
-			return ret;
-		}
-	}
-	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
-
-	/*
-	 * If we're writing the file then make sure to clear the setuid and
-	 * setgid bits if the process is not being run by root.  This keeps
-	 * people from modifying setuid and setgid binaries.
-	 */
-	ret = file_remove_suid(file);
-	if (unlikely(ret))
+	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
+	if (ret)
 		return ret;
 
 	if (mapping->nrpages) {
@@ -738,38 +754,11 @@ xfs_file_buffered_aio_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
 	int			enospc = 0;
-	xfs_fsize_t		new_size;
 	size_t			count = ocount;
 
 	*iolock = XFS_IOLOCK_EXCL;
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|*iolock);
-
-	ret = generic_write_checks(file, &pos, &count,
-					S_ISBLK(inode->i_mode));
-	if (ret) {
-		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|*iolock);
-		*iolock = 0;
-		return ret;
-	}
-
-	new_size = pos + count;
-	if (new_size > ip->i_size)
-		ip->i_new_size = new_size;
-
-	if (likely(!(file->f_mode & FMODE_NOCMTIME)))
-		file_update_time(file);
-
-	if (pos > ip->i_size) {
-		ret = -xfs_zero_eof(ip, pos, ip->i_size);
-		if (ret) {
-			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
-			return ret;
-		}
-	}
-	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
-
-	ret = file_remove_suid(file);
-	if (unlikely(ret))
+	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
+	if (ret)
 		return ret;
 
 	/* We can write back this queue in page reclaim */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
