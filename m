Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751723AbeCERo4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Mar 2018 12:44:56 -0500
Date: Mon, 5 Mar 2018 17:44:55 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: fix transaction allocation deadlock in IO path
Message-ID: <20180305174455.GB14201@wotan.suse.de>
References: <20180305041120.4224-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180305041120.4224-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 05, 2018 at 03:11:20PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_trans_alloc() does GFP_KERNEL allocation, and we can call it
> while holding pages locked for writeback in the ->writepages path.
> The memory allocation is allowed to wait on pages under writeback,
> and so can wait on pages that are held locked in writeback by the
> caller.
> 
> This affects both pre-IO submission and post-IO submission paths.
> Hence xfs_setsize_trans_alloc(), xfs_reflink_end_cow(),
> xfs_iomap_write_unwritten() and xfs_reflink_cancel_cow_range().
> xfs_iomap_write_unwritten() already does the right thing, but the
> others don't. Fix them.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

I believe these are two separate regressions though, introduced on separate
kernels Can we treat them as such and use respective Fixes tag for them?

> ---
>  fs/xfs/xfs_aops.c    | 3 ++-
>  fs/xfs/xfs_reflink.c | 4 ++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 9c6a830da0ee..a0afb6411417 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -209,7 +209,8 @@ xfs_setfilesize_trans_alloc(
>  	struct xfs_trans	*tp;
>  	int			error;
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0,
> +				XFS_TRANS_NOFS, &tp);
>  	if (error)
>  		return error;
>  

Fixes: 253f4911f297b ("xfs: better xfs_trans_alloc interface")

Introduced on v4.7

> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 270246943a06..8c16177b33d4 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -668,7 +668,7 @@ xfs_reflink_cancel_cow_range(
>  
>  	/* Start a rolling transaction to remove the mappings */
>  	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
> -			0, 0, 0, &tp);
> +			0, 0, XFS_TRANS_NOFS, &tp);
>  	if (error)
>  		goto out;
>  
> @@ -741,7 +741,7 @@ xfs_reflink_end_cow(
>  			(unsigned int)(end_fsb - offset_fsb),
>  			XFS_DATA_FORK);
>  	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
> -			resblks, 0, XFS_TRANS_RESERVE, &tp);
> +			resblks, 0, XFS_TRANS_RESERVE | XFS_TRANS_NOFS, &tp);
>  	if (error)
>  		goto out;

For both of the above:

Fixes: 43caeb187deb9 ("xfs: move mappings from cow fork to data fork after copy-write)"

Introduced on v4.9.

  Luis
