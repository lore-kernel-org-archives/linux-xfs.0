Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21575 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965205AbcIZVgG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2016 17:36:06 -0400
Date: Mon, 26 Sep 2016 14:35:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: rewrite the COW writeback mapping code
Message-ID: <20160926213557.GD14092@birch.djwong.org>
References: <1474730361-5234-1-git-send-email-hch@lst.de>
 <1474730361-5234-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474730361-5234-3-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sat, Sep 24, 2016 at 08:19:21AM -0700, Christoph Hellwig wrote:
> Add a new xfs_map_cow helper that does a single consistent lookup in the
> COW fork extent map, and remove the existing COW handling code from
> xfs_map_blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c | 119 +++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 69 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 1933803..2a3f4c1 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -357,15 +357,11 @@ xfs_map_blocks(
>  	int			error = 0;
>  	int			bmapi_flags = XFS_BMAPI_ENTIRE;
>  	int			nimaps = 1;
> -	int			whichfork;
> -	bool			need_alloc;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	whichfork = (type == XFS_IO_COW ? XFS_COW_FORK : XFS_DATA_FORK);
> -	need_alloc = (type == XFS_IO_DELALLOC);
> -
> +	ASSERT(type != XFS_IO_COW);
>  	if (type == XFS_IO_UNWRITTEN)
>  		bmapi_flags |= XFS_BMAPI_IGSTATE;
>  
> @@ -378,36 +374,26 @@ xfs_map_blocks(
>  		count = mp->m_super->s_maxbytes - offset;
>  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> -
> -	if (type == XFS_IO_COW) {
> -		if (!xfs_reflink_find_cow_mapping(ip, offset, imap,
> -						     &need_alloc)) {
> -			WARN_ON_ONCE(1);
> -			return -EIO;
> -		}
> -	} else {
> -		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> -				       imap, &nimaps, bmapi_flags);
> -		/*
> -		 * Truncate an overwrite extent if there's a pending CoW
> -		 * reservation before the end of this extent.  This forces us
> -		 * to come back to writepage to take care of the CoW.
> -		 */
> -		if (nimaps && type == XFS_IO_OVERWRITE)
> -			xfs_reflink_trim_irec_to_next_cow(ip, offset_fsb, imap);
> -	}
> +	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> +				imap, &nimaps, bmapi_flags);
> +	/*
> +	 * Truncate an overwrite extent if there's a pending CoW
> +	 * reservation before the end of this extent.  This forces us
> +	 * to come back to writepage to take care of the CoW.
> +	 */
> +	if (nimaps && type == XFS_IO_OVERWRITE)
> +		xfs_reflink_trim_irec_to_next_cow(ip, offset_fsb, imap);
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  
>  	if (error)
>  		return error;
>  
> -	if (need_alloc &&
> +	if (type == XFS_IO_DELALLOC &&
>  	    (!nimaps || isnullstartblock(imap->br_startblock))) {
> -		error = xfs_iomap_write_allocate(ip, whichfork, offset,
> +		error = xfs_iomap_write_allocate(ip, XFS_DATA_FORK, offset,
>  				imap);
>  		if (!error)
> -			trace_xfs_map_blocks_alloc(ip, offset, count, type,
> -					imap);
> +			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
>  		return error;
>  	}
>  
> @@ -707,27 +693,6 @@ xfs_check_page_type(
>  	return false;
>  }
>  
> -/*
> - * Figure out if CoW is pending at this offset.
> - */
> -static bool
> -xfs_is_cow_io(
> -	struct xfs_inode	*ip,
> -	xfs_off_t		offset)
> -{
> -	struct xfs_bmbt_irec	imap;
> -	bool			is_cow, need_alloc;
> -
> -	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
> -		return false;
> -
> -	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	is_cow = xfs_reflink_find_cow_mapping(ip, offset, &imap, &need_alloc);
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -
> -	return is_cow;
> -}
> -
>  STATIC void
>  xfs_vm_invalidatepage(
>  	struct page		*page,
> @@ -804,6 +769,56 @@ out_invalidate:
>  	return;
>  }
>  
> +static int
> +xfs_map_cow(
> +	struct xfs_writepage_ctx *wpc,
> +	struct inode		*inode,
> +	loff_t			offset,
> +	unsigned int		*new_type)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_bmbt_irec	imap;
> +	bool			is_cow = false, need_alloc = false;
> +	int			error;
> +
> +	/*
> +	 * If we already have a valid COW mapping keep using it.
> +	 */
> +	if (wpc->io_type == XFS_IO_COW) {
> +		wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap, offset);
> +		if (wpc->imap_valid) {
> +			*new_type = XFS_IO_COW;
> +			return 0;
> +		}
> +	}
> +
> +	/*
> +	 * Else we need to check if there is a COW mapping at this offset.
> +	 */
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	is_cow = xfs_reflink_find_cow_mapping(ip, offset, &imap, &need_alloc);
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +
> +	if (!is_cow)
> +		return 0;
> +
> +	/*
> +	 * And if the COW mapping has a delayed extent here we need to
> +	 * allocate real space for it now.
> +	 */
> +	if (need_alloc) {
> +		error = xfs_iomap_write_allocate(ip, XFS_COW_FORK, offset,
> +				&imap);
> +		if (error)
> +			return error;
> +	}
> +
> +	wpc->io_type = *new_type = XFS_IO_COW;
> +	wpc->imap_valid = true;
> +	wpc->imap = imap;
> +	return 0;
> +}
> +
>  /*
>   * We implement an immediate ioend submission policy here to avoid needing to
>   * chain multiple ioends and hence nest mempool allocations which can violate
> @@ -876,8 +891,12 @@ xfs_writepage_map(
>  			continue;
>  		}
>  
> -		if (xfs_is_cow_io(XFS_I(inode), offset))
> -			new_type = XFS_IO_COW;
> +		if (xfs_sb_version_hasreflink(&XFS_I(inode)->i_mount->m_sb)) {

This could be:

if (xfs_is_reflink_inode(XFS_I(inode))) {

since we don't have to care about COW mappings unless the inode also has
shared extents.  The code you got this from seems to have this bug too;
I'll just fix this when I push the patch onto my stack.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +			error = xfs_map_cow(wpc, inode, offset, &new_type);
> +			if (error)
> +				goto out;
> +		}
> +
>  		if (wpc->io_type != new_type) {
>  			wpc->io_type = new_type;
>  			wpc->imap_valid = false;
> -- 
> 2.1.4
> 
