Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ANaCq4053026 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 17:36:12 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 316611D20AF7
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 15:38:22 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	jqzrotj4CJDyx0C4 for <xfs@oss.sgi.com>;
	Mon, 10 Jan 2011 15:38:22 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	51786252-1927428
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 10:08:21 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcRJS-0006VY-3J
	for xfs@oss.sgi.com; Tue, 11 Jan 2011 10:38:10 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PcRJJ-0003yZ-S8
	for xfs@oss.sgi.com; Tue, 11 Jan 2011 10:38:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfs: introduce xfs_rw_lock() helpers for locking the inode
Date: Tue, 11 Jan 2011 10:37:44 +1100
Message-Id: <1294702668-15216-5-git-send-email-david@fromorbit.com>
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

We need to obtain the i_mutex, i_iolock and i_ilock during the read
and write paths. Add a set of wrapper functions to neatly
encapsulate the lock ordering and shared/exclusive semantics to make
the locking easier to follow and get right.

Note that this changes some of the exclusive locking serialisation in
that serialisation will occur against the i_mutex instead of the
XFS_IOLOCK_EXCL. This does not change any behaviour, and it is
arguably more efficient to use the mutex for such serialisation than
the rw_sem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_file.c |  136 ++++++++++++++++++++++++++-----------------
 1 files changed, 82 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index c47d7dc0..941d7c2 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -41,6 +41,40 @@
 static const struct vm_operations_struct xfs_file_vm_ops;
 
 /*
+ * Locking primitives for read and write IO paths to ensure we consistently use
+ * and order the inode->i_mutex, ip->i_lock and ip->i_iolock.
+ */
+static inline void
+xfs_rw_ilock(
+	struct xfs_inode	*ip,
+	int			type)
+{
+	if (type & XFS_IOLOCK_EXCL)
+		mutex_lock(&VFS_I(ip)->i_mutex);
+	xfs_ilock(ip, type);
+}
+
+static inline void
+xfs_rw_iunlock(
+	struct xfs_inode	*ip,
+	int			type)
+{
+	xfs_iunlock(ip, type);
+	if (type & XFS_IOLOCK_EXCL)
+		mutex_unlock(&VFS_I(ip)->i_mutex);
+}
+
+static inline void
+xfs_rw_ilock_demote(
+	struct xfs_inode	*ip,
+	int			type)
+{
+	xfs_ilock_demote(ip, type);
+	if (type & XFS_IOLOCK_EXCL)
+		mutex_unlock(&VFS_I(ip)->i_mutex);
+}
+
+/*
  *	xfs_iozero
  *
  *	xfs_iozero clears the specified range of buffer supplied,
@@ -262,22 +296,21 @@ xfs_file_aio_read(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if (unlikely(ioflags & IO_ISDIRECT))
-		mutex_lock(&inode->i_mutex);
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-
 	if (unlikely(ioflags & IO_ISDIRECT)) {
+		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
+
 		if (inode->i_mapping->nrpages) {
 			ret = -xfs_flushinval_pages(ip,
 					(iocb->ki_pos & PAGE_CACHE_MASK),
 					-1, FI_REMAPF_LOCKED);
+			if (ret) {
+				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
+				return ret;
+			}
 		}
-		mutex_unlock(&inode->i_mutex);
-		if (ret) {
-			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-			return ret;
-		}
-	}
+		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
+	} else
+		xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
 
 	trace_xfs_file_read(ip, size, iocb->ki_pos, ioflags);
 
@@ -285,7 +318,7 @@ xfs_file_aio_read(
 	if (ret > 0)
 		XFS_STATS_ADD(xs_read_bytes, ret);
 
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 	return ret;
 }
 
@@ -309,7 +342,7 @@ xfs_file_splice_read(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
 
 	trace_xfs_file_splice_read(ip, count, *ppos, ioflags);
 
@@ -317,7 +350,7 @@ xfs_file_splice_read(
 	if (ret > 0)
 		XFS_STATS_ADD(xs_read_bytes, ret);
 
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 	return ret;
 }
 
@@ -338,10 +371,10 @@ xfs_aio_write_isize_update(
 		*ppos = isize;
 
 	if (*ppos > ip->i_size) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
 		if (*ppos > ip->i_size)
 			ip->i_size = *ppos;
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 }
 
@@ -356,14 +389,22 @@ xfs_aio_write_newsize_update(
 	struct xfs_inode	*ip)
 {
 	if (ip->i_new_size) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
 		ip->i_new_size = 0;
 		if (ip->i_d.di_size > ip->i_size)
 			ip->i_d.di_size = ip->i_size;
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 }
 
+/*
+ * xfs_file_splice_write() does not use xfs_rw_ilock() because
+ * generic_file_splice_write() takes the i_mutex itself. This, in theory,
+ * couuld cause lock inversions between the aio_write path and the splice path
+ * if someone is doing concurrent splice(2) based writes and write(2) based
+ * writes to the same inode. The only real way to fix this is to re-implement
+ * the generic code here with correct locking orders.
+ */
 STATIC ssize_t
 xfs_file_splice_write(
 	struct pipe_inode_info	*pipe,
@@ -386,14 +427,13 @@ xfs_file_splice_write(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL);
 
 	new_size = *ppos + count;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (new_size > ip->i_size)
 		ip->i_new_size = new_size;
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 
 	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
 
@@ -604,7 +644,6 @@ xfs_file_aio_write(
 	xfs_fsize_t		new_size;
 	int			iolock;
 	size_t			ocount = 0, count;
-	int			need_i_mutex;
 
 	XFS_STATS_INC(xs_write_calls);
 
@@ -631,21 +670,17 @@ xfs_file_aio_write(
 relock:
 	if (ioflags & IO_ISDIRECT) {
 		iolock = XFS_IOLOCK_SHARED;
-		need_i_mutex = 0;
 	} else {
 		iolock = XFS_IOLOCK_EXCL;
-		need_i_mutex = 1;
-		mutex_lock(&inode->i_mutex);
 	}
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL|iolock);
-
 start:
+	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|iolock);
 	ret = generic_write_checks(file, &pos, &count,
 					S_ISBLK(inode->i_mode));
 	if (ret) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
-		goto out_unlock_mutex;
+		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|iolock);
+		return ret;
 	}
 
 	if (ioflags & IO_ISDIRECT) {
@@ -654,16 +689,20 @@ start:
 				mp->m_rtdev_targp : mp->m_ddev_targp;
 
 		if ((pos & target->bt_smask) || (count & target->bt_smask)) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
+			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 			return XFS_ERROR(-EINVAL);
 		}
 
