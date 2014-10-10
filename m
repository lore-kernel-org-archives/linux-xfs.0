Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A026C7F62
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FC04AC008
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:11 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id EH7wXCqtgP59iOOY (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:09 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] printk: debug: Slow down printing to 9600 bauds
Date: Fri, 10 Oct 2014 16:23:30 +0200
Message-Id: <1412951028-4085-26-git-send-email-jack@suse.cz>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/printk.h |  42 ++++++++++++++++
 kernel/printk/printk.c        | 112 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 151 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/printk.h b/include/trace/events/printk.h
index c008bc99f9fa..7ba97681960c 100644
--- a/include/trace/events/printk.h
+++ b/include/trace/events/printk.h
@@ -22,6 +22,48 @@ TRACE_EVENT(console,
 
 	TP_printk("%s", __get_str(msg))
 );
+
+DECLARE_EVENT_CLASS(printk_class,
+	TP_PROTO(int u),
+	TP_ARGS(u),
+	TP_STRUCT__entry(
+	        __field(        int, u)
+	),
+	TP_fast_assign(
+	        __entry->u       = u;
+	),
+	TP_printk("arg=%d", __entry->u)
+);
+
+DEFINE_EVENT(printk_class, printk_hand_over,
+	TP_PROTO(int u),
+	TP_ARGS(u)
+);
+
+DEFINE_EVENT(printk_class, printk_ask_help,
+	TP_PROTO(int u),
+	TP_ARGS(u)
+);
+
+DEFINE_EVENT(printk_class, printk_thread_sleep,
+	TP_PROTO(int u),
+	TP_ARGS(u)
+);
+
+DEFINE_EVENT(printk_class, printk_thread_woken,
+	TP_PROTO(int u),
+	TP_ARGS(u)
+);
+
+DEFINE_EVENT(printk_class, printk_thread_locked,
+	TP_PROTO(int u),
+	TP_ARGS(u)
+);
+
+DEFINE_EVENT(printk_class, printk_printing,
+	TP_PROTO(int u),
+	TP_ARGS(u)
+);
 #endif /* _TRACE_PRINTK_H */
 
 /* This part must be outside protection */
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index a06ba16ba0d4..4e64abc45159 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -23,6 +23,7 @@
 #include <linux/console.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
+#include <linux/stacktrace.h>
 #include <linux/nmi.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -90,6 +91,8 @@ EXPORT_SYMBOL_GPL(console_drivers);
 
 /* This gets set if the currently printing task wants to hand over printing */ 
 static int printk_handover;
+static int thread_woken;
+
 /*
  * Number of kernel threads for offloading printing. We need at least two so
  * that they can hand over printing from one to another one and thus switch
@@ -1308,6 +1311,22 @@ static void call_console_drivers(int level, const char *text, size_t len)
 	}
 }
 
+static void printk_echo(char *fmt, ...)
+{
+	unsigned long flags;
+	va_list args;
+	char buf[128];
+	int len;
+
+	len = sprintf(buf, "P%d ", task_pid_nr(current));
+	va_start(args, fmt);
+	len += vsprintf(buf + len, fmt, args);
+	va_end(args);
+	local_irq_save(flags);
+	call_console_drivers(0, buf, len);
+	local_irq_restore(flags);
+}
+
 /*
  * Zap console related locks when oopsing. Only zap at most once
  * every 10 seconds, to leave time for slow consoles to print a
@@ -1512,6 +1531,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	bool in_sched = false;
 	/* cpu currently holding logbuf_lock in this function */
 	static volatile unsigned int logbuf_cpu = UINT_MAX;
+	bool irq_off = irqs_disabled();
 
 	if (level == SCHED_MESSAGE_LOGLEVEL) {
 		level = -1;
@@ -1566,6 +1586,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (in_sched)
 		text_len = scnprintf(text, sizeof(textbuf),
 				     KERN_WARNING "[sched_delayed] ");
+	if (irq_off)
+		text[text_len++] = 'X';
 
 	text_len += vscnprintf(text + text_len,
 			       sizeof(textbuf) - text_len, fmt, args);
@@ -2030,6 +2052,31 @@ out:
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 }
 
