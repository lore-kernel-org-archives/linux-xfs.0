Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6E5LuvK234545 for <xfs@oss.sgi.com>; Sat, 14 Jul 2012 00:21:56 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id lBtCDajpPKZxpbtr
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Jul 2012 22:21:54 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so8239109pbb.26
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 22:21:53 -0700 (PDT)
Date: Fri, 13 Jul 2012 22:21:48 -0700
From: Tejun Heo <tj@kernel.org>
Subject: [PATCH UPDATED 5/6] workqueue: introduce NR_WORKER_POOLS and
	for_each_worker_pool()
Message-ID: <20120714052148.GC7718@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1341859315-17759-6-git-send-email-tj@kernel.org>
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
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, gustavo@padovan.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

>From 4ce62e9e30cacc26885cab133ad1de358dd79f21 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 13 Jul 2012 22:16:44 -0700

Introduce NR_WORKER_POOLS and for_each_worker_pool() and convert code
paths which need to manipulate all pools in a gcwq to use them.
NR_WORKER_POOLS is currently one and for_each_worker_pool() iterates
over only @gcwq->pool.

Note that nr_running is per-pool property and converted to an array
with NR_WORKER_POOLS elements and renamed to pool_nr_running.  Note
that get_pool_nr_running() currently assumes 0 index.  The next patch
will make use of non-zero index.

The changes in this patch are mechanical and don't caues any
functional difference.  This is to prepare for multiple pools per
gcwq.

v2: nr_running indexing bug in get_pool_nr_running() fixed.

v3: Pointer to array is stupid.  Don't use it in get_pool_nr_running()
    as suggested by Linus.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
So, the same 0 index silliness but this shouldn't be as fugly.

Thanks.

 kernel/workqueue.c |  223 +++++++++++++++++++++++++++++++++++----------------
 1 files changed, 153 insertions(+), 70 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7a98bae..b0daaea 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -74,6 +74,8 @@ enum {
 	TRUSTEE_RELEASE		= 3,		/* release workers */
 	TRUSTEE_DONE		= 4,		/* trustee is done */
 
+	NR_WORKER_POOLS		= 1,		/* # worker pools per gcwq */
+
 	BUSY_WORKER_HASH_ORDER	= 6,		/* 64 pointers */
 	BUSY_WORKER_HASH_SIZE	= 1 << BUSY_WORKER_HASH_ORDER,
 	BUSY_WORKER_HASH_MASK	= BUSY_WORKER_HASH_SIZE - 1,
@@ -274,6 +276,9 @@ EXPORT_SYMBOL_GPL(system_nrt_freezable_wq);
 #define CREATE_TRACE_POINTS
 #include <trace/events/workqueue.h>
 
+#define for_each_worker_pool(pool, gcwq)				\
+	for ((pool) = &(gcwq)->pool; (pool); (pool) = NULL)
+
 #define for_each_busy_worker(worker, i, pos, gcwq)			\
 	for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)			\
 		hlist_for_each_entry(worker, pos, &gcwq->busy_hash[i], hentry)
@@ -454,7 +459,7 @@ static bool workqueue_freezing;		/* W: have wqs started freezing? */
  * try_to_wake_up().  Put it in a separate cacheline.
  */
 static DEFINE_PER_CPU(struct global_cwq, global_cwq);
-static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, gcwq_nr_running);
+static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, pool_nr_running[NR_WORKER_POOLS]);
 
 /*
  * Global cpu workqueue and nr_running counter for unbound gcwq.  The
@@ -462,7 +467,9 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, gcwq_nr_running);
  * workers have WORKER_UNBOUND set.
  */
 static struct global_cwq unbound_global_cwq;
-static atomic_t unbound_gcwq_nr_running = ATOMIC_INIT(0);	/* always 0 */
+static atomic_t unbound_pool_nr_running[NR_WORKER_POOLS] = {
+	[0 ... NR_WORKER_POOLS - 1]	= ATOMIC_INIT(0),	/* always 0 */
+};
 
 static int worker_thread(void *__worker);
 
@@ -477,11 +484,12 @@ static struct global_cwq *get_gcwq(unsigned int cpu)
 static atomic_t *get_pool_nr_running(struct worker_pool *pool)
 {
 	int cpu = pool->gcwq->cpu;
+	int idx = 0;
 
 	if (cpu != WORK_CPU_UNBOUND)
-		return &per_cpu(gcwq_nr_running, cpu);
+		return &per_cpu(pool_nr_running, cpu)[idx];
 	else
-		return &unbound_gcwq_nr_running;
+		return &unbound_pool_nr_running[idx];
 }
 
 static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
