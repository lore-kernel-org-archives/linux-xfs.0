Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38398 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752639AbdDQOTp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Apr 2017 10:19:45 -0400
Date: Mon, 17 Apr 2017 10:19:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/10] xfs: fix space reservation in xfs_bmbt_alloc_block
Message-ID: <20170417141943.GE41659@bfoster.bfoster>
References: <20170413080517.12564-1-hch@lst.de>
 <20170413080517.12564-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413080517.12564-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 10:05:14AM +0200, Christoph Hellwig wrote:
> minleft counts the number of blocks that need to be available after the
> current allocation has been completed.  As the total allocation should not
> be more than the transaction reservation we need to subtract the
> allocation length.  In addition we need to subtract the already used
> transaction reservation, for that use the new xfs_trans_blk_res helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap_btree.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index ce41dd5fbb34..153c969febd4 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -442,6 +442,7 @@ xfs_bmbt_alloc_block(
>  	args.mp = cur->bc_mp;
>  	args.fsbno = cur->bc_private.b.firstblock;
>  	args.firstblock = args.fsbno;
> +	args.minlen = args.maxlen = args.prod = 1;
>  	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_private.b.ip->i_ino,
>  			cur->bc_private.b.whichfork);
>  
> @@ -459,14 +460,14 @@ xfs_bmbt_alloc_block(
>  		 * reservation amount is insufficient then we may fail a
>  		 * block allocation here and corrupt the filesystem.
>  		 */
> -		args.minleft = args.tp->t_blk_res;
> +		if (xfs_trans_blk_res(args.tp))
> +			args.minleft = xfs_trans_blk_res(args.tp) - args.maxlen;
>  	} else if (cur->bc_private.b.dfops->dop_low) {
>  		args.type = XFS_ALLOCTYPE_START_BNO;
>  	} else {
>  		args.type = XFS_ALLOCTYPE_NEAR_BNO;
>  	}
>  
> -	args.minlen = args.maxlen = args.prod = 1;
>  	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
>  	if (!args.wasdel && args.tp->t_blk_res == 0) {
>  		error = -ENOSPC;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
