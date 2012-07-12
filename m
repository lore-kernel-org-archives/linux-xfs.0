Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6CMWRJ6086239 for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 17:32:27 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id bZN9G6o81ZlQGBc4
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Jul 2012 15:32:26 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so5463173pbb.26
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 15:32:26 -0700 (PDT)
Date: Thu, 12 Jul 2012 15:32:21 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate
	worker_pool
Message-ID: <20120712223221.GF20167@google.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
	<20120712130648.GA19214@localhost>
	<20120712170519.GA20167@google.com>
	<20120712214514.GD20167@google.com>
	<CA+8MBb+ghRpmtrk=t5-6MqrPMZt+a69UoAWaubyKBeptGdBrWA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+8MBb+ghRpmtrk=t5-6MqrPMZt+a69UoAWaubyKBeptGdBrWA@mail.gmail.com>
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
To: Tony Luck <tony.luck@gmail.com>
Cc: axboe@kernel.dk, xfs@oss.sgi.com, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, gustavo@padovan.org, Fengguang Wu <fengguang.wu@intel.com>, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Hello, Tony.

On Thu, Jul 12, 2012 at 03:16:30PM -0700, Tony Luck wrote:
> On Thu, Jul 12, 2012 at 2:45 PM, Tejun Heo <tj@kernel.org> wrote:
> > I was wrong and am now dazed and confused.  That's from
> > init_workqueues() where only cpu0 is running.  How the hell did
> > nr_running manage to become non-zero at that point?  Can you please
> > apply the following patch and report the boot log?  Thank you.
> 
> Patch applied on top of next-20120712 (which still has the same problem).

Can you please try the following debug patch instead?  Yours is
different from Fengguang's.

Thanks a lot!
---
 kernel/workqueue.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

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
@@ -1212,9 +1215,30 @@ static void worker_enter_idle(struct wor
 	 * between setting %WORKER_ROGUE and zapping nr_running, the
 	 * warning may trigger spuriously.  Check iff trustee is idle.
 	 */
-	WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
-		     pool->nr_workers == pool->nr_idle &&
-		     atomic_read(get_pool_nr_running(pool)));
+	if (WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
+			 pool->nr_workers == pool->nr_idle &&
+			 atomic_read(get_pool_nr_running(pool)))) {
+		static bool once = false;
+		int cpu;
+
+		if (once)
+			return;
+		once = true;
+
+		printk("XXX nr_running mismatch on gcwq[%d] pool[%ld]\n",
+		       gcwq->cpu, pool - gcwq->pools);
+
+		for_each_gcwq_cpu(cpu) {
+			gcwq = get_gcwq(cpu);
+
+			printk("XXX gcwq[%d] flags=0x%x\n", gcwq->cpu, gcwq->flags);
+			for_each_worker_pool(pool, gcwq)
+				printk("XXX gcwq[%d] pool[%ld] nr_workers=%d nr_idle=%d nr_running=%d\n",
+				       gcwq->cpu, pool - gcwq->pools,
+				       pool->nr_workers, pool->nr_idle,
+				       atomic_read(get_pool_nr_running(pool)));
+		}
+	}
 }
 
 /**
@@ -3855,6 +3879,10 @@ static int __init init_workqueues(void)
 		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)
 			INIT_HLIST_HEAD(&gcwq->busy_hash[i]);
 
+		if (cpu != WORK_CPU_UNBOUND)
+			printk("XXX cpu=%d gcwq=%p base=%p\n", cpu, gcwq,
+			       per_cpu_ptr(&pool_nr_running, cpu));
+
 		for_each_worker_pool(pool, gcwq) {
 			pool->gcwq = gcwq;
 			INIT_LIST_HEAD(&pool->worklist);
@@ -3868,6 +3896,10 @@ static int __init init_workqueues(void)
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
