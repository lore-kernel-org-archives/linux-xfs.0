Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932984AbcJLOPj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Oct 2016 10:15:39 -0400
Date: Wed, 12 Oct 2016 10:15:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/9] xfs: optimize xfs_reflink_end_cow
Message-ID: <20161012141536.GD56019@bfoster.bfoster>
References: <1476106685-29048-1-git-send-email-hch@lst.de>
 <1476106685-29048-9-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476106685-29048-9-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Mon, Oct 10, 2016 at 03:38:04PM +0200, Christoph Hellwig wrote:
> Instead of doing a full extent list search for each extent that is to be
> deleted using xfs_bmapi_read and then doing another one inside of
> xfs_bunmapi_cow use the same scheme that xfs_bumapi uses:  look up the
> last extent to be deleted and then use the extent index to walk downward
> until we are outside the range to be deleted.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_reflink.c | 114 ++++++++++++++++++++++-----------------------------
>  fs/xfs/xfs_trace.h   |   1 -
>  2 files changed, 49 insertions(+), 66 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 08170bb..c4e7521 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -637,25 +637,22 @@ xfs_reflink_end_cow(
>  	xfs_off_t			offset,
>  	xfs_off_t			count)
>  {
> -	struct xfs_bmbt_irec		irec;
> -	struct xfs_bmbt_irec		uirec;
> +	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> +	struct xfs_bmbt_irec		got, prev, del;
>  	struct xfs_trans		*tp;
>  	xfs_fileoff_t			offset_fsb;
>  	xfs_fileoff_t			end_fsb;
> -	xfs_filblks_t			count_fsb;
>  	xfs_fsblock_t			firstfsb;
>  	struct xfs_defer_ops		dfops;
> -	int				error;
> +	int				error, eof = 0;
>  	unsigned int			resblks;
> -	xfs_filblks_t			ilen;
>  	xfs_filblks_t			rlen;
> -	int				nimaps;
> +	xfs_extnum_t			idx;
>  
>  	trace_xfs_reflink_end_cow(ip, offset, count);
>  
>  	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
>  	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
> -	count_fsb = (xfs_filblks_t)(end_fsb - offset_fsb);
>  
>  	/* Start a rolling transaction to switch the mappings */
>  	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
> @@ -667,73 +664,61 @@ xfs_reflink_end_cow(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	/* Go find the old extent in the CoW fork. */
> -	while (offset_fsb < end_fsb) {
> -		/* Read extent from the source file */
> -		nimaps = 1;
> -		count_fsb = (xfs_filblks_t)(end_fsb - offset_fsb);
> -		error = xfs_bmapi_read(ip, offset_fsb, count_fsb, &irec,
> -				&nimaps, XFS_BMAPI_COWFORK);
> -		if (error)
> -			goto out_cancel;
> -		ASSERT(nimaps == 1);
> -
> -		ASSERT(irec.br_startblock != DELAYSTARTBLOCK);
> -		trace_xfs_reflink_cow_remap(ip, &irec);
> +	xfs_bmap_search_extents(ip, end_fsb - 1, XFS_COW_FORK, &eof, &idx,
> +			&got, &prev);
> +	if (eof) {
> +		ASSERT(idx > 0);
> +		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, --idx), &got);
> +	}

Hmm, should this happen? Do we really want to proceed with the previous
extent?

I suppose the extent trim below would catch if we've dropped outside the
range of the I/O, but note that if trim extent sets blockcount = 0, it
doesn't necessarily reset the start offset for the (del.br_startoff ==
offset_fsb) check at next_extent. Perhaps that should break once the del
end offset precedes offset_fsb..?

Either way, it would be nice to have a comment here if there's some
reason we shouldn't just bail out or flag a problem...

