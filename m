Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388555AbeHANji (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 09:39:38 -0400
Date: Wed, 1 Aug 2018 07:54:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/14] xfs: repair free space btrees
Message-ID: <20180801115409.GA48176@bfoster>
References: <153292966714.24509.15809693393247424274.stgit@magnolia>
 <153292970169.24509.4581630892233165448.stgit@magnolia>
 <20180731174722.GI40201@bfoster>
 <20180731220125.GY30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180731220125.GY30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Tue, Jul 31, 2018 at 03:01:25PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 31, 2018 at 01:47:23PM -0400, Brian Foster wrote:
> > On Sun, Jul 29, 2018 at 10:48:21PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Rebuild the free space btrees from the gaps in the rmap btree.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/Makefile             |    1 
> > >  fs/xfs/scrub/alloc.c        |    1 
> > >  fs/xfs/scrub/alloc_repair.c |  581 +++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/scrub/common.c       |    8 +
> > >  fs/xfs/scrub/repair.h       |    2 
> > >  fs/xfs/scrub/scrub.c        |    4 
> > >  fs/xfs/scrub/trace.h        |    2 
> > >  fs/xfs/xfs_extent_busy.c    |   14 +
> > >  fs/xfs/xfs_extent_busy.h    |    2 
> > >  9 files changed, 610 insertions(+), 5 deletions(-)
> > >  create mode 100644 fs/xfs/scrub/alloc_repair.c
> > > 
> > > 
> > ...
> > > diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
> > > new file mode 100644
> > > index 000000000000..b228c2906de2
> > > --- /dev/null
> > > +++ b/fs/xfs/scrub/alloc_repair.c
> > > @@ -0,0 +1,581 @@
> > ...
> > > +/* Record extents that aren't in use from gaps in the rmap records. */
> > > +STATIC int
> > > +xrep_abt_walk_rmap(
> > > +	struct xfs_btree_cur	*cur,
> > > +	struct xfs_rmap_irec	*rec,
> > > +	void			*priv)
> > > +{
> > > +	struct xrep_abt		*ra = priv;
> > > +	struct xrep_abt_extent	*rae;
> > > +	xfs_fsblock_t		fsb;
> > > +	int			error;
> > > +
> > > +	/* Record all the OWN_AG blocks... */
> > > +	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
> > > +		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
> > > +				rec->rm_startblock);
> > > +		error = xfs_bitmap_set(ra->btlist, fsb, rec->rm_blockcount);
> > > +		if (error)
> > > +			return error;
> > > +	}
> > > +
> > > +	/* ...and all the rmapbt blocks... */
> > > +	error = xfs_bitmap_set_btcur_path(&ra->nobtlist, cur);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	/* ...and all the free space. */
> > > +	if (rec->rm_startblock > ra->next_bno) {
> > > +		trace_xrep_abt_walk_rmap(cur->bc_mp, cur->bc_private.a.agno,
> > > +				ra->next_bno, rec->rm_startblock - ra->next_bno,
> > > +				XFS_RMAP_OWN_NULL, 0, 0);
> > > +
> > > +		rae = kmem_alloc(sizeof(struct xrep_abt_extent), KM_MAYFAIL);
> > > +		if (!rae)
> > > +			return -ENOMEM;
> > > +		INIT_LIST_HEAD(&rae->list);
> > > +		rae->bno = ra->next_bno;
> > > +		rae->len = rec->rm_startblock - ra->next_bno;
> > > +		list_add_tail(&rae->list, ra->extlist);
> > 
> > Any reason we don't use a bitmap for this one?
> > 

??

> > > +		ra->nr_records++;
> > > +		ra->nr_blocks += rae->len;
> > > +	}
> > > +	ra->next_bno = max_t(xfs_agblock_t, ra->next_bno,
> > > +			rec->rm_startblock + rec->rm_blockcount);
> > 
> > The max_t() is to cover the record overlap case, right? If so, another
> > one liner comment would be good.
> 
> Right.  Will add a comment.
> 
> > > +	return 0;
> > > +}
> > > +
> > ...
> > > +/* Free an extent, which creates a record in the bnobt/cntbt. */
> > > +STATIC int
> > > +xrep_abt_free_extent(
> > > +	struct xfs_scrub	*sc,
> > > +	xfs_fsblock_t		fsbno,
> > > +	xfs_extlen_t		len,
> > > +	struct xfs_owner_info	*oinfo)
> > > +{
> > > +	int			error;
> > > +
> > > +	error = xfs_free_extent(sc->tp, fsbno, len, oinfo, 0);
> > > +	if (error)
> > > +		return error;
> > > +	error = xrep_roll_ag_trans(sc);
> > > +	if (error)
> > > +		return error;
> > > +	return xfs_mod_fdblocks(sc->mp, -(int64_t)len, false);
> > 
> > What's this call for? Is it because the blocks we're freeing were
> > already free? (Similar question on the other xfs_mod_fdblocks() call
> > further down).
> 
> Yes.  The goal here is to free the (already free) extent with no net
> change in fdblocks...
> 
> > BTW, what prevents some other task from coming along and screwing with
> > this? For example, could a large falloc or buffered write come in and
> > allocate these global blocks before we take them away here (causing the
> > whole sequence to fail)?
> 
> ...but you're right that here is a window of opportunity for someone to
> swoop in and reserve the blocks while we still have the AGF locked,
> which means that we'll fail here even though that other process will
> never get the space.
> 
> Thinking about this a bit more, what we really want to do is to skip the
> xfs_trans_mod_sb(len) that happens after xfs_free_ag_extent inserts the
> record into the bno/cntbt.  Hm.  If a record insertion requires an
> expansion of the bnobt/cntbt, we'll pull blocks from the AGFL, but we
> separately force those to be accounted to XFS_AG_RESV_AGFL.  Therefore,
> we could make a "fake" per-AG reservation type that would skip the
> fdblocks update.  That avoids the problem where we commit the free space
> record but someone else reserves all the free space and then we blow out
> with ENOSPC and a half-rebuilt bnobt.
> 

Ok, that sounds a bit more straightforward to me.

> For the second case (which I assume is xrep_abt_reset_counters?) I'll
> respond below.
> 
> > > +}
> > > +
...
> > > +/*
> > > + * Reset the global free block counter and the per-AG counters to make it look
> > > + * like this AG has no free space.
> > > + */
> > > +STATIC int
> > > +xrep_abt_reset_counters(
> > > +	struct xfs_scrub	*sc,
> > > +	int			*log_flags)
> > > +{
> > > +	struct xfs_perag	*pag = sc->sa.pag;
> > > +	struct xfs_agf		*agf;
> > > +	xfs_agblock_t		new_btblks;
> > > +	xfs_agblock_t		to_free;
> > > +	int			error;
> > > +
> > > +	/*
> > > +	 * Since we're abandoning the old bnobt/cntbt, we have to decrease
> > > +	 * fdblocks by the # of blocks in those trees.  btreeblks counts the
> > > +	 * non-root blocks of the free space and rmap btrees.  Do this before
> > > +	 * resetting the AGF counters.
> > > +	 */
> > 
> > Hmm, I'm not quite following the comment wrt to the xfs_mod_fdblocks()
> > below. to_free looks like it's the count of all current btree blocks
> > minus rmap blocks (i.e., old bno/cnt btree blocks). Are we "allocating"
> > those blocks here because we're going to free them later?
> 
> Yes.  Though now that I have a XFS_AG_RESV_IGNORE, maybe I should just
> pass that to xrep_reap_extents in xrep_abt_rebuild_trees and then I can
> skip the racy mod_fdblocks thing here too.
> 

I think I'll ultimately need to see the code to make sure I follow the
ignore thing correctly, but that overall sounds better to me. If we do
retain these kind of calls to undo/work-around underlying
infrastructure, I think we need a bit more specific comments that
describe precisely what behavior the call is offsetting.

> > > +	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
> > > +
> > > +	/* rmap_blocks accounts root block, btreeblks doesn't */
> > > +	new_btblks = be32_to_cpu(agf->agf_rmap_blocks) - 1;
> > > +
> > > +	/* btreeblks doesn't account bno/cnt root blocks */
> > > +	to_free = pag->pagf_btreeblks + 2;
> > > +
> > > +	/* and don't account for the blocks we aren't freeing */
> > > +	to_free -= new_btblks;
> > > +
> > > +	error = xfs_mod_fdblocks(sc->mp, -(int64_t)to_free, false);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	/*
> > > +	 * Reset the per-AG info, both incore and ondisk.  Mark the incore
> > > +	 * state stale in case we fail out of here.
> > > +	 */
> > > +	ASSERT(pag->pagf_init);
> > > +	pag->pagf_init = 0;
> > > +	pag->pagf_btreeblks = new_btblks;
> > > +	pag->pagf_freeblks = 0;
> > > +	pag->pagf_longest = 0;
> > > +
> > > +	agf->agf_btreeblks = cpu_to_be32(new_btblks);
> > > +	agf->agf_freeblks = 0;
> > > +	agf->agf_longest = 0;
> > > +	*log_flags |= XFS_AGF_BTREEBLKS | XFS_AGF_LONGEST | XFS_AGF_FREEBLKS;
> > > +
> > > +	return 0;
> > > +}
> > > +
...
> > > +
> > > +/*
> > > + * Make our new freespace btree roots permanent so that we can start freeing
> > > + * unused space back into the AG.
> > > + */
> > > +STATIC int
> > > +xrep_abt_commit_new(
> > > +	struct xfs_scrub	*sc,
> > > +	struct xfs_bitmap	*old_allocbt_blocks,
> > > +	int			log_flags)
> > > +{
> > > +	int			error;
> > > +
> > > +	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, log_flags);
> > > +
> > > +	/* Invalidate the old freespace btree blocks and commit. */
> > > +	error = xrep_invalidate_blocks(sc, old_allocbt_blocks);
> > > +	if (error)
> > > +		return error;
> > 
> > It looks like the above invalidation all happens in the same
> > transaction. Those aren't logging buffer data or anything, but any idea
> > how many log formats we can get away with in this single transaction?
> 
> Hm... well, on my computer a log format is ~88 bytes.  Assuming 4K
> blocks, the max AG size of 1TB, maximum free space fragmentation, and
> two btrees, the tree could be up to ~270 million records.  Assuming ~505
> records per block, that's ... ~531,000 leaf blocks and ~1100 node blocks
> for both btrees.  If we invalidate both, that's ~46M of RAM?
> 

