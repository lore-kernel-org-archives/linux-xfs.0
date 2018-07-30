Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:37802 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728746AbeG3W0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 18:26:06 -0400
Date: Mon, 30 Jul 2018 13:49:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/15] xfs: always defer agfl block frees
Message-ID: <20180730204916.GO30972@magnolia>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-15-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-15-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:45:19PM -0400, Brian Foster wrote:
> The AGFL fixup code conditionally defers block frees from the free
> list based on whether the current transaction has an associated
> xfs_defer_ops structure. Now that dfops is embedded in the
> transaction and the internal dfops is used unconditionally, this
> invariant is always true.
> 
> Remove the now dead logic to check for ->t_dfops in
> xfs_alloc_fix_freelist() and unconditionally defer AGFL block frees.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 6bacdc31a439..32a370665d71 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2323,15 +2323,8 @@ xfs_alloc_fix_freelist(
>  		if (error)
>  			goto out_agbp_relse;
>  
> -		/* defer agfl frees if dfops is provided */
> -		if (tp->t_dfops) {
> -			xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
> -		} else {
> -			error = xfs_free_agfl_block(tp, args->agno, bno, agbp,
> -						    &targs.oinfo);
> -			if (error)
> -				goto out_agbp_relse;
> -		}
> +		/* defer agfl frees */
> +		xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
>  	}
>  
>  	targs.tp = tp;
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
