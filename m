Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 29E9A7FB9
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 04:11:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E11298F808F
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 02:11:15 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id uZuzdUpFTEE7JC41 for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 02:11:12 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] direct-io: Implement generic deferred AIO completions
Date: Wed, 14 Aug 2013 11:10:55 +0200
Message-Id: <1376471456-11966-2-git-send-email-jack@suse.cz>
In-Reply-To: <1376471456-11966-1-git-send-email-jack@suse.cz>
References: <1376471456-11966-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@infradead.org>

Add support to the core direct-io code to defer AIO completions to user
context using a workqueue.  This replaces opencoded and less efficient
code in XFS and ext4 (we save a memory allocation for each direct IO)
and will be needed to properly support O_(D)SYNC for AIO.

The communication between the filesystem and the direct I/O code requires
a new buffer head flag, which is a bit ugly but not avoidable until the
direct I/O code stops abusing the buffer_head structure for communicating
with the filesystems.

Currently this creates a per-superblock unbound workqueue for these
completions, which is taken from an earlier patch by Jan Kara.  I'm
not really convinced about this use and would prefer a "normal" global
workqueue with a high concurrency limit, but this needs further discussion.

JK: Fixed ext4 part, dynamic allocation of the workqueue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/direct-io.c              | 85 ++++++++++++++++++++++++++++++++++++---------
 fs/ext4/ext4.h              | 11 ------
 fs/ext4/inode.c             | 28 ++++-----------
 fs/ext4/page-io.c           | 30 ++++------------
 fs/ext4/super.c             | 16 ---------
 fs/ocfs2/aops.c             |  8 +----
 fs/super.c                  | 18 +++++-----
 fs/xfs/xfs_aops.c           | 28 +++------------
 fs/xfs/xfs_aops.h           |  3 --
 include/linux/buffer_head.h |  2 ++
 include/linux/fs.h          |  7 ++--
 11 files changed, 105 insertions(+), 131 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 7ab90f5..8b31b9f 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -127,6 +127,7 @@ struct dio {
 	spinlock_t bio_lock;		/* protects BIO fields below */
 	int page_errors;		/* errno from get_user_pages() */
 	int is_async;			/* is IO async ? */
+	bool defer_completion;		/* defer AIO completion to workqueue? */
 	int io_error;			/* IO error in completion path */
 	unsigned long refcount;		/* direct_io_worker() and bios */
 	struct bio *bio_list;		/* singly linked via bi_private */
@@ -141,7 +142,10 @@ struct dio {
 	 * allocation time.  Don't add new fields after pages[] unless you
 	 * wish that they not be zeroed.
 	 */
-	struct page *pages[DIO_PAGES];	/* page buffer */
+	union {
+		struct page *pages[DIO_PAGES];	/* page buffer */
+		struct work_struct complete_work;/* deferred AIO completion */
+	};
 } ____cacheline_aligned_in_smp;
 
 static struct kmem_cache *dio_cache __read_mostly;
@@ -221,16 +225,16 @@ static inline struct page *dio_get_page(struct dio *dio,
  * dio_complete() - called when all DIO BIO I/O has been completed
  * @offset: the byte offset in the file of the completed operation
  *
- * This releases locks as dictated by the locking type, lets interested parties
- * know that a DIO operation has completed, and calculates the resulting return
- * code for the operation.
+ * This drops i_dio_count, lets interested parties know that a DIO operation
+ * has completed, and calculates the resulting return code for the operation.
  *
  * It lets the filesystem know if it registered an interest earlier via
  * get_block.  Pass the private field of the map buffer_head so that
  * filesystems can use it to hold additional state between get_block calls and
  * dio_complete.
  */
-static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is_async)
+static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
+		bool is_async)
 {
 	ssize_t transferred = 0;
 
@@ -258,19 +262,26 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is
 	if (ret == 0)
 		ret = transferred;
 
-	if (dio->end_io && dio->result) {
-		dio->end_io(dio->iocb, offset, transferred,
-			    dio->private, ret, is_async);
-	} else {
-		inode_dio_done(dio->inode);
-		if (is_async)
-			aio_complete(dio->iocb, ret, 0);
-	}
+	if (dio->end_io && dio->result)
+		dio->end_io(dio->iocb, offset, transferred, dio->private);
+
+	inode_dio_done(dio->inode);
+	if (is_async)
+		aio_complete(dio->iocb, ret, 0);
 
+	kmem_cache_free(dio_cache, dio);
 	return ret;
 }
 