@@ -3345,9 +3353,30 @@ EXPORT_SYMBOL_GPL(work_busy);
 	__ret1 < 0 ? -1 : 0;						\
 })
 
+static bool gcwq_is_managing_workers(struct global_cwq *gcwq)
+{
+	struct worker_pool *pool;
+
+	for_each_worker_pool(pool, gcwq)
+		if (pool->flags & POOL_MANAGING_WORKERS)
+			return true;
+	return false;
+}
+
+static bool gcwq_has_idle_workers(struct global_cwq *gcwq)
+{
+	struct worker_pool *pool;
+
+	for_each_worker_pool(pool, gcwq)
+		if (!list_empty(&pool->idle_list))
+			return true;
+	return false;
+}
+
 static int __cpuinit trustee_thread(void *__gcwq)
 {
 	struct global_cwq *gcwq = __gcwq;
+	struct worker_pool *pool;
 	struct worker *worker;
 	struct work_struct *work;
 	struct hlist_node *pos;
@@ -3363,13 +3392,15 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	 * cancelled.
 	 */
 	BUG_ON(gcwq->cpu != smp_processor_id());
-	rc = trustee_wait_event(!(gcwq->pool.flags & POOL_MANAGING_WORKERS));
+	rc = trustee_wait_event(!gcwq_is_managing_workers(gcwq));
 	BUG_ON(rc < 0);
 
-	gcwq->pool.flags |= POOL_MANAGING_WORKERS;
+	for_each_worker_pool(pool, gcwq) {
+		pool->flags |= POOL_MANAGING_WORKERS;
 
-	list_for_each_entry(worker, &gcwq->pool.idle_list, entry)
-		worker->flags |= WORKER_ROGUE;
+		list_for_each_entry(worker, &pool->idle_list, entry)
+			worker->flags |= WORKER_ROGUE;
+	}
 
 	for_each_busy_worker(worker, i, pos, gcwq)
 		worker->flags |= WORKER_ROGUE;
@@ -3390,10 +3421,12 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	 * keep_working() are always true as long as the worklist is
 	 * not empty.
 	 */
-	atomic_set(get_pool_nr_running(&gcwq->pool), 0);
+	for_each_worker_pool(pool, gcwq)
+		atomic_set(get_pool_nr_running(pool), 0);
 
 	spin_unlock_irq(&gcwq->lock);
-	del_timer_sync(&gcwq->pool.idle_timer);
+	for_each_worker_pool(pool, gcwq)
+		del_timer_sync(&pool->idle_timer);
 	spin_lock_irq(&gcwq->lock);
 
 	/*
@@ -3415,29 +3448,38 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	 * may be frozen works in freezable cwqs.  Don't declare
 	 * completion while frozen.
 	 */
-	while (gcwq->pool.nr_workers != gcwq->pool.nr_idle ||
-	       gcwq->flags & GCWQ_FREEZING ||
-	       gcwq->trustee_state == TRUSTEE_IN_CHARGE) {
-		int nr_works = 0;
+	while (true) {
+		bool busy = false;
 
-		list_for_each_entry(work, &gcwq->pool.worklist, entry) {
-			send_mayday(work);
-			nr_works++;
-		}
+		for_each_worker_pool(pool, gcwq)
+			busy |= pool->nr_workers != pool->nr_idle;
 
-		list_for_each_entry(worker, &gcwq->pool.idle_list, entry) {
-			if (!nr_works--)
-				break;
-			wake_up_process(worker->task);
-		}
+		if (!busy && !(gcwq->flags & GCWQ_FREEZING) &&
+		    gcwq->trustee_state != TRUSTEE_IN_CHARGE)
+			break;
 
-		if (need_to_create_worker(&gcwq->pool)) {
-			spin_unlock_irq(&gcwq->lock);
-			worker = create_worker(&gcwq->pool, false);
-			spin_lock_irq(&gcwq->lock);
-			if (worker) {
-				worker->flags |= WORKER_ROGUE;
-				start_worker(worker);
+		for_each_worker_pool(pool, gcwq) {
+			int nr_works = 0;
+
+			list_for_each_entry(work, &pool->worklist, entry) {
+				send_mayday(work);
+				nr_works++;
+			}
+
+			list_for_each_entry(worker, &pool->idle_list, entry) {
+				if (!nr_works--)
+					break;
+				wake_up_process(worker->task);
+			}
+
+			if (need_to_create_worker(pool)) {
+				spin_unlock_irq(&gcwq->lock);
+				worker = create_worker(pool, false);
+				spin_lock_irq(&gcwq->lock);
+				if (worker) {
+					worker->flags |= WORKER_ROGUE;
+					start_worker(worker);
+				}
 			}
 		}
 
@@ -3452,11 +3494,18 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	 * all workers till we're canceled.
 	 */
 	do {
-		rc = trustee_wait_event(!list_empty(&gcwq->pool.idle_list));
-		while (!list_empty(&gcwq->pool.idle_list))
-			destroy_worker(list_first_entry(&gcwq->pool.idle_list,
-							struct worker, entry));
-	} while (gcwq->pool.nr_workers && rc >= 0);
+		rc = trustee_wait_event(gcwq_has_idle_workers(gcwq));
+
+		i = 0;
+		for_each_worker_pool(pool, gcwq) {
+			while (!list_empty(&pool->idle_list)) {
+				worker = list_first_entry(&pool->idle_list,
+							  struct worker, entry);
+				destroy_worker(worker);
+			}
+			i |= pool->nr_workers;
+		}
+	} while (i && rc >= 0);
 
 	/*
 	 * At this point, either draining has completed and no worker
@@ -3465,7 +3514,8 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	 * Tell the remaining busy ones to rebind once it finishes the
 	 * currently scheduled works by scheduling the rebind_work.
 	 */
-	WARN_ON(!list_empty(&gcwq->pool.idle_list));
+	for_each_worker_pool(pool, gcwq)
+		WARN_ON(!list_empty(&pool->idle_list));
 
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
@@ -3490,7 +3540,8 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	}
 
 	/* relinquish manager role */
-	gcwq->pool.flags &= ~POOL_MANAGING_WORKERS;
+	for_each_worker_pool(pool, gcwq)
+		pool->flags &= ~POOL_MANAGING_WORKERS;
 
 	/* notify completion */
 	gcwq->trustee = NULL;
@@ -3532,8 +3583,10 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 	unsigned int cpu = (unsigned long)hcpu;
 	struct global_cwq *gcwq = get_gcwq(cpu);
 	struct task_struct *new_trustee = NULL;
-	struct worker *uninitialized_var(new_worker);
+	struct worker *new_workers[NR_WORKER_POOLS] = { };
+	struct worker_pool *pool;
 	unsigned long flags;
+	int i;
 
 	action &= ~CPU_TASKS_FROZEN;
 
@@ -3546,12 +3599,12 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		kthread_bind(new_trustee, cpu);
 		/* fall through */
 	case CPU_UP_PREPARE:
-		BUG_ON(gcwq->pool.first_idle);
-		new_worker = create_worker(&gcwq->pool, false);
-		if (!new_worker) {
-			if (new_trustee)
-				kthread_stop(new_trustee);
-			return NOTIFY_BAD;
+		i = 0;
+		for_each_worker_pool(pool, gcwq) {
+			BUG_ON(pool->first_idle);
+			new_workers[i] = create_worker(pool, false);
+			if (!new_workers[i++])
+				goto err_destroy;
 		}
 	}
 
@@ -3568,8 +3621,11 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		wait_trustee_state(gcwq, TRUSTEE_IN_CHARGE);
 		/* fall through */
 	case CPU_UP_PREPARE:
-		BUG_ON(gcwq->pool.first_idle);
-		gcwq->pool.first_idle = new_worker;
+		i = 0;
+		for_each_worker_pool(pool, gcwq) {
+			BUG_ON(pool->first_idle);
+			pool->first_idle = new_workers[i++];
+		}
 		break;
 
 	case CPU_DYING:
@@ -3586,8 +3642,10 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		gcwq->trustee_state = TRUSTEE_BUTCHER;
 		/* fall through */
 	case CPU_UP_CANCELED:
-		destroy_worker(gcwq->pool.first_idle);
-		gcwq->pool.first_idle = NULL;
+		for_each_worker_pool(pool, gcwq) {
+			destroy_worker(pool->first_idle);
+			pool->first_idle = NULL;
+		}
 		break;
 
 	case CPU_DOWN_FAILED:
@@ -3604,18 +3662,32 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		 * Put the first_idle in and request a real manager to
 		 * take a look.
 		 */
-		spin_unlock_irq(&gcwq->lock);
-		kthread_bind(gcwq->pool.first_idle->task, cpu);
-		spin_lock_irq(&gcwq->lock);
-		gcwq->pool.flags |= POOL_MANAGE_WORKERS;
-		start_worker(gcwq->pool.first_idle);
-		gcwq->pool.first_idle = NULL;
+		for_each_worker_pool(pool, gcwq) {
+			spin_unlock_irq(&gcwq->lock);
+			kthread_bind(pool->first_idle->task, cpu);
+			spin_lock_irq(&gcwq->lock);
+			pool->flags |= POOL_MANAGE_WORKERS;
+			start_worker(pool->first_idle);
+			pool->first_idle = NULL;
+		}
 		break;
 	}
 
 	spin_unlock_irqrestore(&gcwq->lock, flags);
 
 	return notifier_from_errno(0);
+
+err_destroy:
+	if (new_trustee)
+		kthread_stop(new_trustee);
+
+	spin_lock_irqsave(&gcwq->lock, flags);
+	for (i = 0; i < NR_WORKER_POOLS; i++)
+		if (new_workers[i])
+			destroy_worker(new_workers[i]);
+	spin_unlock_irqrestore(&gcwq->lock, flags);
+
+	return NOTIFY_BAD;
 }
 
 #ifdef CONFIG_SMP
@@ -3774,6 +3846,7 @@ void thaw_workqueues(void)
 
 	for_each_gcwq_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct worker_pool *pool;
 		struct workqueue_struct *wq;
 
 		spin_lock_irq(&gcwq->lock);
@@ -3795,7 +3868,8 @@ void thaw_workqueues(void)
 				cwq_activate_first_delayed(cwq);
 		}
 
