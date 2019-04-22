Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729119AbfDVTnL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Apr 2019 15:43:11 -0400
Date: Mon, 22 Apr 2019 14:43:09 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 05/10] libxfs: drop the ifork_ops parameter from
 _inode_verify_forks
Message-ID: <20190422194309.GA30508@redhat.com>
References: <155594788997.115924.16224143537288136652.stgit@magnolia>
 <155594792189.115924.17675145707430115266.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155594792189.115924.17675145707430115266.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Mon, Apr 22, 2019 at 08:45:21AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that the inode remembers its own ifork_ops, we can drop the second
> parameter from libxfs_inode_verify_forks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  include/xfs_inode.h |    3 +--
>  libxfs/rdwr.c       |   11 +++++------
>  libxfs/util.c       |    2 +-
>  3 files changed, 7 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> index e1e8b430..52d79f3c 100644
> --- a/include/xfs_inode.h
> +++ b/include/xfs_inode.h
> @@ -151,8 +151,7 @@ extern void	libxfs_trans_ichgtime(struct xfs_trans *,
>  extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
>  
>  /* Inode Cache Interfaces */
> -extern bool	libxfs_inode_verify_forks(struct xfs_inode *ip,
> -				struct xfs_ifork_ops *);
> +extern bool	libxfs_inode_verify_forks(struct xfs_inode *ip);
>  extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
>  				uint, struct xfs_inode **,
>  				struct xfs_ifork_ops *);
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 69d5abb2..bc2ed38c 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1338,16 +1338,15 @@ extern kmem_zone_t	*xfs_ili_zone;
>   */
>  bool
>  libxfs_inode_verify_forks(
> -	struct xfs_inode	*ip,
> -	struct xfs_ifork_ops	*ops)
> +	struct xfs_inode	*ip)
>  {
>  	struct xfs_ifork	*ifp;
>  	xfs_failaddr_t		fa;
>  
> -	if (!ops)
> +	if (!ip->i_fork_ops)
>  		return true;
>  
> -	fa = xfs_ifork_verify_data(ip, ops);
> +	fa = xfs_ifork_verify_data(ip, ip->i_fork_ops);
>  	if (fa) {
>  		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
> @@ -1355,7 +1354,7 @@ libxfs_inode_verify_forks(
>  		return false;
>  	}
>  
> -	fa = xfs_ifork_verify_attr(ip, ops);
> +	fa = xfs_ifork_verify_attr(ip, ip->i_fork_ops);
>  	if (fa) {
>  		ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> @@ -1392,7 +1391,7 @@ libxfs_iget(
>  	}
>  
>  	ip->i_fork_ops = ifork_ops;
> -	if (!libxfs_inode_verify_forks(ip, ifork_ops)) {
> +	if (!libxfs_inode_verify_forks(ip)) {
>  		libxfs_irele(ip);
>  		return -EFSCORRUPTED;
>  	}
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 2e3b9d51..ea75fa20 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -422,7 +422,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
>  		VFS_I(ip)->i_version++;
>  
>  	/* Check the inline fork data before we write out. */
> -	if (!libxfs_inode_verify_forks(ip, ip->i_fork_ops))
> +	if (!libxfs_inode_verify_forks(ip))
>  		return -EFSCORRUPTED;
>  
>  	/*
> 
