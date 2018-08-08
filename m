Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38252 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbeHICfK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Aug 2018 22:35:10 -0400
Date: Wed, 8 Aug 2018 15:42:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/14] xfs: repair free space btrees
Message-ID: <20180808224232.GJ30972@magnolia>
References: <20180731220125.GY30972@magnolia>
 <20180801115409.GA48176@bfoster>
 <20180801162316.GH30972@magnolia>
 <20180801183919.GE48176@bfoster>
 <20180802062845.GQ30972@magnolia>
 <20180802134824.GB65267@bfoster>
 <20180802192205.GT30972@magnolia>
 <20180803104940.GA5657@bfoster>
 <20180807233458.GH30972@magnolia>
 <20180808122953.GB2819@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180808122953.GB2819@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Wed, Aug 08, 2018 at 08:29:54AM -0400, Brian Foster wrote:
> On Tue, Aug 07, 2018 at 04:34:58PM -0700, Darrick J. Wong wrote:
> > On Fri, Aug 03, 2018 at 06:49:40AM -0400, Brian Foster wrote:
> > > On Thu, Aug 02, 2018 at 12:22:05PM -0700, Darrick J. Wong wrote:
> > > > On Thu, Aug 02, 2018 at 09:48:24AM -0400, Brian Foster wrote:
> > > > > On Wed, Aug 01, 2018 at 11:28:45PM -0700, Darrick J. Wong wrote:
> > > > > > On Wed, Aug 01, 2018 at 02:39:20PM -0400, Brian Foster wrote:
> > > > > > > On Wed, Aug 01, 2018 at 09:23:16AM -0700, Darrick J. Wong wrote:
> > > > > > > > On Wed, Aug 01, 2018 at 07:54:09AM -0400, Brian Foster wrote:
> > > > > > > > > On Tue, Jul 31, 2018 at 03:01:25PM -0700, Darrick J. Wong wrote:
> > > > > > > > > > On Tue, Jul 31, 2018 at 01:47:23PM -0400, Brian Foster wrote:
> > > > > > > > > > > On Sun, Jul 29, 2018 at 10:48:21PM -0700, Darrick J. Wong wrote:
> > > > > > > > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > > > > > > > 
> > > > > > > > > > > > Rebuild the free space btrees from the gaps in the rmap btree.
> > > > > > > > > > > > 
> > > > > > > > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > > > > > > > ---
> > > > > > > > > > > >  fs/xfs/Makefile             |    1 
> > > > > > > > > > > >  fs/xfs/scrub/alloc.c        |    1 
> > > > > > > > > > > >  fs/xfs/scrub/alloc_repair.c |  581 +++++++++++++++++++++++++++++++++++++++++++
> > > > > > > > > > > >  fs/xfs/scrub/common.c       |    8 +
> > > > > > > > > > > >  fs/xfs/scrub/repair.h       |    2 
> > > > > > > > > > > >  fs/xfs/scrub/scrub.c        |    4 
> > > > > > > > > > > >  fs/xfs/scrub/trace.h        |    2 
> > > > > > > > > > > >  fs/xfs/xfs_extent_busy.c    |   14 +
> > > > > > > > > > > >  fs/xfs/xfs_extent_busy.h    |    2 
> > > > > > > > > > > >  9 files changed, 610 insertions(+), 5 deletions(-)
> > > > > > > > > > > >  create mode 100644 fs/xfs/scrub/alloc_repair.c
> > > > > > > > > > > > 
> > > > > > > > > > > > 
> > > > > > > > > > > ...
> > > > > > > > > > > > diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
> > > > > > > > > > > > new file mode 100644
> > > > > > > > > > > > index 000000000000..b228c2906de2
> > > > > > > > > > > > --- /dev/null
> > > > > > > > > > > > +++ b/fs/xfs/scrub/alloc_repair.c
> > > > > > > > > > > > @@ -0,0 +1,581 @@
> > > > > > > ...
> > > > > > > > > > > > +
> > > > > > > > > > > > +/*
> > > > > > > > > > > > + * Make our new freespace btree roots permanent so that we can start freeing
> > > > > > > > > > > > + * unused space back into the AG.
> > > > > > > > > > > > + */
> > > > > > > > > > > > +STATIC int
> > > > > > > > > > > > +xrep_abt_commit_new(
> > > > > > > > > > > > +	struct xfs_scrub	*sc,
> > > > > > > > > > > > +	struct xfs_bitmap	*old_allocbt_blocks,
> > > > > > > > > > > > +	int			log_flags)
> > > > > > > > > > > > +{
> > > > > > > > > > > > +	int			error;
> > > > > > > > > > > > +
> > > > > > > > > > > > +	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, log_flags);
> > > > > > > > > > > > +
> > > > > > > > > > > > +	/* Invalidate the old freespace btree blocks and commit. */
> > > > > > > > > > > > +	error = xrep_invalidate_blocks(sc, old_allocbt_blocks);
> > > > > > > > > > > > +	if (error)
> > > > > > > > > > > > +		return error;
> > > > > > > > > > > 
> > > > > > > > > > > It looks like the above invalidation all happens in the same
> > > > > > > > > > > transaction. Those aren't logging buffer data or anything, but any idea
> > > > > > > > > > > how many log formats we can get away with in this single transaction?
> > > > > > > > > > 
> > > > > > > > > > Hm... well, on my computer a log format is ~88 bytes.  Assuming 4K
> > > > > > > > > > blocks, the max AG size of 1TB, maximum free space fragmentation, and
> > > > > > > > > > two btrees, the tree could be up to ~270 million records.  Assuming ~505
> > > > > > > > > > records per block, that's ... ~531,000 leaf blocks and ~1100 node blocks
> > > > > > > > > > for both btrees.  If we invalidate both, that's ~46M of RAM?
> > > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > I was thinking more about transaction reservation than RAM. It may not
> > > > > > > > 
> > > > > > > > Hmm.  tr_itruncate is ~650K on my 2TB SSD, assuming 88 bytes per, that's
> > > > > > > > about ... ~7300 log format items?  Not a lot, maybe it should roll the
> > > > > > > > transaction every 1000 invalidations or so...
> > > > > > > > 
> > > > > > > 
> > > > > > > I'm not really sure what categorizes as a lot here given that the blocks
> > > > > > > would need to be in-core, but rolling on some fixed/safe interval sounds
> > > > > > > reasonable to me.
> > > > > > > 
> > > > > > > > > currently be an issue, but it might be worth putting something down in a
> > > > > > > > > comment to note that this is a single transaction and we expect to not
> > > > > > > > > have to invalidate more than N (ballpark) blocks in a single go,
> > > > > > > > > whatever that value happens to be.
> > > > > > > > > 
> > > > > > > > > > > > +	error = xrep_roll_ag_trans(sc);
> > > > > > > > > > > > +	if (error)
> > > > > > > > > > > > +		return error;
> > > > > > > > > > > > +
> > > > > > > > > > > > +	/* Now that we've succeeded, mark the incore state valid again. */
> > > > > > > > > > > > +	sc->sa.pag->pagf_init = 1;
> > > > > > > > > > > > +	return 0;
> > > > > > > > > > > > +}
> > > > > > > > > > > > +
> > > > > > > > > > > > +/* Build new free space btrees and dispose of the old one. */
> > > > > > > > > > > > +STATIC int
> > > > > > > > > > > > +xrep_abt_rebuild_trees(
> > > > > > > > > > > > +	struct xfs_scrub	*sc,
> > > > > > > > > > > > +	struct list_head	*free_extents,
> > > > > > > > > > > > +	struct xfs_bitmap	*old_allocbt_blocks)
> > > > > > > > > > > > +{
> > > > > > > > > > > > +	struct xfs_owner_info	oinfo;
> > > > > > > > > > > > +	struct xrep_abt_extent	*rae;
> > > > > > > > > > > > +	struct xrep_abt_extent	*n;
> > > > > > > > > > > > +	struct xrep_abt_extent	*longest;
> > > > > > > > > > > > +	int			error;
> > > > > > > > > > > > +
> > > > > > > > > > > > +	xfs_rmap_skip_owner_update(&oinfo);
> > > > > > > > > > > > +
> > > > > > > > > > > > +	/*
> > > > > > > > > > > > +	 * Insert the longest free extent in case it's necessary to
> > > > > > > > > > > > +	 * refresh the AGFL with multiple blocks.  If there is no longest
> > > > > > > > > > > > +	 * extent, we had exactly the free space we needed; we're done.
> > > > > > > > > > > > +	 */
> > > > > > > > > > > 
> > > > > > > > > > > I'm confused by the last sentence. longest should only be NULL if the
> > > > > > > > > > > free space list is empty and haven't we already bailed out with -ENOSPC
> > > > > > > > > > > if that's the case?
> > > > > > > > > > > 
> > > > > > > > > > > > +	longest = xrep_abt_get_longest(free_extents);
> > > > > > > > > > 
> > > > > > > > > > xrep_abt_rebuild_trees is called after we allocate and initialize two
> > > > > > > > > > new btree roots in xrep_abt_reset_btrees.  If free_extents is an empty
> > > > > > > > > > list here, then we found exactly two blocks worth of free space and used
> > > > > > > > > > them to set up new btree roots.
> > > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > Got it, thanks.
> > > > > > > > > 
> > > > > > > > > > > > +	if (!longest)
> > > > > > > > > > > > +		goto done;
> > > > > > > > > > > > +	error = xrep_abt_free_extent(sc,
> > > > > > > > > > > > +			XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, longest->bno),
> > > > > > > > > > > > +			longest->len, &oinfo);
> > > > > > > > > > > > +	list_del(&longest->list);
> > > > > > > > > > > > +	kmem_free(longest);
> > > > > > > > > > > > +	if (error)
> > > > > > > > > > > > +		return error;
> > > > > > > > > > > > +
> > > > > > > > > > > > +	/* Insert records into the new btrees. */
> > > > > > > > > > > > +	list_for_each_entry_safe(rae, n, free_extents, list) {
> > > > > > > > > > > > +		error = xrep_abt_free_extent(sc,
> > > > > > > > > > > > +				XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, rae->bno),
> > > > > > > > > > > > +				rae->len, &oinfo);
> > > > > > > > > > > > +		if (error)
> > > > > > > > > > > > +			return error;
> > > > > > > > > > > > +		list_del(&rae->list);
> > > > > > > > > > > > +		kmem_free(rae);
> > > > > > > > > > > > +	}
> > > > > > > > > > > 
> > > > > > > > > > > Ok, at this point we've reset the btree roots and we start freeing the
> > > > > > > > > > > free ranges that were discovered via the rmapbt analysis. AFAICT, if we
> > > > > > > > > > > fail or crash at this point, we leave the allocbts in a partially
> > > > > > > > > > > constructed state. I take it that is Ok with respect to the broader
> > > > > > > > > > > repair algorithm because we'd essentially start over by inspecting the
> > > > > > > > > > > rmapbt again on a retry.
> > > > > > > > > > 
> > > > > > > > > > Right.  Though in the crash/shutdown case, you'll end up with the
> > > > > > > > > > filesystem in an offline state at some point before you can retry the
> > > > > > > > > > scrub, it's probably faster to run xfs_repair to fix the damage.
> > > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > Can we really assume that if we're already up and running an online
> > > > > > > > > repair? The filesystem has to be mountable in that case in the first
> > > > > > > > > place. If we've already reset and started reconstructing the allocation
> > > > > > > > > btrees then I'd think those transactions would recover just fine on a
> > > > > > > > > power loss or something (perhaps not in the event of some other
> > > > > > > > > corruption related shutdown).
> > > > > > > > 
> > > > > > > > Right, for the system crash case, whatever transactions committed should
> > > > > > > > replay just fine, and you can even start up the online repair again, and
> > > > > > > > if the AG isn't particularly close to ENOSPC then (barring rmap
> > > > > > > > corruption) it should work just fine.
> > > > > > > > 
> > > > > > > > If the fs went down because either (a) repair hit other corruption or
> > > > > > > > (b) some other thread hit an error in some other part of the filesystem,
> > > > > > > > then it's not so clear -- in (b) you could probably try again, but for
> > > > > > > > (a) you'll definitely have to unmount and run xfs_repair.
> > > > > > > > 
> > > > > > > 
> > > > > > > Indeed, there are certainly cases where we simply won't be able to do an
> > > > > > > online repair. I'm trying to think about scenarios where we should be
> > > > > > > able to do an online repair, but we lose power or hit some kind of
> > > > > > > transient error like a memory allocation failure before it completes. It
> > > > > > > would be nice if the online repair itself didn't contribute (within
> > > > > > > reason) to the inability to simply try again just because the fs was
> > > > > > > close to -ENOSPC.
> > > > > > 
> > > > > > Agreed.  Most of the, uh, opportunities to hit ENOMEM happen before we
> > > > > > start modifying on-disk metadata.  If that happens, we just free all the
> > > > > > memory and bail out having done nothing.
> > > > > > 
> > > > > > > For one, I think it's potentially confusing behavior. Second, it might
> > > > > > > be concerning to regular users who perceive it as an online repair
> > > > > > > leaving the fs in a worse off state. Us fs devs know that may not really
> > > > > > > be the case, but I think we're better for addressing it if we can
> > > > > > > reasonably do so.
> > > > > > 
> > > > > > <nod> Further in the future I want to add the ability to offline an AG,
> > > > > > so the worst that happens is that scrub turns the AG off, repair doesn't
> > > > > > fix it, and the AG simply stays offline.  That might give us the
> > > > > > ability to survive cancelling the repair transaction, since if the AG's
> > > > > > offline already anyway we could just throw away the dirty buffers and
> > > > > > resurrect the AG later.  I don't know, that's purely speculative.
> > > > > > 
> > > > > > > > Perhaps the guideline here is that if the fs goes down more than once
> > > > > > > > during online repair then unmount it and run xfs_repair.
> > > > > > > > 
> > > > > > > 
> > > > > > > Yep, I think that makes sense if the filesystem or repair itself is
> > > > > > > tripping over other corruptions that fail to keep it active for the
> > > > > > > duration of the repair.
> > > > > > 
> > > > > > <nod>
> > > > > > 
> > > > > > > > > > > The blocks allocated for the btrees that we've begun to construct here
> > > > > > > > > > > end up mapped in the rmapbt as we go, right? IIUC, that means we don't
> > > > > > > > > > > necessarily have infinite retries to make sure this completes. IOW,
> > > > > > > > > > > suppose that a first repair attempt finds just enough free space to
> > > > > > > > > > > construct new trees, gets far enough along to consume most of that free
> > > > > > > > > > > space and then crashes. Is it possible that a subsequent repair attempt
> > > > > > > > > > > includes the btree blocks allocated during the previous failed repair
> > > > > > > > > > > attempt in the sum of "old btree blocks" and determines we don't have
> > > > > > > > > > > enough free space to repair?
> > > > > > > > > > 
> > > > > > > > > > Yes, that's a risk of running the free space repair.
> > > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > Can we improve on that? For example, are the rmapbt entries for the old
> > > > > > > > > allocation btree blocks necessary once we commit the btree resets? If
> > > > > > > > > not, could we remove those entries before we start tree reconstruction?
> > > > > > > > > 
> > > > > > > > > Alternatively, could we incorporate use of the old btree blocks? As it
> > > > > > > > > is, we discover those blocks simply so we can free them at the end.
> > > > > > > > > Perhaps we could free them sooner or find a more clever means to
> > > > > > > > > reallocate directly from that in-core list? I guess we have to consider
> > > > > > > > > whether they were really valid/sane btree blocks, but either way ISTM
> > > > > > > > > that the old blocks list is essentially invalidated once we reset the
> > > > > > > > > btrees.
> > > > > > > > 
> > > > > > > > Hmm, it's a little tricky to do that -- we could reap the old bnobt and
> > > > > > > > cntbt blocks (in the old_allocbt_blocks bitmap) first, but if adding a
> > > > > > > > record causes a btree split we'll pull blocks from the AGFL, and if
> > > > > > > > there aren't enough blocks in the bnobt to fill the AGFL back up then
> > > > > > > > fix_freelist won't succeed.  That complication is why it finds the
> > > > > > > > longest extent in the unclaimed list and pushes that in first, then
> > > > > > > > works on the rest of the extents.
> > > > > > > > 
> > > > > > > 
> > > > > > > Hmm, but doesn't a btree split require at least one full space btree
> > > > > > > block per-level? In conjunction, the agfl minimum size requirement grows
> > > > > > > with the height of the tree, which implies available free space..? I
> > > > > > > could be missing something, perhaps we have to account for the rmapbt in
> > > > > > > that case as well? Regardless...
> > > > > > > 
> > > > > > > > I suppose one could try to avoid ENOSPC by pushing that longest extent
> > > > > > > > in first (since we know that won't trigger a split), then reap the old
> > > > > > > > alloc btree blocks, and then add everything else back in...
> > > > > > > > 
> > > > > > > 
> > > > > > > I think it would be reasonable to seed the btree with the longest record
> > > > > > > or some fixed number of longest records (~1/2 a root block, for example)
> > > > > > > before making actual use of the btrees to reap the old blocks. I think
> > > > > > > then you'd only have a very short window of a single block leak on a
> > > > > > > poorly timed power loss and repair retry sequence before you start
> > > > > > > actually freeing originally used space (which in practice, I think
> > > > > > > solves the problem).
> > > > > > > 
> > > > > > > Given that we're starting from empty, I wonder if another option may be
> > > > > > > to over fill the agfl with old btree blocks or something. The first real
> > > > > > > free should shift enough blocks back into the btrees to ensure the agfl
> > > > > > > can be managed from that point forward, right? That may be more work
> > > > > > > than it's worth though and/or a job for another patch. (FWIW, we also
> > > > > > > have that NOSHRINK agfl fixup flag for userspace repair.)
> > > > > > 
> > > > > > Yes, I'll give that a try tomorrow, now that I've finished porting all
> > > > > > the 4.19 stuff to xfsprogs. :)
> > > > > > 
> > > > > > Looping back to something we discussed earlier in this thread, I'd
> > > > > > prefer to hold off on converting the list of already-freed extents to
> > > > > > xfs_bitmap because the same problem exists in all the repair functions
> > > > > > of having to store a large number of records for the rebuilt btree, and
> > > > > > maybe there's some way to <cough> use pageable memory for that, since
> > > > > > the access patterns for that are append, sort, and iterate; for those
> > > > > > three uses we don't necessarily require all the records to be in memory
> > > > > > all the time.  For the allocbt repair I expect the free space records to
> > > > > > be far more numerous than the list of old bnobt/cntbt blocks.
> > > > > > 
> > > > > 
> > > > > Ok, it's fair enough that we'll probably want to find some kind of
> > > > > generic, more efficient technique for handling this across the various
> > > > > applicable repair algorithms.
> > > > > 
> > > > > One other high level thing that crossed my mind with regard to the
> > > > > general btree reconstruction algorithms is whether we need to build up
> > > > > this kind of central record list at all. For example, rather than slurp
> > > > > up the entire list of btree records in-core, sort it and dump it back
> > > > > out, could we take advantage of the fact that our existing on-disk
> > > > > structure insertion mechanisms already handle out of order records
> > > > > (simply stated, an extent free knows how to insert the associated record
> > > > > at the right place in the space btrees)? For example, suppose we reset
> > > > > the existing btrees first, then scanned the rmapbt and repopulated the
> > > > > new btrees as records are discovered..?
> > > > 
> > > > I tried that in an earlier draft of the bnobt repair function.  The
> > > > biggest problem with inserting as we go is dealing with the inevitable
> > > > transaction rolls (right now we do after every record insertion to avoid
> > > > playing games with guessing how much reservation is left).  Btree
> > > > cursor state can't survive transaction rolls because the transaction
> > > > commit releases all the buffers that aren't bhold'en, and we can't bhold
> > > > that many buffers across a _defer_finish.
> > > > 
> > > 
> > > Ok, interesting.
> > > 
> > > Where do we need to run an xfs_defer_finish() during the reconstruction
> > > sequence, btw?
> > 
> > Not here, as I'm sure you were thinking. :)  For the AG btrees
> > themselves it's sufficient to roll the transaction.  I suppose we could
> > simply have a xfs_btree_bhold function that would bhold every buffer so
> > that a cursor could survive a roll.
> > 
> > Inode fork reconstruction is going to require _defer_finish, however.
> > 
> 
> Ok, just wasn't sure if I missed something in the bits I've looked
> through so far..
> 
> > > I thought that would only run on final commit as opposed to
> > > intermediate rolls.
> > 
> > We could let the deferred items sit around until final commit, but I
> > think I'd prefer to process them as soon as possible since iirc deferred
> > items pin the log until they're finished.  I would hope that userspace
> > isn't banging on the log while repair runs, but it's certainly possible.
> > 
> 
> I was just surmising in general, not necessarily suggesting we change
> behavior.

