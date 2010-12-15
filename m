Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBF2n4PR163108 for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 20:49:05 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43C8E1ECFDE
	for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 18:50:55 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	UBe9ceeBNZqncP6Y for <xfs@oss.sgi.com>;
	Tue, 14 Dec 2010 18:50:55 -0800 (PST)
Date: Wed, 15 Dec 2010 13:50:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: convert inode cache lookups to use RCU locking
Message-ID: <20101215025049.GE9925@dastard>
References: <1292203957-15819-1-git-send-email-david@fromorbit.com>
	<1292203957-15819-3-git-send-email-david@fromorbit.com>
	<20101214211801.GH2161@linux.vnet.ibm.com>
	<20101214230047.GC16267@dastard>
	<20101215010536.GT2161@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101215010536.GT2161@linux.vnet.ibm.com>
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
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: eric.dumazet@gmail.com, xfs@oss.sgi.com

On Tue, Dec 14, 2010 at 05:05:36PM -0800, Paul E. McKenney wrote:
> On Wed, Dec 15, 2010 at 10:00:47AM +1100, Dave Chinner wrote:
> > On Tue, Dec 14, 2010 at 01:18:01PM -0800, Paul E. McKenney wrote:
> > > On Mon, Dec 13, 2010 at 12:32:36PM +1100, Dave Chinner wrote:
> > > > +	/*
> > > > +	 * check for re-use of an inode within an RCU grace period due to the
> > > > +	 * radix tree nodes not being updated yet. We monitor for this by
> > > > +	 * setting the inode number to zero before freeing the inode structure.
> > > > +	 * If the inode has been reallocated and set up, then the inode number
> > > > +	 * will not match, so check for that, too.
> > > > +	 */
> > > >  	spin_lock(&ip->i_flags_lock);
> > > > +	if (ip->i_ino != ino) {
> > > > +		trace_xfs_iget_skip(ip);
> > > > +		XFS_STATS_INC(xs_ig_frecycle);
> > > > +		spin_unlock(&ip->i_flags_lock);
> > > > +		rcu_read_unlock();
> > > > +		/* Expire the grace period so we don't trip over it again. */
> > > > +		synchronize_rcu();
> > > 
> > > Hmmm...  Interesting.  Wouldn't the fact that we acquired the same lock
> > > that was held after removing the inode guarantee that an immediate retry
> > > would manage not to find this same inode again?
> > 
> > That is what I'm not sure of. I was more worried about resolving the
> > contents of the radix tree nodes, not so much the inode itself. If a
> > new traversal will resolve the tree correctly (which is what you are
> > implying), then synchronize_rcu() is not needed....
> 
> Here is the sequence of events that I believe must be in place:
> 

s/vfs_inode/xfs_inode/g

> 1.	Some CPU removes the vfs_inode from the radix tree, presumably
> 	while holding some lock whose identity does not matter here.

Yes, the ->pag_ici_lock.

> 2.	Before invoking call_rcu() on a given vfs_inode, this same
> 	CPU clears the inode number while holding ->i_flags_lock.

Not necessarily the same CPU - there are points where we take
sleeping locks for synchronisation with any remaining users, and
we don't use preempt_disable() to prevent a change of CPU on a
preemptible kernel.

> 	If the CPU in #1 and #2 might be different, then either
> 	CPU #1 must hold ->i_flags_lock while removing the vfs_inode
> 	from the radix tree, or I don't understand how this can work
> 	even with the synchronize_rcu().

I'm probably missing something, but why does the CPU we run
call_rcu() to free the inode on matter w.r.t. which CPU it was
deleted from the radix tree on?

There is this comment in include/linux/radix-tree.h:

 * It is still required that the caller manage the synchronization and lifetimes
 * of the items. So if RCU lock-free lookups are used, typically this would mean
 * that the items have their own locks, or are amenable to lock-free access; and
 * that the items are freed by RCU (or only freed after having been deleted from
 * the radix tree *and* a synchronize_rcu() grace period).

There is nothing there that mentions the items need to be deleted on
the same CPU as they were removed from the radix tree or that the
item lock needs to be held when the item is removed from the tree.
AFAICT, the XFS code is following these guidelines.

FWIW, this is where is got the idea of using synchronize_rcu() to
ensure a llokup retry wouldn't see the same freed inode. I'm
thinking that simply re-running the lookup will give the same
guarantee because of the memory barriers in the radix tree lookup
code...

> 3.	Some CPU, possibly different than that in #1 and #2 above,
> 	executes the above code.  If locking works correctly, it
> 	must see the earlier changes, so a subsequent access should
> 	see the results of #1 above, so that it won't see the element
> 	that was removed there.

Isn't the item validity considered separately to the tree traversal
consistency? i.e. the item lock (i.e. ->i_flags_lock) provides a
safe item validity check via the unlock->lock memory barrier, whilst
the radix tree uses rcu_dereference() to provide memory barriers
against the modifications?

> That said, I don't claim to understand either vfs or xfs very well, so
> I would be arbitrarily deeply confused.

We might both be confused ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