+static void dio_aio_complete_work(struct work_struct *work)
+{
+	struct dio *dio = container_of(work, struct dio, complete_work);
+
+	dio_complete(dio, dio->iocb->ki_pos, 0, true);
+}
+
 static int dio_bio_complete(struct dio *dio, struct bio *bio);
+
 /*
  * Asynchronous IO callback. 
  */
@@ -290,8 +301,13 @@ static void dio_bio_end_aio(struct bio *bio, int error)
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
 	if (remaining == 0) {
-		dio_complete(dio, dio->iocb->ki_pos, 0, true);
-		kmem_cache_free(dio_cache, dio);
+		if (dio->result && dio->defer_completion) {
+			INIT_WORK(&dio->complete_work, dio_aio_complete_work);
+			queue_work(dio->inode->i_sb->s_dio_done_wq,
+				   &dio->complete_work);
+		} else {
+			dio_complete(dio, dio->iocb->ki_pos, 0, true);
+		}
 	}
 }
 
@@ -511,6 +527,41 @@ static inline int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
 }
 
 /*
+ * Create workqueue for deferred direct IO completions. We allocate the
+ * workqueue when it's first needed. This avoids creating workqueue for
+ * filesystems that don't need it and also allows us to create the workqueue
+ * late enough so the we can include s_id in the name of the workqueue.
+ */
+static int sb_init_dio_done_wq(struct super_block *sb)
+{
+	struct workqueue_struct *wq = alloc_workqueue("dio/%s",
+						      WQ_MEM_RECLAIM, 0,
+						      sb->s_id);
+	if (!wq)
+		return -ENOMEM;
+	/*
+	 * This has to be atomic as more DIOs can race to create the workqueue
+	 */
+	cmpxchg(&sb->s_dio_done_wq, NULL, wq);
+	/* Someone created workqueue before us? Free ours... */
+	if (wq != sb->s_dio_done_wq)
+		destroy_workqueue(wq);
+	return 0;
+}
+
+static int dio_set_defer_completion(struct dio *dio)
+{
+	struct super_block *sb = dio->inode->i_sb;
+
+	if (dio->defer_completion)
+		return 0;
+	dio->defer_completion = true;
+	if (!sb->s_dio_done_wq)
+		return sb_init_dio_done_wq(sb);
+	return 0;
+}
+
+/*
  * Call into the fs to map some more disk blocks.  We record the current number
  * of available blocks at sdio->blocks_available.  These are in units of the
  * fs blocksize, (1 << inode->i_blkbits).
@@ -581,6 +632,9 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 
 		/* Store for completion */
 		dio->private = map_bh->b_private;
+
+		if (ret == 0 && buffer_defer_completion(map_bh))
+			ret = dio_set_defer_completion(dio);
 	}
 	return ret;
 }
@@ -1269,7 +1323,6 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 
 	if (drop_refcount(dio) == 0) {
 		retval = dio_complete(dio, offset, retval, false);
-		kmem_cache_free(dio_cache, dio);
 	} else
 		BUG_ON(retval != -EIOCBQUEUED);
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b577e45..bb64697 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -180,7 +180,6 @@ struct ext4_map_blocks {
  * Flags for ext4_io_end->flags
  */
 #define	EXT4_IO_END_UNWRITTEN	0x0001
-#define EXT4_IO_END_DIRECT	0x0002
 
 /*
  * For converting uninitialized extents on a work queue. 'handle' is used for
@@ -196,8 +195,6 @@ typedef struct ext4_io_end {
 	unsigned int		flag;		/* unwritten or not */
 	loff_t			offset;		/* offset in the file */
 	ssize_t			size;		/* size of the extent */
-	struct kiocb		*iocb;		/* iocb struct for AIO */
-	int			result;		/* error value for AIO */
 	atomic_t		count;		/* reference counter */
 } ext4_io_end_t;
 
