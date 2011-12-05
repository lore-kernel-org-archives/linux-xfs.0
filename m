Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB59BN2Q124394 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 03:11:23 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52FCF29A252
	for <xfs@oss.sgi.com>; Mon,  5 Dec 2011 01:11:21 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	9GNi8TO2rAeeU6ki for <xfs@oss.sgi.com>;
	Mon, 05 Dec 2011 01:11:21 -0800 (PST)
Date: Mon, 5 Dec 2011 04:11:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/16] xfs: flatten the dquot lock ordering
Message-ID: <20111205091121.GA22018@infradead.org>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082837.808570926@bombadil.infradead.org>
	<20111205050428.GP7046@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111205050428.GP7046@dastard>
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

On Mon, Dec 05, 2011 at 04:04:28PM +1100, Dave Chinner wrote:
> Ok, so we now mark dquots being freed with a flag, and then avoid
> those inodes during various operations as they dquots are considered
> dead.
> 
> That means we can use the fact that nothing new will ever use the
> dquot being freed while it is still active on lists, so we don't
> need to nest locks during reclaim of the dquot to prevent concurrent
> lookups from finding it.
> 
> Did i understand the intent correctly?

Yes.

> > +	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
> > +	ASSERT(!list_empty(&dqp->q_freelist));
> >  	list_del_init(&dqp->q_freelist);
> 
> That assert could do with a comment - I had to think hard about why
> that was correct. It's because when the dquot refcount goes to zero it
> is moved onto the free list, so when reclaiming a dquot we should
> always find it on the free list....

Indeed.  I'll see if I can come up with a sensible comment.

> > @@ -509,46 +518,27 @@ xfs_qm_dqpurge_int(
> >  	 */
> >  	xfs_qm_detach_gdquots(mp);
> >  
> > -      again:
> > -	nmisses = 0;
> 
> I don't think that nmisses is initialised to zero correctly anymore.

We do a

        int                     nmisses = 0;

at the top of the function.  Now that there are no retry loops that's
sufficient.

> 
> > -	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
> >  	/*
> >  	 * Try to get rid of all of the unwanted dquots. The idea is to
> >  	 * get them off mplist and hashlist, but leave them on freelist.
> >  	 */
> 
> That comment is no longer correct - they purged dquots don't remain
> on the freelist anymore - they are freed....

I'll fix it up.

> >  		/*
> > +		 * Prevent lookups now that we are past the point of no return.
> >  		 */
> > -		if (!mutex_trylock(&dqp->q_hash->qh_lock)) {
> > -			restarts++;
> > -			goto dqfunlock;
> > -		}
> > +		dqp->dq_flags |= XFS_DQ_FREEING;
> > +		xfs_dqunlock(dqp);
> 
> Probably worth commenting here that it is safe to access the dquot
> unlocked because we own the XFS_DQ_FREEING flag that guarantees
> nobody else will start using the dquot once we unlock it.

I'll make the comment a bit more verbose.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
