Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727157AbeIZVaj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Sep 2018 17:30:39 -0400
Date: Wed, 26 Sep 2018 11:17:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/10] xfs: simplify the IOMAP_ZERO check in
 xfs_file_iomap_begin a bit
Message-ID: <20180926151711.GA899@bfoster>
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

Hmm, can't this subtlely change behavior? Suppose we get a zero range
call over a non-shared delalloc extent of a reflinked file. The current
code gets into the reflink branch above, needs_cow_for_zeroing() returns
true because it's not an unwritten extent, xfs_reflink_reserve_cow()
doesn't ultimately do anything because the range is not shared, we skip
out via the check above and presumably the core iomap code zeroes the
page.

With this change, it looks like that scenario plays out the same until
we get to imap_needs_alloc(), which returns true and brings us to do an
allocation... I guess this changes a bit in the follow on patches, but
the IOMAP_ZERO check that remains still makes the logic look funny.
Should we ever get here with IOMAP_ZERO after the final patch to switch
to separate ops?

Brian

>  	if (!imap_needs_alloc(inode, &imap, nimaps))
>  		goto out_found;
>  
> -- 
> 2.18.0
> 
