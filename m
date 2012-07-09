Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q69IgE2Q000793 for <xfs@oss.sgi.com>; Mon, 9 Jul 2012 13:42:14 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id nD0KKBhN7FUtNkNv
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Jul 2012 11:42:12 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so24415848pbb.26
	for <xfs@oss.sgi.com>; Mon, 09 Jul 2012 11:42:11 -0700 (PDT)
From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] workqueue: use @pool instead of @gcwq or @cpu where
	applicable
Date: Mon,  9 Jul 2012 11:41:52 -0700
Message-Id: <1341859315-17759-4-git-send-email-tj@kernel.org>
In-Reply-To: <1341859315-17759-1-git-send-email-tj@kernel.org>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
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
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, gustavo@padovan.org, Tejun Heo <tj@kernel.org>, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Modify all functions which deal with per-pool properties to pass
around @pool instead of @gcwq or @cpu.

The changes in this patch are mechanical and don't caues any
functional difference.  This is to prepare for multiple pools per
gcwq.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |  218 ++++++++++++++++++++++++++-------------------------
 1 files changed, 111 insertions(+), 107 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bc43a0c..9f82c25 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -471,8 +471,10 @@ static struct global_cwq *get_gcwq(unsigned int cpu)
 		return &unbound_global_cwq;
 }
 
-static atomic_t *get_gcwq_nr_running(unsigned int cpu)
+static atomic_t *get_pool_nr_running(struct worker_pool *pool)
 {
+	int cpu = pool->gcwq->cpu;
+
 	if (cpu != WORK_CPU_UNBOUND)
 		return &per_cpu(gcwq_nr_running, cpu);
 	else
@@ -578,10 +580,10 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
  * assume that they're being called with gcwq->lock held.
  */
 
-static bool __need_more_worker(struct global_cwq *gcwq)
+static bool __need_more_worker(struct worker_pool *pool)
 {
-	return !atomic_read(get_gcwq_nr_running(gcwq->cpu)) ||
-		gcwq->flags & GCWQ_HIGHPRI_PENDING;
+	return !atomic_read(get_pool_nr_running(pool)) ||
+		pool->gcwq->flags & GCWQ_HIGHPRI_PENDING;
 }
 
 /*
@@ -592,45 +594,46 @@ static bool __need_more_worker(struct global_cwq *gcwq)
  * function will always return %true for unbound gcwq as long as the
  * worklist isn't empty.
  */
-static bool need_more_worker(struct global_cwq *gcwq)
+static bool need_more_worker(struct worker_pool *pool)
 {
-	return !list_empty(&gcwq->pool.worklist) && __need_more_worker(gcwq);
+	return !list_empty(&pool->worklist) && __need_more_worker(pool);
 }
 
 /* Can I start working?  Called from busy but !running workers. */
-static bool may_start_working(struct global_cwq *gcwq)
+static bool may_start_working(struct worker_pool *pool)
 {
-	return gcwq->pool.nr_idle;
+	return pool->nr_idle;
 }
 
 /* Do I need to keep working?  Called from currently running workers. */
-static bool keep_working(struct global_cwq *gcwq)
+static bool keep_working(struct worker_pool *pool)
 {
-	atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
+	atomic_t *nr_running = get_pool_nr_running(pool);
 
-	return !list_empty(&gcwq->pool.worklist) &&
+	return !list_empty(&pool->worklist) &&
 		(atomic_read(nr_running) <= 1 ||
-		 gcwq->flags & GCWQ_HIGHPRI_PENDING);
+		 pool->gcwq->flags & GCWQ_HIGHPRI_PENDING);
 }
 
 /* Do we need a new worker?  Called from manager. */
-static bool need_to_create_worker(struct global_cwq *gcwq)
+static bool need_to_create_worker(struct worker_pool *pool)
 {
-	return need_more_worker(gcwq) && !may_start_working(gcwq);
+	return need_more_worker(pool) && !may_start_working(pool);
 }
 
 /* Do I need to be the manager? */
