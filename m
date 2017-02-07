Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22708 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751414AbdBGBWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2017 20:22:07 -0500
Date: Mon, 6 Feb 2017 17:21:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: split indlen reservations fairly when under
 reserved
Message-ID: <20170207012159.GC12378@birch.djwong.org>
References: <1486146865-47286-1-git-send-email-bfoster@redhat.com>
 <1486146865-47286-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486146865-47286-3-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Patrick Dung <mpatdung@gmail.com>

On Fri, Feb 03, 2017 at 01:34:25PM -0500, Brian Foster wrote:
> Certain workoads that punch holes into speculative preallocation can
> cause delalloc indirect reservation splits when the delalloc extent is
> split in two. If further splits occur, an already short-handed extent
> can be split into two in a manner that leaves zero indirect blocks for
> one of the two new extents. This occurs because the shortage is large
> enough that the xfs_bmap_split_indlen() algorithm completely drains the
> requested indlen of one of the extents before it honors the existing
> reservation.
> 
> This ultimately results in a warning from xfs_bmap_del_extent(). This
> has been observed during file copies of large, sparse files using 'cp
> --sparse=always.'
> 
> To avoid this problem, update xfs_bmap_split_indlen() to explicitly
> apply the reservation shortage fairly between both extents. This smooths
> out the overall indlen shortage and defers the situation where we end up
> with a delalloc extent with zero indlen reservation to extreme
> circumstances.
> 
> Reported-by: Patrick Dung <mpatdung@gmail.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 58 +++++++++++++++++++++++++++++++++---------------
>  1 file changed, 40 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d2e48ed..4ca4606 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4790,34 +4790,56 @@ xfs_bmap_split_indlen(
>  	xfs_filblks_t			len2 = *indlen2;
>  	xfs_filblks_t			nres = len1 + len2; /* new total res. */
>  	xfs_filblks_t			stolen = 0;
> +	xfs_filblks_t			resfactor;
>  
>  	/*
>  	 * Steal as many blocks as we can to try and satisfy the worst case
>  	 * indlen for both new extents.
>  	 */
> -	while (nres > ores && avail) {
> -		nres--;
> -		avail--;
> -		stolen++;
> -	}
> +	if (ores < nres && avail)
> +		stolen = XFS_FILBLKS_MIN(nres - ores, avail);
> +	ores += stolen;
> +
> +	 /* nothing else to do if we've satisfied the new reservation */
> +	if (ores >= nres)
> +		return stolen;
> +
> +	/*
> +	 * We can't meet the total required reservation for the two extents.
> +	 * Calculate the percent of the overall shortage between both extents
> +	 * and apply this percentage to each of the requested indlen values.
> +	 * This distributes the shortage fairly and reduces the chances that one
> +	 * of the two extents is left with nothing when extents are repeatedly
> +	 * split.
> +	 */
> +	resfactor = (ores * 100) / nres;
> +	len1 = resfactor * len1 / 100;
> +	len2 = resfactor * len2 / 100;
> +	ASSERT(len1 + len2 <= ores);
> +	ASSERT(len1 < *indlen1 && len2 < *indlen2);
>  
>  	/*
> -	 * The only blocks available are those reserved for the original
> -	 * extent and what we can steal from the extent being removed.
> -	 * If this still isn't enough to satisfy the combined
> -	 * requirements for the two new extents, skim blocks off of each
> -	 * of the new reservations until they match what is available.
> +	 * Hand out the remainder to each extent. If one of the two reservations
> +	 * is zero, we want to make sure that one gets a block first. The loop
> +	 * below starts with len1, so hand len2 a block right off the bat if it
> +	 * is zero.
>  	 */
> -	while (nres > ores) {
> -		if (len1) {
> -			len1--;
> -			nres--;
> +	ores -= (len1 + len2);
> +	ASSERT((*indlen1 - len1) + (*indlen2 - len2) >= ores);
> +	if (ores && !len2 && *indlen2) {
> +		len2++;
> +		ores--;
> +	}
> +	while (ores) {
> +		if (len1 < *indlen1) {
> +			len1++;
> +			ores--;
>  		}
> -		if (nres == ores)
> +		if (!ores)
>  			break;
> -		if (len2) {
> -			len2--;
> -			nres--;
> +		if (len2 < *indlen2) {
> +			len2++;
> +			ores--;
>  		}
>  	}
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
