Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6E5OJiE234842 for <xfs@oss.sgi.com>; Sat, 14 Jul 2012 00:24:19 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id oDJDg1djp07JZ3AY
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Jul 2012 22:24:18 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so8242633pbb.26
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 22:24:17 -0700 (PDT)
Date: Fri, 13 Jul 2012 22:24:12 -0700
From: Tejun Heo <tj@kernel.org>
Subject: [PATCH UPDATED v3 6/6] workqueue: reimplement WQ_HIGHPRI using a
	separate worker_pool
Message-ID: <20120714052412.GD7718@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1341859315-17759-7-git-send-email-tj@kernel.org>
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

>From a465fcee388d62d22e390b57c81ca8411f25a1da Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 13 Jul 2012 22:16:45 -0700

WQ_HIGHPRI was implemented by queueing highpri work items at the head
of the global worklist.  Other than queueing at the head, they weren't
handled differently; unfortunately, this could lead to execution
latency of a few seconds on heavily loaded systems.

Now that workqueue code has been updated to deal with multiple
worker_pools per global_cwq, this patch reimplements WQ_HIGHPRI using
a separate worker_pool.  NR_WORKER_POOLS is bumped to two and
gcwq->pools[0] is used for normal pri work items and ->pools[1] for
highpri.  Highpri workers get -20 nice level and has 'H' suffix in
their names.  Note that this change increases the number of kworkers
per cpu.

POOL_HIGHPRI_PENDING, pool_determine_ins_pos() and highpri chain
wakeup code in process_one_work() are no longer used and removed.

This allows proper prioritization of highpri work items and removes
high execution latency of highpri work items.

v2: nr_running indexing bug in get_pool_nr_running() fixed.

v3: Refreshed for the get_pool_nr_running() update in the previous
    patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Josh Hunt <joshhunt00@gmail.com>
LKML-Reference: <CAKA=qzaHqwZ8eqpLNFjxnO2fX-tgAOjmpvxgBFjv6dJeQaOW1w@mail.gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
---
 Documentation/workqueue.txt |  103 ++++++++++++++++---------------------------
 kernel/workqueue.c          |  100 +++++++++++------------------------------
 2 files changed, 65 insertions(+), 138 deletions(-)

diff --git a/Documentation/workqueue.txt b/Documentation/workqueue.txt
index a0b577d..a6ab4b6 100644
--- a/Documentation/workqueue.txt
+++ b/Documentation/workqueue.txt
@@ -89,25 +89,28 @@ called thread-pools.
 
 The cmwq design differentiates between the user-facing workqueues that
 subsystems and drivers queue work items on and the backend mechanism
-which manages thread-pool and processes the queued work items.
+which manages thread-pools and processes the queued work items.
 
 The backend is called gcwq.  There is one gcwq for each possible CPU
-and one gcwq to serve work items queued on unbound workqueues.
+and one gcwq to serve work items queued on unbound workqueues.  Each
+gcwq has two thread-pools - one for normal work items and the other
+for high priority ones.
 
 Subsystems and drivers can create and queue work items through special
 workqueue API functions as they see fit. They can influence some
 aspects of the way the work items are executed by setting flags on the
 workqueue they are putting the work item on. These flags include
-things like CPU locality, reentrancy, concurrency limits and more. To
-get a detailed overview refer to the API description of
+things like CPU locality, reentrancy, concurrency limits, priority and
+more.  To get a detailed overview refer to the API description of
 alloc_workqueue() below.
 
-When a work item is queued to a workqueue, the target gcwq is
-determined according to the queue parameters and workqueue attributes
-and appended on the shared worklist of the gcwq.  For example, unless
-specifically overridden, a work item of a bound workqueue will be
-queued on the worklist of exactly that gcwq that is associated to the
-CPU the issuer is running on.
+When a work item is queued to a workqueue, the target gcwq and
+thread-pool is determined according to the queue parameters and
+workqueue attributes and appended on the shared worklist of the
+thread-pool.  For example, unless specifically overridden, a work item
+of a bound workqueue will be queued on the worklist of either normal
+or highpri thread-pool of the gcwq that is associated to the CPU the
+issuer is running on.
 
 For any worker pool implementation, managing the concurrency level
 (how many execution contexts are active) is an important issue.  cmwq
@@ -115,26 +118,26 @@ tries to keep the concurrency at a minimal but sufficient level.
 Minimal to save resources and sufficient in that the system is used at
 its full capacity.
 
