Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2044A7F84
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 16:02:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A354AAC003
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 14:02:34 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 66HNlRJ8NpWuHzhv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 14:02:31 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] fs: pass iocb to generic_write_sync
Date: Wed,  1 Oct 2014 23:04:53 +0200
Message-Id: <1412197494-7655-3-git-send-email-hch@lst.de>
In-Reply-To: <1412197494-7655-1-git-send-email-hch@lst.de>
References: <1412197494-7655-1-git-send-email-hch@lst.de>
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
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Clean up the generic_write_sync by just passing an iocb and a bytes
written / negative errno argument.  In addition to simplifying the
callers this also prepares for passing a per-operation O_DSYNC
flag.  Two callers didn't quite fit that scheme:

 - dio_complete didn't both to update ki_pos as we don't need it
   on a iocb that is about to be freed, so we had to add it. Additionally
   it also synced out written data in the error case, which has been
   changed to operate like the other callers.
 - gfs2 also used generic_write_sync to implement a crude version
   of fallocate.  It has been switched to use an open coded variant
   instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c     |  8 +-------
 fs/btrfs/file.c    |  7 ++-----
 fs/cifs/file.c     |  8 +-------
 fs/direct-io.c     |  8 ++------
 fs/ext4/file.c     |  8 +-------
 fs/gfs2/file.c     |  9 +++++++--
 fs/ntfs/file.c     |  8 ++------
 fs/udf/file.c      | 11 ++---------
 fs/xfs/xfs_file.c  |  8 +-------
 include/linux/fs.h |  8 +-------
 mm/filemap.c       | 30 ++++++++++++++++++++----------
 11 files changed, 40 insertions(+), 73 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6d72746..79ed323 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1574,18 +1574,12 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
  */
 ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
-	struct file *file = iocb->ki_filp;
 	struct blk_plug plug;
 	ssize_t ret;
 
 	blk_start_plug(&plug);
 	ret = __generic_file_write_iter(iocb, from);
-	if (ret > 0) {
-		ssize_t err;
-		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
-		if (err < 0)
-			ret = err;
-	}
+	ret = generic_write_sync(iocb, ret);
 	blk_finish_plug(&plug);
 	return ret;
 }
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ff1cc03..e77f599 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1823,11 +1823,8 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	 */
 	BTRFS_I(inode)->last_trans = root->fs_info->generation + 1;
 	BTRFS_I(inode)->last_sub_trans = root->log_transid;
-	if (num_written > 0) {
-		err = generic_write_sync(file, pos, num_written);
-		if (err < 0)
-			num_written = err;
-	}
+
+	num_written = generic_write_sync(iocb, num_written);
 
 	if (sync)
 		atomic_dec(&BTRFS_I(inode)->sync_writers);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e7169ba..2dca0da 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2706,13 +2706,7 @@ cifs_writev(struct kiocb *iocb, struct iov_iter *from)
 		rc = __generic_file_write_iter(iocb, from);
 		mutex_unlock(&inode->i_mutex);
 
-		if (rc > 0) {
-			ssize_t err;
-
-			err = generic_write_sync(file, iocb->ki_pos - rc, rc);
-			if (err < 0)
-				rc = err;
-		}
+		rc = generic_write_sync(iocb, rc);
 	} else {
 		mutex_unlock(&inode->i_mutex);
 	}
diff --git a/fs/direct-io.c b/fs/direct-io.c
index e181b6b..b72ac83 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -257,12 +257,8 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
 	inode_dio_done(dio->inode);
 	if (is_async) {
 		if (dio->rw & WRITE) {
-			int err;
-
-			err = generic_write_sync(dio->iocb->ki_filp, offset,
-						 transferred);
-			if (err < 0 && ret > 0)
-				ret = err;
+			dio->iocb->ki_pos = offset + transferred;
+			ret = generic_write_sync(dio->iocb, ret);
 		}
 
 		aio_complete(dio->iocb, ret, 0);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index aca7b24..79b000c 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -175,13 +175,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ret = __generic_file_write_iter(iocb, from);
 	mutex_unlock(&inode->i_mutex);
 
-	if (ret > 0) {
-		ssize_t err;
-
-		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
-		if (err < 0)
-			ret = err;
-	}
+	ret = generic_write_sync(iocb, ret);
 	if (o_direct)
 		blk_finish_plug(&plug);
 
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 7f4ed3d..34e3d36 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -895,8 +895,13 @@ retry:
 		gfs2_quota_unlock(ip);
 	}
 
