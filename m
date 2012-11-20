Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK7des3121126 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 01:39:40 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id D32j8e7YU0I5FkSk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Nov 2012 23:41:49 -0800 (PST)
Subject: [PATCH 2/9] ext4: honor the O_SYNC flag for aysnchronous direct I/O
	requests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 19 Nov 2012 23:41:31 -0800
Message-ID: <20121120074131.24645.38489.stgit@blackbox.djwong.org>
In-Reply-To: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com, jmoyer@redhat.com, bpm@sgi.com, viro@zeniv.linux.org.uk, jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

If a file is opened with O_SYNC|O_DIRECT, the drive cache does not get
flushed after the write completion.  Instead, it's flushed *before* the
I/O is sent to the disk (in __generic_file_aio_write).  This patch
attempts to fix that problem by marking an I/O as requiring a cache
flush in endio processing.  I'll send a follow-on patch to the
generic write code to get rid of the bogus generic_write_sync call
when EIOCBQUEUED is returned.

From: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
[darrick.wong@oracle.com: Rework original patch to reflect a subsequent
			  ext4 reorganization]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ext4.h    |    9 +++++
 fs/ext4/file.c    |    2 +
 fs/ext4/inode.c   |    6 +++
 fs/ext4/page-io.c |   92 +++++++++++++++++++++++++++++++++++++++++++++--------
 fs/ext4/super.c   |   13 +++++++
 5 files changed, 106 insertions(+), 16 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3c20de1..f5a0b89 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -186,6 +186,7 @@ struct mpage_da_data {
 #define EXT4_IO_END_ERROR	0x0002
 #define EXT4_IO_END_QUEUED	0x0004
 #define EXT4_IO_END_DIRECT	0x0008
+#define EXT4_IO_END_NEEDS_SYNC	0x0010
 
 struct ext4_io_page {
 	struct page	*p_page;
@@ -1279,6 +1280,9 @@ struct ext4_sb_info {
 	/* workqueue for dio unwritten */
 	struct workqueue_struct *dio_unwritten_wq;
 
+	/* workqueue for aio+dio+o_sync disk cache flushing */
+	struct workqueue_struct *aio_dio_flush_wq;
+
 	/* timer for periodic error stats printing */
 	struct timer_list s_err_report;
 
@@ -1335,6 +1339,11 @@ static inline void ext4_set_io_unwritten_flag(struct inode *inode,
 	}
 }
 
+static inline int ext4_io_end_deferred(ext4_io_end_t *i)
+{
+	return i->flag & (EXT4_IO_END_UNWRITTEN | EXT4_IO_END_NEEDS_SYNC);
+}
+
 static inline ext4_io_end_t *ext4_inode_aio(struct inode *inode)
 {
 	return inode->i_private;
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index bf3966b..dd34b81 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -155,7 +155,7 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 
-	if (ret > 0 || ret == -EIOCBQUEUED) {
+	if (ret > 0) {
 		ssize_t err;
 
 		err = generic_write_sync(file, pos, ret);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b3c243b..fc4f05e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2893,8 +2893,12 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 
 	iocb->private = NULL;
 
+	/* AIO+DIO+O_SYNC I/Os need a cache flush after completion */
+	if (is_async && (IS_SYNC(inode) || (iocb->ki_filp->f_flags & O_DSYNC)))
+		io_end->flag |= EXT4_IO_END_NEEDS_SYNC;
+
 	/* if not aio dio with unwritten extents, just free io and return */
-	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
+	if (!ext4_io_end_deferred(io_end)) {
 		ext4_free_io_end(io_end);
 out:
 		if (is_async)
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 68e896e..cda013a 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -84,6 +84,50 @@ void ext4_free_io_end(ext4_io_end_t *io)
 	kmem_cache_free(io_end_cachep, io);
 }
 
+/*
+ * This function is called in the completion path for AIO O_SYNC|O_DIRECT
+ * writes, and also in the fsync path.  The purpose is to ensure that the
+ * disk caches for the journal and data devices are flushed.
+ */
+static int ext4_end_io_do_flush(ext4_io_end_t *io)
+{
+	struct inode *inode = io->inode;
+	tid_t commit_tid;
+	bool needs_barrier = false;
+	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	int barriers_enabled = test_opt(inode->i_sb, BARRIER);
+	int ret = 0;
+
+	if (!barriers_enabled)
+		return 0;
+
+	/*
+	 * If we are running in nojournal mode, just flush the disk
+	 * cache and return.
+	 */
+	if (!journal)
+		return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);
+
+	if (ext4_should_journal_data(inode)) {
+		ret = ext4_force_commit(inode->i_sb);
+		goto out;
+	}
+
+	commit_tid = io->iocb->ki_filp->f_flags & __O_SYNC ?
+		EXT4_I(inode)->i_sync_tid : EXT4_I(inode)->i_datasync_tid;
+	if (!jbd2_trans_will_send_data_barrier(journal, commit_tid))
+		needs_barrier = true;
+
+	jbd2_log_start_commit(journal, commit_tid);
+	ret = jbd2_log_wait_commit(journal, commit_tid);
+
+	if (!ret && needs_barrier)
+		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);
+
+out:
+	return ret;
+}
+
 /* check a range of space and convert unwritten extents to written. */
 static int ext4_end_io(ext4_io_end_t *io)
 {
@@ -96,21 +140,37 @@ static int ext4_end_io(ext4_io_end_t *io)
 		   "list->prev 0x%p\n",
 		   io, inode->i_ino, io->list.next, io->list.prev);
 
-	ret = ext4_convert_unwritten_extents(inode, offset, size);
-	if (ret < 0) {
-		ext4_msg(inode->i_sb, KERN_EMERG,
-			 "failed to convert unwritten extents to written "
-			 "extents -- potential data loss!  "
-			 "(inode %lu, offset %llu, size %zd, error %d)",
-			 inode->i_ino, offset, size, ret);
+	if (io->flag & EXT4_IO_END_UNWRITTEN) {
+		ret = ext4_convert_unwritten_extents(inode, offset, size);
+		if (ret < 0) {
+			ext4_msg(inode->i_sb, KERN_EMERG,
+				 "failed to convert unwritten extents to "
+				 "written extents -- potential data loss!  "
+				 "(inode %lu, offset %llu, size %zd, error %d)",
+				 inode->i_ino, offset, size, ret);
+			goto endio;
+		}
 	}
+
+	/*
+	 * This function has two callers.  The first is the end_io_work
+	 * routine just below, which is an asynchronous completion context.
+	 * The second is in the fsync path.  For the latter path, we can't
+	 * return from here until the job is done.  Hence,
+	 * ext4_end_io_do_flush is blocking.
+	 */
+	if (io->flag & EXT4_IO_END_NEEDS_SYNC)
+		ret = ext4_end_io_do_flush(io);
+
+endio:
 	if (io->iocb)
 		aio_complete(io->iocb, io->result, 0);
 
 	if (io->flag & EXT4_IO_END_DIRECT)
 		inode_dio_done(inode);
 	/* Wake up anyone waiting on unwritten extent conversion */
-	if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
+	if (io->flag & EXT4_IO_END_UNWRITTEN &&
+	    atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
 		wake_up_all(ext4_ioend_wq(io->inode));
 	return ret;
 }
@@ -149,8 +209,11 @@ void ext4_add_complete_io(ext4_io_end_t *io_end)
 	struct workqueue_struct *wq;
 	unsigned long flags;
 
-	BUG_ON(!(io_end->flag & EXT4_IO_END_UNWRITTEN));
-	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
+	BUG_ON(!ext4_io_end_deferred(io_end));
+	if (io_end->flag & EXT4_IO_END_UNWRITTEN)
+		wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
+	else
+		wq = EXT4_SB(io_end->inode->i_sb)->aio_dio_flush_wq;
 
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	if (list_empty(&ei->i_completed_io_list)) {
@@ -180,7 +243,7 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
 
 	while (!list_empty(&unwritten)) {
 		io = list_entry(unwritten.next, ext4_io_end_t, list);
-		BUG_ON(!(io->flag & EXT4_IO_END_UNWRITTEN));
+		BUG_ON(!ext4_io_end_deferred(io));
 		list_del_init(&io->list);
 
 		err = ext4_end_io(io);
@@ -192,7 +255,8 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	while (!list_empty(&complete)) {
 		io = list_entry(complete.next, ext4_io_end_t, list);
-		io->flag &= ~EXT4_IO_END_UNWRITTEN;
+		io->flag &= ~(EXT4_IO_END_UNWRITTEN |
+			      EXT4_IO_END_NEEDS_SYNC);
 		/* end_io context can not be destroyed now because it still
 		 * used by queued worker. Worker thread will destroy it later */
 		if (io->flag & EXT4_IO_END_QUEUED)
@@ -204,7 +268,7 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
 	 * flag, and destroy it's end_io if it was converted already */
 	if (work_io) {
 		work_io->flag &= ~EXT4_IO_END_QUEUED;
-		if (!(work_io->flag & EXT4_IO_END_UNWRITTEN))
+		if (!ext4_io_end_deferred(work_io))
 			list_add_tail(&work_io->list, &to_free);
 	}
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
@@ -319,7 +383,7 @@ static void ext4_end_bio(struct bio *bio, int error)
 			     bi_sector >> (inode->i_blkbits - 9));
 	}
 
-	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
+	if (!ext4_io_end_deferred(io_end)) {
 		ext4_free_io_end(io_end);
 		return;
 	}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 80928f7..c657c4d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -849,7 +849,9 @@ static void ext4_put_super(struct super_block *sb)
 	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
 
 	flush_workqueue(sbi->dio_unwritten_wq);
+	flush_workqueue(sbi->aio_dio_flush_wq);
 	destroy_workqueue(sbi->dio_unwritten_wq);
+	destroy_workqueue(sbi->aio_dio_flush_wq);
 
 	if (sbi->s_journal) {
 		err = jbd2_journal_destroy(sbi->s_journal);
@@ -3913,6 +3915,14 @@ no_journal:
 		goto failed_mount_wq;
 	}
 
+	EXT4_SB(sb)->aio_dio_flush_wq =
+		alloc_workqueue("ext4-aio-dio-flush",
+				WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
+	if (!EXT4_SB(sb)->aio_dio_flush_wq) {
+		pr_err("EXT4-fs: failed to create flush workqueue\n");
+		goto failed_flush_wq;
+	}
+
 	/*
 	 * The jbd2_journal_load will have done any necessary log recovery,
 	 * so we can safely mount the rest of the filesystem now.
@@ -4045,6 +4055,8 @@ failed_mount4a:
 	sb->s_root = NULL;
 failed_mount4:
 	ext4_msg(sb, KERN_ERR, "mount failed");
+	destroy_workqueue(EXT4_SB(sb)->aio_dio_flush_wq);
+failed_flush_wq:
 	destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
 failed_mount_wq:
 	if (sbi->s_journal) {
@@ -4494,6 +4506,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 
 	trace_ext4_sync_fs(sb, wait);
 	flush_workqueue(sbi->dio_unwritten_wq);
+	flush_workqueue(sbi->aio_dio_flush_wq);
 	/*
 	 * Writeback quota in non-journalled quota case - journalled quota has
 	 * no dirty dquots

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
