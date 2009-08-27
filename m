Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7RNF5TY116156 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 18:15:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 88F0D4064CF
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 16:15:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bVJDrS4YR0Wum6YB for
	<xfs@oss.sgi.com>; Thu, 27 Aug 2009 16:15:59 -0700 (PDT)
Message-Id: <20090827231557.717120121@bombadil.infradead.org>
Date: Thu, 27 Aug 2009 19:15:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] xfs: mark inodes dirty before issuing I/O
References: <20090827231536.646792672@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-mark-inode-dirty-early
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

From: Dave Chinner <david@fromorbit.com>

To make sure they get properly waited on in sync when I/O is in flight and
we latter need to update the inode size.  Requires a new helper to check if an
ioend structure is beyond the current EOF.


Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-08-26 20:06:07.105357325 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2009-08-26 20:08:09.017355358 -0300
@@ -186,19 +186,37 @@ xfs_destroy_ioend(
 }
 
 /*
+ * If the end of the current ioend is beyond the current EOF,
+ * return the new EOF value, otherwise zero.
+ */
+STATIC xfs_fsize_t
+xfs_ioend_new_eof(
+	xfs_ioend_t		*ioend)
+{
+	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
+	xfs_fsize_t		isize;
+	xfs_fsize_t		bsize;
+
+	bsize = ioend->io_offset + ioend->io_size;
+	isize = MAX(ip->i_size, ip->i_new_size);
+	isize = MIN(isize, bsize);
+	return isize > ip->i_d.di_size ? isize : 0;
+}
+
+/*
  * Update on-disk file size now that data has been written to disk.
  * The current in-memory file size is i_size.  If a write is beyond
  * eof i_new_size will be the intended file size until i_size is
  * updated.  If this write does not extend all the way to the valid
  * file size then restrict this update to the end of the write.
  */
+
 STATIC void
 xfs_setfilesize(
 	xfs_ioend_t		*ioend)
 {
 	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
 	xfs_fsize_t		isize;
-	xfs_fsize_t		bsize;
 
 	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
 	ASSERT(ioend->io_type != IOMAP_READ);
@@ -206,14 +224,9 @@ xfs_setfilesize(
 	if (unlikely(ioend->io_error))
 		return;
 
-	bsize = ioend->io_offset + ioend->io_size;
-
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	isize = MAX(ip->i_size, ip->i_new_size);
-	isize = MIN(isize, bsize);
-
-	if (ip->i_d.di_size < isize) {
+	isize = xfs_ioend_new_eof(ioend);
+	if (isize) {
 		ip->i_d.di_size = isize;
 		xfs_mark_inode_dirty_sync(ip);
 	}
@@ -403,10 +416,16 @@ xfs_submit_ioend_bio(
 	struct bio	*bio)
 {
 	atomic_inc(&ioend->io_remaining);
-
 	bio->bi_private = ioend;
 	bio->bi_end_io = xfs_end_bio;
 
+	/*
+	 * If the I/O is beyond EOF we mark the inode dirty immediately
+	 * but don't update the inode size until I/O completion.
+	 */
+	if (xfs_ioend_new_eof(ioend))
+		xfs_mark_inode_dirty_sync(XFS_I(ioend->io_inode));
+
 	submit_bio(WRITE, bio);
 	ASSERT(!bio_flagged(bio, BIO_EOPNOTSUPP));
 	bio_put(bio);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
