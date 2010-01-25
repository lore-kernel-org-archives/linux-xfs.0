Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0PBq636052236 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 05:52:06 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E9274135DD40
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 03:53:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GiDWs9Lt1ScEMR1a for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2010 03:53:09 -0800 (PST)
Date: Mon, 25 Jan 2010 06:53:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] xfs: Use delayed write for inodes rather than async
Message-ID: <20100125115308.GC8595@infradead.org>
References: <1264400564-19704-1-git-send-email-david@fromorbit.com>
	<1264400564-19704-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1264400564-19704-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index 98b8937..ca0cc59 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c
> @@ -270,8 +270,7 @@ xfs_sync_inode_attr(
>  		goto out_unlock;
>  	}
>  
> -	error = xfs_iflush(ip, (flags & SYNC_WAIT) ?
> -			   XFS_IFLUSH_SYNC : XFS_IFLUSH_DELWRI);
> +	error = xfs_iflush(ip, (flags & SYNC_WAIT));

No need for the masking here, as xfs_iflush simply ignores SYNC_TRYLOCK.

>  	/* Now we have an inode that needs flushing */
>  	error = xfs_iflush(ip, sync_mode);
> +	if (!(sync_mode & SYNC_WAIT))
> +		goto requeue_no_flock;

So for the !wait case we entirely ignore the return value?  We should
at least check for an I/O error here I think.  Also in this context
the requeue label name doesn't fit too well, even if it's the same
action as the requeue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
