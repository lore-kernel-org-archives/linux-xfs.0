Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from LGEAMRELO12.lge.com ([156.147.23.52]:39917 "EHLO
        lgeamrelo12.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936571AbdJRJjP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 05:39:15 -0400
From: Byungchul Park <byungchul.park@lge.com>
Subject: [RESEND PATCH 2/3] lockdep: Remove unnecessary acquisitions wrt workqueue flush
Date: Wed, 18 Oct 2017 18:38:51 +0900
Message-Id: <1508319532-24655-3-git-send-email-byungchul.park@lge.com>
In-Reply-To: <1508319532-24655-1-git-send-email-byungchul.park@lge.com>
References: <1508319532-24655-1-git-send-email-byungchul.park@lge.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: peterz@infradead.org, mingo@kernel.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com

The workqueue added manual acquisitions to catch deadlock cases.
Now crossrelease was introduced, some of those are redundant, since
wait_for_completion() already includes the acquisition for itself.
Removed it.

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 include/linux/workqueue.h |  4 ++--
 kernel/workqueue.c        | 20 ++++----------------
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index db6dc9d..1bef13e 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -218,7 +218,7 @@ static inline void destroy_delayed_work_on_stack(struct delayed_work *work) { }
 									\
 		__init_work((_work), _onstack);				\
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
-		lockdep_init_map(&(_work)->lockdep_map, #_work, &__key, 0); \
+		lockdep_init_map(&(_work)->lockdep_map, "(complete)"#_work, &__key, 0); \
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		(_work)->func = (_func);				\
 	} while (0)
@@ -398,7 +398,7 @@ enum {
 	static struct lock_class_key __key;				\
 	const char *__lock_name;					\
 									\
-	__lock_name = #fmt#args;					\
+	__lock_name = "(complete)"#fmt#args;				\
 									\
 	__alloc_workqueue_key((fmt), (flags), (max_active),		\
 			      &__key, __lock_name, ##args);		\
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ab3c0dc..72f68b1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2497,15 +2497,8 @@ static void insert_wq_barrier(struct pool_workqueue *pwq,
 	INIT_WORK_ONSTACK(&barr->work, wq_barrier_func);
 	__set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(&barr->work));
 
-	/*
-	 * Explicitly init the crosslock for wq_barrier::done, make its lock
-	 * key a subkey of the corresponding work. As a result we won't
-	 * build a dependency between wq_barrier::done and unrelated work.
-	 */
-	lockdep_init_map_crosslock((struct lockdep_map *)&barr->done.map,
-				   "(complete)wq_barr::done",
-				   target->lockdep_map.key, 1);
-	__init_completion(&barr->done);
+	init_completion_with_map(&barr->done, &target->lockdep_map);
+
 	barr->task = current;
 
 	/*
@@ -2611,16 +2604,14 @@ void flush_workqueue(struct workqueue_struct *wq)
 	struct wq_flusher this_flusher = {
 		.list = LIST_HEAD_INIT(this_flusher.list),
 		.flush_color = -1,
-		.done = COMPLETION_INITIALIZER_ONSTACK(this_flusher.done),
 	};
 	int next_color;
 
+	init_completion_with_map(&this_flusher.done, &wq->lockdep_map);
+
 	if (WARN_ON(!wq_online))
 		return;
 
-	lock_map_acquire(&wq->lockdep_map);
-	lock_map_release(&wq->lockdep_map);
-
 	mutex_lock(&wq->mutex);
 
 	/*
@@ -2883,9 +2874,6 @@ bool flush_work(struct work_struct *work)
 	if (WARN_ON(!wq_online))
 		return false;
 
-	lock_map_acquire(&work->lockdep_map);
-	lock_map_release(&work->lockdep_map);
-
 	if (start_flush_work(work, &barr)) {
 		wait_for_completion(&barr.done);
 		destroy_work_on_stack(&barr.work);
-- 
1.9.1

