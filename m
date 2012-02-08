Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q18G9nj4087639 for <xfs@oss.sgi.com>; Wed, 8 Feb 2012 10:09:49 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id x09BsNPAQpJGYcBA (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Feb 2012 08:09:47 -0800 (PST)
Date: Wed, 8 Feb 2012 17:09:45 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] filemap: don't call generic_write_sync for
	-EIOCBQUEUED
Message-ID: <20120208160945.GB1696@quack.suse.cz>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
	<1327698949-12616-4-git-send-email-jmoyer@redhat.com>
	<20120202175219.GB6640@quack.suse.cz>
	<x497gzzrkfa.fsf@segfault.boston.devel.redhat.com>
	<20120206195546.GA22640@infradead.org>
	<x49pqdqml91.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <x49pqdqml91.fsf@segfault.boston.devel.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 07-02-12 15:39:06, Jeff Moyer wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> > On Mon, Feb 06, 2012 at 11:33:29AM -0500, Jeff Moyer wrote:
> >> > code, right? Before that we'd drain the IO queue when cache flush is issued
> >> > and thus effectively wait for IO completion...
> >> 
> >> Right, though hch seems to think even then the problem existed.
> >
> > I was wrong, using -o barrier it didn't.  That was however not something
> > people using O_SYNC heavy production loads would do, they'd use disabled
> > caches and nobarrier.
> >
> >> > Also I was thinking whether we couldn't implement the fix in VFS. Basically
> >> > it would be the same like the fix for ext4. Like having a per-sb workqueue
> >> > and queue work calling generic_write_sync() from end_io handler when the
> >> > file is O_SYNC? That would solve the issue for all filesystems...
> >> 
> >> Well, that would require buy-in from the other file system developers.
> >> What do the XFS folks think?
> >
> > I don't think using that code for XFS makes sene.  But just like
> > generic_write_sync there's no reason it can't be added to generic code,
> > just make sure only generic_file_aio_write/__generic_file_aio_write use
> > it, but generic_file_buffered_write and generic_file_direct_write stay
> > clear of it.
> 
> ext4_file_write (ext4's .aio_write routine) calls into
> generic_file_aio_write.  So, I don't think we can generalize that this
> routine means that the file system doesn't install its own endio
> handler.  What's more, we'd have to pass an endio routine down the call
> stack quite a ways.  In all, I think that would be an uglier solution to
> the problem.  Did I miss something?
  I think it can be done in a relatively elegant way. POC patch (completely
untested) is attached. What do you think? All filesystems using
blockdev_direct_IO() can be easily converted to use this, gfs2 & ocfs2 can
also use the framework. That leaves only ext4, xfs & btrfs which need
special handling. Actually, maybe btrfs could be converted as well because
it doesn't seem to need to offload anything else to workqueue. But I'm not
really sure...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--5mCyUwZo2JvN/JJP
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-vfs-Handle-O_SYNC-aio-dio-in-generic-code-properly.patch"

>From be2a2bdc27f86053a6c7db3f2cfb12b6fc987e52 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 8 Feb 2012 16:56:53 +0100
Subject: [PATCH] vfs: Handle O_SYNC aio dio in generic code properly

Provide VFS helpers for handling O_SYNC aio dio writes. Filesystem wanting
to use the helpers has to initialize s_dio_flush_wq and pass DIO_SYNC_WRITES
to __blockdev_direct_IO. Generic code then takes care to call
generic_write_sync() from a workqueue context when aio dio is completed.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/direct-io.c     |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/super.c         |    2 +
 include/linux/fs.h |   11 ++++++
 3 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 4a588db..03c9028 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -112,6 +112,15 @@ struct dio_submit {
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
@@ -134,6 +143,7 @@ struct dio {
 	/* AIO related stuff */
 	struct kiocb *iocb;		/* kiocb */
 	ssize_t result;                 /* IO result */
+	struct dio_sync_io_work *sync_work;	/* work used for O_SYNC AIO */
 
 	/*
 	 * pages[] (and any fields placed after it) are not zeroed out at
@@ -261,6 +271,44 @@ static inline struct page *dio_get_page(struct dio *dio,
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
+
+/**
  * dio_complete() - called when all DIO BIO I/O has been completed
  * @offset: the byte offset in the file of the completed operation
  *
@@ -305,9 +353,13 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is
 		dio->end_io(dio->iocb, offset, transferred,
 			    dio->private, ret, is_async);
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
@@ -1064,6 +1116,25 @@ static inline int drop_refcount(struct dio *dio)
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
+/*
  * This is a library function for use by filesystem drivers.
  *
  * The locking rules are governed by the flags parameter:
@@ -1155,6 +1226,18 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	memset(dio, 0, offsetof(struct dio, pages));
 
 	dio->flags = flags;
+	if (flags & DIO_SYNC_WRITES && rw & WRITE &&
+	    ((iocb->ki_filp->f_flags & O_DSYNC) || IS_SYNC(inode))) {
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
@@ -1167,6 +1250,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 							      end - 1);
 			if (retval) {
 				mutex_unlock(&inode->i_mutex);
+				kfree(dio->sync_work);
 				kmem_cache_free(dio_cache, dio);
 				goto out;
 			}
@@ -1310,6 +1394,9 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 
 	if (drop_refcount(dio) == 0) {
 		retval = dio_complete(dio, offset, retval, false);
+		/* Test for !NULL to save a call for common case */
+		if (dio->sync_work)
+			kfree(dio->sync_work);
 		kmem_cache_free(dio_cache, dio);
 	} else
 		BUG_ON(retval != -EIOCBQUEUED);
diff --git a/fs/super.c b/fs/super.c
index 6015c02..741784d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -200,6 +200,8 @@ static inline void destroy_super(struct super_block *s)
 #ifdef CONFIG_SMP
 	free_percpu(s->s_files);
 #endif
+	if (s->s_dio_flush_wq)
+		destroy_workqueue(s->s_dio_flush_wq);
 	security_sb_free(s);
 	WARN_ON(!list_empty(&s->s_mounts));
 	kfree(s->s_subtype);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 386da09..910843e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1496,6 +1496,9 @@ struct super_block {
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
+
+	/* Pending fsync calls for completed AIO DIO with O_SYNC */
+	struct workqueue_struct	*s_dio_flush_wq;
 };
 
 /* superblock cache pruning functions */
@@ -2428,12 +2431,20 @@ enum {
 
 	/* filesystem does not support filling holes */
 	DIO_SKIP_HOLES	= 0x02,
+
+	/* need generic handling of O_SYNC aio writes */
+	DIO_SYNC_WRITES = 0x04
 };
 
 void dio_end_io(struct bio *bio, int error);
 void inode_dio_wait(struct inode *inode);
 void inode_dio_done(struct inode *inode);
 
+static inline struct workqueue_struct *alloc_dio_sync_wq(void)
+{
+	return alloc_workqueue("dio-sync", WQ_UNBOUND, 1);
+}
+
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset,
 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-- 
1.7.1


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--5mCyUwZo2JvN/JJP--
