Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Jun 2008 00:30:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m557UDNn005115
	for <xfs@oss.sgi.com>; Thu, 5 Jun 2008 00:30:15 -0700
Message-ID: <48479632.4080406@sgi.com>
Date: Thu, 05 Jun 2008 17:30:58 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] factor out inode has attrs check
References: <20080603113955.GA2703@lst.de>
In-Reply-To: <20080603113955.GA2703@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Looks good.
I'll run thru qa and check in.

So there are a couple of cases where XFS_DINODE_FMT_LOCAL
is used in xfs_attr_inactive() as well as the noattr check.
Okay, that's because the EAs would be in shortform so we
don't have to do anything for inactive here (the inode inactive
will suffice).
Apart from that they are all replacements (callouts) except
for the superfluous check Christoph mentioned. Cool.

--Tim


Christoph Hellwig wrote:
> Note that xfs_attr_fetch did the check twice while keeping the inode
> locked and we can just remove the superflous check.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_attr.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_attr.c	2008-06-01 14:32:06.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_attr.c	2008-06-01 14:40:04.000000000 +0200
> @@ -111,6 +111,17 @@ xfs_attr_name_to_xname(
>  	return 0;
>  }
>  
> +STATIC int
> +xfs_inode_hasattr(
> +	struct xfs_inode	*ip)
> +{
> +	if (!XFS_IFORK_Q(ip) ||
> +	    (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> +	     ip->i_d.di_anextents == 0))
> +		return 0;
> +	return 1;
> +}
> +
>  /*========================================================================
>   * Overall external interface routines.
>   *========================================================================*/
> @@ -122,10 +133,8 @@ xfs_attr_fetch(xfs_inode_t *ip, struct x
>  	xfs_da_args_t   args;
>  	int             error;
>  
> -	if ((XFS_IFORK_Q(ip) == 0) ||
> -	    (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	     ip->i_d.di_anextents == 0))
> -		return(ENOATTR);
> +	if (!xfs_inode_hasattr(ip))
> +		return ENOATTR;
>  
>  	/*
>  	 * Fill in the arg structure for this request.
> @@ -143,11 +152,7 @@ xfs_attr_fetch(xfs_inode_t *ip, struct x
>  	/*
>  	 * Decide on what work routines to call based on the inode size.
>  	 */
> -	if (XFS_IFORK_Q(ip) == 0 ||
> -	    (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	     ip->i_d.di_anextents == 0)) {
> -		error = XFS_ERROR(ENOATTR);
> -	} else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> +	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>  		error = xfs_attr_shortform_getvalue(&args);
>  	} else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK)) {
>  		error = xfs_attr_leaf_get(&args);
> @@ -523,9 +528,7 @@ xfs_attr_remove_int(xfs_inode_t *dp, str
>  	/*
>  	 * Decide on what work routines to call based on the inode size.
>  	 */
> -	if (XFS_IFORK_Q(dp) == 0 ||
> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	     dp->i_d.di_anextents == 0)) {
> +	if (!xfs_inode_hasattr(dp)) {
>  		error = XFS_ERROR(ENOATTR);
>  		goto out;
>  	}
> @@ -595,11 +598,9 @@ xfs_attr_remove(
>  		return error;
>  
>  	xfs_ilock(dp, XFS_ILOCK_SHARED);
> -	if (XFS_IFORK_Q(dp) == 0 ||
> -		   (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -		    dp->i_d.di_anextents == 0)) {
> +	if (!xfs_inode_hasattr(dp)) {
>  		xfs_iunlock(dp, XFS_ILOCK_SHARED);
> -		return(XFS_ERROR(ENOATTR));
> +		return XFS_ERROR(ENOATTR);
>  	}
>  	xfs_iunlock(dp, XFS_ILOCK_SHARED);
>  
> @@ -615,9 +616,7 @@ xfs_attr_list_int(xfs_attr_list_context_
>  	/*
>  	 * Decide on what work routines to call based on the inode size.
>  	 */
> -	if (XFS_IFORK_Q(dp) == 0 ||
> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	     dp->i_d.di_anextents == 0)) {
> +	if (!xfs_inode_hasattr(dp)) {
>  		error = 0;
>  	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>  		error = xfs_attr_shortform_list(context);
> @@ -810,12 +809,10 @@ xfs_attr_inactive(xfs_inode_t *dp)
>  	ASSERT(! XFS_NOT_DQATTACHED(mp, dp));
>  
>  	xfs_ilock(dp, XFS_ILOCK_SHARED);
> -	if ((XFS_IFORK_Q(dp) == 0) ||
> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) ||
> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	     dp->i_d.di_anextents == 0)) {
> +	if (!xfs_inode_hasattr(dp) ||
> +	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>  		xfs_iunlock(dp, XFS_ILOCK_SHARED);
> -		return(0);
> +		return 0;
>  	}
>  	xfs_iunlock(dp, XFS_ILOCK_SHARED);
>  
> @@ -848,10 +845,8 @@ xfs_attr_inactive(xfs_inode_t *dp)
>  	/*
>  	 * Decide on what work routines to call based on the inode size.
>  	 */
> -	if ((XFS_IFORK_Q(dp) == 0) ||
> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) ||
> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	     dp->i_d.di_anextents == 0)) {
> +	if (!xfs_inode_hasattr(dp) ||
> +	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>  		error = 0;
>  		goto out;
>  	}
> 
