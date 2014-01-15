Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DEB8F7F3F
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 19:45:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C9336304053
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 17:45:11 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	uwXTvtODoCQMTNRP for <xfs@oss.sgi.com>;
	Tue, 14 Jan 2014 17:45:09 -0800 (PST)
Date: Wed, 15 Jan 2014 12:45:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)
Message-ID: <20140115014503.GQ3469@dastard>
References: <20131218230615.GQ31386@dastard>
	<78FC295EC7FF48C987266DC48B183930@alyakaslap>
	<20131219105513.GZ31386@dastard>
	<8155F3F9D6094F40B4DA71BD561D2DE8@alyakaslap>
	<20131226230018.GJ20579@dastard>
	<A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
	<20140113030230.GF3469@dastard>
	<CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
	<20140113204314.GJ3469@dastard>
	<CAOcd+r22FirPMHjdxQyTmXOAM72ND-t0=njK9nEmesSV5=Ec=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOcd+r22FirPMHjdxQyTmXOAM72ND-t0=njK9nEmesSV5=Ec=Q@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Alex Lyakas <alex@zadarastorage.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 14, 2014 at 03:48:46PM +0200, Alex Lyakas wrote:
> >> - When a busy extent commits, by all means we "unbusy" the extent as
> >> usual. But we also check in the second rbtree, whether we can issue a
> >> discard for some discard range. Perhaps we can. Or we cannot because
> >> of other busy extents, that have not committed yet (the numbering is
> >> used to determine that). In that case, we will discard later, when all
> >> the needed busy extent commit. Unless new allocation removed/changed
> >> this discard range already. But we are not delaying the "unbusying" of
> >> the busy extent, and we are not keeping the AGF locked (I think).
> >> Also, we are issuing discards in the same place and context where XFS
> >> does it today.
> >
> > This is where I think the issues lie. We don't want to have to do
> > anything when a busy extent is removed at transaction commit -
> > that's the reason online discard sucks right now. And we want to
> > avoid having to care about transactions and ordering when it comes
> > to tracking discard ranges and issuing them.
> >
> > The way I see it is that if we have a worker thread that
> > periodically walks the discard tree to issue discards, we simply
> > need to do a busy extent tree lookup on the range of each discard
> > being tracked. If there are busy extents that span the discard
> > range, then the free space isn't yet stable and so we can't issue
> > the discard on that range. If there are no busy extents over the
> > discard range then the free space is stable and we can issue the
> > discard.
> >
> > i.e. if we completely dissociate the discard and busy extent
> > tracking and just replace it with a busy extent lookup at discard
> > time then we don't need any sort of reference counting or log
> > sequence tracking on busy extents or discard ranges.
> Nice. I like the idea of doing the busy extent lookup instead of
> numbering busy extents and tracking the order of commits.
> So first of all, this idea can also be applied to what I suggest,
> i.e., doing the discard at its current place. But instead of tracking
> busy extent numbers, we:
> - when a busy extent commits and it has a discard range attached to
> it, we lookup in the busy extents tree to check for other busy extents
> overlapping the discard range. Anyways the original code locks the
> pagb_lock in that context, so we might as well do the search.
> - if we find an overlapping busy extent, we detach the discard-range
> from our busy extent and attach it to the overlapping extent. When
> this overlapping busy extent commits, we will retry the search.

I don't think that busy extents should every have a pointer to the
discard range. It's simply not necessary if we are looking up busy
extents at discard time. Hence everything to do with discards can be
removed from the busy extent tree and moved into the discard tree...

> WRT that I have questions: in xfs_extent_busy_update_extent() we can
> "unbusy" part of the extent, or even rb_erase() the busy extent from
> the busy extent tree (it still remains in t_busy list and will be
> tracked).
> Q1: why it is ok to do so? why it is ok for "metadata" to reuse part
> (or all) of the busy extent before its extent-free-intent is
> committed?

The metadata changes are logged, and crash recovery allows correct
ordering of the free, realloc and modify process for metadata. Hence
it doesn't matter that we overwrite the contents of the block before
the free transaction is on disk - the correct contents will always
be present after recovery.

We can't do that for user data because we don't log user data.
Therefore if we allow user data to overwrite the block whil eit is
still busy, crash recovery may not result in the block having the
correct contents (i.e. the transaction that freed the block never
reaches the journal) and we hence expose some other user's data or
metadata in the file.

> Q2: assume we have two busy extents on the same discard range:
> +--busy1--+ +--busy2--+
> +----------discard1--------+
> Assume that xfs_extent_busy_update_extent() fully unbusies busy1. Now
> busy2 commits, searches for overlapping busy extent, does not find one
> and discards discard1. I assume it is fine, because:

I don't think that is correct. If we unbusy busy1 due to
reallocation, we cannot issue a discard across that range. It's in
use by the filesystem, and discarding that range will result in data
or metadata corruption.

> xfs_extent_busy_update_extent() is called before
> xfs_alloc_fixup_trees() where I intend to check for overlapping
> discard range. So if we manage to discard before
> xfs_alloc_fixup_trees(), it is fine, because XFS has not yet really
> allocated this space. Otherwise, xfs_alloc_fixup_trees() will knock
> off discard1 and we will not discard. Works?

