Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A89507F8B
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 16:38:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 822578F8039
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 14:38:30 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IpqJMsutIAjqgAr0 for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 14:38:20 -0800 (PST)
Date: Mon, 9 Dec 2013 09:38:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/11] xfs: use xfs_ilock_data_map_shared in xfs_qm_dqtobp
Message-ID: <20131208223804.GH31386@dastard>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203129.064095439@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206203129.064095439@bombadil.infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 12:30:13PM -0800, Christoph Hellwig wrote:
> We might not have read in the extent list at this point, so make sure we
> take the ilock exclusively if we have to do so.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_dquot.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dquot.c	2013-12-06 17:20:27.571331599 +0100
> +++ xfs/fs/xfs/xfs_dquot.c	2013-12-06 19:39:42.307160146 +0100
> @@ -469,16 +469,17 @@ xfs_qm_dqtobp(
>  	struct xfs_mount	*mp = dqp->q_mount;
>  	xfs_dqid_t		id = be32_to_cpu(dqp->q_core.d_id);
>  	struct xfs_trans	*tp = (tpp ? *tpp : NULL);
> +	uint			lock_mode;
>  
>  	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
>  
> -	xfs_ilock(quotip, XFS_ILOCK_SHARED);
> +	lock_mode = xfs_ilock_data_map_shared(quotip);
>  	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
>  		/*
>  		 * Return if this type of quotas is turned off while we
>  		 * didn't have the quota inode lock.
>  		 */
> -		xfs_iunlock(quotip, XFS_ILOCK_SHARED);
> +		xfs_iunlock(quotip, lock_mode);
>  		return ESRCH;
>  	}
>  
> @@ -488,7 +489,7 @@ xfs_qm_dqtobp(
>  	error = xfs_bmapi_read(quotip, dqp->q_fileoffset,
>  			       XFS_DQUOT_CLUSTER_SIZE_FSB, &map, &nmaps, 0);
>  
> -	xfs_iunlock(quotip, XFS_ILOCK_SHARED);
> +	xfs_iunlock(quotip, lock_mode);
>  	if (error)
>  		return error;

Looks fine - it doesn't change the race condition w/ dquot creation
at all, so we can ignore that for now...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