I was thinking more about transaction reservation than RAM. It may not
currently be an issue, but it might be worth putting something down in a
comment to note that this is a single transaction and we expect to not
have to invalidate more than N (ballpark) blocks in a single go,
whatever that value happens to be.

> > > +	error = xrep_roll_ag_trans(sc);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	/* Now that we've succeeded, mark the incore state valid again. */
> > > +	sc->sa.pag->pagf_init = 1;
> > > +	return 0;
> > > +}
> > > +
> > > +/* Build new free space btrees and dispose of the old one. */
> > > +STATIC int
> > > +xrep_abt_rebuild_trees(
> > > +	struct xfs_scrub	*sc,
> > > +	struct list_head	*free_extents,
> > > +	struct xfs_bitmap	*old_allocbt_blocks)
> > > +{
> > > +	struct xfs_owner_info	oinfo;
> > > +	struct xrep_abt_extent	*rae;
> > > +	struct xrep_abt_extent	*n;
> > > +	struct xrep_abt_extent	*longest;
> > > +	int			error;
> > > +
> > > +	xfs_rmap_skip_owner_update(&oinfo);
> > > +
> > > +	/*
> > > +	 * Insert the longest free extent in case it's necessary to
> > > +	 * refresh the AGFL with multiple blocks.  If there is no longest
> > > +	 * extent, we had exactly the free space we needed; we're done.
> > > +	 */
> > 
> > I'm confused by the last sentence. longest should only be NULL if the
> > free space list is empty and haven't we already bailed out with -ENOSPC
> > if that's the case?
> > 
> > > +	longest = xrep_abt_get_longest(free_extents);
> 
> xrep_abt_rebuild_trees is called after we allocate and initialize two
> new btree roots in xrep_abt_reset_btrees.  If free_extents is an empty
> list here, then we found exactly two blocks worth of free space and used
> them to set up new btree roots.
> 

Got it, thanks.

> > > +	if (!longest)
> > > +		goto done;
> > > +	error = xrep_abt_free_extent(sc,
> > > +			XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, longest->bno),
> > > +			longest->len, &oinfo);
> > > +	list_del(&longest->list);
> > > +	kmem_free(longest);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	/* Insert records into the new btrees. */
> > > +	list_for_each_entry_safe(rae, n, free_extents, list) {
> > > +		error = xrep_abt_free_extent(sc,
> > > +				XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, rae->bno),
> > > +				rae->len, &oinfo);
> > > +		if (error)
> > > +			return error;
> > > +		list_del(&rae->list);
> > > +		kmem_free(rae);
> > > +	}
> > 
> > Ok, at this point we've reset the btree roots and we start freeing the
> > free ranges that were discovered via the rmapbt analysis. AFAICT, if we
> > fail or crash at this point, we leave the allocbts in a partially
> > constructed state. I take it that is Ok with respect to the broader
> > repair algorithm because we'd essentially start over by inspecting the
> > rmapbt again on a retry.
> 
> Right.  Though in the crash/shutdown case, you'll end up with the
> filesystem in an offline state at some point before you can retry the
> scrub, it's probably faster to run xfs_repair to fix the damage.
> 

