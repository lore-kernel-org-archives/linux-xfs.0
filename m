Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52193EE3F0C
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 19:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237714AbjILTjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 15:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237716AbjILTjq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 15:39:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB3210D0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 12:39:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B294C433C8;
        Tue, 12 Sep 2023 19:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694547582;
        bh=VGhV2vu2PzTs+sjhXoEkbVXJYws4F+iUpuxN/KBEXq0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MHek2UeQWHOpryOkHPotVOJYVPZHNoiYd+5HEgB3+ELMj+3BN4E2t+IaDm+fr6cNS
         rmTWt2Pj4SzkZ/f52GXjTt6puYKElipe1KfInToEXAWS2OEKi1dQCKKP2rtA/Xlt0+
         /61g+vGpRRCxlJq6leaVFrJoBEcd2KKUO1vUGfWX7yC3qh1ruN9wCdRkczDxTb+6mu
         +LnYIzjAVgfMIoA5qrkVeY0h+xnzccSZaJrWmZ2zIopPsSDfxG2qwSMvvmxdl4seqE
         Woqqc5CL7UEwZQrjqI9Du7u3TkHKC6C6UUtICdyCMMgMvtxCr8L57joSPpVTvgfoFy
         rMXqWmbRwDuNQ==
Subject: [PATCH 1/6] libfrog: fix overly sleep workqueues
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 12 Sep 2023 12:39:41 -0700
Message-ID: <169454758152.3539425.17620295149533266267.stgit@frogsfrogsfrogs>
In-Reply-To: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I discovered the following bad behavior in the workqueue code when I
noticed that xfs_scrub was running single-threaded despite having 4
virtual CPUs allocated to the VM.  I observed this sequence:

Thread 1	WQ1		WQ2...N
workqueue_create
		<start up>
		pthread_cond_wait
				<start up>
				pthread_cond_wait
workqueue_add
next_item == NULL
pthread_cond_signal

workqueue_add
next_item != NULL
<do not pthread_cond_signal>

		<receives wakeup>
		<run first item>

workqueue_add
next_item != NULL
<do not pthread_cond_signal>

		<run second item>
		<run third item>
		pthread_cond_wait

workqueue_terminate
pthread_cond_broadcast
				<receives wakeup>
				<nothing to do, exits>
		<wakes up again>
		<nothing to do, exits>

Notice how threads WQ2...N are completely idle while WQ1 ends up doing
all the work!  That wasn't the point of a worker pool!  Observe that
thread 1 manages to queue two work items before WQ1 pulls the first item
off the queue.  When thread 1 queues the third item, it sees that
next_item is not NULL, so it doesn't wake a worker.  If thread 1 queues
all the N work that it has before WQ1 empties the queue, then none of
the other thread get woken up.

Fix this by maintaining a count of the number of active threads, and
using that to wake either the sole idle thread, or all the threads if
there are many that are idle.  This dramatically improves startup
behavior of the workqueue and eliminates the collapse case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/workqueue.c |   34 ++++++++++++++++++++++++----------
 libfrog/workqueue.h |    1 +
 2 files changed, 25 insertions(+), 10 deletions(-)


diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index 702a53e2f3c..db5b3f68bc5 100644
--- a/libfrog/workqueue.c
+++ b/libfrog/workqueue.c
@@ -26,8 +26,8 @@ workqueue_thread(void *arg)
 	 * Check for notification to exit after every chunk of work.
 	 */
 	rcu_register_thread();
+	pthread_mutex_lock(&wq->lock);
 	while (1) {
-		pthread_mutex_lock(&wq->lock);
 
 		/*
 		 * Wait for work.
@@ -36,10 +36,8 @@ workqueue_thread(void *arg)
 			assert(wq->item_count == 0);
 			pthread_cond_wait(&wq->wakeup, &wq->lock);
 		}
-		if (wq->next_item == NULL && wq->terminate) {
-			pthread_mutex_unlock(&wq->lock);
+		if (wq->next_item == NULL && wq->terminate)
 			break;
-		}
 
 		/*
 		 *  Dequeue work from the head of the list. If the queue was
@@ -57,11 +55,16 @@ workqueue_thread(void *arg)
 			/* more work, wake up another worker */
 			pthread_cond_signal(&wq->wakeup);
 		}
+		wq->active_threads++;
 		pthread_mutex_unlock(&wq->lock);
 
 		(wi->function)(wi->queue, wi->index, wi->arg);
 		free(wi);
+
+		pthread_mutex_lock(&wq->lock);
+		wq->active_threads--;
 	}
+	pthread_mutex_unlock(&wq->lock);
 	rcu_unregister_thread();
 
 	return NULL;
@@ -170,12 +173,6 @@ workqueue_add(
 restart:
 	if (wq->next_item == NULL) {
 		assert(wq->item_count == 0);
-		ret = -pthread_cond_signal(&wq->wakeup);
-		if (ret) {
-			pthread_mutex_unlock(&wq->lock);
-			free(wi);
-			return ret;
-		}
 		wq->next_item = wi;
 	} else {
 		/* throttle on a full queue if configured */
@@ -192,6 +189,23 @@ workqueue_add(
 	}
 	wq->last_item = wi;
 	wq->item_count++;
+
+	if (wq->active_threads == wq->thread_count - 1) {
+		/* One thread is idle, wake it */
+		ret = -pthread_cond_signal(&wq->wakeup);
+		if (ret) {
+			pthread_mutex_unlock(&wq->lock);
+			return ret;
+		}
+	} else if (wq->active_threads < wq->thread_count) {
+		/* Multiple threads are idle, wake everyone */
+		ret = -pthread_cond_broadcast(&wq->wakeup);
+		if (ret) {
+			pthread_mutex_unlock(&wq->lock);
+			return ret;
+		}
+	}
+
 	pthread_mutex_unlock(&wq->lock);
 
 	return 0;
diff --git a/libfrog/workqueue.h b/libfrog/workqueue.h
index a9c108d0e66..edbe12fabab 100644
--- a/libfrog/workqueue.h
+++ b/libfrog/workqueue.h
@@ -29,6 +29,7 @@ struct workqueue {
 	pthread_cond_t		wakeup;
 	unsigned int		item_count;
 	unsigned int		thread_count;
+	unsigned int		active_threads;
 	bool			terminate;
 	bool			terminated;
 	int			max_queued;

