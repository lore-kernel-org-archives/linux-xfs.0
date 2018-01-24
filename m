Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36976 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964999AbeAXTOc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jan 2018 14:14:32 -0500
Date: Wed, 24 Jan 2018 11:14:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/11] xfs: CoW fork operations should only update quota
 reservations
Message-ID: <20180124191425.GA9068@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676030319.12349.11227408793644481553.stgit@magnolia>
 <20180124142215.GD37554@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180124142215.GD37554@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 24, 2018 at 09:22:16AM -0500, Brian Foster wrote:
> On Tue, Jan 23, 2018 at 06:18:23PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Since the CoW fork only exists in memory, it is incorrect to update the
> > on-disk quota block counts when we modify the CoW fork.  Unlike the data
> > fork, even real extents in the CoW fork are only reservations (on-disk
> > they're owned by the refcountbt) so they must not be tracked in the on
> > disk quota info.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c |  203 ++++++++++++++++++++++++++++++++++++++++++++--
> >  fs/xfs/xfs_reflink.c     |    8 +-
> >  2 files changed, 196 insertions(+), 15 deletions(-)
> > 
> > 
> 
> Mostly comments on the comment so far... I still have to grok the code,
> but working through to this point made my brain hurt a bit so I'm
> sending what I have so far. ;P

Grokking all the pieces (especially the quota handling stuff) made my
brain hurt too.

> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 6e6f3cb..e3e8f7c 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -52,6 +52,145 @@
> >  #include "xfs_refcount.h"
> >  #include "xfs_icache.h"
> >  
> > +/*
> > + * Data/Attr Fork Mapping Lifecycle
> > + *
> > + * The data fork contains the block mappings between logical blocks in a file
> > + * and physical blocks on the disk.  The XFS notions of delayed allocation
> > + * reservations, unwritten extents, and real extents follow well known
> > + * conventions in the filesystem world.
> > + *
> > + * As a side note, the attribute fork does the same for extended attribute
> > + * blocks, though the logical block offsets are not available to userspace and
> > + * the only valid states are HOLE and REAL.
> > + *
> > + * Metadata involved outside of the block mapping itself are as follows:
> > + *
> > + * - i_delayed_blks: Number of blocks that are reserved for delayed allocation.
> > + * - i_cow_blocks: Number of blocks reserved for copy on write staging.
> > + *
> 
> I know it's implied by some of the field names, but I think it would be
> useful to point out what data structures these are associated with.
> Also, i_cow_blocks technically doesn't exist yet.. right?

Yeah, it's added by the next patch, I was being lazy and putting the
comment ahead of the next commit rather than rewriting the block comment
in subsequent patches.

> > + * - di_nblocks: Number of blocks (on-disk) assigned to the inode.
> > + *
> 
> Hmm, some of these are self-explanatory or already documented where they
> are defined. I'm wondering if we really need to repeat descriptions for
> all of these (as opposed to ensuring they are all sufficiently described
> where they are defined). That also saves us from having to keep field
> names and whatnot synced up in an unexpected source location.
> 
> > + * - d_bcount: Number of quota blocks accounted for by on-disk metadata.
> > + * - q_res_bcount: Number of quota blocks reserved in-core for future writes +
> > + *           blocks mentioned by on-disk metadata.
> > + *
> > + * - qt_blk_res: Number of quota blocks reserved in-core for this transaction.
> > + *           Unused reservation is given back to q_res_bcount on commit.
> > + * - qt_bcount: Number of quota blocks used by this transaction from
> > + *           qt_blk_res.  d_bcount is increased by this on commit.
> > + * - qt_delbcount: Number of quota blocks used by this transaction from
> > + *           q_res_bcount but not q_res_bcount.  d_bcount is increased by this
> > + *           on commit.
> > + *
> 
> "from q_res_bcount but not q_res_bcount" ?

"...from q_res_bcount but not qt_blk_res."

> Also: qt_bcount_delta, qt_delbcount_delta?

Oops, yes, those names should have _delta after them.

> > + * - sb_fdblocks: Number of free blocks recorded in the superblock on disk.
> > + * - fdblocks: Number of free blocks recorded in the superblock minus any
> > + *           in-core reservations made in anticipation of future writes.
> > + *
> > + * - t_blk_res: Number of blocks reserved out of fdblocks for a transaction.
> > + *           When the transaction commits, t_blk_res - t_blk_res_used is given
> > + *           back to fdblocks.
> > + * - t_blk_res_used: Number of blocks used by this transaction that were
> > + *           reserved for this transaction.
> > + * - t_fdblocks_del: Number of blocks by which fdblocks and sb_fdblocks will
> > + *           have to decrease at commit.
> > + * - t_res_fdblocks_delta: Number of blocks by which sb_fdblocks will have to
> > + *           decrease at commit.  We assume that fdblocks was decreased
> > + *           prior to the transaction.
> > + *
> > + * Data fork block mappings have four logical states:
> > + *
> > + *    +--------> UNWRITTEN <------+
> > + *    |              ^            |
> > + *    |              v            v
> > + * DELALLOC <----> HOLE <------> REAL
> > + *    |                           ^
> > + *    |                           |
> > + *    +---------------------------+
> > + *
> 
> I'm not sure we need a graphic for the extent states. Non-hole
> conversions to delalloc is the only transition that doesn't make any
> sense.

First of all, Dave keeps asking for ASCII art 'when appropriate'. :)

But on a more serious note, I thought the state diagram would be useful
for anyone who isn't so familiar with how blocks get mapped into files
in xfs, particularly to compare the data fork diagram against the
corresponding picture for the cow fork.

> > + * The state transitions and required metadata updates are as follows:
> > + *
> > + * - HOLE to DELALLOC: Increase i_delayed_blks and q_res_bcount, and decrease
> > + *           fdblocks.
> > + * - HOLE to REAL: Increase di_nblocks and qt_bcount, and decrease fdblocks.
> > + * - HOLE to UNWRITTEN: Same as above.
> > + *
> > + * - DELALLOC to UNWRITTEN: Increase di_nblocks and qt_delbcount, and decrease
> > + *           i_delayed_blks.
> > + * - DELALLOC to REAL: Same as above.
> > + * - DELALLOC to HOLE: Increase fdblocks, and decrease i_delayed_blks and
> > + *           q_res_bcount.
> > + *
> > + * - UNWRITTEN to HOLE: Decrease di_nblocks and q_bcount, and increase fdblocks.
> > + * - UNWRITTEN to REAL: No change.
> > + *
> > + * - REAL to UNWRITTEN: No change.
> > + * - REAL to HOLE: Decrease di_nblocks and q_bcount, and increase fdblocks.
> > + *
> > + * Note in particular that delalloc reservations have "transaction-less"
> > + * quota reservations via q_res_bcount.  If the reservation is allocated,
> > + * qt_delbcount is used to increment d_bcount without touching q_res_bcount.
> > + * Filling a hole with an allocated extent, by contrast, uses qt_blk_res
> > + * to make a reservation in q_res_bcount, qt_bcount to record the number
> > + * of allocated blocks; at commit qt_bcount is added to d_bcount and
> > + * qt_blk_res - qt_bcount is added back to q_res_bcount.
> > + *
> 
> While I agree with the intent/usefulness of a big comment around how the
> quota accounting works, this all kind of reads like a braindump so far.

Guilty as charged!  This /is/ pulled straight from my notes. :/

> E.g., this state changes these fields, this field represents how much to
> change some other field, etc. While I'm sure that is useful information
> to work out the problem being resolved here, it doesn't explain much how
> everything works. IOW, I still feel like I need to go trace through the
> code to understand the comment, as opposed to the comment helping me
> trace through the code.
> 
> I think it would be better to have a high level description about how
> the quota accounting works with respect to the transaction/extent
> states, what high-level data structures are involved and how they
> relate, etc., rather than what seems essentially to be a chart that maps
> states to fields. 

Hm, ok.  I'll work on that for the next revision.

> I'm also wondering how much of the whole picture really needs to be
> described here to cover quota accounting with respect to block mapping
> (sufficiently to differentiate data fork from cow fork, which I take is
> the purpose of this section). For example, do we really need the
> internal transaction details for how quota deltas are carried?
> 
> Instead, I think it might be sufficient to explain that the quota system
> works in two "levels" (for lack of a better term :/), one for
> reservation and another for real block usage. The reservation is
> associated with transaction reservation and/or delayed block allocation
> (no tx). In either case, quota reservation is converted to real quota
> block usage when a transaction commits that maps real/physical blocks.
> If the transaction held extra reservation that went unused, that quota
> reservation is released. The primary difference is that transactions to
> convert delalloc -> real do not reserve quota blocks in the first place,
> since that has already occurred, so they just need to make sure to
> convert/persist the quota res for the blocks that were converted to
> real.

I thought about cutting this whole comment down to a simple sentence
about how quota accounting is different between the data & cow forks (as
you figured out, we use delalloc quota reservations for everything in
the cow fork and only turn them into real ones when we go to remap) but
then worried that doing so would presuppose the reader knew anything
about how the extent lifecycles work... and that's how I end up with a
gigantic manual.

> > + * Copy on Write Fork Mapping Lifecycle
> > + *
> > + * The CoW fork handles things differently from the data fork because its
> > + * mappings only exist in memory-- the refcount btree is the on-disk owner of
> > + * the extents until they're remapped into the data fork.  Therefore,
> > + * unwritten and real extents in the CoW fork are treated the same way as
> > + * delayed allocation extents.  Quota and fdblock changes only exist in
> > + * memory, which requires some twists in the bmap functions.
> > + *
> 
> Ok, but perhaps this should point out what happens when cow blocks are
> reserved with respect to quotas..? IIUC, a delalloc quota reservation
> occurs just the same as above, the blocks simply reside in another fork.

Yes.

> > + * The CoW fork extent state diagram looks like this:
> > + *
> > + *    +--------> UNWRITTEN -------+
> > + *    |              ^            |
> > + *    |              v            v
> > + * DELALLOC <----> HOLE <------- REAL
> > + *
> > + * Holes are still holes.  Delayed allocation extents reserve blocks for
> > + * landing future writes, just like they do in the data fork.  However, unlike
> > + * the data fork, unwritten extents signal an extent that has been allocated
> > + * but is not currently undergoing writeback.  Real extents are undergoing
> > + * writeback, and when that writeback finishes the corresponding data fork
> > + * extent will be punched out and the CoW fork counterpart moved to the new
> > + * hole in the data fork.
> > + *
> 
> Ok, so the difference is that for the COW fork, the _extent state_
> conversion is not the appropriate trigger event to convert quota
> reservation to real quota usage. Instead, the blocks being remapped from
> the COW fork to the data fork is when that should occur.

Yes.

> > + * The state transitions and required metadata updates are as follows:
> > + *
> > + * - HOLE to DELALLOC: Increase i_cow_blocks and q_res_bcount, and decrease
> > + *           fdblocks.
> > + * - HOLE to UNWRITTEN: Same as above, but since we reserved quota via
> > + *           qt_blk_res (which increased q_res_bcount) when we allocate the
> > + *           extent we have to decrease qt_blk_res so that the commit doesn't
> > + *           give the allocated CoW blocks back.
> > + *
> 
> Hmm, this is a little confusing. Looking at the code change and comment
> below, I think I get what this is trying to do, which is essentially
> make a real block cow fork alloc behave like a delalloc reservation
> (with respect to quota). FWIW, I think what confuses me is the assertion
> that the blocks would be "given back" otherwise. The only reference I
> have to compare is data fork alloc behavior, which implies that used
> reservation would not be given back, but rather converted to real quota
> usage on block allocation (and excess reservation would still be given
> back, which afaict we still want to happen). So the trickery is required
> to prevent conversion of quota reservation for the allocated cow blocks,
> let that res sit around until the cow blocks are remapped, and release
> unused reservation from the tx as normal. Am I following that correctly?

Yes.

> > + * - DELALLOC to UNWRITTEN: No change.
> > + * - DELALLOC to HOLE: Decrease i_cow_blocks and q_res_bcount, and increase
> > + *           fdblocks.
> > + *
> > + * - UNWRITTEN to HOLE: Same as DELALLOC to HOLE.
> > + * - UNWRITTEN to REAL: No change.
> > + *
> > + * - REAL to HOLE: This transition happens when we've finished a write
> > + *           operation and need to move the mapping to the data fork.  We
> > + *           punch the correspond data fork mappings, which decreases
> > + *           qt_bcount.  Then we map the CoW fork mapping into the hole we
> > + *           just cleared out of the data fork, which increases qt_bcount.
> > + *           There's a subtlety here -- if we promoted a write over a hole to
> > + *           CoW, there will be a net increase in qt_bcount, which is fine
> > + *           because we already reserved the quota when we filled the CoW
> > + *           fork.  Finally, we punch the CoW fork mapping, which decreases
> > + *           q_res_bcount.
> > + *
> > + * Notice how all CoW fork extents use transactionless quota reservations and
> > + * the in-core fdblocks to maintain state, and we avoid updating any on-disk
> > + * metadata.  This is essential to maintain metadata correctness if the system
> > + * goes down.
> > + */
> >  
> >  kmem_zone_t		*xfs_bmap_free_item_zone;
> >  
> > @@ -3337,6 +3476,39 @@ xfs_bmap_btalloc_filestreams(
> >  	return 0;
> >  }
> >  
> > +/* Deal with CoW fork accounting when we allocate a block. */
> > +static void
> > +xfs_bmap_btalloc_cow(
> > +	struct xfs_bmalloca	*ap,
> > +	struct xfs_alloc_arg	*args)
> > +{
> > +	/* Filling a previously reserved extent; nothing to do here. */
> > +	if (ap->wasdel)
> > +		return;
> > +
> > +	/*
> > +	 * The CoW fork only exists in memory, so the on-disk quota accounting
> > +	 * must not incude any CoW fork extents.  Therefore, CoW blocks are
> > +	 * only tracked in the in-core dquot block count (q_res_bcount).
> > +	 *
> > +	 * If we get here, we're filling a CoW hole with a real (non-delalloc)
> > +	 * CoW extent having reserved enough blocks from both q_res_bcount and
> > +	 * qt_blk_res to guarantee that we won't run out of space.  The unused
> > +	 * qt_blk_res is given back to q_res_bcount when the transaction
> > +	 * commits.
> > +	 *
> > +	 * We don't want the quota accounting for our newly allocated blocks
> > +	 * to be given back, so we must decrease qt_blk_res without decreasing
> > +	 * q_res_bcount.
> > +	 *
> > +	 * Note: If we're allocating a delalloc extent, we already reserved
> > +	 * the q_res_bcount blocks, so no quota accounting update is needed
> > +	 * here.
> > +	 */
> > +	xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
> > +			-(long)args->len);
> > +}
> 
> Factoring nit.. if we're going to refactor bits of xfs_bmap_btalloc()
> out, it might be cleaner to factor out all of the quota logic rather
> than just the cow bits (which is basically just a simple check and
> function call). E.g., refactor into an xfs_bmap_btalloc_quota() helper
> that does the right thing based on the fork, with comments as to why,
> etc. (and perhaps just leave the unrelated di_nblocks change behind).

