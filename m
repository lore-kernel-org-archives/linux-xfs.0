Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07752C4743D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 01:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4AEA60FF2
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 01:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhFIBDZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 21:03:25 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49004 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230303AbhFIBDZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jun 2021 21:03:25 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id F407B1043F8F;
        Wed,  9 Jun 2021 11:01:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lqmaj-00AaW5-A2; Wed, 09 Jun 2021 11:01:09 +1000
Date:   Wed, 9 Jun 2021 11:01:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/9] xfs: deferred inode inactivation
Message-ID: <20210609010109.GN664593@dread.disaster.area>
References: <162310469340.3465262.504398465311182657.stgit@locust>
 <162310470480.3465262.12512984715866568596.stgit@locust>
 <20210608005753.GG664593@dread.disaster.area>
 <20210608044051.GB2945763@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608044051.GB2945763@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=WH9A7_TyzLk7ZCWRKK8A:9 a=kLYwObMevb3PokJb:21 a=4EAlflD1rj-eSrKO:21
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 07, 2021 at 09:40:51PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 08, 2021 at 10:57:53AM +1000, Dave Chinner wrote:
> > On Mon, Jun 07, 2021 at 03:25:04PM -0700, Darrick J. Wong wrote:
> > > +/* Queue a new inode gc pass if there are inodes needing inactivation. */
> > > +static void
> > > +xfs_inodegc_queue(
> > > +	struct xfs_mount        *mp)
> > > +{
> > > +	if (!xfs_inodegc_running(mp))
> > > +		return;
> > > +
> > > +	rcu_read_lock();
> > > +	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
> > > +		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
> > > +	rcu_read_unlock();
> > > +}
> > 
> > I have no idea why we are checking if the gc is running here. All
> > our other background stuff runs and re-queues until it is directly
> > stopped or there's nothing left in the tree. Hence I'm a bit
> > clueless right now about what this semantic is for...
> 
> The opflag is supposed to control whether inactivation actually runs.
> As you might guess from _running calls being scattered everywhere, it's
> pretty ugly code.  All this crap exists because there's no easy solution
> to shutting down background threads after we commit to freezing the fs
> but before an fs freeze hits SB_FREEZE_FS and we can't allocate new
> transactions.
> 
> Fixing inactivation to use NO_WRITECOUNT means auditing every function
> call that xfs_inactive makes to look for an xfs_trans_alloc* call and
> probably modifying all of them to be able to switch between regular and
> NOWRITECOUNT mode.  I tried that, it's ugly.
> 
> Another solution is to add ->freeze_super and ->thaw_super functions
> to prevent a FITHAW caller from racing with a FIFREEZE caller and
> accidentally rearming the inodegc while a freeze starts.

This seems like the right way to proceed.

Of course, all the freeze/thaw exclusion is in freeze_super and
thaw_super via the umount lock, so to do this we need to factor
freeze_super() so that we can take the active references to the
superblock ourselves, then turn off inodegc, then run the generic
freeze_super() code...

The unfreeze side where we'd turn the inode gc back on is already
inside the protected region (via ->unfreeze_fs callout in
thaw_super_locked()) so we don't need to do anything special there.

[I'll reorder bits to address all the other freeze stuff now so it's
not all mixed up with the stat/df stuff]

> > > +/* Stop all queued inactivation work. */
> > > +void
> > > +xfs_inodegc_stop(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +	clear_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags);
> > > +	cancel_delayed_work_sync(&mp->m_inodegc_work);
> > > +}
> > 
> > what's to stop racing invocations of stop/start? Perhaps:
> > 
> > 	if (test_and_clear_bit())
> > 		cancel_delayed_work_sync(&mp->m_inodegc_work);
> 
> That horrible hack below.
>
> > > +
> > > +/* Schedule deferred inode inactivation work. */
> > > +void
> > > +xfs_inodegc_start(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +	set_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags);
> > > +	xfs_inodegc_queue(mp);
> > > +}
> > 
> > 	if (test_and_set_bit())
> > 		xfs_inodegc_queue(mp);
> > 
> > So that the running state will remain in sync with the actual queue
> > operation? Though I'm still not sure why we need the running bit...
> 
> (see ugly sync_fs SB_FREEZE_PAGEFAULTS hack)

I'm not sure how that addresses any sort of concurrent set/clear
that could occur as it doesn't guarantee that the running state
matches the opflag bit state...

