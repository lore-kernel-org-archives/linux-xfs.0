Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:52717 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752363AbdGXXiQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2017 19:38:16 -0400
Date: Tue, 25 Jul 2017 09:38:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/22] xfs: scrub in-memory metadata buffers
Message-ID: <20170724233813.GG17762@dastard>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061194082.14732.17289613506653968866.stgit@magnolia>
 <20170724014327.GC17762@dastard>
 <20170724223654.GK4352@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170724223654.GK4352@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2017 at 03:36:54PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 24, 2017 at 11:43:27AM +1000, Dave Chinner wrote:
> > On Thu, Jul 20, 2017 at 09:39:00PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Call the verifier function for all in-memory metadata buffers, looking
> > > for memory corruption either due to bad memory or coding bugs.
> > 
> > How does this fit into the bigger picture? We can't do an exhaustive
> > search of the in memory buffer cache, because access is racy w.r.t.
> > the life cycle of in memory buffers.
> > 
> > Also, if we are doing a full scrub, we're going to hit and then
> > check the cached in-memory buffers anyway, so I'm missing the
> > context that explains why this code is necessary.
> 
> Before we start scanning the filesystem (which could lead to clean
> buffers being pushed out of memory and later reread), we want to check
> the buffers that have been sitting around in memory to see if they've
> mutated since the last time the verifiers ran.

I'm not sure we need a special cache walk to do this.

My thinking is that if the buffers get pushed out of memory, the
verifier will be run at that time, so we don't need to run the
verifier before a scrub to avoid problems here.

Further, if we read the buffer as part of the scrub and it's found
in cache, then if the scrub finds a corruption we'll know it
happened between the last verifier invocation and the scrub.

If the buffer is not in cache and scrub reads the metadata from
disk, then the verifier should fire on read if the item is corrupt
coming off disk. If the verifier doesn't find corruption in this
case but scrub does, then we've got to think about whether the
verifier has sufficient coverage.

> > > +#define XFS_SCRUB_METABUFS_TOO_MANY_RETRIES	10
> > > +struct xfs_scrub_metabufs_info {
> > > +	struct xfs_scrub_context	*sc;
> > > +	unsigned int			retries;
> > > +};
> > 
> > So do we get 10 retries per buffer, or 10 retries across an entire
> > scan?
> 
> Ten per scan.

That will prevent large/active filesystems from being scanned
completely, I think.

> > > +STATIC int
> > > +xfs_scrub_metabufs_scrub_buf(
> > > +	struct xfs_scrub_metabufs_info	*smi,
> > > +	struct xfs_buf			*bp)
> > > +{
> > > +	int				olderror;
> > > +	int				error = 0;
> > > +
> > > +	/*
> > > +	 * We hold the rcu lock during the rhashtable walk, so we can't risk
> > > +	 * having the log forced due to a stale buffer by xfs_buf_lock.
> > > +	 */
> > > +	if (bp->b_flags & XBF_STALE)
> > > +		return 0;
> > > +
> > > +	atomic_inc(&bp->b_hold);
> > 
> > This looks wrong. I think it can race with reclaim because we don't
> > hold the pag->pag_buf_lock. i.e.  xfs_buf_rele() does this:
> > 
> > 	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
> > 
> > to prevent lookups - which are done under the pag->pag_buf_lock -
> > from finding the buffer while it has a zero hold count and may be
> > removed from the cache and freed.
> 
> I could be misunderstanding rhashtable here -- as I understand it, the
> rhashtable_walk_start function calls rcu_read_lock and doesn't release
> it until we call rhashtable_walk_stop.  The rhashtable lookup, insert,
> and remove functions each call rcu_read_lock before fidding with the
> hashtable internals.  I /think/ this means that even if the scrubber
> gets ahold of a buffer with zero b_hold that's being xfs_buf_rele'd,
> that concurrent xfs_buf_rele will be waiting for rcu_read_lock, and
> therefore the buffer cannot be freed until the walk stops.

No, we're not using RCU to protect object life cycles, and RCU also
doesn't protect the rhashtable walks for xfs_bufs because the
xfs_bufs are not freed by a RCU callback at the end of the grace
period.

FYI, when we moved to the rhashtable code, Lucas Stach also provided
a RCU lookup patch which I didn't merge.  It turns out that the RCU
freeing of xfs_bufs has more overhead than the potential CPU usage
saved by removing lock contention in lookups:

https://www.spinics.net/lists/linux-xfs/msg02186.html

IOWs, the per-ag rhashtable has low enough contention
characteristics than the infrastructure overhead of lockless lookups
result in a net performance loss and so the cache index
insert/lookup/remove code is still protected by
pag->pag_buf_lock....

The LRU walk doesn't need the pag->pag_buf_lock because all the
objects on the LRU already have a reference. Hence it can walked
without affecting lookup/insert/remove performance of the cache...

> > [snip]
> > 
> > > +	olderror = bp->b_error;
> > > +	if (bp->b_fspriv)
> > > +		bp->b_ops->verify_write(bp);
> > 
> > Should we be recalculating the CRC on buffers we aren't about to 
> > be writing to disk?
> 
> I don't think it causes any harm to recalculate the crc early.  If the
> buffer is dirty and corrupt we can't fix it and write out will flag it
> and shut down the fs anyway, so it likely doesn't matter anyway.

ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
