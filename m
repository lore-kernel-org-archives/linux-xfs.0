Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o737NDaO230202 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 02:23:13 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E447748E47D
	for <xfs@oss.sgi.com>; Tue,  3 Aug 2010 00:23:31 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	QuAHAyD2G1ZYexTC for <xfs@oss.sgi.com>;
	Tue, 03 Aug 2010 00:23:31 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] dio: track and serialise unaligned direct IO
Date: Tue,  3 Aug 2010 17:23:22 +1000
Message-Id: <1280820204-1418-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1280820204-1418-1-git-send-email-david@fromorbit.com>
References: <1280820204-1418-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5111271954718745703=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com

--===============5111271954718745703==
Content-Type: text/plain

From: Dave Chinner <dchinner@redhat.com>

If we get two unaligned direct IO's to the same filesystem block
that is marked as a new allocation (i.e. buffer_new), then both IOs
will zero the portion of the block they are not writing data to. As
a result, when the IOs complete there will be a portion of the block
that contains zeros from the last IO to complete rather than the
data that should be there.

This is easily manifested by qemu using aio+dio with an unaligned
guest filesystem - every IO is unaligned and fileystem corruption is
encountered in the guest filesystem. xfstest 240 (from Eric Sandeen)
is also a simple reproducer.

To avoid this problem, track unaligned IO that triggers sub-block
zeroing and check new incoming unaligned IO that require sub-block
zeroing against that list. If we get an overlap where the start and
end of unaligned IOs hit the same filesystem block, then we need to
block the incoming IOs until the IO that is zeroing the block
completes. The blocked IO can then continue without needing to do
any zeroing and hence won't overwrite valid data with zeros.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/direct-io.c |  152 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 146 insertions(+), 6 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index a10cb91..865749e 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -71,6 +71,9 @@ struct dio {
 	unsigned start_zero_done;	/* flag: sub-blocksize zeroing has
 					   been performed at the start of a
 					   write */
+#define LAST_SECTOR ((sector_t)-1LL)
+	sector_t zero_block_front;	/* fs block we are zeroing at front */
+	sector_t zero_block_rear;	/* fs block we are zeroing at rear */
 	int pages_in_io;		/* approximate total IO pages */
 	size_t	size;			/* total request size (doesn't change)*/
 	sector_t block_in_file;		/* Current offset into the underlying
@@ -135,6 +138,101 @@ struct dio {
 	struct page *pages[DIO_PAGES];	/* page buffer */
 };
 
+
+/*
+ * record fs blocks we are doing zeroing on in a zero block list.
+ * unaligned IO is not very performant and so is relatively uncommon,
+ * so a global list should be sufficent to track them.
+ */
+struct dio_zero_block {
+	struct list_head dio_list;	/* list of io in progress */
+	sector_t	zero_block;	/* block being zeroed */
+	struct dio	*dio;		/* owner dio */
+	wait_queue_head_t wq;		/* New IO block here */
+	atomic_t	ref;		/* reference count */
+};
+
+static DEFINE_SPINLOCK(dio_zero_block_lock);
+static LIST_HEAD(dio_zero_block_list);
+
+/*
+ * Add a filesystem block to the list of blocks we are tracking.
+ */
+static void
+dio_start_zero_block(struct dio *dio, sector_t zero_block)
+{
+	struct dio_zero_block *zb;
+
+	zb = kmalloc(sizeof(*zb), GFP_NOIO);
+	if (!zb)
+		return;
+	INIT_LIST_HEAD(&zb->dio_list);
+	init_waitqueue_head(&zb->wq);
+	zb->zero_block = zero_block;
+	zb->dio = dio;
+	atomic_set(&zb->ref, 1);
+
+	spin_lock(&dio_zero_block_lock);
+	list_add(&zb->dio_list, &dio_zero_block_list);
+	spin_unlock(&dio_zero_block_lock);
+}
+
+static void
+dio_drop_zero_block(struct dio_zero_block *zb)
+{
+	if (atomic_dec_and_test(&zb->ref))
+		kfree(zb);
+}
+
+/*
+ * Check whether a filesystem block is currently being zeroed, and if it is
+ * wait for it to complete before returning. If we waited for a block being
+ * zeroed, return 1 to indicate that the block is already initialised,
+ * otherwise return 0 to indicate that it needs zeroing.
+ */
+static int
+dio_wait_zero_block(struct dio *dio, sector_t zero_block)
+{
+	struct dio_zero_block *zb;
+
+	spin_lock(&dio_zero_block_lock);
+	list_for_each_entry(zb, &dio_zero_block_list, dio_list) {
+		if (zb->dio->inode != dio->inode)
+			continue;
+		if (zb->zero_block != zero_block)
+			continue;
+		atomic_inc(&zb->ref);
+		spin_unlock(&dio_zero_block_lock);
+		wait_event(zb->wq, (list_empty(&zb->dio_list)));
+		dio_drop_zero_block(zb);
+		return 1;
+	}
+	spin_unlock(&dio_zero_block_lock);
+	return 0;
+}
+
+/*
+ * Complete a block zeroing and wake up anyone waiting for it.
+ */
+static void dio_end_zero_block(struct dio *dio, sector_t zero_block)
+{
+	struct dio_zero_block *zb;
+
+	spin_lock(&dio_zero_block_lock);
+	list_for_each_entry(zb, &dio_zero_block_list, dio_list) {
+		if (zb->dio->inode != dio->inode)
+			continue;
+		if (zb->zero_block != zero_block)
+			continue;
+		list_del_init(&zb->dio_list);
+		spin_unlock(&dio_zero_block_lock);
+		wake_up(&zb->wq);
+		dio_drop_zero_block(zb);
+		return;
+	}
+	spin_unlock(&dio_zero_block_lock);
+}
+
 /*
  * How many pages are in the queue?
  */