> > Ok, "opflags" are undocumented as to how they work, what their
> > consistency model is, etc. I understand you want an atomic flag to
> > indicate that something is running, and mp->m_flags is not that
> > (despite being used that way historically). 
> > 
> > I dislike the "_BIT" annotations for a variable that is only to be
> > used as an index bit field. Or maybe it's a flag field and you
> > haven't defined any bitwise flags for it because you're not using it
> > that way yet.
> > 
> > So, is m_opflags an indexed bit field or a normal flag field like
> > m_flags?
> 
> It's an indexed bit field, which is why I named it _BIT.  I'll try to
> add more documentation around what this thing is and how the flags work:
> 
> struct xfs_mount {
> 	...
> 	/*
> 	 * This atomic bitset controls flags that alter the behavior of
> 	 * the filesystem.  Use only the atomic bit helper functions
> 	 * here; see XFS_OPFLAG_* for information about the actual
> 	 * flags.
> 	 */
> 	unsigned long		m_opflags;
> 	...
> };
> 
> /*
>  * Operation flags -- each entry here is a bit index into m_opflags and
>  * is not itself a flag value.
>  */
> 
> /* Are we allowed to run the inode inactivation worker? */
> #define XFS_OPFLAG_INODEGC_RUNNING_BIT	(0)

This doesn't really address my comments - there's still the _BIT
annotation mixed with "flags" variables. Other examples of this are
that "operational flags" or state variables are updated via
set/clear/test/etc bit op wrappers. An example of this is page and
bufferhead state bits and variables...

I mentioned on #xfs an older patchset I had that cleaned up a lot of
this cruft in the xfs_mount flags fields by separating feature flags
from state flags. That can be found here:

https://lore.kernel.org/linux-xfs/20180820044851.414-1-david@fromorbit.com/

I think if we are going to introduce dynamic mount state flags, we
need to move towards that sort of separation. So leave this patch
set as it is now with the opflags, and I'll update my flag vs state
rework patchset and merge this new code into it...

That all said, I still don't really see a need for a state bit here
if we can stop the inode gc before we start the freeze process as
via a xfs_fs_freeze_super() method.

