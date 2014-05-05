Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A482D29DF8
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 15:21:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 70A7B8F8035
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 13:21:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JPnWqhv808MUhWTg for
	<xfs@oss.sgi.com>; Mon, 05 May 2014 13:21:09 -0700 (PDT)
Date: Mon, 5 May 2014 16:21:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/5] xfs: fold xfs_attr_set_int into xfs_attr_set
Message-ID: <20140505202104.GB12448@laptop.bfoster>
References: <1399130415-5382-1-git-send-email-hch@lst.de>
	<1399130415-5382-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399130415-5382-2-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sat, May 03, 2014 at 05:20:11PM +0200, Christoph Hellwig wrote:
> Plus various minor style fixes to the new xfs_attr_set.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me.

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_attr.c |  110 +++++++++++++++++++++--------------------------------
>  1 file changed, 44 insertions(+), 66 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
> index 01b6a01..eb3ae8f 100644
> --- a/fs/xfs/xfs_attr.c
> +++ b/fs/xfs/xfs_attr.c
> @@ -221,26 +221,32 @@ xfs_attr_calc_size(
>  	return nblks;
>  }
>  
> -STATIC int
> -xfs_attr_set_int(
> -	struct xfs_inode *dp,
> -	struct xfs_name	*name,
> -	unsigned char	*value,
> -	int		valuelen,
> -	int		flags)
> +int
> +xfs_attr_set(
> +	struct xfs_inode	*dp,
> +	const unsigned char	*name,
> +	unsigned char		*value,
> +	int			valuelen,
> +	int			flags)
>  {
> -	xfs_da_args_t		args;
> -	xfs_fsblock_t		firstblock;
> -	xfs_bmap_free_t		flist;
> -	int			error, err2, committed;
>  	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_da_args	args;
> +	struct xfs_bmap_free	flist;
>  	struct xfs_trans_res	tres;
> +	struct xfs_name		xname;
> +	xfs_fsblock_t		firstblock;
>  	int			rsvd = (flags & ATTR_ROOT) != 0;
> -	int			local;
> +	int			error, err2, committed, local;
> +
> +	XFS_STATS_INC(xs_attr_set);
> +
> +	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
> +		return EIO;
> +
> +	error = xfs_attr_name_to_xname(&xname, name);
> +	if (error)
> +		return error;
>  
> -	/*
> -	 * Attach the dquots to the inode.
> -	 */
>  	error = xfs_qm_dqattach(dp, 0);
>  	if (error)
>  		return error;
> @@ -251,18 +257,16 @@ xfs_attr_set_int(
>  	 */
>  	if (XFS_IFORK_Q(dp) == 0) {
>  		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
> -			      XFS_ATTR_SF_ENTSIZE_BYNAME(name->len, valuelen);
> +			      XFS_ATTR_SF_ENTSIZE_BYNAME(xname.len, valuelen);
>  
> -		if ((error = xfs_bmap_add_attrfork(dp, sf_size, rsvd)))
> -			return(error);
> +		error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
> +		if (error)
> +			return error;
>  	}
>  
> -	/*
> -	 * Fill in the arg structure for this request.
> -	 */
> -	memset((char *)&args, 0, sizeof(args));
> -	args.name = name->name;
> -	args.namelen = name->len;
> +	memset(&args, 0, sizeof(args));
> +	args.name = xname.name;
> +	args.namelen = xname.len;
>  	args.value = value;
>  	args.valuelen = valuelen;
>  	args.flags = flags;
> @@ -274,7 +278,7 @@ xfs_attr_set_int(
>  	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
>  
>  	/* Size is now blocks for attribute data */
> -	args.total = xfs_attr_calc_size(dp, name->len, valuelen, &local);
> +	args.total = xfs_attr_calc_size(dp, xname.len, valuelen, &local);
>  
>  	/*
>  	 * Start our first transaction of the day.
> @@ -303,7 +307,7 @@ xfs_attr_set_int(
>  	error = xfs_trans_reserve(args.trans, &tres, args.total, 0);
>  	if (error) {
>  		xfs_trans_cancel(args.trans, 0);
> -		return(error);
> +		return error;
>  	}
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
>  
> @@ -313,7 +317,7 @@ xfs_attr_set_int(
>  	if (error) {
>  		xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  		xfs_trans_cancel(args.trans, XFS_TRANS_RELEASE_LOG_RES);
> -		return (error);
> +		return error;
>  	}
>  
>  	xfs_trans_ijoin(args.trans, dp, 0);
> @@ -322,9 +326,9 @@ xfs_attr_set_int(
>  	 * If the attribute list is non-existent or a shortform list,
>  	 * upgrade it to a single-leaf-block attribute list.
>  	 */
> -	if ((dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) ||
> -	    ((dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS) &&
> -	     (dp->i_d.di_anextents == 0))) {
> +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> +	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> +	     dp->i_d.di_anextents == 0)) {
>  
>  		/*
>  		 * Build initial attribute list (if required).
> @@ -349,9 +353,8 @@ xfs_attr_set_int(
>  			 * the transaction goes to disk before returning
>  			 * to the user.
>  			 */
> -			if (mp->m_flags & XFS_MOUNT_WSYNC) {
> +			if (mp->m_flags & XFS_MOUNT_WSYNC)
>  				xfs_trans_set_sync(args.trans);
> -			}
>  
>  			if (!error && (flags & ATTR_KERNOTIME) == 0) {
>  				xfs_trans_ichgtime(args.trans, dp,
> @@ -361,7 +364,7 @@ xfs_attr_set_int(
>  						 XFS_TRANS_RELEASE_LOG_RES);
>  			xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  
> -			return(error == 0 ? err2 : error);
> +			return error ? error : err2;
>  		}
>  
>  		/*
> @@ -399,22 +402,19 @@ xfs_attr_set_int(
>  
>  	}
>  
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>  		error = xfs_attr_leaf_addname(&args);
> -	} else {
> +	else
>  		error = xfs_attr_node_addname(&args);
> -	}
> -	if (error) {
> +	if (error)
>  		goto out;
> -	}
>  
>  	/*
>  	 * If this is a synchronous mount, make sure that the
>  	 * transaction goes to disk before returning to the user.
>  	 */
> -	if (mp->m_flags & XFS_MOUNT_WSYNC) {
> +	if (mp->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_trans_set_sync(args.trans);
> -	}
>  
>  	if ((flags & ATTR_KERNOTIME) == 0)
>  		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
> @@ -426,37 +426,15 @@ xfs_attr_set_int(
>  	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  
> -	return(error);
> +	return error;
>  
>  out:
> -	if (args.trans)
> +	if (args.trans) {
>  		xfs_trans_cancel(args.trans,
>  			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
> +	}
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> -	return(error);
> -}
> -
> -int
> -xfs_attr_set(
> -	xfs_inode_t	*dp,
> -	const unsigned char *name,
> -	unsigned char	*value,
> -	int		valuelen,
> -	int		flags)
> -{
> -	int             error;
> -	struct xfs_name	xname;
> -
> -	XFS_STATS_INC(xs_attr_set);
> -
> -	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
> -		return (EIO);
> -
> -	error = xfs_attr_name_to_xname(&xname, name);
> -	if (error)
> -		return error;
> -
> -	return xfs_attr_set_int(dp, &xname, value, valuelen, flags);
> +	return error;
>  }
>  
>  /*
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
