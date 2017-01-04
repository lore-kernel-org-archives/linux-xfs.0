Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761451AbdADSTm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Jan 2017 13:19:42 -0500
Date: Wed, 4 Jan 2017 13:19:41 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/5] xfs: adjust allocation length in
 xfs_alloc_space_available
Message-ID: <20170104181940.GD41989@bfoster.bfoster>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
 <1482436822-31546-5-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482436822-31546-5-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Thu, Dec 22, 2016 at 09:00:21PM +0100, Christoph Hellwig wrote:
> We must decide in xfs_alloc_fix_freelist if we can perform an
> allocation from a given AG is possible or not based on the available
> space, and should not fail the allocation past that point on a
> healthy file system.
> 
> But currently we have two additional places that second-guess
> xfs_alloc_fix_freelist: xfs_alloc_ag_vextent tries to adjust the
> maxlen parameter to remove the reservation before doing the
> allocation (but ignores the various minium freespace requirements),
> and xfs_alloc_fix_minleft tries to fix up the allocated length
> after we've found an extent, but ignores the reservations and also
> doesn't take the AGFL into account (and thus fails allocations
> for not matching minlen in some cases).
> 
> Remove all these later fixups and just correct the maxlen argument
> inside xfs_alloc_fix_freelist once we have the AGF buffer locked.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 80 ++++++++++-------------------------------------
>  fs/xfs/libxfs/xfs_alloc.h |  2 +-
>  2 files changed, 17 insertions(+), 65 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index fe92570..6a10aab 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
...
> @@ -2070,10 +2012,19 @@ xfs_alloc_space_available(
>  
>  	/* do we have enough free space remaining for the allocation? */
>  	available = (int)(pag->pagf_freeblks + pag->pagf_flcount -
> -			  reservation - min_free - args->total);
> -	if (available < (int)args->minleft || available <= 0)
> +			  reservation - min_free - args->minleft);
> +	if (available < (int)args->total)
>  		return false;
>  
> +	/*
> +	 * Clamp maxlen to the amount of free space available for the actual
> +	 * extent allocation.
> +	 */
> +	if (available < (int)args->maxlen && !(flags & XFS_ALLOC_FLAG_CHECK)) {
> +		args->maxlen = available;
> +		ASSERT(args->maxlen > 0);

Still missing my nit from the previous version. Otherwise:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	}
> +
>  	return true;
>  }
>  
> @@ -2119,7 +2070,8 @@ xfs_alloc_fix_freelist(
>  	}
>  
>  	need = xfs_alloc_min_freelist(mp, pag);
> -	if (!xfs_alloc_space_available(args, need, flags))
> +	if (!xfs_alloc_space_available(args, need, flags |
> +			XFS_ALLOC_FLAG_CHECK))
>  		goto out_agbp_relse;
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 7c404a6..1d0f48a 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -56,7 +56,7 @@ typedef unsigned int xfs_alloctype_t;
>  #define	XFS_ALLOC_FLAG_FREEING	0x00000002  /* indicate caller is freeing extents*/
>  #define	XFS_ALLOC_FLAG_NORMAP	0x00000004  /* don't modify the rmapbt */
>  #define	XFS_ALLOC_FLAG_NOSHRINK	0x00000008  /* don't shrink the freelist */
> -
> +#define	XFS_ALLOC_FLAG_CHECK	0x00000010  /* test only, don't modify args */
>  
>  /*
>   * Argument structure for xfs_alloc routines.
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