Oh, ok.  Sorry, I misinterpreted you. :)

> > > We could just try and make the automatic buffer relogging list a
> > > dynamic allocation if there are enough held buffers in the
> > > transaction.
> > 
> > Hmm.  Might be worth pursuing...
> > 
> > > > So, that early draft spent a lot of time tearing down and reconstructing
> > > > rmapbt cursors since the standard _btree_query_all isn't suited to that
> > > > kind of usage.  It was easily twice as slow on a RAM-backed disk just
> > > > from the rmap cursor overhead and much more complex, so I rewrote it to
> > > > be simpler.  I also have a slight preference for not touching anything
> > > > until we're absolutely sure we have all the data we need to repair the
> > > > structure.
> > > > 
> > > 
> > > Yes, I think that is sane in principle. I'm just a bit concerned about
> > > how reliable that xfs_repair-like approach will be in the kernel longer
> > > term, particularly once we start having to deal with large filesystems
> > > and limited or contended memory, etc. We already have xfs_repair users
> > > that need to tweak settings because there isn't enough memory available
> > > to repair the fs. Granted that is for fs-wide repairs and the flipside
> > > is that we know a single AG can only be up to 1TB. It's certainly
> > > possible that putting some persistent backing behind the in-core data is
> > > enough to resolve the problem (and the current approach is certainly
> > > reasonable enough to me for the initial implementation).
> > > 
> > > bjoin limitations aside, I wonder if a cursor roll mechanism that held
> > > all of the cursor buffers, rolled the transaction and then rejoined all
> > > said buffers would help us get around that. (Not sure I follow the early
> > > prototype behavior, but it sounds like we had to restart the rmapbt
> > > lookup over and over...).
> > 
> > Correct.
> > 
> > > Another caveat with that approach may be that I think we'd need to be
> > > sure that the reconstruction operation doesn't ever need to update the
> > > rmapbt while we're mid walk of the latter.
> > 
> > <nod> Looking even farther back in my notes, that was also an issue --
> > fixing the free list causes blocks to go on or off the agfl, which
> > causes rmapbt updates, which meant that the only way I could get
> > in-place updates to work was to re-lookup where we were in the btree and
> > also try to deal with any rmapbt entries that might have crept in as
> > result of the record insertion.
> > 
> > Getting the concurrency right for each repair function looked like a
> > difficult problem to solve, but amassing all the records elsewhere and
> > rebuilding was easy to understand.
> > 
> 
> Yeah. This all points to this kind of strategy being too complex to be
> worth the prospective benefits in the short term. Clearly we have
> several, potentially tricky roadblocks to work through before this can
> be made feasible. Thanks for the background, it's still useful to have
> this context to compare with whatever we may have to do to support a
> reclaimable memory approach.

