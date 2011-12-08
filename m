Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB8LA7xs164189 for <xfs@oss.sgi.com>; Thu, 8 Dec 2011 15:10:08 -0600
Date: Thu, 8 Dec 2011 15:10:30 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 04/19] xfs: untange SYNC_WAIT and SYNC_TRYLOCK meanings
	for xfs_qm_dqflush
Message-ID: <20111208211030.GU29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215853.264745959@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215853.264745959@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:10PM -0500, Christoph Hellwig wrote:
> Only skip pinned dquots if SYNC_TRYLOCK is specified, and adjust the callers
> to keep the behaviour unchanged.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

s/untange/untangle  in the subject line.

> ---
>  fs/xfs/xfs_dquot.c      |    2 +-
>  fs/xfs/xfs_dquot_item.c |    2 +-
>  fs/xfs/xfs_qm.c         |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_dquot.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dquot.c	2011-11-05 08:54:01.729993938 +0100
> +++ xfs/fs/xfs/xfs_dquot.c	2011-11-25 11:45:32.668742260 +0100
> @@ -1169,7 +1169,7 @@ xfs_qm_dqflush(
>  	 * If not dirty, or it's pinned and we are not supposed to block, nada.
>  	 */
>  	if (!XFS_DQ_IS_DIRTY(dqp) ||
> -	    (!(flags & SYNC_WAIT) && atomic_read(&dqp->q_pincount) > 0)) {
> +	    ((flags & SYNC_TRYLOCK) && atomic_read(&dqp->q_pincount) > 0)) {

There is a SYNC_WAIT at the bottom of xfs_qm_dqflush.  Should it be
modified too?

>  		xfs_dqfunlock(dqp);
>  		return 0;
>  	}
> Index: xfs/fs/xfs/xfs_dquot_item.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dquot_item.c	2011-11-25 11:43:25.269432441 +0100
> +++ xfs/fs/xfs/xfs_dquot_item.c	2011-11-25 11:45:32.668742260 +0100
> @@ -133,7 +133,7 @@ xfs_qm_dquot_logitem_push(
>  	 * lock without sleeping, then there must not have been
>  	 * anyone in the process of flushing the dquot.
>  	 */
> -	error = xfs_qm_dqflush(dqp, 0);
> +	error = xfs_qm_dqflush(dqp, SYNC_TRYLOCK);
>  	if (error)
>  		xfs_warn(dqp->q_mount, "%s: push error %d on dqp %p",
>  			__func__, error, dqp);
> Index: xfs/fs/xfs/xfs_qm.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm.c	2011-11-19 20:14:00.400421363 +0100
> +++ xfs/fs/xfs/xfs_qm.c	2011-11-25 11:45:32.672075575 +0100
> @@ -1661,7 +1661,7 @@ xfs_qm_quotacheck(
>  	 * successfully.
>  	 */
>  	if (!error)
> -		error = xfs_qm_dqflush_all(mp, 0);
> +		error = xfs_qm_dqflush_all(mp, SYNC_TRYLOCK);
>  
>  	/*
>  	 * We can get this error if we couldn't do a dquot allocation inside

from xfs_qm_dqreclaim_one:
	/*
	 * We flush it delayed write, so don't bother
	 * releasing the freelist lock.
	 */
	error = xfs_qm_dqflush(dqp, 0); 

Should that also be changed to SYNC_TRYLOCK?

SYNC_TRYLOCK also has meaning for xfs_qm_sync().  Maybe the intention
was that SYNC_TRYLOCK would be used with xfs_qm_sync, and SYNC_WAIT with
xfs_qm_dqflush?

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
