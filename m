Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48435 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbcI0EfP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 00:35:15 -0400
Date: Mon, 26 Sep 2016 21:35:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: rewrite the COW allow path
Message-ID: <20160927043505.GF14092@birch.djwong.org>
References: <1474773755-26796-1-git-send-email-hch@lst.de>
 <1474773755-26796-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474773755-26796-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sat, Sep 24, 2016 at 08:22:35PM -0700, Christoph Hellwig wrote:
> This patch rewrites xfs_reflink_reserve_cow_range and everything below it
> in a similar fashion to what I did for the delayed allocation path
> earlier.  We now remove the number of lookups quite a bit and simplify
> the code.  The steps are:
> 
>  1) check if we already have an extent in the COW fork for the area.
>     If so nothing to do, we can move along.
>  2) look up block number for the current extent, and if there is none
>     it's not shared move along.
>  3) last but not least unshare the current extent as far as we are
>     going to write into it.  For this we avoid an additional COW
>     for lookup and use the information we set aside in step 1) above.
>  4) Goto 1) unless we've covered the whole range
> 
> As a nice side effect this also removes all the intrusions the reflink
> support added to the existing delated allocation code.
> 
> Last but not least this updates the xfs_reflink_reserve_cow_range
> calling convention to pass a byte offset and length, as that is
> what both callers expect anyway.

