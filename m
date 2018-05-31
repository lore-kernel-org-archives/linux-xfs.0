Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53252 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755794AbeEaRQq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 13:16:46 -0400
Date: Thu, 31 May 2018 12:16:44 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 3/4] xfs: strengthen rtalloc query range checks
Message-ID: <20180531171644.GC25547@redhat.com>
References: <152778442467.6891.15278589749191666547.stgit@magnolia>
 <152778444301.6891.15337114742525069233.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152778444301.6891.15337114742525069233.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 31, 2018 at 09:34:03AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Strengthen the rtalloc range query checks to make sure that the keys do
> not run off the end of the realtime device inappropriately.  Note that
> the query range functions require units of rt extents, not blocks,
> despite the type name.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

looks fine.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 7712f282d172..1855182c11ec 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1038,8 +1038,11 @@ xfs_rtalloc_query_range(
>  
>  	if (low_rec->ar_startblock > high_rec->ar_startblock)
>  		return -EINVAL;
> -	else if (low_rec->ar_startblock == high_rec->ar_startblock)
> +	if (low_rec->ar_startblock >= mp->m_sb.sb_rextents ||
> +	    low_rec->ar_startblock == high_rec->ar_startblock)
>  		return 0;
> +	if (high_rec->ar_startblock >= mp->m_sb.sb_rextents)
> +		high_rec->ar_startblock = mp->m_sb.sb_rextents - 1;
>  
>  	/* Iterate the bitmap, looking for discrepancies. */
>  	rtstart = low_rec->ar_startblock;
> @@ -1083,7 +1086,7 @@ xfs_rtalloc_query_all(
>  	struct xfs_rtalloc_rec		keys[2];
>  
>  	keys[0].ar_startblock = 0;
> -	keys[1].ar_startblock = tp->t_mountp->m_sb.sb_rblocks;
> +	keys[1].ar_startblock = tp->t_mountp->m_sb.sb_rextents - 1;
>  	keys[0].ar_blockcount = keys[1].ar_blockcount = 0;
>  
>  	return xfs_rtalloc_query_range(tp, &keys[0], &keys[1], fn, priv);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