You need to update the discard ranges at the same place that the
busy extents are updated. That is the point that the extent is freed
or allocated, and that's the point where the information about the
free space the extent was allocated from is available. Hence the
discard tree should be updated in the same spot from the same
information.

That is, on freeing via xfs_free_extent(), the
xfs_extent_busy_insert() call needs to be moved inside
xfs_free_ag_extent() to where it knows the entire range of the free
extent that spans the extent being freed (i.e. the extent after
merging). This gives you the ability to round the discard range
outwards to the discard granularity. At this point, insert the
extent being freed into the busy tree, and the discard range into
the discard tree. The busy extents don't merge on insert, the
discard ranges can merge.  Note that this will capture blocks moved
from the AGFL to the free space trees, which we don't currently
capture now for discard.

We have to insert the busy extent first, though, because ordering
matters when it comes to discard range tree walks - a busy range
needs to be added first so that the walk doesn't find a discard
range before it's corresponding busy extent is added to the tree.

When we are allocating, we need to remove discard ranges at the
same places where we call xfs_extent_busy_reuse() and *after* a
successful call to xfs_alloc_fixup_trees(). i.e. the allocation has
not complete until after all the free space information has been
updated. The range for discard needs to be trimmed only if the
allocation succeeds, similarly, we only need to block on a discard
in progress if the allocation succeeds....

> WRT to the worker thread: we need some good strategy when to awake it.
> Like use a workqueue and a work item, that tells exactly which discard
> range is now a candidate for discard and needs to be checked for
> overlapping busy extents?

Any extent in the discard range tree is a candidate for discard.
grab the first extent, check it has no busy extents in it's range,
mark it as being discarded and issue the discard (i'm assuming the
tree lock is a mutex here). For the current synchronous discard
implementation, on completion we can simply remove the object from
the tree and free it. Drop the lock, relax, start again.

Once we've walked the entire tree, set up the workqueue to run again
some time in the future if there is still more work to be done. If
it's empty, just return. We'll start it again when we queue up the
first new discard range being inserted into the tree. (same way we
run periodic inode reclaim workqueues)

> > FWIW, if we do this then we can change fstrim xfs_trim_extents() to
> > queue up all the work to be done in the background simply by
> > populating the discard tree with all the free space ranges we wish
> > to discard.  This will significantly reduce the impact of fstrim on
> > filesystem runtime performance as the AGF will only be held locked
> > long enough to populate the discard tree.  And if we do the work
> > per-ag, then we are also parallelising it by allowing discards on
> > multiple AGs to be issued at once and hence it will be significantly
> > faster on devices that can queue TRIM commands (SATA 3.1, SAS and
> > NVMe devices).....
> If we have a huge filesystem with a lot of ranges to discard, this
> will require an un-bound memory amount to populate this tree?

In theory, but we're talking about a fairly frequent discard issue
here (e.g. every 5s) so the buildup is effectively bounded by time.
If it's really a problem, we can bound it by count, too.

> > The fact that this track and background issue mechanism would allow
> > us to optimise both forms of discard the filesystem supports makes
> > me optimistic that we are on the right path. :)
> >
> >> >> question that I have:
> >> >> # xfs_free_ag_extent() has a "isfl" parameter. If it is "true", then
> >> >> this extent is added as usual to the free-space btrees, but the
> >> >> caller doesn't add it as a busy extent. This means that such extent
> >> >> is suitable for allocation right away, without waiting for the log
> >> >> commit?
> >> >
> >> > It means the extent is being moved from the AGFL to the free space
> >> > btree. blocks on the AGFL have already gone through free space
> >> > accounting and busy extent tracking to get to the AGFL, and so there
> >> > is no need to repeat it when moving it to the free space btrees.
> >> Ok, I realize now that this block has already gone through the busy
> >> extent tracking via xfs_allocbt_free_block().
> >
> > Right, and note that blocks going through that path aren't discarded
> > due to the XFS_EXTENT_BUSY_SKIP_DISCARD flag. This is due to the
> > fact they are being freed to the AGFL and as such are likely to be
> > reused immediately. ;)
> Yes, and WRT that: is it true to say that the following holds:
> if we have busy extent with this flag, then we know appropriate range
> is not in the free-space btrees.

Not necessarily tree, because while the extent was pu ton the free
list at the time it was marked busy (hence the skip discard), it
doesn't mean that it hasn't been migrated back to the free space
btree since then.

> Because when we insert such busy
> extent, we don't drop it into the free-space btrees. As a result, we
> should never have a discard range that overlaps a busy extent with
> XFS_EXTENT_BUSY_SKIP_DISCARD.

Right, but a later call to xfs_alloc_fixup_trees() can move it to
the free space tree if the free list was longer than needed for the
current transaction.  hence my comment above about us missing
discards in that case. ;)

> Because all our discard ranges are also
> free in the free-space btrees. Therefore, busy extents with this flag
> do not require any special treatment; we can ignore them fully or
> simply ignore the fact that they have this special flag - they will
> never have a discard range attached anyways.

Pretty much -  if we move discard range updates directly into the
btree manipulation functions, then we can remove all knowledge of
discards from the busy extent tree as discard ranges consider the
free list to be "allocated space"....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
