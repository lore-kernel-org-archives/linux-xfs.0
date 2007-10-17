Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 02:09:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9H98s8p011344
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 02:08:56 -0700
Date: Wed, 17 Oct 2007 19:08:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] flush inode when changing atime.
Message-ID: <20071017090844.GZ995458@sgi.com>
References: <200710170456.AA06101@TNESG9305.wm.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710170456.AA06101@TNESG9305.wm.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 17, 2007 at 01:56:00PM +0900, Utako Kusaka wrote:
> Hi,
> 
> The atime is changed for reading but it returns to a previous value
> after unmount. i_update_core is still off after reading a file using
> read(), readdir() and readlink(). So an inode isn't flushed to disk.

I think this was done by design - Christoph? I can't remember exactly
as it was more than two years ago this change was made. It is effectively
equivalent to using the relatime mount option.

The question is whether we want to change the default behaviour or
whether we need to supply an "atimeisatime" mount option for those
that really need atime to be updated on every access.

> I referred to following fix when I made a patch:
> TAKE 946679 - fix, speedup and simplify atime handling
> http://marc.info/?l=linux-xfs&m=113398234310217&w=4

Yes, that was the patch that removed the explicit atime updates
in the XFS code. Your fix is reverting part of that change.

> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-10-15 15:50:10.000000000 +0900
> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-10-15 16:49:35.000000000 +0900
> @@ -1003,6 +1003,8 @@ xfs_readlink(
>  		error = xfs_readlink_bmap(ip, link);
>  	}
>  
> +	ip->i_update_core = 1;
> +

If we are going to put these back in, then they should be
calls to xfs_ichgtime_fast() so that we know what the reason
for marking the core dirty is.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
