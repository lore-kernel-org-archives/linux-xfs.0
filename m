Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 15:38:31 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1INcNTx005263
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 15:38:27 -0800
Message-ID: <47BA16CC.7040700@sgi.com>
Date: Tue, 19 Feb 2008 10:37:48 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [patch] Don't change ctime in truncate is size does not change
References: <20080218233251.GV155407@sgi.com>
In-Reply-To: <20080218233251.GV155407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Did we ever discover what was behind the comment:
"Have to do this even if the file's size doesn't change"

Cheers
-- Mark

David Chinner wrote:
> XFS changes the c/mtime of an inode when truncating it to the same
> size. The c/mtime is only supposed to change if the size is changed.
> Not to be confused with ftruncate, where the c/mtime is supposed to
> be changed even if the size is not changed.
> 
> The Linux VFS encodes this semantic difference in the flags it sends
> down to ->setattr, which XFS currently ignores. We need to make XFS
> pay attention to the VFS flags and hence Do The Right Thing.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/xfs_vnodeops.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2008-01-25 16:03:23.654971763 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2008-01-25 16:10:30.875397129 +1100
> @@ -634,6 +634,15 @@ xfs_setattr(
>  	 * Truncate file.  Must have write permission and not be a directory.
>  	 */
>  	if (mask & XFS_AT_SIZE) {
> +		/*
> +		 * Only change the c/mtime if we are changing the size
> +		 * or we are explicitly asked to change it. This handles
> +		 * the semantic difference between truncate() and ftruncate()
> +		 * as implemented in the VFS.
> +		 */
> +		if (vap->va_size != ip->i_size || mask & XFS_AT_CTIME)
> +			timeflags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
> +
>  		if (vap->va_size > ip->i_size) {
>  			xfs_igrow_finish(tp, ip, vap->va_size,
>  			    !(flags & ATTR_DMI));
> @@ -662,10 +671,6 @@ xfs_setattr(
>  			 */
>  			xfs_iflags_set(ip, XFS_ITRUNCATED);
>  		}
> -		/*
> -		 * Have to do this even if the file's size doesn't change.
> -		 */
> -		timeflags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
>  	}
>  
>  	/*

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