-		wake_up_worker(&gcwq->pool);
+		for_each_worker_pool(pool, gcwq)
+			wake_up_worker(pool);
 
 		spin_unlock_irq(&gcwq->lock);
 	}
@@ -3816,25 +3890,29 @@ static int __init init_workqueues(void)
 	/* initialize gcwqs */
 	for_each_gcwq_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct worker_pool *pool;
 
 		spin_lock_init(&gcwq->lock);
-		gcwq->pool.gcwq = gcwq;
-		INIT_LIST_HEAD(&gcwq->pool.worklist);
 		gcwq->cpu = cpu;
 		gcwq->flags |= GCWQ_DISASSOCIATED;
 
-		INIT_LIST_HEAD(&gcwq->pool.idle_list);
 		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)
 			INIT_HLIST_HEAD(&gcwq->busy_hash[i]);
 
-		init_timer_deferrable(&gcwq->pool.idle_timer);
-		gcwq->pool.idle_timer.function = idle_worker_timeout;
-		gcwq->pool.idle_timer.data = (unsigned long)&gcwq->pool;
+		for_each_worker_pool(pool, gcwq) {
+			pool->gcwq = gcwq;
+			INIT_LIST_HEAD(&pool->worklist);
+			INIT_LIST_HEAD(&pool->idle_list);
 
-		setup_timer(&gcwq->pool.mayday_timer, gcwq_mayday_timeout,
-			    (unsigned long)&gcwq->pool);
+			init_timer_deferrable(&pool->idle_timer);
+			pool->idle_timer.function = idle_worker_timeout;
+			pool->idle_timer.data = (unsigned long)pool;
 
-		ida_init(&gcwq->pool.worker_ida);
+			setup_timer(&pool->mayday_timer, gcwq_mayday_timeout,
+				    (unsigned long)pool);
+
+			ida_init(&pool->worker_ida);
+		}
 
 		gcwq->trustee_state = TRUSTEE_DONE;
 		init_waitqueue_head(&gcwq->trustee_wait);
@@ -3843,15 +3921,20 @@ static int __init init_workqueues(void)
 	/* create the initial worker */
 	for_each_online_gcwq_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
-		struct worker *worker;
+		struct worker_pool *pool;
 
 		if (cpu != WORK_CPU_UNBOUND)
 			gcwq->flags &= ~GCWQ_DISASSOCIATED;
-		worker = create_worker(&gcwq->pool, true);
-		BUG_ON(!worker);
-		spin_lock_irq(&gcwq->lock);
-		start_worker(worker);
-		spin_unlock_irq(&gcwq->lock);
+
+		for_each_worker_pool(pool, gcwq) {
+			struct worker *worker;
+
+			worker = create_worker(pool, true);
+			BUG_ON(!worker);
+			spin_lock_irq(&gcwq->lock);
+			start_worker(worker);
+			spin_unlock_irq(&gcwq->lock);
+		}
 	}
 
 	system_wq = alloc_workqueue("events", 0, 0);
-- 
1.7.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
