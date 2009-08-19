Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JKgV3J225927 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 15:42:46 -0500
Received: from mx3.mail.elte.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C38013E2E96
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 13:42:51 -0700 (PDT)
Received: from mx3.mail.elte.hu (mx3.mail.elte.hu [157.181.1.138]) by
	cuda.sgi.com with ESMTP id tI2cFXg88HWfwX8I for
	<xfs@oss.sgi.com>; Wed, 19 Aug 2009 13:42:51 -0700 (PDT)
Date: Wed, 19 Aug 2009 22:39:16 +0200
From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Message-ID: <20090819203916.GA25296@elte.hu>
References: <20090816004705.GA7347@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090816004705.GA7347@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, liml@rtr.ca, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> Given that everyone is so big in the discard discussion 
> I'd like to present what I had started to prepare for 
> XFS.  I didn't plan to send it out until I get my hands 
> onto a TRIM capable device (or at least get time to add 
> support to qemu), and so far it's only been tested in 
> dry-run mode.
> 
> The basic idea is to add an ioctl which walks the free 
> space btrees in each allocation group and simply 
> discard everythin that is free. [...]

A general interface design question: you added a new 
ioctl XFS_IOC_TRIM case. It's a sub-case of an 
ugly-looking demultiplexing xfs_file_ioctl().

What is your threshold for turning something into a 
syscall? When are ioctls acceptable in your opinion?

I'm asking this because we are facing a similar problem 
with perfcounters: we need to extend the ioctl 
functionality there but introducing a new syscall looks 
wasteful.

So i'm torn about the 'syscall versus ioctl' issue, i'd 
like to avoid making interface design mistakes and i'd 
like to solicit some opinions about this. I've attached 
the perfcounters ioctl patch below.

Thanks,

	Ingo

----- Forwarded message from Peter Zijlstra <a.p.zijlstra@chello.nl> -----

Date: Wed, 19 Aug 2009 11:18:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/4][RFC] perf_counter: Allow sharing of output channels
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
	stephane eranian <eranian@googlemail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>

Provide the ability to configure a counter to send its output to
another (already existing) counter's output stream.

