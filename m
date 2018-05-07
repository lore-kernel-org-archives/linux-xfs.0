Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59659 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbeEGJyd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 May 2018 05:54:33 -0400
Date: Mon, 7 May 2018 11:57:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] blk-wbt: throttle discards like background writes
Message-ID: <20180507095746.GC25210@lst.de>
References: <1525360843-6504-1-git-send-email-axboe@kernel.dk> <1525360843-6504-4-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525360843-6504-4-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, dchinner@redhat.com, hch@lst.de

> -static inline struct rq_wait *get_rq_wait(struct rq_wb *rwb, bool is_kswapd)
> +static inline struct rq_wait *get_rq_wait(struct rq_wb *rwb, bool is_trim,
> +					  bool is_kswapd)
>  {
> -	return &rwb->rq_wait[is_kswapd];
> +	if (is_trim)
> +		return &rwb->rq_wait[WBT_REQ_DISCARD];
> +	else if (is_kswapd)
> +		return &rwb->rq_wait[WBT_REQ_KSWAPD];
> +	else
> +		return &rwb->rq_wait[WBT_REQ_BG];
>  }

Wouldn't it be more useful to pass a enum wbt_flag here?

Or just have a wbt_flag_to_wait_idx helper and do the array indexing
in the callers?

>  {
>  	const int op = bio_op(bio);
>  
> -	/*
> -	 * If not a WRITE, do nothing
> -	 */
> -	if (op != REQ_OP_WRITE)
> -		return false;
> +	if (op == REQ_OP_WRITE) {
> +		/*
> +		 * Don't throttle WRITE_ODIRECT
> +		 */
> +		if ((bio->bi_opf & (REQ_SYNC | REQ_IDLE)) ==
> +		    (REQ_SYNC | REQ_IDLE))
> +			return false;
>  
> -	/*
> -	 * Don't throttle WRITE_ODIRECT
> -	 */
> -	if ((bio->bi_opf & (REQ_SYNC | REQ_IDLE)) == (REQ_SYNC | REQ_IDLE))
> -		return false;
> +		return true;
> +	} else if (op == REQ_OP_DISCARD)
> +		return true;

what about:

	switch (bio_op(bio)) {
	case REQ_OP_WRITE:
		/*
		 * Don't throttle WRITE_ODIRECT
		 */
		if ((bio->bi_opf & (REQ_SYNC | REQ_IDLE)) ==
		    (REQ_SYNC | REQ_IDLE))
			return false;
		/*FALLTHROUGH*/
	case REQ_OP_DISCARD:
		return true;
	default:
		return false;
