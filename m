Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n77HPsIS144383 for <xfs@oss.sgi.com>; Fri, 7 Aug 2009 12:25:54 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45562AC01C
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2009 10:26:43 -0700 (PDT)
Message-Id: <24CFF78E-BB3F-47A1-8D6C-49EA198CCD94@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090804141834.526088000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 1/4] xfs: fix locking in xfs_iget_cache_hit
Date: Fri, 7 Aug 2009 12:25:47 -0500
References: <20090804141554.992235000@bombadil.infradead.org>
	<20090804141834.526088000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Aug 4, 2009, at 9:15 AM, Christoph Hellwig wrote:

> The locking in xfs_iget_cache_hit currently has numerous problems:
>
> - we clear the reclaim tag without i_flags_lock which protects  
> modifications
>   to it
> - we call inode_init_always which can sleep with pag_ici_lock held
> - we acquire and drop i_flags_lock a lot and thus provide no  
> consistency
>   between the various flags we set/clear under it
>
> This patch fixes all that with a major revamp of the locking in the  
> function.
> The new version acquires i_flags_lock early and only drops it once  
> we need to
> call into inode_init_always or before calling xfs_ilock.
>
> This patch fixes a bug seen in the wild where we race modifying the  
> reclaim tag.

Some comments below as well as couple of questions based on the
difference with previous code, not necessarily pointing to a
problem. Just trying to figure it out for myself.

