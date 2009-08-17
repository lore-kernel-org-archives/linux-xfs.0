Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7H3UBMP042400 for <xfs@oss.sgi.com>; Sun, 16 Aug 2009 22:30:21 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 58E048F80FC
	for <xfs@oss.sgi.com>; Sun, 16 Aug 2009 20:30:59 -0700 (PDT)
Message-Id: <7168AA57-8F65-42DC-9D6A-E30A1C315FA9@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090817003634.GA31274@infradead.org>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 1/4] xfs: fix locking in xfs_iget_cache_hit
Date: Sun, 16 Aug 2009 22:05:46 -0500
References: <20090804141554.992235000@bombadil.infradead.org>
	<20090804141834.526088000@bombadil.infradead.org>
	<24CFF78E-BB3F-47A1-8D6C-49EA198CCD94@sgi.com>
	<20090810170940.GA2580@infradead.org>
	<BF8D127F-8F72-4B8C-B14C-24DD1C7EC235@sgi.com>
	<20090817003634.GA31274@infradead.org>
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


On Aug 16, 2009, at 7:36 PM, Christoph Hellwig wrote:

> On Sun, Aug 16, 2009 at 05:54:35PM -0500, Felix Blyakher wrote:
>>> The wait_on_inode is only sensible for the non-recycle case.
>>
>> The case, I was referring to, was indeed the reclaimable one when
>> the first thread is going through
>>
>>    xfs_iget
>> 	xfs_iget_cache_hit
>>            if (ip->i_flags & XFS_IRECLAIMABLE) {
>>                ip->i_flags |= XFS_INEW;
>> -->
>>        xfs_setup_inode
>>            inode->i_state = I_NEW|I_LOCK;
>>
>>
>> while another therad run through the following sequence right where  
>> the
>> arrow shows above:
>>
>>        xfs_iget_cache_hit
>>            if (ip->i_flags & XFS_INEW) {
>>                wait_on_inode
>>
>> There is nothing to wait on here yet, as I_LOCK is not set yet.
>
> Yeah.  The new version should fix it.

Agree.

> Here's a version with the small update that Eric suggested, any chance
> we could get this into 2.6.31 still?

Will send the pull request tonight.

Felix

>
>
> -- 
>
> Subject: xfs: fix locking in xfs_iget_cache_hit
> From: Christoph Hellwig <hch@lst.de>
>
> The locking in xfs_iget_cache_hit currently has numerous problems:
>
> - we clear the reclaim tag without i_flags_lock which protects  
> modifications
>   to it
> - we call inode_init_always which can sleep with pag_ici_lock held
>   (this is oss.sgi.com BZ #819)
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
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Felix Blyakher <felixb@sgi.com>
>
> Index: linux-2.6/fs/xfs/xfs_iget.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_iget.c	2009-08-16 20:10:25.200960533  
> -0300
> +++ linux-2.6/fs/xfs/xfs_iget.c	2009-08-16 20:11:30.580432781 -0300
> @@ -191,80 +191,82 @@ xfs_iget_cache_hit(
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
> +	 * If we are racing with another cache hit that is currently
> +	 * instantiating this inode or currently recycling it out of
> +	 * reclaimabe state, wait for the initialisation to complete
> +	 * before continuing.
> +	 *
> +	 * XXX(hch): eventually we should do something equivalent to
> +	 *	     wait_on_inode to wait for these flags to be cleared
> +	 *	     instead of polling for it.
> 	 */
> -	if (xfs_iflags_test(ip, (XFS_INEW|XFS_IRECLAIM))) {
> +	if (ip->i_flags & (XFS_INEW|XFS_IRECLAIM)) {
> 		XFS_STATS_INC(xs_ig_frecycle);
> +		error = EAGAIN;
> 		goto out_error;
> 	}
>
> -	/* If IRECLAIMABLE is set, we've torn down the vfs inode part */
> -	if (xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
> -
> -		/*
> -		 * If lookup is racing with unlink, then we should return an
> -		 * error immediately so we don't remove it from the reclaim
> -		 * list and potentially leak the inode.
> -		 */
> -		if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
> -			error = ENOENT;
> -			goto out_error;
> -		}
> +	/*
> +	 * If lookup is racing with unlink return an error immediately.
> +	 */
> +	if (ip->i_d.di_mode == 0 && !(flags & XFS_IGET_CREATE)) {
> +		error = ENOENT;
> +		goto out_error;
> +	}
>
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
> -		if (inode_init_always(mp->m_super, VFS_I(ip))) {
> -			error = ENOMEM;
> -			goto out_error;
> -		}
> +		ip->i_flags |= XFS_INEW;
> +		ip->i_flags &= ~XFS_IRECLAIMABLE;
> +		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
>
> -		/*
> -		 * We must set the XFS_INEW flag before clearing the
> -		 * XFS_IRECLAIMABLE flag so that if a racing lookup does
> -		 * not find the XFS_IRECLAIMABLE above but has the igrab()
> -		 * below succeed we can safely check XFS_INEW to detect
> -		 * that this inode is still being initialised.
> -		 */
> -		xfs_iflags_set(ip, XFS_INEW);
> -		xfs_iflags_clear(ip, XFS_IRECLAIMABLE);
> +		spin_unlock(&ip->i_flags_lock);
> +		read_unlock(&pag->pag_ici_lock);
>
> -		/* clear the radix tree reclaim flag as well. */
> -		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
> -	} else if (!igrab(VFS_I(ip))) {
> +		error = -inode_init_always(mp->m_super, inode);
> +		if (error) {
> +			/*
> +			 * Re-initializing the inode failed, and we are in deep
> +			 * trouble.  Try to re-add it to the reclaim list.
> +			 */
> +			read_lock(&pag->pag_ici_lock);
> +			spin_lock(&ip->i_flags_lock);
> +
> +			ip->i_flags &= ~XFS_INEW;
> +			ip->i_flags |= XFS_IRECLAIMABLE;
> +			__xfs_inode_set_reclaim_tag(pag, ip);
> +			goto out_error;
> +		}
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
> @@ -274,6 +276,7 @@ xfs_iget_cache_hit(
> 	return 0;
>
> out_error:
> +	spin_unlock(&ip->i_flags_lock);
> 	read_unlock(&pag->pag_ici_lock);
> 	return error;
> }
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-08-16  
> 20:01:14.632430664 -0300
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2009-08-16  
> 20:10:25.740968342 -0300
> @@ -708,6 +708,16 @@ xfs_reclaim_inode(
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
> +}
> +
> /*
>  * We set the inode flag atomically with the radix tree tag.
>  * Once we get tag lookups on the radix tree, this inode flag
> @@ -722,8 +732,7 @@ xfs_inode_set_reclaim_tag(
>
> 	read_lock(&pag->pag_ici_lock);
> 	spin_lock(&ip->i_flags_lock);
> -	radix_tree_tag_set(&pag->pag_ici_root,
> -			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
> +	__xfs_inode_set_reclaim_tag(pag, ip);
> 	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
> 	spin_unlock(&ip->i_flags_lock);
> 	read_unlock(&pag->pag_ici_lock);
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.h	2009-08-16  
> 20:01:14.640431122 -0300
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.h	2009-08-16  
> 20:10:25.744967593 -0300
> @@ -48,6 +48,7 @@ int xfs_reclaim_inode(struct xfs_inode *
> int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
>
> void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
> +void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct  
> xfs_inode *ip);
> void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
> void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct  
> xfs_perag *pag,
> 				struct xfs_inode *ip);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
