Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47618 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbeLRXij (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 18:38:39 -0500
Date: Tue, 18 Dec 2018 15:38:28 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/11] xfs: report IOMAP_F_SHARED from
 xfs_file_iomap_begin_delay
Message-ID: <20181218233828.GU27208@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
 <20181203222503.30649-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203222503.30649-10-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 03, 2018 at 05:25:01PM -0500, Christoph Hellwig wrote:
> No user of it in the iomap code at the moment, but we should not
> actively report wrong information if we can trivially get it right.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iomap.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index d19f99e5476a..bbc5d2e06b06 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -541,7 +541,7 @@ xfs_file_iomap_begin_delay(
>  	struct xfs_bmbt_irec	imap, cmap;
>  	struct xfs_iext_cursor	icur, ccur;
>  	xfs_fsblock_t		prealloc_blocks = 0;
> -	bool			eof = false, cow_eof = false, shared;
> +	bool			eof = false, cow_eof = false, shared = false;
>  	int			whichfork = XFS_DATA_FORK;
>  	int			error = 0;
>  
> @@ -709,13 +709,14 @@ xfs_file_iomap_begin_delay(
>  		if (imap.br_startoff > offset_fsb) {
>  			xfs_trim_extent(&cmap, offset_fsb,
>  					imap.br_startoff - offset_fsb);
> -			error = xfs_bmbt_to_iomap(ip, iomap, &cmap, false);
> +			error = xfs_bmbt_to_iomap(ip, iomap, &cmap, true);

Does this belong in the previous patch?  (Maybe all of it?)

--D

>  			goto out_unlock;
>  		}
>  		/* ensure we only report blocks we have a reservation for */
>  		xfs_trim_extent(&imap, cmap.br_startoff, cmap.br_blockcount);
> +		shared = true;
>  	}
> -	error = xfs_bmbt_to_iomap(ip, iomap, &imap, false);
> +	error = xfs_bmbt_to_iomap(ip, iomap, &imap, shared);
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
> -- 
> 2.19.1
> 
