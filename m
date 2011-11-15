Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAFKET8D067895 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 14:14:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7959135D2EB
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 12:14:27 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	sUaMDeSF074gkONk for <xfs@oss.sgi.com>;
	Tue, 15 Nov 2011 12:14:27 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RQPOk-0007SM-Tc
	for xfs@oss.sgi.com; Tue, 15 Nov 2011 20:14:27 +0000
Message-Id: <20111115201426.862605739@bombadil.infradead.org>
Date: Tue, 15 Nov 2011 15:14:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/5] xfs: do not require an ioend for new EOF calculation
References: <20111115201407.038216766@bombadil.infradead.org>
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
 fs/xfs/xfs_aops.c  |   26 +++++---------------------
 fs/xfs/xfs_inode.h |   14 ++++++++++++++
 2 files changed, 19 insertions(+), 21 deletions(-)

Index: linux-2.6/fs/xfs/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_aops.c	2011-11-08 08:11:44.891887054 +0100
+++ linux-2.6/fs/xfs/xfs_aops.c	2011-11-08 08:12:31.586400976 +0100
@@ -99,24 +99,6 @@ xfs_destroy_ioend(
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
-	isize = MAX(ip->i_size, ip->i_new_size);
-	isize = MIN(isize, bsize);
-	return isize > ip->i_d.di_size ? isize : 0;
-}
-
-/*
  * Fast and loose check if this write could update the on-disk inode size.
  */
 static inline bool xfs_ioend_is_append(struct xfs_ioend *ioend)
@@ -140,7 +122,7 @@ xfs_setfilesize(
 	xfs_fsize_t		isize;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	isize = xfs_ioend_new_eof(ioend);
+	isize = xfs_new_eof(ip, ioend->io_offset + ioend->io_size);
 	if (isize) {
 		trace_xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
 		ip->i_d.di_size = isize;
@@ -362,6 +344,8 @@ xfs_submit_ioend_bio(
 	xfs_ioend_t		*ioend,
 	struct bio		*bio)
 {
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+
 	atomic_inc(&ioend->io_remaining);
 	bio->bi_private = ioend;
 	bio->bi_end_io = xfs_end_bio;
@@ -370,8 +354,8 @@ xfs_submit_ioend_bio(
 	 * If the I/O is beyond EOF we mark the inode dirty immediately
 	 * but don't update the inode size until I/O completion.
 	 */
-	if (xfs_ioend_new_eof(ioend))
-		xfs_mark_inode_dirty(XFS_I(ioend->io_inode));
+	if (xfs_new_eof(ip, ioend->io_offset + ioend->io_size))
+		xfs_mark_inode_dirty(ip);
 
 	submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE, bio);
 }
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2011-11-08 08:02:50.000000000 +0100
+++ linux-2.6/fs/xfs/xfs_inode.h	2011-11-08 08:13:01.290386996 +0100
@@ -278,6 +278,20 @@ static inline struct inode *VFS_I(struct
 }
 
 /*
+ * If this I/O goes past the on-disk inode size update it unless it would
+ * be past the current in-core or write in-progress inode size.
+ */
+static inline xfs_fsize_t
+xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
+{
+	xfs_fsize_t i_size = max(ip->i_size, ip->i_new_size);
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