-	if (error == 0)
-		error = generic_write_sync(file, pos, count);
+	if (error)
+		goto out_unlock;
+
+	if ((file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host)) {
+		error = vfs_fsync_range(file, pos, pos + count - 1,
+			       (file->f_flags & __O_SYNC) ? 0 : 1);
+	}
 	goto out_unlock;
 
 out_trans_fail:
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index f5ec1ce..eaf2ce6 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2126,12 +2126,8 @@ static ssize_t ntfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	mutex_lock(&inode->i_mutex);
 	ret = ntfs_file_aio_write_nolock(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
-	if (ret > 0) {
-		int err = generic_write_sync(file, iocb->ki_pos - ret, ret);
-		if (err < 0)
-			ret = err;
-	}
-	return ret;
+
+	return generic_write_sync(iocb, ret);
 }
 
 /**
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 86c6743..9fe6bb1 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -155,16 +155,9 @@ static ssize_t udf_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	retval = __generic_file_write_iter(iocb, from);
 	mutex_unlock(&inode->i_mutex);
 
-	if (retval > 0) {
-		ssize_t err;
-
+	if (retval > 0)
 		mark_inode_dirty(inode);
-		err = generic_write_sync(file, iocb->ki_pos - retval, retval);
-		if (err < 0)
-			retval = err;
-	}
-
-	return retval;
+	return generic_write_sync(iocb, retval);
 }
 
 long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f9efffc..986965a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -790,14 +790,8 @@ xfs_file_write_iter(
 		ret = xfs_file_buffered_aio_write(iocb, from);
 
 	if (ret > 0) {
-		ssize_t err;
-
 		XFS_STATS_ADD(xs_write_bytes, ret);
-
-		/* Handle various SYNC-type writes */
-		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
-		if (err < 0)
-			ret = err;
+		ret = generic_write_sync(iocb, ret);
 	}
 	return ret;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b884975..cf759fa 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2259,13 +2259,7 @@ extern int filemap_fdatawrite_range(struct address_space *mapping,
 extern int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
 			   int datasync);
 extern int vfs_fsync(struct file *file, int datasync);
-static inline int generic_write_sync(struct file *file, loff_t pos, loff_t count)
-{
-	if (!(file->f_flags & O_DSYNC) && !IS_SYNC(file->f_mapping->host))
-		return 0;
-	return vfs_fsync_range(file, pos, pos + count - 1,
-			       (file->f_flags & __O_SYNC) ? 0 : 1);
-}
+extern int generic_write_sync(struct kiocb *iocb, loff_t count);
 extern void emergency_sync(void);
 extern void emergency_remount(void);
 #ifdef CONFIG_BLOCK
diff --git a/mm/filemap.c b/mm/filemap.c
index 86ed6f7..f9ffb6f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2654,6 +2654,24 @@ out:
 }
 EXPORT_SYMBOL(__generic_file_write_iter);
 
+int generic_write_sync(struct kiocb *iocb, loff_t count)
+{
+	struct file *file = iocb->ki_filp;
+
+	if (count > 0 &&
+	    ((file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host))) {
+	    	bool fdatasync = !(file->f_flags & __O_SYNC);
+		ssize_t ret = 0;
+
+		ret = vfs_fsync_range(file, iocb->ki_pos - count,
+				iocb->ki_pos - 1, fdatasync);
+		if (ret < 0)
+			return ret;
+	}
+	return count;
+}
+EXPORT_SYMBOL(generic_write_sync);
+
 /**
  * generic_file_write_iter - write data to a file
  * @iocb:	IO state structure
@@ -2665,22 +2683,14 @@ EXPORT_SYMBOL(__generic_file_write_iter);
  */
 ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
 	ssize_t ret;
 
 	mutex_lock(&inode->i_mutex);
 	ret = __generic_file_write_iter(iocb, from);
 	mutex_unlock(&inode->i_mutex);
 
-	if (ret > 0) {
-		ssize_t err;
-
-		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
-		if (err < 0)
-			ret = err;
-	}
-	return ret;
+	return generic_write_sync(iocb, ret);
 }
 EXPORT_SYMBOL(generic_file_write_iter);
 
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
