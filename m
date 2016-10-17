Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57456 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933255AbcJQRTT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 13:19:19 -0400
Date: Mon, 17 Oct 2016 13:19:16 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/9] xfs: optimize writes to reflink files
Message-ID: <20161017171915.GG12736@bfoster.bfoster>
References: <1476521554-1894-1-git-send-email-hch@lst.de>
 <1476521554-1894-6-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476521554-1894-6-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Sat, Oct 15, 2016 at 10:52:30AM +0200, Christoph Hellwig wrote:
> Instead of reserving space as the first thing in write_begin move it past
> reading the extent in the data fork.  That way we only have to read from
> the data fork once and can reuse that information for trimming the extent
> to the shared/unshared boundary.  Additionally this allows to easily
> limit the actual write size to said boundary, and avoid a roundtrip on the
> ilock.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iomap.c   |  56 +++++++++++++-------
>  fs/xfs/xfs_reflink.c | 141 +++++++++++++++++++++------------------------------
>  fs/xfs/xfs_reflink.h |   4 +-
>  fs/xfs/xfs_trace.h   |   3 +-
>  4 files changed, 100 insertions(+), 104 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 1dabf2e..436e109 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -566,6 +566,17 @@ xfs_file_iomap_begin_delay(
>  	xfs_bmap_search_extents(ip, offset_fsb, XFS_DATA_FORK, &eof, &idx,
>  			&got, &prev);
>  	if (!eof && got.br_startoff <= offset_fsb) {
> +		if (xfs_is_reflink_inode(ip)) {
> +			bool		shared;
> +
> +			end_fsb = min(XFS_B_TO_FSB(mp, offset + count),
> +					maxbytes_fsb);
> +			xfs_trim_extent(&got, offset_fsb, end_fsb - offset_fsb);
> +			error = xfs_reflink_reserve_cow(ip, &got, &shared);
> +			if (error)
> +				goto out_unlock;
> +		}
> +
>  		trace_xfs_iomap_found(ip, offset, count, 0, &got);
>  		goto done;
>  	}
> @@ -961,19 +972,13 @@ xfs_file_iomap_begin(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_bmbt_irec	imap;
>  	xfs_fileoff_t		offset_fsb, end_fsb;
> -	bool			shared, trimmed;
>  	int			nimaps = 1, error = 0;
> +	bool			shared = false, trimmed = false;
>  	unsigned		lockmode;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
> -		error = xfs_reflink_reserve_cow_range(ip, offset, length);
> -		if (error < 0)
> -			return error;
> -	}
> -
>  	if ((flags & IOMAP_WRITE) && !IS_DAX(inode) &&
>  		   !xfs_get_extsz_hint(ip)) {
>  		/* Reserve delalloc blocks for regular writeback. */
> @@ -981,7 +986,16 @@ xfs_file_iomap_begin(
>  				iomap);
>  	}
>  
> -	lockmode = xfs_ilock_data_map_shared(ip);
> +	/*
> +	 * COW writes will allocate delalloc space, so we need to make sure
> +	 * to take the lock exclusively here.
> +	 */
> +	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
> +		lockmode = XFS_ILOCK_EXCL;
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	} else {
> +		lockmode = xfs_ilock_data_map_shared(ip);
> +	}
>  
>  	ASSERT(offset <= mp->m_super->s_maxbytes);
>  	if ((xfs_fsize_t)offset + length > mp->m_super->s_maxbytes)
> @@ -991,19 +1005,24 @@ xfs_file_iomap_begin(
>  
>  	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
>  			       &nimaps, 0);
> -	if (error) {
> -		xfs_iunlock(ip, lockmode);
> -		return error;
> -	}
> +	if (error)
> +		goto out_unlock;
>  
> -	if (flags & (IOMAP_WRITE | IOMAP_ZERO | IOMAP_REPORT)) {
> +	if (flags & IOMAP_REPORT) {
>  		/* Trim the mapping to the nearest shared extent boundary. */
>  		error = xfs_reflink_trim_around_shared(ip, &imap, &shared,
>  				&trimmed);
> -		if (error) {
> -			xfs_iunlock(ip, lockmode);
> -			return error;
> -		}
> +		if (error)
> +			goto out_unlock;
> +	}
> +
> +	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
> +		error = xfs_reflink_reserve_cow(ip, &imap, &shared);
> +		if (error)
> +			goto out_unlock;
> +
> +		end_fsb = imap.br_startoff + imap.br_blockcount;
> +		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
>  	}
>  
>  	if ((flags & IOMAP_WRITE) && imap_needs_alloc(inode, &imap, nimaps)) {
> @@ -1042,6 +1061,9 @@ xfs_file_iomap_begin(
>  	if (shared)
>  		iomap->flags |= IOMAP_F_SHARED;
>  	return 0;
> +out_unlock:
> +	xfs_iunlock(ip, lockmode);
> +	return error;
>  }
>  
>  static int
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 46c824c..5d230ea 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -228,50 +228,54 @@ xfs_reflink_trim_around_shared(
>  	}
>  }
>  
> -/* Create a CoW reservation for a range of blocks within a file. */
> -static int
> -__xfs_reflink_reserve_cow(
> +/*
> + * Trim the passed in imap to the next shared/unshared extent boundary, and
> + * if imap->br_startoff points to a shared extent reserve space for it in the
> + * COW fork.  In this case *shared is set to true, else to false.
> + *
> + * Note that imap will always contain the block numbers for the existing blocks
> + * in the data fork, as the upper layers need them for read-modify-write
> + * operations.
> + */
> +int
> +xfs_reflink_reserve_cow(
>  	struct xfs_inode	*ip,
> -	xfs_fileoff_t		*offset_fsb,
> -	xfs_fileoff_t		end_fsb,
> -	bool			*skipped)
> +	struct xfs_bmbt_irec	*imap,
> +	bool			*shared)
>  {
> -	struct xfs_bmbt_irec	got, prev, imap;
> -	xfs_fileoff_t		orig_end_fsb;
> -	int			nimaps, eof = 0, error = 0;
> -	bool			shared = false, trimmed = false;
> +	struct xfs_bmbt_irec	got, prev;
> +	xfs_fileoff_t		end_fsb, orig_end_fsb;
> +	int			eof = 0, error = 0;
> +	bool			trimmed;
>  	xfs_extnum_t		idx;
>  	xfs_extlen_t		align;
>  
> -	/* Already reserved?  Skip the refcount btree access. */
> -	xfs_bmap_search_extents(ip, *offset_fsb, XFS_COW_FORK, &eof, &idx,
> +	/*
> +	 * Search the COW fork extent list first.  This serves two purposes:
> +	 * first this implement the speculative preallocation using cowextisze,
> +	 * so that we also unshared block adjacent to shared blocks instead
> +	 * of just the shared blocks themselves.  Second the lookup in the
> +	 * extent list is generally faster than going out to the shared extent
> +	 * tree.
> +	 */
> +	xfs_bmap_search_extents(ip, imap->br_startoff, XFS_COW_FORK, &eof, &idx,
>  			&got, &prev);
> -	if (!eof && got.br_startoff <= *offset_fsb) {
> -		end_fsb = orig_end_fsb = got.br_startoff + got.br_blockcount;
> -		trace_xfs_reflink_cow_found(ip, &got);
> -		goto done;
> -	}
> +	if (!eof && got.br_startoff <= imap->br_startoff) {
> +		trace_xfs_reflink_cow_found(ip, imap);
> +		xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
>  
> -	/* Read extent from the source file. */
> -	nimaps = 1;
> -	error = xfs_bmapi_read(ip, *offset_fsb, end_fsb - *offset_fsb,
> -			&imap, &nimaps, 0);
> -	if (error)
> -		goto out_unlock;
> -	ASSERT(nimaps == 1);
> +		*shared = true;
> +		return 0;
> +	}
>  
>  	/* Trim the mapping to the nearest shared extent boundary. */
> -	error = xfs_reflink_trim_around_shared(ip, &imap, &shared, &trimmed);
> +	error = xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
>  	if (error)
> -		goto out_unlock;
> -
> -	end_fsb = orig_end_fsb = imap.br_startoff + imap.br_blockcount;
> +		return error;
>  
>  	/* Not shared?  Just report the (potentially capped) extent. */
> -	if (!shared) {
> -		*skipped = true;
> -		goto done;
> -	}
> +	if (!*shared)
> +		return 0;
>  
>  	/*
>  	 * Fork all the shared blocks from our write offset until the end of
> @@ -279,73 +283,40 @@ __xfs_reflink_reserve_cow(
>  	 */
>  	error = xfs_qm_dqattach_locked(ip, 0);
>  	if (error)
> -		goto out_unlock;
> +		return error;
> +
> +	end_fsb = orig_end_fsb = imap->br_startoff + imap->br_blockcount;
>  
>  	align = xfs_eof_alignment(ip, xfs_get_cowextsz_hint(ip));
>  	if (align)
>  		end_fsb = roundup_64(end_fsb, align);
>  
>  retry:
> -	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, *offset_fsb,
> -			end_fsb - *offset_fsb, &got,
> -			&prev, &idx, eof);
> +	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, imap->br_startoff,
> +			end_fsb - imap->br_startoff, &got, &prev, &idx, eof);
>  	switch (error) {
>  	case 0:
>  		break;
>  	case -ENOSPC:
>  	case -EDQUOT:
>  		/* retry without any preallocation */
> -		trace_xfs_reflink_cow_enospc(ip, &imap);
> +		trace_xfs_reflink_cow_enospc(ip, imap);
>  		if (end_fsb != orig_end_fsb) {
>  			end_fsb = orig_end_fsb;
>  			goto retry;
>  		}
>  		/*FALLTHRU*/
>  	default:
> -		goto out_unlock;
> +		return error;
>  	}
>  
>  	if (end_fsb != orig_end_fsb)
>  		xfs_inode_set_cowblocks_tag(ip);
>  
>  	trace_xfs_reflink_cow_alloc(ip, &got);
> -done:
> -	*offset_fsb = end_fsb;
> -out_unlock:
> -	return error;
> +	return 0;
>  }
>  
> -/* Create a CoW reservation for part of a file. */
> -int
> -xfs_reflink_reserve_cow_range(
> -	struct xfs_inode	*ip,
> -	xfs_off_t		offset,
> -	xfs_off_t		count)
> -{
> -	struct xfs_mount	*mp = ip->i_mount;
> -	xfs_fileoff_t		offset_fsb, end_fsb;
> -	bool			skipped = false;
> -	int			error;
> -
> -	trace_xfs_reflink_reserve_cow_range(ip, offset, count);
> -
> -	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> -	end_fsb = XFS_B_TO_FSB(mp, offset + count);
> -
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	while (offset_fsb < end_fsb) {
> -		error = __xfs_reflink_reserve_cow(ip, &offset_fsb, end_fsb,
> -				&skipped);
> -		if (error) {
> -			trace_xfs_reflink_reserve_cow_range_error(ip, error,
> -				_RET_IP_);
> -			break;
> -		}
> -	}
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -
> -	return error;
> -}
>  
>  /* Allocate all CoW reservations covering a range of blocks in a file. */
>  static int
> @@ -359,9 +330,8 @@ __xfs_reflink_allocate_cow(
>  	struct xfs_defer_ops	dfops;
>  	struct xfs_trans	*tp;
>  	xfs_fsblock_t		first_block;
> -	xfs_fileoff_t		next_fsb;
>  	int			nimaps = 1, error;
> -	bool			skipped = false;
> +	bool			shared;
>  
>  	xfs_defer_init(&dfops, &first_block);
>  
> @@ -372,33 +342,38 @@ __xfs_reflink_allocate_cow(
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
> -	next_fsb = *offset_fsb;
> -	error = __xfs_reflink_reserve_cow(ip, &next_fsb, end_fsb, &skipped);
> +	/* Read extent from the source file. */
> +	nimaps = 1;
> +	error = xfs_bmapi_read(ip, *offset_fsb, end_fsb - *offset_fsb,
> +			&imap, &nimaps, 0);
> +	if (error)
> +		goto out_unlock;
> +	ASSERT(nimaps == 1);
> +
> +	error = xfs_reflink_reserve_cow(ip, &imap, &shared);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	if (skipped) {
> -		*offset_fsb = next_fsb;
> +	if (!shared) {
> +		*offset_fsb = imap.br_startoff + imap.br_blockcount;
>  		goto out_trans_cancel;
>  	}
>  
>  	xfs_trans_ijoin(tp, ip, 0);
> -	error = xfs_bmapi_write(tp, ip, *offset_fsb, next_fsb - *offset_fsb,
> +	error = xfs_bmapi_write(tp, ip, imap.br_startoff, imap.br_blockcount,
>  			XFS_BMAPI_COWFORK, &first_block,
>  			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK),
>  			&imap, &nimaps, &dfops);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	/* We might not have been able to map the whole delalloc extent */
> -	*offset_fsb = min(*offset_fsb + imap.br_blockcount, next_fsb);
> -
>  	error = xfs_defer_finish(&tp, &dfops, NULL);
>  	if (error)
>  		goto out_trans_cancel;
>  
>  	error = xfs_trans_commit(tp);
>  
> +	*offset_fsb = imap.br_startoff + imap.br_blockcount;
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 5dc3c8a..9f76924 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -26,8 +26,8 @@ extern int xfs_reflink_find_shared(struct xfs_mount *mp, xfs_agnumber_t agno,
>  extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
>  		struct xfs_bmbt_irec *irec, bool *shared, bool *trimmed);
>  
> -extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip,
> -		xfs_off_t offset, xfs_off_t count);
> +extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
> +		struct xfs_bmbt_irec *imap, bool *shared);
>  extern int xfs_reflink_allocate_cow_range(struct xfs_inode *ip,
>  		xfs_off_t offset, xfs_off_t count);
>  extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index ad188d3..72f9f6b 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3346,7 +3346,7 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_alloc);
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_found);
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
>  
> -DEFINE_RW_EVENT(xfs_reflink_reserve_cow_range);
> +DEFINE_RW_EVENT(xfs_reflink_reserve_cow);
>  DEFINE_RW_EVENT(xfs_reflink_allocate_cow_range);
>  
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_bounce_dio_write);
> @@ -3358,7 +3358,6 @@ DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap);
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_piece);
>  
> -DEFINE_INODE_ERROR_EVENT(xfs_reflink_reserve_cow_range_error);
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_allocate_cow_range_error);
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_cow_range_error);
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_end_cow_error);
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