Can we really assume that if we're already up and running an online
repair? The filesystem has to be mountable in that case in the first
place. If we've already reset and started reconstructing the allocation
btrees then I'd think those transactions would recover just fine on a
power loss or something (perhaps not in the event of some other
corruption related shutdown).

> > The blocks allocated for the btrees that we've begun to construct here
> > end up mapped in the rmapbt as we go, right? IIUC, that means we don't
> > necessarily have infinite retries to make sure this completes. IOW,
> > suppose that a first repair attempt finds just enough free space to
> > construct new trees, gets far enough along to consume most of that free
> > space and then crashes. Is it possible that a subsequent repair attempt
> > includes the btree blocks allocated during the previous failed repair
> > attempt in the sum of "old btree blocks" and determines we don't have
> > enough free space to repair?
> 
> Yes, that's a risk of running the free space repair.
> 

Can we improve on that? For example, are the rmapbt entries for the old
allocation btree blocks necessary once we commit the btree resets? If
not, could we remove those entries before we start tree reconstruction?

Alternatively, could we incorporate use of the old btree blocks? As it
is, we discover those blocks simply so we can free them at the end.
Perhaps we could free them sooner or find a more clever means to
reallocate directly from that in-core list? I guess we have to consider
whether they were really valid/sane btree blocks, but either way ISTM
that the old blocks list is essentially invalidated once we reset the
btrees.

