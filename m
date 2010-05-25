Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PAqUio242723 for <xfs@oss.sgi.com>; Tue, 25 May 2010 05:52:30 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A41A336D262
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 03:54:51 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	bDXnTPuooAWSWQyv for <xfs@oss.sgi.com>;
	Tue, 25 May 2010 03:54:51 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] ext4: Use our own write_cache_pages()
Date: Tue, 25 May 2010 20:54:09 +1000
Message-Id: <1274784852-30502-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1274784852-30502-1-git-send-email-david@fromorbit.com>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com, linux-ext4@vger.kernel.org, tytso@mit.edu, xfs@oss.sgi.com

From: Theodore Ts'o <tytso@mit.edu>

Make a copy of write_cache_pages() for the benefit of
ext4_da_writepages().  This allows us to simplify the code some, and
will allow us to further customize the code in future patches.

There are some nasty hacks in write_cache_pages(), which Linus has
(correctly) characterized as vile.  I've just copied it into
write_cache_pages_da(), without trying to clean those bits up lest I
break something in the ext4's delalloc implementation, which is a bit
fragile right now.  This will allow Dave Chinner to clean up
write_cache_pages() in mm/page-writeback.c, without worrying about
breaking ext4.  Eventually write_cache_pages_da() will go away when I
rewrite ext4's delayed allocation and create a general
ext4_writepages() which is used for all of ext4's writeback.  Until
now this is the lowest risk way to clean up the core
write_cache_pages() function.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c             |  141 ++++++++++++++++++++++++++++++++++++-------
 include/trace/events/ext4.h |    5 +-
 2 files changed, 120 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3e0f6af..cdd4abe 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2423,17 +2423,6 @@ static int __mpage_da_writepage(struct page *page,
 	struct buffer_head *bh, *head;
 	sector_t logical;
 
-	if (mpd->io_done) {
-		/*
-		 * Rest of the page in the page_vec
-		 * redirty then and skip then. We will
-		 * try to write them again after
-		 * starting a new transaction
-		 */
-		redirty_page_for_writepage(wbc, page);
-		unlock_page(page);
-		return MPAGE_DA_EXTENT_TAIL;
-	}
 	/*
 	 * Can we merge this page to current extent?
 	 */
@@ -2828,6 +2817,124 @@ static int ext4_da_writepages_trans_blocks(struct inode *inode)
 	return ext4_chunk_trans_blocks(inode, max_blocks);
 }
 