[ compile tested only ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stephane eranian <eranian@googlemail.com>
---
 include/linux/perf_counter.h |    5 ++
 kernel/perf_counter.c        |   83 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 85 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -216,6 +216,7 @@ struct perf_counter_attr {
 #define PERF_COUNTER_IOC_REFRESH	_IO ('$', 2)
 #define PERF_COUNTER_IOC_RESET		_IO ('$', 3)
 #define PERF_COUNTER_IOC_PERIOD		_IOW('$', 4, u64)
+#define PERF_COUNTER_IOC_SET_OUTPUT	_IO ('$', 5)
 
 enum perf_counter_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
@@ -415,6 +416,9 @@ enum perf_callchain_context {
 	PERF_CONTEXT_MAX		= (__u64)-4095,
 };
 
+#define PERF_FLAG_FD_NO_GROUP	(1U << 0)
+#define PERF_FLAG_FD_OUTPUT	(1U << 1)
+
 #ifdef __KERNEL__
 /*
  * Kernel-internal data types and definitions:
@@ -536,6 +540,7 @@ struct perf_counter {
 	struct list_head		sibling_list;
 	int				nr_siblings;
 	struct perf_counter		*group_leader;
+	struct perf_counter		*output;
 	const struct pmu		*pmu;
 
 	enum perf_counter_active_state	state;
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1686,6 +1686,11 @@ static void free_counter(struct perf_cou
 			atomic_dec(&nr_task_counters);
 	}
 
+	if (counter->output) {
+		fput(counter->output->filp);
+		counter->output = NULL;
+	}
+
 	if (counter->destroy)
 		counter->destroy(counter);
 
@@ -1971,6 +1976,8 @@ unlock:
 	return ret;
 }
 
+int perf_counter_set_output(struct perf_counter *counter, int output_fd);
+
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct perf_counter *counter = file->private_data;
@@ -1994,6 +2001,9 @@ static long perf_ioctl(struct file *file
 	case PERF_COUNTER_IOC_PERIOD:
 		return perf_counter_period(counter, (u64 __user *)arg);
 
+	case PERF_COUNTER_IOC_SET_OUTPUT:
+		return perf_counter_set_output(counter, arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -2264,6 +2274,11 @@ static int perf_mmap(struct file *file, 
 
 	WARN_ON_ONCE(counter->ctx->parent_ctx);
 	mutex_lock(&counter->mmap_mutex);
+	if (counter->output) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
 	if (atomic_inc_not_zero(&counter->mmap_count)) {
 		if (nr_pages != counter->data->nr_pages)
 			ret = -EINVAL;
@@ -2649,6 +2664,7 @@ static int perf_output_begin(struct perf
 			     struct perf_counter *counter, unsigned int size,
 			     int nmi, int sample)
 {
+	struct perf_counter *output_counter;
 	struct perf_mmap_data *data;
 	unsigned int offset, head;
 	int have_lost;
@@ -2658,13 +2674,17 @@ static int perf_output_begin(struct perf
 		u64			 lost;
 	} lost_event;
 
+	rcu_read_lock();
 	/*
 	 * For inherited counters we send all the output towards the parent.
 	 */
 	if (counter->parent)
 		counter = counter->parent;
 
-	rcu_read_lock();
+	output_counter = rcu_dereference(counter->output);
+	if (output_counter)
+		counter = output_counter;
+
 	data = rcu_dereference(counter->data);
 	if (!data)
 		goto out;
@@ -4214,6 +4234,57 @@ err_size:
 	goto out;
 }
 
+int perf_counter_set_output(struct perf_counter *counter, int output_fd)
+{
+	struct perf_counter *output_counter = NULL;
+	struct file *output_file = NULL;
+	struct perf_counter *old_output;
+	int fput_needed = 0;
+	int ret = -EINVAL;
+
+	if (!output_fd)
+		goto set;
+
+	output_file = fget_light(output_fd, &fput_needed);
+	if (!output_file)
+		return -EBADF;
+
+	if (output_file->f_op != &perf_fops)
+		goto out;
+
+	output_counter = output_file->private_data;
+
+	/* Don't chain output fds */
+	if (output_counter->output)
+		goto out;
+
+	/* Don't set an output fd when we already have an output channel */
+	if (counter->data)
+		goto out;
+
+	atomic_long_inc(&output_file->f_count);
+
+set:
+	mutex_lock(&counter->mmap_mutex);
+	old_output = counter->output;
+	rcu_assign_pointer(counter->output, output_counter);
+	mutex_unlock(&counter->mmap_mutex);
+
+	if (old_output) {
+		/*
+		 * we need to make sure no existing perf_output_*()
+		 * is still referencing this counter.
+		 */
+		synchronize_rcu();
+		fput(old_output->filp);
+	}
+
+	ret = 0;
+out:
+	fput_light(output_file, fput_needed);
+	return ret;
+}
+
 /**
  * sys_perf_counter_open - open a performance counter, associate it to a task/cpu
  *
@@ -4236,7 +4307,7 @@ SYSCALL_DEFINE5(perf_counter_open,
 	int ret;
 
 	/* for future expandability... */
-	if (flags)
+	if (flags & ~(PERF_FLAG_FD_NO_GROUP | PERF_FLAG_FD_OUTPUT))
 		return -EINVAL;
 
 	ret = perf_copy_attr(attr_uptr, &attr);
@@ -4264,7 +4335,7 @@ SYSCALL_DEFINE5(perf_counter_open,
 	 * Look up the group leader (we will attach this counter to it):
 	 */
 	group_leader = NULL;
-	if (group_fd != -1) {
+	if (group_fd != -1 && !(flags & PERF_FLAG_FD_NO_GROUP)) {
 		ret = -EINVAL;
 		group_file = fget_light(group_fd, &fput_needed);
 		if (!group_file)
@@ -4306,6 +4377,12 @@ SYSCALL_DEFINE5(perf_counter_open,
 	if (!counter_file)
 		goto err_free_put_context;
 
+	if (flags & PERF_FLAG_FD_OUTPUT) {
+		ret = perf_counter_set_output(counter, group_fd);
+		if (ret)
+			goto err_free_put_context;
+	}
+
 	counter->filp = counter_file;
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);

-- 

----- End forwarded message -----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
