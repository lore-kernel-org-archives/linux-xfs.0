Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:52328 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727689AbeJ3UN6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 16:13:58 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4k-0005bt-VM
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:47 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4k-0001jf-Ts
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/7] workqueue: bound maximum queue depth
Date: Tue, 30 Oct 2018 22:20:40 +1100
Message-Id: <20181030112043.6034-5-david@fromorbit.com>
In-Reply-To: <20181030112043.6034-1-david@fromorbit.com>
References: <20181030112043.6034-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Existing users of workqueues have bound maximum queue depths in
their external algorithms (e.g. prefetch counts). For parallelising
work that doesn't have an external bound, allow workqueues to
throttle incoming requests at a maximum bound. bounded workqueues
also need to distribute work over all worker threads themselves as
there is no external bounding or worker function throttling
provided.

Existing callers are not throttled and retain direct control of
worker threads, only users of the new create interface will be
throttled and concurrency managed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/workqueue.h |  4 ++++
 libfrog/workqueue.c | 30 +++++++++++++++++++++++++++---
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/include/workqueue.h b/include/workqueue.h
index c45dc4fbcf64..504da9403b85 100644
--- a/include/workqueue.h
+++ b/include/workqueue.h
@@ -30,10 +30,14 @@ struct workqueue {
 	unsigned int		item_count;
 	unsigned int		thread_count;
 	bool			terminate;
+	int			max_queued;
+	pthread_cond_t		queue_full;
 };
 
 int workqueue_create(struct workqueue *wq, void *wq_ctx,
 		unsigned int nr_workers);
+int workqueue_create_bound(struct workqueue *wq, void *wq_ctx,
+		unsigned int nr_workers, int max_queue);
 int workqueue_add(struct workqueue *wq, workqueue_func_t fn,
 		uint32_t index, void *arg);
 void workqueue_destroy(struct workqueue *wq);
diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index 7311477374b4..8fe0dc7249f5 100644
--- a/libfrog/workqueue.c
+++ b/libfrog/workqueue.c
@@ -40,13 +40,21 @@ workqueue_thread(void *arg)
 		}
 
 		/*
-		 *  Dequeue work from the head of the list.
+		 *  Dequeue work from the head of the list. If the queue was
+		 *  full then send a wakeup if we're configured to do so.
 		 */
 		assert(wq->item_count > 0);
+		if (wq->max_queued && wq->item_count == wq->max_queued)
+			pthread_cond_signal(&wq->queue_full);
+
 		wi = wq->next_item;
 		wq->next_item = wi->next;
 		wq->item_count--;
 
+		if (wq->max_queued && wq->next_item) {
+			/* more work, wake up another worker */
+			pthread_cond_signal(&wq->wakeup);
+		}
 		pthread_mutex_unlock(&wq->lock);
 
 		(wi->function)(wi->queue, wi->index, wi->arg);
@@ -58,22 +66,25 @@ workqueue_thread(void *arg)
 
 /* Allocate a work queue and threads. */
 int
-workqueue_create(
+workqueue_create_bound(
 	struct workqueue	*wq,
 	void			*wq_ctx,
-	unsigned int		nr_workers)
+	unsigned int		nr_workers,
+	int			max_queue)
 {
 	unsigned int		i;
 	int			err = 0;
 
 	memset(wq, 0, sizeof(*wq));
 	pthread_cond_init(&wq->wakeup, NULL);
+	pthread_cond_init(&wq->queue_full, NULL);
 	pthread_mutex_init(&wq->lock, NULL);
 
 	wq->wq_ctx = wq_ctx;
 	wq->thread_count = nr_workers;
 	wq->threads = malloc(nr_workers * sizeof(pthread_t));
 	wq->terminate = false;
+	wq->max_queued = max_queue;
 
 	for (i = 0; i < nr_workers; i++) {
 		err = pthread_create(&wq->threads[i], NULL, workqueue_thread,
@@ -87,6 +98,15 @@ workqueue_create(
 	return err;
 }
 
+int
+workqueue_create(
+	struct workqueue	*wq,
+	void			*wq_ctx,
+	unsigned int		nr_workers)
+{
+	return workqueue_create_bound(wq, wq_ctx, nr_workers, 0);
+}
+
 /*
  * Create a work item consisting of a function and some arguments and
  * schedule the work item to be run via the thread pool.
@@ -122,6 +142,9 @@ workqueue_add(
 		assert(wq->item_count == 0);
 		pthread_cond_signal(&wq->wakeup);
 	} else {
+		/* throttle on a full queue if configured */
+		if (wq->max_queued && wq->item_count == wq->max_queued)
+			pthread_cond_wait(&wq->queue_full, &wq->lock);
 		wq->last_item->next = wi;
 	}
 	wq->last_item = wi;
@@ -153,5 +176,6 @@ workqueue_destroy(
 	free(wq->threads);
 	pthread_mutex_destroy(&wq->lock);
 	pthread_cond_destroy(&wq->wakeup);
+	pthread_cond_destroy(&wq->queue_full);
 	memset(wq, 0, sizeof(*wq));
 }
-- 
2.19.1