-		if (!need_i_mutex && (mapping->nrpages || pos > ip->i_size)) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
+		/*
+		 * For direct I/O, if there are cached pages or we're extending
+		 * the file, we need IOLOCK_EXCL until we're sure the bytes at
+		 * the new EOF have been zeroed and/or the cached pages are
+		 * flushed out.  Upgrade the I/O lock and start again.
+		 */
+		if (iolock != XFS_IOLOCK_EXCL &&
+		    (mapping->nrpages || pos > ip->i_size)) {
+			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 			iolock = XFS_IOLOCK_EXCL;
-			need_i_mutex = 1;
-			mutex_lock(&inode->i_mutex);
-			xfs_ilock(ip, XFS_ILOCK_EXCL|iolock);
 			goto start;
 		}
 	}
@@ -687,11 +726,11 @@ start:
 	if (pos > ip->i_size) {
 		ret = -xfs_zero_eof(ip, pos, ip->i_size);
 		if (ret) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 			goto out_unlock_internal;
 		}
 	}
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 
 	/*
 	 * If we're writing the file then make sure to clear the
@@ -708,7 +747,7 @@ start:
 
 	if ((ioflags & IO_ISDIRECT)) {
 		if (mapping->nrpages) {
-			WARN_ON(need_i_mutex == 0);
+			WARN_ON(iolock != XFS_IOLOCK_EXCL);
 			ret = -xfs_flushinval_pages(ip,
 					(pos & PAGE_CACHE_MASK),
 					-1, FI_REMAPF_LOCKED);
@@ -716,13 +755,10 @@ start:
 				goto out_unlock_internal;
 		}
 
-		if (need_i_mutex) {
+		if (iolock == XFS_IOLOCK_EXCL) {
 			/* demote the lock now the cached pages are gone */
-			xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
-			mutex_unlock(&inode->i_mutex);
-
+			xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
 			iolock = XFS_IOLOCK_SHARED;
-			need_i_mutex = 0;
 		}
 
 		trace_xfs_file_direct_write(ip, count, iocb->ki_pos, ioflags);
@@ -740,7 +776,7 @@ start:
 			count -= ret;
 
 			ioflags &= ~IO_ISDIRECT;
-			xfs_iunlock(ip, iolock);
+			xfs_rw_iunlock(ip, iolock);
 			goto relock;
 		}
 	} else {
@@ -775,14 +811,9 @@ write_retry:
 		loff_t end = pos + ret - 1;
 		int error, error2;
 
-		xfs_iunlock(ip, iolock);
-		if (need_i_mutex)
-			mutex_unlock(&inode->i_mutex);
-
+		xfs_rw_iunlock(ip, iolock);
 		error = filemap_write_and_wait_range(mapping, pos, end);
-		if (need_i_mutex)
-			mutex_lock(&inode->i_mutex);
-		xfs_ilock(ip, iolock);
+		xfs_rw_ilock(ip, iolock);
 
 		error2 = -xfs_file_fsync(file,
 					 (file->f_flags & __O_SYNC) ? 0 : 1);
@@ -794,10 +825,7 @@ write_retry:
 
  out_unlock_internal:
 	xfs_aio_write_newsize_update(ip);
-	xfs_iunlock(ip, iolock);
- out_unlock_mutex:
-	if (need_i_mutex)
-		mutex_unlock(&inode->i_mutex);
+	xfs_rw_iunlock(ip, iolock);
 	return ret;
 }
 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
