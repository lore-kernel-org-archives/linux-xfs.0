Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932129AbeB0Nzu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Feb 2018 08:55:50 -0500
Date: Tue, 27 Feb 2018 08:55:49 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/5] xfs: check for cow blocks before trying to clear
 them during inode reclaim
Message-ID: <20180227135549.GD3479@bfoster.bfoster>
References: <151935118240.21654.10146641674018880885.stgit@magnolia>
 <151935120057.21654.6400354165591541565.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151935120057.21654.6400354165591541565.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 22, 2018 at 06:00:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There's no point in allocating a transaction and locking the inode in
> preparation to clear cow blocks if there actually are any cow fork
> extents.  Therefore, move the xfs_reflink_cancel_cow_range hunk to
> xfs_inactive and check the cow ifp first.  This makes inode reclamation
> run faster.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c |    5 +++++
>  fs/xfs/xfs_super.c |    9 ---------
>  2 files changed, 5 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 604ee38..50fbbf5 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1872,6 +1872,7 @@ xfs_inactive(
>  	xfs_inode_t	*ip)
>  {
>  	struct xfs_mount	*mp;
> +	struct xfs_ifork	*cow_ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	int			error;
>  	int			truncate = 0;
>  
> @@ -1892,6 +1893,10 @@ xfs_inactive(
>  	if (mp->m_flags & XFS_MOUNT_RDONLY)
>  		return;
>  
> +	/* Try to clean out the cow blocks if there are any. */
> +	if (xfs_is_reflink_inode(ip) && cow_ifp->if_bytes > 0)
> +		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
> +
>  	if (VFS_I(ip)->i_nlink != 0) {
>  		/*
>  		 * force is true because we are evicting an inode from the
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 7aba628..624a802 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -970,7 +970,6 @@ xfs_fs_destroy_inode(
>  	struct inode		*inode)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
> -	int			error;
>  
>  	trace_xfs_destroy_inode(ip);
>  
> @@ -978,14 +977,6 @@ xfs_fs_destroy_inode(
>  	XFS_STATS_INC(ip->i_mount, vn_rele);
>  	XFS_STATS_INC(ip->i_mount, vn_remove);
>  
> -	if (xfs_is_reflink_inode(ip)) {
> -		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
> -		if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount))
> -			xfs_warn(ip->i_mount,
> -"Error %d while evicting CoW blocks for inode %llu.",
> -					error, ip->i_ino);
> -	}
> -
>  	xfs_inactive(ip);
>  
>  	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
