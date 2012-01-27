Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RLFuWP253298 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 15:15:56 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Brow9YXJvdnyMxfN for
	<xfs@oss.sgi.com>; Fri, 27 Jan 2012 13:15:54 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 2/3] ext4: honor the O_SYNC flag for aysnchronous direct I/O
	requests
Date: Fri, 27 Jan 2012 16:15:48 -0500
Message-Id: <1327698949-12616-3-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
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
To: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
Cc: Jeff Moyer <jmoyer@redhat.com>

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
 fs/ext4/ext4.h    |    4 ++++
 fs/ext4/inode.c   |   11 +++++++++--
 fs/ext4/page-io.c |   39 ++++++++++++++++++++++++++++++++-------
 fs/ext4/super.c   |   11 +++++++++++
 4 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2d55d7c..4377ed3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -185,6 +185,7 @@ struct mpage_da_data {
 #define EXT4_IO_END_ERROR	0x0002
 #define EXT4_IO_END_QUEUED	0x0004
 #define EXT4_IO_END_DIRECT	0x0008
+#define EXT4_IO_END_NEEDS_SYNC	0x0010
 
 struct ext4_io_page {
 	struct page	*p_page;
@@ -1247,6 +1248,9 @@ struct ext4_sb_info {
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
index 9e1b8eb..d07cd40 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -98,15 +98,40 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
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
+	}
+
+	/*
+	 * This function has two callers.  The first is the end_io_work
+	 * routine just below.  This is an asynchronous completion context.
+	 * The second is in the fsync path.  For the latter path, we can't
+	 * return from here until the job is done.  Hence, we issue a
+	 * blocking blkdev_issue_flush call.
+	 */
+	if (io->flag & EXT4_IO_END_NEEDS_SYNC) {
+		/*
+		 * Ideally, we'd like to know if the force_commit routine
+		 * actually did send something to disk.  If it didn't,
+		 * then we need to issue the cache flush by hand.  For now,
+		 * play it safe and do both.
+		 */
+		ret = ext4_force_commit(inode->i_sb);
+		if (ret)
+			goto endio;
+		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);
 	}
 
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