Brian

> > > +
> > > +done:
> > > +	/* Free all the OWN_AG blocks that are not in the rmapbt/agfl. */
> > > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> > > +	return xrep_reap_extents(sc, old_allocbt_blocks, &oinfo,
> > > +			XFS_AG_RESV_NONE);
> > > +}
> > > +
> > ...
> > > diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> > > index 0ed68379e551..82f99633a597 100644
> > > --- a/fs/xfs/xfs_extent_busy.c
> > > +++ b/fs/xfs/xfs_extent_busy.c
> > > @@ -657,3 +657,17 @@ xfs_extent_busy_ag_cmp(
> > >  		diff = b1->bno - b2->bno;
> > >  	return diff;
> > >  }
> > > +
> > > +/* Are there any busy extents in this AG? */
> > > +bool
> > > +xfs_extent_busy_list_empty(
> > > +	struct xfs_perag	*pag)
> > > +{
> > > +	spin_lock(&pag->pagb_lock);
> > > +	if (pag->pagb_tree.rb_node) {
> > 
> > RB_EMPTY_ROOT()?
> 
> Good suggestion, thank you!
> 
> --D
> 
> > Brian
> > 
> > > +		spin_unlock(&pag->pagb_lock);
> > > +		return false;
> > > +	}
> > > +	spin_unlock(&pag->pagb_lock);
> > > +	return true;
> > > +}
> > > diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> > > index 990ab3891971..2f8c73c712c6 100644
> > > --- a/fs/xfs/xfs_extent_busy.h
> > > +++ b/fs/xfs/xfs_extent_busy.h
> > > @@ -65,4 +65,6 @@ static inline void xfs_extent_busy_sort(struct list_head *list)
> > >  	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
> > >  }
> > >  
> > > +bool xfs_extent_busy_list_empty(struct xfs_perag *pag);
> > > +
> > >  #endif /* __XFS_EXTENT_BUSY_H__ */
> > > 
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
