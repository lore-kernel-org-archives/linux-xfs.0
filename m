Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40874 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbeE3R4r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 13:56:47 -0400
Date: Wed, 30 May 2018 10:56:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/18] xfs: move all writeback buffer_head manipulation
 into xfs_map_at_offset
Message-ID: <20180530175640.GR837@magnolia>
References: <20180530100013.31358-1-hch@lst.de>
 <20180530100013.31358-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530100013.31358-15-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 12:00:09PM +0200, Christoph Hellwig wrote:
> This keeps it in a single place so it can be made otional more easily.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c | 22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 7d02d04d5a5b..025f2acac100 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -495,21 +495,6 @@ xfs_imap_valid(
>  		offset < imap->br_startoff + imap->br_blockcount;
>  }
>  
> -STATIC void
> -xfs_start_buffer_writeback(
> -	struct buffer_head	*bh)
> -{
> -	ASSERT(buffer_mapped(bh));
> -	ASSERT(buffer_locked(bh));
> -	ASSERT(!buffer_delay(bh));
> -	ASSERT(!buffer_unwritten(bh));
> -
> -	bh->b_end_io = NULL;
> -	set_buffer_async_write(bh);
> -	set_buffer_uptodate(bh);
> -	clear_buffer_dirty(bh);
> -}
> -
>  STATIC void
>  xfs_start_page_writeback(
>  	struct page		*page,
> @@ -718,6 +703,7 @@ xfs_map_at_offset(
>  	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
>  	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
>  
> +	lock_buffer(bh);
>  	xfs_map_buffer(inode, bh, imap, offset);
>  	set_buffer_mapped(bh);
>  	clear_buffer_delay(bh);
> @@ -730,6 +716,10 @@ xfs_map_at_offset(
>  	 * set the bdev now.
>  	 */
>  	bh->b_bdev = xfs_find_bdev_for_inode(inode);
> +	bh->b_end_io = NULL;
> +	set_buffer_async_write(bh);
> +	set_buffer_uptodate(bh);
> +	clear_buffer_dirty(bh);
>  }
>  
>  STATIC void
> @@ -875,11 +865,9 @@ xfs_writepage_map(
>  			continue;
>  		}
>  
> -		lock_buffer(bh);
>  		xfs_map_at_offset(inode, bh, &wpc->imap, file_offset);
>  		xfs_add_to_ioend(inode, file_offset, page, wpc, wbc,
>  				&submit_list);
> -		xfs_start_buffer_writeback(bh);
>  		count++;
>  	}
>  
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
