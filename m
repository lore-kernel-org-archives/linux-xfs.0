Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57838 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbeKNMiM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Nov 2018 07:38:12 -0500
Date: Tue, 13 Nov 2018 18:36:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] block: fix 32 bit overflow in __blkdev_issue_discard()
Message-ID: <20181114023654.GJ4235@magnolia>
References: <20181113214337.20581-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113214337.20581-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Wed, Nov 14, 2018 at 08:43:37AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A discard cleanup merged into 4.20-rc2 causes fstests xfs/259 to
> fall into an endless loop in the discard code. The test is creating
> a device that is exactly 2^32 sectors in size to test mkfs boundary
> conditions around the 32 bit sector overflow region.
> 
> mkfs issues a discard for the entire device size by default, and
> hence this throws a sector count of 2^32 into
> blkdev_issue_discard(). It takes the number of sectors to discard as
> a sector_t - a 64 bit value.
> 
> The commit ba5d73851e71 ("block: cleanup __blkdev_issue_discard")
> takes this sector count and casts it to a 32 bit value before
> comapring it against the maximum allowed discard size the device
> has. This truncates away the upper 32 bits, and so if the lower 32
> bits of the sector count is zero, it starts issuing discards of
> length 0. This causes the code to fall into an endless loop, issuing
> a zero length discards over and over again on the same sector.
> 
> Fixes: ba5d73851e71 ("block: cleanup __blkdev_issue_discard")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Fixes the regression for me too, so...

Tested-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  block/blk-lib.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index e8b3bb9bf375..144e156ed341 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -55,9 +55,12 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  		return -EINVAL;
>  
>  	while (nr_sects) {
> -		unsigned int req_sects = min_t(unsigned int, nr_sects,
> +		sector_t req_sects = min_t(sector_t, nr_sects,
>  				bio_allowed_max_sectors(q));
>  
> +		WARN_ON_ONCE(req_sects == 0);
> +		WARN_ON_ONCE((req_sects << 9) > UINT_MAX);
> +
>  		bio = blk_next_bio(bio, 0, gfp_mask);
>  		bio->bi_iter.bi_sector = sector;
>  		bio_set_dev(bio, bdev);
> -- 
> 2.19.1
> 
