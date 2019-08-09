Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40571 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbfHIBVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 21:21:33 -0400
Date: Fri, 9 Aug 2019 11:20:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 23/24] xfs: reclaim inodes from the LRU
Message-ID: <20190809012022.GX7777@dread.disaster.area>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-24-david@fromorbit.com>
 <20190808163905.GC24551@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808163905.GC24551@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Thu, Aug 08, 2019 at 12:39:05PM -0400, Brian Foster wrote:
> On Thu, Aug 01, 2019 at 12:17:51PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Replace the AG radix tree walking reclaim code with a list_lru
> > walker, giving us both node-aware and memcg-aware inode reclaim
> > at the XFS level. This requires adding an inode isolation function to
> > determine if the inode can be reclaim, and a list walker to
> > dispose of the inodes that were isolated.
> > 
> > We want the isolation function to be non-blocking. If we can't
> > grab an inode then we either skip it or rotate it. If it's clean
> > then we skip it, if it's dirty then we rotate to give it time to be
> 
> Do you mean we remove it if it's clean?

No, I mean if we can't grab it and it's clean, then we just skip it,
leaving it at the head of the LRU for the next scanner to
immediately try to reclaim it. If it's dirty, we rotate it so that
time passes before we try to reclaim it again in the hope that it is
already clean by the time we've scanned through the entire LRU...

> > +++ b/fs/xfs/xfs_super.c
> ...
> > @@ -1810,23 +1811,58 @@ xfs_fs_mount(
> >  }
> >  
> >  static long
> > -xfs_fs_nr_cached_objects(
> > +xfs_fs_free_cached_objects(
> >  	struct super_block	*sb,
> >  	struct shrink_control	*sc)
> >  {
> > -	/* Paranoia: catch incorrect calls during mount setup or teardown */
> > -	if (WARN_ON_ONCE(!sb->s_fs_info))
> > -		return 0;
> > +	struct xfs_mount	*mp = XFS_M(sb);
> > +        struct xfs_ireclaim_args ra;
> 
> ^ whitespace damage

Already fixed.

> > +	long freed;
> >  
> > -	return list_lru_shrink_count(&XFS_M(sb)->m_inode_lru, sc);
> > +	INIT_LIST_HEAD(&ra.freeable);
> > +	ra.lowest_lsn = NULLCOMMITLSN;
> > +	ra.dirty_skipped = 0;
> > +
> > +	freed = list_lru_shrink_walk(&mp->m_inode_lru, sc,
> > +					xfs_inode_reclaim_isolate, &ra);
> 
> This is more related to the locking discussion on the earlier patch, but
> this looks like it has more similar serialization to the example patch I
> posted than the one without locking at all. IIUC, this walk has an
> internal lock per node lru that is held across the walk and passed into
> the callback. We never cycle it, so for any given node we only allow one
> reclaimer through here at a time.

That's not a guarantee that list_lru gives us. It could drop it's
internal lock at any time during that walk and we would be
blissfully unaware that it has done this. And at that point, the
reclaim context is completely unaware that other reclaim contexts
may be scanning the same LRU at the same time and are interleaving
with it.

And, really, that does not matter one iota. If multiple scanners are
interleaving, the reclaim traversal order and the decisions made are
no different from what a single reclaimer does.  i.e. we just don't
have to care if reclaim contexts interleave or not, because they
will not repeat work that has already been done unnecessarily.
That's one of the reasons for moving to IO-less LRU ordered reclaim
- it removes all the gross hacks we've had to implement to guarantee
reclaim scanning progress in one nice neat package of generic
infrastructure.

> That seems to be Ok given we don't do much in the isolation handler, the
> lock isn't held across the dispose sequence and we're still batching in
> the shrinker core on top of that. We're still serialized over the lru
> fixups such that concurrent reclaimers aren't processing the same
> inodes, however.

The only thing that we may need here is need_resched() checks if it
turns out that holding a lock for 1024 items to be scanned proved to
be too long to hold on to a single CPU. If we do that we'd cycle the
LRU lock and return RETRY or RETRY_REMOVE, hence enabling reclaimers
more finer-grained interleaving....

> BTW I got a lockdep splat[1] for some reason on a straight mount/unmount
> cycle with this patch.
....
> [   39.030519]  lock_acquire+0x90/0x170
> [   39.031170]  ? xfs_ilock+0xd2/0x280 [xfs]
> [   39.031603]  down_write_nested+0x4f/0xb0
> [   39.032064]  ? xfs_ilock+0xd2/0x280 [xfs]
> [   39.032684]  ? xfs_dispose_inodes+0x124/0x320 [xfs]
> [   39.033575]  xfs_ilock+0xd2/0x280 [xfs]
> [   39.034058]  xfs_dispose_inodes+0x124/0x320 [xfs]

False positive, AFAICT. It's complaining about the final xfs_ilock()
call we do before freeing the inode because we have other inodes
locked. I don't think this can deadlock because the inodes under
reclaim should not be usable by anyone else at this point because
they have the I_RECLAIM flag set.

I did notice this - I added a XXX comment I added to the case being
complained about to note I needed to resolve this locking issue.

+        * Here we do an (almost) spurious inode lock in order to coordinate
+        * with inode cache radix tree lookups.  This is because the lookup
+        * can reference the inodes in the cache without taking references.
+        *
+        * We make that OK here by ensuring that we wait until the inode is
+        * unlocked after the lookup before we go ahead and free it. 
+        * unlocked after the lookup before we go ahead and free it. 
+        *
+        * XXX: need to check this is still true. Not sure it is.
         */

I added that last line in this patch. In more detail....

The comment is suggesting that we need to take the ILOCK to
co-ordinate with RCU protected lookups in progress before we RCU
free the inode. That's waht RCU is supposed to do, so I'm not at all
sure what this is actually serialising against any more.

i.e. any racing radix tree lookup from this point in time is going
to see the XFS_IRECLAIM flag and ip->i_ino == 0 while under the
rcu_read_lock, and they will go try again after dropping all lock
context and waiting for a bit. The inode may remain visibile until
the next rcu grace period expires, but all lookups will abort long
before the get anywhere near the ILOCK. And once the RCU grace
period expires, lookups will be locked out by the rcu_read_lock(),
the raidx tree moves to a state where the removal of the inode is
guaranteed visibile to all CPUs, and then the object is freed.

So the ILOCK should have no part in lookup serialisation, and I need
to go look at the history of the code to determine where and why
this was added, and whether the condition it protects against is
still a valid concern or not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
