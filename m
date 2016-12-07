Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750953AbcLGLx0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 06:53:26 -0500
Date: Wed, 7 Dec 2016 06:53:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 48/63] xfs: preallocate blocks for worst-case btree
 expansion
Message-ID: <20161207115323.GA23106@bfoster.bfoster>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520505244.29434.3772387185608259922.stgit@birch.djwong.org>
 <20161012184450.GE56019@bfoster.bfoster>
 <20161012205257.GJ22379@birch.djwong.org>
 <20161012224236.GA5104@bfoster.bfoster>
 <20161206193229.GF8436@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161206193229.GF8436@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Tue, Dec 06, 2016 at 11:32:29AM -0800, Darrick J. Wong wrote:
> On Wed, Oct 12, 2016 at 06:42:36PM -0400, Brian Foster wrote:
> > On Wed, Oct 12, 2016 at 01:52:57PM -0700, Darrick J. Wong wrote:
> > > On Wed, Oct 12, 2016 at 02:44:51PM -0400, Brian Foster wrote:
> > > > On Thu, Sep 29, 2016 at 08:10:52PM -0700, Darrick J. Wong wrote:
> > > > > To gracefully handle the situation where a CoW operation turns a
> > > > > single refcount extent into a lot of tiny ones and then run out of
> > > > > space when a tree split has to happen, use the per-AG reserved block
> > > > > pool to pre-allocate all the space we'll ever need for a maximal
> > > > > btree.  For a 4K block size, this only costs an overhead of 0.3% of
> > > > > available disk space.
> > > > > 
> > > > > When reflink is enabled, we have an unfortunate problem with rmap --
> > > > > since we can share a block billions of times, this means that the
> > > > > reverse mapping btree can expand basically infinitely.  When an AG is
> > > > > so full that there are no free blocks with which to expand the rmapbt,
> > > > > the filesystem will shut down hard.
> > > > > 
> > > > > This is rather annoying to the user, so use the AG reservation code to
> > > > > reserve a "reasonable" amount of space for rmap.  We'll prevent
> > > > > reflinks and CoW operations if we think we're getting close to
> > > > > exhausting an AG's free space rather than shutting down, but this
> > > > > permanent reservation should be enough for "most" users.  Hopefully.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > [hch@lst.de: ensure that we invalidate the freed btree buffer]
> > > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > > ---
> > > > > v2: Simplify the return value from xfs_perag_pool_free_block to a bool
> > > > > so that we can easily call xfs_trans_binval for both the per-AG pool
> > > > > and the real freeing case.  Without this we fail to invalidate the
> > > > > btree buffer and will trip over the write verifier on a shrinking
> > > > > refcount btree.
> > > > > 
> > > > > v3: Convert to the new per-AG reservation code.
> > > > > 
> > > > > v4: Combine this patch with the one that adds the rmapbt reservation,
> > > > > since the rmapbt reservation is only needed for reflink filesystems.
> > > > > 
> > > > > v5: If we detect errors while counting the refcount or rmap btrees,
> > > > > shut down the filesystem to avoid the scenario where the fs shuts down
> > > > > mid-transaction due to btree corruption, repair refuses to run until
> > > > > the log is clean, and the log cannot be cleaned because replay hits
> > > > > btree corruption and shuts down.
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_ag_resv.c        |   11 ++++++
> > > > >  fs/xfs/libxfs/xfs_refcount_btree.c |   45 ++++++++++++++++++++++++-
> > > > >  fs/xfs/libxfs/xfs_refcount_btree.h |    3 ++
> > > > >  fs/xfs/libxfs/xfs_rmap_btree.c     |   60 ++++++++++++++++++++++++++++++++++
> > > > >  fs/xfs/libxfs/xfs_rmap_btree.h     |    7 ++++
> > > > >  fs/xfs/xfs_fsops.c                 |   64 ++++++++++++++++++++++++++++++++++++
> > > > >  fs/xfs/xfs_fsops.h                 |    3 ++
> > > > >  fs/xfs/xfs_mount.c                 |    8 +++++
> > > > >  fs/xfs/xfs_super.c                 |   12 +++++++
> > > > >  9 files changed, 210 insertions(+), 3 deletions(-)
> > > > > 
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> > > > > index e3ae0f2..adf770f 100644
> > > > > --- a/fs/xfs/libxfs/xfs_ag_resv.c
> > > > > +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> > > > > @@ -38,6 +38,7 @@
> > > > >  #include "xfs_trans_space.h"
> > > > >  #include "xfs_rmap_btree.h"
> > > > >  #include "xfs_btree.h"
> > > > > +#include "xfs_refcount_btree.h"
> > > > >  
> > > > >  /*
> > > > >   * Per-AG Block Reservations
> > > > > @@ -228,6 +229,11 @@ xfs_ag_resv_init(
> > > > >  	if (pag->pag_meta_resv.ar_asked == 0) {
> > > > >  		ask = used = 0;
> > > > >  
> > > > > +		error = xfs_refcountbt_calc_reserves(pag->pag_mount,
> > > > > +				pag->pag_agno, &ask, &used);
> > > > > +		if (error)
> > > > > +			goto out;
> > > > > +
> > > > >  		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_METADATA,
> > > > >  				ask, used);
> > > > 
> > > > Now that I get here, I see we have these per-ag reservation structures
> > > > and whatnot, but __xfs_ag_resv_init() (from a previous patch) calls
> > > > xfs_mod_fdblocks() for the reservation. AFAICT, that reserves from the
> > > > "global pool." Based on the commit log, isn't the intent here to reserve
> > > > blocks within each AG? What am I missing?
> > > 
> > > The AG reservation code "reserves" blocks in each AG by hiding them from
> > > the allocator.  They're all still there in the bnobt, but we underreport
> > > the length of the longest free extent and the free block count in that
> > > AG to make it look like there's less free space than there is.  Since
> > > those blocks are no longer generally available, we have to decrease the
> > > in-core free block count so we can't create delalloc reservations that
> > > the allocator won't (or can't) satisfy.
> > > 
> > 
> > Yep, I think I get the idea/purpose in principle. It sounds similar to
> > global reserve pool, where we set aside a count of unallocated blocks
> > via accounting magic such that we have some available in cases such as
> > the need to allocate a block to free an extent in low free space
> > conditions.
> 
> Correct.
> 
> > In this case, it looks like we reserve blocks in the same manner (via
> > xfs_mod_fdblocks()) and record the reservation in a new per-ag
> > reservation structure. The part I'm missing is how we guarantee those
> > blocks are accessible in the particular AG (or am I entirely mistaken
> > about the requirement that the per-AG reservation must reside within
> > that specific AG?).
> 
> You're correct there too.
> 
> > An example might clarify where my confusion lies... suppose we have a
> > non-standard configuration with a 1TB ag size and just barely enough
> > total filesystem size for a second AG, e.g., we have two AGs where AG 0
> > is 1TB and AG 1 is 16MB. Suppose that the reservation requirement (for
> > the sake of example, at least) based on sb_agblocks is larger than the
> > entire size of AG 1. Yet, the xfs_mod_fdblocks() call for the AG 1 res
> > struct will apparently succeed because there are plenty of blocks in
> > mp->m_fdblocks. Unless I'm mistaken, shouldn't we not be able to reserve
> > this many blocks out of AG 1?
> 
> You're right, that is a bug.  We /ought/ to be calculating the
> reservation ask based on agf_length, not sb_agblocks.  I'll also have to
> fix growfs to change the reservation if the length of the last AG
> changes.
> 

Yep, makes sense.

IMO it would also be nice to see some kind of assertion at reservation
time that the AG can honor the reservation at the time it is made, since
IIUC that should always be enforced to be true (whether that be DEBUG
code or a simple warning or whatever... just a thought).

> > Even in the case where AG 1 is large enough for the reservation, what
> > actually prevents a sequence of single block allocations from using all
> > of the space in the AG? 
> 
> AFAICT, the allocator picks an AG and tries to fix the freelist before
> allocating blocks.  As part of ensuring the AGFL, we call
> xfs_alloc_space_available to decide if there's enough space in the AG
> both to satisfy the allocation request and to fix the freelist.
> 
> _a_s_a starts by determining the number of blocks that have to stay
> reserved in that AG for the given allocation type.  Then it calls
> xfs_alloc_longest_free_extent to find the longest free extent in the AG.
> 
> _a_l_f_e finds the longest extent and subtracts whatever part of the AG
> reservation it can't satisfy out of the non-longest free extents.
> 
> Upon returning from _a_l_f_e, _a_s_a rejects the allocation if the
> longest extent cannot satisfy the required minimum allocation with the
> given alignment constraints.
> 
> Next it calculates the space that would remain after the allocation,
> which is:
> 
> (free space + agfl blocks) - (ag reservation) - (minimum agfl length) -
>      (total blocks requested)
> 

Ah, Ok. I think I missed that this calculation was tweaked, I'm guessing
because that doesn't appear to have been changed in this patch (granted
this is an old series). Thus I didn't see how the reservation was
ultimately enforced on a particular AG. Makes sense now, thanks for the
explanation!

Brian

> If this quantity is less than zero (or less than args->minleft) then the
> allocation is also rejected.  I believe this should be sufficient to
> prevent a series of single block alloc requests from exhausting the AG
> since we're stopped from giving away reserved blocks that we're not
> entitled to, even if there are still records in the bnobt.
> 
> --D
> 
> > 
> > Brian
> > 
> > > Maybe a more concrete way to put that is: say we have 4 AGs with 4 agresv
> > > blocks each, and no other free space left anywhere.  The in-core fdblocks count
> > > should be 0 so that starting a write into a hole returns ENOSPC even if the
> > > write could be done without any btree shape changes.   Otherwise, writepages
> > > tries to allocate the delalloc reservation, fails to find any space because
> > > we've hidden it, and kaboom.
> > > 
> > > --D
> > > 
> > > > 
> > > > Brian
> > > > 
> > > > >  		if (error)
> > > > > @@ -238,6 +244,11 @@ xfs_ag_resv_init(
> > > > >  	if (pag->pag_agfl_resv.ar_asked == 0) {
> > > > >  		ask = used = 0;
> > > > >  
> > > > > +		error = xfs_rmapbt_calc_reserves(pag->pag_mount, pag->pag_agno,
> > > > > +				&ask, &used);
> > > > > +		if (error)
> > > > > +			goto out;
> > > > > +
> > > > >  		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_AGFL, ask, used);
> > > > >  		if (error)
> > > > >  			goto out;
> > > > > diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> > > > > index 6b5e82b9..453bb27 100644
> > > > > --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> > > > > +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> > > > > @@ -79,6 +79,8 @@ xfs_refcountbt_alloc_block(
> > > > >  	struct xfs_alloc_arg	args;		/* block allocation args */
> > > > >  	int			error;		/* error return value */
> > > > >  
> > > > > +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > > > > +
> > > > >  	memset(&args, 0, sizeof(args));
> > > > >  	args.tp = cur->bc_tp;
> > > > >  	args.mp = cur->bc_mp;
> > > > > @@ -88,6 +90,7 @@ xfs_refcountbt_alloc_block(
> > > > >  	args.firstblock = args.fsbno;
> > > > >  	xfs_rmap_ag_owner(&args.oinfo, XFS_RMAP_OWN_REFC);
> > > > >  	args.minlen = args.maxlen = args.prod = 1;
> > > > > +	args.resv = XFS_AG_RESV_METADATA;
> > > > >  
> > > > >  	error = xfs_alloc_vextent(&args);
> > > > >  	if (error)
> > > > > @@ -125,16 +128,19 @@ xfs_refcountbt_free_block(
> > > > >  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> > > > >  	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
> > > > >  	struct xfs_owner_info	oinfo;
> > > > > +	int			error;
> > > > >  
> > > > >  	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_private.a.agno,
> > > > >  			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
> > > > >  	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
> > > > >  	be32_add_cpu(&agf->agf_refcount_blocks, -1);
> > > > >  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
> > > > > -	xfs_bmap_add_free(mp, cur->bc_private.a.dfops, fsbno, 1,
> > > > > -			&oinfo);
> > > > > +	error = xfs_free_extent(cur->bc_tp, fsbno, 1, &oinfo,
> > > > > +			XFS_AG_RESV_METADATA);
> > > > > +	if (error)
> > > > > +		return error;
> > > > >  
> > > > > -	return 0;
> > > > > +	return error;
> > > > >  }
> > > > >  
> > > > >  STATIC int
> > > > > @@ -410,3 +416,36 @@ xfs_refcountbt_max_size(
> > > > >  
> > > > >  	return xfs_refcountbt_calc_size(mp, mp->m_sb.sb_agblocks);
> > > > >  }
> > > > > +
> > > > > +/*
> > > > > + * Figure out how many blocks to reserve and how many are used by this btree.
> > > > > + */
> > > > > +int
> > > > > +xfs_refcountbt_calc_reserves(
> > > > > +	struct xfs_mount	*mp,
> > > > > +	xfs_agnumber_t		agno,
> > > > > +	xfs_extlen_t		*ask,
> > > > > +	xfs_extlen_t		*used)
> > > > > +{
> > > > > +	struct xfs_buf		*agbp;
> > > > > +	struct xfs_agf		*agf;
> > > > > +	xfs_extlen_t		tree_len;
> > > > > +	int			error;
> > > > > +
> > > > > +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> > > > > +		return 0;
> > > > > +
> > > > > +	*ask += xfs_refcountbt_max_size(mp);
> > > > > +
> > > > > +	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
> > > > > +	if (error)
> > > > > +		return error;
> > > > > +
> > > > > +	agf = XFS_BUF_TO_AGF(agbp);
> > > > > +	tree_len = be32_to_cpu(agf->agf_refcount_blocks);
> > > > > +	xfs_buf_relse(agbp);
> > > > > +
> > > > > +	*used += tree_len;
> > > > > +
> > > > > +	return error;
> > > > > +}
> > > > > diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
> > > > > index 780b02f..3be7768 100644
> > > > > --- a/fs/xfs/libxfs/xfs_refcount_btree.h
> > > > > +++ b/fs/xfs/libxfs/xfs_refcount_btree.h
> > > > > @@ -68,4 +68,7 @@ extern xfs_extlen_t xfs_refcountbt_calc_size(struct xfs_mount *mp,
> > > > >  		unsigned long long len);
> > > > >  extern xfs_extlen_t xfs_refcountbt_max_size(struct xfs_mount *mp);
> > > > >  
> > > > > +extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
> > > > > +		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
> > > > > +
> > > > >  #endif	/* __XFS_REFCOUNT_BTREE_H__ */
> > > > > diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> > > > > index 9c0585e..83e672f 100644
> > > > > --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> > > > > +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> > > > > @@ -35,6 +35,7 @@
> > > > >  #include "xfs_cksum.h"
> > > > >  #include "xfs_error.h"
> > > > >  #include "xfs_extent_busy.h"
> > > > > +#include "xfs_ag_resv.h"
> > > > >  
> > > > >  /*
> > > > >   * Reverse map btree.
> > > > > @@ -533,3 +534,62 @@ xfs_rmapbt_compute_maxlevels(
> > > > >  		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(mp,
> > > > >  				mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
> > > > >  }
> > > > > +
> > > > > +/* Calculate the refcount btree size for some records. */
> > > > > +xfs_extlen_t
> > > > > +xfs_rmapbt_calc_size(
> > > > > +	struct xfs_mount	*mp,
> > > > > +	unsigned long long	len)
> > > > > +{
> > > > > +	return xfs_btree_calc_size(mp, mp->m_rmap_mnr, len);
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Calculate the maximum refcount btree size.
> > > > > + */
> > > > > +xfs_extlen_t
> > > > > +xfs_rmapbt_max_size(
> > > > > +	struct xfs_mount	*mp)
> > > > > +{
> > > > > +	/* Bail out if we're uninitialized, which can happen in mkfs. */
> > > > > +	if (mp->m_rmap_mxr[0] == 0)
> > > > > +		return 0;
> > > > > +
> > > > > +	return xfs_rmapbt_calc_size(mp, mp->m_sb.sb_agblocks);
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Figure out how many blocks to reserve and how many are used by this btree.
> > > > > + */
> > > > > +int
> > > > > +xfs_rmapbt_calc_reserves(
> > > > > +	struct xfs_mount	*mp,
> > > > > +	xfs_agnumber_t		agno,
> > > > > +	xfs_extlen_t		*ask,
> > > > > +	xfs_extlen_t		*used)
> > > > > +{
> > > > > +	struct xfs_buf		*agbp;
> > > > > +	struct xfs_agf		*agf;
> > > > > +	xfs_extlen_t		pool_len;
> > > > > +	xfs_extlen_t		tree_len;
> > > > > +	int			error;
> > > > > +
> > > > > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > > > > +		return 0;
> > > > > +
> > > > > +	/* Reserve 1% of the AG or enough for 1 block per record. */
> > > > > +	pool_len = max(mp->m_sb.sb_agblocks / 100, xfs_rmapbt_max_size(mp));
> > > > > +	*ask += pool_len;
> > > > > +
> > > > > +	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
> > > > > +	if (error)
> > > > > +		return error;
> > > > > +
> > > > > +	agf = XFS_BUF_TO_AGF(agbp);
> > > > > +	tree_len = be32_to_cpu(agf->agf_rmap_blocks);
> > > > > +	xfs_buf_relse(agbp);
> > > > > +
> > > > > +	*used += tree_len;
> > > > > +
> > > > > +	return error;
> > > > > +}
> > > > > diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> > > > > index e73a553..2a9ac47 100644
> > > > > --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> > > > > +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> > > > > @@ -58,4 +58,11 @@ struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
> > > > >  int xfs_rmapbt_maxrecs(struct xfs_mount *mp, int blocklen, int leaf);
> > > > >  extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
> > > > >  
> > > > > +extern xfs_extlen_t xfs_rmapbt_calc_size(struct xfs_mount *mp,
> > > > > +		unsigned long long len);
> > > > > +extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp);
> > > > > +
> > > > > +extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp,
> > > > > +		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
> > > > > +
> > > > >  #endif	/* __XFS_RMAP_BTREE_H__ */
> > > > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > > > index 3acbf4e0..93d12fa 100644
> > > > > --- a/fs/xfs/xfs_fsops.c
> > > > > +++ b/fs/xfs/xfs_fsops.c
> > > > > @@ -43,6 +43,7 @@
> > > > >  #include "xfs_log.h"
> > > > >  #include "xfs_filestream.h"
> > > > >  #include "xfs_rmap.h"
> > > > > +#include "xfs_ag_resv.h"
> > > > >  
> > > > >  /*
> > > > >   * File system operations
> > > > > @@ -630,6 +631,11 @@ xfs_growfs_data_private(
> > > > >  	xfs_set_low_space_thresholds(mp);
> > > > >  	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> > > > >  
> > > > > +	/* Reserve AG metadata blocks. */
> > > > > +	error = xfs_fs_reserve_ag_blocks(mp);
> > > > > +	if (error && error != -ENOSPC)
> > > > > +		goto out;
> > > > > +
> > > > >  	/* update secondary superblocks. */
> > > > >  	for (agno = 1; agno < nagcount; agno++) {
> > > > >  		error = 0;
> > > > > @@ -680,6 +686,8 @@ xfs_growfs_data_private(
> > > > >  			continue;
> > > > >  		}
> > > > >  	}
> > > > > +
> > > > > + out:
> > > > >  	return saved_error ? saved_error : error;
> > > > >  
> > > > >   error0:
> > > > > @@ -989,3 +997,59 @@ xfs_do_force_shutdown(
> > > > >  	"Please umount the filesystem and rectify the problem(s)");
> > > > >  	}
> > > > >  }
> > > > > +
> > > > > +/*
> > > > > + * Reserve free space for per-AG metadata.
> > > > > + */
> > > > > +int
> > > > > +xfs_fs_reserve_ag_blocks(
> > > > > +	struct xfs_mount	*mp)
> > > > > +{
> > > > > +	xfs_agnumber_t		agno;
> > > > > +	struct xfs_perag	*pag;
> > > > > +	int			error = 0;
> > > > > +	int			err2;
> > > > > +
> > > > > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > > > > +		pag = xfs_perag_get(mp, agno);
> > > > > +		err2 = xfs_ag_resv_init(pag);
> > > > > +		xfs_perag_put(pag);
> > > > > +		if (err2 && !error)
> > > > > +			error = err2;
> > > > > +	}
> > > > > +
> > > > > +	if (error && error != -ENOSPC) {
> > > > > +		xfs_warn(mp,
> > > > > +	"Error %d reserving per-AG metadata reserve pool.", error);
> > > > > +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > > > +	}
> > > > > +
> > > > > +	return error;
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Free space reserved for per-AG metadata.
> > > > > + */
> > > > > +int
> > > > > +xfs_fs_unreserve_ag_blocks(
> > > > > +	struct xfs_mount	*mp)
> > > > > +{
> > > > > +	xfs_agnumber_t		agno;
> > > > > +	struct xfs_perag	*pag;
> > > > > +	int			error = 0;
> > > > > +	int			err2;
> > > > > +
> > > > > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > > > > +		pag = xfs_perag_get(mp, agno);
> > > > > +		err2 = xfs_ag_resv_free(pag);
> > > > > +		xfs_perag_put(pag);
> > > > > +		if (err2 && !error)
> > > > > +			error = err2;
> > > > > +	}
> > > > > +
> > > > > +	if (error)
> > > > > +		xfs_warn(mp,
> > > > > +	"Error %d freeing per-AG metadata reserve pool.", error);
> > > > > +
> > > > > +	return error;
> > > > > +}
> > > > > diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> > > > > index f32713f..f349158 100644
> > > > > --- a/fs/xfs/xfs_fsops.h
> > > > > +++ b/fs/xfs/xfs_fsops.h
> > > > > @@ -26,4 +26,7 @@ extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
> > > > >  				xfs_fsop_resblks_t *outval);
> > > > >  extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
> > > > >  
> > > > > +extern int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
> > > > > +extern int xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
> > > > > +
> > > > >  #endif	/* __XFS_FSOPS_H__ */
> > > > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > > > index caecbd2..b5da81d 100644
> > > > > --- a/fs/xfs/xfs_mount.c
> > > > > +++ b/fs/xfs/xfs_mount.c
> > > > > @@ -986,10 +986,17 @@ xfs_mountfs(
> > > > >  			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > > >  			goto out_quota;
> > > > >  		}
> > > > > +
> > > > > +		/* Reserve AG blocks for future btree expansion. */
> > > > > +		error = xfs_fs_reserve_ag_blocks(mp);
> > > > > +		if (error && error != -ENOSPC)
> > > > > +			goto out_agresv;
> > > > >  	}
> > > > >  
> > > > >  	return 0;
> > > > >  
> > > > > + out_agresv:
> > > > > +	xfs_fs_unreserve_ag_blocks(mp);
> > > > >   out_quota:
> > > > >  	xfs_qm_unmount_quotas(mp);
> > > > >   out_rtunmount:
> > > > > @@ -1034,6 +1041,7 @@ xfs_unmountfs(
> > > > >  
> > > > >  	cancel_delayed_work_sync(&mp->m_eofblocks_work);
> > > > >  
> > > > > +	xfs_fs_unreserve_ag_blocks(mp);
> > > > >  	xfs_qm_unmount_quotas(mp);
> > > > >  	xfs_rtunmount_inodes(mp);
> > > > >  	IRELE(mp->m_rootip);
> > > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > > index e6aaa91..875ab9f 100644
> > > > > --- a/fs/xfs/xfs_super.c
> > > > > +++ b/fs/xfs/xfs_super.c
> > > > > @@ -1315,10 +1315,22 @@ xfs_fs_remount(
> > > > >  			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > > >  			return error;
> > > > >  		}
> > > > > +
> > > > > +		/* Create the per-AG metadata reservation pool .*/
> > > > > +		error = xfs_fs_reserve_ag_blocks(mp);
> > > > > +		if (error && error != -ENOSPC)
> > > > > +			return error;
> > > > >  	}
> > > > >  
> > > > >  	/* rw -> ro */
> > > > >  	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
> > > > > +		/* Free the per-AG metadata reservation pool. */
> > > > > +		error = xfs_fs_unreserve_ag_blocks(mp);
> > > > > +		if (error) {
> > > > > +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > > > +			return error;
> > > > > +		}
> > > > > +
> > > > >  		/*
> > > > >  		 * Before we sync the metadata, we need to free up the reserve
> > > > >  		 * block pool so that the used block count in the superblock on
> > > > > 
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
