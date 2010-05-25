Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PAqedY242788 for <xfs@oss.sgi.com>; Tue, 25 May 2010 05:52:40 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46A18143FFC6
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 03:55:00 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	kIiiRRUQFNAkCwUr for <xfs@oss.sgi.com>;
	Tue, 25 May 2010 03:55:00 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Date: Tue, 25 May 2010 20:54:10 +1000
Message-Id: <1274784852-30502-5-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

If a filesystem writes more than one page in ->writepage, write_cache_pages
fails to notice this and continues to attempt writeback when wbc->nr_to_write
has gone negative - this trace was captured from XFS:


    wbc_writeback_start: towrt=1024
    wbc_writepage: towrt=1024
    wbc_writepage: towrt=0
    wbc_writepage: towrt=-1
    wbc_writepage: towrt=-5
    wbc_writepage: towrt=-21
    wbc_writepage: towrt=-85

This has adverse effects on filesystem writeback behaviour. write_cache_pages()
needs to terminate after a certain number of pages are written, not after a
certain number of calls to ->writepage are made.  This is a regression
introduced by 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4, but cannot be reverted
directly due to subsequent bug fixes that have gone in on top of it.

This commit adds a ->writepage tracepoint inside write_cache_pages() (how the
above trace was generated) and does the revert manually leaving the subsequent
bug fixes in tact. ext4 is not affected by this as a previous commit in the
series stops ext4 from using the generic function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/writeback.h        |    9 ---------
 include/trace/events/writeback.h |    1 +
 mm/page-writeback.c              |   16 ++++++----------
 3 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index a74837e..488ac1c 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -55,15 +55,6 @@ struct writeback_control {
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
-	/*
-	 * write_cache_pages() won't update wbc->nr_to_write and
-	 * mapping->writeback_index if no_nrwrite_index_update
-	 * is set.  write_cache_pages() may write more than we
-	 * requested and we want to make sure nr_to_write and
-	 * writeback_index are updated in a consistent manner
-	 * so we use a single control to update them
-	 */
-	unsigned no_nrwrite_index_update:1;
 
 	/*
 	 * For WB_SYNC_ALL, the sb must always be pinned. For WB_SYNC_NONE,
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 72c1a12..5dda40e 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -244,6 +244,7 @@ DEFINE_WBC_EVENT(wbc_writeback_wait);
 DEFINE_WBC_EVENT(wbc_balance_dirty_start);
 DEFINE_WBC_EVENT(wbc_balance_dirty_written);
 DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
+DEFINE_WBC_EVENT(wbc_writepage);
 
 #endif /* _TRACE_WRITEBACK_H */
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 68eb727..0fe713d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -839,7 +839,6 @@ int write_cache_pages(struct address_space *mapping,
 	pgoff_t done_index;
 	int cycled;
 	int range_whole = 0;
-	long nr_to_write = wbc->nr_to_write;
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
@@ -921,6 +920,7 @@ continue_unlock:
 			if (!clear_page_dirty_for_io(page))
 				goto continue_unlock;
 
+			trace_wbc_writepage(wbc);
 			ret = (*writepage)(page, wbc, data);
 			if (unlikely(ret)) {
 				if (ret == AOP_WRITEPAGE_ACTIVATE) {
@@ -939,11 +939,10 @@ continue_unlock:
 					done = 1;
 					break;
 				}
- 			}
+			}
 
-			if (nr_to_write > 0) {
-				nr_to_write--;
-				if (nr_to_write == 0 &&
+			if (wbc->nr_to_write > 0) {
+				if (--wbc->nr_to_write == 0 &&
 				    wbc->sync_mode == WB_SYNC_NONE) {
 					/*
 					 * We stop writing back only if we are
@@ -974,11 +973,8 @@ continue_unlock:
 		end = writeback_index - 1;
 		goto retry;
 	}
-	if (!wbc->no_nrwrite_index_update) {
-		if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
-			mapping->writeback_index = done_index;
-		wbc->nr_to_write = nr_to_write;
-	}
+	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
+		mapping->writeback_index = done_index;
 
 	return ret;
 }
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
