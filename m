Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40946 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752982AbeE3SIp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 14:08:45 -0400
Date: Wed, 30 May 2018 11:08:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/18] xfs: do not set the page uptodate in
 xfs_writepage_map
Message-ID: <20180530180839.GU837@magnolia>
References: <20180530100013.31358-1-hch@lst.de>
 <20180530100013.31358-18-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530100013.31358-18-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 12:00:12PM +0200, Christoph Hellwig wrote:
> We already track the page uptodate status based on the buffer uptodate
> status, which is updated whenever reading or zeroing blocks.
> 
> This code has been there since commit a ptool commit in 2002, which
> claims to:
> 
>     "merge" the 2.4 fsx fix for block size < page size to 2.5.  This needed
>     major changes to actually fit.
> 
> and isn't present in other writepage implementations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, assuming that reads or buffered writes set the page
uptodate...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index ac417ef326a9..84f88cecd2f1 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -786,7 +786,6 @@ xfs_writepage_map(
>  	ssize_t			len = i_blocksize(inode);
>  	int			error = 0;
>  	int			count = 0;
> -	bool			uptodate = true;
>  	loff_t			file_offset;	/* file offset of page */
>  	unsigned		poffset;	/* offset into page */
>  
> @@ -813,7 +812,6 @@ xfs_writepage_map(
>  		if (!buffer_uptodate(bh)) {
>  			if (PageUptodate(page))
>  				ASSERT(buffer_mapped(bh));
> -			uptodate = false;
>  			continue;
>  		}
>  
> @@ -847,9 +845,6 @@ xfs_writepage_map(
>  		count++;
>  	}
>  
> -	if (uptodate && poffset == PAGE_SIZE)
> -		SetPageUptodate(page);
> -
>  	ASSERT(wpc->ioend || list_empty(&submit_list));
>  
>  out:
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
