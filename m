Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E39A7F53
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 09:17:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5923B304032
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 07:17:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gwGK1wv5T2rzgv70 for
	<xfs@oss.sgi.com>; Tue, 22 Apr 2014 07:17:52 -0700 (PDT)
Date: Tue, 22 Apr 2014 10:17:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: remote attribute overwrite causes transaction overrun
Message-ID: <20140422141743.GA55823@bfoster.bfoster>
References: <1398149949-11324-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398149949-11324-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 22, 2014 at 04:59:09PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit e461fcb ("xfs: remote attribute lookups require the value
> length") passes the remote attribute length in the xfs_da_args
> structure on lookup so that CRC calculations and validity checking
> can be performed correctly by related code. This, unfortunately has
> the side effect of changing the args->valuelen parameter in cases
> where it shouldn't.
> 
> That is, when we replace a remote attribute, the incoming
> replacement stores the value and length in args->value and
> args->valuelen, but then the lookup which finds the existing remote
> attribute overwrites args->valuelen with the length of the remote
> attribute being replaced. Hence when we go to create the new
> attribute, we create it of the size of the existing remote
> attribute, not the size it is supposed to be. When the new attribute
> is much smaller than the old attribute, this results in a
> transaction overrun and an ASSERT() failure on a debug kernel:
> 
> XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
> 
> Fix this by keeping the remote attribute value length separate to
> the attribute value length in the xfs_da_args structure. The enables
> us to pass the length of the remote attribute to be removed without
> overwriting the new attribute's length.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_attr.c        |  7 ++++++-
>  fs/xfs/xfs_attr_leaf.c   | 21 +++++++++++----------
>  fs/xfs/xfs_attr_remote.c | 11 ++++++++---
>  fs/xfs/xfs_da_btree.h    |  2 ++
>  4 files changed, 27 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
> index 01b6a01..dbaa674 100644
> --- a/fs/xfs/xfs_attr.c
> +++ b/fs/xfs/xfs_attr.c
> @@ -213,7 +213,7 @@ xfs_attr_calc_size(
>  		 * Out of line attribute, cannot double split, but
>  		 * make room for the attribute value itself.
>  		 */
> -		uint	dblocks = XFS_B_TO_FSB(mp, valuelen);
> +		uint	dblocks = xfs_attr3_rmt_blocks(mp, valuelen);
>  		nblks += dblocks;
>  		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
>  	}
> @@ -703,6 +703,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  		args->index2 = args->index;
>  		args->rmtblkno2 = args->rmtblkno;
>  		args->rmtblkcnt2 = args->rmtblkcnt;
> +		args->rmtvaluelen2 = args->rmtvaluelen;
>  	}

Why don't we zero out the first set of values here similar to the node
case?

