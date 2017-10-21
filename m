Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39502 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752915AbdJUA0l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 20:26:41 -0400
Date: Fri, 20 Oct 2017 17:26:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/15] xfs: don't rely on extent indices in
 xfs_bmap_collapse_extents
Message-ID: <20171021002637.GG4755@magnolia>
References: <20171019065942.18813-1-hch@lst.de>
 <20171019065942.18813-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019065942.18813-14-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2017 at 08:59:40AM +0200, Christoph Hellwig wrote:
> Rewrite xfs_bmap_collapse_extents so that we don't rely on extent indices
> except for iterating over them.  Not being able to iterate to the next
> extent is a sufficient exit condition, and we don't need to do any extent
> count games given that:
> 
>   a) we already flushed all delalloc extents past our start offset
>      before doing the operation
>   b) xfs_iext_count() includes delalloc extents anyway
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 54 +++++++++++-------------------------------------
>  1 file changed, 12 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 2de9458903b6..4c89fdacda90 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5626,8 +5626,6 @@ xfs_bmap_collapse_extents(
>  	struct xfs_btree_cur	*cur = NULL;
>  	struct xfs_bmbt_irec	got, prev;
>  	xfs_extnum_t		current_ext;
> -	xfs_extnum_t		total_extents;
> -	xfs_extnum_t		stop_extent;
>  	xfs_fileoff_t		new_startoff;
>  	int			error = 0;
>  	int			logflags = 0;
> @@ -5658,52 +5656,31 @@ xfs_bmap_collapse_extents(
>  		cur->bc_private.b.flags = 0;
>  	}
>  
> -	/*
> -	 * There may be delalloc extents in the data fork before the range we
> -	 * are collapsing out, so we cannot use the count of real extents here.
> -	 * Instead we have to calculate it from the incore fork.
> -	 */
> -	total_extents = xfs_iext_count(ifp);
> -	if (total_extents == 0) {
> -		*done = true;
> -		goto del_cursor;
> -	}
> -
> -	/*
> -	 * Look up the extent index for the fsb where we start shifting. We can
> -	 * henceforth iterate with current_ext as extent list changes are locked
> -	 * out via ilock.
> -	 *
> -	 * If next_fsb lies in a hole beyond which there are no extents we are
> -	 * done.
> -	 */
>  	if (!xfs_iext_lookup_extent(ip, ifp, *next_fsb, &current_ext, &got)) {
>  		*done = true;
>  		goto del_cursor;
>  	}
>  	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got.br_startblock));
>  
> -	stop_extent = total_extents;
> -	if (current_ext >= stop_extent) {
> -		error = -EIO;
> -		goto del_cursor;
> -	}
> -
>  	new_startoff = got.br_startoff - offset_shift_fsb;
> -	if (current_ext) {
> -		xfs_iext_get_extent(ifp, current_ext - 1, &prev);
> +	if (xfs_iext_get_extent(ifp, current_ext - 1, &prev)) {
>  		if (new_startoff < prev.br_startoff + prev.br_blockcount) {
>  			error = -EINVAL;
>  			goto del_cursor;
>  		}
>  
> -		/* check whether to merge the extent or shift it down */
>  		if (xfs_bmse_can_merge(&prev, &got, offset_shift_fsb)) {
>  			error = xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
>  					current_ext, &got, &prev, cur,
>  					&logflags, dfops);
>  			if (error)
>  				goto del_cursor;
> +
> +			/* update got after merge */
> +			if (!xfs_iext_get_extent(ifp, current_ext, &got)) {
> +				*done = true;
> +				goto del_cursor;
> +			}
>  			goto done;
>  		}
>  	} else {
> @@ -5717,20 +5694,13 @@ xfs_bmap_collapse_extents(
>  			cur, &logflags, dfops, new_startoff);
>  	if (error)
>  		goto del_cursor;
> -	current_ext++;
> -done:
> -	/*
> -	 * If there was an extent merge during the shift, the extent
> -	 * count can change. Update the total and grade the next record.
> -	 */
> -	total_extents = xfs_iext_count(ifp);
> -	stop_extent = total_extents;
> -	if (current_ext == stop_extent) {
> -		*done = true;
> -		goto del_cursor;
> +
> +	if (!xfs_iext_get_extent(ifp, ++current_ext, &got)) {
> +		 *done = true;
> +		 goto del_cursor;
>  	}
> -	xfs_iext_get_extent(ifp, current_ext, &got);
>  
> +done:
>  	*next_fsb = got.br_startoff;
>  del_cursor:
>  	if (cur)
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
