Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58746 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbeJaCxM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 22:53:12 -0400
Date: Tue, 30 Oct 2018 10:58:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/7] workqueue: bound maximum queue depth
Message-ID: <20181030175839.GM4135@magnolia>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030112043.6034-5-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 30, 2018 at 10:20:40PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Existing users of workqueues have bound maximum queue depths in
> their external algorithms (e.g. prefetch counts). For parallelising
> work that doesn't have an external bound, allow workqueues to
> throttle incoming requests at a maximum bound. bounded workqueues
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
>  include/workqueue.h |  4 ++++
>  libfrog/workqueue.c | 30 +++++++++++++++++++++++++++---
>  2 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/include/workqueue.h b/include/workqueue.h
> index c45dc4fbcf64..504da9403b85 100644
> --- a/include/workqueue.h
> +++ b/include/workqueue.h
> @@ -30,10 +30,14 @@ struct workqueue {
>  	unsigned int		item_count;
>  	unsigned int		thread_count;
>  	bool			terminate;
> +	int			max_queued;
> +	pthread_cond_t		queue_full;
>  };
>  
>  int workqueue_create(struct workqueue *wq, void *wq_ctx,
>  		unsigned int nr_workers);
> +int workqueue_create_bound(struct workqueue *wq, void *wq_ctx,
> +		unsigned int nr_workers, int max_queue);

What does negative max_queue mean?

>  int workqueue_add(struct workqueue *wq, workqueue_func_t fn,
>  		uint32_t index, void *arg);
>  void workqueue_destroy(struct workqueue *wq);
> diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
> index 7311477374b4..8fe0dc7249f5 100644
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
> +			pthread_cond_signal(&wq->queue_full);
> +
>  		wi = wq->next_item;
>  		wq->next_item = wi->next;
>  		wq->item_count--;
>  
> +		if (wq->max_queued && wq->next_item) {
> +			/* more work, wake up another worker */
> +			pthread_cond_signal(&wq->wakeup);
> +		}

It seems a little funny to me that the worker thread wakes up other
worker threads when there is more work to do (vs. workqueue_add which
actually added more work)...

--D

>  		pthread_mutex_unlock(&wq->lock);
>  
>  		(wi->function)(wi->queue, wi->index, wi->arg);
> @@ -58,22 +66,25 @@ workqueue_thread(void *arg)
>  
>  /* Allocate a work queue and threads. */
>  int
> -workqueue_create(
> +workqueue_create_bound(
>  	struct workqueue	*wq,
>  	void			*wq_ctx,
> -	unsigned int		nr_workers)
> +	unsigned int		nr_workers,
> +	int			max_queue)
>  {
>  	unsigned int		i;
>  	int			err = 0;
>  
>  	memset(wq, 0, sizeof(*wq));
>  	pthread_cond_init(&wq->wakeup, NULL);
> +	pthread_cond_init(&wq->queue_full, NULL);
>  	pthread_mutex_init(&wq->lock, NULL);
>  
>  	wq->wq_ctx = wq_ctx;
>  	wq->thread_count = nr_workers;
>  	wq->threads = malloc(nr_workers * sizeof(pthread_t));
>  	wq->terminate = false;
> +	wq->max_queued = max_queue;
>  
>  	for (i = 0; i < nr_workers; i++) {
>  		err = pthread_create(&wq->threads[i], NULL, workqueue_thread,
> @@ -87,6 +98,15 @@ workqueue_create(
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
>   * Create a work item consisting of a function and some arguments and
>   * schedule the work item to be run via the thread pool.
> @@ -122,6 +142,9 @@ workqueue_add(
>  		assert(wq->item_count == 0);
>  		pthread_cond_signal(&wq->wakeup);
>  	} else {
> +		/* throttle on a full queue if configured */
> +		if (wq->max_queued && wq->item_count == wq->max_queued)
> +			pthread_cond_wait(&wq->queue_full, &wq->lock);
>  		wq->last_item->next = wi;
>  	}
>  	wq->last_item = wi;
> @@ -153,5 +176,6 @@ workqueue_destroy(
>  	free(wq->threads);
>  	pthread_mutex_destroy(&wq->lock);
>  	pthread_cond_destroy(&wq->wakeup);
> +	pthread_cond_destroy(&wq->queue_full);
>  	memset(wq, 0, sizeof(*wq));
>  }
> -- 
> 2.19.1
> 
