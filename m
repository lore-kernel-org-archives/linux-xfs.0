Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45954 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbeGMXIU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jul 2018 19:08:20 -0400
Date: Fri, 13 Jul 2018 15:51:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/6] xfs: avoid COW fork extent lookups in writeback if
 the fork didn't change
Message-ID: <20180713225135.GP32415@magnolia>
References: <20180712134910.30298-1-hch@lst.de>
 <20180712134910.30298-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180712134910.30298-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 12, 2018 at 03:49:10PM +0200, Christoph Hellwig wrote:
> Used the per-fork sequence counter to avoid lookups in the writeback code
> unless the COW fork actually changed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c  | 30 +++++++++++++++++++++++++-----
>  fs/xfs/xfs_iomap.c |  5 ++++-
>  fs/xfs/xfs_iomap.h |  2 +-
>  3 files changed, 30 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 814100d27343..aff9d44fa338 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -29,6 +29,7 @@
>  struct xfs_writepage_ctx {
>  	struct xfs_bmbt_irec    imap;
>  	unsigned int		io_type;
> +	unsigned int		cow_seq;
>  	struct xfs_ioend	*ioend;
>  };
>  
> @@ -310,6 +311,7 @@ xfs_map_blocks(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	ssize_t			count = i_blocksize(inode);
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset), end_fsb;
> +	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
>  	struct xfs_bmbt_irec	imap;
>  	int			whichfork = XFS_DATA_FORK;
>  	struct xfs_iext_cursor	icur;
> @@ -333,12 +335,15 @@ xfs_map_blocks(
>  	 * COW fork blocks can overlap data fork blocks even if the blocks
>  	 * aren't shared.  COW I/O always takes precedent, so we must always
>  	 * check for overlap on reflink inodes unless the mapping is already a
> -	 * COW one.
> +	 * COW one, or the COW fork hasn't changed from the last time we looked
> +	 * at it.
>  	 */
>  	imap_valid = offset_fsb >= wpc->imap.br_startoff &&
>  		     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount;
>  	if (imap_valid &&
> -	    (!xfs_inode_has_cow_data(ip) || wpc->io_type == XFS_IO_COW))
> +	    (!xfs_inode_has_cow_data(ip) ||
> +	     wpc->io_type == XFS_IO_COW ||
> +	     wpc->cow_seq == ip->i_cowfp->if_seq))
>  		return 0;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
> @@ -364,8 +369,10 @@ xfs_map_blocks(
>  	 * it directly instead of looking up anything in the data fork.
>  	 */
>  	if (xfs_inode_has_cow_data(ip) &&
> -	    xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &imap) &&
> -	    imap.br_startoff <= offset_fsb) {
> +	    xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &imap))
> +		cow_fsb = imap.br_startoff;
> +	if (cow_fsb != NULLFILEOFF && cow_fsb <= offset_fsb) {
> +		wpc->cow_seq = ip->i_cowfp->if_seq;
>  		xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  		/*
>  		 * Truncate can race with writeback since writeback doesn't
> @@ -411,6 +418,16 @@ xfs_map_blocks(
>  		imap.br_startblock = HOLESTARTBLOCK;
>  		wpc->io_type = XFS_IO_HOLE;
>  	} else {
> +		/*
> +		 * Truncate to the next COW extent if there is one.  This is the
> +		 * only opportunity to do this because we can skip COW fork
> +		 * lookups for the subsequent blocks in the mapping; however,
> +		 * the requirement to treat the COW range separately remains.
> +		 */
> +		if (cow_fsb != NULLFILEOFF &&
> +		    cow_fsb < imap.br_startoff + imap.br_blockcount)
> +			imap.br_blockcount = cow_fsb - imap.br_startoff;
> +
>  		if (isnullstartblock(imap.br_startblock)) {
>  			/* got a delalloc extent */
>  			wpc->io_type = XFS_IO_DELALLOC;
> @@ -427,9 +444,12 @@ xfs_map_blocks(
>  	trace_xfs_map_blocks_found(ip, offset, count, wpc->io_type, &imap);
>  	return 0;
>  allocate_blocks:
> -	error = xfs_iomap_write_allocate(ip, whichfork, offset, &imap);
> +	error = xfs_iomap_write_allocate(ip, whichfork, offset, &imap,
> +			&wpc->cow_seq);
>  	if (error)
>  		return error;
> +	ASSERT(whichfork == XFS_COW_FORK || cow_fsb == NULLFILEOFF ||
> +	       imap.br_startoff + imap.br_blockcount <= cow_fsb);
>  	wpc->imap = imap;
>  	trace_xfs_map_blocks_alloc(ip, offset, count, wpc->io_type, &imap);
>  	return 0;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 756694219f77..43a7ff7f450c 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -658,7 +658,8 @@ xfs_iomap_write_allocate(
>  	xfs_inode_t	*ip,
>  	int		whichfork,
>  	xfs_off_t	offset,
> -	xfs_bmbt_irec_t *imap)
> +	xfs_bmbt_irec_t *imap,
> +	unsigned int	*cow_seq)
>  {
>  	xfs_mount_t	*mp = ip->i_mount;
>  	xfs_fileoff_t	offset_fsb, last_block;
> @@ -780,6 +781,8 @@ xfs_iomap_write_allocate(
>  			if (error)
>  				goto error0;
>  
> +			if (whichfork == XFS_COW_FORK)
> +				*cow_seq = XFS_IFORK_PTR(ip, whichfork)->if_seq;
>  			xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		}
>  
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index 83474c9cede9..c6170548831b 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -14,7 +14,7 @@ struct xfs_bmbt_irec;
>  int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
>  			struct xfs_bmbt_irec *, int);
>  int xfs_iomap_write_allocate(struct xfs_inode *, int, xfs_off_t,
> -			struct xfs_bmbt_irec *);
> +			struct xfs_bmbt_irec *, unsigned int *);
>  int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
>  
>  void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
> -- 
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
