Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q632nRBh044589 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 21:49:27 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1aQktOuBruz69ij8 for
	<xfs@oss.sgi.com>; Mon, 02 Jul 2012 19:49:26 -0700 (PDT)
Date: Mon, 2 Jul 2012 22:49:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 2/3] block: reorganize rounding of
	max_discard_sectors
Message-ID: <20120703024910.GC3586@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
	<1341235225-27551-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1341235225-27551-3-git-send-email-pbonzini@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, snitzer@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de

On Mon, Jul 02, 2012 at 03:20:24PM +0200, Paolo Bonzini wrote:
> Mostly a preparation for the next patch.
> 
> In principle this fixes an infinite loop if max_discard_sectors < granularity,
> but that really shouldn't happen.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  block/blk-lib.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 2b461b4..16b06f6 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -44,6 +44,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  	struct request_queue *q = bdev_get_queue(bdev);
>  	int type = REQ_WRITE | REQ_DISCARD;
>  	unsigned int max_discard_sectors;
> +	unsigned int granularity;
>  	struct bio_batch bb;
>  	struct bio *bio;
>  	int ret = 0;
> @@ -54,18 +55,18 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  	if (!blk_queue_discard(q))
>  		return -EOPNOTSUPP;
>  
> +	/* Zero-sector (unknown) and one-sector granularities are the same.  */
> +	granularity = max(q->limits.discard_granularity >> 9, 1U);
> +
>  	/*
>  	 * Ensure that max_discard_sectors is of the proper
>  	 * granularity
>  	 */
>  	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
> +	max_discard_sectors = round_down(max_discard_sectors, granularity);
>  	if (unlikely(!max_discard_sectors)) {
>  		/* Avoid infinite loop below. Being cautious never hurts. */
>  		return -EOPNOTSUPP;
> -	} else if (q->limits.discard_granularity) {
> -		unsigned int disc_sects = q->limits.discard_granularity >> 9;
> -
> -		max_discard_sectors &= ~(disc_sects - 1);

This is kind of odd. If discard_granularity is zero, we assume that
discards are supported and granularity is 1. But if max_discard_sectors
is zero, we assume discards are disabled. Not sure if we should treat
max_discard_sectors and discard_granularity in same way or not.

Thanks
Vivek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