<nod>  Reclaimable memfd "memory" isn't too difficult, we can call
kernel_read and kernel_write, though lockdep gets pretty mad about xfs
taking sb_start_write (on the memfd filesystem) at the same time it has
sb_starT_write on the xfs (not to mention the stack usage) so I had to
throw in the extra twist of delegating the actual file io to a workqueue
item (a la xfs_btree_split).

> > > That may be an issue for inode btree reconstruction, for example,
> > > since it looks like inobt block allocation requires rmapbt updates.
> > > We'd probably need some way to share (or invalidate) a cursor across
> > > different contexts to deal with that.
> > 
> > I might pursue that strategy if we ever hit the point where we can't
> > find space to store the records (see below).  Another option could be to
> > divert all deferred items for an AG, build a replacement btree in new
> > space, then finish all the deferred items... but that's starting to get
> > into offlineable AGs, which is its own project that I want to tackle
> > later.
> > 
> > (Not that much later, just not this cycle.)
> > 
> 
> *nod*
> 
> > > > For other repair functions (like the data/attr fork repairs) we have to
> > > > scan all the rmapbts for extents, and I'd prefer to lock those AGs only
> > > > for as long as necessary to extract the extents we want.
> > > > 
> > > > > The obvious problem is that we still have some checks that allow the
> > > > > whole repair operation to bail out before we determine whether we can
> > > > > start to rebuild the on-disk btrees. These are things like making sure
> > > > > we can actually read the associated rmapbt blocks (i.e., no read errors
> > > > > or verifier failures), basic record sanity checks, etc. But ISTM that
> > > > > isn't anything we couldn't get around with a multi-pass implementation.
> > > > > Secondary issues might be things like no longer being able to easily
> > > > > insert the longest free extent range(s) first (meaning we'd have to
> > > > > stuff the agfl with old btree blocks or figure out some other approach).
> > > > 
> > > > Well, you could scan the rmapbt twice -- once to find the longest
> > > > record, then again to do the actual insertion.
> > > > 
> > > 
> > > Yep, that's what I meant by multi-pass.
> > > 
> > > > > BTW, isn't the typical scrub sequence already multi-pass by virtue of
> > > > > the xfs_scrub_metadata() implementation? I'm wondering if the ->scrub()
> > > > > callout could not only detect corruption, but validate whether repair
> > > > > (if requested) is possible based on the kind of checks that are
> > > > > currently in the repair side rmapbt walkers. Thoughts?r
> > > > 
> > > > Yes, scrub basically validates that for us now, with the notable
> > > > exception of the notorious rmapbt scrubber, which doesn't
> > > > cross-reference with inode block mappings because that would be a
> > > > locking nightmare.
> > > > 
> > > > > Are there future
> > > > > changes that are better supported by an in-core tracking structure in
> > > > > general (assuming we'll eventually replace the linked lists with
> > > > > something more efficient) as opposed to attempting to optimize out the
> > > > > need for that tracking at all?
> > > > 
> > > > Well, I was thinking that we could just allocate a memfd (or a file on
> > > > the same xfs once we have AG offlining) and store the records in there.
> > > > That saves us the list_head overhead and potentially enables access to a
> > > > lot more storage than pinning things in RAM.
> > > > 
> > > 
> > > Would using the same fs mean we have to store the repair data in a
> > > separate AG, or somehow locate/use free space in the target AG?
> > 
> > As part of building an "offline AG" feature we'd presumably have to
> > teach the allocators to avoid the offline AGs for allocations, which
> > would make it so that we could host the repair data files in the same
> > XFS that's being fixed.  That seems a little risky to me, but the disk
> > is probably larger than mem+swap.
> > 
> 
> Got it, so we'd use the remaining space in the fs outside of the target
> AG. ISTM that still presumes the rest of the fs is coherent, but I
> suppose the offline AG thing helps us with that. We'd just have to make
> sure we've shut down all currently corrupted AGs before we start to
> repair a particular corrupted one, and then hope there's still enough
> free space in the fs to proceed.

