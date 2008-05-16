Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 May 2008 00:22:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4G7MBsm030605
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 00:22:17 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A20AB6DBDE
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 00:22:59 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 0ZJQLIBypJr2ftsg for <xfs@oss.sgi.com>; Fri, 16 May 2008 00:22:59 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4G7MpF3001133
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 09:22:52 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4G7MpvY001131
	for xfs@oss.sgi.com; Fri, 16 May 2008 09:22:51 +0200
Date: Fri, 16 May 2008 09:22:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill xfs_uuid_unmount
Message-ID: <20080516072251.GB1052@lst.de>
References: <20080426200923.GA14172@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426200923.GA14172@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Sat, Apr 26, 2008 at 10:09:23PM +0200, Christoph Hellwig wrote:
> Quite useless wrapper that doesn't help making the code more readable.

ping?

> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-04-25 20:40:50.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-04-25 20:48:27.000000000 +0200
> @@ -47,7 +47,6 @@
>  
>  STATIC int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
>  STATIC int	xfs_uuid_mount(xfs_mount_t *);
> -STATIC void	xfs_uuid_unmount(xfs_mount_t *mp);
>  STATIC void	xfs_unmountfs_wait(xfs_mount_t *);
>  
>  
> @@ -1262,7 +1261,7 @@ xfs_mountfs(
>  	/* FALLTHROUGH */
>   error1:
>  	if (uuid_mounted)
> -		xfs_uuid_unmount(mp);
> +		uuid_table_remove(&mp->m_sb.sb_uuid);
>  	xfs_freesb(mp);
>  	return error;
>  }
> @@ -1343,7 +1342,7 @@ xfs_unmountfs(xfs_mount_t *mp, struct cr
>  
>  	xfs_unmountfs_close(mp, cr);
>  	if ((mp->m_flags & XFS_MOUNT_NOUUID) == 0)
> -		xfs_uuid_unmount(mp);
> +		uuid_table_remove(&mp->m_sb.sb_uuid);
>  
>  #if defined(DEBUG) || defined(INDUCE_IO_ERROR)
>  	xfs_errortag_clearall(mp, 0);
> @@ -1905,16 +1904,6 @@ xfs_uuid_mount(
>  }
>  
>  /*
> - * Remove filesystem from the UUID table.
> - */
> -STATIC void
> -xfs_uuid_unmount(
> -	xfs_mount_t	*mp)
> -{
> -	uuid_table_remove(&mp->m_sb.sb_uuid);
> -}
> -
> -/*
>   * Used to log changes to the superblock unit and width fields which could
>   * be altered by the mount options, as well as any potential sb_features2
>   * fixup. Only the first superblock is updated.
---end quoted text---
