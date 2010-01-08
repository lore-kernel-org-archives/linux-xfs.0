Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08AZSai030808 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 04:35:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18793EE9A0E
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 02:36:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vQvbdZrNbFxVHFfB for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2010 02:36:21 -0800 (PST)
Date: Fri, 8 Jan 2010 05:36:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: Use delayed write for inodes rather than async
Message-ID: <20100108103620.GA11769@infradead.org>
References: <1262649861-28530-1-git-send-email-david@fromorbit.com>
	<1262649861-28530-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1262649861-28530-2-git-send-email-david@fromorbit.com>
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

> +++ b/fs/xfs/linux-2.6/xfs_sync.c
> @@ -460,8 +460,8 @@ xfs_quiesce_fs(
>  {
>  	int	count = 0, pincount;
>  
> +	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI);
>  	xfs_flush_buftarg(mp->m_ddev_targp, 0);
> -	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);

Hmm.  I think the current code here is simply wrong.  We do need to
flush all delwri buffers after the inode reclaim.  Maybe we should
get this hunk in for .33?

> -		xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
> +		xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI);
>  		/* dgc: errors ignored here */
>  		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
>  		error = xfs_sync_fsdata(mp, SYNC_TRYLOCK);
> @@ -687,7 +687,7 @@ xfs_reclaim_inode(
>  		spin_unlock(&ip->i_flags_lock);
>  		write_unlock(&pag->pag_ici_lock);
>  		xfs_perag_put(pag);
> -		return -EAGAIN;
> +		return EAGAIN;

Unrelated bug in the upsteam code.  But your inode direct reclaim
changes should sort this out already.

> @@ -3012,16 +3001,6 @@ xfs_iflush_int(
>  	iip = ip->i_itemp;
>  	mp = ip->i_mount;
>  
> -
> -	/*
> -	 * If the inode isn't dirty, then just release the inode
> -	 * flush lock and do nothing.
> -	 */
> -	if (xfs_inode_clean(ip)) {
> -		xfs_ifunlock(ip);
> -		return 0;
> -	}
> -

while we now have this check in xfs_reclaim_inode there still are
various other callers.  Did you audit them all to make sure we don't
need the check here anymore?

> index 223d9c3..16c4654 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1444,7 +1444,14 @@ xfs_unmountfs(
>  	 * need to force the log first.
>  	 */
>  	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
> -	xfs_reclaim_inodes(mp, XFS_IFLUSH_ASYNC);
> +
> +	/*
> +	 * flush the delwri buffers before the reclaim so that it doesn't
> +	 * block for a long time waiting to reclaim inodes that are already
> +	 * in the delwri state.
> +	 */
> +	XFS_bflush(mp->m_ddev_targp);
> +	xfs_reclaim_inodes(mp, XFS_IFLUSH_SYNC);

Wouldn't it be more efficient to also write them out delwri and then
flush out the delwri queue again?

Either way the current code seems fishy to me with an async writeout
here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
