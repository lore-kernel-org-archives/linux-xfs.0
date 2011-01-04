Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p044kewr175954 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 22:46:41 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52FE71D0823A
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 20:48:45 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	dFD5SADtf9RvhaQc for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 20:48:45 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	51786249-1927428
	for <xfs@oss.sgi.com>; Tue, 04 Jan 2011 15:18:44 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PZyp9-0000Sz-9R
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:48:43 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PZyp7-0003tg-Ic
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:48:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfs: introduce xfs_rw_lock() helpers for locking the inode
Date: Tue,  4 Jan 2011 15:48:34 +1100
Message-Id: <1294116518-14908-5-git-send-email-david@fromorbit.com>
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

We need to obtain the i_mutex, i_iolock and i_ilock during the read
and write paths. Add a set of wrapper functions to neatly
encapsulate the lock ordering and shared/exclusive semantics to make
the locking easier to follow and get right.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_file.c |  123 ++++++++++++++++++++++++-------------------
 1 files changed, 68 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 33a688c..0d6111e 100644
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
 
@@ -356,11 +389,11 @@ xfs_aio_write_newsize_update(
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
 
@@ -386,14 +419,13 @@ xfs_file_splice_write(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL);
 
 	new_size = *ppos + count;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (new_size > ip->i_size)
 		ip->i_new_size = new_size;
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 
 	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
 
@@ -401,7 +433,7 @@ xfs_file_splice_write(
 
 	xfs_aio_write_isize_update(inode, ppos, ret);
 	xfs_aio_write_newsize_update(ip);
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
 	return ret;
 }
 
@@ -604,7 +636,6 @@ xfs_file_aio_write(
 	xfs_fsize_t		new_size;
 	int			iolock;
 	size_t			ocount = 0, count;
-	int			need_i_mutex;
 
 	XFS_STATS_INC(xs_write_calls);
 
@@ -631,21 +662,16 @@ xfs_file_aio_write(
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
 	ret = generic_write_checks(file, &pos, &count,
 					S_ISBLK(inode->i_mode));
 	if (ret) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
-		goto out_unlock_mutex;
+		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|iolock);
+		return ret;
 	}
 
 	if (ioflags & IO_ISDIRECT) {
@@ -654,16 +680,14 @@ start:
 				mp->m_rtdev_targp : mp->m_ddev_targp;
 
 		if ((pos & target->bt_smask) || (count & target->bt_smask)) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
+			xfs_rw_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 			return XFS_ERROR(-EINVAL);
 		}
 
-		if (!need_i_mutex && (mapping->nrpages || pos > ip->i_size)) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
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
@@ -687,11 +711,11 @@ start:
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
@@ -708,7 +732,7 @@ start:
 
 	if ((ioflags & IO_ISDIRECT)) {
 		if (mapping->nrpages) {
-			WARN_ON(need_i_mutex == 0);
+			WARN_ON(iolock != XFS_IOLOCK_EXCL);
 			ret = -xfs_flushinval_pages(ip,
 					(pos & PAGE_CACHE_MASK),
 					-1, FI_REMAPF_LOCKED);
@@ -716,13 +740,10 @@ start:
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
@@ -740,7 +761,7 @@ start:
 			count -= ret;
 
 			ioflags &= ~IO_ISDIRECT;
-			xfs_iunlock(ip, iolock);
+			xfs_rw_iunlock(ip, iolock);
 			goto relock;
 		}
 	} else {
@@ -779,14 +800,9 @@ write_retry:
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
@@ -798,10 +814,7 @@ write_retry:
 
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
