Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 01:16:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5O8GUkq006173
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 01:16:30 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B4AA26EBFB
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 01:17:30 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id GOLOfFtv2DPnDfIv for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 01:17:30 -0700 (PDT)
Date: Tue, 24 Jun 2008 10:17:19 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] don't update mtime on rename source
Message-ID: <20080624081719.GA31440@lst.de>
References: <20080624081348.GA31048@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624081348.GA31048@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: mj@mjturner.net

Sorry for the missing subject, should be the one in this mail

On Tue, Jun 24, 2008 at 10:13:48AM +0200, Christoph Hellwig wrote:
> As reported by Michael-John Turner XFS updates the mtime on the source
> inode of a rename call in case it's a directory and changes the parent.
> 
> This doesn't make any sense, is not mentioned in the standards and not
> performed by any other Linux filesystems so remove it.
> 
> 
> (resending this as it might have been lost in the previous thread)
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2008-06-18 18:24:38.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2008-06-18 18:30:17.000000000 +0200
> @@ -336,22 +336,18 @@ xfs_rename(
>  		ASSERT(error != EEXIST);
>  		if (error)
>  			goto abort_return;
> -		xfs_ichgtime(src_ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> -
> -	} else {
> -		/*
> -		 * We always want to hit the ctime on the source inode.
> -		 * We do it in the if clause above for the 'new_parent &&
> -		 * src_is_directory' case, and here we get all the other
> -		 * cases.  This isn't strictly required by the standards
> -		 * since the source inode isn't really being changed,
> -		 * but old unix file systems did it and some incremental
> -		 * backup programs won't work without it.
> -		 */
> -		xfs_ichgtime(src_ip, XFS_ICHGTIME_CHG);
>  	}
>  
>  	/*
> +	 * We always want to hit the ctime on the source inode.
> +	 *
> +	 * This isn't strictly required by the standards since the source
> +	 * inode isn't really being changed, but old unix file systems did
> +	 * it and some incremental backup programs won't work without it.
> +	 */
> +	xfs_ichgtime(src_ip, XFS_ICHGTIME_CHG);
> +
> +	/*
>  	 * Adjust the link count on src_dp.  This is necessary when
>  	 * renaming a directory, either within one parent when
>  	 * the target existed, or across two parent directories.
---end quoted text---
