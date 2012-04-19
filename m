Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3JKwikt118839 for <xfs@oss.sgi.com>; Thu, 19 Apr 2012 15:58:44 -0500
Date: Thu, 19 Apr 2012 16:00:44 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/5] xfs: reduce ilock hold times in xfs_setattr_size
Message-ID: <20120419210044.GF16881@sgi.com>
References: <20120327143445.196524266@bombadil.infradead.org>
	<20120327143826.615954651@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327143826.615954651@bombadil.infradead.org>
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

On Tue, Mar 27, 2012 at 10:34:48AM -0400, Christoph Hellwig wrote:
> We do not need the ilock for most checks done in the beginning of
> xfs_setattr_size.  Replace the long critical section before starting the
> transaction with a smaller one around xfs_zero_eof and an optional one
> inside xfs_qm_dqattach that isn't entered unless using quotas.  While
> this isn't a big optimization for xfs_setattr_size itself it will allow
> pushing the ilock into xfs_zero_eof itself later.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_iops.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_iops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iops.c	2012-03-26 15:17:47.088854526 +0200
> +++ xfs/fs/xfs/xfs_iops.c	2012-03-26 15:17:57.265521382 +0200
> @@ -700,7 +700,7 @@ xfs_setattr_size(
>  	xfs_off_t		oldsize, newsize;
>  	struct xfs_trans	*tp;
>  	int			error;
> -	uint			lock_flags;
> +	uint			lock_flags = 0;
>  	uint			commit_flags = 0;
>  
>  	trace_xfs_setattr(ip);
> @@ -720,10 +720,10 @@ xfs_setattr_size(
>  			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
>  			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
>  
> -	lock_flags = XFS_ILOCK_EXCL;
> -	if (!(flags & XFS_ATTR_NOLOCK))
> +	if (!(flags & XFS_ATTR_NOLOCK)) {
>  		lock_flags |= XFS_IOLOCK_EXCL;
> -	xfs_ilock(ip, lock_flags);
> +		xfs_ilock(ip, lock_flags);
> +	}
>  
>  	oldsize = inode->i_size;
>  	newsize = iattr->ia_size;

Usually the ilock is taken to protect i_d.di_nextents.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