@@ -253,6 +351,11 @@ static int dio_complete(struct dio *dio, loff_t offset, int ret, bool is_async)
 		aio_complete(dio->iocb, ret, 0);
 	}
 
+	if (dio->zero_block_front != LAST_SECTOR)
+		dio_end_zero_block(dio, dio->zero_block_front);
+	if (dio->zero_block_rear != LAST_SECTOR)
+		dio_end_zero_block(dio, dio->zero_block_rear);
+
 	if (dio->flags & DIO_LOCKING)
 		/* lockdep: non-owner release */
 		up_read_non_owner(&dio->inode->i_alloc_sem);
@@ -777,6 +880,12 @@ static void clean_blockdev_aliases(struct dio *dio)
  * block with zeros. This happens only if user-buffer, fileoffset or
  * io length is not filesystem block-size multiple.
  *
+ * We need to track the blocks we are zeroing. If we have concurrent IOs that hit
+ * the same start or end block, we do not want all the IOs to zero the portion
+ * they are not writing data to as that will overwrite data from the other IOs.
+ * Hence we need to block until the first unaligned IO completes before we can
+ * continue (without executing any zeroing).
+ *
  * `end' is zero if we're doing the start of the IO, 1 at the end of the
  * IO.
  */
@@ -784,8 +893,8 @@ static void dio_zero_block(struct dio *dio, int end)
 {
 	unsigned dio_blocks_per_fs_block;
 	unsigned this_chunk_blocks;	/* In dio_blocks */
-	unsigned this_chunk_bytes;
 	struct page *page;
+	sector_t fsblock;
 
 	dio->start_zero_done = 1;
 	if (!dio->blkfactor || !buffer_new(&dio->map_bh))
@@ -797,17 +906,41 @@ static void dio_zero_block(struct dio *dio, int end)
 	if (!this_chunk_blocks)
 		return;
 
+	if (end)
+		this_chunk_blocks = dio_blocks_per_fs_block - this_chunk_blocks;
+
 	/*
 	 * We need to zero out part of an fs block.  It is either at the
-	 * beginning or the end of the fs block.
+	 * beginning or the end of the fs block, but first we need to check if
+	 * there is already a zeroing being run on this block.
+	 *
+	 * If we are doing a sub-block IO (i.e. zeroing both front and rear of
+	 * the same block) we don't need to wait or set a gaurd for the rear of
+	 * the block as we already have one set.
 	 */
-	if (end) 
-		this_chunk_blocks = dio_blocks_per_fs_block - this_chunk_blocks;
+	fsblock = dio->block_in_file >> dio->blkfactor;
+	if (!end || dio->zero_block_front != fsblock) {
 
-	this_chunk_bytes = this_chunk_blocks << dio->blkbits;
+		/* wait for any zeroing already in progress */
+		if (dio_wait_zero_block(dio, fsblock)) {
+			/* skip the range we would have zeroed. */
+			dio->next_block_for_io += this_chunk_blocks;
+			return;
+		}
+
+		/*
+		 * we are going to zero stuff now, so set a guard to catch
+		 * others that might want to zero the same block.
+		 */
+		dio_start_zero_block(dio, fsblock);
+		if (end)
+			dio->zero_block_rear = fsblock;
+		else
+			dio->zero_block_front = fsblock;
+	}
 
 	page = ZERO_PAGE(0);
-	if (submit_page_section(dio, page, 0, this_chunk_bytes, 
+	if (submit_page_section(dio, page, 0, this_chunk_blocks << dio->blkbits,
 				dio->next_block_for_io))
 		return;
 
@@ -1191,6 +1324,13 @@ __blockdev_direct_IO_newtrunc(int rw, struct kiocb *iocb, struct inode *inode,
 	 */
 	memset(dio, 0, offsetof(struct dio, pages));
 
+	/*
+	 * zero_blocks need to initialised to largeѕt value to avoid
+	 * matching the zero block accidentally.
+	 */
+	dio->zero_block_front = LAST_SECTOR;
+	dio->zero_block_rear = LAST_SECTOR;
+
 	dio->flags = flags;
 	if (dio->flags & DIO_LOCKING) {
 		/* watch out for a 0 len io from a tricksy fs */
-- 
1.7.1


--===============5111271954718745703==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5111271954718745703==--
