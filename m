Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBF4tRj9247922 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 22:55:27 -0600
Date: Wed, 14 Dec 2011 22:55:51 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 14/19] xfs: simplify xfs_qm_dqattach_grouphint
Message-ID: <20111215045551.GH29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215855.133477972@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215855.133477972@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:20PM -0500, Christoph Hellwig wrote:
> No need to play games with the qlock now that the freelist lock nests inside
> it.  Also clean up various outdated comments.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good, minor gripes notwithstanding.
Reviewed-by: Ben Myers <bpm@sgi.com>

> ---
>  fs/xfs/xfs_qm.c |   64 ++++++++++++++------------------------------------------
>  1 file changed, 16 insertions(+), 48 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_qm.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm.c	2011-12-06 15:49:31.303693024 +0100
> +++ xfs/fs/xfs/xfs_qm.c	2011-12-06 15:51:39.467028734 +0100
> @@ -650,11 +650,7 @@ xfs_qm_dqattach_one(
>  
>  /*
>   * Given a udquot and gdquot, attach a ptr to the group dquot in the
> - * udquot as a hint for future lookups. The idea sounds simple, but the
> - * execution isn't, because the udquot might have a group dquot attached
> - * already and getting rid of that gets us into lock ordering constraints.
> - * The process is complicated more by the fact that the dquots may or may not
> - * be locked on entry.
> + * udquot as a hint for future lookups.
>   */
>  STATIC void
>  xfs_qm_dqattach_grouphint(
> @@ -665,45 +661,21 @@ xfs_qm_dqattach_grouphint(
>  
>  	xfs_dqlock(udq);
>  
> -	if ((tmp = udq->q_gdquot)) {
> -		if (tmp == gdq) {
> -			xfs_dqunlock(udq);
> -			return;
> -		}
> +	tmp = udq->q_gdquot;
> +	if (tmp) {
> +		if (tmp == gdq)
> +			goto done;
>  
>  		udq->q_gdquot = NULL;
> -		/*
> -		 * We can't keep any dqlocks when calling dqrele,
> -		 * because the freelist lock comes before dqlocks.
> -		 */
> -		xfs_dqunlock(udq);
> -		/*
> -		 * we took a hard reference once upon a time in dqget,
> -		 * so give it back when the udquot no longer points at it
> -		 * dqput() does the unlocking of the dquot.
> -		 */

At least tell us where we got the ref we're going to dqrele.  This
comment had some value.

>  		xfs_qm_dqrele(tmp);
> -
> -		xfs_dqlock(udq);
> -		xfs_dqlock(gdq);
> -
> -	} else {
> -		ASSERT(XFS_DQ_IS_LOCKED(udq));
> -		xfs_dqlock(gdq);
> -	}
> -
> -	ASSERT(XFS_DQ_IS_LOCKED(udq));
> -	ASSERT(XFS_DQ_IS_LOCKED(gdq));
> -	/*
> -	 * Somebody could have attached a gdquot here,
> -	 * when we dropped the uqlock. If so, just do nothing.
> -	 */
> -	if (udq->q_gdquot == NULL) {
> -		XFS_DQHOLD(gdq);
> -		udq->q_gdquot = gdq;
>  	}
>  
> +	xfs_dqlock(gdq);
> +	XFS_DQHOLD(gdq);
>  	xfs_dqunlock(gdq);
> +
> +	udq->q_gdquot = gdq;
> +done:
>  	xfs_dqunlock(udq);
>  }
>  
> @@ -770,17 +742,13 @@ xfs_qm_dqattach_locked(
>  		ASSERT(ip->i_gdquot);
>  
>  		/*
> -		 * We may or may not have the i_udquot locked at this point,
> -		 * but this check is OK since we don't depend on the i_gdquot to
> -		 * be accurate 100% all the time. It is just a hint, and this
> -		 * will succeed in general.
> -		 */
> -		if (ip->i_udquot->q_gdquot == ip->i_gdquot)
> -			goto done;
> -		/*
> -		 * Attach i_gdquot to the gdquot hint inside the i_udquot.
> +		 * We do not have i_udquot locked at this point, but this check
> +		 * is OK since we don't depend on the i_gdquot to be accurate
> +		 * 100% all the time. It is just a hint, and this will
> +		 * succeed in general.
>  		 */

Tsk.  Lets not be too smart for our own good.

> -		xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot);
> +		if (ip->i_udquot->q_gdquot != ip->i_gdquot)
> +			xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot);
>  	}
>  
>   done:
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