@@ -900,11 +897,9 @@ struct ext4_inode_info {
 	 * Completed IOs that need unwritten extents handling and don't have
 	 * transaction reserved
 	 */
-	struct list_head i_unrsv_conversion_list;
 	atomic_t i_ioend_count;	/* Number of outstanding io_end structs */
 	atomic_t i_unwritten; /* Nr. of inflight conversions pending */
 	struct work_struct i_rsv_conversion_work;
-	struct work_struct i_unrsv_conversion_work;
 
 	spinlock_t i_block_reservation_lock;
 
@@ -1276,8 +1271,6 @@ struct ext4_sb_info {
 	struct flex_groups *s_flex_groups;
 	ext4_group_t s_flex_groups_allocated;
 
-	/* workqueue for unreserved extent convertions (dio) */
-	struct workqueue_struct *unrsv_conversion_wq;
 	/* workqueue for reserved extent conversions (buffered io) */
 	struct workqueue_struct *rsv_conversion_wq;
 
@@ -1340,9 +1333,6 @@ static inline void ext4_set_io_unwritten_flag(struct inode *inode,
 					      struct ext4_io_end *io_end)
 {
 	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
-		/* Writeback has to have coversion transaction reserved */
-		WARN_ON(EXT4_SB(inode->i_sb)->s_journal && !io_end->handle &&
-			!(io_end->flag & EXT4_IO_END_DIRECT));
 		io_end->flag |= EXT4_IO_END_UNWRITTEN;
 		atomic_inc(&EXT4_I(inode)->i_unwritten);
 	}
@@ -2715,7 +2705,6 @@ extern void ext4_put_io_end_defer(ext4_io_end_t *io_end);
 extern void ext4_io_submit_init(struct ext4_io_submit *io,
 				struct writeback_control *wbc);
 extern void ext4_end_io_rsv_work(struct work_struct *work);
-extern void ext4_end_io_unrsv_work(struct work_struct *work);
 extern void ext4_io_submit(struct ext4_io_submit *io);
 extern int ext4_bio_write_page(struct ext4_io_submit *io,
 			       struct page *page,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dd32a2e..3780ce6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -727,8 +727,12 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
 
 	ret = ext4_map_blocks(handle, inode, &map, flags);
 	if (ret > 0) {
+		ext4_io_end_t *io_end = ext4_inode_aio(inode);
+
 		map_bh(bh, inode->i_sb, map.m_pblk);
 		bh->b_state = (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;
+		if (io_end && io_end->flag & EXT4_IO_END_UNWRITTEN)
+			set_buffer_defer_completion(bh);
 		bh->b_size = inode->i_sb->s_blocksize * map.m_len;
 		ret = 0;
 	}
@@ -2991,19 +2995,13 @@ static int ext4_get_block_write_nolock(struct inode *inode, sector_t iblock,
 }
 
 static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
-			    ssize_t size, void *private, int ret,
-			    bool is_async)
+			    ssize_t size, void *private)
 {
-	struct inode *inode = file_inode(iocb->ki_filp);
         ext4_io_end_t *io_end = iocb->private;
 
 	/* if not async direct IO just return */
-	if (!io_end) {
-		inode_dio_done(inode);
-		if (is_async)
-			aio_complete(iocb, ret, 0);
+	if (!io_end)
 		return;
-	}
 
 	ext_debug("ext4_end_io_dio(): io_end 0x%p "
 		  "for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
@@ -3013,11 +3011,7 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 	iocb->private = NULL;
 	io_end->offset = offset;
 	io_end->size = size;
-	if (is_async) {
-		io_end->iocb = iocb;
-		io_end->result = ret;
-	}
-	ext4_put_io_end_defer(io_end);
+	ext4_put_io_end(io_end);
 }
 
 /*
@@ -3102,7 +3096,6 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 			ret = -ENOMEM;
 			goto retake_lock;
 		}
-		io_end->flag |= EXT4_IO_END_DIRECT;
 		/*
 		 * Grab reference for DIO. Will be dropped in ext4_end_io_dio()
 		 */
@@ -3147,13 +3140,6 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		if (ret <= 0 && ret != -EIOCBQUEUED && iocb->private) {
 			WARN_ON(iocb->private != io_end);
 			WARN_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
-			WARN_ON(io_end->iocb);
-			/*
-			 * Generic code already did inode_dio_done() so we
-			 * have to clear EXT4_IO_END_DIRECT to not do it for
-			 * the second time.
-			 */
-			io_end->flag = 0;
 			ext4_put_io_end(io_end);
 			iocb->private = NULL;
 		}
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 6625d21..d7d0c7b 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -123,10 +123,6 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
 		ext4_finish_bio(bio);
 		bio_put(bio);
 	}
-	if (io_end->flag & EXT4_IO_END_DIRECT)
-		inode_dio_done(io_end->inode);
-	if (io_end->iocb)
-		aio_complete(io_end->iocb, io_end->result, 0);
 	kmem_cache_free(io_end_cachep, io_end);
 }
 
@@ -204,19 +200,14 @@ static void ext4_add_complete_io(ext4_io_end_t *io_end)
 	struct workqueue_struct *wq;
 	unsigned long flags;
 
-	BUG_ON(!(io_end->flag & EXT4_IO_END_UNWRITTEN));
+	/* Only reserved conversions from writeback should enter here */
+	WARN_ON(!(io_end->flag & EXT4_IO_END_UNWRITTEN));
+	WARN_ON(!io_end->handle);
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
-	if (io_end->handle) {
-		wq = EXT4_SB(io_end->inode->i_sb)->rsv_conversion_wq;
-		if (list_empty(&ei->i_rsv_conversion_list))
-			queue_work(wq, &ei->i_rsv_conversion_work);
-		list_add_tail(&io_end->list, &ei->i_rsv_conversion_list);
-	} else {
-		wq = EXT4_SB(io_end->inode->i_sb)->unrsv_conversion_wq;
-		if (list_empty(&ei->i_unrsv_conversion_list))
-			queue_work(wq, &ei->i_unrsv_conversion_work);
-		list_add_tail(&io_end->list, &ei->i_unrsv_conversion_list);
-	}
+	wq = EXT4_SB(io_end->inode->i_sb)->rsv_conversion_wq;
+	if (list_empty(&ei->i_rsv_conversion_list))
+		queue_work(wq, &ei->i_rsv_conversion_work);
+	list_add_tail(&io_end->list, &ei->i_rsv_conversion_list);
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 }
 
