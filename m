Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2CKbPrD138197 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 15:37:25 -0500
Date: Mon, 12 Mar 2012 15:37:32 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 5/8] xfs: per-filesystem dquot LRU lists
Message-ID: <20120312203732.GF7762@sgi.com>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022904.240235841@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120220022904.240235841@bombadil.infradead.org>
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
Cc: xfs@oss.sgi.com

On Sun, Feb 19, 2012 at 09:28:20PM -0500, Christoph Hellwig wrote:
> Replace the global dquot lru lists with a per-filesystem one.
> 
> Note that the shrinker isn't wire up to the per-superblock VFS shrinker
> infrastructure as would have problems summing up and splitting the counts
> for inodes and dquots.  I don't think this is a major problem as the quota
> cache isn't as interwinded with the inode cache as the dentry cache is,
> because an inode that is dropped from the cache will generally release
> a dquot reference, but most of the time it won't be the last one.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

...

> @@ -1126,6 +1129,7 @@ xfs_qm_dqpurge(
>  {
>  	struct xfs_mount	*mp = dqp->q_mount;
>  	struct xfs_dqhash	*qh = dqp->q_hash;
> +	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>  
>  	xfs_dqlock(dqp);
>  
> @@ -1176,22 +1180,21 @@ xfs_qm_dqpurge(
>  	qh->qh_version++;
>  	mutex_unlock(&qh->qh_lock);
>  
> -	mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
> +	mutex_lock(&qi->qi_dqlist_lock);
>  	list_del_init(&dqp->q_mplist);
> -	mp->m_quotainfo->qi_dqreclaims++;
> -	mp->m_quotainfo->qi_dquots--;
> -	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
> +	qi->qi_dqreclaims++;
> +	qi->qi_dquots--;
> +	mutex_unlock(&qi->qi_dqlist_lock);
>  
>  	/*
>  	 * We move dquots to the freelist as soon as their reference count
>  	 * hits zero, so it really should be on the freelist here.
>  	 */
> -	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
> -	ASSERT(!list_empty(&dqp->q_freelist));
> -	list_del_init(&dqp->q_freelist);
> -	xfs_Gqm->qm_dqfrlist_cnt--;
> -	XFS_STATS_DEC(xs_qm_dquot_unused);

Looks like you have removed this decrement of xs_qm_dquot_unused.  You
didn't mention it in your commit message, so I am not sure if it is
intentional.

Other than that, this patch looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
