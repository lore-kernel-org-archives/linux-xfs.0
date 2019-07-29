Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53078 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfG2EUw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jul 2019 00:20:52 -0400
Date: Sun, 28 Jul 2019 21:20:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs: xfs: Fix possible null-pointer dereferences in
 xchk_da_btree_block_check_sibling()
Message-ID: <20190729042034.GM1561054@magnolia>
References: <20190729032401.28081-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729032401.28081-1-baijiaju1990@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: bfoster@redhat.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jul 29, 2019 at 11:24:01AM +0800, Jia-Ju Bai wrote:
> In xchk_da_btree_block_check_sibling(), there is an if statement on 
> line 274 to check whether ds->state->altpath.blk[level].bp is NULL:
>     if (ds->state->altpath.blk[level].bp)
> 
> When ds->state->altpath.blk[level].bp is NULL, it is used on line 281: 
>     xfs_trans_brelse(..., ds->state->altpath.blk[level].bp);
>         struct xfs_buf_log_item	*bip = bp->b_log_item;
>         ASSERT(bp->b_transp == tp);
> 
> Thus, possible null-pointer dereferences may occur.
> 
> To fix these bugs, ds->state->altpath.blk[level].bp is checked before
> being used.
> 
> These bugs are found by a static analysis tool STCheck written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  fs/xfs/scrub/dabtree.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 94c4f1de1922..33ff90c0dd70 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -278,7 +278,9 @@ xchk_da_btree_block_check_sibling(
>  	/* Compare upper level pointer to sibling pointer. */
>  	if (ds->state->altpath.blk[level].blkno != sibling)
>  		xchk_da_set_corrupt(ds, level);
> -	xfs_trans_brelse(ds->dargs.trans, ds->state->altpath.blk[level].bp);
> +	if (ds->state->altpath.blk[level].bp)
> +		xfs_trans_brelse(ds->dargs.trans, 
> +						ds->state->altpath.blk[level].bp);

Indentation here (in xfs we use two spaces)

Also, uh, shouldn't we set ds->state->altpath.blk[level].bp to NULL
since we've released the buffer?

--D

>  out:
>  	return error;
>  }
> -- 
> 2.17.0
> 
