Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBDM02nS175915 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 16:00:02 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EDCA156F242
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 14:00:00 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Eb5BSNeHqb99vQV6 for <xfs@oss.sgi.com>;
	Tue, 13 Dec 2011 14:00:00 -0800 (PST)
Date: Wed, 14 Dec 2011 08:59:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/11] xfs: remove the if_ext_max field in struct xfs_ifork
Message-ID: <20111213215958.GC3179@dastard>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155918.162879660@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111208155918.162879660@bombadil.infradead.org>
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

On Thu, Dec 08, 2011 at 10:57:59AM -0500, Christoph Hellwig wrote:
> We spent a lot of effort to maintain this field, but it always equalts to the
> fork size divided by the constant size of an extent.  The prime use of it is
> to assert that the two stay in sync.  Just divide the fork size by the extent
> size in the few places that we actually use it and remove the overhead
> of maintaining it.

Ok, so you are trading off the overhead of initialising once with
runtime overhead of a read, against a runtime overhead read and a
integer division. Some platforms have slow integer division, so at
face value this migh tbe a bit slower.

However, sizeof(struct xfs_bmbt_rec) == 16, which is determined at
compile time so the compiler can optimise that to a shift, which has
basically no overhead compared to a division on platforms where
division is slow.

>From taht perspective, this seems like a good tradeoff to make -
very little additional runtime overhead, much simpler code.

> Also introduce a few helpers to consolidate the places
> where we actually care about the value.

The helpers are a vast improvement.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Couple of small formatting comments below, but otherwise consider it

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> Index: xfs/fs/xfs/xfs_dfrag.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dfrag.c	2011-12-02 19:39:31.437161062 +0100
> +++ xfs/fs/xfs/xfs_dfrag.c	2011-12-07 11:17:02.342984256 +0100
> @@ -163,12 +163,14 @@ xfs_swap_extents_check_format(
>  
>  	/* Check temp in extent form to max in target */
>  	if (tip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
> -	    XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) > ip->i_df.if_ext_max)
> +	    XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) >
> +	    XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
>  		return EINVAL;

I'd indent the XFS_IFORK_MAXEXT() so it's obvious it's part of a
conditional and not a new conditional expression. Maybe something
like:

+	    XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) >
+			XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))

Otherwise it's not exactly obvious how the logic flows here.

>  
>  	/* Check target in extent form to max in temp */
>  	if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
> -	    XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) > tip->i_df.if_ext_max)
> +	    XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) >
> +	    XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
>  		return EINVAL;

Same here.

>  
>  	/*
> @@ -180,18 +182,25 @@ xfs_swap_extents_check_format(
>  	 * (a common defrag case) which will occur when the temp inode is in
>  	 * extent format...
>  	 */
> -	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
> -	    ((XFS_IFORK_BOFF(ip) &&
> -	      tip->i_df.if_broot_bytes > XFS_IFORK_BOFF(ip)) ||
> -	     XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) <= ip->i_df.if_ext_max))
> +	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
> +		if (XFS_IFORK_BOFF(ip) &&
> +		    tip->i_df.if_broot_bytes > XFS_IFORK_BOFF(ip))
> +			return EINVAL;
> +		if (XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) <=
> +		    XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
>  		return EINVAL;
                ^ needs another indent.
> +	}
>  
>  	/* Reciprocal target->temp btree format checks */
> -	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
> -	    ((XFS_IFORK_BOFF(tip) &&
> -	      ip->i_df.if_broot_bytes > XFS_IFORK_BOFF(tip)) ||
> -	     XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) <= tip->i_df.if_ext_max))
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
> +		if (XFS_IFORK_BOFF(tip) &&
> +		    ip->i_df.if_broot_bytes > XFS_IFORK_BOFF(tip))
> +			return EINVAL;
> +
> +		if (XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) <=
> +		    XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
>  		return EINVAL;

Same here.


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
