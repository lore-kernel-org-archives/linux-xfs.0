Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17IBvL3250506 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 12:11:57 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JcAHTJ0ePWcHdupb (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 10:11:56 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RupWF-00027x-70
	for xfs@oss.sgi.com; Tue, 07 Feb 2012 18:11:55 +0000
Message-Id: <20120207181155.167493646@bombadil.infradead.org>
Date: Tue, 07 Feb 2012 13:10:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfs: do not require an ioend for new EOF calculation
References: <20120207181037.745771452@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-eof-calculation
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

Replace xfs_ioend_new_eof with a new inline xfs_new_eof helper that
doesn't require and ioend, and is available also outside of xfs_aops.c.

Also make the code a bit more clear by using a normal if statement
instead of a slightly misleading MIN().

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_aops.c  |   24 ++++--------------------
 fs/xfs/xfs_inode.h |   14 ++++++++++++++
 2 files changed, 18 insertions(+), 20 deletions(-)

Index: xfs/fs/xfs/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.c	2011-11-30 11:05:19.260046232 +0100
+++ xfs/fs/xfs/xfs_aops.c	2011-11-30 11:06:07.983115611 +0100
@@ -99,23 +99,6 @@ xfs_destroy_ioend(
 }
 
 /*
- * If the end of the current ioend is beyond the current EOF,
- * return the new EOF value, otherwise zero.
- */
-STATIC xfs_fsize_t
-xfs_ioend_new_eof(
-	xfs_ioend_t		*ioend)
-{
-	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
-	xfs_fsize_t		isize;
-	xfs_fsize_t		bsize;
-
-	bsize = ioend->io_offset + ioend->io_size;
-	isize = MIN(i_size_read(VFS_I(ip)), bsize);
-	return isize > ip->i_d.di_size ? isize : 0;
-}
-
-/*
  * Fast and loose check if this write could update the on-disk inode size.
  */
 static inline bool xfs_ioend_is_append(struct xfs_ioend *ioend)
@@ -135,7 +118,7 @@ xfs_setfilesize(
 	xfs_fsize_t		isize;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	isize = xfs_ioend_new_eof(ioend);
+	isize = xfs_new_eof(ip, ioend->io_offset + ioend->io_size);
 	if (isize) {
 		trace_xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
 		ip->i_d.di_size = isize;
@@ -357,6 +340,7 @@ xfs_submit_ioend_bio(
 	xfs_ioend_t		*ioend,
 	struct bio		*bio)
 {
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	atomic_inc(&ioend->io_remaining);
 	bio->bi_private = ioend;
 	bio->bi_end_io = xfs_end_bio;
@@ -365,8 +349,8 @@ xfs_submit_ioend_bio(
 	 * If the I/O is beyond EOF we mark the inode dirty immediately
 	 * but don't update the inode size until I/O completion.
 	 */
-	if (xfs_ioend_new_eof(ioend))
-		xfs_mark_inode_dirty(XFS_I(ioend->io_inode));
+	if (xfs_new_eof(ip, ioend->io_offset + ioend->io_size))
+		xfs_mark_inode_dirty(ip);
 
 	submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE, bio);
 }
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-11-30 11:05:16.670060264 +0100
+++ xfs/fs/xfs/xfs_inode.h	2011-11-30 11:06:03.769805103 +0100
@@ -275,6 +275,20 @@ static inline xfs_fsize_t XFS_ISIZE(stru
 }
 
 /*
+ * If this I/O goes past the on-disk inode size update it unless it would
+ * be past the current in-core inode size.
+ */
+static inline xfs_fsize_t
+xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
+{
+	xfs_fsize_t i_size = i_size_read(VFS_I(ip));
+
+	if (new_size > i_size)
+		new_size = i_size;
+	return new_size > ip->i_d.di_size ? new_size : 0;
+}
+
+/*
  * i_flags helper functions
  */
 static inline void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
