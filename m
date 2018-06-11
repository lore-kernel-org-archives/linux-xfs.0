Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932842AbeFKMOl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jun 2018 08:14:41 -0400
Date: Mon, 11 Jun 2018 08:14:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: update incore per-AG inode count
Message-ID: <20180611121438.GA2812@bfoster>
References: <20180609022653.GS25007@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180609022653.GS25007@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Fri, Jun 08, 2018 at 07:26:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> For whatever reason we never actually update pagi_count (the in-core
> perag inode count) when we allocate or free inode chunks.  Online scrub
> is going to use it, so we need to fix the accounting.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Interesting, I guess it hasn't been a problem because the value is only
used in a particular mount scenario right after it is initialized from
disk. Anyways:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ialloc.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 3f551eb29157..a64f71b614cc 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -897,6 +897,7 @@ xfs_ialloc_ag_alloc(
>  	be32_add_cpu(&agi->agi_freecount, newlen);
>  	pag = xfs_perag_get(args.mp, agno);
>  	pag->pagi_freecount += newlen;
> +	pag->pagi_count += newlen;
>  	xfs_perag_put(pag);
>  	agi->agi_newino = cpu_to_be32(newino);
>  
> @@ -1991,6 +1992,7 @@ xfs_difree_inobt(
>  		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
>  		pag = xfs_perag_get(mp, agno);
>  		pag->pagi_freecount -= ilen - 1;
> +		pag->pagi_count -= ilen;
>  		xfs_perag_put(pag);
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
