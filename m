Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F46C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17D2864E64
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhCSBqQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 21:46:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229896AbhCSBp7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 21:45:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58FA464E45;
        Fri, 19 Mar 2021 01:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616118359;
        bh=5/btSRkOM2FhWgqrb7XF2haP5b5hPo3cIV5oHy32a6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HmuXN5fdEWXwxNF48Sk/9/7wDQiBTUoQhid8IMbbf187w01vXh0SzBgdlZ5knEth6
         J/uD9Av4jdA6noSXznamG6ccoEMF3IB1CASMFWtBABwfofbeEkeROCzif37XeZ3c0j
         OCVlQqdI89FmQlb9NNU3q/RpqGXD4u3IfQV3feOTISiZvsY9icH60ux1Hm6AjWKpTu
         FxJloeKVGPrRJ5OHwOACrGTGbQAhZ+QcpKjaEIsbJRflh5LVD0RwFDoZPd8ynLwm6t
         OP5Aue/OEnzNvSZdv1mJrQBw0j+X9uNmgoYZMQoBFhksqcwhQTxFiumoQEQkLUbEIN
         39Cai1Hf0M7Bw==
Date:   Thu, 18 Mar 2021 18:45:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hsiangkao@redhat.com
Subject: Re: [PATCH 1/7] workqueue: bound maximum queue depth
Message-ID: <20210319014558.GC1670408@magnolia>
References: <20210319013355.776008-1-david@fromorbit.com>
 <20210319013355.776008-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319013355.776008-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 12:33:49PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Existing users of workqueues have bound maximum queue depths in
> their external algorithms (e.g. prefetch counts). For parallelising
> work that doesn't have an external bound, allow workqueues to
> throttle incoming requests at a maximum bound. Bounded workqueues
> also need to distribute work over all worker threads themselves as
> there is no external bounding or worker function throttling
> provided.
> 
> Existing callers are not throttled and retain direct control of
> worker threads, only users of the new create interface will be
> throttled and concurrency managed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libfrog/workqueue.c | 42 +++++++++++++++++++++++++++++++++++++++---
>  libfrog/workqueue.h |  4 ++++
>  2 files changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
> index fe3de4289379..97f3bf76d9b9 100644
> --- a/libfrog/workqueue.c
> +++ b/libfrog/workqueue.c
> @@ -40,13 +40,21 @@ workqueue_thread(void *arg)
>  		}
>  
>  		/*
> -		 *  Dequeue work from the head of the list.
> +		 *  Dequeue work from the head of the list. If the queue was
> +		 *  full then send a wakeup if we're configured to do so.
>  		 */
>  		assert(wq->item_count > 0);
> +		if (wq->max_queued && wq->item_count == wq->max_queued)
> +			pthread_cond_broadcast(&wq->queue_full);

FWIW I'll probably end up changing this to:

	if (wq->max_queued)
			pthread_cond_signal(&wq->queue_full);

To support multiple producers whenever I get around to posting the giant
scrub rewrite that is .... 272nd in line.  In the meantime:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  		wi = wq->next_item;
>  		wq->next_item = wi->next;
>  		wq->item_count--;
>  
> +		if (wq->max_queued && wq->next_item) {
> +			/* more work, wake up another worker */
> +			pthread_cond_signal(&wq->wakeup);
> +		}
>  		pthread_mutex_unlock(&wq->lock);
>  
>  		(wi->function)(wi->queue, wi->index, wi->arg);
> @@ -58,10 +66,11 @@ workqueue_thread(void *arg)
>  
>  /* Allocate a work queue and threads.  Returns zero or negative error code. */
>  int
> -workqueue_create(
> +workqueue_create_bound(
>  	struct workqueue	*wq,
>  	void			*wq_ctx,
> -	unsigned int		nr_workers)
> +	unsigned int		nr_workers,
> +	unsigned int		max_queue)
>  {
>  	unsigned int		i;
>  	int			err = 0;
> @@ -70,12 +79,16 @@ workqueue_create(
>  	err = -pthread_cond_init(&wq->wakeup, NULL);
>  	if (err)
>  		return err;
> +	err = -pthread_cond_init(&wq->queue_full, NULL);
> +	if (err)
> +		goto out_wake;
>  	err = -pthread_mutex_init(&wq->lock, NULL);
>  	if (err)
>  		goto out_cond;
>  
>  	wq->wq_ctx = wq_ctx;
>  	wq->thread_count = nr_workers;
> +	wq->max_queued = max_queue;
>  	wq->threads = malloc(nr_workers * sizeof(pthread_t));
>  	if (!wq->threads) {
>  		err = -errno;
> @@ -102,10 +115,21 @@ workqueue_create(
>  out_mutex:
>  	pthread_mutex_destroy(&wq->lock);
>  out_cond:
> +	pthread_cond_destroy(&wq->queue_full);
> +out_wake:
>  	pthread_cond_destroy(&wq->wakeup);
>  	return err;
>  }
>  
> +int
> +workqueue_create(
> +	struct workqueue	*wq,
> +	void			*wq_ctx,
> +	unsigned int		nr_workers)
> +{
> +	return workqueue_create_bound(wq, wq_ctx, nr_workers, 0);
> +}
> +
>  /*
>   * Create a work item consisting of a function and some arguments and schedule
>   * the work item to be run via the thread pool.  Returns zero or a negative
> @@ -140,6 +164,7 @@ workqueue_add(
>  
>  	/* Now queue the new work structure to the work queue. */
>  	pthread_mutex_lock(&wq->lock);
> +restart:
>  	if (wq->next_item == NULL) {
>  		assert(wq->item_count == 0);
>  		ret = -pthread_cond_signal(&wq->wakeup);
> @@ -150,6 +175,16 @@ workqueue_add(
>  		}
>  		wq->next_item = wi;
>  	} else {
> +		/* throttle on a full queue if configured */
> +		if (wq->max_queued && wq->item_count == wq->max_queued) {
> +			pthread_cond_wait(&wq->queue_full, &wq->lock);
> +			/*
> +			 * Queue might be empty or even still full by the time
> +			 * we get the lock back, so restart the lookup so we do
> +			 * the right thing with the current state of the queue.
> +			 */
> +			goto restart;
> +		}
>  		wq->last_item->next = wi;
>  	}
>  	wq->last_item = wi;
> @@ -201,5 +236,6 @@ workqueue_destroy(
>  	free(wq->threads);
>  	pthread_mutex_destroy(&wq->lock);
>  	pthread_cond_destroy(&wq->wakeup);
> +	pthread_cond_destroy(&wq->queue_full);
>  	memset(wq, 0, sizeof(*wq));
>  }
> diff --git a/libfrog/workqueue.h b/libfrog/workqueue.h
> index a56d1cf14081..a9c108d0e66a 100644
> --- a/libfrog/workqueue.h
> +++ b/libfrog/workqueue.h
> @@ -31,10 +31,14 @@ struct workqueue {
>  	unsigned int		thread_count;
>  	bool			terminate;
>  	bool			terminated;
> +	int			max_queued;
> +	pthread_cond_t		queue_full;
>  };
>  
>  int workqueue_create(struct workqueue *wq, void *wq_ctx,
>  		unsigned int nr_workers);
> +int workqueue_create_bound(struct workqueue *wq, void *wq_ctx,
> +		unsigned int nr_workers, unsigned int max_queue);
>  int workqueue_add(struct workqueue *wq, workqueue_func_t fn,
>  		uint32_t index, void *arg);
>  int workqueue_terminate(struct workqueue *wq);
> -- 
> 2.30.1
> 
