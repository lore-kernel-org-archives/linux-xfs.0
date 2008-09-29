Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 00:43:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8T7hFC2018404
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 00:43:15 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62048490E8E
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 00:44:51 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Q3cFao7TfiiE80qG for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 00:44:51 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8T7ioIF023910
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 09:44:50 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8T7ioa1023908
	for xfs@oss.sgi.com; Mon, 29 Sep 2008 09:44:50 +0200
Date: Mon, 29 Sep 2008 09:44:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH][mainline-only] remove useless mnt_want_write call in xfs_write
Message-ID: <20080929074450.GB23785@lst.de>
References: <20080814212551.GA20980@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814212551.GA20980@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Any chance to get this into the git tree for the first 2.6.28 pull?

On Thu, Aug 14, 2008 at 11:25:51PM +0200, Christoph Hellwig wrote:
> When mnt_want_write was introduced a call to it was added around
> xfs_ichgtime, but there is no need for this because a file can't be open
> read/write on a r/o mount, and a mount can't degrade r/o while we still
> have files open for writing.  As the mnt_want_write changes were never
> merged into the CVS tree this patch is for mainline only.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> --- linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c	2008-08-14 14:52:15.000000000 -0300
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2008-08-14 14:54:53.000000000 -0300
> @@ -51,7 +51,6 @@
>  #include "xfs_vnodeops.h"
>  
>  #include <linux/capability.h>
> -#include <linux/mount.h>
>  #include <linux/writeback.h>
>  
>  
> @@ -668,15 +667,8 @@ start:
>  	if (new_size > xip->i_size)
>  		xip->i_new_size = new_size;
>  
> -	/*
> -	 * We're not supposed to change timestamps in readonly-mounted
> -	 * filesystems.  Throw it away if anyone asks us.
> -	 */
> -	if (likely(!(ioflags & IO_INVIS) &&
> -		   !mnt_want_write(file->f_path.mnt))) {
> +	if (likely(!(ioflags & IO_INVIS)))
>  		xfs_ichgtime(xip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> -		mnt_drop_write(file->f_path.mnt);
> -	}
>  
>  	/*
>  	 * If the offset is beyond the size of the file, we have a couple
---end quoted text---
