Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBDHULTE164354 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 11:30:22 -0600
Date: Tue, 13 Dec 2011 11:30:46 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 09/19] xfs: cleanup xfs_qm_dqlookup
Message-ID: <20111213173046.GA29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215854.196332791@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215854.196332791@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:15PM -0500, Christoph Hellwig wrote:
> Rearrange the code to avoid the conditional locking around the flist_locked
> variable.  This means we lose a (rather pointless) assert, and hold the
> freelist lock a bit longer for one corner case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

> ---
>  fs/xfs/xfs_dquot.c |   25 +++++--------------------
>  1 file changed, 5 insertions(+), 20 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_dquot.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dquot.c	2011-10-27 22:40:02.250173174 +0200
> +++ xfs/fs/xfs/xfs_dquot.c	2011-10-27 22:40:02.770171231 +0200
> @@ -710,12 +710,9 @@ xfs_qm_dqlookup(
>  	xfs_dquot_t		**O_dqpp)
>  {
>  	xfs_dquot_t		*dqp;
> -	uint			flist_locked;
>  
>  	ASSERT(mutex_is_locked(&qh->qh_lock));
>  
> -	flist_locked = B_FALSE;
> -
>  	/*
>  	 * Traverse the hashchain looking for a match
>  	 */
> @@ -750,31 +747,19 @@ xfs_qm_dqlookup(
>  					xfs_dqlock(dqp);
>  					dqp->dq_flags &= ~(XFS_DQ_WANT);
>  				}
> -				flist_locked = B_TRUE;
> -			}
> -
> -			/*
> -			 * id couldn't have changed; we had the hashlock all
> -			 * along
> -			 */
> -			ASSERT(be32_to_cpu(dqp->q_core.d_id) == id);
>  
> -			if (flist_locked) {
> -				if (dqp->q_nrefs != 0) {
> -					mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
> -					flist_locked = B_FALSE;
> -				} else {
> +				if (dqp->q_nrefs == 0) {

Ah.  We have to check this again because we would have unlocked and
reaquired the dqlock when we went for the free list lock in the
contended case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
