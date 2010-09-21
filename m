Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8L21P67245924 for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 21:01:25 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B39D810A8236
	for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 19:02:16 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	tToxWcLWvnctk3qF for <xfs@oss.sgi.com>;
	Mon, 20 Sep 2010 19:02:16 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39670725-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Sep 2010 11:32:15 +0930 (CST)
Date: Tue, 21 Sep 2010 12:02:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/18] xfs: metadata and buffer cache scalability
	improvements
Message-ID: <20100921020203.GC2614@dastard>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284729700.5524.53.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284729700.5524.53.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 17, 2010 at 08:21:40AM -0500, Alex Elder wrote:
> On Tue, 2010-09-14 at 20:55 +1000, Dave Chinner wrote:
> > This patchset has grown quite a bit - it started out as a "convert
> > the buffer cache to rbtrees" patch, and has gotten bigger as I
> > peeled the onion from one bottleneck to another.
> 
> I know you're going to re-submit this series.  I would
> like you to split it into several smaller series if you
> don't mind.  Some of these are simpler than others,
> and there are some somewhat logical groupings (you
> even described them here as two sets).  But beyond
> that it would be nice to get at least some of them
> committed before the full series is perfected.
> 
> To be constructive, here's a grouping based on what
> seems to be a change of significance somehow.  I'm
> not suggesting they all be separated, but I'm just
> trying to identify the many things you're doing with
> this series.  
> 
> [01/18] xfs: single thread inode cache shrinking.

This is separate, and I'm completely reworking this patch.

Fundamentally, single threading the shrinker is not robust enough
to prevent OOM situations because reclaim relies on the shrinkers to
throttle reclaim sufficiently that some memory is reclaimed while
they are running. Hence every shrinker call needs to do something,
otherwise the direct reclaim priority will wind up very quickly and
declare OOM instead of waiting for IO completion to clean and free
objects.

I've introduced per-ag reclaim walk locks to prevent multiple
shrinkers from walking the same AG, and this has prevented most of
the lock contention. instead, the shrinkers burn CPU walking
instead. hence I've needed to add batched lookups (new patch)
and optimise the way we check whether an inode is reclaimable by
avoiding locking the inode first.

I've also added a scan cursor that tracks where the last reclaim
walk got up to, and restarts the next shrinker reclaim walk from
that inode. This means it is not walkiagn over the same unreclaimable
inodes over and over again.

Then I've changed shrinker reclaim to be sort-of-blocking. That is, it
doesn't block on locks (because that would cause deadlocks), but it
does does SYNC_WAIT inode cluster IO when it finds a dirty inode.
This provides sufficient throttling for reclaim not to OOM.

To make matters even more complex, the inode cache shrinker was
being overloaded by the VM because the buffer cache lru shrinker was
not being asked to do enough work. As a result, the buffer cache
would grow to 1.5GB, and the VM would spent all it's time trying to
shrinker the inode cache! The cause of this was leaving stale
buffers on the LRU, so avoiding leaving them on the LRU has
prevented buffer cache windup on parallel unlink workloads.

The reclaim code is not as efficient as the "just do a full, single
threaded non-blocking reclaim pass" code, but it is still ~4x faster
than the existing code and does not randomly go OOM on parallel
unlink workloads.


> [02/18] xfs: reduce the number of CIL lock round trips during commit

Stand-alone fix.

> [05/18] xfs: convert inode cache lookups to use RCU locking
> [06/18] xfs: convert pag_ici_lock to a spin lock

So up to this point I now have:

d10d7d6 xfs: reduce the number of CIL lock round trips during commit
e9a1a2a xfs: remove debug assert for per-ag reference counting
0a055a3 xfs: lockless per-ag lookups
3403f75 xfs: convert inode cache lookups to use RCU locking
84c5b79 xfs: convert pag_ici_lock to a spin lock
033bc9b xfs: batch per-ag inode lookup walks (NEW)
c5bbc30 xfs: rework inode cache shrinking. (NEW)




> [07/18] xfs: don't use vfs writeback for pure metadata modifications

Standalone.

> [08/18] xfs: rename xfs_buf_get_nodaddr to be more appropriate
> [09/18] xfs: introduced uncached buffer read primitve
> [10/18] xfs: store xfs_mount in the buftarg instead of in the xfs_buf
> [11/18] xfs: kill XBF_FS_MANAGED buffers
> [12/18] xfs: use unhashed buffers for size checks
> [13/18] xfs: remove buftarg hash for external devices

cleanups needed for rbtree conversion.

> [03/18] xfs: remove debug assert for per-ag reference counting
> [04/18] xfs: lockless per-ag lookups

Stand alone.

> [14/18] xfs: convert buffer cache hash to rbtree

Goes with the cleanups.

> [15/18] xfs; pack xfs_buf structure more tightly
> [16/18] xfs: convert xfsbud shrinker to a per-buftarg shrinker.
> [17/18] xfs: add a lru to the XFS buffer cache
> [18/18] xfs: stop using the page cache to back the buffer cache

All together, with the LRU code being reworked a bit w.r.t. stale
buffers and shrinker behaviour.

In reality, though, i don't think that separating them into separate
series make much sense. The order they are in right now is
bisectable and fairly logical....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
