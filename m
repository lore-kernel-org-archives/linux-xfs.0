Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:2881 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756604AbcLOWQv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 17:16:51 -0500
Date: Fri, 16 Dec 2016 09:09:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: fix bogus minleft manipulations
Message-ID: <20161215220938.GV4219@dastard>
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
....

The xfs_alloc_vextent() loop changes look fine. The minleft hacks
always troubled me.

> ---
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 2760bc3..44773c9 100644
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

But this looks wrong. when combined with the next patch that sets:

	args.minleft = xfs_bmap_worst_indlen(ap->ip, args.maxlen);

we've got a minleft value that might be for multigigabyte
allocation, but now we are only asking for a total allocation
of minlen, and that might be 1 block. IOWs, shouldn't this "last,
final attempt" code actually do something like this:

		args.maxlen = ap->minlen;
		args.total = ap->minlen;
		args.minleft = xfs_bmap_worst_indlen(ap->ip, args.maxlen);

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
>  	if (args.fsbno == NULLFSBLOCK) {
>  		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
>  		*stat = 0;

Yes, that's fair enough considering the common in the block that
set args.minleft, and that was a bug fix introduced long after this
fallback was put in place because the fallback could still fail...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