Seems reasonable, tests ok, so:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c    |  11 +---
>  fs/xfs/xfs_iomap.c   | 104 +++++++++---------------------
>  fs/xfs/xfs_iomap.h   |   5 +-
>  fs/xfs/xfs_pnfs.c    |   2 +-
>  fs/xfs/xfs_reflink.c | 174 ++++++++++++++++++++++++---------------------------
>  fs/xfs/xfs_reflink.h |   2 +-
>  fs/xfs/xfs_trace.h   |   6 +-
>  7 files changed, 118 insertions(+), 186 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index fc357d4..aee0c4c 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -675,16 +675,7 @@ xfs_file_dio_aio_write(
>  
>  	/* If this is a block-aligned directio CoW, remap immediately. */
>  	if (xfs_is_reflink_inode(ip) && !unaligned_io) {
> -		/*
> -		 * XXX(hch): this seems all a little messy, I'd much prefer to
> -		 * do this in the get_blocks handler or equivalent.  It's
> -		 * probably time to rewrite DIO using the iomap infrastructure..
> -		 */
> -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> -		ret = xfs_reflink_reserve_cow_range(ip,
> -				XFS_B_TO_FSBT(mp, iocb->ki_pos),
> -				XFS_B_TO_FSB(mp, iocb->ki_pos + count));
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +		ret = xfs_reflink_reserve_cow_range(ip, iocb->ki_pos, count);
>  		if (ret)
>  			goto out;
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 5afbfa5..d907eb9 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -49,13 +49,10 @@ void
>  xfs_bmbt_to_iomap(
>  	struct xfs_inode	*ip,
>  	struct iomap		*iomap,
> -	struct xfs_bmbt_irec	*imap,
> -	bool			is_shared)
> +	struct xfs_bmbt_irec	*imap)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  
> -	if (is_shared)
> -		iomap->flags |= IOMAP_F_SHARED;
>  	if (imap->br_startblock == HOLESTARTBLOCK) {
>  		iomap->blkno = IOMAP_NULL_BLOCK;
>  		iomap->type = IOMAP_HOLE;
> @@ -74,7 +71,7 @@ xfs_bmbt_to_iomap(
>  	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
>  }
>  
> -static xfs_extlen_t
> +xfs_extlen_t
>  xfs_eof_alignment(
>  	struct xfs_inode	*ip,
>  	xfs_extlen_t		extsize)
> @@ -525,15 +522,16 @@ check_writeio:
>  }
>  
>  static int
> -xfs_file_iomap_delay(
> -	struct xfs_inode	*ip,
> -	int			whichfork,
> -	xfs_off_t		offset,
> -	xfs_off_t		count,
> -	struct xfs_bmbt_irec	*imap)
> +xfs_file_iomap_begin_delay(
> +	struct inode		*inode,
> +	loff_t			offset,
> +	loff_t			count,
> +	unsigned		flags,
> +	struct iomap		*iomap)
>  {
> +	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	xfs_fileoff_t		maxbytes_fsb =
>  		XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> @@ -544,11 +542,13 @@ xfs_file_iomap_delay(
>  	xfs_extnum_t		idx;
>  
>  	ASSERT(!XFS_IS_REALTIME_INODE(ip));
> -	ASSERT(whichfork == XFS_COW_FORK || !xfs_get_extsz_hint(ip));
> +	ASSERT(!xfs_get_extsz_hint(ip));
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
>  	if (unlikely(XFS_TEST_ERROR(
> -	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> -	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
> +	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
> +	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
>  	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  		error = -EFSCORRUPTED;
> @@ -557,13 +557,13 @@ xfs_file_iomap_delay(
>  
>  	XFS_STATS_INC(mp, xs_blk_mapw);
>  
> -	if (whichfork == XFS_DATA_FORK && !(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(NULL, ip, whichfork);
> +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
>  		if (error)
>  			goto out_unlock;
>  	}
>  
> -	xfs_bmap_search_extents(ip, offset_fsb, whichfork, &eof, &idx,
> +	xfs_bmap_search_extents(ip, offset_fsb, XFS_DATA_FORK, &eof, &idx,
>  			&got, &prev);
>  	if (!eof && got.br_startoff <= offset_fsb) {
>  		trace_xfs_iomap_found(ip, offset, count, 0, &got);
> @@ -587,7 +587,7 @@ xfs_file_iomap_delay(
>  	end_fsb = orig_end_fsb =
>  		min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
>  
> -	if (eof && whichfork == XFS_DATA_FORK) {
> +	if (eof) {
>  		xfs_fsblock_t	prealloc_blocks;
>  
>  		prealloc_blocks =
> @@ -609,16 +609,8 @@ xfs_file_iomap_delay(
>  		}
>  	}
>  
> -	if (whichfork == XFS_COW_FORK) {
> -		xfs_extlen_t	align;
> -
> -		align = xfs_eof_alignment(ip, xfs_get_cowextsz_hint(ip));
> -		if (align)
> -			end_fsb = roundup_64(end_fsb, align);
> -	}
> -
>  retry:
> -	error = xfs_bmapi_reserve_delalloc(ip, whichfork, offset_fsb,
> +	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
>  			end_fsb - offset_fsb, &got,
>  			&prev, &idx, eof);
>  	switch (error) {
> @@ -641,7 +633,7 @@ retry:
>  	 * Tag the inode as speculatively preallocated so we can reclaim this
>  	 * space on demand, if necessary.
>  	 */
> -	if (end_fsb != orig_end_fsb && whichfork == XFS_DATA_FORK)
> +	if (end_fsb != orig_end_fsb)
>  		xfs_inode_set_eofblocks_tag(ip);
>  
>  	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
> @@ -655,48 +647,13 @@ done:
>  			goto out_unlock;
>  	}
>  
> -	*imap = got;
> +	xfs_bmbt_to_iomap(ip, iomap, &got);
>  
>  out_unlock:
> -	return error;
> -}
> -
> -/* Create a delalloc reservation in the data fork. */
> -static int
> -xfs_file_iomap_begin_delay(
> -	struct inode		*inode,
> -	loff_t			offset,
> -	loff_t			count,
> -	unsigned		flags,
> -	struct iomap		*iomap)
> -{
> -	struct xfs_bmbt_irec	got;
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	int			error;
> -
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	error = xfs_file_iomap_delay(ip, XFS_DATA_FORK, offset, count, &got);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	if (error)
> -		goto out;
> -	xfs_bmbt_to_iomap(ip, iomap, &got, false);
> -out:
>  	return error;
>  }
>  
> -/* Create a delalloc reservation in the CoW fork. */
> -int
> -xfs_iomap_cow_delay(
> -	struct xfs_inode	*ip,
> -	xfs_off_t		offset,
> -	size_t			count,
> -	struct xfs_bmbt_irec	*ret_imap)
> -{
> -	trace_xfs_iomap_cow_delay(ip, offset, count);
> -
> -	return xfs_file_iomap_delay(ip, XFS_COW_FORK, offset, count, ret_imap);
> -}
> -
>  /*
>   * Pass in a delayed allocate extent, convert it to real extents;
>   * return to the caller the extent we create which maps on top of
> @@ -1012,15 +969,8 @@ xfs_file_iomap_begin(
>  		return -EIO;
>  
>  	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
> -		/* Reserve delalloc blocks for CoW. */
> -		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> -		end_fsb = XFS_B_TO_FSB(mp, offset + length);
> -		trace_xfs_reflink_reserve_cow_range(ip, length, offset);
> -
> -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> -		error = xfs_reflink_reserve_cow_range(ip, offset_fsb, end_fsb);
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -		if (error)
> +		error = xfs_reflink_reserve_cow_range(ip, offset, length);
> +		if (error < 0)
>  			return error;
>  	}
>  
> @@ -1085,7 +1035,9 @@ xfs_file_iomap_begin(
>  		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
>  	}
>  
> -	xfs_bmbt_to_iomap(ip, iomap, &imap, shared);
> +	xfs_bmbt_to_iomap(ip, iomap, &imap);
> +	if (shared)
> +		iomap->flags |= IOMAP_F_SHARED;
>  	return 0;
>  }
>  
> @@ -1183,7 +1135,7 @@ out_unlock:
>  
>  	if (!error) {
>  		ASSERT(nimaps);
> -		xfs_bmbt_to_iomap(ip, iomap, &imap, false);
> +		xfs_bmbt_to_iomap(ip, iomap, &imap);
>  	}
>  
>  	return error;
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index 8886532..6d45cf0 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -28,11 +28,10 @@ int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
>  int xfs_iomap_write_allocate(struct xfs_inode *, int, xfs_off_t,
>  			struct xfs_bmbt_irec *);
>  int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
> -int xfs_iomap_cow_delay(struct xfs_inode *, xfs_off_t, size_t,
> -			struct xfs_bmbt_irec *);
>  
>  void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
> -		struct xfs_bmbt_irec *, bool);
> +		struct xfs_bmbt_irec *);
> +xfs_extlen_t xfs_eof_alignment(struct xfs_inode *ip, xfs_extlen_t extsize);
>  
>  extern struct iomap_ops xfs_iomap_ops;
>  extern struct iomap_ops xfs_xattr_iomap_ops;
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 5519e4b..93a7aaf 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -188,7 +188,7 @@ xfs_fs_map_blocks(
>  	}
>  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  
> -	xfs_bmbt_to_iomap(ip, iomap, &imap, false);
> +	xfs_bmbt_to_iomap(ip, iomap, &imap);
>  	*device_generation = mp->m_generation;
>  	return error;
>  out_unlock:
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index a1ba7f5..09e0e27 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -249,122 +249,112 @@ xfs_reflink_trim_around_shared(
>  	}
>  }
>  
> -/* Find the shared ranges under an irec, and set up delalloc extents. */
>  static int
> -xfs_reflink_reserve_cow_extent(
> +__xfs_reflink_reserve_cow(
>  	struct xfs_inode	*ip,
> -	struct xfs_bmbt_irec	*irec)
> +	xfs_fileoff_t		*offset_fsb,
> +	xfs_fileoff_t		end_fsb)
>  {
> -	struct xfs_bmbt_irec	rec;
> -	xfs_agnumber_t		agno;
> -	xfs_agblock_t		agbno;
> -	xfs_extlen_t		aglen;
> -	xfs_agblock_t		fbno;
> -	xfs_extlen_t		flen;
> -	xfs_fileoff_t		lblk;
> -	xfs_off_t		foffset;
> -	xfs_extlen_t		distance;
> -	size_t			fsize;
> -	int			error = 0;
> +	struct xfs_bmbt_irec	got, prev, imap;
> +	xfs_fileoff_t		orig_end_fsb;
> +	int			nimaps, eof = 0, error = 0;
> +	bool			shared = false, trimmed = false;
> +	xfs_extnum_t		idx;
> +	xfs_extlen_t		align;
> +
> +	/* Already reserved?  Skip the refcount btree access. */
> +	xfs_bmap_search_extents(ip, *offset_fsb, XFS_COW_FORK, &eof, &idx,
> +			&got, &prev);
> +	if (!eof && got.br_startoff <= *offset_fsb) {
> +		end_fsb = orig_end_fsb = got.br_startoff + got.br_blockcount;
> +		trace_xfs_reflink_cow_found(ip, &got);
> +		goto done;
> +	}
>  
> -	/* Holes, unwritten, and delalloc extents cannot be shared */
> -	if (ISUNWRITTEN(irec) ||
> -	    irec->br_startblock == HOLESTARTBLOCK ||
> -	    irec->br_startblock == DELAYSTARTBLOCK)
> -		return 0;
> +	/* Read extent from the source file. */
> +	nimaps = 1;
> +	error = xfs_bmapi_read(ip, *offset_fsb, end_fsb - *offset_fsb,
> +			&imap, &nimaps, 0);
> +	if (error)
> +		goto out_unlock;
> +	ASSERT(nimaps == 1);
>  
> -	trace_xfs_reflink_reserve_cow_extent(ip, irec);
> -	agno = XFS_FSB_TO_AGNO(ip->i_mount, irec->br_startblock);
> -	agbno = XFS_FSB_TO_AGBNO(ip->i_mount, irec->br_startblock);
> -	lblk = irec->br_startoff;
> -	aglen = irec->br_blockcount;
> +	/* Trim the mapping to the nearest shared extent boundary. */
> +	error = xfs_reflink_trim_around_shared(ip, &imap, &shared, &trimmed);
> +	if (error)
> +		goto out_unlock;
>  
> -	while (aglen > 0) {
> -		/* Find maximal fork range within this extent */
> -		error = xfs_reflink_find_shared(ip->i_mount, agno, agbno,
> -				aglen, &fbno, &flen, true);
> -		if (error)
> -			break;
> -		if (flen == 0) {
> -			distance = fbno - agbno;
> -			goto advloop;
> -		}
> +	end_fsb = orig_end_fsb = imap.br_startoff + imap.br_blockcount;
>  
> -		/* Add as much as we can to the cow fork */
> -		foffset = XFS_FSB_TO_B(ip->i_mount, lblk + fbno - agbno);
> -		fsize = XFS_FSB_TO_B(ip->i_mount, flen);
> -		error = xfs_iomap_cow_delay(ip, foffset, fsize, &rec);
> -		if (error)
> -			break;
> +	/* Not shared?  Just report the (potentially capped) extent. */
> +	if (!shared)
> +		goto done;
>  
> -		distance = (rec.br_startoff - lblk) + rec.br_blockcount;
> -advloop:
> -		if (aglen < distance)
> -			break;
> -		aglen -= distance;
> -		agbno += distance;
> -		lblk += distance;
> +	/*
> +	 * Fork all the shared blocks from our write offset until the end of
> +	 * the extent.
> +	 */
> +	error = xfs_qm_dqattach_locked(ip, 0);
> +	if (error)
> +		goto out_unlock;
> +
> +	align = xfs_eof_alignment(ip, xfs_get_cowextsz_hint(ip));
> +	if (align)
> +		end_fsb = roundup_64(end_fsb, align);
> +
> +retry:
> +	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, *offset_fsb,
> +			end_fsb - *offset_fsb, &got,
> +			&prev, &idx, eof);
> +	switch (error) {
> +	case 0:
> +		break;
> +	case -ENOSPC:
> +	case -EDQUOT:
> +		/* retry without any preallocation */
> +		trace_xfs_reflink_cow_enospc(ip, &imap);
> +		if (end_fsb != orig_end_fsb) {
> +			end_fsb = orig_end_fsb;
> +			goto retry;
> +		}
> +		/*FALLTHRU*/
> +	default:
> +		goto out_unlock;
>  	}
>  
> -	if (error)
> -		trace_xfs_reflink_reserve_cow_extent_error(ip, error, _RET_IP_);
> +	trace_xfs_reflink_cow_alloc(ip, &got);
> +done:
> +	*offset_fsb = end_fsb;
> +out_unlock:
>  	return error;
>  }
>  
> -/*
> - * Create CoW reservations for all shared blocks within a byte range of
> - * a file.
> - */
>  int
>  xfs_reflink_reserve_cow_range(
>  	struct xfs_inode	*ip,
> -	xfs_fileoff_t		offset_fsb,
> -	xfs_fileoff_t		end_fsb)
> +	xfs_off_t		offset,
> +	xfs_off_t		count)
>  {
> -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> -	struct xfs_bmbt_rec_host *gotp;
> -	struct xfs_bmbt_irec	imap;
> -	xfs_extnum_t		idx;
> -	int			nimaps, error = 0;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_fileoff_t		offset_fsb, end_fsb;
> +	int			error;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	trace_xfs_reflink_reserve_cow_range(ip, offset, count);
>  
> -	trace_xfs_reflink_reserve_cow_range(ip,
> -			XFS_FSB_TO_B(ip->i_mount, end_fsb - offset_fsb),
> -			XFS_FSB_TO_B(ip->i_mount, offset_fsb));
> +	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> +	end_fsb = XFS_B_TO_FSB(mp, offset + count);
>  
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	while (offset_fsb < end_fsb) {
> -		/* Already reserved?  Skip the refcount btree access. */
> -		gotp = xfs_iext_bno_to_ext(ifp, offset_fsb, &idx);
> -		if (gotp) {
> -			xfs_bmbt_get_all(gotp, &imap);
> -			if (imap.br_startoff <= offset_fsb &&
> -			    imap.br_startoff + imap.br_blockcount > offset_fsb) {
> -				offset_fsb = imap.br_startoff + imap.br_blockcount;
> -				continue;
> -			}
> -		}
> -
> -		/* Read extent from the source file. */
> -		nimaps = 1;
> -		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> -				&imap, &nimaps, 0);
> -		if (error)
> -			break;
> -
> -		if (nimaps == 0)
> +		error = __xfs_reflink_reserve_cow(ip, &offset_fsb, end_fsb);
> +		if (error) {
> +			trace_xfs_reflink_reserve_cow_range_error(ip, error,
> +				_RET_IP_);
>  			break;
> -
> -		/* Fork all the shared blocks in this extent. */
> -		error = xfs_reflink_reserve_cow_extent(ip, &imap);
> -		if (error)
> -			break;
> -
> -		offset_fsb += imap.br_blockcount;
> +		}
>  	}
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  
> -	if (error)
> -		trace_xfs_reflink_reserve_cow_range_error(ip, error, _RET_IP_);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 6519f19..0e19ec6 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -27,7 +27,7 @@ extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
>  		struct xfs_bmbt_irec *irec, bool *shared, bool *trimmed);
>  
>  extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip,
> -		xfs_fileoff_t offset_fsb, xfs_fileoff_t end_fsb);
> +		xfs_off_t offset, xfs_off_t count);
>  extern int xfs_reflink_allocate_cow_range(struct xfs_inode *ip, xfs_off_t pos,
>  		xfs_off_t len);
>  extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index dc891f4..c8fb91c 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3314,16 +3314,17 @@ DEFINE_INODE_ERROR_EVENT(xfs_reflink_dirty_page_error);
>  
>  /* copy on write */
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_around_shared);
> +DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_alloc);
> +DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_found);
> +DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
>  
>  DEFINE_RW_EVENT(xfs_reflink_reserve_cow_range);
> -DEFINE_INODE_IREC_EVENT(xfs_reflink_reserve_cow_extent);
>  DEFINE_RW_EVENT(xfs_reflink_allocate_cow_range);
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_allocate_cow_extent);
>  
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_bounce_dio_write);
>  DEFINE_IOMAP_EVENT(xfs_reflink_find_cow_mapping);
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_irec);
> -DEFINE_SIMPLE_IO_EVENT(xfs_iomap_cow_delay);
>  
>  DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
>  DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
> @@ -3331,7 +3332,6 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap);
>  DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_piece);
>  
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_reserve_cow_range_error);
> -DEFINE_INODE_ERROR_EVENT(xfs_reflink_reserve_cow_extent_error);
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_allocate_cow_range_error);
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_cow_range_error);
>  DEFINE_INODE_ERROR_EVENT(xfs_reflink_end_cow_error);
> -- 
> 2.1.4
> 
