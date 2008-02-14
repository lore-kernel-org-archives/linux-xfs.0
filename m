Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 15:52:48 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1ENqfDa003713
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 15:52:43 -0800
Date: Fri, 15 Feb 2008 10:52:59 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Use xfs_inode_clean() in more places
Message-ID: <20080214235259.GR155259@sgi.com>
References: <20080121051647.GF155259@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121051647.GF155259@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

ping?

On Mon, Jan 21, 2008 at 04:16:47PM +1100, David Chinner wrote:
> Use xfs_inode_clean() in more places.
> 
> Version 2:
> - remove eye-hurting STATIC_INLINE
> - make check less verbose
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/xfs_inode.c      |   27 +++++----------------------
>  fs/xfs/xfs_inode_item.h |    8 ++++++++
>  fs/xfs/xfs_vnodeops.c   |    4 +---
>  3 files changed, 14 insertions(+), 25 deletions(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2008-01-21 16:06:27.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2008-01-21 16:08:47.893673473 +1100
> @@ -2118,13 +2118,6 @@ xfs_iunlink_remove(
>  	return 0;
>  }
>  
> -STATIC_INLINE int xfs_inode_clean(xfs_inode_t *ip)
> -{
> -	return (((ip->i_itemp == NULL) ||
> -		!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
> -		(ip->i_update_core == 0));
> -}
> -
>  STATIC void
>  xfs_ifree_cluster(
>  	xfs_inode_t	*free_ip,
> @@ -3004,7 +2997,6 @@ xfs_iflush_cluster(
>  	int			ilist_size;
>  	xfs_inode_t		*ilist;
>  	xfs_inode_t		*iq;
> -	xfs_inode_log_item_t	*iip;
>  	int			nr_found;
>  	int			clcount = 0;
>  	int			bufwasdelwri;
> @@ -3038,13 +3030,8 @@ xfs_iflush_cluster(
>  		 * is a candidate for flushing.  These checks will be repeated
>  		 * later after the appropriate locks are acquired.
>  		 */
> -		iip = iq->i_itemp;
> -		if ((iq->i_update_core == 0) &&
> -		    ((iip == NULL) ||
> -		     !(iip->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
> -		      xfs_ipincount(iq) == 0) {
> +		if (xfs_inode_clean(iq) && xfs_ipincount(iq) == 0)
>  			continue;
> -		}
>  
>  		/*
>  		 * Try to get locks.  If any are unavailable or it is pinned,
> @@ -3067,10 +3054,8 @@ xfs_iflush_cluster(
>  		 * arriving here means that this inode can be flushed.  First
>  		 * re-check that it's dirty before flushing.
>  		 */
> -		iip = iq->i_itemp;
> -		if ((iq->i_update_core != 0) || ((iip != NULL) &&
> -		     (iip->ili_format.ilf_fields & XFS_ILOG_ALL))) {
> -			int error;
> +		if (!xfs_inode_clean(iq)) {
> +			int	error;
>  			error = xfs_iflush_int(iq, bp);
>  			if (error) {
>  				xfs_iunlock(iq, XFS_ILOCK_SHARED);
> @@ -3174,8 +3159,7 @@ xfs_iflush(
>  	 * If the inode isn't dirty, then just release the inode
>  	 * flush lock and do nothing.
>  	 */
> -	if ((ip->i_update_core == 0) &&
> -	    ((iip == NULL) || !(iip->ili_format.ilf_fields & XFS_ILOG_ALL))) {
> +	if (xfs_inode_clean(ip)) {
>  		ASSERT((iip != NULL) ?
>  			 !(iip->ili_item.li_flags & XFS_LI_IN_AIL) : 1);
>  		xfs_ifunlock(ip);
> @@ -3341,8 +3325,7 @@ xfs_iflush_int(
>  	 * If the inode isn't dirty, then just release the inode
>  	 * flush lock and do nothing.
>  	 */
> -	if ((ip->i_update_core == 0) &&
> -	    ((iip == NULL) || !(iip->ili_format.ilf_fields & XFS_ILOG_ALL))) {
> +	if (xfs_inode_clean(ip)) {
>  		xfs_ifunlock(ip);
>  		return 0;
>  	}
> Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2008-01-21 16:06:27.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2008-01-21 16:08:47.897672964 +1100
> @@ -3490,7 +3490,6 @@ xfs_inode_flush(
>  	int		flags)
>  {
>  	xfs_mount_t	*mp = ip->i_mount;
> -	xfs_inode_log_item_t *iip = ip->i_itemp;
>  	int		error = 0;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
> @@ -3500,8 +3499,7 @@ xfs_inode_flush(
>  	 * Bypass inodes which have already been cleaned by
>  	 * the inode flush clustering code inside xfs_iflush
>  	 */
> -	if ((ip->i_update_core == 0) &&
> -	    ((iip == NULL) || !(iip->ili_format.ilf_fields & XFS_ILOG_ALL)))
> +	if (xfs_inode_clean(ip))
>  		return 0;
>  
>  	/*
> Index: 2.6.x-xfs-new/fs/xfs/xfs_inode_item.h
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode_item.h	2008-01-21 16:06:27.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_inode_item.h	2008-01-21 16:14:34.001674576 +1100
> @@ -168,6 +168,14 @@ static inline int xfs_ilog_fext(int w)
>  	return (w == XFS_DATA_FORK ? XFS_ILOG_DEXT : XFS_ILOG_AEXT);
>  }
>  
> +static inline int xfs_inode_clean(xfs_inode_t *ip)
> +{
> +	return (!ip->i_itemp ||
> +		!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
> +	       !ip->i_update_core;
> +}
> +
> +
>  #ifdef __KERNEL__
>  
>  extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