@@ -256,13 +247,6 @@ void ext4_end_io_rsv_work(struct work_struct *work)
 	ext4_do_flush_completed_IO(&ei->vfs_inode, &ei->i_rsv_conversion_list);
 }
 
-void ext4_end_io_unrsv_work(struct work_struct *work)
-{
-	struct ext4_inode_info *ei = container_of(work, struct ext4_inode_info,
-						  i_unrsv_conversion_work);
-	ext4_do_flush_completed_IO(&ei->vfs_inode, &ei->i_unrsv_conversion_list);
-}
-
 ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
 {
 	ext4_io_end_t *io = kmem_cache_zalloc(io_end_cachep, flags);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 36b141e..85c034f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -762,9 +762,7 @@ static void ext4_put_super(struct super_block *sb)
 	ext4_unregister_li_request(sb);
 	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
 
-	flush_workqueue(sbi->unrsv_conversion_wq);
 	flush_workqueue(sbi->rsv_conversion_wq);
-	destroy_workqueue(sbi->unrsv_conversion_wq);
 	destroy_workqueue(sbi->rsv_conversion_wq);
 
 	if (sbi->s_journal) {
@@ -875,14 +873,12 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 #endif
 	ei->jinode = NULL;
 	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
-	INIT_LIST_HEAD(&ei->i_unrsv_conversion_list);
 	spin_lock_init(&ei->i_completed_io_lock);
 	ei->i_sync_tid = 0;
 	ei->i_datasync_tid = 0;
 	atomic_set(&ei->i_ioend_count, 0);
 	atomic_set(&ei->i_unwritten, 0);
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
-	INIT_WORK(&ei->i_unrsv_conversion_work, ext4_end_io_unrsv_work);
 
 	return &ei->vfs_inode;
 }
@@ -3954,14 +3950,6 @@ no_journal:
 		goto failed_mount4;
 	}
 
