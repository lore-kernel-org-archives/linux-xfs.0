Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TM5LVV198885 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 17:05:22 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GpQxtvBiWbEYGHv5 for
	<xfs@oss.sgi.com>; Thu, 29 Mar 2012 15:05:20 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 1/7] vfs: Handle O_SYNC AIO DIO in generic code properly
Date: Thu, 29 Mar 2012 18:04:59 -0400
Message-Id: <1333058705-31512-2-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
References: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

From: Jan Kara <jack@suse.cz>

Provide VFS helpers for handling O_SYNC AIO DIO writes. Filesystem wanting to
use the helpers has to pass DIO_SYNC_WRITES to __blockdev_direct_IO. Then if
they don't use direct IO end_io handler, generic code takes care of everything
else. Otherwise their end_io handler is passed struct dio_sync_io_work pointer
as 'private' argument and they have to call generic_dio_end_io() to finish
their AIO DIO. Generic code then takes care to call generic_write_sync() from
a workqueue context when AIO DIO is completed.

Since all filesystems using blockdev_direct_IO() need O_SYNC aio dio handling
and the generic one is enough for them, make blockdev_direct_IO() pass
DIO_SYNC_WRITES flag.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/direct-io.c     |  128 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/super.c         |    2 +
 include/linux/fs.h |   13 +++++-
 3 files changed, 138 insertions(+), 5 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index f4aadd1..15aa177 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -38,6 +38,8 @@
 #include <linux/atomic.h>
 #include <linux/prefetch.h>
 
+#include <asm/cmpxchg.h>
+
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
  * the size of a structure in the slab cache
@@ -112,6 +114,15 @@ struct dio_submit {
 	unsigned tail;			/* last valid page + 1 */
 };
 
