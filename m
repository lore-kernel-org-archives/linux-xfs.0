Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58046 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755308AbdDMSaJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 14:30:09 -0400
Date: Thu, 13 Apr 2017 14:30:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/10] xfs: remove an unsafe retry in xfs_bmbt_alloc_block
Message-ID: <20170413183006.GD25915@bfoster.bfoster>
References: <20170413080517.12564-1-hch@lst.de>
 <20170413080517.12564-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413080517.12564-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 10:05:11AM +0200, Christoph Hellwig wrote:
> We've already reserved all possible required blocks and checked
> they are avaible in the same AG.
> 

I'm not quite following why this retry is unsafe as noted in the patch
title.. do you mean "unnecessary?" AFAICT, the firstblock == NULLFSBLOCK
case means we can issue this first allocation from any AG. If no AG can
allocate a block while satisfying minleft, then we can still safely
allocate from any AG provided any subsequent allocations occur in
increasing AG order (i.e., by setting dop_low), right?

Also, if this is unnecessary, what exactly verifies that all of the
reserved blocks are available within the same AG?

This patch may ultimately be fine, but at minimum I think a bit more
context/explanation is needed in the commit log. A couple things that
give me pause are 1.) this is a context highly sensitive to allocation
failure and 2.) the minleft used in the initial allocation is based on
the transaction block reservation, which isn't exactly deterministic (so
can some future transaction now increase the likelihood of bmbt block
allocation failure because it decided to reserve too many extra
blocks?).

Brian

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap_btree.c | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 3e17ceda038c..ce41dd5fbb34 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -476,19 +476,6 @@ xfs_bmbt_alloc_block(
>  	if (error)
>  		goto error0;
>  
> -	if (args.fsbno == NULLFSBLOCK && args.minleft) {
> -		/*
> -		 * Could not find an AG with enough free space to satisfy
> -		 * a full btree split.  Try again and if
> -		 * successful activate the lowspace algorithm.
> -		 */
> -		args.fsbno = 0;
> -		args.type = XFS_ALLOCTYPE_FIRST_AG;
> -		error = xfs_alloc_vextent(&args);
> -		if (error)
> -			goto error0;
> -		cur->bc_private.b.dfops->dop_low = true;
> -	}
>  	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
>  		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
>  		*stat = 0;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
