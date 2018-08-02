Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53212 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbeHBISd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Aug 2018 04:18:33 -0400
Date: Wed, 1 Aug 2018 23:28:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/14] xfs: repair free space btrees
Message-ID: <20180802062845.GQ30972@magnolia>
References: <153292966714.24509.15809693393247424274.stgit@magnolia>
 <153292970169.24509.4581630892233165448.stgit@magnolia>
 <20180731174722.GI40201@bfoster>
 <20180731220125.GY30972@magnolia>
 <20180801115409.GA48176@bfoster>
 <20180801162316.GH30972@magnolia>
 <20180801183919.GE48176@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180801183919.GE48176@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Wed, Aug 01, 2018 at 02:39:20PM -0400, Brian Foster wrote:
> On Wed, Aug 01, 2018 at 09:23:16AM -0700, Darrick J. Wong wrote:
> > On Wed, Aug 01, 2018 at 07:54:09AM -0400, Brian Foster wrote:
> > > On Tue, Jul 31, 2018 at 03:01:25PM -0700, Darrick J. Wong wrote:
> > > > On Tue, Jul 31, 2018 at 01:47:23PM -0400, Brian Foster wrote:
> > > > > On Sun, Jul 29, 2018 at 10:48:21PM -0700, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > 
> > > > > > Rebuild the free space btrees from the gaps in the rmap btree.
> > > > > > 
> > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > ---
> > > > > >  fs/xfs/Makefile             |    1 
> > > > > >  fs/xfs/scrub/alloc.c        |    1 
> > > > > >  fs/xfs/scrub/alloc_repair.c |  581 +++++++++++++++++++++++++++++++++++++++++++
> > > > > >  fs/xfs/scrub/common.c       |    8 +
> > > > > >  fs/xfs/scrub/repair.h       |    2 
> > > > > >  fs/xfs/scrub/scrub.c        |    4 
> > > > > >  fs/xfs/scrub/trace.h        |    2 
> > > > > >  fs/xfs/xfs_extent_busy.c    |   14 +
> > > > > >  fs/xfs/xfs_extent_busy.h    |    2 
> > > > > >  9 files changed, 610 insertions(+), 5 deletions(-)
> > > > > >  create mode 100644 fs/xfs/scrub/alloc_repair.c
> > > > > > 
> > > > > > 
> > > > > ...
> > > > > > diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
> > > > > > new file mode 100644
> > > > > > index 000000000000..b228c2906de2
> > > > > > --- /dev/null
> > > > > > +++ b/fs/xfs/scrub/alloc_repair.c
> > > > > > @@ -0,0 +1,581 @@
> ...
> > > > > > +
> > > > > > +/*
> > > > > > + * Make our new freespace btree roots permanent so that we can start freeing
> > > > > > + * unused space back into the AG.
> > > > > > + */
> > > > > > +STATIC int
> > > > > > +xrep_abt_commit_new(
> > > > > > +	struct xfs_scrub	*sc,
> > > > > > +	struct xfs_bitmap	*old_allocbt_blocks,
> > > > > > +	int			log_flags)
> > > > > > +{
> > > > > > +	int			error;
> > > > > > +
> > > > > > +	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, log_flags);
> > > > > > +
> > > > > > +	/* Invalidate the old freespace btree blocks and commit. */
> > > > > > +	error = xrep_invalidate_blocks(sc, old_allocbt_blocks);
> > > > > > +	if (error)
> > > > > > +		return error;
> > > > > 
> > > > > It looks like the above invalidation all happens in the same
> > > > > transaction. Those aren't logging buffer data or anything, but any idea
> > > > > how many log formats we can get away with in this single transaction?
> > > > 
> > > > Hm... well, on my computer a log format is ~88 bytes.  Assuming 4K
> > > > blocks, the max AG size of 1TB, maximum free space fragmentation, and
> > > > two btrees, the tree could be up to ~270 million records.  Assuming ~505
> > > > records per block, that's ... ~531,000 leaf blocks and ~1100 node blocks
> > > > for both btrees.  If we invalidate both, that's ~46M of RAM?
> > > > 
> > > 
> > > I was thinking more about transaction reservation than RAM. It may not
> > 
> > Hmm.  tr_itruncate is ~650K on my 2TB SSD, assuming 88 bytes per, that's
> > about ... ~7300 log format items?  Not a lot, maybe it should roll the
> > transaction every 1000 invalidations or so...
> > 
> 
> I'm not really sure what categorizes as a lot here given that the blocks
> would need to be in-core, but rolling on some fixed/safe interval sounds
> reasonable to me.
> 
> > > currently be an issue, but it might be worth putting something down in a
> > > comment to note that this is a single transaction and we expect to not
> > > have to invalidate more than N (ballpark) blocks in a single go,
> > > whatever that value happens to be.
> > > 
> > > > > > +	error = xrep_roll_ag_trans(sc);
> > > > > > +	if (error)
> > > > > > +		return error;
> > > > > > +
> > > > > > +	/* Now that we've succeeded, mark the incore state valid again. */
> > > > > > +	sc->sa.pag->pagf_init = 1;
> > > > > > +	return 0;
> > > > > > +}
> > > > > > +
> > > > > > +/* Build new free space btrees and dispose of the old one. */
> > > > > > +STATIC int
> > > > > > +xrep_abt_rebuild_trees(
> > > > > > +	struct xfs_scrub	*sc,
> > > > > > +	struct list_head	*free_extents,
> > > > > > +	struct xfs_bitmap	*old_allocbt_blocks)
> > > > > > +{
> > > > > > +	struct xfs_owner_info	oinfo;
> > > > > > +	struct xrep_abt_extent	*rae;
> > > > > > +	struct xrep_abt_extent	*n;
> > > > > > +	struct xrep_abt_extent	*longest;
> > > > > > +	int			error;
> > > > > > +
> > > > > > +	xfs_rmap_skip_owner_update(&oinfo);
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * Insert the longest free extent in case it's necessary to
> > > > > > +	 * refresh the AGFL with multiple blocks.  If there is no longest
> > > > > > +	 * extent, we had exactly the free space we needed; we're done.
> > > > > > +	 */
> > > > > 
> > > > > I'm confused by the last sentence. longest should only be NULL if the
> > > > > free space list is empty and haven't we already bailed out with -ENOSPC
> > > > > if that's the case?
> > > > > 
> > > > > > +	longest = xrep_abt_get_longest(free_extents);
> > > > 
> > > > xrep_abt_rebuild_trees is called after we allocate and initialize two
> > > > new btree roots in xrep_abt_reset_btrees.  If free_extents is an empty
> > > > list here, then we found exactly two blocks worth of free space and used
> > > > them to set up new btree roots.
> > > > 
> > > 
> > > Got it, thanks.
> > > 
> > > > > > +	if (!longest)
> > > > > > +		goto done;
> > > > > > +	error = xrep_abt_free_extent(sc,
> > > > > > +			XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, longest->bno),
> > > > > > +			longest->len, &oinfo);
> > > > > > +	list_del(&longest->list);
> > > > > > +	kmem_free(longest);
> > > > > > +	if (error)
> > > > > > +		return error;
> > > > > > +
> > > > > > +	/* Insert records into the new btrees. */
> > > > > > +	list_for_each_entry_safe(rae, n, free_extents, list) {
> > > > > > +		error = xrep_abt_free_extent(sc,
> > > > > > +				XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, rae->bno),
> > > > > > +				rae->len, &oinfo);
> > > > > > +		if (error)
> > > > > > +			return error;
> > > > > > +		list_del(&rae->list);
> > > > > > +		kmem_free(rae);
> > > > > > +	}
> > > > > 
> > > > > Ok, at this point we've reset the btree roots and we start freeing the
> > > > > free ranges that were discovered via the rmapbt analysis. AFAICT, if we
> > > > > fail or crash at this point, we leave the allocbts in a partially
> > > > > constructed state. I take it that is Ok with respect to the broader
> > > > > repair algorithm because we'd essentially start over by inspecting the
> > > > > rmapbt again on a retry.
> > > > 
> > > > Right.  Though in the crash/shutdown case, you'll end up with the
> > > > filesystem in an offline state at some point before you can retry the
> > > > scrub, it's probably faster to run xfs_repair to fix the damage.
> > > > 
> > > 
> > > Can we really assume that if we're already up and running an online
> > > repair? The filesystem has to be mountable in that case in the first
> > > place. If we've already reset and started reconstructing the allocation
> > > btrees then I'd think those transactions would recover just fine on a
> > > power loss or something (perhaps not in the event of some other
> > > corruption related shutdown).
> > 
> > Right, for the system crash case, whatever transactions committed should
> > replay just fine, and you can even start up the online repair again, and
> > if the AG isn't particularly close to ENOSPC then (barring rmap
> > corruption) it should work just fine.
> > 
> > If the fs went down because either (a) repair hit other corruption or
> > (b) some other thread hit an error in some other part of the filesystem,
> > then it's not so clear -- in (b) you could probably try again, but for
> > (a) you'll definitely have to unmount and run xfs_repair.
> > 
> 
> Indeed, there are certainly cases where we simply won't be able to do an
> online repair. I'm trying to think about scenarios where we should be
> able to do an online repair, but we lose power or hit some kind of
> transient error like a memory allocation failure before it completes. It
> would be nice if the online repair itself didn't contribute (within
> reason) to the inability to simply try again just because the fs was
> close to -ENOSPC.

