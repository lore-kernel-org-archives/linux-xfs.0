Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 19:48:34 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M3mRCv029690
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 19:48:30 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D14E6E8ED01
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 19:48:52 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id kPLfHwQovHKNpkEC for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 19:48:52 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m1M3mjF3005425
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 04:48:45 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m1M3mjxo005423
	for xfs@oss.sgi.com; Fri, 22 Feb 2008 04:48:45 +0100
Date: Fri, 22 Feb 2008 04:48:45 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove superflous xfs_readsb call in xfs_mountfs
Message-ID: <20080222034845.GA5354@lst.de>
References: <20071218174829.GA3195@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218174829.GA3195@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Tue, Dec 18, 2007 at 06:48:29PM +0100, Christoph Hellwig wrote:
> When xfs_mountfs is called by xfs_mount xfs_readsb was called 35 lines
> above unconditionally, so there is no need to try to read the superblock
> if it's not present.  If any other port doesn't have the superblock
> read at this point it should just call it directly from it's xfs_mount
> equivalent.

Ping?

> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2007-12-17 14:34:57.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2007-12-17 14:35:17.000000000 +0100
> @@ -968,11 +968,6 @@ xfs_mountfs(
>  	int		uuid_mounted = 0;
>  	int		error = 0;
>  
> -	if (mp->m_sb_bp == NULL) {
> -		error = xfs_readsb(mp, mfsi_flags);
> -		if (error)
> -			return error;
> -	}
>  	xfs_mount_common(mp, sbp);
>  
>  	/*
---end quoted text---
