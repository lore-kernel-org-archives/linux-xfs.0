Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 18:46:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5C1k9Wt030893
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 18:46:10 -0700
Date: Tue, 12 Jun 2007 11:45:58 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] fix 32bit build
Message-ID: <20070612014558.GL86004887@sgi.com>
References: <20070609102637.GA23294@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070609102637.GA23294@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sat, Jun 09, 2007 at 12:26:37PM +0200, Christoph Hellwig wrote:
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2007-06-09 11:20:51.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2007-06-09 11:21:43.000000000 +0200
> @@ -1154,7 +1154,9 @@ xfs_mountfs(
>  	 * This may drive us straight to ENOSPC on mount, but that implies
>  	 * we were already there on the last unmount.
>  	 */
> -	resblks = min_t(__uint64_t, mp->m_sb.sb_dblocks / 20, 1024);
> +	resblks = mp->m_sb.sb_dblocks;
> +	do_div(resblks, 20);
> +	resblks = min_t(__uint64_t, resblks, 1024);
>  	xfs_reserve_blocks(mp, &resblks, NULL);
>  
>  	return 0;
> 

/me smacks forehead.

I'll get this sorted. Thanks, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