-	EXT4_SB(sb)->unrsv_conversion_wq =
-		alloc_workqueue("ext4-unrsv-conversion", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
-	if (!EXT4_SB(sb)->unrsv_conversion_wq) {
-		printk(KERN_ERR "EXT4-fs: failed to create workqueue\n");
-		ret = -ENOMEM;
-		goto failed_mount4;
-	}
-
 	/*
 	 * The jbd2_journal_load will have done any necessary log recovery,
 	 * so we can safely mount the rest of the filesystem now.
@@ -4115,8 +4103,6 @@ failed_mount4:
 	ext4_msg(sb, KERN_ERR, "mount failed");
 	if (EXT4_SB(sb)->rsv_conversion_wq)
 		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
-	if (EXT4_SB(sb)->unrsv_conversion_wq)
-		destroy_workqueue(EXT4_SB(sb)->unrsv_conversion_wq);
 failed_mount_wq:
 	if (sbi->s_journal) {
 		jbd2_journal_destroy(sbi->s_journal);
@@ -4564,7 +4550,6 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 
 	trace_ext4_sync_fs(sb, wait);
 	flush_workqueue(sbi->rsv_conversion_wq);
-	flush_workqueue(sbi->unrsv_conversion_wq);
 	/*
 	 * Writeback quota in non-journalled quota case - journalled quota has
 	 * no dirty dquots
@@ -4600,7 +4585,6 @@ static int ext4_sync_fs_nojournal(struct super_block *sb, int wait)
 
 	trace_ext4_sync_fs(sb, wait);
 	flush_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
-	flush_workqueue(EXT4_SB(sb)->unrsv_conversion_wq);
 	dquot_writeback_dquots(sb, -1);
 	if (wait && test_opt(sb, BARRIER))
 		ret = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 79736a2..a533593 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -565,9 +565,7 @@ bail:
 static void ocfs2_dio_end_io(struct kiocb *iocb,
 			     loff_t offset,
 			     ssize_t bytes,
-			     void *private,
-			     int ret,
-			     bool is_async)
+			     void *private)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	int level;
@@ -592,10 +590,6 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 
 	level = ocfs2_iocb_rw_locked_level(iocb);
 	ocfs2_rw_unlock(inode, level);
-
-	inode_dio_done(inode);
-	if (is_async)
-		aio_complete(iocb, ret, 0);
 }
 
 /*
diff --git a/fs/super.c b/fs/super.c
index 68307c0..d961ae1 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -152,15 +152,9 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	static const struct super_operations default_op;
 
 	if (s) {
-		if (security_sb_alloc(s)) {
-			/*
-			 * We cannot call security_sb_free() without
-			 * security_sb_alloc() succeeding. So bail out manually
-			 */
-			kfree(s);
-			s = NULL;
-			goto out;
-		}
+		if (security_sb_alloc(s))
+			goto out_free_sb;
+
 #ifdef CONFIG_SMP
 		s->s_files = alloc_percpu(struct list_head);
 		if (!s->s_files)
@@ -228,6 +222,7 @@ err_out:
 		free_percpu(s->s_files);
 #endif
 	destroy_sb_writers(s);
+out_free_sb:
 	kfree(s);
 	s = NULL;
 	goto out;
@@ -412,6 +407,11 @@ void generic_shutdown_super(struct super_block *sb)
 
 		fsnotify_unmount_inodes(&sb->s_inodes);
 
+		if (sb->s_dio_done_wq) {
+			destroy_workqueue(sb->s_dio_done_wq);
+			sb->s_dio_done_wq = NULL;
+		}
+
 		evict_inodes(sb);
 
 		if (sop->put_super)
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 596ec71..e11d654 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -86,14 +86,6 @@ xfs_destroy_ioend(
 		bh->b_end_io(bh, !ioend->io_error);
 	}
 
-	if (ioend->io_iocb) {
-		inode_dio_done(ioend->io_inode);
-		if (ioend->io_isasync) {
-			aio_complete(ioend->io_iocb, ioend->io_error ?
-					ioend->io_error : ioend->io_result, 0);
-		}
-	}
-
 	mempool_free(ioend, xfs_ioend_pool);
 }
 
