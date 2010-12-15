Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBF5mHKU172576
	for <linux-xfs@oss.sgi.com>; Tue, 14 Dec 2010 23:48:23 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5AE5145234A
	for <linux-xfs@oss.sgi.com>; Tue, 14 Dec 2010 21:50:08 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id ITGrhxFKWkLntQ56 for <linux-xfs@oss.sgi.com>;
	Tue, 14 Dec 2010 21:50:08 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1PSkFa-00030S-Cl
	for linux-xfs@oss.sgi.com; Wed, 15 Dec 2010 06:50:06 +0100
Received: from ppp121-45-207-179.lns20.cbr1.internode.on.net ([121.45.207.179])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 15 Dec 2010 06:50:06 +0100
Received: from npiggin by ppp121-45-207-179.lns20.cbr1.internode.on.net with
	local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 15 Dec 2010 06:50:06 +0100
From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH 2/3] xfs: convert inode cache lookups to use RCU locking
Date: Wed, 15 Dec 2010 03:30:43 +0000 (UTC)
Message-ID: <loom.20101215T041848-135@post.gmane.org>
References: <1292203957-15819-1-git-send-email-david@fromorbit.com>
	<1292203957-15819-3-git-send-email-david@fromorbit.com>
	<20101214211801.GH2161@linux.vnet.ibm.com>
	<20101214230047.GC16267@dastard>
	<20101215010536.GT2161@linux.vnet.ibm.com>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Paul E. McKenney <paulmck <at> linux.vnet.ibm.com> writes: 
> On Wed, Dec 15, 2010 at 10:00:47AM +1100, Dave Chinner wrote:
> > On Tue, Dec 14, 2010 at 01:18:01PM -0800, Paul E. McKenney wrote:
> > > On Mon, Dec 13, 2010 at 12:32:36PM +1100, Dave Chinner wrote:

> > > > 
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
[...]
> > > If this is not the case, then readers finding it again will not be
> > > protected by the RCU grace period, right?
> > > 
> > > In short, I don't understand why the synchronize_rcu() is needed.
> > > If it is somehow helping, that sounds to me like it is covering up
> > > a real bug that should be fixed separately.
> > 
> > It isn't covering up a bug, it was more tryingt o be consistent with
> > the rest of the xfs_inode lookup failures - we back off and try
> > again later. If that is unnecessary resolve the RCU lookup race,
> > then it can be dropped.

The RCU radix tree should have the same type of causality semantics
as, say, loading and storing a single word, if that helps think about it.
So the favourite sequence:

x = 1;
smp_wmb();
y = 1;

    r2 = y;
    smp_rmb();
    r1 = x;

Then r2 == 1 implies r1 == 1. Ie. if we "see" something has happened
on a CPU (from another CPU), then we will also see everything that has
previously happened on that CPU (provided the correct barriers are
there).

radix_tree_delete(&tree, idx);
smp_wmb();
y = 1;

    r2 = y;
    smp_rmb();
    r1 = radix_tree_lookup(&tree, idx);

So if we see r2 == 1, then r1 will be NULL.

In this case, if you can observe something that has happened after the
inode is removed from the tree (ie. i_ino has changed), then you should
not find it in the tree after a subsequent lookup (no synchronize_rcu
required, just appropriate locking or barriers).

BTW. I wondered if you can also do the radix_tree tag lookup for reclaim
under RCU?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
