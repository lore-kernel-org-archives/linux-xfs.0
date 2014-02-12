Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 43A267F50
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 07:30:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C028DAC001
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 05:30:07 -0800 (PST)
Received: from merlin.infradead.org (merlin.infradead.org [205.233.59.134]) by
	cuda.sgi.com with ESMTP id tCDF3YPiJMl2f1xZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Feb 2014 05:30:04 -0800 (PST)
Date: Wed, 12 Feb 2014 14:29:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212132952.GX27965@twins.programming.kicks-ass.net>
References: <20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<20140212055027.GA28502@redhat.com>
	<20140212061038.GC13997@dastard> <20140212063150.GD13997@dastard>
	<CA+55aFyp91=1seVT0ZV8T+GjOuafWvvjHNHn+MKGydsG+8eUEQ@mail.gmail.com>
	<20140212074036.4c6105b5@gandalf.local.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140212074036.4c6105b5@gandalf.local.home>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jens Axboe <axboe@kernel.dk>, Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>

On Wed, Feb 12, 2014 at 07:40:36AM -0500, Steven Rostedt wrote:
> The pt_regs structure.
> 
> That's what? 21 unsigned longs? 21 * 8 = 168. I think that's the
> culprit here.
> 
> Peter and Frederic, is there a way not to store that on the stack?

Something like so?

---
 include/trace/ftrace.h          | 7 ++++---
 kernel/trace/trace_event_perf.c | 5 ++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1a8b28db3775..87ae3ef1d278 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -678,7 +678,7 @@ perf_trace_##call(void *__data, proto)					\
 	struct ftrace_event_call *event_call = __data;			\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_raw_##call *entry;				\
-	struct pt_regs __regs;						\
+	struct pt_regs *__regs;						\
 	u64 __addr = 0, __count = 1;					\
 	struct task_struct *__task = NULL;				\
 	struct hlist_head *head;					\
@@ -697,18 +697,19 @@ perf_trace_##call(void *__data, proto)					\
 			     sizeof(u64));				\
 	__entry_size -= sizeof(u32);					\
 									\
-	perf_fetch_caller_regs(&__regs);				\
 	entry = perf_trace_buf_prepare(__entry_size,			\
 			event_call->event.type, &__regs, &rctx);	\
 	if (!entry)							\
 		return;							\
 									\
+	perf_fetch_caller_regs(__regs);					\
+									\
 	tstruct								\
 									\
 	{ assign; }							\
 									\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
-		__count, &__regs, head, __task);			\
+		__count, __regs, head, __task);				\
 }
 
 /*
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index e854f420e033..1885f4aac109 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -232,8 +232,10 @@ void perf_trace_del(struct perf_event *p_event, int flags)
 	tp_event->class->reg(tp_event, TRACE_REG_PERF_DEL, p_event);
 }
 
+static DEFINE_PER_CPU(struct pt_regs, tp_regs[4]);
+
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
-				       struct pt_regs *regs, int *rctxp)
+				       struct pt_regs **regs, int *rctxp)
 {
 	struct trace_entry *entry;
 	unsigned long flags;
@@ -252,6 +254,7 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	if (*rctxp < 0)
 		return NULL;
 
+	*regs = this_cpu_ptr(&tp_regs[*rctxp]);
 	raw_data = this_cpu_ptr(perf_trace_buf[*rctxp]);
 
 	/* zero the dead bytes from align to not leak stack to user */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
