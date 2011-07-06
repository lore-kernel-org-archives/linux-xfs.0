Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p663iZFK064082 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:44:35 -0500
Subject: Re: [PATCH 21/27] xfs: cleanup struct xfs_dir2_leaf
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094606.567693269@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.567693269@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 22:44:33 -0500
Message-ID: <1309923873.3381.42.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
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

One comment below, otherwise looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> Index: xfs/fs/xfs/xfs_dir2_leaf.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dir2_leaf.h	2011-06-30 09:18:07.263416117 +0200
> +++ xfs/fs/xfs/xfs_dir2_leaf.h	2011-06-30 09:38:44.723400763 +0200
> @@ -72,10 +72,7 @@ typedef struct xfs_dir2_leaf_tail {
>   */

A comment explaining the implied/variable-offset
fields is needed here.

>  typedef struct xfs_dir2_leaf {
>  	xfs_dir2_leaf_hdr_t	hdr;		/* leaf header */
> -	xfs_dir2_leaf_entry_t	ents[1];	/* entries */
> -						/* ... */
> -	xfs_dir2_data_off_t	bests[1];	/* best free counts */
> -	xfs_dir2_leaf_tail_t	tail;		/* leaf tail */
> +	xfs_dir2_leaf_entry_t	ents[];	/* entries */
>  } xfs_dir2_leaf_t;
>  
>  /*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