>  
> -		/*
> -		 * We can have a hole in the CoW fork if part of a directio
> -		 * write is CoW but part of it isn't.
> -		 */
> -		rlen = ilen = irec.br_blockcount;
> -		if (irec.br_startblock == HOLESTARTBLOCK)
> +	do {
> +		ASSERT(!isnullstartblock(got.br_startblock));
> +		del = got;
> +		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
> +		if (!del.br_blockcount)
>  			goto next_extent;
>  
>  		/* Unmap the old blocks in the data fork. */
> -		while (rlen) {
> -			xfs_defer_init(&dfops, &firstfsb);
> -			error = __xfs_bunmapi(tp, ip, irec.br_startoff,
> -					&rlen, 0, 1, &firstfsb, &dfops);
> -			if (error)
> -				goto out_defer;
> -
> -			/*
> -			 * Trim the extent to whatever got unmapped.
> -			 * Remember, bunmapi works backwards.
> -			 */
> -			uirec.br_startblock = irec.br_startblock + rlen;
> -			uirec.br_startoff = irec.br_startoff + rlen;
> -			uirec.br_blockcount = irec.br_blockcount - rlen;
> -			irec.br_blockcount = rlen;
> -			trace_xfs_reflink_cow_remap_piece(ip, &uirec);
> +		xfs_defer_init(&dfops, &firstfsb);
> +		rlen = del.br_blockcount;
> +		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1,
> +				&firstfsb, &dfops);
> +		if (error)
> +			goto out_defer;
>  
> -			/* Free the CoW orphan record. */
> -			error = xfs_refcount_free_cow_extent(tp->t_mountp,
> -					&dfops, uirec.br_startblock,
> -					uirec.br_blockcount);
> -			if (error)
> -				goto out_defer;
> +		/* Trim the extent to whatever got unmapped. */
> +		if (rlen) {
> +			xfs_trim_extent(&del, del.br_startoff + rlen,
> +				del.br_blockcount - rlen);
> +		}
> +		trace_xfs_reflink_cow_remap(ip, &del);
>  
> -			/* Map the new blocks into the data fork. */
> -			error = xfs_bmap_map_extent(tp->t_mountp, &dfops,
> -					ip, &uirec);
> -			if (error)
> -				goto out_defer;
> +		/* Free the CoW orphan record. */
> +		error = xfs_refcount_free_cow_extent(tp->t_mountp, &dfops,
> +				del.br_startblock, del.br_blockcount);
> +		if (error)
> +			goto out_defer;
>  
> -			/* Remove the mapping from the CoW fork. */
> -			error = xfs_bunmapi_cow(ip, &uirec);
> -			if (error)
> -				goto out_defer;
> +		/* Map the new blocks into the data fork. */
> +		error = xfs_bmap_map_extent(tp->t_mountp, &dfops, ip, &del);
> +		if (error)
> +			goto out_defer;
>  
> -			error = xfs_defer_finish(&tp, &dfops, ip);
> -			if (error)
> -				goto out_defer;
> -		}
> +		/* Remove the mapping from the CoW fork. */
> +		xfs_bmap_del_extent_cow(ip, &idx, &got, &del);
> +
> +		error = xfs_defer_finish(&tp, &dfops, ip);
> +		if (error)
> +			goto out_defer;
>  
>  next_extent:
> -		/* Roll on... */
> -		offset_fsb = irec.br_startoff + ilen;
> -	}
> +		if (del.br_startoff == offset_fsb || idx < 0)
> +			break;
> +
> +		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &got);
> +		if (got.br_startoff >= del.br_startoff && --idx >= 0)
> +			xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &got);
> +	} while (got.br_startoff < del.br_startoff);

Maybe it's just me, but I find this whole loop kind of confusing. I
realize it is tricky because we have to handle several different cases
with regard to index (no more extents to the left, bmap_del_extent_cow()
pushing index forward or back).

In staring at it a bit, I'm wondering if something like the following
would work:

	/* walk backwards until we're out of the I/O range... */
	while (got.br_startoff + got.br_blockcount > offset_fsb) {
		del = got;
		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
		/* extent delete may have bumped idx forward */
		if (!del.br_blockcount) {
			idx--;
			goto next_extent;
		}

		...

next_extent:
		if (idx < 0)
			break;
		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &got);
	}

Thoughts?

Brian

>  
>  	error = xfs_trans_commit(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -743,7 +728,6 @@ next_extent:
>  
>  out_defer:
>  	xfs_defer_cancel(&dfops);
> -out_cancel:
>  	xfs_trans_cancel(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  out:
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 520660d..f3b4418 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3357,7 +3357,6 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_irec);
>  DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
>  DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap);
> -DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_piece);
>  
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_allocate_cow_range_error);
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_cow_range_error);
> -- 
> 2.10.1.382.ga23ca1b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
