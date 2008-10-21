Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 20:05:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L35jjR015201
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 20:05:45 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 753AC10BCB57
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 20:07:29 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id HWt6CkyoaNuwv5DO for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 20:07:29 -0700 (PDT)
Date: Tue, 21 Oct 2008 14:07:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] free inodes using destroy_inode
Message-ID: <20081021030726.GD18495@disturbed>
References: <20081020222044.GC23662@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020222044.GC23662@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Oct 21, 2008 at 12:20:44AM +0200, Christoph Hellwig wrote:
> To make sure we free the security data inodes need to be freed using
> the proper VFS helper (which we also need to export for this).  To make
> sure we don't corrupt the radix tree we need to add another special
> case to xfs_reclaim for inodes that haven't been fully initialized yet.

Yes, this should fix the problems destroying inodes in the
not-quite-fully-instantiated state. Couple of things, though.

> Index: xfs-2.6/fs/xfs/xfs_inode.c
> ===================================================================
> --- xfs-2.6.orig/fs/xfs/xfs_inode.c	2008-10-20 23:54:05.000000000 +0200
> +++ xfs-2.6/fs/xfs/xfs_inode.c	2008-10-20 23:54:08.000000000 +0200
> @@ -872,10 +872,8 @@ xfs_iread(
>  	imap.im_blkno = bno;
>  	error = xfs_imap(mp, tp, ip->i_ino, &imap,
>  				XFS_IMAP_LOOKUP | imap_flags);
> -	if (error) {
> -		xfs_idestroy(ip);
> -		return error;
> -	}
> +	if (error)
> + 		goto out_destroy_inode;
   ^
Extra whitespace.

> @@ -887,10 +885,8 @@ xfs_iread(
>  	ASSERT(bno == 0 || bno == imap.im_blkno);
>  
>  	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, imap_flags);
> -	if (error) {
> -		xfs_idestroy(ip);
> -		return error;
> -	}
> +	if (error)
> + 		goto out_destroy_inode;
   ^
Ditto.

> Index: xfs-2.6/fs/xfs/xfs_inode.h
> ===================================================================
> --- xfs-2.6.orig/fs/xfs/xfs_inode.h	2008-10-20 23:54:05.000000000 +0200
> +++ xfs-2.6/fs/xfs/xfs_inode.h	2008-10-20 23:54:08.000000000 +0200
> @@ -309,6 +309,12 @@ static inline struct inode *VFS_I(struct
>  	return &ip->i_vnode;
>  }
>  
> +static inline void xfs_destroy_inode(struct xfs_inode *ip)
> +{
> +	make_bad_inode(VFS_I(ip));
> +	return destroy_inode(VFS_I(ip));
> +}

Yes, makes sense to mark it bad first to avoid most of the
reclaim code.

> Index: xfs-2.6/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- xfs-2.6.orig/fs/xfs/xfs_vnodeops.c	2008-10-20 23:49:27.000000000 +0200
> +++ xfs-2.6/fs/xfs/xfs_vnodeops.c	2008-10-20 23:55:31.000000000 +0200
> @@ -2798,13 +2798,19 @@ int
>  xfs_reclaim(
>  	xfs_inode_t	*ip)
>  {
> +	struct inode	*inode = VFS_I(ip);
>  
>  	xfs_itrace_entry(ip);
>  
> -	ASSERT(!VN_MAPPED(VFS_I(ip)));
> +	ASSERT(!VN_MAPPED(inode));
> +
> +	if (unlikely(inode->i_state & I_NEW)) {
> +		xfs_idestroy(ip);
> +		return 0;
> +	}

Can that happen? I thought xfs_iput_new() took care of clearing the
I_NEW flag via unlock_new_inode() and so there is no way that flag
can leak through to here. perhaps a comment explaining what the
error path is that leads to needing this check is in order....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
