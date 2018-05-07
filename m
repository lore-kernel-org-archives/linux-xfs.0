Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33772 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752773AbeEGXVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 19:21:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w47NGObW073804
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 23:21:32 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2hs426ea73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 May 2018 23:21:32 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w47NLV2N016291
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 23:21:31 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w47NLVQ6011909
        for <linux-xfs@vger.kernel.org>; Mon, 7 May 2018 23:21:31 GMT
Date: Mon, 7 May 2018 16:21:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/21] xfs: Add attibute remove and helper functions
Message-ID: <20180507232129.GR11261@magnolia>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-5-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525627494-12873-5-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, May 06, 2018 at 10:24:37AM -0700, Allison Henderson wrote:
> This patch adds xfs_attr_remove_args. These sub-routines remove
> the attributes specified in @args. We will use this later for setting
> parent pointers as a deferred attribute operation.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++++++----------
>  fs/xfs/libxfs/xfs_attr.h |  1 +
>  2 files changed, 34 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 99c4a31..514f4f8 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -296,6 +296,34 @@ xfs_attr_set_args(
>  }
>  
>  /*
> + * Remove the attribute specified in @args.
> + */
> +int
> +xfs_attr_remove_args(
> +	struct xfs_da_args      *args,
> +	int			flags,
> +	bool                    roll_trans)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	int			error;
> +
> +	xfs_trans_ijoin(args->trans, dp, 0);
> +
> +	if (!xfs_inode_hasattr(dp)) {
> +		error = -ENOATTR;
> +	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> +		error = xfs_attr_shortform_remove(args, roll_trans);
> +	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +		error = xfs_attr_leaf_removename(args, roll_trans);
> +	} else {
> +		error = xfs_attr_node_removename(args, roll_trans);
> +	}
> +
> +	return error;
> +}
> +
> +/*
>   * Calculate how many blocks we need for the new attribute,
>   */
>  STATIC int
> @@ -439,6 +467,7 @@ xfs_attr_set(
>  	return error;
>  }
>  
> +
>  /*
>   * Generic handler routine to remove a name from an attribute list.
>   * Transitions attribute list from Btree to shortform as necessary.
> @@ -495,17 +524,9 @@ xfs_attr_remove(
>  	 * blocks not allocate in the common case.
>  	 */
>  	xfs_trans_ijoin(args.trans, dp, 0);
> +	xfs_defer_init(args.dfops, args.firstblock);
>  
> -	if (!xfs_inode_hasattr(dp)) {
> -		error = -ENOATTR;
> -	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> -		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> -		error = xfs_attr_shortform_remove(&args, true);
> -	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error = xfs_attr_leaf_removename(&args, true);
> -	} else {
> -		error = xfs_attr_node_removename(&args, true);
> -	}
> +	error = xfs_attr_remove_args(&args, flags, true);
>  
>  	if (error)
>  		goto out;
> @@ -530,6 +551,8 @@ xfs_attr_remove(
>  	return error;
>  
>  out:
> +	xfs_defer_cancel(&dfops);
> +
>  	if (args.trans)
>  		xfs_trans_cancel(args.trans);
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index b5dc02c..ef6b47e 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -155,6 +155,7 @@ int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
>  int xfs_attr_set_args(struct xfs_da_args *args, int flags,
>  			struct xfs_buf *leaf_bp, bool roll_trans);
>  int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
> +int xfs_attr_remove_args(struct xfs_da_args *args, int flags, bool roll_trans);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
