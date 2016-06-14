Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3BBB27CA0
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 13:13:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F2F38F8050
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 11:13:23 -0700 (PDT)
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com
	[15.241.48.73]) by cuda.sgi.com with ESMTP id DSTG36VKwMrSLcti
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Jun 2016 11:13:20 -0700 (PDT)
From: Waiman Long <Waiman.Long@hpe.com>
Subject: [RFC PATCH-tip 1/6] locking/rwsem: Stop active read lock ASAP
Date: Tue, 14 Jun 2016 14:12:34 -0400
Message-Id: <1465927959-39719-2-git-send-email-Waiman.Long@hpe.com>
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

Currently, when down_read() fails, the active read locking isn't undone
until the rwsem_down_read_failed() function grabs the wait_lock. If the
wait_lock is contended, it may takes a while to get the lock. During
that period, writer lock stealing will be disabled because of the
active read lock.

This patch will release the active read lock ASAP so that writer lock
stealing can happen sooner. The only downside is when the reader is
the first one in the wait queue as it has to issue another atomic
operation to update the count.

On a 4-socket Haswell machine running on a 4.7-rc1 tip-based kernel,
the fio test with multithreaded randrw and randwrite tests on the
same file on a XFS partition on top of a NVDIMM with DAX were run,
the aggregated bandwidths before and after the patch were as follows:

  Test      BW before patch     BW after patch  % change
  ----      ---------------     --------------  --------
  randrw        1210 MB/s          1352 MB/s      +12%
  randwrite     1622 MB/s          1710 MB/s      +5.4%

The write-only microbench also showed improvement because some read
locking was done by the XFS code.

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 kernel/locking/rwsem-xadd.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 2031281..29027c6 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -230,11 +230,18 @@ __rwsem_mark_wake(struct rw_semaphore *sem,
 __visible
 struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 {
-	long count, adjustment = -RWSEM_ACTIVE_READ_BIAS;
+	long count, adjustment = 0;
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
 	WAKE_Q(wake_q);
 
+	/*
+	 * Undo read bias from down_read operation, stop active locking.
+	 * Doing that after taking the wait_lock may block writer lock
+	 * stealing for too long.
+	 */
+	atomic_long_add(-RWSEM_ACTIVE_READ_BIAS, &sem->count);
+
 	/* set up my own style of waitqueue */
 	waiter.task = tsk;
 	waiter.type = RWSEM_WAITING_FOR_READ;
@@ -244,8 +251,11 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 		adjustment += RWSEM_WAITING_BIAS;
 	list_add_tail(&waiter.list, &sem->wait_list);
 
-	/* we're now waiting on the lock, but no longer actively locking */
-	count = atomic_long_add_return(adjustment, &sem->count);
+	/* we're now waiting on the lock */
+	if (adjustment)
+		count = atomic_long_add_return(adjustment, &sem->count);
+	else
+		count = atomic_long_read(&sem->count);
 
 	/* If there are no active locks, wake the front queued process(es).
 	 *
@@ -253,8 +263,7 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 	 * wake our own waiter to join the existing active readers !
 	 */
 	if (count == RWSEM_WAITING_BIAS ||
-	    (count > RWSEM_WAITING_BIAS &&
-	     adjustment != -RWSEM_ACTIVE_READ_BIAS))
+	    (count > RWSEM_WAITING_BIAS && adjustment))
 		sem = __rwsem_mark_wake(sem, RWSEM_WAKE_ANY, &wake_q);
 
 	raw_spin_unlock_irq(&sem->wait_lock);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