+/*
+ * write_cache_pages_da - walk the list of dirty pages of the given
+ * address space and call the callback function (which usually writes
+ * the pages).
+ *
+ * This is a forked version of write_cache_pages().  Differences:
+ *	Range cyclic is ignored.
+ *	no_nrwrite_index_update is always presumed true
+ */
+static int write_cache_pages_da(struct address_space *mapping,
+				struct writeback_control *wbc,
+				struct mpage_da_data *mpd)
+{
+	int ret = 0;
+	int done = 0;
+	struct pagevec pvec;
+	int nr_pages;
+	pgoff_t index;
+	pgoff_t end;		/* Inclusive */
+	long nr_to_write = wbc->nr_to_write;
+
+	pagevec_init(&pvec, 0);
+	index = wbc->range_start >> PAGE_CACHE_SHIFT;
+	end = wbc->range_end >> PAGE_CACHE_SHIFT;
+
+	while (!done && (index <= end)) {
+		int i;
+
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			      PAGECACHE_TAG_DIRTY,
+			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		if (nr_pages == 0)
+			break;
+
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			/*
+			 * At this point, the page may be truncated or
+			 * invalidated (changing page->mapping to NULL), or
+			 * even swizzled back from swapper_space to tmpfs file
+			 * mapping. However, page->index will not change
+			 * because we have a reference on the page.
+			 */
+			if (page->index > end) {
+				done = 1;
+				break;
+			}
+
+			lock_page(page);
+
+			/*
+			 * Page truncated or invalidated. We can freely skip it
+			 * then, even for data integrity operations: the page
+			 * has disappeared concurrently, so there could be no
+			 * real expectation of this data interity operation
+			 * even if there is now a new, dirty page at the same
+			 * pagecache address.
+			 */
+			if (unlikely(page->mapping != mapping)) {
+continue_unlock:
+				unlock_page(page);
+				continue;
+			}
+
+			if (!PageDirty(page)) {
+				/* someone wrote it for us */
+				goto continue_unlock;
+			}
+
+			if (PageWriteback(page)) {
+				if (wbc->sync_mode != WB_SYNC_NONE)
+					wait_on_page_writeback(page);
+				else
+					goto continue_unlock;
+			}
+
+			BUG_ON(PageWriteback(page));
+			if (!clear_page_dirty_for_io(page))
+				goto continue_unlock;
+
+			ret = __mpage_da_writepage(page, wbc, mpd);
+			if (unlikely(ret)) {
+				if (ret == AOP_WRITEPAGE_ACTIVATE) {
+					unlock_page(page);
+					ret = 0;
+				} else {
+					done = 1;
+					break;
+				}
+ 			}
+
+			if (nr_to_write > 0) {
+				nr_to_write--;
+				if (nr_to_write == 0 &&
+				    wbc->sync_mode == WB_SYNC_NONE) {
+					/*
+					 * We stop writing back only if we are
+					 * not doing integrity sync. In case of
+					 * integrity sync we have to keep going
+					 * because someone may be concurrently
+					 * dirtying pages, and we might have
+					 * synced a lot of newly appeared dirty
+					 * pages, but have not synced all of the
+					 * old dirty pages.
+					 */
+					done = 1;
+					break;
+				}
+			}
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+	return ret;
+}
+
+
 static int ext4_da_writepages(struct address_space *mapping,
 			      struct writeback_control *wbc)
 {
@@ -2836,7 +2943,6 @@ static int ext4_da_writepages(struct address_space *mapping,
 	handle_t *handle = NULL;
 	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
-	int no_nrwrite_index_update;
 	int pages_written = 0;
 	long pages_skipped;
 	unsigned int max_pages;
@@ -2916,12 +3022,6 @@ static int ext4_da_writepages(struct address_space *mapping,
 	mpd.wbc = wbc;
 	mpd.inode = mapping->host;
 
-	/*
-	 * we don't want write_cache_pages to update
-	 * nr_to_write and writeback_index
-	 */
-	no_nrwrite_index_update = wbc->no_nrwrite_index_update;
-	wbc->no_nrwrite_index_update = 1;
 	pages_skipped = wbc->pages_skipped;
 
 retry:
@@ -2963,8 +3063,7 @@ retry:
 		mpd.io_done = 0;
 		mpd.pages_written = 0;
 		mpd.retval = 0;
-		ret = write_cache_pages(mapping, wbc, __mpage_da_writepage,
-					&mpd);
+		ret = write_cache_pages_da(mapping, wbc, &mpd);
 		/*
 		 * If we have a contiguous extent of pages and we
 		 * haven't done the I/O yet, map the blocks and submit
@@ -3030,8 +3129,6 @@ retry:
 		mapping->writeback_index = index;
 
 out_writepages:
-	if (!no_nrwrite_index_update)
-		wbc->no_nrwrite_index_update = 0;
 	wbc->nr_to_write -= nr_to_writebump;
 	wbc->range_start = range_start;
 	trace_ext4_da_writepages_result(inode, wbc, ret, pages_written);
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 2aa6aa3..fe76c15 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -306,7 +306,6 @@ TRACE_EVENT(ext4_da_writepages_result,
 		__field(	int,	pages_written		)
 		__field(	long,	pages_skipped		)
 		__field(	char,	more_io			)	
-		__field(	char,	no_nrwrite_index_update )
 		__field(       pgoff_t,	writeback_index		)
 	),
 
@@ -317,16 +316,14 @@ TRACE_EVENT(ext4_da_writepages_result,
 		__entry->pages_written	= pages_written;
 		__entry->pages_skipped	= wbc->pages_skipped;
 		__entry->more_io	= wbc->more_io;
-		__entry->no_nrwrite_index_update = wbc->no_nrwrite_index_update;
 		__entry->writeback_index = inode->i_mapping->writeback_index;
 	),
 
-	TP_printk("dev %s ino %lu ret %d pages_written %d pages_skipped %ld more_io %d no_nrwrite_index_update %d writeback_index %lu",
+	TP_printk("dev %s ino %lu ret %d pages_written %d pages_skipped %ld more_io %d writeback_index %lu",
 		  jbd2_dev_to_name(__entry->dev),
 		  (unsigned long) __entry->ino, __entry->ret,
 		  __entry->pages_written, __entry->pages_skipped,
 		  __entry->more_io,
-		  __entry->no_nrwrite_index_update,
 		  (unsigned long) __entry->writeback_index)
 );
 
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
