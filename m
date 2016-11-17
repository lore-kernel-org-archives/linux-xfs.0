Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49752 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933718AbcKQSdc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Nov 2016 13:33:32 -0500
Date: Thu, 17 Nov 2016 13:33:30 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/14] xfs: use new extent lookup helpers
 xfs_file_iomap_begin_delay
Message-ID: <20161117183330.GI49658@bfoster.bfoster>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
 <1479143565-30615-8-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479143565-30615-8-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 14, 2016 at 06:12:38PM +0100, Christoph Hellwig wrote:
> And only lookup the previous extent inside xfs_iomap_prealloc_size
> if we actually need it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iomap.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 59ffcac..2272190 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -395,11 +395,12 @@ xfs_iomap_prealloc_size(
>  	struct xfs_inode	*ip,
>  	loff_t			offset,
>  	loff_t			count,
> -	xfs_extnum_t		idx,
> -	struct xfs_bmbt_irec	*prev)
> +	xfs_extnum_t		idx)

My cow prealloc series is going to end up adding this right back, fwiw.
Though at that point it's not really "prev" as used throughout the
extent manipulation code, but rather just an extent on which to base the
initial prealloc size.

That aside, looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> +	struct xfs_bmbt_irec	prev;
>  	int			shift = 0;
>  	int64_t			freesp;
>  	xfs_fsblock_t		qblocks;
> @@ -419,8 +420,8 @@ xfs_iomap_prealloc_size(
>  	 */
>  	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ||
>  	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
> -	    idx == 0 ||
> -	    prev->br_startoff + prev->br_blockcount < offset_fsb)
> +	    !xfs_iext_get_extent(ifp, idx - 1, &prev) ||
> +	    prev.br_startoff + prev.br_blockcount < offset_fsb)
>  		return mp->m_writeio_blocks;
>  
>  	/*
> @@ -439,8 +440,8 @@ xfs_iomap_prealloc_size(
>  	 * always extends to MAXEXTLEN rather than falling short due to things
>  	 * like stripe unit/width alignment of real extents.
>  	 */
> -	if (prev->br_blockcount <= (MAXEXTLEN >> 1))
> -		alloc_blocks = prev->br_blockcount << 1;
> +	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
> +		alloc_blocks = prev.br_blockcount << 1;
>  	else
>  		alloc_blocks = XFS_B_TO_FSB(mp, offset);
>  	if (!alloc_blocks)
> @@ -538,7 +539,6 @@ xfs_file_iomap_begin_delay(
>  	xfs_fileoff_t		end_fsb, orig_end_fsb;
>  	int			error = 0, eof = 0;
>  	struct xfs_bmbt_irec	got;
> -	struct xfs_bmbt_irec	prev;
>  	xfs_extnum_t		idx;
>  
>  	ASSERT(!XFS_IS_REALTIME_INODE(ip));
> @@ -563,8 +563,7 @@ xfs_file_iomap_begin_delay(
>  			goto out_unlock;
>  	}
>  
> -	xfs_bmap_search_extents(ip, offset_fsb, XFS_DATA_FORK, &eof, &idx,
> -			&got, &prev);
> +	eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got);
>  	if (!eof && got.br_startoff <= offset_fsb) {
>  		if (xfs_is_reflink_inode(ip)) {
>  			bool		shared;
> @@ -601,8 +600,7 @@ xfs_file_iomap_begin_delay(
>  	if (eof) {
>  		xfs_fsblock_t	prealloc_blocks;
>  
> -		prealloc_blocks =
> -			xfs_iomap_prealloc_size(ip, offset, count, idx, &prev);
> +		prealloc_blocks = xfs_iomap_prealloc_size(ip, offset, count, idx);
>  		if (prealloc_blocks) {
>  			xfs_extlen_t	align;
>  			xfs_off_t	end_offset;
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
