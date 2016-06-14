Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B4A3D7CAF
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 13:13:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8778730405F
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 11:13:25 -0700 (PDT)
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com
	[15.241.48.73]) by cuda.sgi.com with ESMTP id 6XOLNC9AhlP0TpFB
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Jun 2016 11:13:23 -0700 (PDT)
From: Waiman Long <Waiman.Long@hpe.com>
Subject: [RFC PATCH-tip 3/6] locking/rwsem: move down rwsem_down_read_failed
	function
Date: Tue, 14 Jun 2016 14:12:36 -0400
Message-Id: <1465927959-39719-4-git-send-email-Waiman.Long@hpe.com>
In-Reply-To: <1465927959-39719-1-git-send-email-Waiman.Long@hpe.com>
References: <1465927959-39719-1-git-send-email-Waiman.Long@hpe.com>
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
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, linux-ia64@vger.kernel.org, Scott J Norton <scott.norton@hpe.com>, x86@kernel.org, linux-kernel@vger.kernel.org, Waiman Long <Waiman.Long@hpe.com>, xfs@oss.sgi.com, linux-alpha@vger.kernel.org, Douglas Hatch <doug.hatch@hpe.com>, Jason Low <jason.low2@hp.com>

Move the rwsem_down_read_failed() function down to below the optimistic
spinning section before enabling optimistic spinning for the readers.
There is no change in code.

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 kernel/locking/rwsem-xadd.c |  116 +++++++++++++++++++++---------------------
 1 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 9703f4a..400e594 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -226,64 +226,6 @@ __rwsem_mark_wake(struct rw_semaphore *sem,
 }
 
 /*
- * Wait for the read lock to be granted
- */
-__visible
-struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
-{
-	long count, adjustment = 0;
-	struct rwsem_waiter waiter;
-	struct task_struct *tsk = current;
-	WAKE_Q(wake_q);
-
-	/*
-	 * Undo read bias from down_read operation, stop active locking.
-	 * Doing that after taking the wait_lock may block writer lock
-	 * stealing for too long.
-	 */
-	atomic_long_add(-RWSEM_ACTIVE_READ_BIAS, &sem->count);
-
-	/* set up my own style of waitqueue */
-	waiter.task = tsk;
-	waiter.type = RWSEM_WAITING_FOR_READ;
-
-	raw_spin_lock_irq(&sem->wait_lock);
-	if (list_empty(&sem->wait_list))
-		adjustment += RWSEM_WAITING_BIAS;
-	list_add_tail(&waiter.list, &sem->wait_list);
-
-	/* we're now waiting on the lock */
-	if (adjustment)
-		count = atomic_long_add_return(adjustment, &sem->count);
-	else
-		count = atomic_long_read(&sem->count);
-
-	/* If there are no active locks, wake the front queued process(es).
-	 *
-	 * If there are no writers and we are first in the queue,
-	 * wake our own waiter to join the existing active readers !
-	 */
-	if (count == RWSEM_WAITING_BIAS ||
-	    (count > RWSEM_WAITING_BIAS && adjustment))
-		sem = __rwsem_mark_wake(sem, RWSEM_WAKE_ANY, &wake_q);
-
-	raw_spin_unlock_irq(&sem->wait_lock);
-	wake_up_q(&wake_q);
-
-	/* wait to be given the lock */
-	while (true) {
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-		if (!waiter.task)
-			break;
-		schedule();
-	}
-
-	__set_task_state(tsk, TASK_RUNNING);
-	return sem;
-}
-EXPORT_SYMBOL(rwsem_down_read_failed);
-
-/*
  * This function must be called with the sem->wait_lock held to prevent
  * race conditions between checking the rwsem wait list and setting the
  * sem->count accordingly.
@@ -479,6 +421,64 @@ static inline bool rwsem_has_spinner(struct rw_semaphore *sem)
 #endif
 
 /*
+ * Wait for the read lock to be granted
+ */
+__visible
+struct rw_semaphore __sched * rwsem_down_read_failed(struct rw_semaphore *sem)
+{
+	long count, adjustment = 0;
+	struct rwsem_waiter waiter;
+	struct task_struct *tsk = current;
+	WAKE_Q(wake_q);
+
+	/*
+	 * Undo read bias from down_read operation, stop active locking.
+	 * Doing that after taking the wait_lock may block writer lock
+	 * stealing for too long.
+	 */
+	atomic_long_add(-RWSEM_ACTIVE_READ_BIAS, &sem->count);
+
+	/* set up my own style of waitqueue */
+	waiter.task = tsk;
+	waiter.type = RWSEM_WAITING_FOR_READ;
+
+	raw_spin_lock_irq(&sem->wait_lock);
+	if (list_empty(&sem->wait_list))
+		adjustment += RWSEM_WAITING_BIAS;
+	list_add_tail(&waiter.list, &sem->wait_list);
+
+	/* we're now waiting on the lock */
+	if (adjustment)
+		count = atomic_long_add_return(adjustment, &sem->count);
+	else
+		count = atomic_long_read(&sem->count);
+
+	/* If there are no active locks, wake the front queued process(es).
+	 *
+	 * If there are no writers and we are first in the queue,
+	 * wake our own waiter to join the existing active readers !
+	 */
+	if (count == RWSEM_WAITING_BIAS ||
+	    (count > RWSEM_WAITING_BIAS && adjustment))
+		sem = __rwsem_mark_wake(sem, RWSEM_WAKE_ANY, &wake_q);
+
+	raw_spin_unlock_irq(&sem->wait_lock);
+	wake_up_q(&wake_q);
+
+	/* wait to be given the lock */
+	while (true) {
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		if (!waiter.task)
+			break;
+		schedule();
+	}
+
+	__set_task_state(tsk, TASK_RUNNING);
+	return sem;
+}
+EXPORT_SYMBOL(rwsem_down_read_failed);
+
+/*
  * Wait until we successfully acquire the write lock
  */
 static inline struct rw_semaphore *
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
