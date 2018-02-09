Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23001 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751031AbeBIQLp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Feb 2018 11:11:45 -0500
Date: Fri, 9 Feb 2018 11:11:43 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/7] xfs: make imaxpct changes in growfs separate
Message-ID: <20180209161143.GB21413@bfoster.bfoster>
References: <20180201064202.7174-1-david@fromorbit.com>
 <20180201064202.7174-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180201064202.7174-6-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 01, 2018 at 05:42:00PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When growfs changes the imaxpct value of the filesystem, it runs
> through all the "change size" growfs code, whether it needs to or
> not. Separate out changing imaxpct into it's own function and
> transaction to simplify the rest of the growfs code.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c | 67 +++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 49 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 94650b7d517e..5c844e540320 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
...
> @@ -673,25 +661,68 @@ xfs_growfs_log_private(
...
>  int
>  xfs_growfs_data(
> -	xfs_mount_t		*mp,
> -	xfs_growfs_data_t	*in)
> +	struct xfs_mount	*mp,
> +	struct xfs_growfs_data	*in)
>  {
> -	int error;
> +	int			error = 0;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  	if (!mutex_trylock(&mp->m_growlock))
>  		return -EWOULDBLOCK;
> +
> +	/* update imaxpct seperately to the physical grow of the filesystem */

separately

> +	if (in->imaxpct != mp->m_sb.sb_imax_pct) {
> +		error = xfs_growfs_imaxpct(mp, in->imaxpct);
> +		if (error)
> +			goto out_error;
> +	}
> +
>  	error = xfs_growfs_data_private(mp, in);
> +	if (error)
> +		goto out_error;

The 'xfs_growfs -m <maxpct>' use case typically doesn't involve a size
change. With this change, there's no reason to run through
xfs_growfs_data_private() if in.newblocks == mp->m_sb.sb_dblocks, right?
Otherwise this seems fine.

Brian

> +
> +	/*
> +	 * Post growfs calculations needed to reflect new state in operations
> +	 */
> +	if (mp->m_sb.sb_imax_pct) {
> +		uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
> +		do_div(icount, 100);
> +		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
> +	} else
> +		mp->m_maxicount = 0;
> +
> +out_error:
>  	/*
>  	 * Increment the generation unconditionally, the error could be from
>  	 * updating the secondary superblocks, in which case the new size
> -- 
> 2.15.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