-Each gcwq bound to an actual CPU implements concurrency management by
-hooking into the scheduler.  The gcwq is notified whenever an active
-worker wakes up or sleeps and keeps track of the number of the
-currently runnable workers.  Generally, work items are not expected to
-hog a CPU and consume many cycles.  That means maintaining just enough
-concurrency to prevent work processing from stalling should be
-optimal.  As long as there are one or more runnable workers on the
-CPU, the gcwq doesn't start execution of a new work, but, when the
-last running worker goes to sleep, it immediately schedules a new
-worker so that the CPU doesn't sit idle while there are pending work
-items.  This allows using a minimal number of workers without losing
-execution bandwidth.
+Each thread-pool bound to an actual CPU implements concurrency
+management by hooking into the scheduler.  The thread-pool is notified
+whenever an active worker wakes up or sleeps and keeps track of the
+number of the currently runnable workers.  Generally, work items are
+not expected to hog a CPU and consume many cycles.  That means
+maintaining just enough concurrency to prevent work processing from
+stalling should be optimal.  As long as there are one or more runnable
+workers on the CPU, the thread-pool doesn't start execution of a new
+work, but, when the last running worker goes to sleep, it immediately
+schedules a new worker so that the CPU doesn't sit idle while there
+are pending work items.  This allows using a minimal number of workers
+without losing execution bandwidth.
 
 Keeping idle workers around doesn't cost other than the memory space
 for kthreads, so cmwq holds onto idle ones for a while before killing
 them.
 
 For an unbound wq, the above concurrency management doesn't apply and
-the gcwq for the pseudo unbound CPU tries to start executing all work
-items as soon as possible.  The responsibility of regulating
+the thread-pools for the pseudo unbound CPU try to start executing all
+work items as soon as possible.  The responsibility of regulating
 concurrency level is on the users.  There is also a flag to mark a
 bound wq to ignore the concurrency management.  Please refer to the
 API section for details.
@@ -205,31 +208,22 @@ resources, scheduled and executed.
 
   WQ_HIGHPRI
 
-	Work items of a highpri wq are queued at the head of the
-	worklist of the target gcwq and start execution regardless of
-	the current concurrency level.  In other words, highpri work
-	items will always start execution as soon as execution
-	resource is available.
+	Work items of a highpri wq are queued to the highpri
+	thread-pool of the target gcwq.  Highpri thread-pools are
+	served by worker threads with elevated nice level.
 
-	Ordering among highpri work items is preserved - a highpri
-	work item queued after another highpri work item will start
-	execution after the earlier highpri work item starts.
-
-	Although highpri work items are not held back by other
-	runnable work items, they still contribute to the concurrency
-	level.  Highpri work items in runnable state will prevent
-	non-highpri work items from starting execution.
-
-	This flag is meaningless for unbound wq.
+	Note that normal and highpri thread-pools don't interact with
+	each other.  Each maintain its separate pool of workers and
+	implements concurrency management among its workers.
 
   WQ_CPU_INTENSIVE
 
 	Work items of a CPU intensive wq do not contribute to the
 	concurrency level.  In other words, runnable CPU intensive
-	work items will not prevent other work items from starting
-	execution.  This is useful for bound work items which are
-	expected to hog CPU cycles so that their execution is
-	regulated by the system scheduler.
+	work items will not prevent other work items in the same
+	thread-pool from starting execution.  This is useful for bound
+	work items which are expected to hog CPU cycles so that their
+	execution is regulated by the system scheduler.
 
 	Although CPU intensive work items don't contribute to the
 	concurrency level, start of their executions is still
@@ -239,14 +233,6 @@ resources, scheduled and executed.
 
 	This flag is meaningless for unbound wq.
 
-  WQ_HIGHPRI | WQ_CPU_INTENSIVE
-
-	This combination makes the wq avoid interaction with
-	concurrency management completely and behave as a simple
-	per-CPU execution context provider.  Work items queued on a
-	highpri CPU-intensive wq start execution as soon as resources
-	are available and don't affect execution of other work items.
-
 @max_active:
 
 @max_active determines the maximum number of execution contexts per
@@ -328,20 +314,7 @@ If @max_active == 2,
  35		w2 wakes up and finishes
 
 Now, let's assume w1 and w2 are queued to a different wq q1 which has
