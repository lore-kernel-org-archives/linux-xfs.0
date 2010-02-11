Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1BN8mns188095 for <xfs@oss.sgi.com>; Thu, 11 Feb 2010 17:08:48 -0600
Subject: Re: [PATCH] xfs: optimize log flushing in xfs_fsync
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100205095755.GA30848@infradead.org>
References: <20100205095755.GA30848@infradead.org>
Date: Thu, 11 Feb 2010 17:10:00 -0600
Message-ID: <1265929800.2793.30.camel@doink1>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Fri, 2010-02-05 at 04:57 -0500, Christoph Hellwig wrote:
> If we have a pinned inode it must have a log item attached to it.
> Usually that log item will have ili_last_lsn already set, in which
> case we only need to flush the log up to that LSN instead of doing
> a full log force.  This gives speedups of about 5% in some fsync
> heavy workloads.

This looks good.  I was going to suggest:
    ASSERT(ip->i_itemp != NULL);
before it's dereferenced, but a pinned inode had better
have an item pointer...

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_vnodeops.c	2010-02-04 17:38:33.679254119 +0100
> +++ xfs/fs/xfs/xfs_vnodeops.c	2010-02-04 17:38:51.606006156 +0100
> @@ -626,8 +626,14 @@ xfs_fsync(
>  		 * force the log.
>  		 */
>  		if (xfs_ipincount(ip)) {
> -			error = _xfs_log_force(ip->i_mount, XFS_LOG_SYNC,
> -					       &log_flushed);
> +			if (ip->i_itemp->ili_last_lsn) {
> +				error = _xfs_log_force_lsn(ip->i_mount,
> +						ip->i_itemp->ili_last_lsn,
> +						XFS_LOG_SYNC, &log_flushed);
> +			} else {
> +				error = _xfs_log_force(ip->i_mount,
> +						XFS_LOG_SYNC, &log_flushed);
> +			}
>  		}
>  	} else	{
>  		/*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
