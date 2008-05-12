Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 May 2008 18:43:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4C1hKAn008284
	for <xfs@oss.sgi.com>; Sun, 11 May 2008 18:43:23 -0700
Date: Mon, 12 May 2008 11:43:50 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/10] merge xfs_unmount into xfs_fs_put_super / xfs_fs_fill_super
Message-ID: <20080512014350.GQ103491721@sgi.com>
References: <20080501220048.GA2315@lst.de> <20080509063158.GA25251@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509063158.GA25251@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, May 09, 2008 at 08:31:58AM +0200, Christoph Hellwig wrote:
> Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.h	2008-05-09 08:16:55.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_vfsops.h	2008-05-09 08:26:11.000000000 +0200
> @@ -10,7 +10,6 @@ struct xfs_mount_args;
>  
>  int xfs_mount(struct xfs_mount *mp, struct xfs_mount_args *args,
>  		struct cred *credp);
> -int xfs_unmount(struct xfs_mount *mp, int flags, struct cred *credp);
>  int xfs_sync(struct xfs_mount *mp, int flags);
>  void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
>  		int lnnum);

This hunk does not apply - xfs_mntupdate() is defined in this file in
the current tree.

<sigh>

Oh, this is on top a bunch of other patches you sent a while back
that no-one has picked up. I'll go get those now....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
