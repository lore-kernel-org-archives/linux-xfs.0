Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p663DcmH063022 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:13:38 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7F751BF6A64
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 20:13:34 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	TJ5ay48IC6byHhY0 for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 20:13:34 -0700 (PDT)
Date: Wed, 6 Jul 2011 13:13:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 21/27] xfs: cleanup struct xfs_dir2_leaf
Message-ID: <20110706031331.GP1026@dastard>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.567693269@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701094606.567693269@bombadil.infradead.org>
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

On Fri, Jul 01, 2011 at 05:43:42AM -0400, Christoph Hellwig wrote:
> Simplify the confusing xfs_dir2_leaf structure.  It is supposed to describe
> an XFS dir2 leaf format btree block, but due to the variable sized nature
> of almost all elements in it it can't actuall do anything close to that
> job.   Remove the members that are after the first variable sized array,
> given that they could only be used for sizeof expressions that can as well
> just use the underlying types directly, and make the ents array a real
> C99 variable sized array.
> 
> Also factor out the xfs_dir2_leaf_size, to make the sizing of a leaf
> entry which already was convoluted somewhat readable after using the
> longer type names in the sizeof expressions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> 
> Index: xfs/fs/xfs/xfs_dir2_leaf.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dir2_leaf.h	2011-06-30 09:18:07.263416117 +0200
> +++ xfs/fs/xfs/xfs_dir2_leaf.h	2011-06-30 09:38:44.723400763 +0200
> @@ -72,10 +72,7 @@ typedef struct xfs_dir2_leaf_tail {
>   */
>  typedef struct xfs_dir2_leaf {
>  	xfs_dir2_leaf_hdr_t	hdr;		/* leaf header */
> -	xfs_dir2_leaf_entry_t	ents[1];	/* entries */
> -						/* ... */
> -	xfs_dir2_data_off_t	bests[1];	/* best free counts */
> -	xfs_dir2_leaf_tail_t	tail;		/* leaf tail */
> +	xfs_dir2_leaf_entry_t	ents[];	/* entries */
>  } xfs_dir2_leaf_t;

This needs a coment describing the layout of the structure like
you've done with the other structures that have been cleaned up.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
