Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52594 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753645AbeEHBLv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 21:11:51 -0400
Date: Mon, 7 May 2018 18:11:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 3/6] xfs: defer agfl block frees from deferred ops
 processing context
Message-ID: <20180508011132.GG11261@magnolia>
References: <20180418133119.21775-1-bfoster@redhat.com>
 <20180418133119.21775-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418133119.21775-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 18, 2018 at 09:31:16AM -0400, Brian Foster wrote:
> Now that AGFL block frees are deferred when dfops is set in the
> transaction, start deferring AGFL block frees from contexts that are
> known to push the limits of existing log reservations.
> 
> The first such context is deferred operation processing itself. This
> primarily targets deferred extent frees (such as file extents and
> inode chunks), but in doing so covers all allocation operations that
> occur in deferred operation processing context.
> 
> Update xfs_defer_finish() to set and reset ->t_agfl_dfops across the
> processing sequence. This means that any AGFL block frees due to
> allocation events result in the addition of new EFIs to the dfops
> rather than being processed immediately. xfs_defer_finish() rolls
> the transaction at least once more to process the frees of the AGFL
> blocks back to the allocation btrees and returns once the AGFL is
> rectified.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_defer.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 087fea02c389..4d87d9661907 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -352,11 +352,22 @@ xfs_defer_finish(
>  	void				*state;
>  	int				error = 0;
>  	void				(*cleanup_fn)(struct xfs_trans *, void *, int);
> +	struct xfs_defer_ops		*orig_dop;
>  
>  	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
>  
>  	trace_xfs_defer_finish((*tp)->t_mountp, dop);
>  
> +	/*
> +	 * Attach dfops to the transaction during deferred ops processing. This
> +	 * explicitly causes calls into the allocator to defer AGFL block frees.
> +	 * Note that this code can go away once all dfops users attach to the
> +	 * associated tp.
> +	 */
> +	ASSERT(!(*tp)->t_agfl_dfops || ((*tp)->t_agfl_dfops == dop));
> +	orig_dop = (*tp)->t_agfl_dfops;
> +	(*tp)->t_agfl_dfops = dop;
> +
>  	/* Until we run out of pending work to finish... */
>  	while (xfs_defer_has_unfinished_work(dop)) {
>  		/* Log intents for work items sitting in the intake. */
> @@ -428,6 +439,7 @@ xfs_defer_finish(
>  	}
>  
>  out:
> +	(*tp)->t_agfl_dfops = orig_dop;
>  	if (error)
>  		trace_xfs_defer_finish_error((*tp)->t_mountp, dop, error);
>  	else
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