Agreed.  Most of the, uh, opportunities to hit ENOMEM happen before we
start modifying on-disk metadata.  If that happens, we just free all the
memory and bail out having done nothing.

> For one, I think it's potentially confusing behavior. Second, it might
> be concerning to regular users who perceive it as an online repair
> leaving the fs in a worse off state. Us fs devs know that may not really
> be the case, but I think we're better for addressing it if we can
> reasonably do so.

<nod> Further in the future I want to add the ability to offline an AG,
so the worst that happens is that scrub turns the AG off, repair doesn't
fix it, and the AG simply stays offline.  That might give us the
ability to survive cancelling the repair transaction, since if the AG's
offline already anyway we could just throw away the dirty buffers and
resurrect the AG later.  I don't know, that's purely speculative.

> > Perhaps the guideline here is that if the fs goes down more than once
> > during online repair then unmount it and run xfs_repair.
> > 
> 
> Yep, I think that makes sense if the filesystem or repair itself is
> tripping over other corruptions that fail to keep it active for the
> duration of the repair.

<nod>

> > > > > The blocks allocated for the btrees that we've begun to construct here
> > > > > end up mapped in the rmapbt as we go, right? IIUC, that means we don't
> > > > > necessarily have infinite retries to make sure this completes. IOW,
> > > > > suppose that a first repair attempt finds just enough free space to
> > > > > construct new trees, gets far enough along to consume most of that free
> > > > > space and then crashes. Is it possible that a subsequent repair attempt
> > > > > includes the btree blocks allocated during the previous failed repair
> > > > > attempt in the sum of "old btree blocks" and determines we don't have
> > > > > enough free space to repair?
> > > > 
> > > > Yes, that's a risk of running the free space repair.
> > > > 
> > > 
> > > Can we improve on that? For example, are the rmapbt entries for the old
> > > allocation btree blocks necessary once we commit the btree resets? If
> > > not, could we remove those entries before we start tree reconstruction?
> > > 
> > > Alternatively, could we incorporate use of the old btree blocks? As it
> > > is, we discover those blocks simply so we can free them at the end.
> > > Perhaps we could free them sooner or find a more clever means to
> > > reallocate directly from that in-core list? I guess we have to consider
> > > whether they were really valid/sane btree blocks, but either way ISTM
> > > that the old blocks list is essentially invalidated once we reset the
> > > btrees.
> > 
> > Hmm, it's a little tricky to do that -- we could reap the old bnobt and
> > cntbt blocks (in the old_allocbt_blocks bitmap) first, but if adding a
> > record causes a btree split we'll pull blocks from the AGFL, and if
> > there aren't enough blocks in the bnobt to fill the AGFL back up then
> > fix_freelist won't succeed.  That complication is why it finds the
> > longest extent in the unclaimed list and pushes that in first, then
> > works on the rest of the extents.
> > 
> 
> Hmm, but doesn't a btree split require at least one full space btree
> block per-level? In conjunction, the agfl minimum size requirement grows
> with the height of the tree, which implies available free space..? I
> could be missing something, perhaps we have to account for the rmapbt in
> that case as well? Regardless...
> 
> > I suppose one could try to avoid ENOSPC by pushing that longest extent
> > in first (since we know that won't trigger a split), then reap the old
> > alloc btree blocks, and then add everything else back in...
> > 
> 
> I think it would be reasonable to seed the btree with the longest record
> or some fixed number of longest records (~1/2 a root block, for example)
> before making actual use of the btrees to reap the old blocks. I think
> then you'd only have a very short window of a single block leak on a
> poorly timed power loss and repair retry sequence before you start
> actually freeing originally used space (which in practice, I think
> solves the problem).
> 
> Given that we're starting from empty, I wonder if another option may be
> to over fill the agfl with old btree blocks or something. The first real
> free should shift enough blocks back into the btrees to ensure the agfl
> can be managed from that point forward, right? That may be more work
> than it's worth though and/or a job for another patch. (FWIW, we also
> have that NOSHRINK agfl fixup flag for userspace repair.)