>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6/fs/xfs/xfs_iget.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_iget.c	2009-08-01 23:20:54.775080254  
> +0200
> +++ linux-2.6/fs/xfs/xfs_iget.c	2009-08-01 23:20:54.807080483 +0200
> @@ -133,80 +133,90 @@ xfs_iget_cache_hit(
> 	int			flags,
> 	int			lock_flags) __releases(pag->pag_ici_lock)
> {
> +	struct inode		*inode = VFS_I(ip);
> 	struct xfs_mount	*mp = ip->i_mount;
> -	int			error = EAGAIN;
> +	int			error;
> +
> +	spin_lock(&ip->i_flags_lock);
>
> 	/*
> -	 * If INEW is set this inode is being set up
> -	 * If IRECLAIM is set this inode is being torn down
> -	 * Pause and try again.
> +	 * This inode is being torn down, pause and try again.
> 	 */
> -	if (xfs_iflags_test(ip, (XFS_INEW|XFS_IRECLAIM))) {
> +	if (ip->i_flags & XFS_IRECLAIM) {
> 		XFS_STATS_INC(xs_ig_frecycle);
> +		error = EAGAIN;
> 		goto out_error;
> 	}
>
> -	/* If IRECLAIMABLE is set, we've torn down the vfs inode part */
> -	if (xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
> +	/*
> +	 * If we are racing with another cache hit that is currently  
> recycling
> +	 * this inode out of the XFS_IRECLAIMABLE state, wait for the
> +	 * initialisation to complete before continuing.
> +	 */
> +	if (ip->i_flags & XFS_INEW) {

Another case when we find XFS_INEW set is the race with the
cache miss, which just set up a new inode. Would the proposed
code be still sensible in that case? If yes, at least comments
should be updated.

>
> +		spin_unlock(&ip->i_flags_lock);
> +		read_unlock(&pag->pag_ici_lock);
>
> -		/*
> -		 * If lookup is racing with unlink, then we should return an
> -		 * error immediately so we don't remove it from the reclaim
> -		 * list and potentially leak the inode.
> -		 */
> -		if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
> -			error = ENOENT;
> -			goto out_error;
> -		}
> +		XFS_STATS_INC(xs_ig_frecycle);
> +		wait_on_inode(inode);

It's possible to have XFS_INEW set, but no I_LOCK|I_NEW yet.
Then the wait_on_inode() would return quickly even before the
linux inode is reinitialized. Though, that was the case with
the old code as well.

>
> +		return EAGAIN;

This return seems inconsistent with usual goto end of function
convention. I understand that in this case goto out_error would
be incorrect. Should we create new label out_error_unlocked?

>
> +	}
>
> +	/*
> +	 * If lookup is racing with unlink, then we should return an
> +	 * error immediately so we don't remove it from the reclaim
> +	 * list and potentially leak the inode.
> +	 */
> +	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {

Previously the conclusion of the race with unlink was based on
XFS_IRECLAIMABLE i_flag set in addition to the test above.
Is is no longer a case, or not really necessary?

>
> +		error = ENOENT;
> +		goto out_error;
> +	}
> +
> +	/*
> +	 * If IRECLAIMABLE is set, we've torn down the VFS inode already.
> +	 * Need to carefully get it back into useable state.
> +	 */
> +	if (ip->i_flags & XFS_IRECLAIMABLE) {
> 		xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
>
> 		/*
> -		 * We need to re-initialise the VFS inode as it has been
> -		 * 'freed' by the VFS. Do this here so we can deal with
> -		 * errors cleanly, then tag it so it can be set up correctly
> -		 * later.
> +		 * We need to set XFS_INEW atomically with clearing the
> +		 * reclaimable tag so that we do have an indicator of the
> +		 * inode still being initialized.
> 		 */
> -		if (!inode_init_always(mp->m_super, VFS_I(ip))) {
> +		ip->i_flags |= XFS_INEW;
> +		__xfs_inode_clear_reclaim_tag(pag, ip);
> +
> +		spin_unlock(&ip->i_flags_lock);
> +		read_unlock(&pag->pag_ici_lock);
> +
> +		if (unlikely(!inode_init_always(mp->m_super, inode))) {
> +			/*
> +			 * Re-initializing the inode failed, and we are in deep
> +			 * trouble.  Try to re-add it to the reclaim list.
> +			 */
> +			read_lock(&pag->pag_ici_lock);
> +			spin_lock(&ip->i_flags_lock);
> +
> +			ip->i_flags &= ~XFS_INEW;
> +			__xfs_inode_set_reclaim_tag(pag, ip);
> +
> 			error = ENOMEM;
> 			goto out_error;
> 		}
> -
> -		/*
> -		 * We must set the XFS_INEW flag before clearing the
> -		 * XFS_IRECLAIMABLE flag so that if a racing lookup does
> -		 * not find the XFS_IRECLAIMABLE above but has the igrab()
> -		 * below succeed we can safely check XFS_INEW to detect
> -		 * that this inode is still being initialised.
> -		 */
> -		xfs_iflags_set(ip, XFS_INEW);
> -		xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
> -
> -		/* clear the radix tree reclaim flag as well. */
> -		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
> -	} else if (!igrab(VFS_I(ip))) {
> +		inode->i_state = I_LOCK|I_NEW;
> +	} else {
> 		/* If the VFS inode is being torn down, pause and try again. */
> -		XFS_STATS_INC(xs_ig_frecycle);
> -		goto out_error;
> -	} else if (xfs_iflags_test(ip, XFS_INEW)) {
> -		/*
> -		 * We are racing with another cache hit that is
> -		 * currently recycling this inode out of the XFS_IRECLAIMABLE
> -		 * state. Wait for the initialisation to complete before
> -		 * continuing.
> -		 */
> -		wait_on_inode(VFS_I(ip));
> -	}
> +		if (!igrab(inode)) {
> +			error = EAGAIN;
> +			goto out_error;
> +		}
>
> -	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
> -		error = ENOENT;
> -		iput(VFS_I(ip));
> -		goto out_error;
> +		/* We've got a live one. */
> +		spin_unlock(&ip->i_flags_lock);
> +		read_unlock(&pag->pag_ici_lock);
> 	}
>
> -	/* We've got a live one. */
> -	read_unlock(&pag->pag_ici_lock);
> -
> 	if (lock_flags != 0)
> 		xfs_ilock(ip, lock_flags);
>
> @@ -216,6 +226,7 @@ xfs_iget_cache_hit(
> 	return 0;
>
> out_error:
> +	spin_unlock(&ip->i_flags_lock);
> 	read_unlock(&pag->pag_ici_lock);
> 	return error;
> }
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-08-01  
> 23:20:31.441330970 +0200
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2009-08-01  
> 23:20:54.807080483 +0200
> @@ -708,6 +708,17 @@ xfs_reclaim_inode(
> 	return 0;
> }
>
> +void
> +__xfs_inode_set_reclaim_tag(
> +	struct xfs_perag	*pag,
> +	struct xfs_inode	*ip)
> +{
> +	radix_tree_tag_set(&pag->pag_ici_root,
> +			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
> +			   XFS_ICI_RECLAIM_TAG);
> +	ip->i_flags |= XFS_IRECLAIMABLE;
> +}
> +
> /*
>  * We set the inode flag atomically with the radix tree tag.
>  * Once we get tag lookups on the radix tree, this inode flag
> @@ -722,9 +733,7 @@ xfs_inode_set_reclaim_tag(
>
> 	read_lock(&pag->pag_ici_lock);
> 	spin_lock(&ip->i_flags_lock);
> -	radix_tree_tag_set(&pag->pag_ici_root,
> -			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
> -	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
> +	__xfs_inode_set_reclaim_tag(pag, ip);
> 	spin_unlock(&ip->i_flags_lock);
> 	read_unlock(&pag->pag_ici_lock);
> 	xfs_put_perag(mp, pag);
> @@ -732,27 +741,13 @@ xfs_inode_set_reclaim_tag(
>
> void
> __xfs_inode_clear_reclaim_tag(
> -	xfs_mount_t	*mp,
> -	xfs_perag_t	*pag,
> -	xfs_inode_t	*ip)
> +	struct xfs_perag	*pag,
> +	struct xfs_inode	*ip)
> {
> +	ip->i_flags &= ~XFS_IRECLAIMABLE;
> 	radix_tree_tag_clear(&pag->pag_ici_root,
> -			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
> -}
> -
> -void
> -xfs_inode_clear_reclaim_tag(
> -	xfs_inode_t	*ip)
> -{
> -	xfs_mount_t	*mp = ip->i_mount;
> -	xfs_perag_t	*pag = xfs_get_perag(mp, ip->i_ino);
> -
> -	read_lock(&pag->pag_ici_lock);
> -	spin_lock(&ip->i_flags_lock);
> -	__xfs_inode_clear_reclaim_tag(mp, pag, ip);
> -	spin_unlock(&ip->i_flags_lock);
> -	read_unlock(&pag->pag_ici_lock);
> -	xfs_put_perag(mp, pag);
> +			     XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
> +			     XFS_ICI_RECLAIM_TAG);
> }
>
> STATIC int
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.h	2009-08-01  
> 23:20:31.449329683 +0200
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.h	2009-08-01  
> 23:20:54.808079772 +0200
> @@ -48,9 +48,8 @@ int xfs_reclaim_inode(struct xfs_inode *
> int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
>
> void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
> -void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
> -void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct  
> xfs_perag *pag,
> -				struct xfs_inode *ip);
> +void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct  
> xfs_inode *ip);
> +void __xfs_inode_clear_reclaim_tag(struct xfs_perag *pag, struct  
> xfs_inode *ip);
>
> int xfs_sync_inode_valid(struct xfs_inode *ip, struct xfs_perag *pag);
> int xfs_inode_ag_iterator(struct xfs_mount *mp,
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