That's a pretty big hope. :)  I think for now 

> That makes more sense, but I still agree that it seems risky in general.
> Technical risk aside, there's also usability concerns in that the local
> free space requirement is another bit of non-determinism

I don't think it's non-deterministic, it's just hard for the filesystem
to communicate to the user/admin ahead of time.  Roughly speaking, we
need to have about as much disk space for the new btree as we had
allocated for the old one.

As far as memory requirements go, in last week's revising of the patches
I compressed the in-memory record structs down about as far as possible;
with the removal of the list heads, the memory requirements drop by
30-60%.  We require the same amount of memory as would be needed to
store all of the records in the leaf nodes, and no more, and we can use
swap space to do it.

> around the ability to online repair vs. having to punt to xfs_repair,
> or if the repair consumes whatever free space remains in the fs to the
> detriment of whatever workload the user presumably wanted to keep the
> fs online for, etc.

I've occasionally thought that future xfs_scrub could ask the kernel to
estimate how much disk and memory it will need for the repair (and
whether the disk space requirement is fs-scope or AG-scope); then it
could forego a repair action and recommend xfs_repair if running the
online repair would take the system below some configurable threshold.

> > > presume either way we'd have to ensure that AG is either consistent or
> > > locked out from outside I/O. If we have the total record count we can
> > 
> > We usually don't, but for the btrees that have their own record/blocks
> > counters we might be able to guess a number, fallocate it, and see if
> > that doesn't ENOSPC.
> > 
> > > preallocate the file and hope there is no such other free space
> > > corruption or something that would allow some other task to mess with
> > > our blocks. I'm a little skeptical overall on relying on a corrupted
> > > filesystem to store repair data, but perhaps there are ways to mitigate
> > > the risks.
> > 
> > Store it elsewhere?  /home for root repairs, /root for any other
> > repair... though if we're going to do that, why not just add a swap file
> > temporarily?
> > 
> 
> Indeed. The thought crossed my mind about whether we could do something
> like have an internal/isolated swap file for dedicated XFS allocations
> to avoid contention with the traditional swap.

