Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0832A7F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 17:02:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E7CCB8F807A
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 15:02:38 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ByCPMuFETzROmuRl for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 15:02:37 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] direct-io: Handle O_(D)SYNC AIO
Date: Thu, 11 Jul 2013 00:02:19 +0200
Message-Id: <1373493739-2243-2-git-send-email-jack@suse.cz>
In-Reply-To: <1373493739-2243-1-git-send-email-jack@suse.cz>
References: <1373493739-2243-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@infradead.org>

Call generic_write_sync() from the deferred I/O completion handler if
O_DSYNC is set for a write request.  Also make sure various callers
don't call generic_write_sync if the direct I/O code returns
-EIOCBQUEUED.

Based on an earlier patch from Jan Kara <jack@suse.cz> with updates from
Jeff Moyer <jmoyer@redhat.com> and Darrick J. Wong <darrick.wong@oracle.com>.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/block_dev.c  |  2 +-
 fs/btrfs/file.c |  2 +-
 fs/cifs/file.c  |  2 +-
 fs/direct-io.c  | 21 ++++++++++++++++++++-
 fs/ext4/file.c  |  2 +-
 mm/filemap.c    |  2 +-
 6 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index bb43ce0..a884054 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1512,7 +1512,7 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	blk_start_plug(&plug);
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
-	if (ret > 0 || ret == -EIOCBQUEUED) {
+	if (ret > 0) {
 		ssize_t err;
 
 		err = generic_write_sync(file, pos, ret);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 89da56a..6eb61da 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1610,7 +1610,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	 */
 	BTRFS_I(inode)->last_trans = root->fs_info->generation + 1;
 	BTRFS_I(inode)->last_sub_trans = root->log_transid;
-	if (num_written > 0 || num_written == -EIOCBQUEUED) {
+	if (num_written > 0) {
 		err = generic_write_sync(file, pos, num_written);
 		if (err < 0 && num_written > 0)
 			num_written = err;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 91d8629..275ab19 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2530,7 +2530,7 @@ cifs_writev(struct kiocb *iocb, const struct iovec *iov,
 		mutex_unlock(&inode->i_mutex);
 	}
 
-	if (rc > 0 || rc == -EIOCBQUEUED) {
+	if (rc > 0) {
 		ssize_t err;
 
 		err = generic_write_sync(file, pos, rc);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 36bddad..fe8562e 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -266,8 +266,18 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
 		dio->end_io(dio->iocb, offset, transferred, dio->private);
 
 	inode_dio_done(dio->inode);
-	if (is_async)
+	if (is_async) {
+		if (dio->rw & WRITE) {
+			int err;
+
+			err = generic_write_sync(dio->iocb->ki_filp, offset,
+						 transferred);
+			if (err < 0 && ret > 0)
+				ret = err;
+		}
+
 		aio_complete(dio->iocb, ret, 0);
+	}
 
 	kmem_cache_free(dio_cache, dio);
 	return ret;
@@ -1161,6 +1171,15 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	dio->is_async = !is_sync_kiocb(iocb) && !((rw & WRITE) &&
 		(end > i_size_read(inode)));
 
+	/*
+	 * For AIO O_(D)SYNC writes we need to defer completions to a workqueue
+	 * so that we can call ->fsync.
+	 */
+	if (dio->is_async && (rw & WRITE) &&
+	    ((iocb->ki_filp->f_flags & O_DSYNC) ||
+	     IS_SYNC(iocb->ki_filp->f_mapping->host)))
+		dio->defer_completion = true;
+
 	retval = 0;
 
 	dio->inode = inode;
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 6f4cc56..bb9efc0 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -149,7 +149,7 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 
-	if (ret > 0 || ret == -EIOCBQUEUED) {
+	if (ret > 0) {
 		ssize_t err;
 
 		err = generic_write_sync(file, pos, ret);
diff --git a/mm/filemap.c b/mm/filemap.c
index 7905fe7..928572e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2550,7 +2550,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 
-	if (ret > 0 || ret == -EIOCBQUEUED) {
+	if (ret > 0) {
 		ssize_t err;
 
 		err = generic_write_sync(file, pos, ret);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