+/* state needed for final sync and completion of O_SYNC AIO DIO */
+struct dio_sync_io_work {
+	struct kiocb *iocb;
+	loff_t offset;
+	ssize_t len;
+	int ret;
+	struct work_struct work;
+};
+
 /* dio_state communicated between submission path and end_io */
 struct dio {
 	int flags;			/* doesn't change */
@@ -134,6 +145,7 @@ struct dio {
 	/* AIO related stuff */
 	struct kiocb *iocb;		/* kiocb */
 	ssize_t result;                 /* IO result */
+	struct dio_sync_io_work *sync_work;	/* work used for O_SYNC AIO */
 
 	/*
 	 * pages[] (and any fields placed after it) are not zeroed out at
@@ -261,6 +273,45 @@ static inline struct page *dio_get_page(struct dio *dio,
 }
 
 /**
+ * generic_dio_end_io() - generic dio ->end_io handler
+ * @iocb: iocb of finishing DIO
+ * @offset: the byte offset in the file of the completed operation
+ * @bytes: length of the completed operation
+ * @work: work to queue for O_SYNC AIO DIO, NULL otherwise
+ * @ret: error code if IO failed
+ * @is_async: is this AIO?
+ *
+ * This is generic callback to be called when direct IO is finished. It
+ * handles update of number of outstanding DIOs for an inode, completion
+ * of async iocb and queueing of work if we need to call fsync() because
+ * io was O_SYNC.
+ */
+void generic_dio_end_io(struct kiocb *iocb, loff_t offset, ssize_t bytes,
+			struct dio_sync_io_work *work, int ret, bool is_async)
+{
+	struct inode *inode = iocb->ki_filp->f_dentry->d_inode;
+
+	if (!is_async) {
+		inode_dio_done(inode);
+		return;
+	}
+
+	/*
+	 * If we need to sync file, we offload completion to workqueue
+	 */
+	if (work) {
+		work->ret = ret;
+		work->offset = offset;
+		work->len = bytes;
+		queue_work(inode->i_sb->s_dio_flush_wq, &work->work);
+	} else {
+		aio_complete(iocb, ret, 0);
+		inode_dio_done(inode);
+	}
+}
+EXPORT_SYMBOL(generic_dio_end_io);
+
+/**
  * dio_complete() - called when all DIO BIO I/O has been completed
  * @offset: the byte offset in the file of the completed operation
  *
@@ -302,12 +353,22 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is
 		ret = transferred;
 
 	if (dio->end_io && dio->result) {
+		void *private;
+
+		if (dio->sync_work)
+			private = dio->sync_work;
+		else
+			private = dio->private;
 		dio->end_io(dio->iocb, offset, transferred,
-			    dio->private, ret, is_async);
+			    private, ret, is_async);
 	} else {
-		if (is_async)
-			aio_complete(dio->iocb, ret, 0);
-		inode_dio_done(dio->inode);
+		/* No IO submitted? Skip syncing... */
+		if (!dio->result && dio->sync_work) {
+			kfree(dio->sync_work);
+			dio->sync_work = NULL;
+		}
+		generic_dio_end_io(dio->iocb, offset, transferred,
+				   dio->sync_work, ret, is_async);
 	}
 
 	return ret;
@@ -1064,6 +1125,41 @@ static inline int drop_refcount(struct dio *dio)
 }
 
 /*
+ * Work performed from workqueue when AIO DIO is finished.
+ */
+static void dio_aio_sync_work(struct work_struct *work)
+{
+	struct dio_sync_io_work *sync_work =
+			container_of(work, struct dio_sync_io_work, work);
+	struct kiocb *iocb = sync_work->iocb;
+	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
+	int err, ret = sync_work->ret;
+
+	err = generic_write_sync(iocb->ki_filp, sync_work->offset,
+				 sync_work->len);
+	if (err < 0 && ret > 0)
+		ret = err;
+	aio_complete(iocb, ret, 0);
+	inode_dio_done(inode);
+}
+
+static noinline int dio_create_flush_wq(struct super_block *sb)
+{
+	struct workqueue_struct *wq =
+				alloc_workqueue("dio-sync", WQ_UNBOUND, 1);
+
+	if (!wq)
+		return -ENOMEM;
+	/*
+	 * Atomically put workqueue in place. Release our one in case someone
+	 * else won the race and attached workqueue to superblock.
+	 */
+	if (cmpxchg(&sb->s_dio_flush_wq, NULL, wq))
+		destroy_workqueue(wq);
+	return 0;
+}
+
+/*
  * This is a library function for use by filesystem drivers.
  *
  * The locking rules are governed by the flags parameter:
@@ -1155,6 +1251,26 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	memset(dio, 0, offsetof(struct dio, pages));
 
 	dio->flags = flags;
+	if (flags & DIO_SYNC_WRITES && rw & WRITE &&
+	    ((iocb->ki_filp->f_flags & O_DSYNC) || IS_SYNC(inode))) {
+		/* The first O_SYNC AIO DIO for this FS? Create workqueue... */
+		if (!inode->i_sb->s_dio_flush_wq) {
+			retval = dio_create_flush_wq(inode->i_sb);
+			if (retval) {
+				kmem_cache_free(dio_cache, dio);
+				goto out;
+			}
+		}
+		dio->sync_work = kmalloc(sizeof(struct dio_sync_io_work),
+					 GFP_KERNEL);
+		if (!dio->sync_work) {
+			retval = -ENOMEM;
+			kmem_cache_free(dio_cache, dio);
+			goto out;
+		}
+		INIT_WORK(&dio->sync_work->work, dio_aio_sync_work);
+		dio->sync_work->iocb = iocb;
+	}
 	if (dio->flags & DIO_LOCKING) {
 		if (rw == READ) {
 			struct address_space *mapping =
@@ -1167,6 +1283,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 							      end - 1);
 			if (retval) {
 				mutex_unlock(&inode->i_mutex);
+				kfree(dio->sync_work);
 				kmem_cache_free(dio_cache, dio);
 				goto out;
 			}
@@ -1310,6 +1427,9 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 
 	if (drop_refcount(dio) == 0) {
 		retval = dio_complete(dio, offset, retval, false);
+		/* Test for !NULL to save a call for common case */
+		if (dio->sync_work)
+			kfree(dio->sync_work);
 		kmem_cache_free(dio_cache, dio);
 	} else
 		BUG_ON(retval != -EIOCBQUEUED);
diff --git a/fs/super.c b/fs/super.c
index cf00177..56b3803 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -201,6 +201,8 @@ static inline void destroy_super(struct super_block *s)
 #ifdef CONFIG_SMP
 	free_percpu(s->s_files);
 #endif
+	if (s->s_dio_flush_wq)
+		destroy_workqueue(s->s_dio_flush_wq);
 	security_sb_free(s);
 	WARN_ON(!list_empty(&s->s_mounts));
 	kfree(s->s_subtype);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c437f91..7af9dd4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -413,6 +413,7 @@ struct kstatfs;
 struct vm_area_struct;
 struct vfsmount;
 struct cred;
+struct workqueue_struct;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -1498,6 +1499,9 @@ struct super_block {
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
+
+	/* Pending fsync calls for completed AIO DIO with O_SYNC */
+	struct workqueue_struct	*s_dio_flush_wq;
 };
 
 /* superblock cache pruning functions */
@@ -2420,11 +2424,18 @@ enum {
 
 	/* filesystem does not support filling holes */
 	DIO_SKIP_HOLES	= 0x02,
+
+	/* need generic handling of O_SYNC aio writes */
+	DIO_SYNC_WRITES = 0x04
 };
 
+struct dio_sync_io_work;
+
 void dio_end_io(struct bio *bio, int error);
 void inode_dio_wait(struct inode *inode);
 void inode_dio_done(struct inode *inode);
+void generic_dio_end_io(struct kiocb *iocb, loff_t offset, ssize_t bytes,
+                        struct dio_sync_io_work *work, int ret, bool is_async);
 
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset,
@@ -2437,7 +2448,7 @@ static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
 {
 	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
 				    offset, nr_segs, get_block, NULL, NULL,
-				    DIO_LOCKING | DIO_SKIP_HOLES);
+				    DIO_LOCKING | DIO_SKIP_HOLES | DIO_SYNC_WRITES);
 }
 #else
 static inline void inode_dio_wait(struct inode *inode)
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