Heh, I think e2fsck has some feature like that where you can pass it a
swap file.  No idea how much good that does on modern systems where
there's one huge partition... :)

> Userspace could somehow set it up or communicate to the kernel. I have
> no idea how realistic that is though or if there's a better interface
> for that kind of thing (i.e., file backed kmem cache?).

I looked, and there aren't any other mechanisms for unpinnned kernel
memory allocations.

> What _seems_ beneficial about that approach is we get (potentially
> external) persistent backing and memory reclaim ability with the
> traditional memory allocation model.
>
> ISTM that if we used a regular file, we'd need to deal with the
> traditional file interface somehow or another (file read/pagecache
> lookup -> record ??).

Yes, that's all neatly wrapped up in kernel_read() and kernel_write() so
all we need is a (struct file *).

> We could repurpose some existing mechanism like the directory code or
> quota inode mechanism to use xfs buffers for that purpose, but I think
> that would require us to always use an internal inode. Allowing
> userspace to pass an fd/file passes that consideration on to the user,
> which might be more flexible. We could always warn about additional
> limitations if that fd happens to be based on the target fs.

<nod> A second advantage of the struct file/kernel_{read,write} approach
is that we if we ever decide to let userspace pass in a fd, it's trivial
to feed that struct file to the kernel io routines instead of a memfd
one.

