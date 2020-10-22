Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A05C388F7
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3780C2225F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502876AbgJVFdC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 01:33:02 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49089 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502871AbgJVFdC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 01:33:02 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7B3953AC0B3
        for <linux-xfs@vger.kernel.org>; Thu, 22 Oct 2020 16:32:58 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kVSwr-0034Km-PD
        for linux-xfs@vger.kernel.org; Thu, 22 Oct 2020 16:15:37 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kVSwr-009aoD-He
        for linux-xfs@vger.kernel.org; Thu, 22 Oct 2020 16:15:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/7] workqueue: bound maximum queue depth
Date:   Thu, 22 Oct 2020 16:15:31 +1100
Message-Id: <20201022051537.2286402-2-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201022051537.2286402-1-david@fromorbit.com>
References: <20201022051537.2286402-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=vJvmB_99ysriVlu2_BwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
 libfrog/workqueue.c | 42 +++++++++++++++++++++++++++++++++++++++---
 libfrog/workqueue.h |  4 ++++
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index fe3de4289379..e42b2a2f678b 100644
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
@@ -58,10 +66,11 @@ workqueue_thread(void *arg)
 
 /* Allocate a work queue and threads.  Returns zero or negative error code. */
 int
-workqueue_create(
+workqueue_create_bound(
 	struct workqueue	*wq,
 	void			*wq_ctx,
-	unsigned int		nr_workers)
+	unsigned int		nr_workers,
+	unsigned int		max_queue)
 {
 	unsigned int		i;
 	int			err = 0;
@@ -70,12 +79,16 @@ workqueue_create(
 	err = -pthread_cond_init(&wq->wakeup, NULL);
 	if (err)
 		return err;
+	err = -pthread_cond_init(&wq->queue_full, NULL);
+	if (err)
+		goto out_wake;
 	err = -pthread_mutex_init(&wq->lock, NULL);
 	if (err)
 		goto out_cond;
 
 	wq->wq_ctx = wq_ctx;
 	wq->thread_count = nr_workers;
+	wq->max_queued = max_queue;
 	wq->threads = malloc(nr_workers * sizeof(pthread_t));
 	if (!wq->threads) {
 		err = -errno;
@@ -102,10 +115,21 @@ workqueue_create(
 out_mutex:
 	pthread_mutex_destroy(&wq->lock);
 out_cond:
+	pthread_cond_destroy(&wq->queue_full);
+out_wake:
 	pthread_cond_destroy(&wq->wakeup);
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
  * Create a work item consisting of a function and some arguments and schedule
  * the work item to be run via the thread pool.  Returns zero or a negative
@@ -140,6 +164,7 @@ workqueue_add(
 
 	/* Now queue the new work structure to the work queue. */
 	pthread_mutex_lock(&wq->lock);
+restart:
 	if (wq->next_item == NULL) {
 		assert(wq->item_count == 0);
 		ret = -pthread_cond_signal(&wq->wakeup);
@@ -150,6 +175,16 @@ workqueue_add(
 		}
 		wq->next_item = wi;
 	} else {
+		/* throttle on a full queue if configured */
+		if (wq->max_queued && wq->item_count == wq->max_queued) {
+			pthread_cond_wait(&wq->queue_full, &wq->lock);
+			/*
+			 * Queue might be empty or even still full by the time
+			 * we get the lock back, so restart the lookup so we do
+			 * the right thing with the current state of the queue.
+			 */
+			goto restart;
+		}
 		wq->last_item->next = wi;
 	}
 	wq->last_item = wi;
@@ -201,5 +236,6 @@ workqueue_destroy(
 	free(wq->threads);
 	pthread_mutex_destroy(&wq->lock);
 	pthread_cond_destroy(&wq->wakeup);
+	pthread_cond_destroy(&wq->queue_full);
 	memset(wq, 0, sizeof(*wq));
 }
diff --git a/libfrog/workqueue.h b/libfrog/workqueue.h
index a56d1cf14081..a9c108d0e66a 100644
--- a/libfrog/workqueue.h
+++ b/libfrog/workqueue.h
@@ -31,10 +31,14 @@ struct workqueue {
 	unsigned int		thread_count;
 	bool			terminate;
 	bool			terminated;
+	int			max_queued;
+	pthread_cond_t		queue_full;
 };
 
 int workqueue_create(struct workqueue *wq, void *wq_ctx,
 		unsigned int nr_workers);
+int workqueue_create_bound(struct workqueue *wq, void *wq_ctx,
+		unsigned int nr_workers, unsigned int max_queue);
 int workqueue_add(struct workqueue *wq, workqueue_func_t fn,
 		uint32_t index, void *arg);
 int workqueue_terminate(struct workqueue *wq);
-- 
2.28.0

