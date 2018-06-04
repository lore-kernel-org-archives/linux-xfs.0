Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752559AbeFDM1A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Jun 2018 08:27:00 -0400
Date: Mon, 4 Jun 2018 08:26:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/21] xfs: make xfs_writepage_map extent map centric
Message-ID: <20180604122658.GE110455@bfoster.bfoster>
References: <20180531180759.21631-1-hch@lst.de>
 <20180531180759.21631-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180531180759.21631-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Thu, May 31, 2018 at 08:07:50PM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
...
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> [hch: forward port + slight refactoring]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c | 96 ++++++++++++++++++++++-------------------------
>  1 file changed, 44 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 6f57a785f4d3..a0ecfd63b858 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
...
> @@ -822,61 +830,46 @@ xfs_writepage_map(
>  {
>  	LIST_HEAD(submit_list);
>  	struct xfs_ioend	*ioend, *next;
> -	struct buffer_head	*bh, *head;
> +	struct buffer_head	*bh;
>  	ssize_t			len = i_blocksize(inode);
>  	uint64_t		file_offset;	/* file offset of page */
> +	unsigned		poffset;	/* offset into page */
>  	int			error = 0;
>  	int			count = 0;
> -	unsigned int		new_type;
>  
> -	bh = head = page_buffers(page);
> +	/*
> +	 * Walk the blocks on the page, and we we run off then end of the
> +	 * current map or find the current map invalid, grab a new one.
> +	 * We only use bufferheads here to check per-block state - they no
> +	 * longer control the iteration through the page. This allows us to
> +	 * replace the bufferhead with some other state tracking mechanism in
> +	 * future.
> +	 */
>  	file_offset = page_offset(page);
> -	do {
> +	bh = page_buffers(page);
> +	for (poffset = 0;
> +	     poffset < PAGE_SIZE;
> +	     poffset += len, file_offset += len, bh = bh->b_this_page) {
> +		/* past the range we are writing, so nothing more to write. */
>  		if (file_offset >= end_offset)
>  			break;
>  
> -		/*
> -		 * set_page_dirty dirties all buffers in a page, independent
> -		 * of their state.  The dirty state however is entirely
> -		 * meaningless for holes (!mapped && uptodate), so skip
> -		 * buffers covering holes here.
> -		 */
> -		if (!buffer_mapped(bh) && buffer_uptodate(bh))
> -			continue;
> -
> -		if (buffer_unwritten(bh))
> -			new_type = XFS_IO_UNWRITTEN;
> -		else if (buffer_delay(bh))
> -			new_type = XFS_IO_DELALLOC;
> -		else if (buffer_uptodate(bh))
> -			new_type = XFS_IO_OVERWRITE;
> -		else {
> +		if (!buffer_uptodate(bh)) {
>  			if (PageUptodate(page))
>  				ASSERT(buffer_mapped(bh));
> -			/*
> -			 * This buffer is not uptodate and will not be
> -			 * written to disk.
> -			 */
>  			continue;
>  		}
>  
> -		/*
> -		 * If we already have a valid COW mapping keep using it.
> -		 */
> -		if (wpc->io_type == XFS_IO_COW &&
> -		    xfs_imap_valid(inode, &wpc->imap, file_offset)) {
> -			wpc->imap_valid = true;
> -			new_type = XFS_IO_COW;
> -		}
> -
> -		if (wpc->io_type != new_type) {
> -			wpc->io_type = new_type;
> -			wpc->imap_valid = false;
> -		}
> -

We drop the previously lifted check but unless I'm missing something wrt
my previous comments on the imap_valid && io_type == COW case, we still
have that unconditional allocation behavior. I suspect if the previous
patch updated the logic below (and preserved it moving forward while
also perhaps adding to the comment to explain why we must call
xfs_map_blocks() in certain cases for reflink inodes), that would fix up
both of these patches.

Otherwise the rest of the changes here look fine to me.

Brian

>  		if (wpc->imap_valid)
>  			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
>  							 file_offset);
> +		/*
> +		 * If we don't have a valid map, now it's time to get a new one
> +		 * for this offset.  This will convert delayed allocations
> +		 * (including COW ones) into real extents.  If we return without
> +		 * a valid map, it means we landed in a hole and we skip the
> +		 * block.
> +		 */
>  		if (!wpc->imap_valid || xfs_is_reflink_inode(XFS_I(inode))) {
>  			error = xfs_map_blocks(wpc, inode, file_offset);
>  			if (error)
> @@ -889,11 +882,10 @@ xfs_writepage_map(
>  			continue;
>  
>  		lock_buffer(bh);
> -		if (wpc->io_type != XFS_IO_OVERWRITE)
> -			xfs_map_at_offset(inode, bh, &wpc->imap, file_offset);
> +		xfs_map_at_offset(inode, bh, &wpc->imap, file_offset);
>  		xfs_add_to_ioend(inode, bh, file_offset, wpc, wbc, &submit_list);
>  		count++;
> -	} while (file_offset += len, ((bh = bh->b_this_page) != head));
> +	}
>  
>  	ASSERT(wpc->ioend || list_empty(&submit_list));
>  
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
