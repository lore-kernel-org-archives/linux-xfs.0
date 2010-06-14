Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5E8SGPS033059 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 03:28:16 -0500
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3315812ACB43
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 01:34:17 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com
	with ESMTP id Et8tRsYDRzhVxNgt for <xfs@oss.sgi.com>;
	Mon, 14 Jun 2010 01:34:17 -0700 (PDT)
Date: Mon, 14 Jun 2010 10:30:21 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] XFS: Fix gcc 4.6 set but not read and unused statement
	warnings v2
Message-ID: <20100614083021.GA29354@lst.de>
References: <20100614081356.GA27499@basil.fritz.box>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100614081356.GA27499@basil.fritz.box>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: ak@linux.intel.com, hch@lst.de, dgc@fromorbit.com, xfs@oss.sgi.com

On Mon, Jun 14, 2010 at 10:13:56AM +0200, Andi Kleen wrote:
> -	/* REFERENCED */
> -	xfs_da_blkinfo_t *blkinfo;
>  	xfs_da_args_t *args;
>  	xfs_dablk_t child;
>  	xfs_dabuf_t *bp;
> @@ -742,15 +738,14 @@ xfs_da_root_join(xfs_da_state_t *state,
>  	if (error)
>  		return(error);
>  	ASSERT(bp != NULL);
> -	blkinfo = bp->data;
>  	if (be16_to_cpu(oldroot->hdr.level) == 1) {
> -		ASSERT(be16_to_cpu(blkinfo->magic) == XFS_DIR2_LEAFN_MAGIC ||
> -		       be16_to_cpu(blkinfo->magic) == XFS_ATTR_LEAF_MAGIC);
> +		ASSERT(be16_to_cpu(bp->data->magic) == XFS_DIR2_LEAFN_MAGIC ||
> +		       be16_to_cpu(bp->data->magic) == XFS_ATTR_LEAF_MAGIC);
>  	} else {
> -		ASSERT(be16_to_cpu(blkinfo->magic) == XFS_DA_NODE_MAGIC);
> +		ASSERT(be16_to_cpu(bp->data->magic) == XFS_DA_NODE_MAGIC);

How can this work?  bp->data is a void pointer.

> @@ -174,7 +173,6 @@ _xfs_filestream_pick_ag(
>  		/* Keep track of the AG with the most free blocks. */
>  		if (pag->pagf_freeblks > maxfree) {
>  			maxfree = pag->pagf_freeblks;
> -			max_streams = atomic_read(&pag->pagf_fstrms);
>  			max_ag = ag;
>  		}
>  
> @@ -196,8 +194,6 @@ _xfs_filestream_pick_ag(
>  		     (flags & XFS_PICK_LOWSPACE))) {
>  
>  			/* Break out, retaining the reference on the AG. */
> -			free = pag->pagf_freeblks;
> -			streams = atomic_read(&pag->pagf_fstrms);

These are used by the tracing code not yet converted to the new tracing
infrastructure.  I think I'll prefer to just add the new tracing code
ASAP to make the warnings go away.

>  			break;
>  		}
> @@ -364,7 +358,8 @@ xfs_fstrm_free_func(
>  	/* Drop the reference taken on the AG when the item was added. */
>  	ref = xfs_filestream_put_ag(ip->i_mount, item->ag);
>  
> -	ASSERT(ref >= 0);
> +	if (ref < 0)
> +		ASSERT(0);

We never use the return value of xfs_filestream_put_ag, so we an just
make it return void (and move it to xfs_filestreams.c while at it).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
