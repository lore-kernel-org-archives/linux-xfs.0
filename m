Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761565AbdADSTs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Jan 2017 13:19:48 -0500
Date: Wed, 4 Jan 2017 13:19:47 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: don't rely on ->total in
 xfs_alloc_space_available
Message-ID: <20170104181947.GE41989@bfoster.bfoster>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
 <1482436822-31546-6-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482436822-31546-6-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Thu, Dec 22, 2016 at 09:00:22PM +0100, Christoph Hellwig wrote:
> ->total is a bit of an odd parameter passed down to the low-level
> allocator all the way from the high-level callers.  It's supposed to
> contain the maximum number of blocks to be allocated for the whole
> transaction [1].
> 
> But in xfs_iomap_write_allocate we only convert existing delayed
> allocations and thus only have a minimal block reservation for the
> current transaction, so xfs_alloc_space_available can't use it for
> the allocation decisions.  Use the maximum of args->total and the
> calculated block requirement to make a decision.  We probably should
> get rid of args->total eventually and instead apply ->minleft more
> broadly, but that will require some extensive changes all over.
> 
> [1] which creates lots of confusion as most callers don't decrement it
> once doing a first allocation.  But that's for a separate series.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 6a10aab..c121407 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1995,7 +1995,7 @@ xfs_alloc_space_available(
>  	int			flags)
>  {
>  	struct xfs_perag	*pag = args->pag;
> -	xfs_extlen_t		longest;
> +	xfs_extlen_t		alloc_len, longest;
>  	xfs_extlen_t		reservation; /* blocks that are still reserved */
>  	int			available;
>  
> @@ -2005,15 +2005,16 @@ xfs_alloc_space_available(
>  	reservation = xfs_ag_resv_needed(pag, args->resv);
>  
>  	/* do we have enough contiguous free space for the allocation? */
> +	alloc_len = args->minlen + (args->alignment - 1) + args->minalignslop;
>  	longest = xfs_alloc_longest_free_extent(args->mp, pag, min_free,
>  			reservation);
> -	if ((args->minlen + args->alignment + args->minalignslop - 1) > longest)
> +	if (longest < alloc_len)
>  		return false;
>  
>  	/* do we have enough free space remaining for the allocation? */
>  	available = (int)(pag->pagf_freeblks + pag->pagf_flcount -
>  			  reservation - min_free - args->minleft);
> -	if (available < (int)args->total)
> +	if (available < (int)max(args->total, alloc_len))
>  		return false;
>  
>  	/*
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
