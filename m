Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB32Yuja007031 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 20:34:57 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1438D1664BF7
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 18:34:55 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	ebzFvap36RSD3zdx for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2008 18:34:55 -0800 (PST)
Date: Wed, 3 Dec 2008 13:29:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 05/22] cleanup the inode reclaim path
Message-ID: <20081203022950.GD18236@disturbed>
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160650.198364000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081202160650.198364000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Tue, Dec 02, 2008 at 11:04:35AM -0500, Christoph Hellwig wrote:
> Merge xfs_iextract and xfs_idestory into xfs_ireclaim as they are never
                         xfs_idestroy
> called individually.  Also rewrite most comments in this area as they
> were serverly out of date.
       severely

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs-master/fs/xfs/xfs_iget.c
> ===================================================================
> --- xfs-master.orig/fs/xfs/xfs_iget.c	2008-12-01 19:26:04.000000000 +0100
> +++ xfs-master/fs/xfs/xfs_iget.c	2008-12-01 19:27:15.000000000 +0100
> @@ -450,65 +450,109 @@ xfs_iput_new(
>  	IRELE(ip);
>  }
>  
> -
>  /*
> - * This routine embodies the part of the reclaim code that pulls
> - * the inode from the inode hash table and the mount structure's
> - * inode list.
> - * This should only be called from xfs_reclaim().
> + * This is called free all the memory associated with an inode.
    * xfs_ireclaim is called to free....

> + * It must free the inode itself and any buffers allocated for
> + * if_extents/if_data and if_broot.  It must also free the lock
> + * associated with the inode.
> + *
> + * Note: because we don't initialise everything on reallocation out
> + * of the zone, we must ensure we nullify everything correctly before
> + * freeing the structure.
>   */
>  void
> -xfs_ireclaim(xfs_inode_t *ip)
> +xfs_ireclaim(
> +	struct xfs_inode	*ip)
>  {
> -	/*
> -	 * Remove from old hash list and mount list.
> -	 */
> -	XFS_STATS_INC(xs_ig_reclaims);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_perag	*pag;
>  
> -	xfs_iextract(ip);
> +	XFS_STATS_INC(xs_ig_reclaims);
>  
>  	/*
> -	 * Here we do a spurious inode lock in order to coordinate with inode
> -	 * cache radix tree lookups.  This is because the lookup can reference
> -	 * the inodes in the cache without taking references.  We make that OK
> -	 * here by ensuring that we wait until the inode is unlocked after the
> -	 * lookup before we go ahead and free it.  We get both the ilock and
> -	 * the iolock because the code may need to drop the ilock one but will
> -	 * still hold the iolock.
> +	 * Remove the inode from the per-AG radix tree.  It doesn't matter
> +	 * if it was never added to it because radix_tree_delete can deal
> +	 * with that case just fine.
>  	 */
> -	xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	pag = xfs_get_perag(mp, ip->i_ino);
> +	write_lock(&pag->pag_ici_lock);
> +	radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino));
> +	write_unlock(&pag->pag_ici_lock);
> +	xfs_put_perag(mp, pag);
>  
>  	/*
> -	 * Release dquots (and their references) if any. An inode may escape
> -	 * xfs_inactive and get here via vn_alloc->vn_reclaim path.
> +	 * Here we do an (almost) spurious inode lock in order to coordinate
> +	 * with inode cache radix tree lookups.  This is because the lookup
> +	 * can reference the inodes in the cache without taking references.
> +	 *
> +	 * We make that OK here by ensuring that we wait until the inode is
> +	 * unlocked after the lookup before we go ahead and free it.  We get
> +	 * both the ilock and the iolock because the code may need to drop the
> +	 * ilock one but will still hold the iolock.
>  	 */

Hmmm - I need to check if this is still true. We now use igrab() to
get a reference on all lookups except the reclaim lookup. In the
case of a racing reclaim lookup, we check for the reclaim
flags on the inode after the lookup but before we try to lock the
inode. Hence this lock check probably doesn't do anything anymore,
but I need to look a bit closer....

Other than the typos, the code looks ok, so:

Reviewed-by: Dave Chinner <david@fromorbit.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
