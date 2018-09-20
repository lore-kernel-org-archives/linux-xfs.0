Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbeIUCRH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 22:17:07 -0400
Date: Thu, 20 Sep 2018 13:31:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/10] xfs: simplify the IOMAP_ZERO check in
 xfs_file_iomap_begin a bit
Message-ID: <20180920203146.GR20086@magnolia>
References: <20180917205354.15401-1-hch@lst.de>
 <20180917205354.15401-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180917205354.15401-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 17, 2018 at 10:53:48PM +0200, Christoph Hellwig wrote:
> Merge the two cases for reflink vs not into a single one.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_iomap.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 6320aca39f39..9595a3c59ade 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1048,16 +1048,20 @@ xfs_file_iomap_begin(
>  	if (!(flags & (IOMAP_WRITE | IOMAP_ZERO)))
>  		goto out_found;
>  
> +	/*
> +	 * Don't need to allocate over holes when doing zeroing operations,
> +	 * unless we need to COW and have an existing extent.
> +	 */
> +	if ((flags & IOMAP_ZERO) &&
> +	    (!xfs_is_reflink_inode(ip) ||
> +	     !needs_cow_for_zeroing(&imap, nimaps)))
> +		goto out_found;
> +
>  	/*
>  	 * Break shared extents if necessary. Checks for non-blocking IO have
>  	 * been done up front, so we don't need to do them here.
>  	 */
>  	if (xfs_is_reflink_inode(ip)) {
> -		/* if zeroing doesn't need COW allocation, then we are done. */
> -		if ((flags & IOMAP_ZERO) &&
> -		    !needs_cow_for_zeroing(&imap, nimaps))
> -			goto out_found;
> -
>  		if (flags & IOMAP_DIRECT) {
>  			/* may drop and re-acquire the ilock */
>  			error = xfs_reflink_allocate_cow(ip, &imap, &shared,
> @@ -1074,10 +1078,6 @@ xfs_file_iomap_begin(
>  		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
>  	}
>  
> -	/* Don't need to allocate over holes when doing zeroing operations. */
> -	if (flags & IOMAP_ZERO)
> -		goto out_found;
> -
>  	if (!imap_needs_alloc(inode, &imap, nimaps))
>  		goto out_found;
>  
> -- 
> 2.18.0
> 
