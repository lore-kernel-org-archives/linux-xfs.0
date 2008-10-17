Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 17:09:29 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9H09PYF013499
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 17:09:26 -0700
Message-ID: <48F7D814.2080705@sgi.com>
Date: Fri, 17 Oct 2008 11:11:00 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: XFS_ERROR use - was Re: [PATCH] prevent NULL returns from d_obtain_alias
References: <20081015192839.GA867@lst.de> <E1KqWzC-00087u-TG@pomaz-ex.szeredi.hu> <20081016180947.GA26285@lst.de>
In-Reply-To: <20081016180947.GA26285@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Oct 16, 2008 at 07:50:10PM +0200, Miklos Szeredi wrote:
>> should be
>>
>>   		return -XFS_ERROR(-PTR_ERR(dentry));
> 
> No need for XFS_ERROR at all here, it's only used for error injection in
> low-level code.  Updated version that propagates the error below:
> 
> (Al, if you rebase vfs.git this should probably be folded into the patch
> that switches over to d_obtain_alias)
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

[...stuff deleted]

> Index: vfs-2.6/fs/xfs/linux-2.6/xfs_ioctl.c
> ===================================================================
> --- vfs-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-10-15 21:26:33.000000000 +0200
> +++ vfs-2.6/fs/xfs/linux-2.6/xfs_ioctl.c	2008-10-16 20:06:20.000000000 +0200
> @@ -312,9 +312,9 @@ xfs_open_by_handle(
>  	}
>  
>  	dentry = d_obtain_alias(inode);
> -	if (dentry == NULL) {
> +	if (IS_ERR(dentry)) {
>  		put_unused_fd(new_fd);
> -		return -XFS_ERROR(ENOMEM);
> +		return PTR_ERR(dentry);
>  	}
>  
>  	/* Ensure umount returns EBUSY on umounts while this file is open. */
> --

Fair enough.
But XFS_ERROR is used throughout the function.
I've found the whole idea of when and when not to use XFS_ERROR annoying :)

I've never used it (other than calling it to stay consistent with the code).
Looking at the code, it is used to BUG and print a msg on particular error codes set in xfs_etrap[] -
and it does this in xfs_error_trap().
Can one not decide to do this at any error point?
I can't see where we hook in to set up xfs_etrap.

> #ifdef DEBUG
> #define XFS_ERROR_NTRAP 10
> extern int      xfs_etrap[XFS_ERROR_NTRAP];
> extern int      xfs_error_trap(int);
> #define XFS_ERROR(e)    xfs_error_trap(e)
> #else
> #define XFS_ERROR(e)    (e)
> #endif


Cheers,
Tim.
