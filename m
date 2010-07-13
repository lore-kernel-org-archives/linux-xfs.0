Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6DCqJkL090759 for <xfs@oss.sgi.com>; Tue, 13 Jul 2010 07:52:19 -0500
Received: from kernel.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A0FD1E27771
	for <xfs@oss.sgi.com>; Tue, 13 Jul 2010 05:55:13 -0700 (PDT)
Received: from kernel.dk (0122700014.0.fullrate.dk [95.166.99.235]) by
	cuda.sgi.com with ESMTP id 8FyonjAcWe6zeB9A for
	<xfs@oss.sgi.com>; Tue, 13 Jul 2010 05:55:13 -0700 (PDT)
Message-ID: <4C3C6232.5090509@kernel.dk>
Date: Tue, 13 Jul 2010 14:55:14 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] blkdev: check for valid request queue before issuing
	flush
References: <1279007450-10457-1-git-send-email-david@fromorbit.com>
	<1279007450-10457-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1279007450-10457-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 2010-07-13 09:50, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Issuing a blkdev_issue_flush() on an unconfigured loop device causes a panic as
> q->make_request_fn is not configured. This can occur when trying to mount the
> unconfigured loop device as an XFS filesystem. There are no guards that catch
> the bio before the request function is called because we don't add a payload to
> the bio. Instead, manually check this case as soon as we have a pointer to the
> queue to flush.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  block/blk-barrier.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-barrier.c b/block/blk-barrier.c
> index 0d710c9..0fd766e 100644
> --- a/block/blk-barrier.c
> +++ b/block/blk-barrier.c
> @@ -319,6 +319,15 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
>  	if (!q)
>  		return -ENXIO;
>  
> +	/*
> +	 * some block devices may not have their queue correctly set up here
> +	 * (e.g. loop device without a backing file) and so issuing a flush
> +	 * here will panic. Ensure there is a request function before issuing
> +	 * the barrier.
> +	 */
> +	if (!q->make_request_fn)
> +		return -ENXIO;
> +
>  	bio = bio_alloc(gfp_mask, 0);
>  	bio->bi_end_io = bio_end_empty_barrier;
>  	bio->bi_bdev = bdev;

This may appear ugly, but I think the patch is fine since there's not
much we can do about the loop crap (outside of changing how you do
setup/configure of it).

I'll apply this, thanks.

-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
