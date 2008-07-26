Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 02:12:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q9CcSq020143
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:12:39 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 952BB331B7C
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:13:49 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id f1qaQztyxCskeYT2 for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:13:49 -0700 (PDT)
Date: Sat, 26 Jul 2008 19:13:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] stop using file_update_time
Message-ID: <20080726091348.GT5947@disturbed>
References: <20080726063339.GC22603@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726063339.GC22603@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sat, Jul 26, 2008 at 08:33:39AM +0200, Christoph Hellwig wrote:
> xfs_ichtime updates the xfs_inode and Linux inode timestamps just fine,
> no need to call file_update_time and then copy the values over to the
> XFS inode.  The only additional thing in file_update_time are checks
> not applicable to the write path.
.....

> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.h	2008-07-24 08:37:09.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h	2008-07-24 08:37:40.000000000 +0200
> @@ -26,9 +26,6 @@ extern const struct file_operations xfs_
>  
>  extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
>  
> -extern void xfs_ichgtime(struct xfs_inode *, int);
> -extern void xfs_ichgtime_fast(struct xfs_inode *, struct inode *, int);
> -

I don't think you meant to remove the xfs_ichgtime() prototype
as well...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
