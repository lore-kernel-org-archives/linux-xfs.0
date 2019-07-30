Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35456 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729908AbfG3Old (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 10:41:33 -0400
Date: Tue, 30 Jul 2019 07:41:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] fs: xfs: Fix possible null-pointer dereferences in
 xchk_da_btree_block_check_sibling()
Message-ID: <20190730144122.GP1561054@magnolia>
References: <20190730023206.14587-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730023206.14587-1-baijiaju1990@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: bfoster@redhat.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jul 30, 2019 at 10:32:06AM +0800, Jia-Ju Bai wrote:
> In xchk_da_btree_block_check_sibling(), there is an if statement on
> line 274 to check whether ds->state->altpath.blk[level].bp is NULL:
>     if (ds->state->altpath.blk[level].bp)
> 
> When ds->state->altpath.blk[level].bp is NULL, it is used on line 281:
>     xfs_trans_brelse(..., ds->state->altpath.blk[level].bp);
>         struct xfs_buf_log_item *bip = bp->b_log_item;
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

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> v2:
> * Adjust the code and add an assignment. 
>   Thank Darrick J. Wong for helpful advice. 
> 
> ---
>  fs/xfs/scrub/dabtree.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 94c4f1de1922..77ff9f97bcda 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -278,7 +278,11 @@ xchk_da_btree_block_check_sibling(
>  	/* Compare upper level pointer to sibling pointer. */
>  	if (ds->state->altpath.blk[level].blkno != sibling)
>  		xchk_da_set_corrupt(ds, level);
> -	xfs_trans_brelse(ds->dargs.trans, ds->state->altpath.blk[level].bp);
> +	if (ds->state->altpath.blk[level].bp) {
> +		xfs_trans_brelse(ds->dargs.trans,
> +				ds->state->altpath.blk[level].bp);
> +		ds->state->altpath.blk[level].bp = NULL;
> +	}
>  out:
>  	return error;
>  }
> -- 
> 2.17.0
> 
