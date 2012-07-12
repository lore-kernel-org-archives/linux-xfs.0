Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6CLjKmh081818 for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 16:45:20 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id gQA5v6QPeF6JX85X
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Jul 2012 14:45:19 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so5389762pbb.26
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 14:45:18 -0700 (PDT)
Date: Thu, 12 Jul 2012 14:45:14 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate
	worker_pool
Message-ID: <20120712214514.GD20167@google.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
	<20120712130648.GA19214@localhost>
	<20120712170519.GA20167@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120712170519.GA20167@google.com>
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
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, Tony Luck <tony.luck@intel.com>, linux-crypto@vger.kernel.org, gustavo@padovan.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Hello, again.

On Thu, Jul 12, 2012 at 10:05:19AM -0700, Tejun Heo wrote:
> On Thu, Jul 12, 2012 at 09:06:48PM +0800, Fengguang Wu wrote:
> > [    0.207977] WARNING: at /c/kernel-tests/mm/kernel/workqueue.c:1217 worker_enter_idle+0x2b8/0x32b()
> > [    0.207977] Modules linked in:
> > [    0.207977] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc6-08414-g9645fff #15
> > [    0.207977] Call Trace:
> > [    0.207977]  [<ffffffff81087189>] ? worker_enter_idle+0x2b8/0x32b
> > [    0.207977]  [<ffffffff810559d9>] warn_slowpath_common+0xae/0xdb
> > [    0.207977]  [<ffffffff81055a2e>] warn_slowpath_null+0x28/0x31
> > [    0.207977]  [<ffffffff81087189>] worker_enter_idle+0x2b8/0x32b
> > [    0.207977]  [<ffffffff81087222>] start_worker+0x26/0x42
> > [    0.207977]  [<ffffffff81c8b261>] init_workqueues+0x2d2/0x59a
> > [    0.207977]  [<ffffffff81c8af8f>] ? usermodehelper_init+0x8a/0x8a
> > [    0.207977]  [<ffffffff81000284>] do_one_initcall+0xce/0x272
> > [    0.207977]  [<ffffffff81c6f650>] kernel_init+0x12e/0x3c1
> > [    0.207977]  [<ffffffff814b9b74>] kernel_thread_helper+0x4/0x10
> > [    0.207977]  [<ffffffff814b80b0>] ? retint_restore_args+0x13/0x13
> > [    0.207977]  [<ffffffff81c6f522>] ? start_kernel+0x737/0x737
> > [    0.207977]  [<ffffffff814b9b70>] ? gs_change+0x13/0x13
> 
> Yeah, I forgot to flip the WARN_ON_ONCE() condition so that it checks
> nr_running before looking at pool->nr_running.  The warning is
> spurious.  Will post fix soon.

I was wrong and am now dazed and confused.  That's from
init_workqueues() where only cpu0 is running.  How the hell did
nr_running manage to become non-zero at that point?  Can you please
apply the following patch and report the boot log?  Thank you.

---
 kernel/workqueue.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -699,8 +699,10 @@ void wq_worker_waking_up(struct task_str
 {
 	struct worker *worker = kthread_data(task);
 
-	if (!(worker->flags & WORKER_NOT_RUNNING))
+	if (!(worker->flags & WORKER_NOT_RUNNING)) {
+		WARN_ON_ONCE(cpu != worker->pool->gcwq->cpu);
 		atomic_inc(get_pool_nr_running(worker->pool));
+	}
 }
 
 /**
@@ -730,6 +732,7 @@ struct task_struct *wq_worker_sleeping(s
 
 	/* this can only happen on the local cpu */
 	BUG_ON(cpu != raw_smp_processor_id());
+	WARN_ON_ONCE(cpu != worker->pool->gcwq->cpu);
 
 	/*
 	 * The counterpart of the following dec_and_test, implied mb,
@@ -3855,6 +3858,10 @@ static int __init init_workqueues(void)
 		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)
 			INIT_HLIST_HEAD(&gcwq->busy_hash[i]);
 
+		if (cpu != WORK_CPU_UNBOUND)
+			printk("XXX cpu=%d gcwq=%p base=%p\n", cpu, gcwq,
+			       per_cpu_ptr(&pool_nr_running, cpu));
+
 		for_each_worker_pool(pool, gcwq) {
 			pool->gcwq = gcwq;
 			INIT_LIST_HEAD(&pool->worklist);
@@ -3868,6 +3875,10 @@ static int __init init_workqueues(void)
 				    (unsigned long)pool);
 
 			ida_init(&pool->worker_ida);
+
+			printk("XXX cpu=%d nr_running=%d @ %p\n", gcwq->cpu,
+			       atomic_read(get_pool_nr_running(pool)),
+			       get_pool_nr_running(pool));
 		}
 
 		gcwq->trustee_state = TRUSTEE_DONE;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