(and that's freeze done...)

> > > @@ -947,6 +963,7 @@ xfs_mountfs(
> > >  	 * qm_unmount_quotas and therefore rely on qm_unmount to release the
> > >  	 * quota inodes.
> > >  	 */
> > > +	xfs_inodegc_flush(mp);
> > >  	xfs_unmount_flush_inodes(mp);
> > 
> > Why isn't xfs_inodegc_flush() part of xfs_unmount_flush_inodes()?
> > Because, really, xfs_unmount_flush_inodes() depends on all the
> > inodes first being inactivated so that all transactions on inodes
> > are complete....
> 
> The teardown sequence is not the same between a regular unmount and an
> aborted mount...
> 
> > >   out_log_dealloc:
> > >  	xfs_log_mount_cancel(mp);
> > > @@ -983,6 +1000,12 @@ xfs_unmountfs(
> > >  	uint64_t		resblks;
> > >  	int			error;
> > >  
> > > +	/*
> > > +	 * Flush all the queued inode inactivation work to disk before tearing
> > > +	 * down rt metadata and quotas.
> > > +	 */
> > > +	xfs_inodegc_flush(mp);
> > > +
> > >  	xfs_blockgc_stop(mp);
> > >  	xfs_fs_unreserve_ag_blocks(mp);
> > >  	xfs_qm_unmount_quotas(mp);
> > 
> > FWIW, there's inconsistency in the order of operations between
> > failure handling in xfs_mountfs() w.r.t. inode flushing and quotas
> > vs what xfs_unmountfs() is now doing....
> 
> ...because during regular unmountfs, we want to inactivate inodes while
> we still have a per-ag reservation protecting finobt expansions.  During
> an aborted mount, we don't necessarily have the reservation set up but
> we have to clean everything out, so the inodegc flush comes much later.
> 
> It's convoluted, but do you want me to clean /that/ up too?  That's a
> pretty heavy lift; I already tried to fix those two paths, ran out of
> brain cells, and gave up.

No, I was just noting that they are different and there was no clear
explaination of why. A comment explaining the difference is really
all I am looking for here...

(and now df vs unlink....)

> > > @@ -80,4 +80,37 @@ int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
> > >  void xfs_blockgc_stop(struct xfs_mount *mp);
> > >  void xfs_blockgc_start(struct xfs_mount *mp);
> > >  
> > > +void xfs_inodegc_worker(struct work_struct *work);
> > > +void xfs_inodegc_flush(struct xfs_mount *mp);
> > > +void xfs_inodegc_stop(struct xfs_mount *mp);
> > > +void xfs_inodegc_start(struct xfs_mount *mp);
> > > +int xfs_inodegc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icw);
> > > +
> > > +/*
> > > + * Process all pending inode inactivations immediately (sort of) so that a
> > > + * resource usage report will be mostly accurate with regards to files that
> > > + * have been unlinked recently.
> > > + *
> > > + * It isn't practical to maintain a count of the resources used by unlinked
> > > + * inodes to adjust the values reported by this function.  Resources that are
> > > + * shared (e.g. reflink) when an inode is queued for inactivation cannot be
> > > + * counted towards the adjustment, and cross referencing data extents with the
> > > + * refcount btree is the only way to decide if a resource is shared.  Worse,
> > > + * unsharing of any data blocks in the system requires either a second
> > > + * consultation with the refcount btree, or training users to deal with the
> > > + * free space counts possibly fluctuating upwards as inactivations occur.
> > > + *
> > > + * Hence we guard the inactivation flush with a ratelimiter so that the counts
> > > + * are not way out of whack while ignoring workloads that hammer us with statfs
> > > + * calls.  Once per clock tick seems frequent enough to avoid complaints about
> > > + * inaccurate counts.
> > > + */
> > > +static inline void
> > > +xfs_inodegc_summary_flush(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +	if (__ratelimit(&mp->m_inodegc_ratelimit))
> > > +		xfs_inodegc_flush(mp);
> > > +}
> > 
> > ONce per clock tick is still quite fast - once a millisecond on a
> > 1000Hz kernel. I'd prefer that we use a known timer base for this
> > sort of thing, not something that changes with kernel config. Every
> > 100ms, perhaps?
> 
> I tried a number of ratelimit values here: 1ms, 4ms, 10ms, 100ms, 500ms,
> 2s, and 15s.  fstests and most everything else seemed to act the same up
> to 10ms.  At 100ms, the tests that delete something and immediately run
> df will start to fail, and above that all hell breaks loose because many
> tests (from which I extrapolate most programmers) expect that statfs
> won't run until unlink has deleted everything.

So the main problem I have with this is that it it blocks the caller
until inactivation is done. For something that is supposed to be
fast and non-blocking, this is a bad thing to do.

The quota usage (called on every get/get_next syscall) is really the
only one that should be called with any frequency - if anyone is
calling statfs so fast that we have to rate limit gc flushes, then
they aren't getting any useful information in the delta between
calls a millisecond apart.

Hence I suspect that flushes and/or rate limited flushes are not
necessary at all here. Why not just deal with it like we do the
inode flush at ENOSPC (i.e. xfs_flush_inodes())? i.e. we try to
flush the work first, and if that returns true we waited on a flush
already in progress and we don't need to do our own? Indeed, why
aren't all the inodegc flushes done this way?

For the quota case, I think doing a flush on the first get call
would be sufficient - doing one for every "next" call doesn't make
much sense, because we've already done a flush at the start of the
dquot get walk. IOWs, we've done the work necessary for a point in
time snapshot of the quota state that is largely consistent across
all the quotas at the time the walk started. Hence I don't think we
need to keep flushing over and over again....

For fs_counts, it is non-blocking, best effort only.  The percpu
counters are read, not summed, so they are inaccurate to begin with.
Hence there's not need to flush inactivated inodes there becuse the
counters are not guaranteed accurate. If we do need a flush, then
just do it unconditionally because anyone calling this with
extremely high frequency really isn't going to get anything useful
from it.

For statfs, we actually sum the percpu counters, so we should just
flush the inodegc before this. If someone is calling statfs with
high enough frequency that rate limiting inodegc flushes is actually
needed, then they've already got substantial problems on large CPU
count machines..

Hence I think we should just have flushes where they are needed, and
change the flush to block and return if a flush is already in
progress rather than doing an entire new flush itself. That
effectively rate limits the flushing, but doesn't prevent a flush
when none has been done in a while due to ratelimit state...

> > I suspect that's really going to hurt stat performance. I guess
> > benchmarks are in order...
> 
> Ok, so here's the question I have: Does POSIX (or any other standard we
> care to fit) actually define any behavior between the following
> sequence:
> 
> unlink("/foo");	/* no sync calls of any kind */
> statfs("/");

None that I know of. the man page for statfs even says:

"buf is a pointer to a statfs structure defined approximately as
follows"

so even the man page is extremely cagey about what is actually
returned in the statfs buffer. Free space counters not being totally
accurate at any specific point in time fits with the "approximately
defined" behaviour description in the man page. As long as we do, in
the near term, correct account for deferred operations, then we're
all good.

> As I've mentioned in the past, the only reason we need these inodegc
> flushes for summary reporting is because users expect that if they
> delete an unshared 10GB file, they can immediately df and see that the
> inode count went down by one and free space went up by 10GB.
> 
> I /guess/ we could modify every single fstest to sync before checking
> summary counts instead of doing this, but I bet there will be some users
> who will be surprised that xfs now has *trfs df logic.

If fstests needs accurate counters, it should use 'df --sync' and we
should make sure that the syncfs implementation triggers a flush of
inactive inodes before it returns. We don't have to guarantee that
the inactivation is on stable storage, but it would make sense that
we trigger background ops to get the free space accounting near to
accurate...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
