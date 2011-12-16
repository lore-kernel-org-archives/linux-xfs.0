Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBGLXHhq069455 for <xfs@oss.sgi.com>; Fri, 16 Dec 2011 15:33:17 -0600
Date: Fri, 16 Dec 2011 15:33:41 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 15/19] xfs: simplify xfs_qm_detach_gdquots
Message-ID: <20111216213341.GP29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215855.306880439@bombadil.infradead.org>
	<20111215164314.GI29840@sgi.com> <20111216004845.GB23662@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111216004845.GB23662@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Dec 16, 2011 at 11:48:45AM +1100, Dave Chinner wrote:
> On Thu, Dec 15, 2011 at 10:43:14AM -0600, Ben Myers wrote:
> > On Tue, Dec 06, 2011 at 04:58:21PM -0500, Christoph Hellwig wrote:
> > > There is no reason to drop qi_dqlist_lock around calls to xfs_qm_dqrele
> > > because the free list lock now nests inside qi_dqlist_lock and the
> > > dquot lock.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > > 
> > > ---
> > >  fs/xfs/xfs_qm.c |   22 +++++-----------------
> > >  1 file changed, 5 insertions(+), 17 deletions(-)
> > > 
> > > Index: xfs/fs/xfs/xfs_qm.c
> > > ===================================================================
> > > --- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:40:07.538179215 +0200
> > > +++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:08.124671538 +0200
> > > @@ -449,7 +449,6 @@ xfs_qm_detach_gdquots(
> > >  {
> > >  	struct xfs_quotainfo	*q = mp->m_quotainfo;
> > >  	struct xfs_dquot	*dqp, *gdqp;
> > > -	int			nrecl;
> > >  
> > >   again:
> > >  	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
> > > @@ -462,25 +461,14 @@ xfs_qm_detach_gdquots(
> > >  			mutex_lock(&q->qi_dqlist_lock);
> > >  			goto again;
> > >  		}
> > > -		if ((gdqp = dqp->q_gdquot)) {
> > > -			xfs_dqlock(gdqp);
> > 
> > Why don't we need to take the dqlock on gdqp here before dropping the
> > lock on dqp?
> 
> Because we have an active reference on it, it's guaranteed not to go
> away from under us. Hence we don't need to lock it before we unlock
> the dqp which holds that reference. As it is, the subsequent
> xfs_qm_dqrele() takes the lock before dropping the reference we
> currently hold.
> 
> > 
> > > +
> > > +		gdqp = dqp->q_gdquot;
> > > +		if (gdqp)
> > >  			dqp->q_gdquot = NULL;
> > > -		}
> > >  		xfs_dqunlock(dqp);
> > >  
> > > -		if (gdqp) {
> > > -			/*
> > > -			 * Can't hold the mplist lock across a dqput.
> > > -			 * XXXmust convert to marker based iterations here.
> > > -			 */
> > > -			nrecl = q->qi_dqreclaims;
> > > -			mutex_unlock(&q->qi_dqlist_lock);
> > > -			xfs_qm_dqput(gdqp);
> > > -
> > > -			mutex_lock(&q->qi_dqlist_lock);
> > > -			if (nrecl != q->qi_dqreclaims)
> > 
> > Why is it ok to ignore di_dqreclaims now?
> 
> That was there to tell us if the list we are traversing was modified
> or not while we had the lock dropped. If is was, then out list next
> pointer may not be valid, so we have to restart the traversal from
> the start.
> 
> We don't drop the lock any more, so we know that the list cannot be
> modified when we drop the current reference on the gdqp. Hence we
> don't need the check anymore.

Thanks Dave.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
