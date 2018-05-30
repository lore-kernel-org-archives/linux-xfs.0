Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53272 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753834AbeE3Reo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 13:34:44 -0400
Date: Wed, 30 May 2018 10:34:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/18] xfs: don't clear imap_valid for a non-uptodate
 buffers
Message-ID: <20180530173437.GO837@magnolia>
References: <20180530100013.31358-1-hch@lst.de>
 <20180530100013.31358-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530100013.31358-12-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 12:00:06PM +0200, Christoph Hellwig wrote:
> Finding a buffer that isn't uptodate doesn't invalidate the mapping for
> any given block.  The last_sector check will already take care of starting
> another ioend as soon as we find any non-update buffer, and if the current
> mapping doesn't include the next uptodate buffer the xfs_imap_valid check
> will take care of it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index cef2bc3cf98b..7dc13b0aae60 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -849,15 +849,12 @@ xfs_writepage_map(
>  			break;
>  
>  		/*
> -		 * Block does not contain valid data, skip it, mark the current
> -		 * map as invalid because we have a discontiguity. This ensures
> -		 * we put subsequent writeable buffers into a new ioend.
> +		 * Block does not contain valid data, skip it.
>  		 */
>  		if (!buffer_uptodate(bh)) {
>  			if (PageUptodate(page))
>  				ASSERT(buffer_mapped(bh));
>  			uptodate = false;
> -			wpc->imap_valid = false;
>  			continue;
>  		}
>  
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
