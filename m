Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DFC4429E00
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 12:40:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D25AE304053
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 10:40:23 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id lS77bagSBWtyvAI7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 10:40:20 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] direct-io: always call ->end_io if non-NULL
Date: Wed,  3 Feb 2016 19:40:14 +0100
Message-Id: <1454524816-11392-2-git-send-email-hch@lst.de>
In-Reply-To: <1454524816-11392-1-git-send-email-hch@lst.de>
References: <1454524816-11392-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

This way we can pass back errors to the file system, and allow for
cleanup required for all direct I/O invocations.

Also allow the ->end_io handlers to return errors on their own, so that
I/O completion errors can be passed on to the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c           |  9 +++++++--
 fs/direct-io.c     |  9 +++++++--
 fs/ext4/inode.c    |  9 +++++++--
 fs/ocfs2/aops.c    |  7 ++++++-
 fs/xfs/xfs_aops.c  | 13 +++++++------
 include/linux/fs.h |  2 +-
 6 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4fd6b0c..e38b2c5 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -267,8 +267,13 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
 	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ)
 		inode_unlock(inode);
 
-	if ((retval > 0) && end_io)
-		end_io(iocb, pos, retval, bh.b_private);
+	if (end_io) {
+		int err;
+
+		err = end_io(iocb, pos, retval, bh.b_private);
+		if (err)
+			retval = err;
+	}
 
 	if (!(flags & DIO_SKIP_DIO_COUNT))
 		inode_dio_end(inode);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 1b2f7ff..9c6f885 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -253,8 +253,13 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
 	if (ret == 0)
 		ret = transferred;
 
-	if (dio->end_io && dio->result)
-		dio->end_io(dio->iocb, offset, transferred, dio->private);
+	if (dio->end_io) {
+		int err;
+
+		err = dio->end_io(dio->iocb, offset, ret, dio->private);
+		if (err)
+			ret = err;
+	}
 
 	if (!(dio->flags & DIO_SKIP_DIO_COUNT))
 		inode_dio_end(dio->inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 83bc8bf..9db04dd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3161,14 +3161,17 @@ out:
 }
 #endif
 
-static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
+static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 			    ssize_t size, void *private)
 {
         ext4_io_end_t *io_end = iocb->private;
 
+	if (size <= 0)
+		return 0;
+
 	/* if not async direct IO just return */
 	if (!io_end)
-		return;
+		return 0;
 
 	ext_debug("ext4_end_io_dio(): io_end 0x%p "
 		  "for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
@@ -3179,6 +3182,8 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 	io_end->offset = offset;
 	io_end->size = size;
 	ext4_put_io_end(io_end);
+
+	return 0;
 }
 
 /*
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 794fd15..5dcc5f5 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -620,7 +620,7 @@ bail:
  * particularly interested in the aio/dio case.  We use the rw_lock DLM lock
  * to protect io on one node from truncation on another.
  */
-static void ocfs2_dio_end_io(struct kiocb *iocb,
+static int ocfs2_dio_end_io(struct kiocb *iocb,
 			     loff_t offset,
 			     ssize_t bytes,
 			     void *private)
@@ -628,6 +628,9 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	struct inode *inode = file_inode(iocb->ki_filp);
 	int level;
 
+	if (bytes <= 0)
+		return 0;
+
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
 
@@ -644,6 +647,8 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 		level = ocfs2_iocb_rw_locked_level(iocb);
 		ocfs2_rw_unlock(inode, level);
 	}
+
+	return 0;
 }
 
 static int ocfs2_releasepage(struct page *page, gfp_t wait)
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 379c089..295aaff 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1645,7 +1645,7 @@ out_end_io:
  * case the completion can be called in interrupt context, whereas if we have an
  * ioend we will always be called in task context (i.e. from a workqueue).
  */
-STATIC void
+STATIC int
 xfs_end_io_direct_write(
 	struct kiocb		*iocb,
 	loff_t			offset,
@@ -1655,15 +1655,19 @@ xfs_end_io_direct_write(
 	struct inode		*inode = file_inode(iocb->ki_filp);
 	struct xfs_ioend	*ioend = private;
 
+	if (size <= 0)
+		return 0;
+
 	trace_xfs_gbmap_direct_endio(XFS_I(inode), offset, size,
 				     ioend ? ioend->io_type : 0, NULL);
 
 	if (!ioend) {
 		ASSERT(offset + size <= i_size_read(inode));
-		return;
+		return 0;
 	}
 
 	__xfs_end_io_direct_write(inode, ioend, offset, size);
+	return 0;
 }
 
 static inline ssize_t
@@ -1672,10 +1676,7 @@ xfs_vm_do_dio(
 	struct kiocb		*iocb,
 	struct iov_iter		*iter,
 	loff_t			offset,
-	void			(*endio)(struct kiocb	*iocb,
-					 loff_t		offset,
-					 ssize_t	size,
-					 void		*private),
+	dio_iodone_t		endio,
 	int			flags)
 {
 	struct block_device	*bdev;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1a20462..d7f37bf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -70,7 +70,7 @@ extern int sysctl_protected_hardlinks;
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create);
-typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
+typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 			ssize_t bytes, void *private);
 typedef void (dax_iodone_t)(struct buffer_head *bh_map, int uptodate);
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
