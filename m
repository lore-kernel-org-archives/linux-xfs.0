Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o590Zig6245448 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 19:35:44 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3574410D0BA4
	for <xfs@oss.sgi.com>; Tue,  8 Jun 2010 17:41:12 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	u6KUmoAccAYU6Ap3 for <xfs@oss.sgi.com>;
	Tue, 08 Jun 2010 17:41:12 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Date: Wed,  9 Jun 2010 10:37:18 +1000
Message-Id: <1276043840-1946-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1276043840-1946-1-git-send-email-david@fromorbit.com>
References: <1276043840-1946-1-git-send-email-david@fromorbit.com>
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
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

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
introduced by 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4 ("vfs: Add
no_nrwrite_index_update writeback control flag"), but cannot be reverted
directly due to subsequent bug fixes that have gone in on top of it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/writeback.h   |    9 ---------
 include/trace/events/ext4.h |    5 +----
 mm/page-writeback.c         |   15 +++++----------
 3 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index f641346..d63ef8f 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -56,15 +56,6 @@ struct writeback_control {
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
 };
 
 /*
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index f5b1ba9..f3865c7 100644
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
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 5fa63bd..b3dbb80 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -835,7 +835,6 @@ int write_cache_pages(struct address_space *mapping,
 	pgoff_t done_index;
 	int cycled;
 	int range_whole = 0;
-	long nr_to_write = wbc->nr_to_write;
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
@@ -935,11 +934,10 @@ continue_unlock:
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
@@ -970,11 +968,8 @@ continue_unlock:
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
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
