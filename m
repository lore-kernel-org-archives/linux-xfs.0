Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758036AbdJMNY3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Oct 2017 09:24:29 -0400
Date: Fri, 13 Oct 2017 09:24:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: move two more RT specific functions into
 CONFIG_XFS_RT
Message-ID: <20171013132427.GC44461@bfoster.bfoster>
References: <20171013120603.4135344-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013120603.4135344-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>, Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org

On Fri, Oct 13, 2017 at 02:05:40PM +0200, Arnd Bergmann wrote:
> The last cleanup introduced two harmless warnings:
> 
> fs/xfs/xfs_fsmap.c:480:1: warning: '__xfs_getfsmap_rtdev' defined but not used
> fs/xfs/xfs_fsmap.c:372:1: warning: 'xfs_getfsmap_rtdev_rtbitmap_helper' defined but not used
> 
> This moves those two functions as well.
> 
> Fixes: bb9c2e543325 ("xfs: move more RT specific code under CONFIG_XFS_RT")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

I don't reproduce the warning, but the patch looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_fsmap.c | 48 ++++++++++++++++++++++++------------------------
>  1 file changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 560e0b40ac1b..43cfc07996a4 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -367,29 +367,6 @@ xfs_getfsmap_datadev_helper(
>  	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
>  }
>  
> -/* Transform a rtbitmap "record" into a fsmap */
> -STATIC int
> -xfs_getfsmap_rtdev_rtbitmap_helper(
> -	struct xfs_trans		*tp,
> -	struct xfs_rtalloc_rec		*rec,
> -	void				*priv)
> -{
> -	struct xfs_mount		*mp = tp->t_mountp;
> -	struct xfs_getfsmap_info	*info = priv;
> -	struct xfs_rmap_irec		irec;
> -	xfs_daddr_t			rec_daddr;
> -
> -	rec_daddr = XFS_FSB_TO_BB(mp, rec->ar_startblock);
> -
> -	irec.rm_startblock = rec->ar_startblock;
> -	irec.rm_blockcount = rec->ar_blockcount;
> -	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
> -	irec.rm_offset = 0;
> -	irec.rm_flags = 0;
> -
> -	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr);
> -}
> -
>  /* Transform a bnobt irec into a fsmap */
>  STATIC int
>  xfs_getfsmap_datadev_bnobt_helper(
> @@ -475,6 +452,30 @@ xfs_getfsmap_logdev(
>  	return xfs_getfsmap_helper(tp, info, &rmap, 0);
>  }
>  
> +#ifdef CONFIG_XFS_RT
> +/* Transform a rtbitmap "record" into a fsmap */
> +STATIC int
> +xfs_getfsmap_rtdev_rtbitmap_helper(
> +	struct xfs_trans		*tp,
> +	struct xfs_rtalloc_rec		*rec,
> +	void				*priv)
> +{
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_getfsmap_info	*info = priv;
> +	struct xfs_rmap_irec		irec;
> +	xfs_daddr_t			rec_daddr;
> +
> +	rec_daddr = XFS_FSB_TO_BB(mp, rec->ar_startblock);
> +
> +	irec.rm_startblock = rec->ar_startblock;
> +	irec.rm_blockcount = rec->ar_blockcount;
> +	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
> +	irec.rm_offset = 0;
> +	irec.rm_flags = 0;
> +
> +	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr);
> +}
> +
>  /* Execute a getfsmap query against the realtime device. */
>  STATIC int
>  __xfs_getfsmap_rtdev(
> @@ -521,7 +522,6 @@ __xfs_getfsmap_rtdev(
>  	return query_fn(tp, info);
>  }
>  
> -#ifdef CONFIG_XFS_RT
>  /* Actually query the realtime bitmap. */
>  STATIC int
>  xfs_getfsmap_rtdev_rtbitmap_query(
> -- 
> 2.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
