Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 16:41:12 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBH0f32U004421
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 16:41:07 -0800
Message-ID: <4765C5AA.5050504@sgi.com>
Date: Mon, 17 Dec 2007 11:41:14 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] stop updating inode->i_blocks
References: <20071216163352.GB2107@lst.de>
In-Reply-To: <20071216163352.GB2107@lst.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

It is looking good from DMAPI point of view.

Regards,
Vlad

Christoph Hellwig wrote:
> The VFS doesn't use i_blocks, it's only used by generic_fillattr and
> the generic quota code which XFS doesn't use.  In XFS there is one use
> to check whether we have an inline or out of line sumlink, but we can
> replace that with a check of the XFS_IFINLINE inode flag.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-11-30 10:14:10.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-11-30 10:18:38.000000000 +0100
> @@ -2503,11 +2503,6 @@ xfs_dm_punch_hole(
>  	 */
>  	if (!error && (len == 0)) {
>  		error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_NOLOCK);
> -		if (!error) {
> -			/* Update linux inode block count after free above */
> -			inode->i_blocks = XFS_FSB_TO_BB(mp,
> -				ip->i_d.di_nblocks + ip->i_delayed_blks);
> -		}
>  	}
>  
>  	/*
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-11-30 10:15:48.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-11-30 10:18:38.000000000 +0100
> @@ -202,9 +202,6 @@ xfs_validate_fields(
>  	loff_t size;
>  
>  	inode->i_nlink = ip->i_d.di_nlink;
> -	inode->i_blocks =
> -		XFS_FSB_TO_BB(ip->i_mount, ip->i_d.di_nblocks +
> -					   ip->i_delayed_blks);
>  	/* we're under i_sem so i_size can't change under us */
>  	size = XFS_ISIZE(ip);
>  	if (i_size_read(inode) != size)
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-11-30 10:15:48.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-11-30 10:18:38.000000000 +0100
> @@ -568,7 +568,7 @@ xfs_set_inodeops(
>  		break;
>  	case S_IFLNK:
>  		inode->i_op = &xfs_symlink_inode_operations;
> -		if (inode->i_blocks)
> +		if (!(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE))
>  			inode->i_mapping->a_ops = &xfs_address_space_operations;
>  		break;
>  	default:
> @@ -605,8 +605,6 @@ xfs_revalidate_inode(
>  
>  	inode->i_generation = ip->i_d.di_gen;
>  	i_size_write(inode, ip->i_d.di_size);
> -	inode->i_blocks =
> -		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
>  	inode->i_atime.tv_sec	= ip->i_d.di_atime.t_sec;
>  	inode->i_atime.tv_nsec	= ip->i_d.di_atime.t_nsec;
>  	inode->i_mtime.tv_sec	= ip->i_d.di_mtime.t_sec;
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2007-11-30 10:14:10.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2007-11-30 10:18:38.000000000 +0100
> @@ -106,8 +106,6 @@ vn_revalidate(
>  	inode->i_nlink	    = ip->i_d.di_nlink;
>  	inode->i_uid	    = ip->i_d.di_uid;
>  	inode->i_gid	    = ip->i_d.di_gid;
> -	inode->i_blocks	    =
> -		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
>  	inode->i_mtime.tv_sec = ip->i_d.di_mtime.t_sec;
>  	inode->i_mtime.tv_nsec = ip->i_d.di_mtime.t_nsec;
>  	inode->i_ctime.tv_sec = ip->i_d.di_ctime.t_sec;
> Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-11-30 10:14:10.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-11-30 10:18:38.000000000 +0100
> @@ -1557,9 +1557,6 @@ xfs_release(
>  			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
>  			if (error)
>  				return error;
> -			/* Update linux inode block count after free above */
> -			vn_to_inode(vp)->i_blocks = XFS_FSB_TO_BB(mp,
> -				ip->i_d.di_nblocks + ip->i_delayed_blks);
>  		}
>  	}
>  
> @@ -1633,9 +1630,6 @@ xfs_inactive(
>  			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
>  			if (error)
>  				return VN_INACTIVE_CACHE;
> -			/* Update linux inode block count after free above */
> -			vn_to_inode(vp)->i_blocks = XFS_FSB_TO_BB(mp,
> -				ip->i_d.di_nblocks + ip->i_delayed_blks);
>  		}
>  		goto out;
>  	}
>
>   