+static struct task_struct *resched_task = NULL;
+static unsigned long last_traced;
+
+static void echo_trace(struct task_struct *task)
+{
+	struct stack_trace trace;
+	unsigned long entries[16];
+	int i;
+
+	trace.nr_entries = 0;
+	trace.max_entries = 16;
+	trace.entries = entries;
+	trace.skip = 0;
+
+	save_stack_trace_tsk(task, &trace);
+	for (i = 0; i < trace.nr_entries; i++)
+		printk_echo("%pS\n", (void *)entries[i]);
+	last_traced = jiffies;
+}
+
+static void ipi_stacktrace(void *info)
+{
+	echo_trace(current);
+}
+
 /*
  * Returns true iff there is other cpu waiting to take over printing. This
  * function also takes are of setting printk_handover if we want to hand over
@@ -2043,16 +2090,33 @@ static bool cpu_stop_printing(int printed_chars)
 	if (!printk_offload_chars || printed_chars < printk_offload_chars)
 		return false;
 	/* Someone is sleeping on console_sem? Give away to him. */
-	if (sema_contended(&console_sem))
+	if (sema_contended(&console_sem)) {
+		printk_echo("Handing over printing\n");
+		trace_printk_hand_over(0);
 		return true;
+	}
 	if (!printk_handover) {
+		unsigned long flags;
+
 		printk_handover = 1;
+		spin_lock_irqsave(&print_queue.lock, flags);
+		if (!list_empty(&print_queue.task_list))
+			resched_task = list_entry(print_queue.task_list.next, wait_queue_t, task_list)->private;
+		spin_unlock_irqrestore(&print_queue.lock, flags);
+		printk_echo("Asking for help %p (%d)\n", resched_task, (resched_task ? task_pid_nr(resched_task) : 0));
+		trace_printk_ask_help(0);
 		/*
 		 * Paired with barrier in prepare_to_wait_exclusive() in
 		 * printing_task()
 		 */
 		smp_mb();
 		wake_up(&print_queue);
+		if (resched_task) {
+			printk_echo("Task state %ld, cpu %u, cur cpu %u\n", 
+				    resched_task->state, task_cpu(resched_task),
+				    task_cpu(current));
+			on_each_cpu(ipi_stacktrace, NULL, 1);
+		}
 	}
 	return false;
 }
@@ -2088,6 +2152,9 @@ void console_unlock(void)
 		return;
 	}
 
+	if (oops_in_progress)
+		printk_echo("Oops!\n");
+	trace_printk_printing(0);
 	console_may_schedule = 0;
 
 	/* flush buffered message fragment immediately to console */
@@ -2148,9 +2215,24 @@ skip:
 		raw_spin_unlock(&logbuf_lock);
 
 		stop_critical_timings();	/* don't trace print latency */
+		if (printk_handover) {
+			if (sema_contended(&console_sem))
+				printk_echo("B ");
+			else if (thread_woken)
+				printk_echo("A ");
+			else if (resched_task) {
+				printk_echo("X%ld ", resched_task->state);
+				if (time_is_before_jiffies(last_traced + HZ)) {
+					smp_call_function_single(
+						task_cpu(resched_task),
+						ipi_stacktrace, NULL, 1);
+				}
+			}
+		}
 		call_console_drivers(level, text, len);
 		start_critical_timings();
 		printed_chars += len;
+		mdelay(len);
 		local_irq_restore(flags);
 	}
 
@@ -2159,6 +2241,7 @@ skip:
 		exclusive_console = NULL;
 
 	printk_handover = 0;
+	resched_task = NULL;
 	console_locked = 0;
 	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 	up(&console_sem);
@@ -2499,23 +2582,46 @@ static int printing_task(void *arg)
 	DEFINE_WAIT(wait);
 
 	while (1) {
-		prepare_to_wait_exclusive(&print_queue, &wait,
+		prepare_to_wait(&print_queue, &wait,
 					  TASK_INTERRUPTIBLE);
-		if (!printk_handover)
+		if (!printk_handover) {
+			trace_printk_thread_sleep(0);
 			schedule();
+		}
 		finish_wait(&print_queue, &wait);
+		trace_printk_thread_woken(0);
+		thread_woken = 1;
 		console_lock();
+		thread_woken = 0;
+		trace_printk_thread_locked(0);
 		console_unlock();
 	}
 	return 0;
 }
 
+static void do_print(struct work_struct *work)
+{
+	char buf[75];
+	int i;
+
+	sprintf(buf, "%p: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n", work);
+	for (i = 0; i < 15; i++)
+		printk(buf);
+}
+
+static struct delayed_work print_work[100];
+
 static int __init printk_late_init(void)
 {
 	struct console *con;
 	int i;
 	struct task_struct *task;
 
+	for (i = 0; i < 100; i++) {
+		INIT_DELAYED_WORK(&print_work[i], do_print);
+		schedule_delayed_work(&print_work[i], HZ * 180);
+	}
+
 	for_each_console(con) {
 		if (!keep_bootcon && con->flags & CON_BOOT) {
 			printk(KERN_INFO "turn off boot console %s%d\n",
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
