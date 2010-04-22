Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MGEVua213490 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 11:14:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A82415480EA
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:16:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	4bcEDEBPWgayaeBU for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 09:16:29 -0700 (PDT)
Date: Fri, 23 Apr 2010 02:16:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Improve scalability of busy extent tracking
Message-ID: <20100422161626.GE23541@dastard>
References: <1271828835-2094-1-git-send-email-david@fromorbit.com>
	<20100422110143.GA21867@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100422110143.GA21867@infradead.org>
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

On Thu, Apr 22, 2010 at 07:01:43AM -0400, Christoph Hellwig wrote:
> Having the patches merged into one certainly helps with readability.
> This version also passes xfsqa fine while I had some problems with that
> with the delayed logging tree.
> 
> > o busy extent transaction owner tracked by transaction id, not by
> >   address of transaction structure. Tracking by address of the
> >   transaction was triggering false ASSERT failures when searching for
> >   busy extents with matching start block numbers.
> 
> I'm a bit confused by that.  How can we ever find a xfs_busy_extent
> structure for a transaction that's been freed?  We always call
> xfs_trans_free_busy before freeing the transaction, so this should
> never happen.

Yeah, I can't explain the root cause, either.  Short story: at the
time I did this I was getting desperate - I'd been trying to work
out the failure you reported for three days and had tried just
about everything I could think of. I was thinking that "I know this
can't happen but I'm going to rule it out, anyway." 

Long story:

I managed to reproduce the xfsqa failures you were seeing in the
previous version - I could only reproduce it on a single CPU VM
with full kernel preemption enabled. I could get it to either
the ASSERT(sync transaction) or corrupt the rbtree.

I confirmed via gdb that when the ASSERT fired the transaction
pointed to by the busy extent matched the address of the transaction
passed in, but it did not look like the right transaction in any
way. i.e. no tracked busy extents, not marked sync, very few items
attached and it was usually the first allocation in the transaction.
I turned on slab poisoning, the kmemleak detector and so on, and
none of them fired indicating a use after free or anything like
that. If I looked at the rbtree at this time, it was almost always
corrupted in some way.

But then there was the fact that none of the debug I put in to
verify the rbtree structure ever caught the tree corruption when it
occurred. I only ever caught a corrupted tree before an operation
was done, never after an operation had been done.  And not only
that, the busy extent tracing only ever indicated valid operation
sequences leading up to the corruption detection and that the busy
extent should not be in the tree whenever the ASSERT fired.

Basically, I could only conclude that the tree was being corrupted
by some outside event. Every time I triggered the problem, i ended
up seeing exactly the same sort of corruption, but never any new
information that would lead me to what corrupted the tree.

This is where I started on trying things that couldn't happen.
Reference counting transactions was the first thing I tried, and
that didn't fix the problem. Then I randomised the transaction IDs
and switched to tracking them to avoid the possibility that
somewhere, somehow we incorrectly matched a re-allocated
transaction.

To my surprise that made all the failures go away. I can't corrupt
the rbtree, I can't trigger the sync transaction assert, none of the
debug I added to verify the rbtree found any problems any more, etc,
and no matter how much stress or how many different workloads I test
against, I cannot get the problem to trip again on any sort of
configuration I can test here.

Hence I delayed sending this out again because I'm still clueless as
to the root cause and I've been hoping I'd be able to see a new
problem with it. But i haven't seen any problems, with or without
delayed logging, so wider testing is the only way I'm going to
uncover any lingering problem. In a way, I'm kind of disappointed
that it fixed the problem you reported...

> And if it can happen we can also get a reuse of the tid,
> even if it is much more likely.  So if there's a corner case I've
> missed we really need to keep a pointer to the xlog_ticket and keep
> a reference on it as long as we have busy extents belonging to it in
> the rbtree.

Like I said, i tried that and it didn't help.

> Besides that here's a few cosmetic comments:
> 
> > -STATIC void
> > -xfs_alloc_search_busy(xfs_trans_t *tp,
> > -		    xfs_agnumber_t agno,
> > -		    xfs_agblock_t bno,
> > -		    xfs_extlen_t len);
> > +static int
> > +xfs_alloc_busy_search(struct xfs_mount *mp, xfs_agnumber_t agno,
> > +		    xfs_agblock_t bno, xfs_extlen_t len);
> 
> The switch in naming convention looks good to me, but it should
> also be applied to xfs_alloc_clear_busy (-> xfs_alloc_busy_clear?)
> and xfs_alloc_mark_busy (-> xfs_alloc_busy_add/insert?)

Yeah, I can do that.

> > +xfs_alloc_mark_busy(
> > +	struct xfs_trans	*tp,
> > +	xfs_agnumber_t		agno,
> > +	xfs_agblock_t		bno,
> > +	xfs_extlen_t		len)
> >  {
> > +	struct xfs_busy_extent	*busyp;
> >  
> > +	busyp = kmem_zalloc(sizeof(struct xfs_busy_extent), KM_MAYFAIL);
> > +	if (!busyp) {
> > +		/*
> > +		 * No Memory!  Since it is now not possible to track the free
> > +		 * block, make this a synchronous transaction to insure that
> > +		 * the block is not reused before this transaction commits.
> > +		 */
> > +		trace_xfs_alloc_busy(tp, agno, bno, len, 1);
> > +		xfs_trans_set_sync(tp);
> > +		return;
> >  	}
> >  
> > +	busyp->agno = agno;
> > +	busyp->bno = bno;
> > +	busyp->length = len;
> > +	busyp->tid = xfs_trans_get_tid(tp);
> > +	INIT_LIST_HEAD(&busyp->list);
> >  
> > +	/* trace before insert to be able to see failed inserts */
> > +	trace_xfs_alloc_busy(tp, agno, bno, len, 0);
> > +	xfs_alloc_busy_insert(tp, busyp);
> > +}
> 
> I'd rather inline xfs_alloc_busy_insert into this function, there's no
> good reason to keep it separate.

OK.

> > -	xfs_trans_clear_busy_extents(tp);
> > +	xfs_trans_free_busy(tp->t_mountp, &tp->t_busy);
> >  	xfs_trans_free(tp);
> >  }
> >  
> > @@ -1013,7 +1016,7 @@ xfs_trans_uncommit(
> >  	xfs_trans_unreserve_and_mod_dquots(tp);
> >  
> >  	xfs_trans_free_items(tp, flags);
> > -	xfs_trans_free_busy(tp);
> > +	xfs_trans_free_busy(tp->t_mountp, &tp->t_busy);
> 
> There's no real need for the prototype change at this point.  I know
> you'll need it for the delayed logging, but let's keep the prototype
> change in that patchset.

Ok. will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
