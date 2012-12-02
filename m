Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB2NhfAS024748 for <xfs@oss.sgi.com>; Sun, 2 Dec 2012 17:43:41 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	NLO4anmYJRSUPc7r for <xfs@oss.sgi.com>;
	Sun, 02 Dec 2012 15:46:01 -0800 (PST)
Date: Mon, 3 Dec 2012 10:46:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/3] xfs: fix the buffer log format for contiguous
	buffers
Message-ID: <20121202234600.GD29399@dastard>
References: <20121128222309.109033307@.sgi.com>
	<20121128222622.792433915@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121128222622.792433915@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 28, 2012 at 04:23:11PM -0600, Mark Tinguely wrote:
> Not every segment in a multi-segment buffer is dirty in a
> transaction and they will not be outputted. The assert in
> xfs_buf_item_format_segment() that checks for the at least
> one chunk of data in the segment to be used is not necessary
> true for multi-segmented buffers.
> 
> This patch:

Has three separate, unrelated changes. That usually means 3
separate patches....

>  1) Change xfs_buf_item_format_segment() to skip over non-dirty
>     segments.

Comments about this below.

>  2) Change the bli_format structure to __bli_format so it is not
>     accidently confused with the bli_formats pointer.

This change looks ok.

>  3) Remove the buffer XFS_TRANS_DEBUG routines xfs_buf_item_log_debug()
>     and xfs_buf_item_log_check(). They are not used and are not
>     multi-segment aware.

Removing XFS_TRANS_DEBUG should definitely be done as a separate
patch and it should remove it from everywhere (there's several stale
uses) rather than just this one place. If we don't use it here, we
don't use it anywhere....

....

> @@ -287,11 +184,6 @@ xfs_buf_item_format_segment(
>  	 */
>  	base_size = offsetof(struct xfs_buf_log_format, blf_data_map) +
>  			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
> -	vecp->i_addr = blfp;
> -	vecp->i_len = base_size;
> -	vecp->i_type = XLOG_REG_TYPE_BFORMAT;
> -	vecp++;
> -	nvecs = 1;
>  
>  	if (bip->bli_flags & XFS_BLI_STALE) {
>  		/*
> @@ -301,7 +193,11 @@ xfs_buf_item_format_segment(
>  		 */
>  		trace_xfs_buf_item_format_stale(bip);
>  		ASSERT(blfp->blf_flags & XFS_BLF_CANCEL);
> -		blfp->blf_size = nvecs;
> +		vecp->i_addr = blfp;
> +		vecp->i_len = base_size;
> +		vecp->i_type = XLOG_REG_TYPE_BFORMAT;
> +		vecp++;
> +		blfp->blf_size = 1;
>  		return vecp;
>  	}
>  
> @@ -309,7 +205,19 @@ xfs_buf_item_format_segment(
>  	 * Fill in an iovec for each set of contiguous chunks.
>  	 */
>  	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
> -	ASSERT(first_bit != -1);
> +	if (first_bit == -1) {
> +		/* If the map is not be dirty in the transaction, mark
> +		 * the size as zero and do not advance the vector pointer.
> +		 */

Comment format.

> +		blfp->blf_size = 0;
> +		return(vecp);

		return vecp;
> +	}
> +
> +	vecp->i_addr = blfp;
> +	vecp->i_len = base_size;
> +	vecp->i_type = XLOG_REG_TYPE_BFORMAT;
> +	vecp++;
> +	nvecs = 1;

This results in duplicating the code. Perhaps it woul dbe better to
rearrange the code slightly to avoid needing to do that. i.e:

{
	nvecs = 0;
	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);

	if (!(bip->bli_flags & XFS_BLI_STALE) && first_bit == -1) {
		/*
		 * If the map is not be dirty in the transaction, mark
		 * the size as zero and do not advance the vector pointer.
		 */
		goto out;
	}

	vecp->i_addr = blfp;
	vecp->i_len = base_size;
	vecp->i_type = XLOG_REG_TYPE_BFORMAT;
	vecp++;
	nvecs = 1;

	if (bip->bli_flags & XFS_BLI_STALE) {
		.....
		goto out;
	}
	.....

out:
	blfp->blf_size = nvecs;
	return vecp;
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