> > > I'm not familiar with memfd. The manpage suggests it's ram backed, is it
> > > swappable or something?
> > 
> > It's supposed to be.  The quick test I ran (allocate a memfd, write 1GB
> > of junk to it on a VM with 400M of RAM) seemed to push about 980MB into
> > the swap file.
> > 
> 
> Ok.
> 
> > > If so, that sounds a reasonable option provided the swap space
> > > requirement can be made clear to users
> > 
> > We can document it.  I don't think it's any worse than xfs_repair being
> > able to use up all the memory + swap... and since we're probably only
> > going to be repairing one thing at a time, most likely scrub won't need
> > as much memory.
> > 
> 
> Right, but as noted below, my concerns with the xfs_repair comparison
> are that 1.) the kernel generally has more of a limit on anonymous
> memory allocations than userspace (i.e., not swappable AFAIU?) and 2.)
> it's not clear how effectively running the system out of memory via the
> kernel will behave from a failure perspective.
> 
> IOW, xfs_repair can run the system out of memory but for the most part
> that ends up being a simple problem for the system: OOM kill the bloated
> xfs_repair process. For an online repair in a similar situation, I have
> no idea what's going to happen.

Back in the days of the huge linked lists the oom killer would target
other proceses because it doesn't know that the online repair thread is
sitting on a ton of pinned kernel memory...

