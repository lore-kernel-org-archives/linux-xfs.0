Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58741 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760031AbdDSGpG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 02:45:06 -0400
Date: Tue, 18 Apr 2017 23:45:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
Message-ID: <20170419064505.GD20053@infradead.org>
References: <20170414120257.8932-1-rgoldwyn@suse.de>
 <20170414120257.8932-6-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170414120257.8932-6-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Fri, Apr 14, 2017 at 07:02:54AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> A new bio operation flag REQ_NOWAIT is introduced to identify bio's

s/bio/block/

> @@ -1232,6 +1232,11 @@ static struct request *get_request(struct request_queue *q, unsigned int op,
>  	if (!IS_ERR(rq))
>  		return rq;
>  
> +	if (bio && (bio->bi_opf & REQ_NOWAIT)) {
> +		blk_put_rl(rl);
> +		return ERR_PTR(-EAGAIN);
> +	}

Please check the op argument instead of touching bio.

> +	if (bio->bi_opf & REQ_NOWAIT) {
> +		if (!blk_queue_nowait(q)) {
> +			err = -EOPNOTSUPP;
> +			goto end_io;
> +		}
> +		if (!(bio->bi_opf & REQ_SYNC)) {

I don't understand this check at all..

> +			if (unlikely(!blk_queue_dying(q) && (bio->bi_opf & REQ_NOWAIT)))

Please break lines after 80 characters.

> @@ -119,6 +119,9 @@ struct request *blk_mq_sched_get_request(struct request_queue *q,
>  	if (likely(!data->hctx))
>  		data->hctx = blk_mq_map_queue(q, data->ctx->cpu);
>  
> +	if (bio && (bio->bi_opf & REQ_NOWAIT))
> +		data->flags |= BLK_MQ_REQ_NOWAIT;

Check the op flag again here.

> +++ b/block/blk-mq.c
> @@ -1538,6 +1538,8 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
>  	rq = blk_mq_sched_get_request(q, bio, bio->bi_opf, &data);
>  	if (unlikely(!rq)) {
>  		__wbt_done(q->rq_wb, wb_acct);
> +		if (bio && (bio->bi_opf & REQ_NOWAIT))
> +			bio_wouldblock_error(bio);

bio iѕ dereferences unconditionally above, so you can do the same.

> @@ -1662,6 +1664,8 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
>  	rq = blk_mq_sched_get_request(q, bio, bio->bi_opf, &data);
>  	if (unlikely(!rq)) {
>  		__wbt_done(q->rq_wb, wb_acct);
> +		if (bio && (bio->bi_opf & REQ_NOWAIT))
> +			bio_wouldblock_error(bio);

Same here.  Although blk_sq_make_request is gone anyway in the current
block tree..

> +	/* Request queue supports BIO_NOWAIT */
> +	queue_flag_set_unlocked(QUEUE_FLAG_NOWAIT, q);

BIO_NOWAIT is gone.  And the comment would not be needed if the
flag had a more descriptive name, e.g. QUEUE_FLAG_NOWAIT_SUPPORT.

And I think all request based drivers should set the flag implicitly
as ->queuecommand can't sleep, and ->queue_rq only when it's always
offloaded to a workqueue when the BLK_MQ_F_BLOCKING flag is set.

> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -480,8 +480,12 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
>  	unsigned i;
>  	int err;
>  
> -	if (bio->bi_error)
> -		dio->io_error = -EIO;
> +	if (bio->bi_error) {
> +		if (bio->bi_opf & REQ_NOWAIT)
> +			dio->io_error = -EAGAIN;
> +		else
> +			dio->io_error = -EIO;
> +	}

Huh?  Once REQ_NOWAIT is set all errors are -EAGAIN?
