Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (unknown [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0B4FB7F4E
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 13:50:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B5D3AC002
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 11:49:53 -0800 (PST)
Received: from mail-qg0-f43.google.com (mail-qg0-f43.google.com
	[209.85.192.43]) by cuda.sgi.com with ESMTP id ABd79yGzx7SOGXAo
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Jan 2015 11:32:43 -0800 (PST)
Received: by mail-qg0-f43.google.com with SMTP id z107so17849934qgd.2
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 11:32:42 -0800 (PST)
Date: Fri, 16 Jan 2015 14:32:39 -0500
From: Tejun Heo <tj@kernel.org>
Subject: [PATCH workqueue wq/for-3.19-fixes] workqueue: fix subtle pool
	management issue which can stall whole worker_pool
Message-ID: <20150116193239.GA3715@htj.dyndns.org>
References: <54B429EB.9050807@sandeen.net>
	<20150112225314.GC22156@htj.dyndns.org>
	<54B454E2.70707@sandeen.net>
	<20150112233755.GD22156@htj.dyndns.org>
	<54B56D2B.6090401@sandeen.net>
	<20150113201900.GA9489@htj.dyndns.org>
	<54B58041.9070502@sandeen.net>
	<20150113204633.GC9489@htj.dyndns.org>
	<54B5A313.2030300@sandeen.net>
	<20150113233552.GH9489@htj.dyndns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150113233552.GH9489@htj.dyndns.org>
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
To: Eric Sandeen <sandeen@sandeen.net>, Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

>From 29187a9eeaf362d8422e62e17a22a6e115277a49 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 16 Jan 2015 14:21:16 -0500

A worker_pool's forward progress is guaranteed by the fact that the
last idle worker assumes the manager role to create more workers and
summon the rescuers if creating workers doesn't succeed in timely
manner before proceeding to execute work items.

This manager role is implemented in manage_workers(), which indicates
whether the worker may proceed to work item execution with its return
value.  This is necessary because multiple workers may contend for the
manager role, and, if there already is a manager, others should
proceed to work item execution.

Unfortunately, the function also indicates that the worker may proceed
to work item execution if need_to_create_worker() is false at the head
of the function.  need_to_create_worker() tests the following
conditions.

	pending work items && !nr_running && !nr_idle

The first and third conditions are protected by pool->lock and thus
won't change while holding pool->lock; however, nr_running can change
asynchronously as other workers block and resume and while it's likely
to be zero, as someone woke this worker up in the first place, some
other workers could have become runnable inbetween making it non-zero.

If this happens, manage_worker() could return false even with zero
nr_idle making the worker, the last idle one, proceed to execute work
items.  If then all workers of the pool end up blocking on a resource
which can only be released by a work item which is pending on that
pool, the whole pool can deadlock as there's no one to create more
workers or summon the rescuers.

This patch fixes the problem by removing the early exit condition from
maybe_create_worker() and making manage_workers() return false iff
there's already another manager, which ensures that the last worker
doesn't start executing work items.

We can leave the early exit condition alone and just ignore the return
value but the only reason it was put there is because the
manage_workers() used to perform both creations and destructions of
workers and thus the function may be invoked while the pool is trying
to reduce the number of workers.  Now that manage_workers() is called
only when more workers are needed, the only case this early exit
condition is triggered is rare race conditions rendering it pointless.

Tested with simulated workload and modified workqueue code which
trigger the pool deadlock reliably without this patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Eric Sandeen <sandeen@sandeen.net>
Link: http://lkml.kernel.org/g/54B019F4.8030009@sandeen.net
Cc: Dave Chinner <david@fromorbit.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: stable@vger.kernel.org
---
Hello,

It took quite some effort to reproduce the issue and verify the fix,
but this works.  Applying to libata/for-3.19-fixes.

Thansk.

 kernel/workqueue.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6202b08..beeeac9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1841,17 +1841,11 @@ static void pool_mayday_timeout(unsigned long __pool)
  * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.  Does GFP_KERNEL allocations.  Called only from
  * manager.
- *
- * Return:
- * %false if no action was taken and pool->lock stayed locked, %true
- * otherwise.
  */
-static bool maybe_create_worker(struct worker_pool *pool)
+static void maybe_create_worker(struct worker_pool *pool)
 __releases(&pool->lock)
 __acquires(&pool->lock)
 {
-	if (!need_to_create_worker(pool))
-		return false;
 restart:
 	spin_unlock_irq(&pool->lock);
 
@@ -1877,7 +1871,6 @@ restart:
 	 */
 	if (need_to_create_worker(pool))
 		goto restart;
-	return true;
 }
 
 /**
@@ -1897,16 +1890,14 @@ restart:
  * multiple times.  Does GFP_KERNEL allocations.
  *
  * Return:
- * %false if the pool don't need management and the caller can safely start
- * processing works, %true indicates that the function released pool->lock
- * and reacquired it to perform some management function and that the
- * conditions that the caller verified while holding the lock before
- * calling the function might no longer be true.
+ * %false if the pool doesn't need management and the caller can safely
+ * start processing works, %true if management function was performed and
+ * the conditions that the caller verified before calling the function may
+ * no longer be true.
  */
 static bool manage_workers(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
-	bool ret = false;
 
 	/*
 	 * Anyone who successfully grabs manager_arb wins the arbitration
@@ -1919,12 +1910,12 @@ static bool manage_workers(struct worker *worker)
 	 * actual management, the pool may stall indefinitely.
 	 */
 	if (!mutex_trylock(&pool->manager_arb))
-		return ret;
+		return false;
 
-	ret |= maybe_create_worker(pool);
+	maybe_create_worker(pool);
 
 	mutex_unlock(&pool->manager_arb);
-	return ret;
+	return true;
 }
 
 /**
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
