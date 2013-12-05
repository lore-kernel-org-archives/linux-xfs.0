Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 069347F75
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 14:41:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E97A18F8035
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 12:41:13 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CXvzD8pzCzL4iMH9 for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 12:41:11 -0800 (PST)
Date: Fri, 6 Dec 2013 07:41:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: use xfs_ilock_map_shared in xfs_qm_dqtobp
Message-ID: <20131205204108.GB29897@dastard>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.330689967@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205155951.330689967@bombadil.infradead.org>
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

On Thu, Dec 05, 2013 at 07:58:32AM -0800, Christoph Hellwig wrote:
> We might not have read in the extent list at this point, so make sure we
> take the ilock exclusively if we have to do so.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_dquot.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dquot.c	2013-11-18 14:39:01.955589999 +0100
> +++ xfs/fs/xfs/xfs_dquot.c	2013-12-05 11:42:34.759679600 +0100
> @@ -469,16 +469,17 @@ xfs_qm_dqtobp(
>  	struct xfs_mount	*mp = dqp->q_mount;
>  	xfs_dqid_t		id = be32_to_cpu(dqp->q_core.d_id);
>  	struct xfs_trans	*tp = (tpp ? *tpp : NULL);
> +	uint			lock_mode;
>  
>  	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
>  
> -	xfs_ilock(quotip, XFS_ILOCK_SHARED);
> +	lock_mode = xfs_ilock_map_shared(quotip);
>  	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
>  		/*
>  		 * Return if this type of quotas is turned off while we
>  		 * didn't have the quota inode lock.
>  		 */
> -		xfs_iunlock(quotip, XFS_ILOCK_SHARED);
> +		xfs_iunlock_map_shared(quotip, lock_mode);
>  		return ESRCH;
>  	}
>  
> @@ -488,7 +489,7 @@ xfs_qm_dqtobp(
>  	error = xfs_bmapi_read(quotip, dqp->q_fileoffset,
>  			       XFS_DQUOT_CLUSTER_SIZE_FSB, &map, &nmaps, 0);
>  
> -	xfs_iunlock(quotip, XFS_ILOCK_SHARED);
> +	xfs_iunlock_map_shared(quotip, lock_mode);
>  	if (error)
>  		return error;

Looks ok, so consider it:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

However, it raises a bigger question about dquot allocation sanity
to me: what makes the map returned valid after we've unlocked the
extent list?

We then use it to determine whether to allocate a
dquot or not, and xfs_qm_dqalloc() then does this after calling
xfs_bmapi_write():

	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
	       (map.br_startblock != HOLESTARTBLOCK));

What's to prevent someone coming in between the xfs_bmapi_read()
and *write() calls and allocating a different dquot in the same
cluster and therefore beating the first thread to the allocation?

This read/write race exists elsewhere - e.g. xfs_iomap_write_allocate
documents it for the data path - and it has to be specifically
handled to prevent corruption.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
