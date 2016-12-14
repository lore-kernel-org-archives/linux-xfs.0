Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753436AbcLNRfl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Dec 2016 12:35:41 -0500
Date: Wed, 14 Dec 2016 12:35:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] xfs: fix bogus minleft manipulations
Message-ID: <20161214173507.GA24645@bfoster.bfoster>
References: <1481644767-9098-1-git-send-email-hch@lst.de>
 <1481644767-9098-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481644767-9098-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Tue, Dec 13, 2016 at 04:59:24PM +0100, Christoph Hellwig wrote:
> We can't just set minleft to 0 when we're low on space - that's exactly
> what we need minleft for: to protect space in the AG for btree block
> allocations when we are low on free space.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_alloc.c      | 24 +++++++-----------------
>  fs/xfs/libxfs/xfs_bmap.c       |  3 ---
>  fs/xfs/libxfs/xfs_bmap_btree.c | 14 --------------
>  3 files changed, 7 insertions(+), 34 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index d6330c2..9581ee8 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -499,20 +499,6 @@ xfs_bmbt_alloc_block(
>  		goto try_another_ag;
>  	}
>  
> -	if (args.fsbno == NULLFSBLOCK && args.minleft) {
> -		/*
> -		 * Could not find an AG with enough free space to satisfy
> -		 * a full btree split.  Try again without minleft and if
> -		 * successful activate the lowspace algorithm.
> -		 */
> -		args.fsbno = 0;
> -		args.type = XFS_ALLOCTYPE_FIRST_AG;
> -		args.minleft = 0;
> -		error = xfs_alloc_vextent(&args);
> -		if (error)
> -			goto error0;
> -		cur->bc_private.b.dfops->dop_low = true;
> -	}

I'm still trying to grok the minleft/dop_low stuff, but doesn't this
increase the risk of bmbt block allocation failure? E.g., args.minleft
is set to the transaction reservation earlier in the function. AFAIK the
res is not guaranteed to be in a particular AG, but in that case we're
just setting a start AG and ultimately cycling through the AGs. If that
fails, this hunk resets minleft, restarts at fsbno 0 and activates the
sequential agno allocation requirement for subsequent allocs. Doesn't
removing this logic mean we can successfully reserve blocks in a write
transaction that will never ultimately be able to allocate bmbt blocks,
even if the data blocks can all be allocated..?

The other thing to note here is that minleft is initialized to 0 and
only set to the transaction res conditionally, so if firstblock is
already set we won't use minleft at all. It's definitely possible I'm
still missing something about how this was all "supposed" to work
originally, but the logic that's left here seems a bit... erratic. :/

Brian

>  	if (args.fsbno == NULLFSBLOCK) {
>  		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
>  		*stat = 0;
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
