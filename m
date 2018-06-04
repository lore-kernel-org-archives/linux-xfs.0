Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752637AbeFDMZk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Jun 2018 08:25:40 -0400
Date: Mon, 4 Jun 2018 08:25:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/21] xfs: rename the offset variable in
 xfs_writepage_map
Message-ID: <20180604122538.GD110455@bfoster.bfoster>
References: <20180531180759.21631-1-hch@lst.de>
 <20180531180759.21631-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180531180759.21631-12-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, May 31, 2018 at 08:07:49PM +0200, Christoph Hellwig wrote:
> Calling it file_offset makes the usage more clear, especially with
> a new poffset variable that will be added soon for the offset inside
> the page.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index d536509ca05b..6f57a785f4d3 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -824,15 +824,15 @@ xfs_writepage_map(
>  	struct xfs_ioend	*ioend, *next;
>  	struct buffer_head	*bh, *head;
>  	ssize_t			len = i_blocksize(inode);
> -	uint64_t		offset;
> +	uint64_t		file_offset;	/* file offset of page */
>  	int			error = 0;
>  	int			count = 0;
>  	unsigned int		new_type;
>  
>  	bh = head = page_buffers(page);
> -	offset = page_offset(page);
> +	file_offset = page_offset(page);
>  	do {
> -		if (offset >= end_offset)
> +		if (file_offset >= end_offset)
>  			break;
>  
>  		/*
> @@ -864,7 +864,7 @@ xfs_writepage_map(
>  		 * If we already have a valid COW mapping keep using it.
>  		 */
>  		if (wpc->io_type == XFS_IO_COW &&
> -		    xfs_imap_valid(inode, &wpc->imap, offset)) {
> +		    xfs_imap_valid(inode, &wpc->imap, file_offset)) {
>  			wpc->imap_valid = true;
>  			new_type = XFS_IO_COW;
>  		}
> @@ -876,13 +876,13 @@ xfs_writepage_map(
>  
>  		if (wpc->imap_valid)
>  			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
> -							 offset);
> +							 file_offset);
>  		if (!wpc->imap_valid || xfs_is_reflink_inode(XFS_I(inode))) {
> -			error = xfs_map_blocks(wpc, inode, offset);
> +			error = xfs_map_blocks(wpc, inode, file_offset);
>  			if (error)
>  				goto out;
>  			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
> -							 offset);
> +							 file_offset);
>  		}
>  
>  		if (!wpc->imap_valid || wpc->io_type == XFS_IO_HOLE)
> @@ -890,10 +890,10 @@ xfs_writepage_map(
>  
>  		lock_buffer(bh);
>  		if (wpc->io_type != XFS_IO_OVERWRITE)
> -			xfs_map_at_offset(inode, bh, &wpc->imap, offset);
> -		xfs_add_to_ioend(inode, bh, offset, wpc, wbc, &submit_list);
> +			xfs_map_at_offset(inode, bh, &wpc->imap, file_offset);
> +		xfs_add_to_ioend(inode, bh, file_offset, wpc, wbc, &submit_list);
>  		count++;
> -	} while (offset += len, ((bh = bh->b_this_page) != head));
> +	} while (file_offset += len, ((bh = bh->b_this_page) != head));
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
