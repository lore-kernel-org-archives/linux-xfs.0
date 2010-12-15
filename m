Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBF1NUNC159549 for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 19:23:30 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCA6514519C6
	for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 17:25:21 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	78i5YUhZshfnDhty for <xfs@oss.sgi.com>;
	Tue, 14 Dec 2010 17:25:21 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50369412-1927428
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 11:55:17 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PSg7I-00064P-4H
	for xfs@oss.sgi.com; Wed, 15 Dec 2010 12:25:16 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PSg5d-0004HN-SL
	for xfs@oss.sgi.com; Wed, 15 Dec 2010 12:23:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/7] xfs: factor common write setup code
Date: Wed, 15 Dec 2010 12:23:27 +1100
Message-Id: <1292376208-16282-7-git-send-email-david@fromorbit.com>
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

The buffered IO and direct Io write paths share a common set of
checks and limiting code prior to issuing the write. Factor that
into a common helper function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_file.c |  130 ++++++++++++++++++++-----------------------
 1 files changed, 61 insertions(+), 69 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index e10e703..269da12 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -588,6 +588,63 @@ out_lock:
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
+	int			error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL|*iolock);
+
+	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
+	if (error) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL|*iolock);
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
+	if (*pos > ip->i_size) {
+		error = -xfs_zero_eof(ip, *pos, ip->i_size);
+		if (error) {
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			return error;
+		}
+	}
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
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
@@ -613,7 +670,6 @@ xfs_file_dio_aio_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			error = 0;
-	xfs_fsize_t		new_size;
 	size_t			count = ocount;
 	xfs_buftarg_t		*target = XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp;
@@ -630,47 +686,9 @@ xfs_file_dio_aio_write(
 	} else {
 		*iolock = XFS_IOLOCK_SHARED;
 	}
-	xfs_ilock(ip, XFS_ILOCK_EXCL|*iolock);
-
-	error = generic_write_checks(file, &pos, &count,
-					S_ISBLK(inode->i_mode));
-	if (error) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL|*iolock);
-		*iolock = 0;
-		return error;
-	}
 
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
-		error = -xfs_zero_eof(ip, pos, ip->i_size);
-		if (error) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			return error;
-		}
-	}
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
-	/*
-	 * If we're writing the file then make sure to clear the setuid and
-	 * setgid bits if the process is not being run by root.  This keeps
-	 * people from modifying setuid and setgid binaries.
-	 */
-	error = file_remove_suid(file);
-	if (unlikely(error))
+	error = xfs_file_aio_write_checks(file, &pos, &count, iolock);
+	if (error)
 		return error;
 
 	if (mapping->nrpages) {
@@ -713,40 +731,14 @@ xfs_file_buffered_aio_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0, error = 0;
 	int			enospc = 0;
-	xfs_fsize_t		new_size;
 	size_t			count = ocount;
 
 	*iolock = XFS_IOLOCK_EXCL;
 	*need_i_mutex = 1;
 	mutex_lock(&inode->i_mutex);
-	xfs_ilock(ip, XFS_ILOCK_EXCL|*iolock);
-
-	error = generic_write_checks(file, &pos, &count,
-					S_ISBLK(inode->i_mode));
-	if (error) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL|*iolock);
-		*iolock = 0;
-		return error;
-	}
-
-	new_size = pos + count;
-	if (new_size > ip->i_size)
-		ip->i_new_size = new_size;
 
-	if (likely(!(file->f_mode & FMODE_NOCMTIME)))
-		file_update_time(file);
-
-	if (pos > ip->i_size) {
-		error = -xfs_zero_eof(ip, pos, ip->i_size);
-		if (error) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			return error;
-		}
-	}
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
-	error = file_remove_suid(file);
-	if (unlikely(error))
+	error = xfs_file_aio_write_checks(file, &pos, &count, iolock);
+	if (error)
 		return error;
 
 	/* We can write back this queue in page reclaim */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
