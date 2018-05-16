Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57776 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeEPWFm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 18:05:42 -0400
Date: Wed, 16 May 2018 15:05:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/22] xfs: add helpers to collect and sift btree block
 pointers during repair
Message-ID: <20180516220537.GN23858@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642363794.1556.12771807615463619233.stgit@magnolia>
 <20180516075652.GR23861@dastard>
 <20180516180125.GI23858@magnolia>
 <20180516213237.GW23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516213237.GW23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 17, 2018 at 07:32:37AM +1000, Dave Chinner wrote:
> On Wed, May 16, 2018 at 11:01:27AM -0700, Darrick J. Wong wrote:
> > On Wed, May 16, 2018 at 05:56:52PM +1000, Dave Chinner wrote:
> > > On Tue, May 15, 2018 at 03:33:58PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Add some helpers to assemble a list of fs block extents.  Generally,
> > > > repair functions will iterate the rmapbt to make a list (1) of all
> > > > extents owned by the nominal owner of the metadata structure; then they
> > > > will iterate all other structures with the same rmap owner to make a
> > > > list (2) of active blocks; and finally we have a subtraction function to
> > > > subtract all the blocks in (2) from (1), with the result that (1) is now
> > > > a list of blocks that were owned by the old btree and must be disposed.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/scrub/repair.c |  207 +++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/scrub/repair.h |   31 +++++++
> > > >  2 files changed, 238 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > > > index 72f04a717150..8e8ecddd7537 100644
> > > > --- a/fs/xfs/scrub/repair.c
> > > > +++ b/fs/xfs/scrub/repair.c
> > > > @@ -361,3 +361,210 @@ xfs_repair_init_btblock(
> > > >  
> > > >  	return 0;
> > > >  }
> > > > +
> > > > +/* Collect a dead btree extent for later disposal. */
> > > > +int
> > > > +xfs_repair_collect_btree_extent(
> > > > +	struct xfs_scrub_context	*sc,
> > > > +	struct xfs_repair_extent_list	*exlist,
> > > > +	xfs_fsblock_t			fsbno,
> > > > +	xfs_extlen_t			len)
> > > > +{
> > > > +	struct xfs_repair_extent	*rex;
> > > > +
> > > > +	trace_xfs_repair_collect_btree_extent(sc->mp,
> > > > +			XFS_FSB_TO_AGNO(sc->mp, fsbno),
> > > > +			XFS_FSB_TO_AGBNO(sc->mp, fsbno), len);
> > > > +
> > > > +	rex = kmem_alloc(sizeof(struct xfs_repair_extent), KM_MAYFAIL);
> > > > +	if (!rex)
> > > > +		return -ENOMEM;
> > > 
> > > Is this in transaction context?
> > 
> > Yes.  After the setup function finishes we're required to own a
> > transaction and hold a lock on whatever resource we're playing with.
> > 
> > > Regardless, I think we need to run the entire of scrub/repair in a
> > > memalloc_nofs_save() context so we don't have memory reclaim recursion
> > > issues...
> > 
> > xfs_trans_reserve should take care of this, right?  So we don't have to
> > feed KM_NOFS to kmem_*_alloc because this is already taken care of.  The
> > MAYFAIL exists because we prefer ENOMEM'ing out to pushing on reclaim.
> 
> Right, if we have an active transaction we are under NOFS allocation
> conditions. I'm jus tnot sure how much of scrub/repair is covered by
> the transaction context (too early in the morning to go code
> spelunking!).

Everything that runs between ->setup and xfs_scrub_teardown is covered
by transaction context.

> w.r.t reclaim, NOFS allocations will still push on reclaim - NOFS
> just means it won't push on any dirty file pages or scan/reclaim
> filesystem caches.

Noted.  I was assuming that NOFS|NOIO meant it would only try reclaim in
other parts of the kernel, it sounds like we're ok here.

> > > > +	while (lp != &exlist->list) {
> > > > +		ex = list_entry(lp, struct xfs_repair_extent, list);
> > > > +
> > > > +		/*
> > > > +		 * Advance subex and/or ex until we find a pair that
> > > > +		 * intersect or we run out of extents.
> > > > +		 */
> > > > +		while (subex->fsbno + subex->len <= ex->fsbno) {
> > > > +			if (list_is_last(&subex->list, &sublist->list))
> > > > +				goto out;
> > > > +			subex = list_next_entry(subex, list);
> > > > +		}
> > > 
> > > So this is a O(n^2) algorithm, right? How does it scale with large
> > > extent lists?
> > 
> > I don't think this is O(n^2) -- each list sort is O(n log n).
> 
> I'm not worried about the list sort. :)
> 
> > Then we
> > iterate exlist once, rolling forward through sublist as necessary.  We
> > never reset lp to the head of exlist nor do we reset subex to the head
> > of sublist.  We're not performing random lookups on the sublist extents
> > at all.
> 
> Ah, I missed the fact the loop doesn't reset the subex list to the
> start for each ex entry. Perhaps a better comment explaining the way
> the algorithm steps through both lists?

Ok:

/*
 * Now that we've sorted both lists, we iterate exlist once, rolling
 * forward through sublist and/or exlist as necessary until we find an
 * overlap or reach the end of either list.  We do not reset lp to the
 * head of exlist nor do we reset subex to the head of sublist.  The
 * list traversal is similar to merge sort, but we're deleting instead.
 * In this manner we avoid O(n^2) operations.
 */

> > So far I haven't noticed /much/ heat from this routine even with
> > deliberately aged filesystems, but that's probably due to the slab
> > allocator eating way more time. :(
> 
> Perhaps it is worth looking at using named slab caches for some of
> these objects to take some heat off of the heap slabs?

Early versions of repair actually did that to try to avoid fragmenting
the power-of-2 slabs by using named slab caches, but slub emits udev
events whenever a named slab is created, and the resulting horrible
cacophony of udev rule processing ate an entire CPU core and uncovered
deadlocks in the parts of the slab management code that manage
/sys/kernel/slab.  That code /really/ does not like you creating and
removing slabs concurrently.

As part of re-evaluating how orepair stores in-core records I will take
another pass at reducing the efficiency problems.

--D

> > > Given that these extents are dynamically allocated, and we're already
> > > burning 16 bytes for a list head on each extent, would it be better to
> > > use a smarter structure better suited for exact lookups? e.g. an
> > > rbtree only takes an extra 8 bytes per extent, and we get O(log N)
> > > searches on the inner loop here...
> > > 
> > > I guess this isn't necessary to fix right now, but I think it's
> > > going to be an issue for maybe mark this down as "needing to be
> > > fixed before removing EXPERIMENTAL tags"?
> > 
> > I've thought about converting this to an rbtree or something, since
> > these are basically glorified bitmap operations.
> 
> You can probably ignore that because I was thinking it was a full
> subex list search for each ex, which is not the case...
> >
> > TBH the other thing that irks me about the current orepair design is its
> > heavy reliance on creating potentially huge linked lists of the records
> > that need to be put into the new structure.  I'd really like a data
> > structure where I can do fast unsorted appends without list overhead,
> > sort the data structure once, and then insert in sorted order.  The slab
> > thing I put into xfs_repair provides this, but we can't easily allocate
> > 128M of space in the kernel.  I also want to do a bulk load of an empty
> > a btree leaf so that we log the leaf block once and update the node
> > pointers once, kind of like what xfs_repair does during phase 5.
> > 
> > ...all this optimization can come after merging.
> 
> *nod*.
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
