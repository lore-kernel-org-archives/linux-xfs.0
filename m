Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:8295 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755546AbcJXCh7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Oct 2016 22:37:59 -0400
Date: Mon, 24 Oct 2016 13:37:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: switch buffer cache entries to RCU freeing
Message-ID: <20161024023755.GW14023@dastard>
References: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
 <1476821653-2595-3-git-send-email-dev@lynxeye.de>
 <20161018224347.GE23194@dastard>
 <1477162364.2070.24.camel@lynxeye.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1477162364.2070.24.camel@lynxeye.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <dev@lynxeye.de>
Cc: linux-xfs@vger.kernel.org

On Sat, Oct 22, 2016 at 08:52:44PM +0200, Lucas Stach wrote:
> Am Mittwoch, den 19.10.2016, 09:43 +1100 schrieb Dave Chinner:
> > On Tue, Oct 18, 2016 at 10:14:13PM +0200, Lucas Stach wrote:
> > >  			    xfs_daddr_to_agno(btp->bt_mount,
> > > cmp_arg.blkno));
> > >  
> > > +	rcu_read_lock();
> > >  	/* lookup buf in pag hash */
> > > -	spin_lock(&pag->pag_buf_lock);
> > >  	bp = rhashtable_lookup_fast(&pag->pag_buf_hash, &cmp_arg,
> > >  				    xfs_buf_hash_params);
> > > -	if (bp) {
> > > -		atomic_inc(&bp->b_hold);
> > > +
> > > +	/* if the hold count is zero the buffer is about to be
> > > freed by RCU */
> > > +	if (bp && atomic_inc_not_zero(&bp->b_hold))
> > >  		goto found;
> > > -	}
> > > +
> > > +	rcu_read_unlock();
> > 
> > This has the same problem with transient 0 hold counts in
> > xfs_buf_rele(). I suspect that we need to take the hold reference in
> > the xfs_buf_rhash_compare() function where we need to take the
> > bp->b_lock() to check for the buffer being in the rcu grace
> > period. If it's not being freed, we should take a reference right
> > then so that it doesn't get freed between the lookup check and the
> > buffer being returned...
> > 
> I don't think this will work with rhashtables. The internal workings of
> those depend on being able to call the compare function multiple times
> on a single lookup, so you can't do anything in the lookup that changes
> the state of the object.

That's not documented anywhere iin the code that I can find. :(
It would be nice to have important API details like that documented
somewhere obvious....

> I think the best we can do is to skip buffers that are already in
> "going to be freed" state in the lookup (without taking the bp-
> >b_lock).

Let's get our terminology straight here to avoid confusion. You're
talking about checking in the compare function here, right? As
opposed to checking the object returned by the lookup function?

> Then take the lock to increase the hold count and recheck if the object
> transitioned into the "about to be freed" state between our lookup and
> the time we got the lock.

.... between the check in the compare function and the time we got
the lock in the object returned?

If so, There is no need to increase the hold count before we check
the freeing state once we have the lock - freeing will serialise
against the lock we take on the buffer object the lookup returns
before it can drop the last reference and free it. Hence as long as
we increment the hold count before we drop the lock we are good...

> If the object is marked from removal at this
> point we need to retry the lookup, I think.

Yup, seems reasonable. Probably best to hook up the xb_miss_locked
stat in this case, too...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
