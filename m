Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755056AbeDWNyj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 09:54:39 -0400
Date: Mon, 23 Apr 2018 09:54:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/13] xfs: remove unnecessary xfs_qm_dqattach parameter
Message-ID: <20180423135434.GD43600@bfoster.bfoster>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
 <152440957769.29601.7369035661664268323.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440957769.29601.7369035661664268323.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Sun, Apr 22, 2018 at 08:06:17AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The flags argument is always zero, get rid of it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c |    4 ++--
>  fs/xfs/xfs_bmap_util.c   |    6 +++---
>  fs/xfs/xfs_inode.c       |   10 +++++-----
>  fs/xfs/xfs_iomap.c       |    4 ++--
>  fs/xfs/xfs_iops.c        |    2 +-
>  fs/xfs/xfs_qm.c          |    7 +++----
>  fs/xfs/xfs_quota.h       |    4 ++--
>  fs/xfs/xfs_reflink.c     |    2 +-
>  8 files changed, 19 insertions(+), 20 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 35a1244..c3d02a6 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -236,7 +236,7 @@ xfs_attr_set(
>  	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
>  	args.total = xfs_attr_calc_size(&args, &local);
>  
> -	error = xfs_qm_dqattach(dp, 0);
> +	error = xfs_qm_dqattach(dp);
>  	if (error)
>  		return error;
>  
> @@ -427,7 +427,7 @@ xfs_attr_remove(
>  	 */
>  	args.op_flags = XFS_DA_OP_OKNOENT;
>  
> -	error = xfs_qm_dqattach(dp, 0);
> +	error = xfs_qm_dqattach(dp);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 8cd8c41..65b2cc2 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -848,7 +848,7 @@ xfs_free_eofblocks(
>  		/*
>  		 * Attach the dquots to the inode up front.
>  		 */
> -		error = xfs_qm_dqattach(ip, 0);
> +		error = xfs_qm_dqattach(ip);
>  		if (error)
>  			return error;
>  
> @@ -918,7 +918,7 @@ xfs_alloc_file_space(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	error = xfs_qm_dqattach(ip, 0);
> +	error = xfs_qm_dqattach(ip);
>  	if (error)
>  		return error;
>  
> @@ -1169,7 +1169,7 @@ xfs_free_file_space(
>  
>  	trace_xfs_free_file_space(ip);
>  
> -	error = xfs_qm_dqattach(ip, 0);
> +	error = xfs_qm_dqattach(ip);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2b70c8b..1da9863 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1411,11 +1411,11 @@ xfs_link(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	error = xfs_qm_dqattach(sip, 0);
> +	error = xfs_qm_dqattach(sip);
>  	if (error)
>  		goto std_return;
>  
> -	error = xfs_qm_dqattach(tdp, 0);
> +	error = xfs_qm_dqattach(tdp);
>  	if (error)
>  		goto std_return;
>  
> @@ -1911,7 +1911,7 @@ xfs_inactive(
>  	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0))
>  		truncate = 1;
>  
> -	error = xfs_qm_dqattach(ip, 0);
> +	error = xfs_qm_dqattach(ip);
>  	if (error)
>  		return;
>  
> @@ -2574,11 +2574,11 @@ xfs_remove(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> -	error = xfs_qm_dqattach(dp, 0);
> +	error = xfs_qm_dqattach(dp);
>  	if (error)
>  		goto std_return;
>  
> -	error = xfs_qm_dqattach(ip, 0);
> +	error = xfs_qm_dqattach(ip);
>  	if (error)
>  		goto std_return;
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 046469f..58b04ea 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -224,7 +224,7 @@ xfs_iomap_write_direct(
>  	 * necessary and move on to transaction setup.
>  	 */
>  	xfs_iunlock(ip, lockmode);
> -	error = xfs_qm_dqattach(ip, 0);
> +	error = xfs_qm_dqattach(ip);
>  	if (error)
>  		return error;
>  
> @@ -692,7 +692,7 @@ xfs_iomap_write_allocate(
>  	/*
>  	 * Make sure that the dquots are there.
>  	 */
> -	error = xfs_qm_dqattach(ip, 0);
> +	error = xfs_qm_dqattach(ip);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index a3ed3c8..5afe3c2 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -855,7 +855,7 @@ xfs_setattr_size(
>  	/*
>  	 * Make sure that the dquots are attached to the inode.
>  	 */
> -	error = xfs_qm_dqattach(ip, 0);
> +	error = xfs_qm_dqattach(ip);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index ec39ae2..d919b85 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -381,8 +381,7 @@ xfs_qm_dqattach_locked(
>  
>  int
>  xfs_qm_dqattach(
> -	struct xfs_inode	*ip,
> -	uint			flags)
> +	struct xfs_inode	*ip)
>  {
>  	int			error;
>  
> @@ -390,7 +389,7 @@ xfs_qm_dqattach(
>  		return 0;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	error = xfs_qm_dqattach_locked(ip, flags);
> +	error = xfs_qm_dqattach_locked(ip, 0);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  
>  	return error;
> @@ -1933,7 +1932,7 @@ xfs_qm_vop_rename_dqattach(
>  		 */
>  		if (i == 0 || ip != i_tab[i-1]) {
>  			if (XFS_NOT_DQATTACHED(mp, ip)) {
> -				error = xfs_qm_dqattach(ip, 0);
> +				error = xfs_qm_dqattach(ip);
>  				if (error)
>  					return error;
>  			}
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index ce6506a..a4d3922 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -90,7 +90,7 @@ extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
>  extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
>  		struct xfs_dquot *, struct xfs_dquot *,
>  		struct xfs_dquot *, uint);
> -extern int xfs_qm_dqattach(struct xfs_inode *, uint);
> +extern int xfs_qm_dqattach(struct xfs_inode *);
>  extern int xfs_qm_dqattach_locked(struct xfs_inode *, uint);
>  extern void xfs_qm_dqdetach(struct xfs_inode *);
>  extern void xfs_qm_dqrele(struct xfs_dquot *);
> @@ -132,7 +132,7 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
>  #define xfs_qm_vop_rename_dqattach(it)					(0)
>  #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
>  #define xfs_qm_vop_chown_reserve(tp, ip, u, g, p, fl)			(0)
> -#define xfs_qm_dqattach(ip, fl)						(0)
> +#define xfs_qm_dqattach(ip)						(0)
>  #define xfs_qm_dqattach_locked(ip, fl)					(0)
>  #define xfs_qm_dqdetach(ip)
>  #define xfs_qm_dqrele(d)
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index cdbd342..fd8e6af 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1359,7 +1359,7 @@ xfs_reflink_remap_range(
>  		goto out_unlock;
>  
>  	/* Attach dquots to dest inode before changing block map */
> -	ret = xfs_qm_dqattach(dest, 0);
> +	ret = xfs_qm_dqattach(dest);
>  	if (ret)
>  		goto out_unlock;
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
