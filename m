Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 18:55:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m331sxkj009624
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 18:55:01 -0700
Date: Wed, 2 Apr 2008 21:51:22 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 3/7] XFS: Refactor node format directory lookup/addname
Message-ID: <20080403015122.GE5211@josefsipek.net>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062708.380299192@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402062708.380299192@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 02, 2008 at 04:25:11PM +1000, Barry Naujok wrote:
...
> --- kern_ci.orig/fs/xfs/xfs_dir2_node.c
> +++ kern_ci/fs/xfs/xfs_dir2_node.c
...
> @@ -432,27 +429,15 @@ xfs_dir2_leafn_lookup_int(
>  	/*
>  	 * Do we have a buffer coming in?
>  	 */
> -	if (state->extravalid)
> -		curbp = state->extrablk.bp;
> -	else
> -		curbp = NULL;
> +	curbp = state->extravalid ? state->extrablk.bp : NULL;
>  	/*
>  	 * For addname, it's a free block buffer, get the block number.
>  	 */
> -	if (args->addname) {
> -		curfdb = curbp ? state->extrablk.blkno : -1;
> -		curdb = -1;
> -		length = xfs_dir2_data_entsize(args->namelen);
> -		if ((free = (curbp ? curbp->data : NULL)))
> -			ASSERT(be32_to_cpu(free->hdr.magic) == XFS_DIR2_FREE_MAGIC);
> -	}
> -	/*
> -	 * For others, it's a data block buffer, get the block number.
> -	 */
> -	else {
> -		curfdb = -1;
> -		curdb = curbp ? state->extrablk.blkno : -1;
> -	}
> +	curfdb = curbp ? state->extrablk.blkno : -1;
> +	free = curbp ? curbp->data : NULL;

The previous 3 lines can be cleaned up as:

if (state->extravalid)
	curbp = state->extrablk.bp;
else
	curbp = NULL;

if (curbp) {
	curfdb = state->extrablk.blkno;
	free = curbp->data;
} else {
	curfdb = -1;
	free = NULL;
}


or, if (state->extravalid && state->extrablk.bp == NULL) is _ALWAYS_ false
(which seems to be the case), you can do:


if (state->extravalid) {
	curbp = state->extrablk.bp;
	curfdb = state->extrablk.blkno;
	free = curbp->data;
} else {
	curbp = NULL;
	curfdb = -1;
	free = NULL;
}

...
> +static int
> +xfs_dir2_leafn_lookup_for_entry(
> +	xfs_dabuf_t		*bp,		/* leaf buffer */
> +	xfs_da_args_t		*args,		/* operation arguments */
> +	int			*indexp,	/* out: leaf entry index */
> +	xfs_da_state_t		*state)		/* state to fill in */
> +{
> +	xfs_dabuf_t		*curbp;		/* current data/free buffer */
> +	xfs_dir2_db_t		curdb;		/* current data block number */
> +	xfs_dir2_data_entry_t	*dep;		/* data block entry */
> +	xfs_inode_t		*dp;		/* incore directory inode */
> +	int			error;		/* error return value */
> +	int			index;		/* leaf entry index */
> +	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
> +	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
> +	xfs_mount_t		*mp;		/* filesystem mount point */
> +	xfs_dir2_db_t		newdb;		/* new data block number */
> +	xfs_trans_t		*tp;		/* transaction pointer */
> +	xfs_dacmp_t		cmp;		/* comparison result */
> +	xfs_dabuf_t		*ci_bp = NULL;	/* buffer with CI match */

Did you try to check the stack usage (scripts/checkstack.pl)?

> +	dp = args->dp;
> +	tp = args->trans;
> +	mp = dp->i_mount;
> +	leaf = bp->data;
> +	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_DIR2_LEAFN_MAGIC);
> +#ifdef __KERNEL__
> +	ASSERT(be16_to_cpu(leaf->hdr.count) > 0);
> +#endif

What's this #ifdef for?

> +		dep = (xfs_dir2_data_entry_t *)((char *)curbp->data +
> +			xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));

Perhaps a static inline to do this calculation more cleanly (assuming it's
done elsewhere as well).

...
> +		/*
> +		 * Compare the entry, return it if it matches.
> +		 */
> +		cmp = args->oknoent ?
> +			xfs_dir_compname(dp, dep->name, dep->namelen,
> +					args->name, args->namelen):
> +			xfs_da_compname(dep->name, dep->namelen,
> +					args->name, args->namelen);

same as comment for 1/7.

Josef 'Jeff' Sipek.

-- 
My public GPG key can be found at
http://www.josefsipek.net/gpg/public-0xC7958FFE.txt
