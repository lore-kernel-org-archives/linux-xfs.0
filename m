Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39092 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752261AbdGYAOi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2017 20:14:38 -0400
Date: Mon, 24 Jul 2017 17:14:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/22] xfs: scrub in-memory metadata buffers
Message-ID: <20170725001433.GL4352@magnolia>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061194082.14732.17289613506653968866.stgit@magnolia>
 <20170724014327.GC17762@dastard>
 <20170724223654.GK4352@magnolia>
 <20170724233813.GG17762@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170724233813.GG17762@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 25, 2017 at 09:38:13AM +1000, Dave Chinner wrote:
> On Mon, Jul 24, 2017 at 03:36:54PM -0700, Darrick J. Wong wrote:
> > On Mon, Jul 24, 2017 at 11:43:27AM +1000, Dave Chinner wrote:
> > > On Thu, Jul 20, 2017 at 09:39:00PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Call the verifier function for all in-memory metadata buffers, looking
> > > > for memory corruption either due to bad memory or coding bugs.
> > > 
> > > How does this fit into the bigger picture? We can't do an exhaustive
> > > search of the in memory buffer cache, because access is racy w.r.t.
> > > the life cycle of in memory buffers.
> > > 
> > > Also, if we are doing a full scrub, we're going to hit and then
> > > check the cached in-memory buffers anyway, so I'm missing the
> > > context that explains why this code is necessary.
> > 
> > Before we start scanning the filesystem (which could lead to clean
> > buffers being pushed out of memory and later reread), we want to check
> > the buffers that have been sitting around in memory to see if they've
> > mutated since the last time the verifiers ran.
> 
> I'm not sure we need a special cache walk to do this.
> 
> My thinking is that if the buffers get pushed out of memory, the
> verifier will be run at that time, so we don't need to run the
> verifier before a scrub to avoid problems here.

Agreed.

> Further, if we read the buffer as part of the scrub and it's found
> in cache, then if the scrub finds a corruption we'll know it
> happened between the last verifier invocation and the scrub.

Hm.  Prior to the introduction of the metabufs scanner a few weeks ago, 
I had thought it sufficient to assume that memory won't get corrupt, so
as long as the read verifier ran at /some/ point in the past we didn't
need to recheck now.

What if we scrap the metabufs scanner and adapt the read verifier
function pointer to allow scrub to bypass the crc check and return the
_THIS_IP_ from any failing structural test?  Then scrubbers can call the
read verifier directly and extract failure info directly.

> If the buffer is not in cache and scrub reads the metadata from
> disk, then the verifier should fire on read if the item is corrupt
> coming off disk. If the verifier doesn't find corruption in this
> case but scrub does, then we've got to think about whether the
> verifier has sufficient coverage.

Scrub has more comprehensive checks (or it will when xref comes along)
so this is likely to happen, fyi.

> > > > +#define XFS_SCRUB_METABUFS_TOO_MANY_RETRIES	10
> > > > +struct xfs_scrub_metabufs_info {
> > > > +	struct xfs_scrub_context	*sc;
> > > > +	unsigned int			retries;
> > > > +};
> > > 
> > > So do we get 10 retries per buffer, or 10 retries across an entire
> > > scan?
> > 
> > Ten per scan.
> 
> That will prevent large/active filesystems from being scanned
> completely, I think.

Perhaps.  Though at this point I think I'll just drop this patch entirely
in favor of re-calling the verifiers....

--D

> > > > +STATIC int
> > > > +xfs_scrub_metabufs_scrub_buf(
> > > > +	struct xfs_scrub_metabufs_info	*smi,
> > > > +	struct xfs_buf			*bp)
> > > > +{
> > > > +	int				olderror;
> > > > +	int				error = 0;
> > > > +
> > > > +	/*
> > > > +	 * We hold the rcu lock during the rhashtable walk, so we can't risk
> > > > +	 * having the log forced due to a stale buffer by xfs_buf_lock.
> > > > +	 */
> > > > +	if (bp->b_flags & XBF_STALE)
> > > > +		return 0;
> > > > +
> > > > +	atomic_inc(&bp->b_hold);
> > > 
> > > This looks wrong. I think it can race with reclaim because we don't
> > > hold the pag->pag_buf_lock. i.e.  xfs_buf_rele() does this:
> > > 
> > > 	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
> > > 
> > > to prevent lookups - which are done under the pag->pag_buf_lock -
> > > from finding the buffer while it has a zero hold count and may be
> > > removed from the cache and freed.
> > 
> > I could be misunderstanding rhashtable here -- as I understand it, the
> > rhashtable_walk_start function calls rcu_read_lock and doesn't release
> > it until we call rhashtable_walk_stop.  The rhashtable lookup, insert,
> > and remove functions each call rcu_read_lock before fidding with the
> > hashtable internals.  I /think/ this means that even if the scrubber
> > gets ahold of a buffer with zero b_hold that's being xfs_buf_rele'd,
> > that concurrent xfs_buf_rele will be waiting for rcu_read_lock, and
> > therefore the buffer cannot be freed until the walk stops.
> 
> No, we're not using RCU to protect object life cycles, and RCU also
> doesn't protect the rhashtable walks for xfs_bufs because the
> xfs_bufs are not freed by a RCU callback at the end of the grace
> period.
> 
> FYI, when we moved to the rhashtable code, Lucas Stach also provided
> a RCU lookup patch which I didn't merge.  It turns out that the RCU
> freeing of xfs_bufs has more overhead than the potential CPU usage
> saved by removing lock contention in lookups:
> 
> https://www.spinics.net/lists/linux-xfs/msg02186.html
> 
> IOWs, the per-ag rhashtable has low enough contention
> characteristics than the infrastructure overhead of lockless lookups
> result in a net performance loss and so the cache index
> insert/lookup/remove code is still protected by
> pag->pag_buf_lock....
> 
> The LRU walk doesn't need the pag->pag_buf_lock because all the
> objects on the LRU already have a reference. Hence it can walked
> without affecting lookup/insert/remove performance of the cache...
> 
> > > [snip]
> > > 
> > > > +	olderror = bp->b_error;
> > > > +	if (bp->b_fspriv)
> > > > +		bp->b_ops->verify_write(bp);
> > > 
> > > Should we be recalculating the CRC on buffers we aren't about to 
> > > be writing to disk?
> > 
> > I don't think it causes any harm to recalculate the crc early.  If the
> > buffer is dirty and corrupt we can't fix it and write out will flag it
> > and shut down the fs anyway, so it likely doesn't matter anyway.
> 
> ok.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
