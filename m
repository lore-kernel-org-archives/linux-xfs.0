Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4QKjicB160283 for <xfs@oss.sgi.com>; Tue, 26 May 2009 15:45:45 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8217B1A205AA
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 13:45:57 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id phcpjEpYC5goAE2D for <xfs@oss.sgi.com>;
	Tue, 26 May 2009 13:45:57 -0700 (PDT)
Message-ID: <4A1C54FB.2080705@sandeen.net>
Date: Tue, 26 May 2009 15:45:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/7] xfs: split inode flushing from xfs_sync_inodes_ag
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171558.298098000@bombadil.infradead.org>
In-Reply-To: <20090514171558.298098000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> In many cases we only want to sync inode metadata. Split out the inode
> flushing into a separate helper to prepare factoring the inode sync code.
> 
> Based on a patch from Dave Chinner, but redone to keep the current behaviour
> exactly and leave changes to the flushing logic to another patch.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-05-14 16:17:41.359813297 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-05-14 19:05:25.545684101 +0200
> @@ -76,6 +76,34 @@ xfs_sync_inode_data(
>  	return error;
>  }
>  
> +STATIC int
> +xfs_sync_inode_attr(
> +	struct xfs_inode	*ip,
> +	int			flags)
> +{
> +	int			error = 0;
> +
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	if (xfs_inode_clean(ip))
> +		goto out_unlock;
> +	if (!xfs_iflock_nowait(ip)) {
> +		if (!(flags & SYNC_WAIT))
> +			goto out_unlock;
> +		xfs_iflock(ip);
> +	}
> +
> +	if (xfs_inode_clean(ip)) {
> +		xfs_ifunlock(ip);
> +		goto out_unlock;
> +	}
> +
> +	error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
> +
> + out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +	return error;
> +}
> +
>  /*
>   * Sync all the inodes in the given AG according to the
>   * direction given by the flags.

...

> @@ -154,22 +181,10 @@ xfs_sync_inodes_ag(
>  		if (flags & SYNC_DELWRI)
>  			error = xfs_sync_inode_data(ip, flags);
>  
> -		xfs_ilock(ip, XFS_ILOCK_SHARED);
> -		if ((flags & SYNC_ATTR) && !xfs_inode_clean(ip)) {
> -			if (flags & SYNC_WAIT) {
> -				xfs_iflock(ip);
> -				if (!xfs_inode_clean(ip))
> -					error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
> -				else
> -					xfs_ifunlock(ip);
> -			} else if (xfs_iflock_nowait(ip)) {
> -				if (!xfs_inode_clean(ip))
> -					error = xfs_iflush(ip, XFS_IFLUSH_DELWRI);

What happened to the XFS_IFLUSH_DELWRI case?

You mentioned "keep the current behavior exactly" but this seems like a
change, no?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
