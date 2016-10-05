Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752015AbcJES0v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Oct 2016 14:26:51 -0400
Date: Wed, 5 Oct 2016 14:26:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 35/63] xfs: move mappings from cow fork to data fork
 after copy-write
Message-ID: <20161005182648.GB4042@bfoster.bfoster>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520496726.29434.17171766557131973673.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520496726.29434.17171766557131973673.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu, Sep 29, 2016 at 08:09:27PM -0700, Darrick J. Wong wrote:
> After the write component of a copy-write operation finishes, clean up
> the bookkeeping left behind.  On error, we simply free the new blocks
> and pass the error up.  If we succeed, however, then we must remove
> the old data fork mapping and move the cow fork mapping to the data
> fork.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> [hch: Call the CoW failure function during xfs_cancel_ioend]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> v2: If CoW fails, we need to remove the CoW fork mapping and free the
> blocks.  Furthermore, if xfs_cancel_ioend happens, we also need to
> clean out all the CoW record keeping.
> 
> v3: When we're removing CoW extents, only free one extent per
> transaction to avoid running out of reservation.  Also,
> xfs_cancel_ioend mustn't clean out the CoW fork because it is called
> when async writeback can't get an inode lock and will try again.
> 
> v4: Use bmapi_read to iterate the CoW fork instead of calling the
> iext functions directly, and make the CoW remapping atomic by
> using the deferred ops mechanism which takes care of logging redo
> items for us.
> 
> v5: Unlock the inode if cancelling the CoW reservation fails.
> ---
>  fs/xfs/xfs_aops.c    |   22 ++++
>  fs/xfs/xfs_reflink.c |  271 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_reflink.h |    8 +
>  3 files changed, 299 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 7b1e9de..aa23993 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -288,6 +288,23 @@ xfs_end_io(
>  		error = -EIO;
>  
>  	/*
> +	 * For a CoW extent, we need to move the mapping from the CoW fork
> +	 * to the data fork.  If instead an error happened, just dump the
> +	 * new blocks.
> +	 */
> +	if (ioend->io_type == XFS_IO_COW) {
> +		if (ioend->io_bio->bi_error) {
> +			error = xfs_reflink_cancel_cow_range(ip,
> +					ioend->io_offset, ioend->io_size);
> +			goto done;
> +		}

I'm a little confused why we'd clear out delalloc blocks here but not if
the write happens to fail in the first place (but I take it the
explanation for my previous comment still applies..).

> +		error = xfs_reflink_end_cow(ip, ioend->io_offset,
> +				ioend->io_size);
> +		if (error)
> +			goto done;

This hunk clobbers error if set by the previous check (not shown in the
diff) due to fs shutdown.

> +	}
> +
> +	/*
>  	 * For unwritten extents we need to issue transactions to convert a
>  	 * range to normal written extens after the data I/O has finished.
>  	 * Detecting and handling completion IO errors is done individually
> @@ -302,7 +319,8 @@ xfs_end_io(
>  	} else if (ioend->io_append_trans) {
>  		error = xfs_setfilesize_ioend(ioend, error);
>  	} else {
> -		ASSERT(!xfs_ioend_is_append(ioend));
> +		ASSERT(!xfs_ioend_is_append(ioend) ||
> +		       ioend->io_type == XFS_IO_COW);
>  	}
>  
>  done:
> @@ -316,7 +334,7 @@ xfs_end_bio(
>  	struct xfs_ioend	*ioend = bio->bi_private;
>  	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
>  
> -	if (ioend->io_type == XFS_IO_UNWRITTEN)
> +	if (ioend->io_type == XFS_IO_UNWRITTEN || ioend->io_type == XFS_IO_COW)
>  		queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
>  	else if (ioend->io_append_trans)
>  		queue_work(mp->m_data_workqueue, &ioend->io_work);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index e8c7c85..d913ad1 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -52,6 +52,7 @@
>  #include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
>  #include "xfs_iomap.h"
> +#include "xfs_rmap_btree.h"
>  
>  /*
>   * Copy on Write of Shared Blocks
> @@ -114,6 +115,37 @@
>   * ioend, the better.
>   */
>  
> +/* Trim extent to fit a logical block range. */
> +static void
> +xfs_trim_extent(
> +	struct xfs_bmbt_irec	*irec,
> +	xfs_fileoff_t		bno,
> +	xfs_filblks_t		len)
> +{
> +	xfs_fileoff_t		distance;
> +	xfs_fileoff_t		end = bno + len;
> +
> +	if (irec->br_startoff + irec->br_blockcount <= bno ||
> +	    irec->br_startoff >= end) {

Hmm, this seems like slightly strange behavior. Why reset blockcount on
an extent for a request to trim it to something beyond the extent? Is
this primarily an error/sanity check or is this an expected case?

As it is, it looks like bno should point to the end of irec in most
cases unless the unmap happens to remove less from the data fork than
what has been allocated in the cow fork (which seems sane). I wonder if
we just want to ASSERT() that the extent and trim range are sane here?

> +		irec->br_blockcount = 0;
> +		return;
> +	}
> +
> +	if (irec->br_startoff < bno) {
> +		distance = bno - irec->br_startoff;
> +		if (irec->br_startblock != DELAYSTARTBLOCK &&
> +		    irec->br_startblock != HOLESTARTBLOCK)
> +			irec->br_startblock += distance;
> +		irec->br_startoff += distance;
> +		irec->br_blockcount -= distance;
> +	}
> +
> +	if (end < irec->br_startoff + irec->br_blockcount) {
> +		distance = irec->br_startoff + irec->br_blockcount - end;
> +		irec->br_blockcount -= distance;
> +	}
> +}
> +
>  /*
>   * Given an AG extent, find the lowest-numbered run of shared blocks within
>   * that range and return the range in fbno/flen.
> @@ -400,3 +432,242 @@ xfs_reflink_trim_irec_to_next_cow(
>  
>  	return 0;
>  }
> +
> +/*
> + * Cancel all pending CoW reservations for some block range of an inode.
> + */
> +int
> +xfs_reflink_cancel_cow_blocks(
> +	struct xfs_inode		*ip,
> +	struct xfs_trans		**tpp,
> +	xfs_fileoff_t			offset_fsb,
> +	xfs_fileoff_t			end_fsb)
> +{
> +	struct xfs_bmbt_irec		irec;
> +	xfs_filblks_t			count_fsb;
> +	xfs_fsblock_t			firstfsb;
> +	struct xfs_defer_ops		dfops;
> +	int				error = 0;
> +	int				nimaps;
> +
> +	if (!xfs_is_reflink_inode(ip))
> +		return 0;
> +
> +	/* Go find the old extent in the CoW fork. */
> +	count_fsb = (xfs_filblks_t)(end_fsb - offset_fsb);
> +	while (count_fsb) {
> +		nimaps = 1;
> +		error = xfs_bmapi_read(ip, offset_fsb, count_fsb, &irec,
> +				&nimaps, XFS_BMAPI_COWFORK);
> +		if (error)
> +			break;
> +		ASSERT(nimaps == 1);
> +
> +		trace_xfs_reflink_cancel_cow(ip, &irec);
> +
> +		if (irec.br_startblock == DELAYSTARTBLOCK) {
> +			/* Free a delayed allocation. */
> +			xfs_mod_fdblocks(ip->i_mount, irec.br_blockcount,
> +					false);
> +			ip->i_delayed_blks -= irec.br_blockcount;
> +
> +			/* Remove the mapping from the CoW fork. */
> +			error = xfs_bunmapi_cow(ip, &irec);
> +			if (error)
> +				break;
> +		} else if (irec.br_startblock == HOLESTARTBLOCK) {
> +			/* empty */
> +		} else {
> +			xfs_trans_ijoin(*tpp, ip, 0);
> +			xfs_defer_init(&dfops, &firstfsb);
> +
> +			xfs_bmap_add_free(ip->i_mount, &dfops,
> +					irec.br_startblock, irec.br_blockcount,
> +					NULL);
> +
> +			/* Update quota accounting */
> +			xfs_trans_mod_dquot_byino(*tpp, ip, XFS_TRANS_DQ_BCOUNT,
> +					-(long)irec.br_blockcount);
> +
> +			/* Roll the transaction */
> +			error = xfs_defer_finish(tpp, &dfops, ip);
> +			if (error) {
> +				xfs_defer_cancel(&dfops);
> +				break;
> +			}
> +
> +			/* Remove the mapping from the CoW fork. */
> +			error = xfs_bunmapi_cow(ip, &irec);
> +			if (error)
> +				break;
> +		}
> +
> +		/* Roll on... */
> +		count_fsb -= irec.br_startoff + irec.br_blockcount - offset_fsb;

Might be wise to safeguard against the extent being larger than the
range (or just use offset_fsb and kill count_fsb)...

> +		offset_fsb = irec.br_startoff + irec.br_blockcount;
> +	}
> +
> +	return error;
> +}
> +
> +/*
> + * Cancel all pending CoW reservations for some byte range of an inode.
> + */
> +int
> +xfs_reflink_cancel_cow_range(
> +	struct xfs_inode	*ip,
> +	xfs_off_t		offset,
> +	xfs_off_t		count)
> +{
> +	struct xfs_trans	*tp;
> +	xfs_fileoff_t		offset_fsb;
> +	xfs_fileoff_t		end_fsb;
> +	int			error;
> +
> +	trace_xfs_reflink_cancel_cow_range(ip, offset, count);
> +
> +	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
> +	if (count == NULLFILEOFF)
> +		end_fsb = NULLFILEOFF;
> +	else
> +		end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
> +
> +	/* Start a rolling transaction to remove the mappings */
> +	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
> +			0, 0, 0, &tp);
> +	if (error)
> +		goto out;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> +
> +	/* Scrape out the old CoW reservations */
> +	error = xfs_reflink_cancel_cow_blocks(ip, &tp, offset_fsb, end_fsb);
> +	if (error)
> +		goto out_defer;
> +
> +	error = xfs_trans_commit(tp);
> +
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return error;
> +
> +out_defer:

out_cancel ?

> +	xfs_trans_cancel(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +out:
> +	trace_xfs_reflink_cancel_cow_range_error(ip, error, _RET_IP_);
> +	return error;
> +}
> +
> +/*
> + * Remap parts of a file's data fork after a successful CoW.
> + */
> +int
> +xfs_reflink_end_cow(
> +	struct xfs_inode		*ip,
> +	xfs_off_t			offset,
> +	xfs_off_t			count)
> +{
> +	struct xfs_bmbt_irec		irec;
> +	struct xfs_bmbt_irec		uirec;
> +	struct xfs_trans		*tp;
> +	xfs_fileoff_t			offset_fsb;
> +	xfs_fileoff_t			end_fsb;
> +	xfs_filblks_t			count_fsb;
> +	xfs_fsblock_t			firstfsb;
> +	struct xfs_defer_ops		dfops;
> +	int				error;
> +	unsigned int			resblks;
> +	xfs_filblks_t			ilen;
> +	xfs_filblks_t			rlen;
> +	int				nimaps;
> +
> +	trace_xfs_reflink_end_cow(ip, offset, count);
> +
> +	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
> +	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
> +	count_fsb = (xfs_filblks_t)(end_fsb - offset_fsb);
> +
> +	/* Start a rolling transaction to switch the mappings */
> +	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
> +	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
> +			resblks, 0, 0, &tp);
> +	if (error)
> +		goto out;

I forget the exact reason why we preallocate append transactions for I/O
completion, but it would be nice if Dave or somebody could chime in on
that to make sure we don't need to do something similar here (and for
the cancel case).

> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> +
> +	/* Go find the old extent in the CoW fork. */
> +	while (count_fsb) {
> +		/* Read extent from the source file */
> +		nimaps = 1;
> +		error = xfs_bmapi_read(ip, offset_fsb, count_fsb, &irec,
> +				&nimaps, XFS_BMAPI_COWFORK);
> +		if (error)
> +			goto out_cancel;
> +		ASSERT(nimaps == 1);
> +
> +		ASSERT(irec.br_startblock != DELAYSTARTBLOCK);
> +		trace_xfs_reflink_cow_remap(ip, &irec);
> +
> +		/*
> +		 * We can have a hole in the CoW fork if part of a directio
> +		 * write is CoW but part of it isn't.
> +		 */
> +		rlen = ilen = irec.br_blockcount;
> +		if (irec.br_startblock == HOLESTARTBLOCK)
> +			goto next_extent;
> +
> +		/* Unmap the old blocks in the data fork. */
> +		while (rlen) {
> +			xfs_defer_init(&dfops, &firstfsb);
> +			error = __xfs_bunmapi(tp, ip, irec.br_startoff,
> +					&rlen, 0, 1, &firstfsb, &dfops);
> +			if (error)
> +				goto out_defer;
> +
> +			/* Trim the extent to whatever got unmapped. */
> +			uirec = irec;
> +			xfs_trim_extent(&uirec, irec.br_startoff + rlen,
> +					irec.br_blockcount - rlen);

We assign uirec = irec, then pass calculated values based on irec and
rlen. How about xfs_trim_extent(&uirec, rlen)?

Also, it took me a while to grok that we "trim" the beginning of the
extent because bunmapi works backwards. A comment would be appreciated
here.  ;)

Brian

> +			irec.br_blockcount = rlen;
> +			trace_xfs_reflink_cow_remap_piece(ip, &uirec);
> +
> +			/* Map the new blocks into the data fork. */
> +			error = xfs_bmap_map_extent(tp->t_mountp, &dfops,
> +					ip, XFS_DATA_FORK, &uirec);
> +			if (error)
> +				goto out_defer;
> +
> +			/* Remove the mapping from the CoW fork. */
> +			error = xfs_bunmapi_cow(ip, &uirec);
> +			if (error)
> +				goto out_defer;
> +
> +			error = xfs_defer_finish(&tp, &dfops, ip);
> +			if (error)
> +				goto out_defer;
> +		}
> +
> +next_extent:
> +		/* Roll on... */
> +		count_fsb -= irec.br_startoff + ilen - offset_fsb;
> +		offset_fsb = irec.br_startoff + ilen;
> +	}
> +
> +	error = xfs_trans_commit(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	if (error)
> +		goto out;
> +	return 0;
> +
> +out_defer:
> +	xfs_defer_cancel(&dfops);
> +out_cancel:
> +	xfs_trans_cancel(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +out:
> +	trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 11408c0..bffa4be 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -33,4 +33,12 @@ extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
>  extern int xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
>  		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap);
>  
> +extern int xfs_reflink_cancel_cow_blocks(struct xfs_inode *ip,
> +		struct xfs_trans **tpp, xfs_fileoff_t offset_fsb,
> +		xfs_fileoff_t end_fsb);
> +extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
> +		xfs_off_t count);
> +extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
> +		xfs_off_t count);
> +
>  #endif /* __XFS_REFLINK_H */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
