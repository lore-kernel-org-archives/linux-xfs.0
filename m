Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753702AbdADSTe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Jan 2017 13:19:34 -0500
Date: Wed, 4 Jan 2017 13:19:33 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/5] xfs: fix bogus minleft manipulations
Message-ID: <20170104181933.GC41989@bfoster.bfoster>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
 <1482436822-31546-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482436822-31546-4-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Thu, Dec 22, 2016 at 09:00:20PM +0100, Christoph Hellwig wrote:
> We can't just set minleft to 0 when we're low on space - that's exactly
> what we need minleft for: to protect space in the AG for btree block
> allocations when we are low on free space.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Staring at this some more, I'm still not terribly fond of this, moreso
because I wonder how much more of this can be ripped out and whether the
low space allocator thing is still effective. Aside from that, afaict
the set_aside change should make it robust and addresses my previous
question in that it holds blocks out of all transaction reservations.

I'm also curious whether the set_aside patch alone addresses the
original problem, or setting minleft = 0 in one of these cases was
actually the cause.

>  fs/xfs/libxfs/xfs_alloc.c      | 24 +++++++-----------------
>  fs/xfs/libxfs/xfs_bmap.c       |  3 ---
>  fs/xfs/libxfs/xfs_bmap_btree.c | 14 --------------
>  3 files changed, 7 insertions(+), 34 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 19c05e9..62663a2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3812,7 +3812,6 @@ xfs_bmap_btalloc(
>  		args.fsbno = 0;
>  		args.type = XFS_ALLOCTYPE_FIRST_AG;
>  		args.total = ap->minlen;
> -		args.minleft = 0;
>  		if ((error = xfs_alloc_vextent(&args)))
>  			return error;
>  		ap->dfops->dop_low = true;
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

We have a similar retry pattern in xfs_bmap_btalloc() where, in the hunk
just above, we retain the retry that appears analogous to this one (in
that it activates the low space algo) and just drop the minleft = 0 bit.
Here we are dropping the whole thing. Any reason not to be consistent
one way or the other? (Though do note that we don't check firstblock
here...).

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
