Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22Jud4g138301 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 13:56:39 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ujkmVErPPyG73Wkk for
	<xfs@oss.sgi.com>; Fri, 02 Mar 2012 11:56:38 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 6/7] ext4: honor the O_SYNC flag for aysnchronous direct I/O
	requests
Date: Fri,  2 Mar 2012 14:56:14 -0500
Message-Id: <1330718175-21540-7-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1330718175-21540-1-git-send-email-jmoyer@redhat.com>
References: <1330718175-21540-1-git-send-email-jmoyer@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
Cc: hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>, jack@suse.cz

Hi,

If a file is opened with O_SYNC|O_DIRECT, the drive cache does not get
flushed after the write completion.  Instead, it's flushed *before* the
I/O is sent to the disk (in __generic_file_aio_write).  This patch
attempts to fix that problem by marking an I/O as requiring a cache
flush in endio processing.  I'll send a follow-on patch to the
generic write code to get rid of the bogus generic_write_sync call
when EIOCBQUEUED is returned.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/ext4/ext4.h    |    4 +++
 fs/ext4/inode.c   |   11 ++++++-
 fs/ext4/page-io.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/ext4/super.c   |   11 ++++++++
 4 files changed, 90 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3ce6a0c..e1478be 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -186,6 +186,7 @@ struct mpage_da_data {
 #define EXT4_IO_END_QUEUED	0x0004
 #define EXT4_IO_END_DIRECT	0x0008
 #define EXT4_IO_END_IN_FSYNC	0x0010
+#define EXT4_IO_END_NEEDS_SYNC	0x0020
 
 struct ext4_io_page {
 	struct page	*p_page;
@@ -1248,6 +1249,9 @@ struct ext4_sb_info {
 	/* workqueue for dio unwritten */
 	struct workqueue_struct *dio_unwritten_wq;
 
+	/* workqueue for aio+dio+o_sync disk cache flushing */
+	struct workqueue_struct *aio_dio_flush_wq;
+
 	/* timer for periodic error stats printing */
 	struct timer_list s_err_report;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f6dc02b..13cdb4c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2769,8 +2769,12 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 
 	iocb->private = NULL;
 
+	/* AIO+DIO+O_SYNC I/Os need a cache flush after completion */
+	if (is_async && (IS_SYNC(inode) || (iocb->ki_filp->f_flags & O_DSYNC)))
+		io_end->flag |= EXT4_IO_END_NEEDS_SYNC;
+
 	/* if not aio dio with unwritten extents, just free io and return */
-	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
+	if (!(io_end->flag & (EXT4_IO_END_UNWRITTEN|EXT4_IO_END_NEEDS_SYNC))) {
 		ext4_free_io_end(io_end);
 out:
 		if (is_async)
@@ -2785,7 +2789,10 @@ out:
 		io_end->iocb = iocb;
 		io_end->result = ret;
 	}
-	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
+	if (io_end->flag & EXT4_IO_END_UNWRITTEN)
+		wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
+	else
+		wq = EXT4_SB(io_end->inode->i_sb)->aio_dio_flush_wq;
 
 	/* Add the io_end to per-inode completed aio dio list*/
 	ei = EXT4_I(io_end->inode);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index dcdeef1..baa1b84 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -82,6 +82,50 @@ void ext4_free_io_end(ext4_io_end_t *io)
 }
 
 /*
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
+/*
  * check a range of space and convert unwritten extents to written.
  *
  * Called with inode->i_mutex; we depend on this when we manipulate
@@ -98,15 +142,30 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
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
+
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
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 502c61f..a24938e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -805,6 +805,7 @@ static void ext4_put_super(struct super_block *sb)
 	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
 
 	flush_workqueue(sbi->dio_unwritten_wq);
+	destroy_workqueue(sbi->aio_dio_flush_wq);
 	destroy_workqueue(sbi->dio_unwritten_wq);
 
 	lock_super(sb);
@@ -3718,6 +3719,13 @@ no_journal:
 		goto failed_mount_wq;
 	}
 
+	EXT4_SB(sb)->aio_dio_flush_wq =
+		alloc_workqueue("ext4-aio-dio-flush", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
+	if (!EXT4_SB(sb)->aio_dio_flush_wq) {
+		printk(KERN_ERR "EXT4-fs: failed to create flush workqueue\n");
+		goto failed_flush_wq;
+	}
+
 	/*
 	 * The jbd2_journal_load will have done any necessary log recovery,
 	 * so we can safely mount the rest of the filesystem now.
@@ -3840,6 +3848,8 @@ failed_mount4a:
 	sb->s_root = NULL;
 failed_mount4:
 	ext4_msg(sb, KERN_ERR, "mount failed");
+	destroy_workqueue(EXT4_SB(sb)->aio_dio_flush_wq);
+failed_flush_wq:
 	destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
 failed_mount_wq:
 	if (sbi->s_journal) {
@@ -4303,6 +4313,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 
 	trace_ext4_sync_fs(sb, wait);
 	flush_workqueue(sbi->dio_unwritten_wq);
+	flush_workqueue(sbi->aio_dio_flush_wq);
 	if (jbd2_journal_start_commit(sbi->s_journal, &target)) {
 		if (wait)
 			jbd2_log_wait_commit(sbi->s_journal, target);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
