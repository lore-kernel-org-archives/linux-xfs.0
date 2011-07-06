Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p662W2L1061628 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 21:32:02 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE85A1799998
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 19:31:59 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	RzPusTn45a7JV6k2 for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 19:31:59 -0700 (PDT)
Date: Wed, 6 Jul 2011 12:31:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/27] xfs: kill struct xfs_dir2_block
Message-ID: <20110706023157.GL1026@dastard>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094605.827598983@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701094605.827598983@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jul 01, 2011 at 05:43:38AM -0400, Christoph Hellwig wrote:
> Remove the confusing xfs_dir2_block structure.  It is supposed to describe
> an XFS dir2 block format btree block, but due to the variable sized nature
> of almost all elements in it it can't actuall do anything close to that
> job.  In addition to accessing the fixed offset header structure it was
> only used to get a pointer to the first dir or unused entry after it,
> which can be trivially replaced by pointer arithmetics on the header
> pointer.  For most users that is actually more natural anyway, as they
> don't use a typed pointer but rather a character pointer for further
> arithmetics.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> @@ -471,14 +470,13 @@ xfs_dir2_block_getdents(
>  	 * We'll skip entries before this.
>  	 */
>  	wantoff = xfs_dir2_dataptr_to_off(mp, *offset);
> -	block = bp->data;
> -	hdr = &block->hdr;
> +	hdr = bp->data;
>  	xfs_dir2_data_check(dp, bp);
>  	/*
>  	 * Set up values for the loop.
>  	 */
>  	btp = xfs_dir2_block_tail_p(mp, hdr);
> -	ptr = (char *)block->u;
> +	ptr = (char *)(hdr + 1);
>  	endptr = (char *)xfs_dir2_block_leaf_p(btp);

That is slightly less obvious what it is doing. It's jumping over
the entire header, but could easily be confused with jumping one
byte in.

Perhaps adding a wrapper e.g. xfs_dir2_block_data_p(hdr) to match
the xfs_dir2_block_tail_p() and xfs_dir2_block_leaf_p() wrappers,
and converting all the other cases to use this as well?

> @@ -1103,7 +1099,7 @@ xfs_dir2_sf_to_block(
>  	 * The whole thing is initialized to free by the init routine.
>  	 * Say we're using the leaf and tail area.
>  	 */
> -	dup = (xfs_dir2_data_unused_t *)block->u;
> +	dup = (xfs_dir2_data_unused_t *)(hdr + 1);

and maybe a xfs_dir2_block_unused_p() wrapper just to avoid the cast
here, though I'm not sure it's worth adding a wrapper just for this
one use.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
