Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DEVbdi087209 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 09:31:37 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 526A5682C2
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 07:31:35 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id f3ipEC4Czbe6fHYv for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 07:31:35 -0700 (PDT)
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH 5/5] mm: writeback: Prioritise dirty inodes encountered by
	direct reclaim for background flushing
Date: Wed, 13 Jul 2011 15:31:27 +0100
Message-Id: <1310567487-15367-6-git-send-email-mgorman@suse.de>
In-Reply-To: <1310567487-15367-1-git-send-email-mgorman@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
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
To: Linux-MM <linux-mm@kvack.org>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>, Mel Gorman <mgorman@suse.de>

It is preferable that no dirty pages are dispatched from the page
reclaim path. If reclaim is encountering dirty pages, it implies that
either reclaim is getting ahead of writeback or use-once logic has
prioritise pages for reclaiming that are young relative to when the
inode was dirtied.

When dirty pages are encounted on the LRU, this patch marks the inodes
I_DIRTY_RECLAIM and wakes the background flusher. When the background
flusher runs, it moves such inodes immediately to the dispatch queue
regardless of inode age. There is no guarantee that pages reclaim
cares about will be cleaned first but the expectation is that the
flusher threads will clean the page quicker than if reclaim tried to
clean a single page.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 fs/fs-writeback.c         |   56 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/fs.h        |    5 ++-
 include/linux/writeback.h |    1 +
 mm/vmscan.c               |   16 ++++++++++++-
 4 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 0f015a0..1201052 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -257,9 +257,23 @@ static void move_expired_inodes(struct list_head *delaying_queue,
 	LIST_HEAD(tmp);
 	struct list_head *pos, *node;
 	struct super_block *sb = NULL;
-	struct inode *inode;
+	struct inode *inode, *tinode;
 	int do_sb_sort = 0;
 
+	/* Move inodes reclaim found at end of LRU to dispatch queue */
+	list_for_each_entry_safe(inode, tinode, delaying_queue, i_wb_list) {
+		/* Move any inode found at end of LRU to dispatch queue */
+		if (inode->i_state & I_DIRTY_RECLAIM) {
+			inode->i_state &= ~I_DIRTY_RECLAIM;
+			list_move(&inode->i_wb_list, &tmp);
+
+			if (sb && sb != inode->i_sb)
+				do_sb_sort = 1;
+			sb = inode->i_sb;
+		}
+	}
+
+	sb = NULL;
 	while (!list_empty(delaying_queue)) {
 		inode = wb_inode(delaying_queue->prev);
 		if (older_than_this &&
@@ -968,6 +982,46 @@ void wakeup_flusher_threads(long nr_pages)
 	rcu_read_unlock();
 }
 
+/*
+ * Similar to wakeup_flusher_threads except prioritise inodes contained
+ * in the page_list regardless of age
+ */
+void wakeup_flusher_threads_pages(long nr_pages, struct list_head *page_list)
+{
+	struct page *page;
+	struct address_space *mapping;
+	struct inode *inode;
+
+	list_for_each_entry(page, page_list, lru) {
+		if (!PageDirty(page))
+			continue;
+
+		if (PageSwapBacked(page))
+			continue;
+
+		lock_page(page);
+		mapping = page_mapping(page);
+		if (!mapping)
+			goto unlock;
+
+		/*
+		 * Test outside the lock to see as if it is already set. Inode
+		 * should be pinned by the lock_page
+		 */
+		inode = page->mapping->host;
+		if (inode->i_state & I_DIRTY_RECLAIM)
+			goto unlock;
+
+		spin_lock(&inode->i_lock);
+		inode->i_state |= I_DIRTY_RECLAIM;
+		spin_unlock(&inode->i_lock);
+unlock:
+		unlock_page(page);
+	}
+
+	wakeup_flusher_threads(nr_pages);
+}
+
 static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 {
 	if (inode->i_ino || strcmp(inode->i_sb->s_id, "bdev")) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5b9792..bb0f4c2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1650,8 +1650,8 @@ struct super_operations {
 /*
  * Inode state bits.  Protected by inode->i_lock
  *
- * Three bits determine the dirty state of the inode, I_DIRTY_SYNC,
- * I_DIRTY_DATASYNC and I_DIRTY_PAGES.
+ * Four bits determine the dirty state of the inode, I_DIRTY_SYNC,
+ * I_DIRTY_DATASYNC, I_DIRTY_PAGES and I_DIRTY_RECLAIM.
  *
  * Four bits define the lifetime of an inode.  Initially, inodes are I_NEW,
  * until that flag is cleared.  I_WILL_FREE, I_FREEING and I_CLEAR are set at
@@ -1706,6 +1706,7 @@ struct super_operations {
 #define __I_SYNC		7
 #define I_SYNC			(1 << __I_SYNC)
 #define I_REFERENCED		(1 << 8)
+#define I_DIRTY_RECLAIM		(1 << 9)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 17e7ccc..1e77793 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -66,6 +66,7 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
 		struct writeback_control *wbc);
 long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
 void wakeup_flusher_threads(long nr_pages);
+void wakeup_flusher_threads_pages(long nr_pages, struct list_head *page_list);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8e00aee..db62af1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -725,8 +725,11 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
+	LIST_HEAD(dirty_pages);
+
 	int pgactivate = 0;
 	unsigned long nr_dirty = 0;
+	unsigned long nr_unqueued_dirty = 0;
 	unsigned long nr_congested = 0;
 	unsigned long nr_reclaimed = 0;
 
@@ -830,7 +833,9 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 			/*
 			 * Only kswapd can writeback filesystem pages to
 			 * avoid risk of stack overflow but do not writeback
-			 * unless under significant pressure.
+			 * unless under significant pressure. For dirty pages
+			 * not under writeback, create a list and pass the
+			 * inodes to the flusher threads later
 			 */
 			if (page_is_file_cache(page) &&
 					(!current_is_kswapd() || priority >= DEF_PRIORITY - 2)) {
@@ -840,6 +845,10 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 				unlock_page(page);
 				deactivate_page(page);
 
+				/* Prioritise the backing inodes later */
+				nr_unqueued_dirty++;
+				list_add(&page->lru, &dirty_pages);
+
 				goto keep_dirty;
 			}
 
@@ -976,6 +985,11 @@ keep_dirty:
 
 	free_page_list(&free_pages);
 
+	if (!list_empty(&dirty_pages)) {
+		wakeup_flusher_threads_pages(nr_unqueued_dirty, &dirty_pages);
+		list_splice(&ret_pages, &dirty_pages);
+	}
+
 	list_splice(&ret_pages, page_list);
 	count_vm_events(PGACTIVATE, pgactivate);
 	*ret_nr_dirty += nr_dirty;
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
