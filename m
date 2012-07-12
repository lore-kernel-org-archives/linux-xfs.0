Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6CLnxl8082279 for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 16:49:59 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id uQc1vFm6ktVCUBCu
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Jul 2012 14:49:57 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so5397558pbb.26
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 14:49:57 -0700 (PDT)
Date: Thu, 12 Jul 2012 14:49:52 -0700
From: Tejun Heo <tj@kernel.org>
Subject: [PATCH UPDATED 2/6] workqueue: factor out worker_pool from global_cwq
Message-ID: <20120712214952.GE20167@google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1341859315-17759-3-git-send-email-tj@kernel.org>
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

>From bd7bdd43dcb81bb08240b9401b36a104f77dc135 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 12 Jul 2012 14:46:37 -0700

Move worklist and all worker management fields from global_cwq into
the new struct worker_pool.  worker_pool points back to the containing
gcwq.  worker and cpu_workqueue_struct are updated to point to
worker_pool instead of gcwq too.

This change is mechanical and doesn't introduce any functional
difference other than rearranging of fields and an added level of
indirection in some places.  This is to prepare for multiple pools per
gcwq.

v2: Comment typo fixes as suggested by Namhyung.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
---
Minor update.  git branches updated accoringly.  Thanks.

 include/trace/events/workqueue.h |    2 +-
 kernel/workqueue.c               |  216 ++++++++++++++++++++-----------------
 2 files changed, 118 insertions(+), 100 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index 4018f50..f28d1b6 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -54,7 +54,7 @@ TRACE_EVENT(workqueue_queue_work,
 		__entry->function	= work->func;
 		__entry->workqueue	= cwq->wq;
 		__entry->req_cpu	= req_cpu;
-		__entry->cpu		= cwq->gcwq->cpu;
+		__entry->cpu		= cwq->pool->gcwq->cpu;
 	),
 
 	TP_printk("work struct=%p function=%pf workqueue=%p req_cpu=%u cpu=%u",
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 27637c2..61f1544 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -115,6 +115,7 @@ enum {
  */
 
 struct global_cwq;
+struct worker_pool;
 
 /*
  * The poor guys doing the actual heavy lifting.  All on-duty workers
@@ -131,7 +132,7 @@ struct worker {
 	struct cpu_workqueue_struct *current_cwq; /* L: current_work's cwq */
 	struct list_head	scheduled;	/* L: scheduled works */
 	struct task_struct	*task;		/* I: worker task */
-	struct global_cwq	*gcwq;		/* I: the associated gcwq */
+	struct worker_pool	*pool;		/* I: the associated pool */
 	/* 64 bytes boundary on 64bit, 32 on 32bit */
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
@@ -139,6 +140,21 @@ struct worker {
 	struct work_struct	rebind_work;	/* L: rebind worker to cpu */
 };
 
+struct worker_pool {
+	struct global_cwq	*gcwq;		/* I: the owning gcwq */
+
+	struct list_head	worklist;	/* L: list of pending works */
+	int			nr_workers;	/* L: total number of workers */
+	int			nr_idle;	/* L: currently idle ones */
+
+	struct list_head	idle_list;	/* X: list of idle workers */
+	struct timer_list	idle_timer;	/* L: worker idle timeout */
+	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
+
+	struct ida		worker_ida;	/* L: for worker IDs */
+	struct worker		*first_idle;	/* L: first idle worker */
+};
+
 /*
  * Global per-cpu workqueue.  There's one and only one for each cpu
  * and all works are queued and processed here regardless of their
@@ -146,27 +162,18 @@ struct worker {
  */
 struct global_cwq {
 	spinlock_t		lock;		/* the gcwq lock */
-	struct list_head	worklist;	/* L: list of pending works */
 	unsigned int		cpu;		/* I: the associated cpu */
 	unsigned int		flags;		/* L: GCWQ_* flags */
 
-	int			nr_workers;	/* L: total number of workers */
-	int			nr_idle;	/* L: currently idle ones */
-
-	/* workers are chained either in the idle_list or busy_hash */
-	struct list_head	idle_list;	/* X: list of idle workers */
+	/* workers are chained either in busy_hash or pool idle_list */
 	struct hlist_head	busy_hash[BUSY_WORKER_HASH_SIZE];
 						/* L: hash of busy workers */
 
-	struct timer_list	idle_timer;	/* L: worker idle timeout */
-	struct timer_list	mayday_timer;	/* L: SOS timer for dworkers */
-
-	struct ida		worker_ida;	/* L: for worker IDs */
+	struct worker_pool	pool;		/* the worker pools */
 
 	struct task_struct	*trustee;	/* L: for gcwq shutdown */
 	unsigned int		trustee_state;	/* L: trustee state */
 	wait_queue_head_t	trustee_wait;	/* trustee wait */
-	struct worker		*first_idle;	/* L: first idle worker */
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -175,7 +182,7 @@ struct global_cwq {
  * aligned at two's power of the number of flag bits.
  */
 struct cpu_workqueue_struct {
-	struct global_cwq	*gcwq;		/* I: the associated gcwq */
+	struct worker_pool	*pool;		/* I: the associated pool */
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	int			work_color;	/* L: current color */
 	int			flush_color;	/* L: flushing color */
@@ -555,7 +562,7 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
 
 	if (data & WORK_STRUCT_CWQ)
 		return ((struct cpu_workqueue_struct *)
-			(data & WORK_STRUCT_WQ_DATA_MASK))->gcwq;
+			(data & WORK_STRUCT_WQ_DATA_MASK))->pool->gcwq;
 
 	cpu = data >> WORK_STRUCT_FLAG_BITS;
 	if (cpu == WORK_CPU_NONE)
@@ -587,13 +594,13 @@ static bool __need_more_worker(struct global_cwq *gcwq)
  */
 static bool need_more_worker(struct global_cwq *gcwq)
 {
-	return !list_empty(&gcwq->worklist) && __need_more_worker(gcwq);
+	return !list_empty(&gcwq->pool.worklist) && __need_more_worker(gcwq);
 }
 
 /* Can I start working?  Called from busy but !running workers. */
 static bool may_start_working(struct global_cwq *gcwq)
 {
-	return gcwq->nr_idle;
+	return gcwq->pool.nr_idle;
 }
 
 /* Do I need to keep working?  Called from currently running workers. */
@@ -601,7 +608,7 @@ static bool keep_working(struct global_cwq *gcwq)
 {
 	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
 
-	return !list_empty(&gcwq->worklist) &&
+	return !list_empty(&gcwq->pool.worklist) &&
 		(atomic_read(nr_running) <= 1 ||
 		 gcwq->flags & GCWQ_HIGHPRI_PENDING);
 }
@@ -622,8 +629,8 @@ static bool need_to_manage_workers(struct global_cwq *gcwq)
 static bool too_many_workers(struct global_cwq *gcwq)
 {
 	bool managing = gcwq->flags & GCWQ_MANAGING_WORKERS;
-	int nr_idle = gcwq->nr_idle + managing; /* manager is considered idle */
-	int nr_busy = gcwq->nr_workers - nr_idle;
+	int nr_idle = gcwq->pool.nr_idle + managing; /* manager is considered idle */
+	int nr_busy = gcwq->pool.nr_workers - nr_idle;
 
 	return nr_idle > 2 && (nr_idle - 2) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
 }
@@ -635,10 +642,10 @@ static bool too_many_workers(struct global_cwq *gcwq)
 /* Return the first worker.  Safe with preemption disabled */
 static struct worker *first_worker(struct global_cwq *gcwq)
 {
-	if (unlikely(list_empty(&gcwq->idle_list)))
+	if (unlikely(list_empty(&gcwq->pool.idle_list)))
 		return NULL;
 
-	return list_first_entry(&gcwq->idle_list, struct worker, entry);
+	return list_first_entry(&gcwq->pool.idle_list, struct worker, entry);
 }
 
 /**
@@ -696,7 +703,8 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 				       unsigned int cpu)
 {
 	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
-	struct global_cwq *gcwq = get_gcwq(cpu);
+	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 	atomic_t *nr_running = get_gcwq_nr_running(cpu);
 
 	if (worker->flags & WORKER_NOT_RUNNING)
@@ -716,7 +724,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 	 * could be manipulating idle_list, so dereferencing idle_list
 	 * without gcwq lock is safe.
 	 */
-	if (atomic_dec_and_test(nr_running) && !list_empty(&gcwq->worklist))
+	if (atomic_dec_and_test(nr_running) && !list_empty(&pool->worklist))
 		to_wakeup = first_worker(gcwq);
 	return to_wakeup ? to_wakeup->task : NULL;
 }
@@ -737,7 +745,8 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 static inline void worker_set_flags(struct worker *worker, unsigned int flags,
 				    bool wakeup)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 
 	WARN_ON_ONCE(worker->task != current);
 
@@ -752,7 +761,7 @@ static inline void worker_set_flags(struct worker *worker, unsigned int flags,
 
 		if (wakeup) {
 			if (atomic_dec_and_test(nr_running) &&
-			    !list_empty(&gcwq->worklist))
+			    !list_empty(&pool->worklist))
 				wake_up_worker(gcwq);
 		} else
 			atomic_dec(nr_running);
@@ -773,7 +782,7 @@ static inline void worker_set_flags(struct worker *worker, unsigned int flags,
  */
 static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct global_cwq *gcwq = worker->pool->gcwq;
 	unsigned int oflags = worker->flags;
 
 	WARN_ON_ONCE(worker->task != current);
@@ -894,9 +903,9 @@ static inline struct list_head *gcwq_determine_ins_pos(struct global_cwq *gcwq,
 	struct work_struct *twork;
 
 	if (likely(!(cwq->wq->flags & WQ_HIGHPRI)))
-		return &gcwq->worklist;
+		return &gcwq->pool.worklist;
 
-	list_for_each_entry(twork, &gcwq->worklist, entry) {
+	list_for_each_entry(twork, &gcwq->pool.worklist, entry) {
 		struct cpu_workqueue_struct *tcwq = get_work_cwq(twork);
 
 		if (!(tcwq->wq->flags & WQ_HIGHPRI))
@@ -924,7 +933,7 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head,
 			unsigned int extra_flags)
 {
-	struct global_cwq *gcwq = cwq->gcwq;
+	struct global_cwq *gcwq = cwq->pool->gcwq;
 
 	/* we own @work, set data and link */
 	set_work_cwq(work, cwq, extra_flags);
@@ -1196,7 +1205,8 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on);
  */
 static void worker_enter_idle(struct worker *worker)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 
 	BUG_ON(worker->flags & WORKER_IDLE);
 	BUG_ON(!list_empty(&worker->entry) &&
@@ -1204,15 +1214,15 @@ static void worker_enter_idle(struct worker *worker)
 
 	/* can't use worker_set_flags(), also called from start_worker() */
 	worker->flags |= WORKER_IDLE;
-	gcwq->nr_idle++;
+	pool->nr_idle++;
 	worker->last_active = jiffies;
 
 	/* idle_list is LIFO */
-	list_add(&worker->entry, &gcwq->idle_list);
+	list_add(&worker->entry, &pool->idle_list);
 
 	if (likely(!(worker->flags & WORKER_ROGUE))) {
-		if (too_many_workers(gcwq) && !timer_pending(&gcwq->idle_timer))
-			mod_timer(&gcwq->idle_timer,
+		if (too_many_workers(gcwq) && !timer_pending(&pool->idle_timer))
+			mod_timer(&pool->idle_timer,
 				  jiffies + IDLE_WORKER_TIMEOUT);
 	} else
 		wake_up_all(&gcwq->trustee_wait);
@@ -1223,7 +1233,7 @@ static void worker_enter_idle(struct worker *worker)
 	 * warning may trigger spuriously.  Check iff trustee is idle.
 	 */
 	WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
-		     gcwq->nr_workers == gcwq->nr_idle &&
+		     pool->nr_workers == pool->nr_idle &&
 		     atomic_read(get_gcwq_nr_running(gcwq->cpu)));
 }
 
@@ -1238,11 +1248,11 @@ static void worker_enter_idle(struct worker *worker)
  */
 static void worker_leave_idle(struct worker *worker)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct worker_pool *pool = worker->pool;
 
 	BUG_ON(!(worker->flags & WORKER_IDLE));
 	worker_clr_flags(worker, WORKER_IDLE);
-	gcwq->nr_idle--;
+	pool->nr_idle--;
 	list_del_init(&worker->entry);
 }
 
@@ -1279,7 +1289,7 @@ static void worker_leave_idle(struct worker *worker)
 static bool worker_maybe_bind_and_lock(struct worker *worker)
 __acquires(&gcwq->lock)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct global_cwq *gcwq = worker->pool->gcwq;
 	struct task_struct *task = worker->task;
 
 	while (true) {
@@ -1321,7 +1331,7 @@ __acquires(&gcwq->lock)
 static void worker_rebind_fn(struct work_struct *work)
 {
 	struct worker *worker = container_of(work, struct worker, rebind_work);
-	struct global_cwq *gcwq = worker->gcwq;
+	struct global_cwq *gcwq = worker->pool->gcwq;
 
 	if (worker_maybe_bind_and_lock(worker))
 		worker_clr_flags(worker, WORKER_REBIND);
@@ -1362,13 +1372,14 @@ static struct worker *alloc_worker(void)
 static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
 {
 	bool on_unbound_cpu = gcwq->cpu == WORK_CPU_UNBOUND;
+	struct worker_pool *pool = &gcwq->pool;
 	struct worker *worker = NULL;
 	int id = -1;
 
 	spin_lock_irq(&gcwq->lock);
-	while (ida_get_new(&gcwq->worker_ida, &id)) {
+	while (ida_get_new(&pool->worker_ida, &id)) {
 		spin_unlock_irq(&gcwq->lock);
-		if (!ida_pre_get(&gcwq->worker_ida, GFP_KERNEL))
+		if (!ida_pre_get(&pool->worker_ida, GFP_KERNEL))
 			goto fail;
 		spin_lock_irq(&gcwq->lock);
 	}
@@ -1378,7 +1389,7 @@ static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
 	if (!worker)
 		goto fail;
 
-	worker->gcwq = gcwq;
+	worker->pool = pool;
 	worker->id = id;
 
 	if (!on_unbound_cpu)
@@ -1409,7 +1420,7 @@ static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
 fail:
 	if (id >= 0) {
 		spin_lock_irq(&gcwq->lock);
-		ida_remove(&gcwq->worker_ida, id);
+		ida_remove(&pool->worker_ida, id);
 		spin_unlock_irq(&gcwq->lock);
 	}
 	kfree(worker);
@@ -1428,7 +1439,7 @@ fail:
 static void start_worker(struct worker *worker)
 {
 	worker->flags |= WORKER_STARTED;
-	worker->gcwq->nr_workers++;
+	worker->pool->nr_workers++;
 	worker_enter_idle(worker);
 	wake_up_process(worker->task);
 }
@@ -1444,7 +1455,8 @@ static void start_worker(struct worker *worker)
  */
 static void destroy_worker(struct worker *worker)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 	int id = worker->id;
 
 	/* sanity check frenzy */
@@ -1452,9 +1464,9 @@ static void destroy_worker(struct worker *worker)
 	BUG_ON(!list_empty(&worker->scheduled));
 
 	if (worker->flags & WORKER_STARTED)
-		gcwq->nr_workers--;
+		pool->nr_workers--;
 	if (worker->flags & WORKER_IDLE)
-		gcwq->nr_idle--;
+		pool->nr_idle--;
 
 	list_del_init(&worker->entry);
 	worker->flags |= WORKER_DIE;
@@ -1465,7 +1477,7 @@ static void destroy_worker(struct worker *worker)
 	kfree(worker);
 
 	spin_lock_irq(&gcwq->lock);
-	ida_remove(&gcwq->worker_ida, id);
+	ida_remove(&pool->worker_ida, id);
 }
 
 static void idle_worker_timeout(unsigned long __gcwq)
@@ -1479,11 +1491,12 @@ static void idle_worker_timeout(unsigned long __gcwq)
 		unsigned long expires;
 
 		/* idle_list is kept in LIFO order, check the last one */
-		worker = list_entry(gcwq->idle_list.prev, struct worker, entry);
+		worker = list_entry(gcwq->pool.idle_list.prev, struct worker,
+				    entry);
 		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
 
 		if (time_before(jiffies, expires))
-			mod_timer(&gcwq->idle_timer, expires);
+			mod_timer(&gcwq->pool.idle_timer, expires);
 		else {
 			/* it's been idle for too long, wake up manager */
 			gcwq->flags |= GCWQ_MANAGE_WORKERS;
@@ -1504,7 +1517,7 @@ static bool send_mayday(struct work_struct *work)
 		return false;
 
 	/* mayday mayday mayday */
-	cpu = cwq->gcwq->cpu;
+	cpu = cwq->pool->gcwq->cpu;
 	/* WORK_CPU_UNBOUND can't be set in cpumask, use cpu 0 instead */
 	if (cpu == WORK_CPU_UNBOUND)
 		cpu = 0;
@@ -1527,13 +1540,13 @@ static void gcwq_mayday_timeout(unsigned long __gcwq)
 		 * allocation deadlock.  Send distress signals to
 		 * rescuers.
 		 */
-		list_for_each_entry(work, &gcwq->worklist, entry)
+		list_for_each_entry(work, &gcwq->pool.worklist, entry)
 			send_mayday(work);
 	}
 
 	spin_unlock_irq(&gcwq->lock);
 
-	mod_timer(&gcwq->mayday_timer, jiffies + MAYDAY_INTERVAL);
+	mod_timer(&gcwq->pool.mayday_timer, jiffies + MAYDAY_INTERVAL);
 }
 
 /**
@@ -1568,14 +1581,14 @@ restart:
 	spin_unlock_irq(&gcwq->lock);
 
 	/* if we don't make progress in MAYDAY_INITIAL_TIMEOUT, call for help */
-	mod_timer(&gcwq->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
+	mod_timer(&gcwq->pool.mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
 
 	while (true) {
 		struct worker *worker;
 
 		worker = create_worker(gcwq, true);
 		if (worker) {
-			del_timer_sync(&gcwq->mayday_timer);
+			del_timer_sync(&gcwq->pool.mayday_timer);
 			spin_lock_irq(&gcwq->lock);
 			start_worker(worker);
 			BUG_ON(need_to_create_worker(gcwq));
@@ -1592,7 +1605,7 @@ restart:
 			break;
 	}
 
-	del_timer_sync(&gcwq->mayday_timer);
+	del_timer_sync(&gcwq->pool.mayday_timer);
 	spin_lock_irq(&gcwq->lock);
 	if (need_to_create_worker(gcwq))
 		goto restart;
@@ -1622,11 +1635,12 @@ static bool maybe_destroy_workers(struct global_cwq *gcwq)
 		struct worker *worker;
 		unsigned long expires;
 
-		worker = list_entry(gcwq->idle_list.prev, struct worker, entry);
+		worker = list_entry(gcwq->pool.idle_list.prev, struct worker,
+				    entry);
 		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
 
 		if (time_before(jiffies, expires)) {
-			mod_timer(&gcwq->idle_timer, expires);
+			mod_timer(&gcwq->pool.idle_timer, expires);
 			break;
 		}
 
@@ -1659,7 +1673,7 @@ static bool maybe_destroy_workers(struct global_cwq *gcwq)
  */
 static bool manage_workers(struct worker *worker)
 {
-	struct global_cwq *gcwq = worker->gcwq;
+	struct global_cwq *gcwq = worker->pool->gcwq;
 	bool ret = false;
 
 	if (gcwq->flags & GCWQ_MANAGING_WORKERS)
@@ -1732,7 +1746,7 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
 {
 	struct work_struct *work = list_first_entry(&cwq->delayed_works,
 						    struct work_struct, entry);
-	struct list_head *pos = gcwq_determine_ins_pos(cwq->gcwq, cwq);
+	struct list_head *pos = gcwq_determine_ins_pos(cwq->pool->gcwq, cwq);
 
 	trace_workqueue_activate_work(work);
 	move_linked_works(work, pos, NULL);
@@ -1808,7 +1822,8 @@ __releases(&gcwq->lock)
 __acquires(&gcwq->lock)
 {
 	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
-	struct global_cwq *gcwq = cwq->gcwq;
+	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 	struct hlist_head *bwh = busy_worker_head(gcwq, work);
 	bool cpu_intensive = cwq->wq->flags & WQ_CPU_INTENSIVE;
 	work_func_t f = work->func;
@@ -1854,10 +1869,10 @@ __acquires(&gcwq->lock)
 	 * wake up another worker; otherwise, clear HIGHPRI_PENDING.
 	 */
 	if (unlikely(gcwq->flags & GCWQ_HIGHPRI_PENDING)) {
-		struct work_struct *nwork = list_first_entry(&gcwq->worklist,
-						struct work_struct, entry);
+		struct work_struct *nwork = list_first_entry(&pool->worklist,
+					 struct work_struct, entry);
 
-		if (!list_empty(&gcwq->worklist) &&
+		if (!list_empty(&pool->worklist) &&
 		    get_work_cwq(nwork)->wq->flags & WQ_HIGHPRI)
 			wake_up_worker(gcwq);
 		else
@@ -1950,7 +1965,8 @@ static void process_scheduled_works(struct worker *worker)
 static int worker_thread(void *__worker)
 {
 	struct worker *worker = __worker;
-	struct global_cwq *gcwq = worker->gcwq;
+	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 
 	/* tell the scheduler that this is a workqueue worker */
 	worker->task->flags |= PF_WQ_WORKER;
@@ -1990,7 +2006,7 @@ recheck:
 
 	do {
 		struct work_struct *work =
-			list_first_entry(&gcwq->worklist,
+			list_first_entry(&pool->worklist,
 					 struct work_struct, entry);
 
 		if (likely(!(*work_data_bits(work) & WORK_STRUCT_LINKED))) {
@@ -2064,14 +2080,15 @@ repeat:
 	for_each_mayday_cpu(cpu, wq->mayday_mask) {
 		unsigned int tcpu = is_unbound ? WORK_CPU_UNBOUND : cpu;
 		struct cpu_workqueue_struct *cwq = get_cwq(tcpu, wq);
-		struct global_cwq *gcwq = cwq->gcwq;
+		struct worker_pool *pool = cwq->pool;
+		struct global_cwq *gcwq = pool->gcwq;
 		struct work_struct *work, *n;
 
 		__set_current_state(TASK_RUNNING);
 		mayday_clear_cpu(cpu, wq->mayday_mask);
 
 		/* migrate to the target cpu if possible */
-		rescuer->gcwq = gcwq;
+		rescuer->pool = pool;
 		worker_maybe_bind_and_lock(rescuer);
 
 		/*
@@ -2079,7 +2096,7 @@ repeat:
 		 * process'em.
 		 */
 		BUG_ON(!list_empty(&rescuer->scheduled));
-		list_for_each_entry_safe(work, n, &gcwq->worklist, entry)
+		list_for_each_entry_safe(work, n, &pool->worklist, entry)
 			if (get_work_cwq(work) == cwq)
 				move_linked_works(work, scheduled, &n);
 
@@ -2216,7 +2233,7 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 
 	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
-		struct global_cwq *gcwq = cwq->gcwq;
+		struct global_cwq *gcwq = cwq->pool->gcwq;
 
 		spin_lock_irq(&gcwq->lock);
 
@@ -2432,9 +2449,9 @@ reflush:
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		bool drained;
 
-		spin_lock_irq(&cwq->gcwq->lock);
+		spin_lock_irq(&cwq->pool->gcwq->lock);
 		drained = !cwq->nr_active && list_empty(&cwq->delayed_works);
-		spin_unlock_irq(&cwq->gcwq->lock);
+		spin_unlock_irq(&cwq->pool->gcwq->lock);
 
 		if (drained)
 			continue;
@@ -2474,7 +2491,7 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 		 */
 		smp_rmb();
 		cwq = get_work_cwq(work);
-		if (unlikely(!cwq || gcwq != cwq->gcwq))
+		if (unlikely(!cwq || gcwq != cwq->pool->gcwq))
 			goto already_gone;
 	} else if (wait_executing) {
 		worker = find_worker_executing_work(gcwq, work);
@@ -3017,7 +3034,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 		struct global_cwq *gcwq = get_gcwq(cpu);
 
 		BUG_ON((unsigned long)cwq & WORK_STRUCT_FLAG_MASK);
-		cwq->gcwq = gcwq;
+		cwq->pool = &gcwq->pool;
 		cwq->wq = wq;
 		cwq->flush_color = -1;
 		cwq->max_active = max_active;
@@ -3344,7 +3361,7 @@ static int __cpuinit trustee_thread(void *__gcwq)
 
 	gcwq->flags |= GCWQ_MANAGING_WORKERS;
 
-	list_for_each_entry(worker, &gcwq->idle_list, entry)
+	list_for_each_entry(worker, &gcwq->pool.idle_list, entry)
 		worker->flags |= WORKER_ROGUE;
 
 	for_each_busy_worker(worker, i, pos, gcwq)
@@ -3369,7 +3386,7 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	atomic_set(get_gcwq_nr_running(gcwq->cpu), 0);
 
 	spin_unlock_irq(&gcwq->lock);
-	del_timer_sync(&gcwq->idle_timer);
+	del_timer_sync(&gcwq->pool.idle_timer);
 	spin_lock_irq(&gcwq->lock);
 
 	/*
@@ -3391,17 +3408,17 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	 * may be frozen works in freezable cwqs.  Don't declare
 	 * completion while frozen.
 	 */
-	while (gcwq->nr_workers != gcwq->nr_idle ||
+	while (gcwq->pool.nr_workers != gcwq->pool.nr_idle ||
 	       gcwq->flags & GCWQ_FREEZING ||
 	       gcwq->trustee_state == TRUSTEE_IN_CHARGE) {
 		int nr_works = 0;
 
-		list_for_each_entry(work, &gcwq->worklist, entry) {
+		list_for_each_entry(work, &gcwq->pool.worklist, entry) {
 			send_mayday(work);
 			nr_works++;
 		}
 
-		list_for_each_entry(worker, &gcwq->idle_list, entry) {
+		list_for_each_entry(worker, &gcwq->pool.idle_list, entry) {
 			if (!nr_works--)
 				break;
 			wake_up_process(worker->task);
@@ -3428,11 +3445,11 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	 * all workers till we're canceled.
 	 */
 	do {
-		rc = trustee_wait_event(!list_empty(&gcwq->idle_list));
-		while (!list_empty(&gcwq->idle_list))
-			destroy_worker(list_first_entry(&gcwq->idle_list,
+		rc = trustee_wait_event(!list_empty(&gcwq->pool.idle_list));
+		while (!list_empty(&gcwq->pool.idle_list))
+			destroy_worker(list_first_entry(&gcwq->pool.idle_list,
 							struct worker, entry));
-	} while (gcwq->nr_workers && rc >= 0);
+	} while (gcwq->pool.nr_workers && rc >= 0);
 
 	/*
 	 * At this point, either draining has completed and no worker
@@ -3441,7 +3458,7 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	 * Tell the remaining busy ones to rebind once it finishes the
 	 * currently scheduled works by scheduling the rebind_work.
 	 */
-	WARN_ON(!list_empty(&gcwq->idle_list));
+	WARN_ON(!list_empty(&gcwq->pool.idle_list));
 
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
@@ -3522,7 +3539,7 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		kthread_bind(new_trustee, cpu);
 		/* fall through */
 	case CPU_UP_PREPARE:
-		BUG_ON(gcwq->first_idle);
+		BUG_ON(gcwq->pool.first_idle);
 		new_worker = create_worker(gcwq, false);
 		if (!new_worker) {
 			if (new_trustee)
@@ -3544,8 +3561,8 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		wait_trustee_state(gcwq, TRUSTEE_IN_CHARGE);
 		/* fall through */
 	case CPU_UP_PREPARE:
-		BUG_ON(gcwq->first_idle);
-		gcwq->first_idle = new_worker;
+		BUG_ON(gcwq->pool.first_idle);
+		gcwq->pool.first_idle = new_worker;
 		break;
 
 	case CPU_DYING:
@@ -3562,8 +3579,8 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		gcwq->trustee_state = TRUSTEE_BUTCHER;
 		/* fall through */
 	case CPU_UP_CANCELED:
-		destroy_worker(gcwq->first_idle);
-		gcwq->first_idle = NULL;
+		destroy_worker(gcwq->pool.first_idle);
+		gcwq->pool.first_idle = NULL;
 		break;
 
 	case CPU_DOWN_FAILED:
@@ -3581,11 +3598,11 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		 * take a look.
 		 */
 		spin_unlock_irq(&gcwq->lock);
-		kthread_bind(gcwq->first_idle->task, cpu);
+		kthread_bind(gcwq->pool.first_idle->task, cpu);
 		spin_lock_irq(&gcwq->lock);
 		gcwq->flags |= GCWQ_MANAGE_WORKERS;
-		start_worker(gcwq->first_idle);
-		gcwq->first_idle = NULL;
+		start_worker(gcwq->pool.first_idle);
+		gcwq->pool.first_idle = NULL;
 		break;
 	}
 
@@ -3794,22 +3811,23 @@ static int __init init_workqueues(void)
 		struct global_cwq *gcwq = get_gcwq(cpu);
 
 		spin_lock_init(&gcwq->lock);
-		INIT_LIST_HEAD(&gcwq->worklist);
+		gcwq->pool.gcwq = gcwq;
+		INIT_LIST_HEAD(&gcwq->pool.worklist);
 		gcwq->cpu = cpu;
 		gcwq->flags |= GCWQ_DISASSOCIATED;
 
-		INIT_LIST_HEAD(&gcwq->idle_list);
+		INIT_LIST_HEAD(&gcwq->pool.idle_list);
 		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)
 			INIT_HLIST_HEAD(&gcwq->busy_hash[i]);
 
-		init_timer_deferrable(&gcwq->idle_timer);
-		gcwq->idle_timer.function = idle_worker_timeout;
-		gcwq->idle_timer.data = (unsigned long)gcwq;
+		init_timer_deferrable(&gcwq->pool.idle_timer);
+		gcwq->pool.idle_timer.function = idle_worker_timeout;
+		gcwq->pool.idle_timer.data = (unsigned long)gcwq;
 
-		setup_timer(&gcwq->mayday_timer, gcwq_mayday_timeout,
+		setup_timer(&gcwq->pool.mayday_timer, gcwq_mayday_timeout,
 			    (unsigned long)gcwq);
 
-		ida_init(&gcwq->worker_ida);
+		ida_init(&gcwq->pool.worker_ida);
 
 		gcwq->trustee_state = TRUSTEE_DONE;
 		init_waitqueue_head(&gcwq->trustee_wait);
-- 
1.7.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
