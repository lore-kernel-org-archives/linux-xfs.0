Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47170 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbeJFKC6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 06:02:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w962s475148430
        for <linux-xfs@vger.kernel.org>; Sat, 6 Oct 2018 03:01:23 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mt1bqnkev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 06 Oct 2018 03:01:22 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9631Mcn032231
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 6 Oct 2018 03:01:22 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9631LSe016831
        for <linux-xfs@vger.kernel.org>; Sat, 6 Oct 2018 03:01:21 GMT
Date: Fri, 5 Oct 2018 20:01:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v9 02/28] xfs: Add helper function xfs_attr_try_sf_addname
Message-ID: <20181006030119.GC28243@magnolia>
References: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
 <1537956907-10244-3-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537956907-10244-3-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 26, 2018 at 03:14:41AM -0700, Allison Henderson wrote:
> This patch adds a subroutine xfs_attr_try_sf_addname
> used by xfs_attr_set.  This subrotine will attempt to
> add the attribute name specified in args in shortform,
> as well and perform error handling previously done in
> xfs_attr_set.
> 
> This patch helps to pre-simplify xfs_attr_set for reviewing
> purposes and reduce indentation.  New function will be added
> in the next patch.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 61 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 40 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1e671d4..f0675be 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -191,6 +191,42 @@ xfs_attr_calc_size(
>  	return nblks;
>  }
>  
> +STATIC int
> +xfs_attr_try_sf_addname(
> +	struct xfs_inode	*dp,
> +	struct xfs_da_args	*args)
> +{
> +
> +	struct xfs_mount	*mp = dp->i_mount;
> +	int			error;
> +
> +	error = xfs_attr_shortform_addname(args);

I wonder, what error codes can come out of this function?  -ENOSPC,
-EEXIST, zero...?

> +	if (error == -ENOSPC)
> +		return error;
> +
> +	/*
> +	 * Commit the shortform mods, and we're done.
> +	 * NOTE: this is also the error path
> +	 * (EEXIST, etc).
> +	 */
> +	ASSERT(args->trans != NULL);

<urk> Um... I get that this is just mechanical code refactoring, but...

> +
> +	/*
> +	 * If this is a synchronous mount, make sure
> +	 * that the transaction goes to disk before
> +	 * returning to the user.
> +	 */
> +	if (mp->m_flags & XFS_MOUNT_WSYNC)
> +		xfs_trans_set_sync(args->trans);

...let's say we're on the error path.  Why would we care about making the
transaction synchronous?

> +
> +	if (!error && (args->flags & ATTR_KERNOTIME) == 0) {
> +		xfs_trans_ichgtime(args->trans, dp,
> +				XFS_ICHGTIME_CHG);
> +	}

And what's the point of updating ctime if we do?

And can we restructure this to follow the usual pattern:

error = xfs_blabhablhablah(...);
if (error)
	bail out;

<keep going>

> +
> +	return error;
> +}
> +
>  int
>  xfs_attr_set(
>  	struct xfs_inode	*dp,
> @@ -281,30 +317,13 @@ xfs_attr_set(
>  		 * Try to add the attr to the attribute list in
>  		 * the inode.
>  		 */
> -		error = xfs_attr_shortform_addname(&args);
> +		error = xfs_attr_try_sf_addname(dp, &args);
>  		if (error != -ENOSPC) {
> -			/*
> -			 * Commit the shortform mods, and we're done.
> -			 * NOTE: this is also the error path (EEXIST, etc).
> -			 */
> -			ASSERT(args.trans != NULL);
> -
> -			/*
> -			 * If this is a synchronous mount, make sure that
> -			 * the transaction goes to disk before returning
> -			 * to the user.
> -			 */
> -			if (mp->m_flags & XFS_MOUNT_WSYNC)
> -				xfs_trans_set_sync(args.trans);
> -
> -			if (!error && (flags & ATTR_KERNOTIME) == 0) {
> -				xfs_trans_ichgtime(args.trans, dp,
> -							XFS_ICHGTIME_CHG);
> -			}
>  			err2 = xfs_trans_commit(args.trans);
> -			xfs_iunlock(dp, XFS_ILOCK_EXCL);
> +			error = error ? error : err2;
>  
> -			return error ? error : err2;
> +			xfs_iunlock(dp, XFS_ILOCK_EXCL);
> +			return error;

Huh, so we commit the transaction on error?? Why?

/me runs away

--D

>  		}
>  
>  		/*
> -- 
> 2.7.4
> 
