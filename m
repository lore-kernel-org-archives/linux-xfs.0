Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23862 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753612AbdJaVh0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 17:37:26 -0400
Date: Tue, 31 Oct 2017 14:37:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/18] xfs: treat idx as a cursor in
 xfs_bmap_collapse_extents
Message-ID: <20171031213722.GQ4911@magnolia>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031142230.11755-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 04:22:20PM +0200, Christoph Hellwig wrote:
> Stop poking before and after the index and just increment or decrement
> it while doing our operations on it to prepare for a new extent list
> implementation.
> 

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 5ba0c0368629..14428d72cf33 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5516,7 +5516,7 @@ xfs_bmse_merge(
>  	struct xfs_inode		*ip,
>  	int				whichfork,
>  	xfs_fileoff_t			shift,		/* shift fsb */
> -	int				current_ext,	/* idx of gotp */
> +	int				*current_ext,	/* idx of gotp */
>  	struct xfs_bmbt_irec		*got,		/* extent to shift */
>  	struct xfs_bmbt_irec		*left,		/* preceding extent */
>  	struct xfs_btree_cur		*cur,
> @@ -5571,9 +5571,10 @@ xfs_bmse_merge(
>  		return error;
>  
>  done:
> +	xfs_iext_remove(ip, *current_ext, 1, 0);
> +	--*current_ext;
>  	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork),
> -			current_ext - 1, &new);
> -	xfs_iext_remove(ip, current_ext, 1, 0);
> +			*current_ext, &new);
>  
>  	/* update reverse mapping. rmap functions merge the rmaps for us */
>  	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, got);
> @@ -5687,16 +5688,10 @@ xfs_bmap_collapse_extents(
>  
>  		if (xfs_bmse_can_merge(&prev, &got, offset_shift_fsb)) {
>  			error = xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
> -					current_ext, &got, &prev, cur,
> +					&current_ext, &got, &prev, cur,
>  					&logflags, dfops);
>  			if (error)
>  				goto del_cursor;
> -
> -			/* update got after merge */
> -			if (!xfs_iext_get_extent(ifp, current_ext, &got)) {
> -				*done = true;
> -				goto del_cursor;
> -			}
>  			goto done;
>  		}
>  	} else {
> @@ -5711,12 +5706,12 @@ xfs_bmap_collapse_extents(
>  	if (error)
>  		goto del_cursor;
>  
> +done:
>  	if (!xfs_iext_get_extent(ifp, ++current_ext, &got)) {
>  		 *done = true;
>  		 goto del_cursor;
>  	}
>  
> -done:
>  	*next_fsb = got.br_startoff;
>  del_cursor:
>  	if (cur)
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
