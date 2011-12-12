Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCMX1c0125716 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 16:33:01 -0600
Date: Mon, 12 Dec 2011 16:33:26 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 07/19] xfs: remove the sync_mode argument to
	xfs_qm_dqflush_all
Message-ID: <20111212223326.GY29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215853.809602126@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215853.809602126@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:13PM -0500, Christoph Hellwig wrote:
> It always is zero, and removing it will make future changes easier.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good
Reviewed-by: Ben Myers <bpm@sgi.com>

> ---
>  fs/xfs/xfs_qm.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_qm.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm.c	2011-11-25 11:45:37.468716258 +0100
> +++ xfs/fs/xfs/xfs_qm.c	2011-11-25 11:45:39.375372594 +0100
> @@ -415,8 +415,7 @@ xfs_qm_unmount_quotas(
>   */
>  STATIC int
>  xfs_qm_dqflush_all(
> -	struct xfs_mount	*mp,
> -	int			sync_mode)
> +	struct xfs_mount	*mp)
>  {
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
>  	int			recl;
> @@ -451,7 +450,7 @@ again:
>  		 * across a disk write.
>  		 */
>  		mutex_unlock(&q->qi_dqlist_lock);
> -		error = xfs_qm_dqflush(dqp, sync_mode);
> +		error = xfs_qm_dqflush(dqp, 0);
>  		xfs_dqunlock(dqp);
>  		if (error)
>  			return error;
> @@ -1567,7 +1566,7 @@ xfs_qm_quotacheck(
>  	 * successfully.
>  	 */
>  	if (!error)
> -		error = xfs_qm_dqflush_all(mp, 0);
> +		error = xfs_qm_dqflush_all(mp);
>  
>  	/*
>  	 * We can get this error if we couldn't do a dquot allocation inside
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
