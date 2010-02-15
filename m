Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1F9imtP047253 for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 03:44:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8895D1CCFB70
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 01:46:05 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id EH2Fj3mDSdjCD40n for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2010 01:46:05 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NgxWn-0000Fk-67
	for xfs@oss.sgi.com; Mon, 15 Feb 2010 09:46:05 +0000
Message-Id: <20100215094605.009247071@bombadil.infradead.org>
Date: Mon, 15 Feb 2010 04:44:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] [PATCH 4/4] xfs: implement optimized fdatasync
References: <20100215094445.528696829@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-implement-fdatasync
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

Allow us to track the difference between timestamp and size updates by using
mark_inode_dirty from the I/O completion code, and checking the VFS inode
flags in xfs_file_fsync.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-02-15 10:23:14.050003751 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-02-15 10:23:28.407272435 +0100
@@ -187,7 +187,7 @@ xfs_setfilesize(
 	isize = xfs_ioend_new_eof(ioend);
 	if (isize) {
 		ip->i_d.di_size = isize;
-		xfs_mark_inode_dirty_sync(ip);
+		xfs_mark_inode_dirty(ip);
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -341,7 +341,7 @@ xfs_submit_ioend_bio(
 	 * but don't update the inode size until I/O completion.
 	 */
 	if (xfs_ioend_new_eof(ioend))
-		xfs_mark_inode_dirty_sync(XFS_I(ioend->io_inode));
+		xfs_mark_inode_dirty(XFS_I(ioend->io_inode));
 
 	submit_bio(wbc->sync_mode == WB_SYNC_ALL ?
 		   WRITE_SYNC_PLUG : WRITE, bio);
Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-02-15 10:23:25.212255603 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-02-15 10:26:34.946005568 +0100
@@ -97,16 +97,6 @@ xfs_iozero(
 	return (-status);
 }
 
-/*
- * We ignore the datasync flag here because a datasync is effectively
- * identical to an fsync. That is, datasync implies that we need to write
- * only the metadata needed to be able to access the data that is written
- * if we crash after the call completes. Hence if we are writing beyond
- * EOF we have to log the inode size change as well, which makes it a
- * full fsync. If we don't write beyond EOF, the inode core will be
- * clean in memory and so we don't need to log the inode, just like
- * fsync.
- */
 STATIC int
 xfs_file_fsync(
 	struct file		*file,
@@ -139,7 +129,18 @@ xfs_file_fsync(
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
-	if (ip->i_update_core) {
+	/*
+	 * First check if the VFS inode is marked dirty.  All the dirtying
+	 * of non-transactional updates no goes through mark_inode_dirty*,
+	 * which allows us to distinguish beteeen pure timestamp updates
+	 * and i_size updates which need to be caught for fdatasync.
+	 * After that also theck for the dirty state in the XFS inode, which
+	 * might gets cleared when the inode gets written out via the AIL
+	 * or xfs_iflush_cluster.
+	 */
+	if (((dentry->d_inode->i_state & I_DIRTY_DATASYNC) ||
+	    ((dentry->d_inode->i_state & I_DIRTY_SYNC) && !datasync)) &&
+	    ip->i_update_core) {
 		/*
 		 * Kick off a transaction to log the inode core to get the
 		 * updates.  The sync transaction will also force the log.
Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2010-02-15 10:23:14.069003332 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2010-02-15 10:23:28.419024635 +0100
@@ -91,6 +91,16 @@ xfs_mark_inode_dirty_sync(
 		mark_inode_dirty_sync(inode);
 }
 
+void
+xfs_mark_inode_dirty(
+	xfs_inode_t	*ip)
+{
+	struct inode	*inode = VFS_I(ip);
+
+	if (!(inode->i_state & (I_WILL_FREE|I_FREEING|I_CLEAR)))
+		mark_inode_dirty(inode);
+}
+
 /*
  * Change the requested timestamp in the given inode.
  * We don't lock across timestamp updates, and we don't log them but
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2010-02-15 10:23:14.079253157 +0100
+++ xfs/fs/xfs/xfs_inode.h	2010-02-15 10:23:28.424047333 +0100
@@ -480,6 +480,7 @@ void		xfs_lock_inodes(xfs_inode_t **, in
 void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 
 void		xfs_synchronize_times(xfs_inode_t *);
+void		xfs_mark_inode_dirty(xfs_inode_t *);
 void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
 
 #define IHOLD(ip) \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
