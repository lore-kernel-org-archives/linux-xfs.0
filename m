Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52oej134714 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:50 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	LfuF7enmCx0J23SS for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:35 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZg-0003Eh-0Q
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:20 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZf-0003cF-UD
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 014/102] xfs: optimize fsync on directories
Date: Thu, 23 Aug 2012 15:01:32 +1000
Message-Id: <1345698180-13612-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 1da2f2dbf2d2aaa1b0f6ca2f61fcf07e24eb659b

Directories are only updated transactionally, which means fsync only
needs to flush the log the inode is currently dirty, but not bother
with checking for dirty data, non-transactional updates, and most
importanly doesn't have to flush disk caches except as part of a
transaction commit.

While the first two optimizations can't easily be measured, the
latter actually makes a difference when doing lots of fsync that do
not actually have to commit the inode, e.g. because an earlier fsync
already pushed the log far enough.

The new xfs_dir_fsync is identical to xfs_nfs_commit_metadata except
for the prototype, but I'm not sure creating a common helper for the
two is worth it given how simple the functions are.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_file.c  |   29 ++++++++++++++++++++++++++++-
 fs/xfs/linux-2.6/xfs_trace.h |    1 +
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 67d392a..185a337 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -124,6 +124,33 @@ xfs_iozero(
 	return (-status);
 }
 
+/*
+ * Fsync operations on directories are much simpler than on regular files,
+ * as there is no file data to flush, and thus also no need for explicit
+ * cache flush operations, and there are no non-transaction metadata updates
+ * on directories either.
+ */
+STATIC int
+xfs_dir_fsync(
+	struct file		*file,
+	int			datasync)
+{
+	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_lsn_t		lsn = 0;
+
+	trace_xfs_dir_fsync(ip);
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (xfs_ipincount(ip))
+		lsn = ip->i_itemp->ili_last_lsn;
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (!lsn)
+		return 0;
+	return _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
+}
+
 STATIC int
 xfs_file_fsync(
 	struct file		*file,
@@ -1141,7 +1168,7 @@ const struct file_operations xfs_dir_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= xfs_file_compat_ioctl,
 #endif
-	.fsync		= xfs_file_fsync,
+	.fsync		= xfs_dir_fsync,
 };
 
 static const struct vm_operations_struct xfs_file_vm_ops = {
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index d48b7a5..fae13a0 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -577,6 +577,7 @@ DEFINE_INODE_EVENT(xfs_vm_bmap);
 DEFINE_INODE_EVENT(xfs_file_ioctl);
 DEFINE_INODE_EVENT(xfs_file_compat_ioctl);
 DEFINE_INODE_EVENT(xfs_ioctl_setattr);
+DEFINE_INODE_EVENT(xfs_dir_fsync);
 DEFINE_INODE_EVENT(xfs_file_fsync);
 DEFINE_INODE_EVENT(xfs_destroy_inode);
 DEFINE_INODE_EVENT(xfs_write_inode);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
