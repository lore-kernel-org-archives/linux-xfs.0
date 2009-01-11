Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0BNXBar011189 for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 17:33:12 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DFD117D7C68
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 15:33:09 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	jfGP66RZYuo0b7IX for <xfs@oss.sgi.com>;
	Sun, 11 Jan 2009 15:33:09 -0800 (PST)
Date: Mon, 12 Jan 2009 10:33:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: fix dentry aliasing issues in open_by_handle
Message-ID: <20090111233306.GH8071@disturbed>
References: <20090109221104.237540000@bombadil.infradead.org>
	<20090109221259.292773000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090109221259.292773000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jan 09, 2009 at 05:11:05PM -0500, Christoph Hellwig wrote:
> Open by handle just grabs an inode by handle and then creates itself
> a dentry for it.  While this works for regular files it is horribly
> broken for directories, where the VFS locking relies on the fact that
> there is only just one single dentry for a given inode, and that
> these are always connected to the root of the filesystem so that
> it's locking algorithms work (see Documentations/filesystems/Locking)
> 
> Remove all the existing open by handle code and replace it with a small
> wrapper around the exportfs code which deals with all these issues.
> At the same time we also make the checks for a valid handle strict
> enough to reject all not perfectly well formed handles - given that
> we never hand out others that's okay and simplifies the code.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
....
> +handle_acceptable(
> +	void			*context,
> +	struct dentry		*dentry)
> +{
> +	return 1;
> +}

That should probably be namespaced correctly because it won't be
static on debug builds. i.e.  xfs_handle_acceptable()

> -	dentry = d_obtain_alias(inode);
> -	if (IS_ERR(dentry)) {
> -		put_unused_fd(new_fd);
> -		return PTR_ERR(dentry);
> +	fd = get_unused_fd();
> +	if (fd < 0) {
> +		error = fd;
> +		goto out_dput;
>  	}
>  
> -	/* Ensure umount returns EBUSY on umounts while this file is open. */
> -	mntget(parfilp->f_path.mnt);
> -
> -	/* Create file pointer. */
> -	filp = dentry_open(dentry, parfilp->f_path.mnt, hreq->oflags, cred);
> +	filp = dentry_open(dentry, mntget(parfilp->f_path.mnt),
> +			   hreq->oflags, cred);
>  	if (IS_ERR(filp)) {
> -		put_unused_fd(new_fd);
> -		return -XFS_ERROR(-PTR_ERR(filp));
> +		put_unused_fd(fd);
> +		return PTR_ERR(filp);
>  	}

Doesn't that error leak a mount+dentry reference? i.e. we do a mntget()
when calling dentry_open(), but we don't drop the reference on
error.

Ah, no, dentry_open() drops both the reference and the dentry on error.
That's ok, then.

>  STATIC int
>  xfs_attrlist_by_handle(
> -	xfs_mount_t		*mp,
>  	void			__user *arg,
> -	struct inode		*parinode)
> +	struct file		*parfilp)

The args in this function are back to front compared to all the
other functions - the others are (filp, arg), this one is the
opposite.

>  	case XFS_IOC_READLINK_BY_HANDLE: {
>  		xfs_fsop_handlereq_t	hreq;
>  
>  		if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
>  			return -XFS_ERROR(EFAULT);
> -		return xfs_readlink_by_handle(mp, &hreq, inode);
> +		return xfs_readlink_by_handle(filp, &hreq);
>  	}
>  	case XFS_IOC_ATTRLIST_BY_HANDLE:
> -		return xfs_attrlist_by_handle(mp, arg, inode);
> +		return xfs_attrlist_by_handle(arg, filp);

As can be seen here.

Other than that, it looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
