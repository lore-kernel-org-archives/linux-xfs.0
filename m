Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752753AbdF0LAI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jun 2017 07:00:08 -0400
Date: Tue, 27 Jun 2017 07:00:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 15/13] xfs: grab dquots without taking the ilock
Message-ID: <20170627110000.GA3147@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <20170626060446.GB4733@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170626060446.GB4733@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 25, 2017 at 11:04:46PM -0700, Darrick J. Wong wrote:
> Add a new dqget flag that grabs the dquot without taking the ilock.
> This will be used by the scrubber (which will have already grabbed
> the ilock) to perform basic sanity checking of the quota data.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

It might be good to add an assert somewhere after where we expect the
lock to be held one way or another. Otherwise looks Ok to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_quota_defs.h |    2 ++
>  fs/xfs/xfs_dquot.c             |   11 +++++++----
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index d69c772..2834574 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -136,6 +136,8 @@ typedef uint16_t	xfs_qwarncnt_t;
>   */
>  #define XFS_QMOPT_INHERIT	0x1000000
>  
> +#define XFS_QMOPT_NOLOCK	0x2000000 /* don't ilock during dqget */
> +
>  /*
>   * flags to xfs_trans_mod_dquot.
>   */
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index e57c6cc..3519efc 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -472,18 +472,20 @@ xfs_qm_dqtobp(
>  	struct xfs_mount	*mp = dqp->q_mount;
>  	xfs_dqid_t		id = be32_to_cpu(dqp->q_core.d_id);
>  	struct xfs_trans	*tp = (tpp ? *tpp : NULL);
> -	uint			lock_mode;
> +	uint			lock_mode = 0;
>  
>  	quotip = xfs_quota_inode(dqp->q_mount, dqp->dq_flags);
>  	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
>  
> -	lock_mode = xfs_ilock_data_map_shared(quotip);
> +	if (!(flags & XFS_QMOPT_NOLOCK))
> +		lock_mode = xfs_ilock_data_map_shared(quotip);
>  	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
>  		/*
>  		 * Return if this type of quotas is turned off while we
>  		 * didn't have the quota inode lock.
>  		 */
> -		xfs_iunlock(quotip, lock_mode);
> +		if (lock_mode)
> +			xfs_iunlock(quotip, lock_mode);
>  		return -ESRCH;
>  	}
>  
> @@ -493,7 +495,8 @@ xfs_qm_dqtobp(
>  	error = xfs_bmapi_read(quotip, dqp->q_fileoffset,
>  			       XFS_DQUOT_CLUSTER_SIZE_FSB, &map, &nmaps, 0);
>  
> -	xfs_iunlock(quotip, lock_mode);
> +	if (lock_mode)
> +		xfs_iunlock(quotip, lock_mode);
>  	if (error)
>  		return error;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