-static bool need_to_manage_workers(struct global_cwq *gcwq)
+static bool need_to_manage_workers(struct worker_pool *pool)
 {
-	return need_to_create_worker(gcwq) || gcwq->flags & GCWQ_MANAGE_WORKERS;
+	return need_to_create_worker(pool) ||
+		pool->gcwq->flags & GCWQ_MANAGE_WORKERS;
 }
 
 /* Do we have too many workers and should some go away? */
-static bool too_many_workers(struct global_cwq *gcwq)
+static bool too_many_workers(struct worker_pool *pool)
 {
-	bool managing = gcwq->flags & GCWQ_MANAGING_WORKERS;
-	int nr_idle = gcwq->pool.nr_idle + managing; /* manager is considered idle */
-	int nr_busy = gcwq->pool.nr_workers - nr_idle;
+	bool managing = pool->gcwq->flags & GCWQ_MANAGING_WORKERS;
+	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
+	int nr_busy = pool->nr_workers - nr_idle;
 
 	return nr_idle > 2 && (nr_idle - 2) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
 }
@@ -640,26 +643,26 @@ static bool too_many_workers(struct global_cwq *gcwq)
  */
 
 /* Return the first worker.  Safe with preemption disabled */
-static struct worker *first_worker(struct global_cwq *gcwq)
+static struct worker *first_worker(struct worker_pool *pool)
 {
-	if (unlikely(list_empty(&gcwq->pool.idle_list)))
+	if (unlikely(list_empty(&pool->idle_list)))
 		return NULL;
 
-	return list_first_entry(&gcwq->pool.idle_list, struct worker, entry);
+	return list_first_entry(&pool->idle_list, struct worker, entry);
 }
 
 /**
  * wake_up_worker - wake up an idle worker
- * @gcwq: gcwq to wake worker for
+ * @pool: worker pool to wake worker from
  *
- * Wake up the first idle worker of @gcwq.
+ * Wake up the first idle worker of @pool.
  *
  * CONTEXT:
  * spin_lock_irq(gcwq->lock).
  */
-static void wake_up_worker(struct global_cwq *gcwq)
+static void wake_up_worker(struct worker_pool *pool)
 {
-	struct worker *worker = first_worker(gcwq);
+	struct worker *worker = first_worker(pool);
 
 	if (likely(worker))
 		wake_up_process(worker->task);
@@ -681,7 +684,7 @@ void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
 	struct worker *worker = kthread_data(task);
 
 	if (!(worker->flags & WORKER_NOT_RUNNING))
-		atomic_inc(get_gcwq_nr_running(cpu));
+		atomic_inc(get_pool_nr_running(worker->pool));
 }
 
 /**
@@ -704,8 +707,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 {
 	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
 	struct worker_pool *pool = worker->pool;
-	struct global_cwq *gcwq = pool->gcwq;
-	atomic_t *nr_running = get_gcwq_nr_running(cpu);
+	atomic_t *nr_running = get_pool_nr_running(pool);
 
 	if (worker->flags & WORKER_NOT_RUNNING)
 		return NULL;
@@ -725,7 +727,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 	 * without gcwq lock is safe.
 	 */
 	if (atomic_dec_and_test(nr_running) && !list_empty(&pool->worklist))
-		to_wakeup = first_worker(gcwq);
+		to_wakeup = first_worker(pool);
 	return to_wakeup ? to_wakeup->task : NULL;
 }
 
