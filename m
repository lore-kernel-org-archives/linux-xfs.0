Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93792C388F2
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C1E52244C
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 05:54:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XxK9WczS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503014AbgJVFya (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 01:54:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53998 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409013AbgJVFya (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 01:54:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M5jr5Q062940;
        Thu, 22 Oct 2020 05:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qC9nCjheFDe7QZnvbm66+cyFjZwzYcTAobNlQNLorxk=;
 b=XxK9WczShfV9Pb8/tJrzUhgeQpJNLAdg49pAH4SWRAmmjICxuEMok+i+P6oEi53hFKXv
 IiqGCQE4VUxDRpYFGiyDwnbrrdiTrX0GZVEvYs4Y3VKuotkdBsROimBH3UHCwy6kZ9FI
 IA5dYxJf+kYK5GtvutiJui+ApuPkJ7kLKjD3NT7d6kGKQ4btvgLAEibaop9ccK1igQjw
 GEfTvIE7gUBk3cr/bMzo08BfDG9B4j6HxZoVEfQ2ulZrNWnamxU6UGlbwZ/jXwNHbMrX
 ocyqaBtEORxbLXl+ZMD//WOD+kCil26VqfYazNrkzOwyAD0qO4WOL1AKABkjtHbkggNG WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 349jrpv2x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 05:54:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M5j12o132032;
        Thu, 22 Oct 2020 05:54:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 348ahycufx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 05:54:27 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09M5sQ7R004999;
        Thu, 22 Oct 2020 05:54:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 22:54:26 -0700
Date:   Wed, 21 Oct 2020 22:54:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] workqueue: bound maximum queue depth
Message-ID: <20201022055425.GN9832@magnolia>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022051537.2286402-2-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=5 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220039
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 04:15:31PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Existing users of workqueues have bound maximum queue depths in
> their external algorithms (e.g. prefetch counts). For parallelising
> work that doesn't have an external bound, allow workqueues to
> throttle incoming requests at a maximum bound. bounded workqueues

Nit: capitalize the 'B' in 'bounded'.

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
> index fe3de4289379..e42b2a2f678b 100644
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

Hmm.  The net effect of this is that we wake up workers faster when a
ton of work comes in, right?  And I bet none of the current workqueue
users have suffered from this because they queue a bunch of work and
then call workqueue_terminate, which wakes all the threads, and they
never go to sleep again.

Does it make sense to simplify the test to "if (wq->next_item) {"?

Other than that, looks good!

--D

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
> 2.28.0
> 
