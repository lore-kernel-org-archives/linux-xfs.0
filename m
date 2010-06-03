Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o53NrjSB186382 for <xfs@oss.sgi.com>; Thu, 3 Jun 2010 18:53:45 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D22B210ABFE1
	for <xfs@oss.sgi.com>; Thu,  3 Jun 2010 16:58:43 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	PbUVsNkkkt6NjChc for <xfs@oss.sgi.com>;
	Thu, 03 Jun 2010 16:58:43 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Date: Fri,  4 Jun 2010 09:55:26 +1000
Message-Id: <1275609328-12514-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1275609328-12514-1-git-send-email-david@fromorbit.com>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

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

This commit adds a ->writepage tracepoint inside write_cache_pages() (how the
above trace was generated) and does the revert manually leaving the subsequent
bug fixes intact. ext4 is not affected by this as a previous commit in the
series stops ext4 from using the generic function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/writeback.h   |    9 ---------
 include/trace/events/ext4.h |    5 +----
 mm/page-writeback.c         |   15 +++++----------
 3 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index cc97d6c..52e82f3 100644
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
 
 	/*
 	 * For WB_SYNC_ALL, the sb must always be pinned. For WB_SYNC_NONE,
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
index caaf954..0fe713d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -839,7 +839,6 @@ int write_cache_pages(struct address_space *mapping,
 	pgoff_t done_index;
 	int cycled;
 	int range_whole = 0;
-	long nr_to_write = wbc->nr_to_write;
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
@@ -940,11 +939,10 @@ continue_unlock:
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
@@ -975,11 +973,8 @@ continue_unlock:
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