@@ -746,7 +748,6 @@ static inline void worker_set_flags(struct worker *worker, unsigned int flags,
 				    bool wakeup)
 {
 	struct worker_pool *pool = worker->pool;
-	struct global_cwq *gcwq = pool->gcwq;
 
 	WARN_ON_ONCE(worker->task != current);
 
@@ -757,12 +758,12 @@ static inline void worker_set_flags(struct worker *worker, unsigned int flags,
 	 */
 	if ((flags & WORKER_NOT_RUNNING) &&
 	    !(worker->flags & WORKER_NOT_RUNNING)) {
-		atomic_t *nr_running = get_gcwq_nr_running(gcwq->cpu);
+		atomic_t *nr_running = get_pool_nr_running(pool);
 
 		if (wakeup) {
 			if (atomic_dec_and_test(nr_running) &&
 			    !list_empty(&pool->worklist))
-				wake_up_worker(gcwq);
+				wake_up_worker(pool);
 		} else
 			atomic_dec(nr_running);
 	}
@@ -782,7 +783,7 @@ static inline void worker_set_flags(struct worker *worker, unsigned int flags,
  */
 static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
 {
-	struct global_cwq *gcwq = worker->pool->gcwq;
+	struct worker_pool *pool = worker->pool;
 	unsigned int oflags = worker->flags;
 
 	WARN_ON_ONCE(worker->task != current);
@@ -796,7 +797,7 @@ static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
 	 */
 	if ((flags & WORKER_NOT_RUNNING) && (oflags & WORKER_NOT_RUNNING))
 		if (!(worker->flags & WORKER_NOT_RUNNING))
-			atomic_inc(get_gcwq_nr_running(gcwq->cpu));
+			atomic_inc(get_pool_nr_running(pool));
 }
 
 /**
@@ -880,15 +881,15 @@ static struct worker *find_worker_executing_work(struct global_cwq *gcwq,
 }
 
 /**
- * gcwq_determine_ins_pos - find insertion position
- * @gcwq: gcwq of interest
+ * pool_determine_ins_pos - find insertion position
+ * @pool: pool of interest
  * @cwq: cwq a work is being queued for
  *
- * A work for @cwq is about to be queued on @gcwq, determine insertion
+ * A work for @cwq is about to be queued on @pool, determine insertion
  * position for the work.  If @cwq is for HIGHPRI wq, the work is
  * queued at the head of the queue but in FIFO order with respect to
  * other HIGHPRI works; otherwise, at the end of the queue.  This
- * function also sets GCWQ_HIGHPRI_PENDING flag to hint @gcwq that
+ * function also sets GCWQ_HIGHPRI_PENDING flag to hint @pool that
  * there are HIGHPRI works pending.
  *
  * CONTEXT:
@@ -897,22 +898,22 @@ static struct worker *find_worker_executing_work(struct global_cwq *gcwq,
  * RETURNS:
  * Pointer to inserstion position.
  */
-static inline struct list_head *gcwq_determine_ins_pos(struct global_cwq *gcwq,
+static inline struct list_head *pool_determine_ins_pos(struct worker_pool *pool,
 					       struct cpu_workqueue_struct *cwq)
 {
 	struct work_struct *twork;
 
 	if (likely(!(cwq->wq->flags & WQ_HIGHPRI)))
-		return &gcwq->pool.worklist;
+		return &pool->worklist;
 
-	list_for_each_entry(twork, &gcwq->pool.worklist, entry) {
+	list_for_each_entry(twork, &pool->worklist, entry) {
 		struct cpu_workqueue_struct *tcwq = get_work_cwq(twork);
 
 		if (!(tcwq->wq->flags & WQ_HIGHPRI))
 			break;
 	}
 
-	gcwq->flags |= GCWQ_HIGHPRI_PENDING;
+	pool->gcwq->flags |= GCWQ_HIGHPRI_PENDING;
 	return &twork->entry;
 }
 
@@ -933,7 +934,7 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head,
 			unsigned int extra_flags)
 {
-	struct global_cwq *gcwq = cwq->pool->gcwq;
+	struct worker_pool *pool = cwq->pool;
 
 	/* we own @work, set data and link */
 	set_work_cwq(work, cwq, extra_flags);
@@ -953,8 +954,8 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 	 */
 	smp_mb();
 
-	if (__need_more_worker(gcwq))
-		wake_up_worker(gcwq);
+	if (__need_more_worker(pool))
+		wake_up_worker(pool);
 }
 
 /*
@@ -1056,7 +1057,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	if (likely(cwq->nr_active < cwq->max_active)) {
 		trace_workqueue_activate_work(work);
 		cwq->nr_active++;
-		worklist = gcwq_determine_ins_pos(gcwq, cwq);
+		worklist = pool_determine_ins_pos(cwq->pool, cwq);
 	} else {
 		work_flags |= WORK_STRUCT_DELAYED;
 		worklist = &cwq->delayed_works;
@@ -1221,7 +1222,7 @@ static void worker_enter_idle(struct worker *worker)
 	list_add(&worker->entry, &pool->idle_list);
 
 	if (likely(!(worker->flags & WORKER_ROGUE))) {
-		if (too_many_workers(gcwq) && !timer_pending(&pool->idle_timer))
+		if (too_many_workers(pool) && !timer_pending(&pool->idle_timer))
 			mod_timer(&pool->idle_timer,
 				  jiffies + IDLE_WORKER_TIMEOUT);
 	} else
@@ -1234,7 +1235,7 @@ static void worker_enter_idle(struct worker *worker)
 	 */
 	WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
 		     pool->nr_workers == pool->nr_idle &&
-		     atomic_read(get_gcwq_nr_running(gcwq->cpu)));
+		     atomic_read(get_pool_nr_running(pool)));
 }
 
 /**
@@ -1356,10 +1357,10 @@ static struct worker *alloc_worker(void)
 
 /**
  * create_worker - create a new workqueue worker
- * @gcwq: gcwq the new worker will belong to
+ * @pool: pool the new worker will belong to
  * @bind: whether to set affinity to @cpu or not
  *
- * Create a new worker which is bound to @gcwq.  The returned worker
+ * Create a new worker which is bound to @pool.  The returned worker
  * can be started by calling start_worker() or destroyed using
  * destroy_worker().
  *
@@ -1369,10 +1370,10 @@ static struct worker *alloc_worker(void)
  * RETURNS:
  * Pointer to the newly created worker.
  */
-static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
+static struct worker *create_worker(struct worker_pool *pool, bool bind)
 {
+	struct global_cwq *gcwq = pool->gcwq;
 	bool on_unbound_cpu = gcwq->cpu == WORK_CPU_UNBOUND;
-	struct worker_pool *pool = &gcwq->pool;
 	struct worker *worker = NULL;
 	int id = -1;
 
@@ -1480,27 +1481,27 @@ static void destroy_worker(struct worker *worker)
 	ida_remove(&pool->worker_ida, id);
 }
 
-static void idle_worker_timeout(unsigned long __gcwq)
+static void idle_worker_timeout(unsigned long __pool)
 {
-	struct global_cwq *gcwq = (void *)__gcwq;
+	struct worker_pool *pool = (void *)__pool;
+	struct global_cwq *gcwq = pool->gcwq;
 
 	spin_lock_irq(&gcwq->lock);
 
-	if (too_many_workers(gcwq)) {
+	if (too_many_workers(pool)) {
 		struct worker *worker;
 		unsigned long expires;
 
 		/* idle_list is kept in LIFO order, check the last one */
-		worker = list_entry(gcwq->pool.idle_list.prev, struct worker,
-				    entry);
+		worker = list_entry(pool->idle_list.prev, struct worker, entry);
 		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
 
 		if (time_before(jiffies, expires))
-			mod_timer(&gcwq->pool.idle_timer, expires);
+			mod_timer(&pool->idle_timer, expires);
 		else {
 			/* it's been idle for too long, wake up manager */
 			gcwq->flags |= GCWQ_MANAGE_WORKERS;
-			wake_up_worker(gcwq);
+			wake_up_worker(pool);
 		}
 	}
 
@@ -1526,37 +1527,38 @@ static bool send_mayday(struct work_struct *work)
 	return true;
 }
 
-static void gcwq_mayday_timeout(unsigned long __gcwq)
+static void gcwq_mayday_timeout(unsigned long __pool)
 {
-	struct global_cwq *gcwq = (void *)__gcwq;
+	struct worker_pool *pool = (void *)__pool;
+	struct global_cwq *gcwq = pool->gcwq;
 	struct work_struct *work;
 
 	spin_lock_irq(&gcwq->lock);
 
-	if (need_to_create_worker(gcwq)) {
+	if (need_to_create_worker(pool)) {
 		/*
 		 * We've been trying to create a new worker but
 		 * haven't been successful.  We might be hitting an
 		 * allocation deadlock.  Send distress signals to
 		 * rescuers.
 		 */
-		list_for_each_entry(work, &gcwq->pool.worklist, entry)
+		list_for_each_entry(work, &pool->worklist, entry)
 			send_mayday(work);
 	}
 
 	spin_unlock_irq(&gcwq->lock);
 
-	mod_timer(&gcwq->pool.mayday_timer, jiffies + MAYDAY_INTERVAL);
+	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
 }
 
 /**
  * maybe_create_worker - create a new worker if necessary
- * @gcwq: gcwq to create a new worker for
+ * @pool: pool to create a new worker for
  *
- * Create a new worker for @gcwq if necessary.  @gcwq is guaranteed to
+ * Create a new worker for @pool if necessary.  @pool is guaranteed to
  * have at least one idle worker on return from this function.  If
  * creating a new worker takes longer than MAYDAY_INTERVAL, mayday is
- * sent to all rescuers with works scheduled on @gcwq to resolve
+ * sent to all rescuers with works scheduled on @pool to resolve
  * possible allocation deadlock.
  *
  * On return, need_to_create_worker() is guaranteed to be false and
@@ -1571,52 +1573,54 @@ static void gcwq_mayday_timeout(unsigned long __gcwq)
  * false if no action was taken and gcwq->lock stayed locked, true
  * otherwise.
  */
-static bool maybe_create_worker(struct global_cwq *gcwq)
+static bool maybe_create_worker(struct worker_pool *pool)
 __releases(&gcwq->lock)
 __acquires(&gcwq->lock)
 {
-	if (!need_to_create_worker(gcwq))
+	struct global_cwq *gcwq = pool->gcwq;
+
+	if (!need_to_create_worker(pool))
 		return false;
 restart:
 	spin_unlock_irq(&gcwq->lock);
 
 	/* if we don't make progress in MAYDAY_INITIAL_TIMEOUT, call for help */
-	mod_timer(&gcwq->pool.mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
+	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
 
 	while (true) {
 		struct worker *worker;
 
-		worker = create_worker(gcwq, true);
+		worker = create_worker(pool, true);
 		if (worker) {
-			del_timer_sync(&gcwq->pool.mayday_timer);
+			del_timer_sync(&pool->mayday_timer);
 			spin_lock_irq(&gcwq->lock);
 			start_worker(worker);
-			BUG_ON(need_to_create_worker(gcwq));
+			BUG_ON(need_to_create_worker(pool));
 			return true;
 		}
 
-		if (!need_to_create_worker(gcwq))
+		if (!need_to_create_worker(pool))
 			break;
 
 		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(CREATE_COOLDOWN);
 
-		if (!need_to_create_worker(gcwq))
+		if (!need_to_create_worker(pool))
 			break;
 	}
 
-	del_timer_sync(&gcwq->pool.mayday_timer);
+	del_timer_sync(&pool->mayday_timer);
 	spin_lock_irq(&gcwq->lock);
-	if (need_to_create_worker(gcwq))
+	if (need_to_create_worker(pool))
 		goto restart;
 	return true;
 }
 
 /**
  * maybe_destroy_worker - destroy workers which have been idle for a while
- * @gcwq: gcwq to destroy workers for
+ * @pool: pool to destroy workers for
  *
- * Destroy @gcwq workers which have been idle for longer than
+ * Destroy @pool workers which have been idle for longer than
  * IDLE_WORKER_TIMEOUT.
  *
  * LOCKING:
@@ -1627,20 +1631,19 @@ restart:
  * false if no action was taken and gcwq->lock stayed locked, true
  * otherwise.
  */
-static bool maybe_destroy_workers(struct global_cwq *gcwq)
+static bool maybe_destroy_workers(struct worker_pool *pool)
 {
 	bool ret = false;
 
-	while (too_many_workers(gcwq)) {
+	while (too_many_workers(pool)) {
 		struct worker *worker;
 		unsigned long expires;
 
-		worker = list_entry(gcwq->pool.idle_list.prev, struct worker,
-				    entry);
+		worker = list_entry(pool->idle_list.prev, struct worker, entry);
 		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
 
 		if (time_before(jiffies, expires)) {
-			mod_timer(&gcwq->pool.idle_timer, expires);
+			mod_timer(&pool->idle_timer, expires);
 			break;
 		}
 
@@ -1673,7 +1676,8 @@ static bool maybe_destroy_workers(struct global_cwq *gcwq)
  */
 static bool manage_workers(struct worker *worker)
 {
-	struct global_cwq *gcwq = worker->pool->gcwq;
+	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 	bool ret = false;
 
 	if (gcwq->flags & GCWQ_MANAGING_WORKERS)
@@ -1686,8 +1690,8 @@ static bool manage_workers(struct worker *worker)
 	 * Destroy and then create so that may_start_working() is true
 	 * on return.
 	 */
-	ret |= maybe_destroy_workers(gcwq);
-	ret |= maybe_create_worker(gcwq);
+	ret |= maybe_destroy_workers(pool);
+	ret |= maybe_create_worker(pool);
 
 	gcwq->flags &= ~GCWQ_MANAGING_WORKERS;
 
@@ -1746,7 +1750,7 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
 {
 	struct work_struct *work = list_first_entry(&cwq->delayed_works,
 						    struct work_struct, entry);
-	struct list_head *pos = gcwq_determine_ins_pos(cwq->pool->gcwq, cwq);
+	struct list_head *pos = pool_determine_ins_pos(cwq->pool, cwq);
 
 	trace_workqueue_activate_work(work);
 	move_linked_works(work, pos, NULL);
@@ -1874,7 +1878,7 @@ __acquires(&gcwq->lock)
 
 		if (!list_empty(&pool->worklist) &&
 		    get_work_cwq(nwork)->wq->flags & WQ_HIGHPRI)
-			wake_up_worker(gcwq);
+			wake_up_worker(pool);
 		else
 			gcwq->flags &= ~GCWQ_HIGHPRI_PENDING;
 	}
@@ -1890,8 +1894,8 @@ __acquires(&gcwq->lock)
 	 * Unbound gcwq isn't concurrency managed and work items should be
 	 * executed ASAP.  Wake up another worker if necessary.
 	 */
-	if ((worker->flags & WORKER_UNBOUND) && need_more_worker(gcwq))
-		wake_up_worker(gcwq);
+	if ((worker->flags & WORKER_UNBOUND) && need_more_worker(pool))
+		wake_up_worker(pool);
 
 	spin_unlock_irq(&gcwq->lock);
 
@@ -1983,11 +1987,11 @@ woke_up:
 	worker_leave_idle(worker);
 recheck:
 	/* no more worker necessary? */
-	if (!need_more_worker(gcwq))
+	if (!need_more_worker(pool))
 		goto sleep;
 
 	/* do we need to manage? */
-	if (unlikely(!may_start_working(gcwq)) && manage_workers(worker))
+	if (unlikely(!may_start_working(pool)) && manage_workers(worker))
 		goto recheck;
 
 	/*
@@ -2018,11 +2022,11 @@ recheck:
 			move_linked_works(work, &worker->scheduled, NULL);
 			process_scheduled_works(worker);
 		}
-	} while (keep_working(gcwq));
+	} while (keep_working(pool));
 
 	worker_set_flags(worker, WORKER_PREP, false);
 sleep:
-	if (unlikely(need_to_manage_workers(gcwq)) && manage_workers(worker))
+	if (unlikely(need_to_manage_workers(pool)) && manage_workers(worker))
 		goto recheck;
 
 	/*
@@ -2107,8 +2111,8 @@ repeat:
 		 * regular worker; otherwise, we end up with 0 concurrency
 		 * and stalling the execution.
 		 */
-		if (keep_working(gcwq))
-			wake_up_worker(gcwq);
+		if (keep_working(pool))
+			wake_up_worker(pool);
 
 		spin_unlock_irq(&gcwq->lock);
 	}
@@ -3383,7 +3387,7 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	 * keep_working() are always true as long as the worklist is
 	 * not empty.
 	 */
-	atomic_set(get_gcwq_nr_running(gcwq->cpu), 0);
+	atomic_set(get_pool_nr_running(&gcwq->pool), 0);
 
 	spin_unlock_irq(&gcwq->lock);
 	del_timer_sync(&gcwq->pool.idle_timer);
@@ -3424,9 +3428,9 @@ static int __cpuinit trustee_thread(void *__gcwq)
 			wake_up_process(worker->task);
 		}
 
-		if (need_to_create_worker(gcwq)) {
+		if (need_to_create_worker(&gcwq->pool)) {
 			spin_unlock_irq(&gcwq->lock);
-			worker = create_worker(gcwq, false);
+			worker = create_worker(&gcwq->pool, false);
 			spin_lock_irq(&gcwq->lock);
 			if (worker) {
 				worker->flags |= WORKER_ROGUE;
@@ -3540,7 +3544,7 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		/* fall through */
 	case CPU_UP_PREPARE:
 		BUG_ON(gcwq->pool.first_idle);
-		new_worker = create_worker(gcwq, false);
+		new_worker = create_worker(&gcwq->pool, false);
 		if (!new_worker) {
 			if (new_trustee)
 				kthread_stop(new_trustee);
@@ -3788,7 +3792,7 @@ void thaw_workqueues(void)
 				cwq_activate_first_delayed(cwq);
 		}
 
-		wake_up_worker(gcwq);
+		wake_up_worker(&gcwq->pool);
 
 		spin_unlock_irq(&gcwq->lock);
 	}
@@ -3822,10 +3826,10 @@ static int __init init_workqueues(void)
 
 		init_timer_deferrable(&gcwq->pool.idle_timer);
 		gcwq->pool.idle_timer.function = idle_worker_timeout;
-		gcwq->pool.idle_timer.data = (unsigned long)gcwq;
+		gcwq->pool.idle_timer.data = (unsigned long)&gcwq->pool;
 
 		setup_timer(&gcwq->pool.mayday_timer, gcwq_mayday_timeout,
-			    (unsigned long)gcwq);
+			    (unsigned long)&gcwq->pool);
 
 		ida_init(&gcwq->pool.worker_ida);
 
@@ -3840,7 +3844,7 @@ static int __init init_workqueues(void)
 
 		if (cpu != WORK_CPU_UNBOUND)
 			gcwq->flags &= ~GCWQ_DISASSOCIATED;
-		worker = create_worker(gcwq, true);
+		worker = create_worker(&gcwq->pool, true);
 		BUG_ON(!worker);
 		spin_lock_irq(&gcwq->lock);
 		start_worker(worker);
-- 
1.7.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
