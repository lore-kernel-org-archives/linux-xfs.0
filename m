Return-Path: <SRS0=dP94=EA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D67C4363A
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Oct 2020 04:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CB1022202
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Oct 2020 04:41:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DlMQVrLp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1767027AbgJYElV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Oct 2020 00:41:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729864AbgJYElU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Oct 2020 00:41:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09P4fIg1112929;
        Sun, 25 Oct 2020 04:41:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7ZWLu9+tl87/1ExuAKWOaZz9KPs00CnvVVAN7SCCyYY=;
 b=DlMQVrLpxXZMij6NJf7iyz1AX3YZhlHS5fhp10EzBmh6xxy/yTlyF435bJA729m/KP/5
 IKApYld7qHm05diqzMYNaJKYD0gF7JiZa0bACMgu7+CC9/eoiFGAxXVAra5LPNT2OlBO
 EFw/LeZD760LZe5VoeT3z5ETFz/m/mBrN4423Jrc60FtC+PDhK/RVSaoEpvd+A5dAA7B
 HZowPnCFZlz0+kwuPuAV9O/USzquQiVHh27UrBFCEslw8rnXdoHgNnnpmKMnBU3uHvpc
 HgsYeNGLr8Z3bNied+49rI3znKSVIk07nt/IrmU8NqHWHRGpgCrgmugOhqRvXP2ItWQx 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34ccwmhc87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 25 Oct 2020 04:41:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09P4e7NO146084;
        Sun, 25 Oct 2020 04:41:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1nkxt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Oct 2020 04:41:17 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09P4fFXb020065;
        Sun, 25 Oct 2020 04:41:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 21:41:15 -0700
Date:   Sat, 24 Oct 2020 21:41:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] workqueue: bound maximum queue depth
Message-ID: <20201025044114.GA347246@magnolia>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022051537.2286402-2-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=5 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010250033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=5
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010250033
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

I ported xfs_scrub to use max_queued for the inode scanner, and got a
hang here.  It uses two workqueues -- the first is an unbouned workqueue
that receives one work item per AG in which each work item calls
INUMBERS, creates a work item for the returned inode chunk, and throws
it at the second workqueue.  The second workqueue is a bounded workqueue
that calls BULKSTAT on the INUMBERS work item and then calls the
iteration function on each bulkstat record returned.

The hang happens when the inumbers workqueue has more than one thread
running.  Both* threads notice the full workqueue and wait on
queue_full.  One of the workers in the second workqueue goes to pull off
the next work item, ends up in this if body, signals one of the sleeping
threads, and starts calling bulkstat.

In the time it takes to wake up the sleeping thread from wq 1, the
second workqueue pulls far enough ahead that the single thread from wq1
never manages to fill wq2 again.  Often, the wq1 thread was sleeping so
that it could add the last inode chunk of that AG to wq2.  We therefore
never wake up the *other* sleeping thread from wq1, and the whole app
stalls.

I dunno if that's a sane way to structure an inumbers/bulkstat scan, but
it seemed reasonable to me.  I can envision two possible fixes here: (1)
use pthread_cond_broadcast to wake everything up; or (2) always call
pthread_cond_wait when we pull a work item off the queue.  Thoughts?

--D

*by "both threads" I really mean "the other 31 threads that are asleep
trying to add things to wq2" but afaict this is a general problem.

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
