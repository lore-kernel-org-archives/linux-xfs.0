Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:47853 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752614AbeD3XXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 19:23:22 -0400
Date: Tue, 1 May 2018 09:23:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
Message-ID: <20180430232319.GV23861@dastard>
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
 <20180430213120.GD13766@dastard>
 <c6e9db38-51d3-ae13-58cb-2b815ddd5891@kernel.dk>
 <20180430222852.GF13766@dastard>
 <87589bc6-e5f5-6247-485f-2237e0c493ad@kernel.dk>
 <799de885-34f0-0cae-ae64-bf7bc194965d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <799de885-34f0-0cae-ae64-bf7bc194965d@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On Mon, Apr 30, 2018 at 05:00:14PM -0600, Jens Axboe wrote:
> On 4/30/18 4:40 PM, Jens Axboe wrote:
> > On 4/30/18 4:28 PM, Dave Chinner wrote:
> >> Yes, it does, but so would having the block layer to throttle device
> >> discard requests in flight to a queue depth of 1. And then we don't
> >> have to change XFS at all.
> > 
> > I'm perfectly fine with making that change by default, and much easier
> > for me since I don't have to patch file systems.
> 
> Totally untested, but this should do the trick. It ensures we have
> a QD of 1 (per caller), which should be sufficient.
> 
> If people tune down the discard size, then you'll be blocking waiting
> for discards on issue.
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index a676084d4740..0bf9befcc863 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -11,16 +11,19 @@
>  #include "blk.h"
>  
>  static struct bio *next_bio(struct bio *bio, unsigned int nr_pages,
> -		gfp_t gfp)
> +			    gfp_t gfp)
>  {
> -	struct bio *new = bio_alloc(gfp, nr_pages);
> -
> +	/*
> +	 * Devices suck at discard, so if we have to break up the bio
> +	 * size due to the max discard size setting, wait for the
> +	 * previous one to finish first.
> +	 */
>  	if (bio) {
> -		bio_chain(bio, new);
> -		submit_bio(bio);
> +		submit_bio_wait(bio);
> +		bio_put(bio);
>  	}

This only addresses the case where __blkdev_issue_discard() breaks
up a single large discard, right? It seems like a brute force
solution, too, because it will do so even when the underlying device
is idle and there's no need to throttle.

Shouldn't the throttling logic at least look at device congestion?
i.e. if the device is not backlogged, then we should be able to
issue the discard without problems. 

I ask this because this only addresses throttling the "discard large
extent" case when the discard limit is set low. i.e. your exact
problem case. We know that XFS can issue large numbers of
discontiguous async discards in a single batch - this patch does not
address that case and so it will still cause starvation problems.

If we look at device congestion in determining how to throttle/back
off during discard issuing, then it doesn't matter what
max_discard_sectors is set to - it will throttle in all situations
that cause device overloads and starvations....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
