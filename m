Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FMApkE206407 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 16:10:51 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hQBPyWf7JsjwnSUV for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 14:10:49 -0800 (PST)
Date: Thu, 16 Feb 2012 09:10:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/9] xfs: use per-filesystem dquot LRU lists
Message-ID: <20120215221045.GM14132@dastard>
References: <20120215022926.577682146@bombadil.infradead.org>
	<20120215023146.847910539@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120215023146.847910539@bombadil.infradead.org>
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

On Tue, Feb 14, 2012 at 09:29:27PM -0500, Christoph Hellwig wrote:
> Replace the global dquot lru lists with a per-filesystem one.
> 
> Note that the shrinker isn't wired up to the per-superblock VFS shrinker
> infrastructure, as doing so would cause problems due to summing up and
> splitting out again the counts for inodes and dquots.  I do not believe this
> is a major issue as the quota cache is not deeply interwinded with inode
> and dentry caching.

Yes, that's fine, like the xfs_buf cache has it's own shrinker
and reclaim algorithm....

> Also temporarily stop tracking the system-wide count of dquots on the LRU
> lists for /proc/fs/xfs/xqm, which will be added back later in the series.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
....
> @@ -869,12 +868,13 @@ recurse:
>  
>  	trace_xfs_dqput_free(dqp);
>  
> -	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
> -	if (list_empty(&dqp->q_freelist)) {
> -		list_add_tail(&dqp->q_freelist, &xfs_Gqm->qm_dqfrlist);
> -		xfs_Gqm->qm_dqfrlist_cnt++;
> +	mutex_lock(&dqp->q_mount->m_quotainfo->qi_lru_lock);
> +	if (list_empty(&dqp->q_lru)) {
> +		list_add_tail(&dqp->q_lru,
> +			      &dqp->q_mount->m_quotainfo->qi_lru_list);
> +		dqp->q_mount->m_quotainfo->qi_lru_count++;
>  	}
> -	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
> +	mutex_unlock(&dqp->q_mount->m_quotainfo->qi_lru_lock);

Might be nice to add a

+	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;

here  to make the code a little easier to read and consistent with
all the other functions.

Regardless, change looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
