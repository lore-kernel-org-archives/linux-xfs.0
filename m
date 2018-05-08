Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53488 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752954AbeEHAHy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 20:07:54 -0400
Date: Mon, 7 May 2018 17:07:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] blk-wbt: pass in enum wbt_flags to get_rq_wait()
Message-ID: <20180508000731.GA11261@magnolia>
References: <1525709615-14395-1-git-send-email-axboe@kernel.dk>
 <1525709615-14395-4-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525709615-14395-4-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, dchinner@redhat.com, hch@lst.de

On Mon, May 07, 2018 at 10:13:34AM -0600, Jens Axboe wrote:
> This is in preparation for having more write queues, in which
> case we would have needed to pass in more information than just
> a simple 'is_kswapd' boolean.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Looks ok (having not run any kind of testing on this yet),
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  block/blk-wbt.c | 25 +++++++++++++++----------
>  block/blk-wbt.h |  4 +++-
>  2 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/block/blk-wbt.c b/block/blk-wbt.c
> index 3e34b41bcefc..25d202345965 100644
> --- a/block/blk-wbt.c
> +++ b/block/blk-wbt.c
> @@ -101,9 +101,13 @@ static bool wb_recent_wait(struct rq_wb *rwb)
>  	return time_before(jiffies, wb->dirty_sleep + HZ);
>  }
>  
> -static inline struct rq_wait *get_rq_wait(struct rq_wb *rwb, bool is_kswapd)
> +static inline struct rq_wait *get_rq_wait(struct rq_wb *rwb,
> +					  enum wbt_flags wb_acct)
>  {
> -	return &rwb->rq_wait[is_kswapd];
> +	if (wb_acct & WBT_KSWAPD)
> +		return &rwb->rq_wait[WBT_RWQ_KSWAPD];
> +
> +	return &rwb->rq_wait[WBT_RWQ_BG];
>  }
>  
>  static void rwb_wake_all(struct rq_wb *rwb)
> @@ -126,7 +130,7 @@ void __wbt_done(struct rq_wb *rwb, enum wbt_flags wb_acct)
>  	if (!(wb_acct & WBT_TRACKED))
>  		return;
>  
> -	rqw = get_rq_wait(rwb, wb_acct & WBT_KSWAPD);
> +	rqw = get_rq_wait(rwb, wb_acct);
>  	inflight = atomic_dec_return(&rqw->inflight);
>  
>  	/*
> @@ -529,11 +533,12 @@ static inline bool may_queue(struct rq_wb *rwb, struct rq_wait *rqw,
>   * Block if we will exceed our limit, or if we are currently waiting for
>   * the timer to kick off queuing again.
>   */
> -static void __wbt_wait(struct rq_wb *rwb, unsigned long rw, spinlock_t *lock)
> +static void __wbt_wait(struct rq_wb *rwb, enum wbt_flags wb_acct,
> +		       unsigned long rw, spinlock_t *lock)
>  	__releases(lock)
>  	__acquires(lock)
>  {
> -	struct rq_wait *rqw = get_rq_wait(rwb, current_is_kswapd());
> +	struct rq_wait *rqw = get_rq_wait(rwb, wb_acct);
>  	DEFINE_WAIT(wait);
>  
>  	if (may_queue(rwb, rqw, &wait, rw))
> @@ -584,7 +589,7 @@ static inline bool wbt_should_throttle(struct rq_wb *rwb, struct bio *bio)
>   */
>  enum wbt_flags wbt_wait(struct rq_wb *rwb, struct bio *bio, spinlock_t *lock)
>  {
> -	unsigned int ret = 0;
> +	enum wbt_flags ret = 0;
>  
>  	if (!rwb_enabled(rwb))
>  		return 0;
> @@ -598,14 +603,14 @@ enum wbt_flags wbt_wait(struct rq_wb *rwb, struct bio *bio, spinlock_t *lock)
>  		return ret;
>  	}
>  
> -	__wbt_wait(rwb, bio->bi_opf, lock);
> +	if (current_is_kswapd())
> +		ret |= WBT_KSWAPD;
> +
> +	__wbt_wait(rwb, ret, bio->bi_opf, lock);
>  
>  	if (!blk_stat_is_active(rwb->cb))
>  		rwb_arm_timer(rwb);
>  
> -	if (current_is_kswapd())
> -		ret |= WBT_KSWAPD;
> -
>  	return ret | WBT_TRACKED;
>  }
>  
> diff --git a/block/blk-wbt.h b/block/blk-wbt.h
> index a232c98fbf4d..8038b4a0d4ef 100644
> --- a/block/blk-wbt.h
> +++ b/block/blk-wbt.h
> @@ -19,7 +19,9 @@ enum wbt_flags {
>  };
>  
>  enum {
> -	WBT_NUM_RWQ		= 2,
> +	WBT_RWQ_BG		= 0,
> +	WBT_RWQ_KSWAPD,
> +	WBT_NUM_RWQ,
>  };
>  
>  /*
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
