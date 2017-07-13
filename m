Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27183 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGMQbl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 12:31:41 -0400
Date: Thu, 13 Jul 2017 09:31:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] Revert "xfs: grab dquots without taking the ilock"
Message-ID: <20170713163127.GA4151@magnolia>
References: <20170713113304.8079-1-hch@lst.de>
 <20170713113304.8079-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170713113304.8079-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 13, 2017 at 01:33:04PM +0200, Christoph Hellwig wrote:
> This reverts commit 50e0bdbe9f48f98bb02eac7030d682f4716884ae.
> 
> The new XFS_QMOPT_NOLOCK isn't used at all,

It'll get used (eventually) by online fsck.

> and conditional locking based on a flag is always the wrong thing to
> do - we should be having helpers that can be called without the lock
> instead.

Fair enough.  How about this instead:

static int
__xfs_qm_dqget(mp, ip, id, type, flags, O_dqpp)
{
	/* existing xfs_qm_dqget implementation */
}

int
xfs_qm_dqget(mp, ip, id, type, flags, O_dqpp)
{
	if (flags & XFS_QMOPT_NOLOCK)
		return -EINVAL;
	return __xfs_qm_dqget(mp, ip, id, type, flags, O_dqpp);
}

/*
 * Grab the bare dquot for a given id, having locked the quota inode.
 * We don't support any caller QMOPT flags or other fancy behavior.
 */
int
xfs_qm_dqget_bare(mp, id, type, O_dqpp)
{
	ASSERT(xfs_isilocked(xfs_quota_inode(mp, type), XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
	return __xfs_qm_dqget(mp, NULL, id, type, XFS_QMOPT_NOLOCK, O_dqpp);
}

XFS_QMOPT_NOLOCK then becomes an internal flag (or I could make it into
an extra parameter to __xfs_qm_dqget) that can only be turned on
indirectly via the xfs_qm_dqget_bare helper.

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_quota_defs.h |  2 --
>  fs/xfs/xfs_dquot.c             | 14 ++++----------
>  2 files changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index 2834574cb6e7..d69c772271cb 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -136,8 +136,6 @@ typedef uint16_t	xfs_qwarncnt_t;
>   */
>  #define XFS_QMOPT_INHERIT	0x1000000
>  
> -#define XFS_QMOPT_NOLOCK	0x2000000 /* don't ilock during dqget */
> -
>  /*
>   * flags to xfs_trans_mod_dquot.
>   */
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index f89f7b5241e6..fd2ef8c2c9a7 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -472,23 +472,18 @@ xfs_qm_dqtobp(
>  	struct xfs_mount	*mp = dqp->q_mount;
>  	xfs_dqid_t		id = be32_to_cpu(dqp->q_core.d_id);
>  	struct xfs_trans	*tp = (tpp ? *tpp : NULL);
> -	uint			lock_mode = 0;
> +	uint			lock_mode;
>  
>  	quotip = xfs_quota_inode(dqp->q_mount, dqp->dq_flags);
>  	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
>  
> -	ASSERT(!(flags & XFS_QMOPT_NOLOCK) ||
> -		xfs_isilocked(quotip, XFS_ILOCK_SHARED) ||
> -		xfs_isilocked(quotip, XFS_ILOCK_EXCL));
> -	if (!(flags & XFS_QMOPT_NOLOCK))
> -		lock_mode = xfs_ilock_data_map_shared(quotip);
> +	lock_mode = xfs_ilock_data_map_shared(quotip);
>  	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
>  		/*
>  		 * Return if this type of quotas is turned off while we
>  		 * didn't have the quota inode lock.
>  		 */
> -		if (lock_mode)
> -			xfs_iunlock(quotip, lock_mode);
> +		xfs_iunlock(quotip, lock_mode);
>  		return -ESRCH;
>  	}
>  
> @@ -498,8 +493,7 @@ xfs_qm_dqtobp(
>  	error = xfs_bmapi_read(quotip, dqp->q_fileoffset,
>  			       XFS_DQUOT_CLUSTER_SIZE_FSB, &map, &nmaps, 0);
>  
> -	if (lock_mode)
> -		xfs_iunlock(quotip, lock_mode);
> +	xfs_iunlock(quotip, lock_mode);
>  	if (error)
>  		return error;
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
