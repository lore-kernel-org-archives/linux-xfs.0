Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 01:27:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q8RRAS008925
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 01:27:27 -0700
Date: Thu, 26 Jun 2008 04:28:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Move xfs_attr_rolltrans to xfs_trans_roll
Message-ID: <20080626082827.GC23954@infradead.org>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com> <1214196150-5427-2-git-send-email-xaiki@sgi.com> <1214196150-5427-3-git-send-email-xaiki@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214196150-5427-3-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

> -		if ((error = xfs_attr_rolltrans(&args.trans, dp)))
> +
> +		error = xfs_trans_roll(&args.trans, dp);
> +		if (error)
>  			goto out;
>  
>  	}
> @@ -1019,7 +1021,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>  		 * Commit the current trans (including the inode) and start
>  		 * a new one.
>  		 */
> -		if ((error = xfs_attr_rolltrans(&args->trans, dp)))
> +		if ((error = xfs_trans_roll(&args->trans, dp)))

Please do the transformation to move all assignments out of the
coditionals everywhere.

> index b08e2a2..9465807 100644
> --- a/fs/xfs/xfs_attr_leaf.c
> +++ b/fs/xfs/xfs_attr_leaf.c
> @@ -2543,7 +2543,7 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
>  	/*
>  	 * Commit the flag value change and start the next trans in series.
>  	 */
> -	error = xfs_attr_rolltrans(&args->trans, args->dp);
> +	error = xfs_trans_roll(&args->trans, args->dp);
>  
>  	return(error);

	return xfs_trans_roll(&args->trans, args->dp);

> +/*
> + * Roll from one trans in the sequence of PERMANENT transactions to the next.
> + */

The comment could be a little more verbose :)

> +int
> +xfs_trans_roll(
> +	xfs_trans_t	**tpp,
> +	xfs_inode_t	*dp)
> +{
> +	xfs_trans_t	*trans;
> +	unsigned int	logres, count;
> +	int		error;

Please convert this to the struct types and canonical variable names
for the given types:

int
xfs_trans_roll(
	struct xfs_trans	*tpp,
	struct xfs_inode	*ip)
{
	struct xfs_trans	*tp;


> +	if ((error = xfs_trans_commit(trans, 0)))
> +		return (error);

	error = xfs_trans_commit(trans, 0);
	if (error)
		return error;

> +	error = xfs_trans_reserve(trans, 0, logres, 0,
> +				  XFS_TRANS_PERM_LOG_RES, count);
> +	/*
> +	 *  Ensure that the inode is in the new transaction and locked.
> +	 */
> +	if (!error) {
> +		xfs_trans_ijoin(trans, dp, XFS_ILOCK_EXCL);
> +		xfs_trans_ihold(trans, dp);
> +	}
> +	return (error);

	if (error)
		return error;

	xfs_trans_ijoin(trans, ip, XFS_ILOCK_EXCL);
	xfs_trans_ihold(trans, ip);
	return 0;
