Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3QE79cm233106 for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 09:07:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D8AF1CE98A6
	for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 07:07:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uw0fKEgY7as3zd1I for
	<xfs@oss.sgi.com>; Sun, 26 Apr 2009 07:07:08 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Ly50d-0008Jl-Vh
	for xfs@oss.sgi.com; Sun, 26 Apr 2009 14:07:08 +0000
Message-Id: <20090426140707.884922000@bombadil.infradead.org>
Date: Sun, 26 Apr 2009 10:03:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/5] xfs: make inodes dirty before issuing I/O
References: <20090426140305.113371000@bombadil.infradead.org>
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

To make sure they get properly waited on in sync when I/O is in flight and
we latter need to update the inode size.



Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-04-26 10:33:05.556127371 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2009-04-26 10:37:23.137953826 +0200
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
 		ip->i_update_core = 1;
 		ip->i_update_size = 1;
@@ -405,10 +418,16 @@ xfs_submit_ioend_bio(
 	struct bio	*bio)
 {
 	atomic_inc(&ioend->io_remaining);
-
 	bio->bi_private = ioend;
 	bio->bi_end_io = xfs_end_bio;
 
+	/*
+	 * if the I/O is beyond EOF we mark the inode dirty immediately
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
