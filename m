Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ns.lynxeye.de ([87.118.118.114]:53243 "EHLO lynxeye.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755913AbcJVSwt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 22 Oct 2016 14:52:49 -0400
Message-ID: <1477162364.2070.24.camel@lynxeye.de>
Subject: Re: [PATCH 2/2] xfs: switch buffer cache entries to RCU freeing
From: Lucas Stach <dev@lynxeye.de>
Date: Sat, 22 Oct 2016 20:52:44 +0200
In-Reply-To: <20161018224347.GE23194@dastard>
References: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
         <1476821653-2595-3-git-send-email-dev@lynxeye.de>
         <20161018224347.GE23194@dastard>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Am Mittwoch, den 19.10.2016, 09:43 +1100 schrieb Dave Chinner:
> On Tue, Oct 18, 2016 at 10:14:13PM +0200, Lucas Stach wrote:
> > 
> > The buffer cache hash as the indexing data structure into the
> > buffer
> > cache is already protected by RCU. By freeing the entries itself by
> > RCU we can get rid of the buffer cache lock altogether.
> > 
> > Signed-off-by: Lucas Stach <dev@lynxeye.de>
> > ---
> >  fs/xfs/xfs_buf.c   | 41 +++++++++++++++++++++++++++--------------
> >  fs/xfs/xfs_buf.h   |  2 ++
> >  fs/xfs/xfs_mount.h |  1 -
> >  3 files changed, 29 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 50c5b01..3ee0a3d1 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -326,6 +326,16 @@ xfs_buf_free(
> >  	kmem_zone_free(xfs_buf_zone, bp);
> >  }
> >  
> > +STATIC void
> > +__xfs_buf_rcu_free(
> > +	struct rcu_head	*head)
> > +{
> > +	xfs_buf_t *bp = container_of(head, struct xfs_buf,
> > rcu_head);
> > +
> > +	ASSERT(atomic_read(&bp->b_hold) == 0);
> > +	xfs_buf_free(bp);
> > +}
> > +
> >  /*
> >   * Allocates all the pages for buffer in question and builds it's
> > page list.
> >   */
> > @@ -491,6 +501,14 @@ _xfs_buf_cmp(
> >  	BUILD_BUG_ON(offsetof(struct xfs_buf_cmp_arg, blkno) !=
> > 0);
> >  
> >  	if (bp->b_bn == cmp_arg->blkno) {
> > +		/*
> > +		 * Skip matches with a hold count of zero, as they
> > are about to
> > +		 * be freed by RCU. Continue searching as another
> > valid entry
> > +		 * might have already been inserted into the hash.
> > +		 */
> > +		if (unlikely(atomic_read(&bp->b_hold) == 0))
> > +			return 1;
> 
> This is an invalid assumption. Buffers transition through a hold
> count of zero when they get moved to the LRU list, which then adds
> a reference for the LRU list so the hold count goes back above zero.
> The pag_buf_lock serialised this 1->0->1 hold count change so it
> wasn't ever seen by lookups or concurrent xfs_buf_rele() calls.
> 
> Removing the pag_buf_lock around freeing of buffers and lookup
> exposes this transition to lookup and so b_hold cannot be used like
> this to determine if a buffer is being freed or not.
> 
> Like I said, there is some really subtle stuff in the buffer
> lifecycle management....
> 
> Hmmmm - because this is now all RCU-ised, we are going to need some
> form of memory barrier to ensure that whatever we use to detect
> buffers in the RCU grace period is race free. I suspect the easiest
> thing to do is to use the bp->b_lock spinlock to set a noticable
> "buffer being freed" state in xfs_buf_rele() that we can check in
> lookup under the spinlock. That way the lock provides the memory
> barrier we need and it also provides serialisation against
> transient hold count values in xfs_buf_rele() similar to what the
> pag_buf_lock used to provide....
> 
> (FYI: the internal object spinlock pattern is what we use for the
> RCU lookup vs freeing serialisation in the XFS inode cache....)
> 

Thanks. Using the internal spinlock seems like a good idea.

> > 
> > @@ -580,14 +597,16 @@ _xfs_buf_find(
> >  	pag = xfs_perag_get(btp->bt_mount,
> >  			    xfs_daddr_to_agno(btp->bt_mount,
> > cmp_arg.blkno));
> >  
> > +	rcu_read_lock();
> >  	/* lookup buf in pag hash */
> > -	spin_lock(&pag->pag_buf_lock);
> >  	bp = rhashtable_lookup_fast(&pag->pag_buf_hash, &cmp_arg,
> >  				    xfs_buf_hash_params);
> > -	if (bp) {
> > -		atomic_inc(&bp->b_hold);
> > +
> > +	/* if the hold count is zero the buffer is about to be
> > freed by RCU */
> > +	if (bp && atomic_inc_not_zero(&bp->b_hold))
> >  		goto found;
> > -	}
> > +
> > +	rcu_read_unlock();
> 
> This has the same problem with transient 0 hold counts in
> xfs_buf_rele(). I suspect that we need to take the hold reference in
> the xfs_buf_rhash_compare() function where we need to take the
> bp->b_lock() to check for the buffer being in the rcu grace
> period. If it's not being freed, we should take a reference right
> then so that it doesn't get freed between the lookup check and the
> buffer being returned...
> 
I don't think this will work with rhashtables. The internal workings of
those depend on being able to call the compare function multiple times
on a single lookup, so you can't do anything in the lookup that changes
the state of the object.

I think the best we can do is to skip buffers that are already in
"going to be freed" state in the lookup (without taking the bp-
>b_lock).
Then take the lock to increase the hold count and recheck if the object
transitioned into the "about to be freed" state between our lookup and
the time we got the lock. If the object is marked from removal at this
point we need to retry the lookup, I think.

Regards,
Lucas
