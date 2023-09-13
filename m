Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B830EDEC49
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Sep 2023 12:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbjIMMla (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Sep 2023 08:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbjIMMla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2023 08:41:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B76B19AC
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2023 05:41:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1A6C433C8;
        Wed, 13 Sep 2023 12:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694608885;
        bh=C6nCDq7s1rg2NYoVJRqc2vHuUFsi0fgRGiwhKBcP4zg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uTkXHC+aFIlNXxZ4OPEKcIGCpY85/cFklOWrpnuP8pxDjjEALGdewX1JMiWwcEmMc
         LvkXPUaRszU+teqmoETvZUsWZGTED6tFVYtFpAnrt0UEX+v+JUwi5UnjRIK2aGYXae
         HtpL3T4VY3+dTJPqIzqhECRmzcYG+aNqb2XwNBYEuJw+PEHxsiR7tOXoMuG1B133Z/
         Zo+eit/V1hr8+nclER9Lj61iJHKVbA3qTMzsysvvSKEyXg7sTzfUYhw49usjaHBJ91
         SKYo7xNl82U8tssKABumArWCvr/bqYuZhmR79muSjfDK0PXkxGZBgimZvQH8hoIcn+
         MDXpio4zSKtpw==
Date:   Wed, 13 Sep 2023 14:41:21 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] libfrog: fix overly sleep workqueues
Message-ID: <20230913124121.sz6keo7p73ps57g4@andromeda>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
 <CVflIDL2YqFJnsXp3FTAwWZ9_tCVv3tSKoPhU-dUmZbnzKKOW-9BAW4QE-ACM6kdJpWFTUYkDzba6NPYfq5TUA==@protonmail.internalid>
 <169454758152.3539425.17620295149533266267.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169454758152.3539425.17620295149533266267.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:39:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I discovered the following bad behavior in the workqueue code when I
> noticed that xfs_scrub was running single-threaded despite having 4
> virtual CPUs allocated to the VM.  I observed this sequence:
> 
> Thread 1	WQ1		WQ2...N
> workqueue_create
> 		<start up>
> 		pthread_cond_wait
> 				<start up>
> 				pthread_cond_wait
> workqueue_add
> next_item == NULL
> pthread_cond_signal
> 
> workqueue_add
> next_item != NULL
> <do not pthread_cond_signal>
> 
> 		<receives wakeup>
> 		<run first item>
> 
> workqueue_add
> next_item != NULL
> <do not pthread_cond_signal>
> 
> 		<run second item>
> 		<run third item>
> 		pthread_cond_wait
> 
> workqueue_terminate
> pthread_cond_broadcast
> 				<receives wakeup>
> 				<nothing to do, exits>
> 		<wakes up again>
> 		<nothing to do, exits>
> 
> Notice how threads WQ2...N are completely idle while WQ1 ends up doing
> all the work!  That wasn't the point of a worker pool!  Observe that
> thread 1 manages to queue two work items before WQ1 pulls the first item
> off the queue.  When thread 1 queues the third item, it sees that
> next_item is not NULL, so it doesn't wake a worker.  If thread 1 queues
> all the N work that it has before WQ1 empties the queue, then none of
> the other thread get woken up.
> 
> Fix this by maintaining a count of the number of active threads, and
> using that to wake either the sole idle thread, or all the threads if
> there are many that are idle.  This dramatically improves startup
> behavior of the workqueue and eliminates the collapse case.
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  libfrog/workqueue.c |   34 ++++++++++++++++++++++++----------
>  libfrog/workqueue.h |    1 +
>  2 files changed, 25 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
> index 702a53e2f3c..db5b3f68bc5 100644
> --- a/libfrog/workqueue.c
> +++ b/libfrog/workqueue.c
> @@ -26,8 +26,8 @@ workqueue_thread(void *arg)
>  	 * Check for notification to exit after every chunk of work.
>  	 */
>  	rcu_register_thread();
> +	pthread_mutex_lock(&wq->lock);
>  	while (1) {
> -		pthread_mutex_lock(&wq->lock);
> 
>  		/*
>  		 * Wait for work.
> @@ -36,10 +36,8 @@ workqueue_thread(void *arg)
>  			assert(wq->item_count == 0);
>  			pthread_cond_wait(&wq->wakeup, &wq->lock);
>  		}
> -		if (wq->next_item == NULL && wq->terminate) {
> -			pthread_mutex_unlock(&wq->lock);
> +		if (wq->next_item == NULL && wq->terminate)
>  			break;
> -		}
> 
>  		/*
>  		 *  Dequeue work from the head of the list. If the queue was
> @@ -57,11 +55,16 @@ workqueue_thread(void *arg)
>  			/* more work, wake up another worker */
>  			pthread_cond_signal(&wq->wakeup);
>  		}
> +		wq->active_threads++;
>  		pthread_mutex_unlock(&wq->lock);
> 
>  		(wi->function)(wi->queue, wi->index, wi->arg);
>  		free(wi);
> +
> +		pthread_mutex_lock(&wq->lock);
> +		wq->active_threads--;
>  	}
> +	pthread_mutex_unlock(&wq->lock);
>  	rcu_unregister_thread();
> 
>  	return NULL;
> @@ -170,12 +173,6 @@ workqueue_add(
>  restart:
>  	if (wq->next_item == NULL) {
>  		assert(wq->item_count == 0);
> -		ret = -pthread_cond_signal(&wq->wakeup);
> -		if (ret) {
> -			pthread_mutex_unlock(&wq->lock);
> -			free(wi);
> -			return ret;
> -		}
>  		wq->next_item = wi;
>  	} else {
>  		/* throttle on a full queue if configured */
> @@ -192,6 +189,23 @@ workqueue_add(
>  	}
>  	wq->last_item = wi;
>  	wq->item_count++;
> +
> +	if (wq->active_threads == wq->thread_count - 1) {
> +		/* One thread is idle, wake it */
> +		ret = -pthread_cond_signal(&wq->wakeup);
> +		if (ret) {
> +			pthread_mutex_unlock(&wq->lock);
> +			return ret;
> +		}
> +	} else if (wq->active_threads < wq->thread_count) {
> +		/* Multiple threads are idle, wake everyone */
> +		ret = -pthread_cond_broadcast(&wq->wakeup);
> +		if (ret) {
> +			pthread_mutex_unlock(&wq->lock);
> +			return ret;
> +		}
> +	}
> +
>  	pthread_mutex_unlock(&wq->lock);
> 
>  	return 0;
> diff --git a/libfrog/workqueue.h b/libfrog/workqueue.h
> index a9c108d0e66..edbe12fabab 100644
> --- a/libfrog/workqueue.h
> +++ b/libfrog/workqueue.h
> @@ -29,6 +29,7 @@ struct workqueue {
>  	pthread_cond_t		wakeup;
>  	unsigned int		item_count;
>  	unsigned int		thread_count;
> +	unsigned int		active_threads;
>  	bool			terminate;
>  	bool			terminated;
>  	int			max_queued;
> 
