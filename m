Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754931AbdIGPrK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Sep 2017 11:47:10 -0400
Date: Thu, 7 Sep 2017 11:47:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/17] xfs: use the proper state defines in
 xfs_bmap_del_extent_real
Message-ID: <20170907154708.GG61662@bfoster.bfoster>
References: <20170903072956.3175-1-hch@lst.de>
 <20170903072956.3175-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903072956.3175-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 09:29:46AM +0200, Christoph Hellwig wrote:
> Use the same defines as the other extent add and delete helpers, which
> both improves code readability and trace point output.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index add690cb19a3..0a4bcef1cca8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5162,13 +5162,13 @@ xfs_bmap_del_extent_real(
>  		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  	}
>  
> -	/*
> -	 * Set flag value to use in switch statement.
> -	 * Left-contig is 2, right-contig is 1.
> -	 */
> -	switch (((got.br_startoff == del->br_startoff) << 1) |
> -		(got_endoff == del_endoff)) {
> -	case 3:
> +	if (got.br_startoff == del->br_startoff)
> +		state |= BMAP_LEFT_CONTIG;
> +	if (got_endoff == del_endoff)
> +		state |= BMAP_RIGHT_CONTIG;
> +
> +	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
> +	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:

The code looks correct because the states ultimately map to the correct
logic, but I think this is actually a misuse of the bmap states. The
contig states are used to define left and right extent contiguity. Here
(and in del_extent_[delay|cow]()) we use them to track extent
replacement alignment, which should be represented by the left and right
filling states (as is done for delalloc/unwritten conversion helpers).
Perhaps we should fix that all up?

Brian

>  		/*
>  		 * Matches the whole extent.  Delete the entry.
>  		 */
> @@ -5188,8 +5188,7 @@ xfs_bmap_del_extent_real(
>  			goto done;
>  		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  		break;
> -
> -	case 2:
> +	case BMAP_LEFT_CONTIG:
>  		/*
>  		 * Deleting the first part of the extent.
>  		 */
> @@ -5208,8 +5207,7 @@ xfs_bmap_del_extent_real(
>  				got.br_state)))
>  			goto done;
>  		break;
> -
> -	case 1:
> +	case BMAP_RIGHT_CONTIG:
>  		/*
>  		 * Deleting the last part of the extent.
>  		 */
> @@ -5227,7 +5225,6 @@ xfs_bmap_del_extent_real(
>  				got.br_state)))
>  			goto done;
>  		break;
> -
>  	case 0:
>  		/*
>  		 * Deleting the middle of the extent.
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