> The hope is that the online repair hits -ENOMEM and unwinds, but ISTM
> we'd still be at risk of other subsystems running into memory
> allocation problems, filling up swap, the OOM killer going after
> unrelated processes, etc.  What if, for example, the OOM killer starts
> picking off processes in service to a running online repair that
> immediately consumes freed up memory until the system is borked?

Yeah.  One thing we /could/ do is register an oom notifier that would
urge any running repair threads to bail out if they can.  It seems to me
that the oom killer blocks on the oom_notify_list chain, so our handler
could wait until at least one thread exits before returning.

> I don't know how likely that is or if it really ends up much different
> from the analogous xfs_repair situation. My only point right now is
> that failure scenario is something we should explore for any solution
> we ultimately consider because it may be an unexpected use case of the
> underlying mechanism.

Ideally, online repair would always be the victim since we know we have
a reasonable fallback.  At least for memfd, however, I think the only
clues we have to decide the question "is this memfd getting in the way
of other threads?" is either seeing ENOMEM, short writes, or getting
kicked by an oom notification.  Maybe that'll be enough?

> (To the contrary, just using a cached file seems a natural fit from
> that perspective.)

Same here.

> > > and the failure characteristics aren't more severe than for userspace.
> > > An online repair that puts the broader system at risk of OOM as
> > > opposed to predictably failing gracefully may not be the most useful
> > > tool.
> > 
> > Agreed.  One huge downside of memfd seems to be the lack of a mechanism
> > for the vm to push back on us if we successfully write all we need to
> > the memfd but then other processes need some memory.  Obviously, if the
> > memfd write itself comes up short or fails then we dump the memfd and
> > error back to userspace.  We might simply have to free array memory
> > while we iterate the records to minimize the time spent at peak memory
> > usage.
> > 
> 
> Hm, yeah. Some kind of fixed/relative size in-core memory pool approach
> may simplify things because we could allocate it up front and know right
> away whether we just don't have enough memory available to repair.

