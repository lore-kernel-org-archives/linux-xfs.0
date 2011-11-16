Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAGNFNdR234380 for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 17:15:23 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 751381D12F33
	for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 15:15:21 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	6BgETgrAdcFDAEPF for <xfs@oss.sgi.com>;
	Wed, 16 Nov 2011 15:15:21 -0800 (PST)
Date: Thu, 17 Nov 2011 10:15:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] [PATCH] xfs: fix attr2 vs large data fork assert
Message-ID: <20111116231517.GA7046@dastard>
References: <20111115201407.038216766@bombadil.infradead.org>
	<20111115201426.498870090@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111115201426.498870090@bombadil.infradead.org>
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

On Tue, Nov 15, 2011 at 03:14:08PM -0500, Christoph Hellwig wrote:
> With Dmitry fsstress updates I've seen very reproducible crashes in
> xfs_attr_shortform_remove because xfs_attr_shortform_bytesfit claims that
> the attributes would not fit inline into the inode after removing an
> attribute.  It turns out that we were operating on an inode with lots
> of delalloc extents, and thus an if_bytes values for the data fork that
> is larger than biggest possible on-disk storage for it which utterly
> confuses the code near the end of xfs_attr_shortform_bytesfit.

We have a test that stresses allocated extents vs attributes in the
xfs_fsr swapext test (227), but that does not take into account
delalloc extents. It sounds like it would be relatively easy to
write a regression test for this particular case - create a file
with a bunch of attributes, then create a number of delalloc data
extents, then remove the attributes to trigger the condition in
xfs_attr_shortform_remove()....


> Fix this by always allowing the current attribute fork, like we already
> do for the attr1 format, given that delalloc conversion will take care
> for moving either the data or attribute area out of line if it doesn't
> fit at that point - or making the point moot by merging extents at this
> point.
> 
> Also document the function better, and clean up some lose bits.

While you are touching that function, can you fix all the whitespace
damage as well? (lots of trailing whitespace). There's a couple of
typos I noticed in your changes (below), but otherwise looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/xfs/xfs_attr_leaf.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_attr_leaf.c	2011-11-04 13:46:59.481655134 +0100
> +++ linux-2.6/fs/xfs/xfs_attr_leaf.c	2011-11-04 15:58:06.480155275 +0100
> @@ -110,6 +110,7 @@ xfs_attr_namesp_match(int arg_flags, int
>  /*
>   * Query whether the requested number of additional bytes of extended
>   * attribute space will be able to fit inline.
> + *
>   * Returns zero if not, else the di_forkoff fork offset to be used in the
>   * literal area for attribute data once the new bytes have been added.
>   *
> @@ -136,11 +137,26 @@ xfs_attr_shortform_bytesfit(xfs_inode_t
>  		return (offset >= minforkoff) ? minforkoff : 0;
>  	}
>  
> -	if (!(mp->m_flags & XFS_MOUNT_ATTR2)) {
> -		if (bytes <= XFS_IFORK_ASIZE(dp))
> -			return dp->i_d.di_forkoff;
> +	/*
> +	 * If the requested numbers of bytes is smaller or equal to the
> +	 * current attribute fork size we can always proceed.
> +	 *
> +	 * Note that if_bytes in the data fork might actually be larger than
> +	 * the current data fork size is due to delalloc extents. In that
> +	 * case either the extent count will go down when they are converted
> +	 * to ral extents, or the delalloc conversion will take care of the

              real

> +	 * literal area rebalancing.
> +	 */
> +	if (bytes <= XFS_IFORK_ASIZE(dp))
> +		return dp->i_d.di_forkoff;
> +
> +	/*
> +	 * For attr2 we can try to move the forkoff if there is space in the
> +	 * literal area, but for the old format we are done if there is no
> +	 * space in the fixes attribute fork.
> +	 */
> +	if (!(mp->m_flags & XFS_MOUNT_ATTR2))
>  		return 0;
> -	}
>  
>  	dsize = dp->i_df.if_bytes;
>  	
> @@ -157,10 +173,9 @@ xfs_attr_shortform_bytesfit(xfs_inode_t
>  		    xfs_default_attroffset(dp))
>  			dsize = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
>  		break;
> -		
>  	case XFS_DINODE_FMT_BTREE:
>  		/*
> -		 * If have data btree then keep forkoff if we have one,
> +		 * If have a data btree then keep forkoff if we have one,

	           If we have

>  		 * otherwise we are adding a new attr, so then we set 
>  		 * minforkoff to where the btree root can finish so we have 
>  		 * plenty of room for attrs
> @@ -168,10 +183,9 @@ xfs_attr_shortform_bytesfit(xfs_inode_t
>  		if (dp->i_d.di_forkoff) {
>  			if (offset < dp->i_d.di_forkoff) 
>  				return 0;
> -			else 
> -				return dp->i_d.di_forkoff;
> -		} else
> -			dsize = XFS_BMAP_BROOT_SPACE(dp->i_df.if_broot);
> +			return dp->i_d.di_forkoff;
> +		}
> +		dsize = XFS_BMAP_BROOT_SPACE(dp->i_df.if_broot);
>  		break;
>  	}
>  	
> @@ -186,10 +200,10 @@ xfs_attr_shortform_bytesfit(xfs_inode_t
>  	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
>  	maxforkoff = maxforkoff >> 3;	/* rounded down */
>  
> -	if (offset >= minforkoff && offset < maxforkoff)
> -		return offset;
>  	if (offset >= maxforkoff)
>  		return maxforkoff;
> +	if (offset >= minforkoff)
> +		return offset;
>  	return 0;
>  }
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