Yes, I'll give that a try tomorrow, now that I've finished porting all
the 4.19 stuff to xfsprogs. :)

Looping back to something we discussed earlier in this thread, I'd
prefer to hold off on converting the list of already-freed extents to
xfs_bitmap because the same problem exists in all the repair functions
of having to store a large number of records for the rebuilt btree, and
maybe there's some way to <cough> use pageable memory for that, since
the access patterns for that are append, sort, and iterate; for those
three uses we don't necessarily require all the records to be in memory
all the time.  For the allocbt repair I expect the free space records to
be far more numerous than the list of old bnobt/cntbt blocks.

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > > > > +
> > > > > > +done:
> > > > > > +	/* Free all the OWN_AG blocks that are not in the rmapbt/agfl. */
> > > > > > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> > > > > > +	return xrep_reap_extents(sc, old_allocbt_blocks, &oinfo,
> > > > > > +			XFS_AG_RESV_NONE);
> > > > > > +}
> > > > > > +
> > > > > ...
> > > > > > diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> > > > > > index 0ed68379e551..82f99633a597 100644
> > > > > > --- a/fs/xfs/xfs_extent_busy.c
> > > > > > +++ b/fs/xfs/xfs_extent_busy.c
> > > > > > @@ -657,3 +657,17 @@ xfs_extent_busy_ag_cmp(
> > > > > >  		diff = b1->bno - b2->bno;
> > > > > >  	return diff;
> > > > > >  }
> > > > > > +
> > > > > > +/* Are there any busy extents in this AG? */
> > > > > > +bool
> > > > > > +xfs_extent_busy_list_empty(
> > > > > > +	struct xfs_perag	*pag)
> > > > > > +{
> > > > > > +	spin_lock(&pag->pagb_lock);
> > > > > > +	if (pag->pagb_tree.rb_node) {
> > > > > 
> > > > > RB_EMPTY_ROOT()?
> > > > 
> > > > Good suggestion, thank you!
> > > > 
> > > > --D
> > > > 
> > > > > Brian
> > > > > 
> > > > > > +		spin_unlock(&pag->pagb_lock);
> > > > > > +		return false;
> > > > > > +	}
> > > > > > +	spin_unlock(&pag->pagb_lock);
> > > > > > +	return true;
> > > > > > +}
> > > > > > diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> > > > > > index 990ab3891971..2f8c73c712c6 100644
> > > > > > --- a/fs/xfs/xfs_extent_busy.h
> > > > > > +++ b/fs/xfs/xfs_extent_busy.h
> > > > > > @@ -65,4 +65,6 @@ static inline void xfs_extent_busy_sort(struct list_head *list)
> > > > > >  	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
> > > > > >  }
> > > > > >  
> > > > > > +bool xfs_extent_busy_list_empty(struct xfs_perag *pag);
> > > > > > +
> > > > > >  #endif /* __XFS_EXTENT_BUSY_H__ */
> > > > > > 
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