I thought about factoring the data/attr fork stuff into its own
xfs_bmap_btalloc_quota() function too, since this function is already
eyewateringly long.  I think I'll do that as a separate refactor at the
end of the series, though...

--D

> Brian
> 
> > +
> >  STATIC int
> >  xfs_bmap_btalloc(
> >  	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> > @@ -3571,19 +3743,22 @@ xfs_bmap_btalloc(
> >  			*ap->firstblock = args.fsbno;
> >  		ASSERT(nullfb || fb_agno <= args.agno);
> >  		ap->length = args.len;
> > -		if (!(ap->flags & XFS_BMAPI_COWFORK))
> > -			ap->ip->i_d.di_nblocks += args.len;
> > -		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
> >  		if (ap->wasdel)
> >  			ap->ip->i_delayed_blks -= args.len;
> > -		/*
> > -		 * Adjust the disk quota also. This was reserved
> > -		 * earlier.
> > -		 */
> > -		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
> > -			ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT :
> > -					XFS_TRANS_DQ_BCOUNT,
> > -			(long) args.len);
> > +		if (ap->flags & XFS_BMAPI_COWFORK) {
> > +			xfs_bmap_btalloc_cow(ap, &args);
> > +		} else {
> > +			ap->ip->i_d.di_nblocks += args.len;
> > +			xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
> > +			/*
> > +			 * Adjust the disk quota also. This was reserved
> > +			 * earlier.
> > +			 */
> > +			xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
> > +				ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT :
> > +						XFS_TRANS_DQ_BCOUNT,
> > +				(long) args.len);
> > +		}
> >  	} else {
> >  		ap->blkno = NULLFSBLOCK;
> >  		ap->length = 0;
> > @@ -4776,6 +4951,7 @@ xfs_bmap_del_extent_cow(
> >  	struct xfs_bmbt_irec	new;
> >  	xfs_fileoff_t		del_endoff, got_endoff;
> >  	int			state = BMAP_COWFORK;
> > +	int			error;
> >  
> >  	XFS_STATS_INC(mp, xs_del_exlist);
> >  
> > @@ -4832,6 +5008,11 @@ xfs_bmap_del_extent_cow(
> >  		xfs_iext_insert(ip, icur, &new, state);
> >  		break;
> >  	}
> > +
> > +	/* Remove the quota reservation */
> > +	error = xfs_trans_reserve_quota_nblks(NULL, ip,
> > +			-(long)del->br_blockcount, 0, XFS_QMOPT_RES_REGBLKS);
> > +	ASSERT(error == 0);
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 82abff6..e367351 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -599,10 +599,6 @@ xfs_reflink_cancel_cow_blocks(
> >  					del.br_startblock, del.br_blockcount,
> >  					NULL);
> >  
> > -			/* Update quota accounting */
> > -			xfs_trans_mod_dquot_byino(*tpp, ip, XFS_TRANS_DQ_BCOUNT,
> > -					-(long)del.br_blockcount);
> > -
> >  			/* Roll the transaction */
> >  			xfs_defer_ijoin(&dfops, ip);
> >  			error = xfs_defer_finish(tpp, &dfops);
> > @@ -795,6 +791,10 @@ xfs_reflink_end_cow(
> >  		if (error)
> >  			goto out_defer;
> >  
> > +		/* Charge this new data fork mapping to the on-disk quota. */
> > +		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
> > +				(long)del.br_blockcount);
> > +
> >  		/* Remove the mapping from the CoW fork. */
> >  		xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
