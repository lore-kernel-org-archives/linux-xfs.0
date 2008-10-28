Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 00:18:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S7HucX029424
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:17:57 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 661C21B6689F
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:17:55 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id CQ4Gzqv1JR5tBhE7 for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:17:55 -0700 (PDT)
Date: Tue, 28 Oct 2008 18:17:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] split up xlog_recover_process_iunlinks
Message-ID: <20081028071750.GV4985@disturbed>
References: <20081027133938.GH1109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133938.GH1109@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:39:38AM -0400, Christoph Hellwig wrote:
> Split out the body of the main loop into a separate helper to make the
> code readable.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

.....

> Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-10-25 13:22:29.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-10-25 13:26:44.000000000 +0200
> @@ -3147,6 +3147,70 @@ out_error:
>  	return;
>  }
>  
> +STATIC xfs_agino_t
> +xlog_recover_process_one_iunlink(
> +	struct xfs_mount		*mp,
> +	xfs_agnumber_t			agno,
> +	xfs_agino_t			agino,
> +	int				bucket)
> +{
> +	struct xfs_buf			*ibp;
> +	struct xfs_dinode		*dip;
> +	struct xfs_inode		*ip;
> +	xfs_ino_t			ino;
> +	int				error;
> +
> +	ino = XFS_AGINO_TO_INO(mp, agno, agino);
> +	error = xfs_iget(mp, NULL, ino, 0, 0, &ip, 0);
> +	if (error)
> +		goto fail;
> +
> +	/*
> +	 * Get the on disk inode to find the next inode in the bucket.
> +	 */
> +	ASSERT(ip != NULL);
> +	error = xfs_itobp(mp, NULL, ip, &dip, &ibp, 0, 0, XFS_BUF_LOCK);
> +	if (error)
> +		goto fail;

Jumping to 'fail' at this point leaks the xfs_inode returned from
xfs_iget(). Hmmmm - it appears the original code leaked too....

Also, I don't think we need the assert for ip, either.  If it's NULL
then we'll panic immediately on entering xfs_itobp().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
