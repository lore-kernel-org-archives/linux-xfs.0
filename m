Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBFGgo8c014817 for <xfs@oss.sgi.com>; Thu, 15 Dec 2011 10:42:50 -0600
Date: Thu, 15 Dec 2011 10:43:14 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 15/19] xfs: simplify xfs_qm_detach_gdquots
Message-ID: <20111215164314.GI29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215855.306880439@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215855.306880439@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:21PM -0500, Christoph Hellwig wrote:
> There is no reason to drop qi_dqlist_lock around calls to xfs_qm_dqrele
> because the free list lock now nests inside qi_dqlist_lock and the
> dquot lock.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> ---
>  fs/xfs/xfs_qm.c |   22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_qm.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:40:07.538179215 +0200
> +++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:08.124671538 +0200
> @@ -449,7 +449,6 @@ xfs_qm_detach_gdquots(
>  {
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
>  	struct xfs_dquot	*dqp, *gdqp;
> -	int			nrecl;
>  
>   again:
>  	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
> @@ -462,25 +461,14 @@ xfs_qm_detach_gdquots(
>  			mutex_lock(&q->qi_dqlist_lock);
>  			goto again;
>  		}
> -		if ((gdqp = dqp->q_gdquot)) {
> -			xfs_dqlock(gdqp);

Why don't we need to take the dqlock on gdqp here before dropping the
lock on dqp?

> +
> +		gdqp = dqp->q_gdquot;
> +		if (gdqp)
>  			dqp->q_gdquot = NULL;
> -		}
>  		xfs_dqunlock(dqp);
>  
> -		if (gdqp) {
> -			/*
> -			 * Can't hold the mplist lock across a dqput.
> -			 * XXXmust convert to marker based iterations here.
> -			 */
> -			nrecl = q->qi_dqreclaims;
> -			mutex_unlock(&q->qi_dqlist_lock);
> -			xfs_qm_dqput(gdqp);
> -
> -			mutex_lock(&q->qi_dqlist_lock);
> -			if (nrecl != q->qi_dqreclaims)

Why is it ok to ignore di_dqreclaims now?

> -				goto again;
> -		}
> +		if (gdqp)
> +			xfs_qm_dqrele(gdqp);
>  	}
>  }
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
