Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o580aRhn179676 for <xfs@oss.sgi.com>; Mon, 7 Jun 2010 19:36:28 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73D1F158C5AF
	for <xfs@oss.sgi.com>; Mon,  7 Jun 2010 17:41:50 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	r8bCl3WB0PLAoCAg for <xfs@oss.sgi.com>;
	Mon, 07 Jun 2010 17:41:50 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] writeback: Add tracing to balance_dirty_pages
Date: Tue,  8 Jun 2010 10:38:03 +1000
Message-Id: <1275957487-23633-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1275957487-23633-1-git-send-email-david@fromorbit.com>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
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

Tracing high level background writeback events is good, but it doesn't
give the entire picture. Add IO dispatched by foreground throttling to the
writeback events.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs-writeback.c                |    5 ++
 include/trace/events/writeback.h |   80 ++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c              |    4 ++
 3 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 0949dfd..6f777d6 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -807,7 +807,11 @@ static long wb_writeback(struct bdi_writeback *wb,
 		wbc.more_io = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
+
+		trace_wbc_writeback_start(&wbc);
 		writeback_inodes_wb(wb, &wbc);
+		trace_wbc_writeback_written(&wbc);
+
 		args->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 
@@ -835,6 +839,7 @@ static long wb_writeback(struct bdi_writeback *wb,
 		if (!list_empty(&wb->b_more_io))  {
 			inode = list_entry(wb->b_more_io.prev,
 						struct inode, i_list);
+			trace_wbc_writeback_wait(&wbc);
 			inode_wait_for_writeback(inode);
 		}
 		spin_unlock(&inode_lock);
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 6f510fa..7867c16 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -7,6 +7,9 @@
 #include <linux/backing-dev.h>
 #include <linux/writeback.h>
 
+struct wb_writeback_args;
+struct bdi_work;
+
 TRACE_EVENT(writeback_queue,
 
 	TP_PROTO(struct backing_dev_info *bdi, struct wb_writeback_args *args),
@@ -165,6 +168,83 @@ TRACE_EVENT(writeback_bdi_register,
 	TP_printk("%s: %s", __entry->name,
 			__entry->start ? "registered" : "unregistered")
 );
+
+/* pass flags explicitly */
+DECLARE_EVENT_CLASS(wbc_class,
+	TP_PROTO(struct writeback_control *wbc),
+	TP_ARGS(wbc),
+	TP_STRUCT__entry(
+		__field(unsigned int, wbc)
+		__array(char, name, 16)
+		__field(long, nr_to_write)
+		__field(long, pages_skipped)
+		__field(int, sb)
+		__field(int, sync_mode)
+		__field(int, nonblocking)
+		__field(int, encountered_congestion)
+		__field(int, for_kupdate)
+		__field(int, for_background)
+		__field(int, for_reclaim)
+		__field(int, range_cyclic)
+		__field(int, more_io)
+		__field(unsigned long, older_than_this)
+		__field(long, range_start)
+		__field(long, range_end)
+	),
+
+	TP_fast_assign(
+		char *__name = "(none)";
+
+		__entry->wbc		= (unsigned long)wbc & 0xffff;
+		if (wbc->bdi)
+			strncpy(__entry->name, dev_name(wbc->bdi->dev), 16);
+		else
+			strncpy(__entry->name, __name, 16);
+		__entry->nr_to_write	= wbc->nr_to_write;
+		__entry->pages_skipped	= wbc->pages_skipped;
+		__entry->sb		= !!wbc->sb;
+		__entry->sync_mode	= wbc->sync_mode;
+		__entry->for_kupdate	= wbc->for_kupdate;
+		__entry->for_background	= wbc->for_background;
+		__entry->for_reclaim	= wbc->for_reclaim;
+		__entry->range_cyclic	= wbc->range_cyclic;
+		__entry->more_io	= wbc->more_io;
+		__entry->older_than_this = wbc->older_than_this ?
+						*wbc->older_than_this : 0;
+		__entry->range_start	= (long)wbc->range_start;
+		__entry->range_end	= (long)wbc->range_end;
+	),
+
+	TP_printk("dev %s wbc=%x towrt=%ld skip=%ld sb=%d mode=%d kupd=%d "
+		"bgrd=%d reclm=%d cyclic=%d more=%d older=0x%lx "
+		"start=0x%lx end=0x%lx",
+		__entry->name,
+		__entry->wbc,
+		__entry->nr_to_write,
+		__entry->pages_skipped,
+		__entry->sb,
+		__entry->sync_mode,
+		__entry->for_kupdate,
+		__entry->for_background,
+		__entry->for_reclaim,
+		__entry->range_cyclic,
+		__entry->more_io,
+		__entry->older_than_this,
+		__entry->range_start,
+		__entry->range_end)
+)
+
+#define DEFINE_WBC_EVENT(name) \
+DEFINE_EVENT(wbc_class, name, \
+	TP_PROTO(struct writeback_control *wbc), \
+	TP_ARGS(wbc))
+DEFINE_WBC_EVENT(wbc_writeback_start);
+DEFINE_WBC_EVENT(wbc_writeback_written);
+DEFINE_WBC_EVENT(wbc_writeback_wait);
+DEFINE_WBC_EVENT(wbc_balance_dirty_start);
+DEFINE_WBC_EVENT(wbc_balance_dirty_written);
+DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
+
 #endif /* _TRACE_WRITEBACK_H */
 
 /* This part must be outside protection */
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 5fa63bd..345a730 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -34,6 +34,7 @@
 #include <linux/syscalls.h>
 #include <linux/buffer_head.h>
 #include <linux/pagevec.h>
+#include <trace/events/writeback.h>
 
 /*
  * After a CPU has dirtied this many pages, balance_dirty_pages_ratelimited
@@ -536,11 +537,13 @@ static void balance_dirty_pages(struct address_space *mapping,
 		 * threshold otherwise wait until the disk writes catch
 		 * up.
 		 */
+		trace_wbc_balance_dirty_start(&wbc);
 		if (bdi_nr_reclaimable > bdi_thresh) {
 			writeback_inodes_wbc(&wbc);
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);
+			trace_wbc_balance_dirty_written(&wbc);
 		}
 
 		/*
@@ -566,6 +569,7 @@ static void balance_dirty_pages(struct address_space *mapping,
 		if (pages_written >= write_chunk)
 			break;		/* We've done our duty */
 
+		trace_wbc_balance_dirty_wait(&wbc);
 		__set_current_state(TASK_INTERRUPTIBLE);
 		io_schedule_timeout(pause);
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
