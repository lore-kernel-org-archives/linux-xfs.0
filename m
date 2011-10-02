Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p92EPMPP131104 for <xfs@oss.sgi.com>; Sun, 2 Oct 2011 09:25:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E7BE5588D8
	for <xfs@oss.sgi.com>; Sun,  2 Oct 2011 07:25:17 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	KGQp8P6w48JScnUr for <xfs@oss.sgi.com>;
	Sun, 02 Oct 2011 07:25:17 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RAMyj-0001sF-09
	for xfs@oss.sgi.com; Sun, 02 Oct 2011 14:25:17 +0000
Date: Sun, 2 Oct 2011 10:25:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: optimize fsync on directories
Message-ID: <20111002142516.GA6361@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Directories are only updated transactionally, which means fsync only
needs to flush the log the inode is currently dirty, but not bother
with checking for dirty data, non-transaction updates, an most importanly
doesn't have to flush disk caches except as part of a transaction commit.

While the first two optimizations can't easily be measured the latter
actually make a difference when doing lots of fsync that do not actually
have to commit the inode, e.g. becase an ealier fsync already pushed
the log far enough.

The new xfs_dir_fsync is identifical to xfs_nfs_commit_metadata except
for the prototype, but I'm not sure creating a common helper for the
two is worth it given how simple the functions are.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2011-09-26 10:56:48.607884402 +0200
+++ xfs/fs/xfs/xfs_file.c	2011-09-26 10:59:56.922867311 +0200
@@ -124,6 +124,35 @@ xfs_iozero(
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
+	loff_t			start,
+	loff_t			end,
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
@@ -1140,7 +1169,7 @@ const struct file_operations xfs_dir_fil
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= xfs_file_compat_ioctl,
 #endif
-	.fsync		= xfs_file_fsync,
+	.fsync		= xfs_dir_fsync,
 };
 
 static const struct vm_operations_struct xfs_file_vm_ops = {
Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2011-09-26 11:00:05.367867252 +0200
+++ xfs/fs/xfs/xfs_trace.h	2011-09-26 11:00:22.090368120 +0200
@@ -576,6 +576,7 @@ DEFINE_INODE_EVENT(xfs_vm_bmap);
 DEFINE_INODE_EVENT(xfs_file_ioctl);
 DEFINE_INODE_EVENT(xfs_file_compat_ioctl);
 DEFINE_INODE_EVENT(xfs_ioctl_setattr);
+DEFINE_INODE_EVENT(xfs_dir_fsync);
 DEFINE_INODE_EVENT(xfs_file_fsync);
 DEFINE_INODE_EVENT(xfs_destroy_inode);
 DEFINE_INODE_EVENT(xfs_write_inode);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
