Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45472 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdITVlV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 17:41:21 -0400
Date: Wed, 20 Sep 2017 14:41:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/19] xfs: use the state defines in
 xfs_bmap_del_extent_real
Message-ID: <20170920214117.GO7112@magnolia>
References: <20170918152422.24345-1-hch@lst.de>
 <20170918152422.24345-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918152422.24345-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2017 at 08:24:11AM -0700, Christoph Hellwig wrote:
> Use the same defines as the other extent add and delete helpers, which
> both improves code readability and trace point output.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index aa4af31750d3..037efc97499f 100644
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
> +		state |= BMAP_LEFT_FILLING;
> +	if (got_endoff == del_endoff)
> +		state |= BMAP_RIGHT_FILLING;
> +
> +	switch (state & (BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING)) {
> +	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
>  		/*
>  		 * Matches the whole extent.  Delete the entry.
>  		 */
> @@ -5188,8 +5188,7 @@ xfs_bmap_del_extent_real(
>  			goto done;
>  		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  		break;
> -
> -	case 2:
> +	case BMAP_LEFT_FILLING:
>  		/*
>  		 * Deleting the first part of the extent.
>  		 */
> @@ -5208,8 +5207,7 @@ xfs_bmap_del_extent_real(
>  				got.br_state)))
>  			goto done;
>  		break;
> -
> -	case 1:
> +	case BMAP_RIGHT_FILLING:
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
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
