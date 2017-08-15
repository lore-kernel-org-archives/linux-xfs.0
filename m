Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:54814
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752993AbdHOCAj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 22:00:39 -0400
Date: Tue, 15 Aug 2017 12:00:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: preserve i_mode if __xfs_set_acl() fails
Message-ID: <20170815020018.GF21024@dastard>
References: <20170814081806.GA3924@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170814081806.GA3924@debian.home>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?= <ernesto.mnd.fernandez@gmail.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>

On Mon, Aug 14, 2017 at 05:18:10AM -0300, Ernesto A. Fernández wrote:
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index de7b9bd..c3193e1 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -395,6 +395,7 @@ xfs_attr_remove(
>  	struct xfs_defer_ops	dfops;
>  	xfs_fsblock_t		firstblock;
>  	int			error;
> +	int			noattr = 0;

bool.

And make it "bool has_attr = true" to avoid the nasty double
negative of "!noattr" later on.

>  
>  	XFS_STATS_INC(mp, xs_attr_remove);
>  
> @@ -438,7 +439,12 @@ xfs_attr_remove(
>  	xfs_trans_ijoin(args.trans, dp, 0);
>  
>  	if (!xfs_inode_hasattr(dp)) {
> -		error = -ENOATTR;
> +		/*
> +		 * Commit even if there is no attr to remove, because when
> +		 * setting ACLs the caller may be changing the mode in the
> +		 * same transaction.
> +		 */
> +		noattr = 1;
>  	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>  		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>  		error = xfs_attr_shortform_remove(&args);
> @@ -458,7 +464,7 @@ xfs_attr_remove(
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_trans_set_sync(args.trans);
>  
> -	if ((flags & ATTR_KERNOTIME) == 0)
> +	if ((flags & ATTR_KERNOTIME) == 0 && !noattr)
>  		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);

Why?

>  
>  	/*
> @@ -468,6 +474,9 @@ xfs_attr_remove(
>  	error = xfs_trans_commit(args.trans);
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  
> +	if (!error && noattr)
> +		error = -ENOATTR;
> +
>  	return error;
>  
>  out:
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 7034e17..1fe4363 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -226,28 +226,13 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  	return error;
>  }
>  
> -static int
> -xfs_set_mode(struct inode *inode, umode_t mode)
> -{
> -	int error = 0;
> -
> -	if (mode != inode->i_mode) {
> -		struct iattr iattr;
> -
> -		iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
> -		iattr.ia_mode = mode;
> -		iattr.ia_ctime = current_time(inode);
> -
> -		error = xfs_setattr_nonsize(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
> -	}
> -
> -	return error;
> -}

Ok, so that does an atomic, transactional change to the inode
mode....

>  int
>  xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
>  	int error = 0;
> +	int mode_changed = 0;
> +	umode_t old_mode = inode->i_mode;
> +	struct timespec old_ctime = inode->i_ctime;
>  
>  	if (!acl)
>  		goto set_acl;
> @@ -257,16 +242,20 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  		return error;
>  
>  	if (type == ACL_TYPE_ACCESS) {
> -		umode_t mode;
> -
> -		error = posix_acl_update_mode(inode, &mode, &acl);
> -		if (error)
> -			return error;
> -		error = xfs_set_mode(inode, mode);
> +		error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
>  		if (error)
>  			return error;
> +		inode->i_ctime = current_time(inode);
> +		XFS_STATS_INC(XFS_I(inode)->i_mount, xs_ig_attrchg);
> +		mode_changed = 1;
>  	}

And this doesn't.

So this breaks all our rules for inode metadata updates, both for
runtime access serialisation and for crash consistency.

>   set_acl:
> -	return __xfs_set_acl(inode, acl, type);
> +	error = __xfs_set_acl(inode, acl, type);
> +	if (error && mode_changed) {
> +		inode->i_mode = old_mode;
> +		inode->i_ctime = old_ctime;
> +		XFS_STATS_DEC(XFS_I(inode)->i_mount, xs_ig_attrchg);
> +	}

Same here.

IOWs, you can't just remove a transactional modification of inode
state and replace it with in-memory VFS inode level changes. You
need to do the changes in transaction context and with the correct
locks held.

IOWs, if you need to undo the mode changes xfs_set_mode() did, you
need to call xfs_set_mode() again. And because modifications have
been made, the new ctime should remain in place, too.

Of course, this still isn't atomic from a runtime access POV, but
that's substantially harder to provide than just undoing the mode
change on ACL attribute save error.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
