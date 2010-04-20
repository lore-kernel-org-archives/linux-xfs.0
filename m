Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3K2fCB4256182 for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 21:41:13 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FB3C2D6101
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 19:42:33 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	cPmASEADrDYJV4Ct for <xfs@oss.sgi.com>;
	Mon, 19 Apr 2010 19:42:33 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] writeback: initial tracing support
Date: Tue, 20 Apr 2010 12:41:51 +1000
Message-Id: <1271731314-5893-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1271731314-5893-1-git-send-email-david@fromorbit.com>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

From: From: Jens Axboe <jens.axboe@oracle.com>

Trace queue/sched/exec parts of the writeback loop.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c                |   51 +++++-------
 include/linux/writeback.h        |   27 ++++++
 include/trace/events/writeback.h |  171 ++++++++++++++++++++++++++++++++++++++
 mm/backing-dev.c                 |    5 +
 4 files changed, 224 insertions(+), 30 deletions(-)
 create mode 100644 include/trace/events/writeback.h

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 76fc4d5..3f5f0a5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -25,7 +25,9 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
+#include <linux/ftrace.h>
 #include "internal.h"
+#include <trace/events/writeback.h>
 
 #define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
 
@@ -34,33 +36,6 @@
  */
 int nr_pdflush_threads;
 
-/*
- * Passed into wb_writeback(), essentially a subset of writeback_control
- */
-struct wb_writeback_args {
-	long nr_pages;
-	struct super_block *sb;
-	enum writeback_sync_modes sync_mode;
-	int for_kupdate:1;
-	int range_cyclic:1;
-	int for_background:1;
-};
-
-/*
- * Work items for the bdi_writeback threads
- */
-struct bdi_work {
-	struct list_head list;		/* pending work list */
-	struct rcu_head rcu_head;	/* for RCU free/clear of work */
-
-	unsigned long seen;		/* threads that have seen this work */
-	atomic_t pending;		/* number of threads still to do work */
-
-	struct wb_writeback_args args;	/* writeback arguments */
-
-	unsigned long state;		/* flag bits, see WS_* */
-};
-
 enum {
 	WS_USED_B = 0,
 	WS_ONSTACK_B,
@@ -135,6 +110,8 @@ static void wb_work_complete(struct bdi_work *work)
 
 static void wb_clear_pending(struct bdi_writeback *wb, struct bdi_work *work)
 {
+	trace_writeback_clear(work);
+
 	/*
 	 * The caller has retrieved the work arguments from this work,
 	 * drop our reference. If this is the last ref, delete and free it
@@ -170,12 +147,16 @@ static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
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
@@ -202,6 +183,7 @@ static void bdi_alloc_queue_work(struct backing_dev_info *bdi,
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	if (work) {
 		bdi_work_init(work, args);
+		trace_writeback_queue(bdi, args);
 		bdi_queue_work(bdi, work);
 	} else {
 		struct bdi_writeback *wb = &bdi->wb;
@@ -235,6 +217,7 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
 	bdi_work_init(&work, &args);
 	work.state |= WS_ONSTACK;
 
+	trace_writeback_queue(bdi, &args);
 	bdi_queue_work(bdi, &work);
 	bdi_wait_on_work_clear(&work);
 }
@@ -880,6 +863,8 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 		if (force_wait)
 			work->args.sync_mode = args.sync_mode = WB_SYNC_ALL;
 
+		trace_writeback_exec(work);
+
 		/*
 		 * If this isn't a data integrity operation, just notify
 		 * that we have seen this work and we are now starting it.
@@ -915,9 +900,13 @@ int bdi_writeback_task(struct bdi_writeback *wb)
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
@@ -938,6 +927,8 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 		try_to_freeze();
 	}
 
+	trace_writeback_thread_start(0);
+
 	return 0;
 }
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 76e8903..b2d615f 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -22,6 +22,33 @@ enum writeback_sync_modes {
 };
 
 /*
+ * Passed into wb_writeback(), essentially a subset of writeback_control
+ */
+struct wb_writeback_args {
+	long nr_pages;
+	struct super_block *sb;
+	enum writeback_sync_modes sync_mode;
+	int for_kupdate:1;
+	int range_cyclic:1;
+	int for_background:1;
+};
+
+/*
+ * Work items for the bdi_writeback threads
+ */
+struct bdi_work {
+	struct list_head list;		/* pending work list */
+	struct rcu_head rcu_head;	/* for RCU free/clear of work */
+
+	unsigned long seen;		/* threads that have seen this work */
+	atomic_t pending;		/* number of threads still to do work */
+
+	struct wb_writeback_args args;	/* writeback arguments */
+
+	unsigned long state;		/* flag bits, see WS_* */
+};
+
+/*
  * A control structure which tells the writeback code what to do.  These are
  * always on the stack, and hence need no locking.  They are always initialised
  * in a manner such that unspecified fields are set to zero.
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
new file mode 100644
index 0000000..df76457
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
+		strncpy(__entry->name, dev_name(bdi->dev), 16);
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
+		strncpy(__entry->name, dev_name(bdi->dev), 16);
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
+		strncpy(__entry->name, name, 16);
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
index 0e8ca03..2323e92 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -11,6 +11,9 @@
 #include <linux/writeback.h>
 #include <linux/device.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/writeback.h>
+
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 {
 }
@@ -570,6 +573,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 
 	bdi_debug_register(bdi, dev_name(dev));
 	set_bit(BDI_registered, &bdi->state);
+	trace_writeback_bdi_register(dev_name(dev), 1);
 exit:
 	return ret;
 }
@@ -632,6 +636,7 @@ static void bdi_prune_sb(struct backing_dev_info *bdi)
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
+		trace_writeback_bdi_register(dev_name(bdi->dev), 0);
 		bdi_prune_sb(bdi);
 
 		if (!bdi_cap_flush_forker(bdi))
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
