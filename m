Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44318 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752568AbeAZTGi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Jan 2018 14:06:38 -0500
Date: Fri, 26 Jan 2018 14:06:36 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/6] xfs: refactor accounting updates out of
 xfs_bmap_btalloc
Message-ID: <20180126190636.GA26910@bfoster.bfoster>
References: <151693228803.7395.12526880865470882359.stgit@magnolia>
 <151693229417.7395.1737479240326881862.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151693229417.7395.1737479240326881862.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 25, 2018 at 06:04:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move all the inode and quota accounting updates out of xfs_bmap_btalloc
> in preparation for fixing some quota accounting problems with copy on
> write.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Modulo Christoph's comments:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c |   34 +++++++++++++++++++++-------------
>  1 file changed, 21 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 0c9c9cd..6ad79ea 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3337,6 +3337,26 @@ xfs_bmap_btalloc_filestreams(
>  	return 0;
>  }
>  
> +/* Update all inode and quota accounting for the allocation we just did. */
> +static void
> +xfs_bmap_btalloc_accounting(
> +	struct xfs_bmalloca	*ap,
> +	struct xfs_alloc_arg	*args)
> +{
> +	if (!(ap->flags & XFS_BMAPI_COWFORK))
> +		ap->ip->i_d.di_nblocks += args->len;
> +	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
> +	if (ap->wasdel)
> +		ap->ip->i_delayed_blks -= args->len;
> +	/*
> +	 * Adjust the disk quota also. This was reserved
> +	 * earlier.
> +	 */
> +	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
> +		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
> +		(long) args->len);
> +}
> +
>  STATIC int
>  xfs_bmap_btalloc(
>  	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> @@ -3571,19 +3591,7 @@ xfs_bmap_btalloc(
>  			*ap->firstblock = args.fsbno;
>  		ASSERT(nullfb || fb_agno <= args.agno);
>  		ap->length = args.len;
> -		if (!(ap->flags & XFS_BMAPI_COWFORK))
> -			ap->ip->i_d.di_nblocks += args.len;
> -		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
> -		if (ap->wasdel)
> -			ap->ip->i_delayed_blks -= args.len;
> -		/*
> -		 * Adjust the disk quota also. This was reserved
> -		 * earlier.
> -		 */
> -		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
> -			ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT :
> -					XFS_TRANS_DQ_BCOUNT,
> -			(long) args.len);
> +		xfs_bmap_btalloc_accounting(ap, &args);
>  	} else {
>  		ap->blkno = NULLFSBLOCK;
>  		ap->length = 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
