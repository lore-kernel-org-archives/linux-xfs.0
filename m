Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755311AbeEaNrI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 09:47:08 -0400
Date: Thu, 31 May 2018 09:47:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/18] xfs: remove the imap_valid flag
Message-ID: <20180531134706.GF2997@bfoster.bfoster>
References: <20180530100013.31358-1-hch@lst.de>
 <20180530100013.31358-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530100013.31358-13-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 12:00:07PM +0200, Christoph Hellwig wrote:
> Simplify the way we check for a valid imap - we know we have a valid
> mapping after xfs_map_blocks returned successfully, and we know we can
> call xfs_imap_valid on any imap, as it will always fail on a
> zero-initialized map.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 7dc13b0aae60..910b410e5a90 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -42,7 +42,6 @@
>   */
>  struct xfs_writepage_ctx {
>  	struct xfs_bmbt_irec    imap;
> -	bool			imap_valid;
>  	unsigned int		io_type;
>  	struct xfs_ioend	*ioend;
>  	sector_t		last_block;
> @@ -858,10 +857,6 @@ xfs_writepage_map(
>  			continue;
>  		}
>  
> -		/* Check to see if current map spans this file offset */
> -		if (wpc->imap_valid)
> -			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
> -							 file_offset);
>  		/*
>  		 * If we don't have a valid map, now it's time to get a new one
>  		 * for this offset.  This will convert delayed allocations
> @@ -869,16 +864,14 @@ xfs_writepage_map(
>  		 * a valid map, it means we landed in a hole and we skip the
>  		 * block.
>  		 */
> -		if (!wpc->imap_valid) {
> +		if (!xfs_imap_valid(inode, &wpc->imap, file_offset)) {
>  			error = xfs_map_blocks(inode, file_offset, &wpc->imap,
>  					     &wpc->io_type);
>  			if (error)
>  				goto out;
> -			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
> -							 file_offset);
>  		}
>  
> -		if (!wpc->imap_valid || wpc->io_type == XFS_IO_HOLE) {
> +		if (wpc->io_type == XFS_IO_HOLE) {
>  			/*
>  			 * set_page_dirty dirties all buffers in a page, independent
>  			 * of their state.  The dirty state however is entirely
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