@@ -281,7 +273,6 @@ xfs_alloc_ioend(
 	 * all the I/O from calling the completion routine too early.
 	 */
 	atomic_set(&ioend->io_remaining, 1);
-	ioend->io_isasync = 0;
 	ioend->io_isdirect = 0;
 	ioend->io_error = 0;
 	ioend->io_list = NULL;
@@ -291,8 +282,6 @@ xfs_alloc_ioend(
 	ioend->io_buffer_tail = NULL;
 	ioend->io_offset = 0;
 	ioend->io_size = 0;
-	ioend->io_iocb = NULL;
-	ioend->io_result = 0;
 	ioend->io_append_trans = NULL;
 
 	INIT_WORK(&ioend->io_work, xfs_end_io);
@@ -1292,8 +1281,10 @@ __xfs_get_blocks(
 		if (create || !ISUNWRITTEN(&imap))
 			xfs_map_buffer(inode, bh_result, &imap, offset);
 		if (create && ISUNWRITTEN(&imap)) {
-			if (direct)
+			if (direct) {
 				bh_result->b_private = inode;
+				set_buffer_defer_completion(bh_result);
+			}
 			set_buffer_unwritten(bh_result);
 		}
 	}
@@ -1390,9 +1381,7 @@ xfs_end_io_direct_write(
 	struct kiocb		*iocb,
 	loff_t			offset,
 	ssize_t			size,
-	void			*private,
-	int			ret,
-	bool			is_async)
+	void			*private)
 {
 	struct xfs_ioend	*ioend = iocb->private;
 
@@ -1414,17 +1403,10 @@ xfs_end_io_direct_write(
 
 	ioend->io_offset = offset;
 	ioend->io_size = size;
-	ioend->io_iocb = iocb;
-	ioend->io_result = ret;
 	if (private && size > 0)
 		ioend->io_type = XFS_IO_UNWRITTEN;
 
-	if (is_async) {
-		ioend->io_isasync = 1;
-		xfs_finish_ioend(ioend);
-	} else {
-		xfs_finish_ioend_sync(ioend);
-	}
+	xfs_finish_ioend_sync(ioend);
 }
 
 STATIC ssize_t
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index c325abb..f94dd45 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -45,7 +45,6 @@ typedef struct xfs_ioend {
 	unsigned int		io_type;	/* delalloc / unwritten */
 	int			io_error;	/* I/O error code */
 	atomic_t		io_remaining;	/* hold count */
-	unsigned int		io_isasync : 1;	/* needs aio_complete */
 	unsigned int		io_isdirect : 1;/* direct I/O */
 	struct inode		*io_inode;	/* file being written to */
 	struct buffer_head	*io_buffer_head;/* buffer linked list head */
@@ -54,8 +53,6 @@ typedef struct xfs_ioend {
 	xfs_off_t		io_offset;	/* offset in the file */
 	struct work_struct	io_work;	/* xfsdatad work queue */
 	struct xfs_trans	*io_append_trans;/* xact. for size update */
-	struct kiocb		*io_iocb;
-	int			io_result;
 } xfs_ioend_t;
 
 extern const struct address_space_operations xfs_address_space_operations;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 91fa9a9..d77797a 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -36,6 +36,7 @@ enum bh_state_bits {
 	BH_Quiet,	/* Buffer Error Prinks to be quiet */
 	BH_Meta,	/* Buffer contains metadata */
 	BH_Prio,	/* Buffer should be submitted with REQ_PRIO */
+	BH_Defer_Completion, /* Defer AIO completion to workqueue */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
@@ -128,6 +129,7 @@ BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Unwritten, unwritten)
 BUFFER_FNS(Meta, meta)
 BUFFER_FNS(Prio, prio)
+BUFFER_FNS(Defer_Completion, defer_completion)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9818747..913aeee 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -46,6 +46,7 @@ struct vfsmount;
 struct cred;
 struct swap_info_struct;
 struct seq_file;
+struct workqueue_struct;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -63,8 +64,7 @@ struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create);
 typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
-			ssize_t bytes, void *private, int ret,
-			bool is_async);
+			ssize_t bytes, void *private);
 
 #define MAY_EXEC		0x00000001
 #define MAY_WRITE		0x00000002
@@ -1328,6 +1328,9 @@ struct super_block {
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
+
+	/* AIO completions deferred from interrupt context */
+	struct workqueue_struct *s_dio_done_wq;
 };
 
 /* superblock cache pruning functions */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
