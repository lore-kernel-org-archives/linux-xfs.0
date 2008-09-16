Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 22:52:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G5qGKY006349
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:52:16 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C0BF445C77
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:53:47 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id N5kk8BjX2ZEnjgiL for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:53:47 -0700 (PDT)
Date: Tue, 16 Sep 2008 15:53:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] cleanup btree record / key / ptr addressing macros
Message-ID: <20080916055333.GW5811@disturbed>
References: <20080915004653.GE12213@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915004653.GE12213@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Sep 15, 2008 at 02:46:53AM +0200, Christoph Hellwig wrote:
> Replace the generic record / key / ptr addressing macros that use cpp token
> pasting with simpler macros that do the job for just one given btree type.
> The new macros lose the cur argument and thus can be used outside the core
> btree code, but also gain an xfs_mount * argument to allow for checking the
> CRC flag in the near future.  Note that many of these macros aren't actually
> used in the kernel code, but only in userspace (mostly in xfs_repair).
......
> @@ -85,9 +84,9 @@ xfs_bmdr_to_bmbt(
>  	rblock->bb_leftsib = cpu_to_be64(NULLDFSBNO);
>  	rblock->bb_rightsib = cpu_to_be64(NULLDFSBNO);
>  	dmxr = xfs_bmdr_maxrecs(mp, dblocklen, 0);
> -	fkp = XFS_BTREE_KEY_ADDR(xfs_bmdr, dblock, 1);
> -	tkp = XFS_BMAP_BROOT_KEY_ADDR(rblock, 1, rblocklen);
> -	fpp = XFS_BTREE_PTR_ADDR(xfs_bmdr, dblock, 1, dmxr);
> +	fkp = XFS_BMDR_KEY_ADDR(dblock, 1);
> +	tkp = XFS_BMBT_KEY_ADDR(mp, rblock, 1);
> +	fpp = XFS_BMDR_PTR_ADDR(dblock, 1, dmxr);
>  	tpp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, rblocklen);

Why did you change XFS_BMAP_BROOT_KEY_ADDR and not
XFS_BMAP_BROOT_PTR_ADDR?

>  	dmxr = be16_to_cpu(dblock->bb_numrecs);
>  	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
> @@ -448,10 +447,10 @@ xfs_bmbt_to_bmdr(
>  	dblock->bb_level = rblock->bb_level;
>  	dblock->bb_numrecs = rblock->bb_numrecs;
>  	dmxr = xfs_bmdr_maxrecs(mp, dblocklen, 0);
> -	fkp = XFS_BMAP_BROOT_KEY_ADDR(rblock, 1, rblocklen);
> -	tkp = XFS_BTREE_KEY_ADDR(xfs_bmdr, dblock, 1);
> -	fpp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, rblocklen);
> -	tpp = XFS_BTREE_PTR_ADDR(xfs_bmdr, dblock, 1, dmxr);
> +	fkp = XFS_BMBT_KEY_ADDR(mp, rblock, 1);
> +	tkp = XFS_BMDR_KEY_ADDR(dblock, 1);
> +  	fpp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, rblocklen);
   ^^

Stray whitespace.

> @@ -79,15 +79,24 @@ typedef	struct xfs_btree_sblock xfs_allo
>  /*
>   * Record, key, and pointer address macros for btree blocks.
>   */
> -#define	XFS_ALLOC_REC_ADDR(bb,i,cur)	\
> -	XFS_BTREE_REC_ADDR(xfs_alloc, bb, i)
> +#define XFS_ALLOC_REC_ADDR(mp, block, index) \
> +	((xfs_alloc_rec_t *) \
> +		((char *)(block) + \
> +		 sizeof(struct xfs_btree_sblock) + \
> +		 (((index) - 1) * sizeof(xfs_alloc_rec_t))))

Shouldn't these become inline functions rather than macros now
that the token substitution is gone? Same for rest as well?
That would remove a bunch of shouting that you're changing
anyway....

> -
> -		if (root) {
> -			keyp = XFS_BMAP_BROOT_KEY_ADDR(block, i, sz);
> -		} else {
> -			keyp = XFS_BTREE_KEY_ADDR(xfs_bmbt, block, i);
> -		}
> +		keyp = XFS_BMBT_KEY_ADDR(mp, block, i);
>  
>  		if (prevp) {
>  			ASSERT(be64_to_cpu(prevp->br_startoff) <
> @@ -6203,19 +6200,16 @@ xfs_check_block(
>  		/*
>  		 * Compare the block numbers to see if there are dups.
>  		 */
> -
> -		if (root) {
> +		if (root)
>  			pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, i, sz);
> -		} else {
> -			pp = XFS_BTREE_PTR_ADDR(xfs_bmbt, block, i, dmxr);
> -		}
> +		else
> +			pp = XFS_BMBT_PTR_ADDR(mp, block, i, dmxr);

Why the assymetry in the interfaces for key and ptr?

> -#define XFS_BMAP_BROOT_REC_ADDR(bb,i,sz) \
> -	(XFS_BTREE_REC_ADDR(xfs_bmbt,bb,i))
> -#define XFS_BMAP_BROOT_KEY_ADDR(bb,i,sz) \
> -	(XFS_BTREE_KEY_ADDR(xfs_bmbt,bb,i))
> -#define XFS_BMAP_BROOT_PTR_ADDR(mp, bb,i,sz) \
> -	(XFS_BTREE_PTR_ADDR(xfs_bmbt,bb,i,xfs_bmbt_maxrecs(mp, sz, 0)))
> +#define XFS_BMAP_BROOT_PTR_ADDR(mp, bb, i, sz) \
> +	XFS_BMBT_PTR_ADDR(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, 0))

Ah, that explains why that macro didn't change. Why keep just this
one?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