-WQ_HIGHPRI set,
-
- TIME IN MSECS	EVENT
- 0		w1 and w2 start and burn CPU
- 5		w1 sleeps
- 10		w2 sleeps
- 10		w0 starts and burns CPU
- 15		w0 sleeps
- 15		w1 wakes up and finishes
- 20		w2 wakes up and finishes
- 25		w0 wakes up and burns CPU
- 30		w0 finishes
-
-If q1 has WQ_CPU_INTENSIVE set,
+WQ_CPU_INTENSIVE set,
 
  TIME IN MSECS	EVENT
  0		w0 starts and burns CPU
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b0daaea..4fa9e35 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -52,7 +52,6 @@ enum {
 	/* pool flags */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_MANAGING_WORKERS	= 1 << 1,	/* managing workers */
-	POOL_HIGHPRI_PENDING	= 1 << 2,	/* highpri works on queue */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -74,7 +73,7 @@ enum {
 	TRUSTEE_RELEASE		= 3,		/* release workers */
 	TRUSTEE_DONE		= 4,		/* trustee is done */
 
-	NR_WORKER_POOLS		= 1,		/* # worker pools per gcwq */
+	NR_WORKER_POOLS		= 2,		/* # worker pools per gcwq */
 
 	BUSY_WORKER_HASH_ORDER	= 6,		/* 64 pointers */
 	BUSY_WORKER_HASH_SIZE	= 1 << BUSY_WORKER_HASH_ORDER,
@@ -95,6 +94,7 @@ enum {
 	 * all cpus.  Give -20.
 	 */
 	RESCUER_NICE_LEVEL	= -20,
+	HIGHPRI_NICE_LEVEL	= -20,
 };
 
 /*
@@ -174,7 +174,7 @@ struct global_cwq {
 	struct hlist_head	busy_hash[BUSY_WORKER_HASH_SIZE];
 						/* L: hash of busy workers */
 
-	struct worker_pool	pool;		/* the worker pools */
+	struct worker_pool	pools[2];	/* normal and highpri pools */
 
 	struct task_struct	*trustee;	/* L: for gcwq shutdown */
 	unsigned int		trustee_state;	/* L: trustee state */
@@ -277,7 +277,8 @@ EXPORT_SYMBOL_GPL(system_nrt_freezable_wq);
 #include <trace/events/workqueue.h>
 
 #define for_each_worker_pool(pool, gcwq)				\
-	for ((pool) = &(gcwq)->pool; (pool); (pool) = NULL)
+	for ((pool) = &(gcwq)->pools[0];				\
+	     (pool) < &(gcwq)->pools[NR_WORKER_POOLS]; (pool)++)
 
 #define for_each_busy_worker(worker, i, pos, gcwq)			\
 	for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)			\
@@ -473,6 +474,11 @@ static atomic_t unbound_pool_nr_running[NR_WORKER_POOLS] = {
 
 static int worker_thread(void *__worker);
 
+static int worker_pool_pri(struct worker_pool *pool)
+{
+	return pool - pool->gcwq->pools;
+}
+
 static struct global_cwq *get_gcwq(unsigned int cpu)
 {
 	if (cpu != WORK_CPU_UNBOUND)
@@ -484,7 +490,7 @@ static struct global_cwq *get_gcwq(unsigned int cpu)
 static atomic_t *get_pool_nr_running(struct worker_pool *pool)
 {
 	int cpu = pool->gcwq->cpu;
-	int idx = 0;
+	int idx = worker_pool_pri(pool);
 
 	if (cpu != WORK_CPU_UNBOUND)
 		return &per_cpu(pool_nr_running, cpu)[idx];
@@ -586,15 +592,14 @@ static struct global_cwq *get_work_gcwq(struct work_struct *work)
 }
 
 /*
- * Policy functions.  These define the policies on how the global
- * worker pool is managed.  Unless noted otherwise, these functions
- * assume that they're being called with gcwq->lock held.
+ * Policy functions.  These define the policies on how the global worker
+ * pools are managed.  Unless noted otherwise, these functions assume that
+ * they're being called with gcwq->lock held.
  */
 
 static bool __need_more_worker(struct worker_pool *pool)
 {
-	return !atomic_read(get_pool_nr_running(pool)) ||
-		(pool->flags & POOL_HIGHPRI_PENDING);
+	return !atomic_read(get_pool_nr_running(pool));
 }
 
 /*
@@ -621,9 +626,7 @@ static bool keep_working(struct worker_pool *pool)
 {
 	atomic_t *nr_running = get_pool_nr_running(pool);
 
-	return !list_empty(&pool->worklist) &&
-		(atomic_read(nr_running) <= 1 ||
-		 (pool->flags & POOL_HIGHPRI_PENDING));
+	return !list_empty(&pool->worklist) && atomic_read(nr_running) <= 1;
 }
 
 /* Do we need a new worker?  Called from manager. */
@@ -892,43 +895,6 @@ static struct worker *find_worker_executing_work(struct global_cwq *gcwq,
 }
 
 /**
- * pool_determine_ins_pos - find insertion position
- * @pool: pool of interest
- * @cwq: cwq a work is being queued for
- *
- * A work for @cwq is about to be queued on @pool, determine insertion
- * position for the work.  If @cwq is for HIGHPRI wq, the work is
- * queued at the head of the queue but in FIFO order with respect to
- * other HIGHPRI works; otherwise, at the end of the queue.  This
- * function also sets POOL_HIGHPRI_PENDING flag to hint @pool that
- * there are HIGHPRI works pending.
- *
- * CONTEXT:
- * spin_lock_irq(gcwq->lock).
- *
- * RETURNS:
- * Pointer to inserstion position.
- */
-static inline struct list_head *pool_determine_ins_pos(struct worker_pool *pool,
-					       struct cpu_workqueue_struct *cwq)
-{
-	struct work_struct *twork;
-
-	if (likely(!(cwq->wq->flags & WQ_HIGHPRI)))
-		return &pool->worklist;
-
-	list_for_each_entry(twork, &pool->worklist, entry) {
-		struct cpu_workqueue_struct *tcwq = get_work_cwq(twork);
-
-		if (!(tcwq->wq->flags & WQ_HIGHPRI))
-			break;
-	}
-
-	pool->flags |= POOL_HIGHPRI_PENDING;
-	return &twork->entry;
-}
-
-/**
  * insert_work - insert a work into gcwq
  * @cwq: cwq @work belongs to
  * @work: work to insert
@@ -1068,7 +1034,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	if (likely(cwq->nr_active < cwq->max_active)) {
 		trace_workqueue_activate_work(work);
 		cwq->nr_active++;
-		worklist = pool_determine_ins_pos(cwq->pool, cwq);
+		worklist = &cwq->pool->worklist;
 	} else {
 		work_flags |= WORK_STRUCT_DELAYED;
 		worklist = &cwq->delayed_works;
@@ -1385,6 +1351,7 @@ static struct worker *create_worker(struct worker_pool *pool, bool bind)
 {
 	struct global_cwq *gcwq = pool->gcwq;
 	bool on_unbound_cpu = gcwq->cpu == WORK_CPU_UNBOUND;
+	const char *pri = worker_pool_pri(pool) ? "H" : "";
 	struct worker *worker = NULL;
 	int id = -1;
 
@@ -1406,15 +1373,17 @@ static struct worker *create_worker(struct worker_pool *pool, bool bind)
 
 	if (!on_unbound_cpu)
 		worker->task = kthread_create_on_node(worker_thread,
-						      worker,
-						      cpu_to_node(gcwq->cpu),
-						      "kworker/%u:%d", gcwq->cpu, id);
+					worker, cpu_to_node(gcwq->cpu),
+					"kworker/%u:%d%s", gcwq->cpu, id, pri);
 	else
 		worker->task = kthread_create(worker_thread, worker,
-					      "kworker/u:%d", id);
+					      "kworker/u:%d%s", id, pri);
 	if (IS_ERR(worker->task))
 		goto fail;
 
+	if (worker_pool_pri(pool))
+		set_user_nice(worker->task, HIGHPRI_NICE_LEVEL);
+
 	/*
 	 * A rogue worker will become a regular one if CPU comes
 	 * online later on.  Make sure every worker has
@@ -1761,10 +1730,9 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
 {
 	struct work_struct *work = list_first_entry(&cwq->delayed_works,
 						    struct work_struct, entry);
-	struct list_head *pos = pool_determine_ins_pos(cwq->pool, cwq);
 
 	trace_workqueue_activate_work(work);
-	move_linked_works(work, pos, NULL);
+	move_linked_works(work, &cwq->pool->worklist, NULL);
 	__clear_bit(WORK_STRUCT_DELAYED_BIT, work_data_bits(work));
 	cwq->nr_active++;
 }
@@ -1880,21 +1848,6 @@ __acquires(&gcwq->lock)
 	list_del_init(&work->entry);
 
 	/*
-	 * If HIGHPRI_PENDING, check the next work, and, if HIGHPRI,
-	 * wake up another worker; otherwise, clear HIGHPRI_PENDING.
-	 */
-	if (unlikely(pool->flags & POOL_HIGHPRI_PENDING)) {
-		struct work_struct *nwork = list_first_entry(&pool->worklist,
-					 struct work_struct, entry);
-
-		if (!list_empty(&pool->worklist) &&
-		    get_work_cwq(nwork)->wq->flags & WQ_HIGHPRI)
-			wake_up_worker(pool);
-		else
-			pool->flags &= ~POOL_HIGHPRI_PENDING;
-	}
-
-	/*
 	 * CPU intensive works don't participate in concurrency
 	 * management.  They're the scheduler's responsibility.
 	 */
@@ -3047,9 +3000,10 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		struct global_cwq *gcwq = get_gcwq(cpu);
+		int pool_idx = (bool)(flags & WQ_HIGHPRI);
 
 		BUG_ON((unsigned long)cwq & WORK_STRUCT_FLAG_MASK);
-		cwq->pool = &gcwq->pool;
+		cwq->pool = &gcwq->pools[pool_idx];
 		cwq->wq = wq;
 		cwq->flush_color = -1;
 		cwq->max_active = max_active;
-- 
1.7.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
