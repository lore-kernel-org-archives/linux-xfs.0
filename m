Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:18491 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726759AbeJFJxA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 05:53:00 -0400
Date: Sat, 6 Oct 2018 12:51:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 03/28] xfs: Add attibute set and helper functions
Message-ID: <20181006025123.GB17046@dastard>
References: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
 <1537956907-10244-4-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537956907-10244-4-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 26, 2018 at 03:14:42AM -0700, Allison Henderson wrote:
> This patch adds xfs_attr_set_args and xfs_bmap_set_attrforkoff.
> These sub-routines set the attributes specified in @args.
> We will use this later for setting parent pointers as a deferred
> attribute operation.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 152 ++++++++++++++++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_attr.h |   1 +
>  fs/xfs/libxfs/xfs_bmap.c |  49 +++++++++------
>  fs/xfs/libxfs/xfs_bmap.h |   1 +
>  4 files changed, 122 insertions(+), 81 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f0675be..bc70151 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -227,6 +227,94 @@ xfs_attr_try_sf_addname(
>  	return error;
>  }
>  
> +/*
> + * Set the attribute specified in @args.
> + */
> +int
> +xfs_attr_set_args(
> +	struct xfs_da_args	*args,
> +	struct xfs_buf          **leaf_bp)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	int			error;
> +	int			sf_size;
> +
> +	/*
> +	 * New inodes setting the parent pointer attr will
> +	 * not have an attribute fork yet. So set the attribute
> +	 * fork appropriately
> +	 */
> +	if (XFS_IFORK_Q((args->dp)) == 0) {
> +		sf_size = sizeof(struct xfs_attr_sf_hdr) +
> +		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
> +		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
> +		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
> +		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
> +	}

This is new code. It is essentially trying to duplicate what
xfs_attr_set() has arelady done with a call to
xfs_bmap_add_attrfork(). It's also not correct, because we don't
know we are adding a sf attr yet, and won't know until
xfs_attr_try_sf_addname() is called.

> +
> +	/*
> +	 * If the attribute list is non-existent or a shortform list,
> +	 * upgrade it to a single-leaf-block attribute list.
> +	 */
> +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> +	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> +	     dp->i_d.di_anextents == 0)) {
> +
> +		/*
> +		 * Build initial attribute list (if required).
> +		 */
> +		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
> +			xfs_attr_shortform_create(args);
> +
> +		/*
> +		 * Try to add the attr to the attribute list in the inode.
> +		 */
> +		error = xfs_attr_try_sf_addname(dp, args);
> +		if (error != -ENOSPC)
> +			goto out;

This changes EEXIST or ENOENT error handling after creating the attr
fork (which modifies the inode and dirties the transaction). The
current code commits the attr fork changes on error (which is
harmless), but after this change we....

[...]
> -
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> -		error = xfs_attr_leaf_addname(&args);
> -	else
> -		error = xfs_attr_node_addname(&args);
> +	error = xfs_attr_set_args(&args, &leaf_bp);
>  	if (error)
>  		goto out;

End up jumping to the transaction cancelling code. IOWs, if we get
an error other than ENOSPC, we'll shut the filesystem down now,
instead of handling it gracefully and returning the error to
userspace.

I've got fixes for all this - I'll test them first before posting
updates for you...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
