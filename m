Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAK7xKDp136870 for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 01:59:20 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD1D4265546
	for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 23:59:19 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	CwunWIVj7q8NFywY for <xfs@oss.sgi.com>;
	Sat, 19 Nov 2011 23:59:19 -0800 (PST)
Date: Sun, 20 Nov 2011 02:59:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: force buffer writeback before blocking on the ilock
	in inode reclaim
Message-ID: <20111120075918.GA19393@infradead.org>
References: <20111120072334.GA27386@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111120072334.GA27386@infradead.org>
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
To: xfs@oss.sgi.com
Cc: Simon Kirby <sim@hostway.ca>

I should probably keep Simon on Cc for this one..

On Sun, Nov 20, 2011 at 02:23:34AM -0500, Christoph Hellwig wrote:
> If we are doing synchronous inode reclaim we block the VM from making
> progress in memory reclaim.  So if we encouter a flush locked inode
> make sure we force out all delayed buffers ASAP to speed up the wait
> for it to be unlocked.  Without this we can get hangs of up to 30
> seconds during workloads hitting synchronous inode reclaim.
> 
> Reported-by: Simon Kirby <sim@hostway.ca>
> Tested-by: Simon Kirby <sim@hostway.ca>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_sync.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_sync.c	2011-11-19 20:14:52.110141228 +0100
> +++ xfs/fs/xfs/xfs_sync.c	2011-11-19 20:40:17.381878121 +0100
> @@ -762,7 +762,8 @@ xfs_reclaim_inode(
>  	struct xfs_perag	*pag,
>  	int			sync_mode)
>  {
> -	int	error;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	int			error;
>  
>  restart:
>  	error = 0;
> @@ -770,12 +771,25 @@ restart:
>  	if (!xfs_iflock_nowait(ip)) {
>  		if (!(sync_mode & SYNC_WAIT))
>  			goto out;
> +
> +		/*
> +		 * If we only have a single dirty inode in a cluster there is
> +		 * a fair chance that the AIL push may have pushed it into
> +		 * the buffer, but xfsbufd won't touch it until 30 seconds
> +		 * from now, and thus we will lock up here.
> +		 *
> +		 * Wakeup xfsbufd now, and force it to write back even
> +		 * recently dirtied buffers.
> +		 */
> +		set_bit(XBT_FORCE_FLUSH, &mp->m_ddev_targp->bt_flags);
> +		wake_up_process(mp->m_ddev_targp->bt_task);
> +
>  		xfs_iflock(ip);
>  	}
>  
>  	if (is_bad_inode(VFS_I(ip)))
>  		goto reclaim;
> -	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
> +	if (XFS_FORCED_SHUTDOWN(mp)) {
>  		xfs_iunpin_wait(ip);
>  		goto reclaim;
>  	}
> @@ -829,8 +843,8 @@ restart:
>  	 * is permanent then the next sync reclaim will reclaim the inode and
>  	 * pass on the error.
>  	 */
> -	if (error && error != EAGAIN && !XFS_FORCED_SHUTDOWN(ip->i_mount)) {
> -		xfs_warn(ip->i_mount,
> +	if (error && error != EAGAIN && !XFS_FORCED_SHUTDOWN(mp)) {
> +		xfs_warn(mp,
>  			"inode 0x%llx background reclaim flush failed with %d",
>  			(long long)ip->i_ino, error);
>  	}
> @@ -860,7 +874,7 @@ reclaim:
>  	 */
>  	spin_lock(&pag->pag_ici_lock);
>  	if (!radix_tree_delete(&pag->pag_ici_root,
> -				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino)))
> +				XFS_INO_TO_AGINO(mp, ip->i_ino)))
>  		ASSERT(0);
>  	__xfs_inode_clear_reclaim(pag, ip);
>  	spin_unlock(&pag->pag_ici_lock);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
