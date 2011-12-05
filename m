Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB54RGnK110435 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 22:27:16 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 653D01DC1E18
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 20:27:13 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NVPc5BeeMEveCbZw for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 20:27:13 -0800 (PST)
Date: Mon, 5 Dec 2011 15:23:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/16] xfs: remove XFS_DQ_INACTIVE
Message-ID: <20111205042351.GN7046@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082837.441012540@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128082837.441012540@bombadil.infradead.org>
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

On Mon, Nov 28, 2011 at 03:27:29AM -0500, Christoph Hellwig wrote:
> Free dquots when purging them during umount instead of keeping them around
> on the freelist in a degraded state.  The out of order locking in
> xfs_qm_dqpurge will be removed again later in this series.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

>  
> -	dqp->q_mount = NULL;
> -	dqp->q_hash = NULL;
> -	dqp->dq_flags = XFS_DQ_INACTIVE;
> -	memset(&dqp->q_core, 0, sizeof(dqp->q_core));
> +	list_del_init(&dqp->q_freelist);
> +	xfs_Gqm->qm_dqfrlist_cnt--;
> +
>  	xfs_dqfunlock(dqp);
>  	xfs_dqunlock(dqp);
> +
> +	mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
>  	mutex_unlock(&qh->qh_lock);
> +
> +	xfs_qm_dqdestroy(dqp);
>  	return (0);
>  }

While there, you may as well make that a "return 0;"

> @@ -171,17 +176,6 @@ xfs_qm_destroy(
>  	xqm->qm_grp_dqhtable = NULL;
>  	xqm->qm_dqhashmask = 0;
>  
> -	/* frlist cleanup */
> -	mutex_lock(&xqm->qm_dqfrlist_lock);
> -	list_for_each_entry_safe(dqp, n, &xqm->qm_dqfrlist, q_freelist) {
> -		xfs_dqlock(dqp);
> -		list_del_init(&dqp->q_freelist);
> -		xfs_Gqm->qm_dqfrlist_cnt--;
> -		xfs_dqunlock(dqp);
> -		xfs_qm_dqdestroy(dqp);
> -	}
> -	mutex_unlock(&xqm->qm_dqfrlist_lock);
> -	mutex_destroy(&xqm->qm_dqfrlist_lock);
>  	kmem_free(xqm);
>  }

Don't we still need that mutex_destroy() call there?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