Hmm.  Apparently we actually /can/ call fallocate on memfd to grab all
the pages at once, provided we have some guesstimate beforehand of how
much space we think we'll need.

So long as my earlier statement about the memory requirements being no
more than the size of the btree leaves is actually true (I haven't
rigorously tried to prove it), we need about (xrep_calc_ag_resblks() *
blocksize) worth of space in the memfd file.  Maybe we ask for 1.5x
that and if we don't get it, we kill the memfd and exit.

--D

> 
> Brian
> 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > > --D
> > > > 
> > > > > Brian
> > > > > 
> > > > > > --D
> > > > > > 
> > > > > > > Brian
> > > > > > > 
> > > > > > > > --D
> > > > > > > > 
> > > > > > > > > Brian
> > > > > > > > > 
> > > > > > > > > > > > +
> > > > > > > > > > > > +done:
> > > > > > > > > > > > +	/* Free all the OWN_AG blocks that are not in the rmapbt/agfl. */
> > > > > > > > > > > > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> > > > > > > > > > > > +	return xrep_reap_extents(sc, old_allocbt_blocks, &oinfo,
> > > > > > > > > > > > +			XFS_AG_RESV_NONE);
> > > > > > > > > > > > +}
> > > > > > > > > > > > +
> > > > > > > > > > > ...
> > > > > > > > > > > > diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> > > > > > > > > > > > index 0ed68379e551..82f99633a597 100644
> > > > > > > > > > > > --- a/fs/xfs/xfs_extent_busy.c
> > > > > > > > > > > > +++ b/fs/xfs/xfs_extent_busy.c
> > > > > > > > > > > > @@ -657,3 +657,17 @@ xfs_extent_busy_ag_cmp(
> > > > > > > > > > > >  		diff = b1->bno - b2->bno;
> > > > > > > > > > > >  	return diff;
> > > > > > > > > > > >  }
> > > > > > > > > > > > +
> > > > > > > > > > > > +/* Are there any busy extents in this AG? */
> > > > > > > > > > > > +bool
> > > > > > > > > > > > +xfs_extent_busy_list_empty(
> > > > > > > > > > > > +	struct xfs_perag	*pag)
> > > > > > > > > > > > +{
> > > > > > > > > > > > +	spin_lock(&pag->pagb_lock);
> > > > > > > > > > > > +	if (pag->pagb_tree.rb_node) {
> > > > > > > > > > > 
> > > > > > > > > > > RB_EMPTY_ROOT()?
> > > > > > > > > > 
> > > > > > > > > > Good suggestion, thank you!
> > > > > > > > > > 
> > > > > > > > > > --D
> > > > > > > > > > 
> > > > > > > > > > > Brian
> > > > > > > > > > > 
> > > > > > > > > > > > +		spin_unlock(&pag->pagb_lock);
> > > > > > > > > > > > +		return false;
> > > > > > > > > > > > +	}
> > > > > > > > > > > > +	spin_unlock(&pag->pagb_lock);
> > > > > > > > > > > > +	return true;
> > > > > > > > > > > > +}
> > > > > > > > > > > > diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> > > > > > > > > > > > index 990ab3891971..2f8c73c712c6 100644
> > > > > > > > > > > > --- a/fs/xfs/xfs_extent_busy.h
> > > > > > > > > > > > +++ b/fs/xfs/xfs_extent_busy.h
> > > > > > > > > > > > @@ -65,4 +65,6 @@ static inline void xfs_extent_busy_sort(struct list_head *list)
> > > > > > > > > > > >  	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
> > > > > > > > > > > >  }
> > > > > > > > > > > >  
> > > > > > > > > > > > +bool xfs_extent_busy_list_empty(struct xfs_perag *pag);
> > > > > > > > > > > > +
> > > > > > > > > > > >  #endif /* __XFS_EXTENT_BUSY_H__ */
> > > > > > > > > > > > 
> > > > > > > > > > > > --
> > > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > > > --
> > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > > --
> > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > --
> > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > --
> > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > --
> > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
