Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o541M3f4190800 for <xfs@oss.sgi.com>; Thu, 3 Jun 2010 20:22:04 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F09513960F4
	for <xfs@oss.sgi.com>; Thu,  3 Jun 2010 18:24:30 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	e38iCeflcmyTLjIt for <xfs@oss.sgi.com>;
	Thu, 03 Jun 2010 18:24:30 -0700 (PDT)
Date: Fri, 4 Jun 2010 11:24:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] writeback: initial tracing support
Message-ID: <20100604012416.GB19651@dastard>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com>
	<1275609328-12514-2-git-send-email-david@fromorbit.com>
	<4C085289.9040000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C085289.9040000@cn.fujitsu.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jun 04, 2010 at 09:10:33AM +0800, Li Zefan wrote:
> > +TRACE_EVENT(writeback_queue,
> > +
> > +	TP_PROTO(struct backing_dev_info *bdi, struct wb_writeback_args *args),
> > +
> > +	TP_ARGS(bdi, args),
> > +
> > +	TP_STRUCT__entry(
> > +		__array(char,		name,		16)
> > +		__field(long,		nr_pages)
> > +		__field(int,		sb)
> > +		__field(int,		sync_mode)
> > +		__field(int,		for_kupdate)
> > +		__field(int,		range_cyclic)
> > +		__field(int,		for_background)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		strncpy(__entry->name, dev_name(bdi->dev), 16);
> 
> Should use strlcpy() ?

Don't care. Updated patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

writeback: initial tracing support

From:	Jens Axboe <jens.axboe@oracle.com>

Trace queue/sched/exec parts of the writeback loop. This provides
insight into when and why flusher threads are scheduled to run. e.g
a sync invocation leaves a trace like:

sync-2798  [006] 611323.335713: writeback_queue: 253:16: pages=87879, sb=0, kupdate=0, range_cyclic=0 for_background=0
sync-2798  [006] 611323.335718: writeback_sched: work=37c0, task=task
sync-2798  [006] 611323.335817: writeback_queue: 8:0: pages=92680, sb=1, kupdate=0, range_cyclic=-1 for_background=0
sync-2798  [006] 611323.335819: writeback_sched: work=35c0, task=task
sync-2798  [006] 611323.335855: writeback_queue: 253:16: pages=92680, sb=1, kupdate=0, range_cyclic=-1 for_background=0
sync-2798  [006] 611323.335857: writeback_sched: work=36c0, task=task
sync-2798  [006] 611323.335890: writeback_queue: 8:0: pages=9223372036854775807, sb=1, kupdate=0, range_cyclic=0 for_background=0
sync-2798  [006] 611323.335891: writeback_sched: work=fe58, task=task
sync-2798  [006] 611323.377341: writeback_queue: 253:16: pages=9223372036854775807, sb=1, kupdate=0, range_cyclic=0 for_background=0
sync-2798  [006] 611323.377346: writeback_sched: work=fe58, task=task

This also lays the foundation for adding more writeback tracing to
provide deeper insight into the whole writeback path.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs-writeback.c                |   45 ++++++++--
 include/trace/events/writeback.h |  171 ++++++++++++++++++++++++++++++++++++++
 mm/backing-dev.c                 |    3 +
 3 files changed, 209 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ea8592b..ebfaed8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -26,15 +26,9 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
+#include <linux/ftrace.h>
 #include "internal.h"
 
-#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
-
-/*
- * We don't actually have pdflush, but this one is exported though /proc...
- */
-int nr_pdflush_threads;
-
 /*
  * Passed into wb_writeback(), essentially a subset of writeback_control
  */
@@ -63,6 +57,21 @@ struct bdi_work {
 	unsigned long state;		/* flag bits, see WS_* */
 };
 
+/*
+ * Include the creation of the trace points after defining the bdi_work and
+ * wb_writeback_args structures so that the definitions remain local to this
+ * file.
+ */
+#define CREATE_TRACE_POINTS
+#include <trace/events/writeback.h>
+
+#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
+
+/*
+ * We don't actually have pdflush, but this one is exported though /proc...
+ */
+int nr_pdflush_threads;
+
 enum {
 	WS_USED_B = 0,
 	WS_ONSTACK_B,
@@ -137,6 +146,8 @@ static void wb_work_complete(struct bdi_work *work)
 
 static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
 {
+	trace_writeback_clear(work);
+
 	/*
 	 * The caller has retrieved the work arguments from this work,
 	 * drop our reference. If this is the last ref, delete and free it
@@ -172,12 +183,16 @@ static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
 	 * If the default thread isn't there, make sure we add it. When
 	 * it gets created and wakes up, we'll run this work.
 	 */
-	if (unlikely(list_empty_careful(&bdi->wb_list)))
+	if (unlikely(list_empty_careful(&bdi->wb_list))) {
+		trace_writeback_sched(bdi, work, "default");
 		wake_up_process(default_backing_dev_info.wb.task);
-	else {
+	} else {
 		struct bdi_writeback *wb = &bdi->wb;
+		struct task_struct *task = wb->task;
 
-		if (wb->task)
+		trace_writeback_sched(bdi, work, task ? "task" : "notask");
+
+		if (task)
 			wake_up_process(wb->task);
 	}
 }
@@ -205,6 +220,7 @@ static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	if (work) {
 		bdi_work_init(work, args);
+		trace_writeback_queue(bdi, args);
 		bdi_queue_work(bdi, work);
 		if (wait)
 			bdi_wait_on_work_clear(work);
@@ -245,6 +261,7 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
 	bdi_work_init(&work, &args);
 	work.state |= WS_ONSTACK;
 
+	trace_writeback_queue(bdi, &args);
 	bdi_queue_work(bdi, &work);
 	bdi_wait_on_work_clear(&work);
 }
@@ -914,6 +931,8 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 		struct wb_writeback_args args = work->args;
 		int post_clear;
 
+		trace_writeback_exec(work);
+
 		/*
 		 * Override sync mode, in case we must wait for completion
 		 */
@@ -957,9 +976,13 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 	unsigned long wait_jiffies = -1UL;
 	long pages_written;
 
+	trace_writeback_thread_start(1);
+
 	while (!kthread_should_stop()) {
 		pages_written = wb_do_writeback(wb, 0);
 
+		trace_writeback_pages_written(pages_written);
+
 		if (pages_written)
 			last_active = jiffies;
 		else if (wait_jiffies != -1UL) {
@@ -989,6 +1012,8 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 		try_to_freeze();
 	}
 
+	trace_writeback_thread_start(0);
+
 	return 0;
 }
 
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
new file mode 100644
index 0000000..6f510fa
--- /dev/null
+++ b/include/trace/events/writeback.h
@@ -0,0 +1,171 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM writeback
+
+#if !defined(_TRACE_WRITEBACK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_WRITEBACK_H
+
+#include <linux/backing-dev.h>
+#include <linux/writeback.h>
+
+TRACE_EVENT(writeback_queue,
+
+	TP_PROTO(struct backing_dev_info *bdi, struct wb_writeback_args *args),
+
+	TP_ARGS(bdi, args),
+
+	TP_STRUCT__entry(
+		__array(char,		name,		16)
+		__field(long,		nr_pages)
+		__field(int,		sb)
+		__field(int,		sync_mode)
+		__field(int,		for_kupdate)
+		__field(int,		range_cyclic)
+		__field(int,		for_background)
+	),
+
+	TP_fast_assign(
+		strlcpy(__entry->name, dev_name(bdi->dev), 16);
+		__entry->nr_pages	= args->nr_pages;
+		__entry->sb		= !!args->sb;
+		__entry->for_kupdate	= args->for_kupdate;
+		__entry->range_cyclic	= args->range_cyclic;
+		__entry->for_background	= args->for_background;
+	),
+
+	TP_printk("%s: pages=%ld, sb=%d, kupdate=%d, range_cyclic=%d "
+		  "for_background=%d", __entry->name, __entry->nr_pages,
+			__entry->sb, __entry->for_kupdate,
+			__entry->range_cyclic, __entry->for_background)
+);
+
+TRACE_EVENT(writeback_sched,
+
+	TP_PROTO(struct backing_dev_info *bdi, struct bdi_work *work,
+		 const char *msg),
+
+	TP_ARGS(bdi, work, msg),
+
+	TP_STRUCT__entry(
+		__array(char,			name,		16)
+		__field(unsigned int,		work)
+		__array(char,			task,		8)
+	),
+
+	TP_fast_assign(
+		strlcpy(__entry->name, dev_name(bdi->dev), 16);
+		__entry->work = (unsigned long) work & 0xffff;
+		snprintf(__entry->task, 8, "%s", msg);
+	),
+
+	TP_printk("work=%x, task=%s", __entry->work, __entry->task)
+);
+
+TRACE_EVENT(writeback_exec,
+
+	TP_PROTO(struct bdi_work *work),
+
+	TP_ARGS(work),
+
+	TP_STRUCT__entry(
+		__field(unsigned int,	work)
+		__field(long,		nr_pages)
+		__field(int,		sb)
+		__field(int,		sync_mode)
+		__field(int,		for_kupdate)
+		__field(int,		range_cyclic)
+		__field(int,		for_background)
+	),
+
+	TP_fast_assign(
+		__entry->work		= (unsigned long) work & 0xffff;
+		__entry->nr_pages	= work->args.nr_pages;
+		__entry->sb		= !!work->args.sb;
+		__entry->for_kupdate	= work->args.for_kupdate;
+		__entry->range_cyclic	= work->args.range_cyclic;
+		__entry->for_background	= work->args.for_background;
+
+	),
+
+	TP_printk("work=%x pages=%ld, sb=%d, kupdate=%d, range_cyclic=%d"
+		  " for_background=%d", __entry->work,
+			__entry->nr_pages, __entry->sb, __entry->for_kupdate,
+			__entry->range_cyclic, __entry->for_background)
+);
+
+TRACE_EVENT(writeback_clear,
+
+	TP_PROTO(struct bdi_work *work),
+
+	TP_ARGS(work),
+
+	TP_STRUCT__entry(
+		__field(struct bdi_work *,	work)
+		__field(int,			refs)
+	),
+
+	TP_fast_assign(
+		__entry->work		= work;
+		__entry->refs		= atomic_read(&work->pending);
+	),
+
+	TP_printk("work=%p, refs=%d", __entry->work, __entry->refs)
+);
+
+TRACE_EVENT(writeback_pages_written,
+
+	TP_PROTO(long pages_written),
+
+	TP_ARGS(pages_written),
+
+	TP_STRUCT__entry(
+		__field(long,		pages)
+	),
+
+	TP_fast_assign(
+		__entry->pages		= pages_written;
+	),
+
+	TP_printk("%ld", __entry->pages)
+);
+
+
+TRACE_EVENT(writeback_thread_start,
+
+	TP_PROTO(int start),
+
+	TP_ARGS(start),
+
+	TP_STRUCT__entry(
+		__field(int,	start)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+	),
+
+	TP_printk("%s", __entry->start ? "started" : "exited")
+);
+
+TRACE_EVENT(writeback_bdi_register,
+
+	TP_PROTO(const char *name, int start),
+
+	TP_ARGS(name, start),
+
+	TP_STRUCT__entry(
+		__array(char,	name,		16)
+		__field(int,	start)
+	),
+
+	TP_fast_assign(
+		strlcpy(__entry->name, name, 16);
+		__entry->start = start;
+	),
+
+	TP_printk("%s: %s", __entry->name,
+			__entry->start ? "registered" : "unregistered")
+);
+#endif /* _TRACE_WRITEBACK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 660a87a..1f7723b 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/writeback.h>
 #include <linux/device.h>
+#include <trace/events/writeback.h>
 
 static atomic_long_t bdi_seq = ATOMIC_LONG_INIT(0);
 
@@ -585,6 +586,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 
 	bdi_debug_register(bdi, dev_name(dev));
 	set_bit(BDI_registered, &bdi->state);
+	trace_writeback_bdi_register(dev_name(dev), 1);
 exit:
 	return ret;
 }
@@ -647,6 +649,7 @@ static void bdi_prune_sb(struct backing_dev_info *bdi)
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
+		trace_writeback_bdi_register(dev_name(bdi->dev), 0);
 		bdi_prune_sb(bdi);
 
 		if (!bdi_cap_flush_forker(bdi))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
