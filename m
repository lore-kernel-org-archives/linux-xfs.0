Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBF6WkqF177346 for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 00:32:47 -0600
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A6671CC88FA
	for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 22:34:38 -0800 (PST)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id K5aMZRLJ3Rh0Q5ef for
	<xfs@oss.sgi.com>; Tue, 14 Dec 2010 22:34:38 -0800 (PST)
Received: from d01dlp02.pok.ibm.com (d01dlp02.pok.ibm.com [9.56.224.85])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id oBF6GoQu019515
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 01:16:50 -0500
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 39CED4DE803E
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 01:32:32 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	oBF6YbdY163328 for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 01:34:37 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	oBF6YbFk023568 for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 01:34:37 -0500
Date: Tue, 14 Dec 2010 22:34:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] xfs: convert inode cache lookups to use RCU locking
Message-ID: <20101215063435.GB2217@linux.vnet.ibm.com>
References: <1292203957-15819-1-git-send-email-david@fromorbit.com>
	<1292203957-15819-3-git-send-email-david@fromorbit.com>
	<20101214211801.GH2161@linux.vnet.ibm.com>
	<20101214230047.GC16267@dastard>
	<20101215010536.GT2161@linux.vnet.ibm.com>
	<20101215025049.GE9925@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101215025049.GE9925@dastard>
Reply-To: paulmck@linux.vnet.ibm.com
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
Cc: eric.dumazet@gmail.com, xfs@oss.sgi.com

On Wed, Dec 15, 2010 at 01:50:49PM +1100, Dave Chinner wrote:
> On Tue, Dec 14, 2010 at 05:05:36PM -0800, Paul E. McKenney wrote:
> > On Wed, Dec 15, 2010 at 10:00:47AM +1100, Dave Chinner wrote:
> > > On Tue, Dec 14, 2010 at 01:18:01PM -0800, Paul E. McKenney wrote:
> > > > On Mon, Dec 13, 2010 at 12:32:36PM +1100, Dave Chinner wrote:
> > > > > +	/*
> > > > > +	 * check for re-use of an inode within an RCU grace period due to the
> > > > > +	 * radix tree nodes not being updated yet. We monitor for this by
> > > > > +	 * setting the inode number to zero before freeing the inode structure.
> > > > > +	 * If the inode has been reallocated and set up, then the inode number
> > > > > +	 * will not match, so check for that, too.
> > > > > +	 */
> > > > >  	spin_lock(&ip->i_flags_lock);
> > > > > +	if (ip->i_ino != ino) {
> > > > > +		trace_xfs_iget_skip(ip);
> > > > > +		XFS_STATS_INC(xs_ig_frecycle);
> > > > > +		spin_unlock(&ip->i_flags_lock);
> > > > > +		rcu_read_unlock();
> > > > > +		/* Expire the grace period so we don't trip over it again. */
> > > > > +		synchronize_rcu();
> > > > 
> > > > Hmmm...  Interesting.  Wouldn't the fact that we acquired the same lock
> > > > that was held after removing the inode guarantee that an immediate retry
> > > > would manage not to find this same inode again?
> > > 
> > > That is what I'm not sure of. I was more worried about resolving the
> > > contents of the radix tree nodes, not so much the inode itself. If a
> > > new traversal will resolve the tree correctly (which is what you are
> > > implying), then synchronize_rcu() is not needed....
> > 
> > Here is the sequence of events that I believe must be in place:
> 
> s/vfs_inode/xfs_inode/g

Good point!

> > 1.	Some CPU removes the vfs_inode from the radix tree, presumably
> > 	while holding some lock whose identity does not matter here.
> 
> Yes, the ->pag_ici_lock.

OK.

> > 2.	Before invoking call_rcu() on a given vfs_inode, this same
> > 	CPU clears the inode number while holding ->i_flags_lock.
> 
> Not necessarily the same CPU - there are points where we take
> sleeping locks for synchronisation with any remaining users, and
> we don't use preempt_disable() to prevent a change of CPU on a
> preemptible kernel.
> 
> > 	If the CPU in #1 and #2 might be different, then either
> > 	CPU #1 must hold ->i_flags_lock while removing the vfs_inode
> > 	from the radix tree, or I don't understand how this can work
> > 	even with the synchronize_rcu().
> 
> I'm probably missing something, but why does the CPU we run
> call_rcu() to free the inode on matter w.r.t. which CPU it was
> deleted from the radix tree on?

I was oversimplifying.  What matters is that the item was deleted
from the radix tree unambiguously before it was passed to call_rcu().
There are a number of ways to make this happen:

1.	Do the removal and the call_rcu() on the same CPU, in that
	order.

2.	Do the removal while holding a given lock, and do the call_rcu()
	under a later critical section for that same lock.

3.	Do the removal while holding lock A one CPU 1, then later
	acquire lock B on CPU 1, and then do the call_rcu() after
	a later acquisition of lock B on some other CPU.

There are a bunch of other variations on this theme, but the key
requirement is again that the call_rcu() happen unambiguously after
the removal.  Otherwise, how is the grace period supposed to
guarantee that all RCU readers that might be accessing the removed
xfs_inode really have completed?

> There is this comment in include/linux/radix-tree.h:
> 
>  * It is still required that the caller manage the synchronization and lifetimes
>  * of the items. So if RCU lock-free lookups are used, typically this would mean
>  * that the items have their own locks, or are amenable to lock-free access; and
>  * that the items are freed by RCU (or only freed after having been deleted from
>  * the radix tree *and* a synchronize_rcu() grace period).
> 
> There is nothing there that mentions the items need to be deleted on
> the same CPU as they were removed from the radix tree or that the
> item lock needs to be held when the item is removed from the tree.
> AFAICT, the XFS code is following these guidelines.

Well, the grace period (from either synchronize_rcu() or call_rcu())
does need to start unambiguously after the deletion from the radix tree.
Should we upgrade the comment?

> FWIW, this is where is got the idea of using synchronize_rcu() to
> ensure a llokup retry wouldn't see the same freed inode. I'm
> thinking that simply re-running the lookup will give the same
> guarantee because of the memory barriers in the radix tree lookup
> code...

Maybe...  But we do need to be sure, right?

> > 3.	Some CPU, possibly different than that in #1 and #2 above,
> > 	executes the above code.  If locking works correctly, it
> > 	must see the earlier changes, so a subsequent access should
> > 	see the results of #1 above, so that it won't see the element
> > 	that was removed there.
> 
> Isn't the item validity considered separately to the tree traversal
> consistency? i.e. the item lock (i.e. ->i_flags_lock) provides a
> safe item validity check via the unlock->lock memory barrier, whilst
> the radix tree uses rcu_dereference() to provide memory barriers
> against the modifications?

But the safe validity check assumes that the RCU grace period starts
unambiguously after the item has been removed.  Violate that assumption,
and all bets are off.

> > That said, I don't claim to understand either vfs or xfs very well, so
> > I would be arbitrarily deeply confused.
> 
> We might both be confused ;)

Sounds like the most likely possibility, now that you mention it.  ;-)

							Thanx, Paul

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
