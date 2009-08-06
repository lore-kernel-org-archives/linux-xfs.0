Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n76Ns33N094892 for <xfs@oss.sgi.com>; Thu, 6 Aug 2009 18:54:03 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B482414A59D7
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2009 17:04:30 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 51GAkpDsc5bBSEMQ for
	<xfs@oss.sgi.com>; Thu, 06 Aug 2009 17:04:30 -0700 (PDT)
Message-ID: <4A7B6D4D.8090707@sandeen.net>
Date: Thu, 06 Aug 2009 18:54:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] xfs: add xfs_inode_free
References: <20090804141554.992235000@bombadil.infradead.org>
	<20090804141836.782959000@bombadil.infradead.org>
In-Reply-To: <20090804141836.782959000@bombadil.infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Christoph Hellwig wrote:

> When we want to tear down an inode that lost the add to the cache race
> in XFS we must not call into ->destroy_inode because that would delete
> the inode that won the race from the inode cache radix tree.
>
> This patch uses splits a new xfs_inode_free helper out of xfs_ireclaim
> and uses that plus __destroy_inode to make sure we really only free
> the memory allocted for the inode that lost the race, and not mess with
> the inode cache state.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>

Looks right to me.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
> Index: linux-2.6/fs/xfs/xfs_iget.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_iget.c	2009-08-03 01:23:29.878784477 +0200
> +++ linux-2.6/fs/xfs/xfs_iget.c	2009-08-03 01:25:01.601784988 +0200
> @@ -116,6 +116,71 @@ xfs_inode_alloc(
>  	return ip;
>  }
>  
> +STATIC void
> +xfs_inode_free(
> +	struct xfs_inode	*ip)
> +{
> +	switch (ip->i_d.di_mode & S_IFMT) {
> +	case S_IFREG:
> +	case S_IFDIR:
> +	case S_IFLNK:
> +		xfs_idestroy_fork(ip, XFS_DATA_FORK);
> +		break;
> +	}
> +
> +	if (ip->i_afp)
> +		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
> +
> +#ifdef XFS_INODE_TRACE
> +	ktrace_free(ip->i_trace);
> +#endif
> +#ifdef XFS_BMAP_TRACE
> +	ktrace_free(ip->i_xtrace);
> +#endif
> +#ifdef XFS_BTREE_TRACE
> +	ktrace_free(ip->i_btrace);
> +#endif
> +#ifdef XFS_RW_TRACE
> +	ktrace_free(ip->i_rwtrace);
> +#endif
> +#ifdef XFS_ILOCK_TRACE
> +	ktrace_free(ip->i_lock_trace);
> +#endif
> +#ifdef XFS_DIR2_TRACE
> +	ktrace_free(ip->i_dir_trace);
> +#endif
> +
> +	if (ip->i_itemp) {
> +		/*
> +		 * Only if we are shutting down the fs will we see an
> +		 * inode still in the AIL. If it is there, we should remove
> +		 * it to prevent a use-after-free from occurring.
> +		 */
> +		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
> +		struct xfs_ail	*ailp = lip->li_ailp;
> +
> +		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
> +				       XFS_FORCED_SHUTDOWN(ip->i_mount));
> +		if (lip->li_flags & XFS_LI_IN_AIL) {
> +			spin_lock(&ailp->xa_lock);
> +			if (lip->li_flags & XFS_LI_IN_AIL)
> +				xfs_trans_ail_delete(ailp, lip);
> +			else
> +				spin_unlock(&ailp->xa_lock);
> +		}
> +		xfs_inode_item_destroy(ip);
> +		ip->i_itemp = NULL;
> +	}
> +
> +	/* asserts to verify all state is correct here */
> +	ASSERT(atomic_read(&ip->i_iocount) == 0);
> +	ASSERT(atomic_read(&ip->i_pincount) == 0);
> +	ASSERT(!spin_is_locked(&ip->i_flags_lock));
> +	ASSERT(completion_done(&ip->i_flush));
> +
> +	kmem_zone_free(xfs_inode_zone, ip);
> +}
> +
>  /*
>   * Check the validity of the inode we just found it the cache
>   */
> @@ -303,7 +368,8 @@ out_preload_end:
>  	if (lock_flags)
>  		xfs_iunlock(ip, lock_flags);
>  out_destroy:
> -	xfs_destroy_inode(ip);
> +	__destroy_inode(VFS_I(ip));
> +	xfs_inode_free(ip);
>  	return error;
>  }
>  
> @@ -506,62 +572,7 @@ xfs_ireclaim(
>  	xfs_qm_dqdetach(ip);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  
> -	switch (ip->i_d.di_mode & S_IFMT) {
> -	case S_IFREG:
> -	case S_IFDIR:
> -	case S_IFLNK:
> -		xfs_idestroy_fork(ip, XFS_DATA_FORK);
> -		break;
> -	}
> -
> -	if (ip->i_afp)
> -		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
> -
> -#ifdef XFS_INODE_TRACE
> -	ktrace_free(ip->i_trace);
> -#endif
> -#ifdef XFS_BMAP_TRACE
> -	ktrace_free(ip->i_xtrace);
> -#endif
> -#ifdef XFS_BTREE_TRACE
> -	ktrace_free(ip->i_btrace);
> -#endif
> -#ifdef XFS_RW_TRACE
> -	ktrace_free(ip->i_rwtrace);
> -#endif
> -#ifdef XFS_ILOCK_TRACE
> -	ktrace_free(ip->i_lock_trace);
> -#endif
> -#ifdef XFS_DIR2_TRACE
> -	ktrace_free(ip->i_dir_trace);
> -#endif
> -	if (ip->i_itemp) {
> -		/*
> -		 * Only if we are shutting down the fs will we see an
> -		 * inode still in the AIL. If it is there, we should remove
> -		 * it to prevent a use-after-free from occurring.
> -		 */
> -		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
> -		struct xfs_ail	*ailp = lip->li_ailp;
> -
> -		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
> -				       XFS_FORCED_SHUTDOWN(ip->i_mount));
> -		if (lip->li_flags & XFS_LI_IN_AIL) {
> -			spin_lock(&ailp->xa_lock);
> -			if (lip->li_flags & XFS_LI_IN_AIL)
> -				xfs_trans_ail_delete(ailp, lip);
> -			else
> -				spin_unlock(&ailp->xa_lock);
> -		}
> -		xfs_inode_item_destroy(ip);
> -		ip->i_itemp = NULL;
> -	}
> -	/* asserts to verify all state is correct here */
> -	ASSERT(atomic_read(&ip->i_iocount) == 0);
> -	ASSERT(atomic_read(&ip->i_pincount) == 0);
> -	ASSERT(!spin_is_locked(&ip->i_flags_lock));
> -	ASSERT(completion_done(&ip->i_flush));
> -	kmem_zone_free(xfs_inode_zone, ip);
> +	xfs_inode_free(ip);
>  }
>  
>  /*
> Index: linux-2.6/fs/xfs/xfs_inode.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_inode.h	2009-08-03 01:23:39.876532108 +0200
> +++ linux-2.6/fs/xfs/xfs_inode.h	2009-08-03 01:23:47.411789594 +0200
> @@ -310,26 +310,6 @@ static inline struct inode *VFS_I(struct
>  }
>  
>  /*
> - * Get rid of a partially initialized inode.
> - *
> - * We have to go through destroy_inode to make sure allocations
> - * from init_inode_always like the security data are undone.
> - *
> - * We mark the inode bad so that it takes the short cut in
> - * the reclaim path instead of going through the flush path
> - * which doesn't make sense for an inode that has never seen the
> - * light of day.
> - */
> -static inline void xfs_destroy_inode(struct xfs_inode *ip)
> -{
> -	struct inode *inode = VFS_I(ip);
> -
> -	make_bad_inode(inode);
> -	__destroy_inode(inode);
> -	inode->i_sb->s_op->destroy_inode(inode);
> -}
> -
> -/*
>   * i_flags helper functions
>   */
>  static inline void
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
