Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48926 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753119AbeGDAzL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:55:11 -0400
Date: Tue, 3 Jul 2018 17:54:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 21/25] xfs: replace no-op firstblock init with
 ->t_firstblock
Message-ID: <20180704005457.GU32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-22-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-22-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:23:15PM -0400, Brian Foster wrote:
> xfs_refcount_recover_cow_leftovers() has no need for a firstblock
> variable and so passes an unrelated xfs_fsblock_t to
> xfs_defer_init() to avoid declaring one. Replace this no-op
> initialization with ->t_firstblock. This will be optimized away by
> the removal of the xfs_defer_init() firstblock param.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_refcount.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 8dc380574cd8..d81c17aac710 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1691,7 +1691,7 @@ xfs_refcount_recover_cow_leftovers(
>  		trace_xfs_refcount_recover_extent(mp, agno, &rr->rr_rrec);
>  
>  		/* Free the orphan record */
> -		xfs_defer_init(tp, &dfops, &fsb);
> +		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
>  		fsb = XFS_AGB_TO_FSB(mp, agno, agbno);
>  		error = xfs_refcount_free_cow_extent(mp, tp->t_dfops, fsb,
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