>  
>  	/*
> @@ -794,6 +795,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  		args->blkno = args->blkno2;
>  		args->rmtblkno = args->rmtblkno2;
>  		args->rmtblkcnt = args->rmtblkcnt2;
> +		args->rmtvaluelen = args->rmtvaluelen2;
>  		if (args->rmtblkno) {
>  			error = xfs_attr_rmtval_remove(args);
>  			if (error)
> @@ -1004,8 +1006,10 @@ restart:
>  		args->index2 = args->index;
>  		args->rmtblkno2 = args->rmtblkno;
>  		args->rmtblkcnt2 = args->rmtblkcnt;
> +		args->rmtvaluelen2 = args->rmtvaluelen;
>  		args->rmtblkno = 0;
>  		args->rmtblkcnt = 0;
> +		args->rmtvaluelen = 0;
>  	}
>  
>  	retval = xfs_attr3_leaf_add(blk->bp, state->args);
> @@ -1133,6 +1137,7 @@ restart:
>  		args->blkno = args->blkno2;
>  		args->rmtblkno = args->rmtblkno2;
>  		args->rmtblkcnt = args->rmtblkcnt2;
> +		args->rmtvaluelen = args->rmtvaluelen2;
>  		if (args->rmtblkno) {
>  			error = xfs_attr_rmtval_remove(args);
>  			if (error)
> diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
> index fe9587f..511c283 100644
> --- a/fs/xfs/xfs_attr_leaf.c
> +++ b/fs/xfs/xfs_attr_leaf.c
> @@ -1229,6 +1229,7 @@ xfs_attr3_leaf_add_work(
>  		name_rmt->valueblk = 0;
>  		args->rmtblkno = 1;
>  		args->rmtblkcnt = xfs_attr3_rmt_blocks(mp, args->valuelen);
> +		args->rmtvaluelen = args->valuelen;
>  	}
>  	xfs_trans_log_buf(args->trans, bp,
>  	     XFS_DA_LOGRANGE(leaf, xfs_attr3_leaf_name(leaf, args->index),
> @@ -2167,11 +2168,11 @@ xfs_attr3_leaf_lookup_int(
>  			if (!xfs_attr_namesp_match(args->flags, entry->flags))
>  				continue;
>  			args->index = probe;
> -			args->valuelen = be32_to_cpu(name_rmt->valuelen);
> +			args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
>  			args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
>  			args->rmtblkcnt = xfs_attr3_rmt_blocks(
>  							args->dp->i_mount,
> -							args->valuelen);
> +							args->rmtvaluelen);
>  			return XFS_ERROR(EEXIST);
>  		}
>  	}
> @@ -2220,19 +2221,19 @@ xfs_attr3_leaf_getvalue(
>  		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
>  		ASSERT(name_rmt->namelen == args->namelen);
>  		ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
> -		valuelen = be32_to_cpu(name_rmt->valuelen);
> +		args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
>  		args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
>  		args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
> -						       valuelen);
> +						       args->rmtvaluelen);
>  		if (args->flags & ATTR_KERNOVAL) {
> -			args->valuelen = valuelen;
> +			args->valuelen = args->rmtvaluelen;
>  			return 0;
>  		}
> -		if (args->valuelen < valuelen) {
> -			args->valuelen = valuelen;
> +		if (args->valuelen < args->rmtvaluelen) {
> +			args->valuelen = args->rmtvaluelen;
>  			return XFS_ERROR(ERANGE);
>  		}
> -		args->valuelen = valuelen;
> +		args->valuelen = args->rmtvaluelen;
>  	}
>  	return 0;
>  }
> @@ -2519,7 +2520,7 @@ xfs_attr3_leaf_clearflag(
>  		ASSERT((entry->flags & XFS_ATTR_LOCAL) == 0);
>  		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
>  		name_rmt->valueblk = cpu_to_be32(args->rmtblkno);
> -		name_rmt->valuelen = cpu_to_be32(args->valuelen);
> +		name_rmt->valuelen = cpu_to_be32(args->rmtvaluelen);
>  		xfs_trans_log_buf(args->trans, bp,
>  			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
>  	}
> @@ -2677,7 +2678,7 @@ xfs_attr3_leaf_flipflags(
>  		ASSERT((entry1->flags & XFS_ATTR_LOCAL) == 0);
>  		name_rmt = xfs_attr3_leaf_name_remote(leaf1, args->index);
>  		name_rmt->valueblk = cpu_to_be32(args->rmtblkno);
> -		name_rmt->valuelen = cpu_to_be32(args->valuelen);
> +		name_rmt->valuelen = cpu_to_be32(args->rmtvaluelen);
>  		xfs_trans_log_buf(args->trans, bp1,
>  			 XFS_DA_LOGRANGE(leaf1, name_rmt, sizeof(*name_rmt)));
>  	}
> diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> index 6e37823..2324c66 100644
> --- a/fs/xfs/xfs_attr_remote.c
> +++ b/fs/xfs/xfs_attr_remote.c
> @@ -337,7 +337,7 @@ xfs_attr_rmtval_get(
>  	struct xfs_buf		*bp;
>  	xfs_dablk_t		lblkno = args->rmtblkno;
>  	__uint8_t		*dst = args->value;
> -	int			valuelen = args->valuelen;
> +	int			valuelen;
>  	int			nmap;
>  	int			error;
>  	int			blkcnt = args->rmtblkcnt;
> @@ -348,6 +348,11 @@ xfs_attr_rmtval_get(
>  
>  	ASSERT(!(args->flags & ATTR_KERNOVAL));
>  
> +	/* remote value might be different size to the buffer supplied. */
> +	if (args->rmtvaluelen = args->valuelen)
> +		args->valuelen = args->rmtvaluelen;
> +	valuelen = args->valuelen;
> +

Jeff already called this out as a potential typo...

I'm guessing the intent is to handle the case where we call from
xfs_attr3_leaf_list_int(). The other callers call
xfs_attr3_leaf_getvalue() first, which sets rmtvaluelen and fixes up
valuelen or returns an error (if short). The list_int() case looks like
it queries the remote length just the same, but only sets valuelen...
Why not just set both valuelen and rmtvaluelen there?

Brian

>  	while (valuelen > 0) {
>  		nmap = ATTR_RMTVALUE_MAPSIZE;
>  		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
> @@ -415,7 +420,7 @@ xfs_attr_rmtval_set(
>  	 * attributes have headers, we can't just do a straight byte to FSB
>  	 * conversion and have to take the header space into account.
>  	 */
> -	blkcnt = xfs_attr3_rmt_blocks(mp, args->valuelen);
> +	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
>  	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
>  						   XFS_ATTR_FORK);
>  	if (error)
> @@ -480,7 +485,7 @@ xfs_attr_rmtval_set(
>  	 */
>  	lblkno = args->rmtblkno;
>  	blkcnt = args->rmtblkcnt;
> -	valuelen = args->valuelen;
> +	valuelen = args->rmtvaluelen;
>  	while (valuelen > 0) {
>  		struct xfs_buf	*bp;
>  		xfs_daddr_t	dblkno;
> diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
> index 6e95ea7..201c609 100644
> --- a/fs/xfs/xfs_da_btree.h
> +++ b/fs/xfs/xfs_da_btree.h
> @@ -60,10 +60,12 @@ typedef struct xfs_da_args {
>  	int		index;		/* index of attr of interest in blk */
>  	xfs_dablk_t	rmtblkno;	/* remote attr value starting blkno */
>  	int		rmtblkcnt;	/* remote attr value block count */
> +	int		rmtvaluelen;	/* remote attr value length in bytes */
>  	xfs_dablk_t	blkno2;		/* blkno of 2nd attr leaf of interest */
>  	int		index2;		/* index of 2nd attr in blk */
>  	xfs_dablk_t	rmtblkno2;	/* remote attr value starting blkno */
>  	int		rmtblkcnt2;	/* remote attr value block count */
> +	int		rmtvaluelen2;	/* remote attr value length in bytes */
>  	int		op_flags;	/* operation flags */
>  	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
>  } xfs_da_args_t;
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
