Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbeLRXjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 18:39:24 -0500
Date: Tue, 18 Dec 2018 15:39:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/11] xfs: also truncate holes covered by COW blocks
Message-ID: <20181218233919.GV27208@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
 <20181203222503.30649-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203222503.30649-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 03, 2018 at 05:24:59PM -0500, Christoph Hellwig wrote:
> This only matters if we want to write data through the COW fork that is
> not actually an overwrite of existing data.  Reasons for that are
> speculative COW fork allocations using the cowextsize, or a mode where
> we always write through the COW fork.  Currently both can't actually
> happen, but I plan to enable them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 124b8de37115..7d95a84064e7 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -403,28 +403,29 @@ xfs_map_blocks(
>  
>  	wpc->fork = XFS_DATA_FORK;
>  
> +	/* landed in a hole or beyond EOF? */
>  	if (imap.br_startoff > offset_fsb) {
> -		/* landed in a hole or beyond EOF */
>  		imap.br_blockcount = imap.br_startoff - offset_fsb;
>  		imap.br_startoff = offset_fsb;
>  		imap.br_startblock = HOLESTARTBLOCK;
>  		imap.br_state = XFS_EXT_NORM;
> -	} else {
> -		/*
> -		 * Truncate to the next COW extent if there is one.  This is the
> -		 * only opportunity to do this because we can skip COW fork
> -		 * lookups for the subsequent blocks in the mapping; however,
> -		 * the requirement to treat the COW range separately remains.
> -		 */
> -		if (cow_fsb != NULLFILEOFF &&
> -		    cow_fsb < imap.br_startoff + imap.br_blockcount)
> -			imap.br_blockcount = cow_fsb - imap.br_startoff;
> -
> -		/* got a delalloc extent? */
> -		if (isnullstartblock(imap.br_startblock))
> -			goto allocate_blocks;
>  	}
>  
> +	/*
> +	 * Truncate to the next COW extent if there is one.  This is the only
> +	 * opportunity to do this because we can skip COW fork lookups for the
> +	 * subsequent blocks in the mapping; however, the requirement to treat
> +	 * the COW range separately remains.
> +	 */
> +	if (cow_fsb != NULLFILEOFF &&
> +	    cow_fsb < imap.br_startoff + imap.br_blockcount)
> +		imap.br_blockcount = cow_fsb - imap.br_startoff;
> +
> +	/* got a delalloc extent? */
> +	if (imap.br_startblock != HOLESTARTBLOCK &&
> +	    isnullstartblock(imap.br_startblock))
> +		goto allocate_blocks;
> +
>  	wpc->imap = imap;
>  	trace_xfs_map_blocks_found(ip, offset, count, wpc->fork, &imap);
>  	return 0;
> -- 
> 2.19.1
> 
