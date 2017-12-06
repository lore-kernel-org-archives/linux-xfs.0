Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47963 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752368AbdLFRxG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Dec 2017 12:53:06 -0500
Date: Wed, 6 Dec 2017 09:53:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: always honor OWN_UNKNOWN rmap removal requests
Message-ID: <20171206175300.GJ19219@magnolia>
References: <20171205185524.GB42206@bfoster.bfoster>
 <20171205233420.GG19219@magnolia>
 <20171206141406.GA46723@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206141406.GA46723@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 06, 2017 at 09:14:07AM -0500, Brian Foster wrote:
> On Tue, Dec 05, 2017 at 03:34:20PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Calling xfs_rmap_free with an unknown owner is supposed to remove any
> > rmaps covering that range regardless of owner.  This is used by the EFI
> > recovery code to say "we're freeing this, it mustn't be owned by
> > anything anymore", but for whatever reason xfs_free_ag_extent filters
> > them out.
> > 
> > Therefore, remove the filter and make xfs_rmap_unmap actually treat it
> > as a wildcard owner -- free anything that's already there, and if
> > there's no owner at all then that's fine too.
> > 
> > There are two existing callers of bmap_add_free that take care the rmap
> > deferred ops themselves and use OWN_UNKNOWN to skip the EFI-based rmap
> > cleanup; convert these to use OWN_NULL, and ensure that the RUI gets
> > added to the defer ops ahead of any EFI.
> > 
> > Lastly, now that xfs_free_extent filters out OWN_NULL rmap free requests,
> > growfs will have to consult directly with the rmap to ensure that there
> > aren't any rmaps in the grown region.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Thanks... this resolves the log recovery problem on a quick test.
> 
> >  fs/xfs/libxfs/xfs_alloc.c    |    2 +-
> >  fs/xfs/libxfs/xfs_bmap.c     |    2 +-
> >  fs/xfs/libxfs/xfs_refcount.c |   52 +++++++++++++++---------------------------
> >  fs/xfs/libxfs/xfs_rmap.c     |   15 +++++++++---
> >  fs/xfs/xfs_fsops.c           |    5 ++++
> >  5 files changed, 37 insertions(+), 39 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index a840028..0f260eeb 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -1696,7 +1696,7 @@ xfs_free_ag_extent(
> >  	bno_cur = cnt_cur = NULL;
> >  	mp = tp->t_mountp;
> >  
> > -	if (oinfo->oi_owner != XFS_RMAP_OWN_UNKNOWN) {
> > +	if (oinfo->oi_owner != XFS_RMAP_OWN_NULL) {
> >  		error = xfs_rmap_free(tp, agbp, agno, bno, len, oinfo);
> >  		if (error)
> >  			goto error0;
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 16df627..89bb3d9 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -573,7 +573,7 @@ xfs_bmap_add_free(
> >  	if (oinfo)
> >  		new->xefi_oinfo = *oinfo;
> >  	else
> > -		xfs_rmap_skip_owner_update(&new->xefi_oinfo);
> > +		xfs_rmap_ag_owner(&new->xefi_oinfo, XFS_RMAP_OWN_NULL);
> 
> So what is the difference now between xfs_rmap_skip_owner_update(),
> which sets OWN_UNKNOWN, and OWN_NULL, which skips owner updates in
> certain cases? Should we be using OWN_NULL consistently to skip owner
> updates (not that UNKNOWN makes much sense in some of the other cases,
> like allocation).

Yeah, there's a bunch of cleanups that I was intending to do (most of
which you've caught below) prior to making a non-RFC submission.

> >  	trace_xfs_bmap_free_defer(mp, XFS_FSB_TO_AGNO(mp, bno), 0,
> >  			XFS_FSB_TO_AGBNO(mp, bno), len);
> >  	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
> > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > index 73f8058..9103be0 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.c
> > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > @@ -1505,27 +1505,12 @@ __xfs_refcount_cow_alloc(
> >  	xfs_extlen_t		aglen,
> >  	struct xfs_defer_ops	*dfops)
> >  {
> > -	int			error;
> > -
> >  	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_private.a.agno,
> >  			agbno, aglen);
> >  
> >  	/* Add refcount btree reservation */
> > -	error = xfs_refcount_adjust_cow(rcur, agbno, aglen,
> > +	return xfs_refcount_adjust_cow(rcur, agbno, aglen,
> >  			XFS_REFCOUNT_ADJUST_COW_ALLOC, dfops);
> > -	if (error)
> > -		return error;
> > -
> > -	/* Add rmap entry */
> > -	if (xfs_sb_version_hasrmapbt(&rcur->bc_mp->m_sb)) {
> > -		error = xfs_rmap_alloc_extent(rcur->bc_mp, dfops,
> > -				rcur->bc_private.a.agno,
> > -				agbno, aglen, XFS_RMAP_OWN_COW);
> > -		if (error)
> > -			return error;
> > -	}
> > -
> > -	return error;
> >  }
> 
> I think the refcount fixup probably warrants an independent patch with a
> more detailed commit log around the ordering requirement and how this
> changes behavior.

Yep.

> >  
> >  /*
> > @@ -1538,27 +1523,12 @@ __xfs_refcount_cow_free(
> >  	xfs_extlen_t		aglen,
> >  	struct xfs_defer_ops	*dfops)
> >  {
> > -	int			error;
> > -
> >  	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_private.a.agno,
> >  			agbno, aglen);
> >  
> >  	/* Remove refcount btree reservation */
> > -	error = xfs_refcount_adjust_cow(rcur, agbno, aglen,
> > +	return xfs_refcount_adjust_cow(rcur, agbno, aglen,
> >  			XFS_REFCOUNT_ADJUST_COW_FREE, dfops);
> 
> xfs_refcount_finish_one() -> xfs_refcount_cow_[alloc|free]() ->
> xfs_refcount_adjust_cow() -> ...
> 
> Hmm, seems like there's opportunity for more cleanup here. Do we really
> need separate xfs_refcount_cow_*() functions just for tracepoints? Seems
> like we could just fold these into xfs_refcount_finish_one().

Yep.

> > -	if (error)
> > -		return error;
> > -
> > -	/* Remove rmap entry */
> > -	if (xfs_sb_version_hasrmapbt(&rcur->bc_mp->m_sb)) {
> > -		error = xfs_rmap_free_extent(rcur->bc_mp, dfops,
> > -				rcur->bc_private.a.agno,
> > -				agbno, aglen, XFS_RMAP_OWN_COW);
> > -		if (error)
> > -			return error;
> > -	}
> > -
> > -	return error;
> >  }
> >  
> >  /* Record a CoW staging extent in the refcount btree. */
> > @@ -1569,11 +1539,19 @@ xfs_refcount_alloc_cow_extent(
> >  	xfs_fsblock_t			fsb,
> >  	xfs_extlen_t			len)
> >  {
> > +	int				error;
> > +
> >  	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> >  		return 0;
> >  
> > -	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_ALLOC_COW,
> > +	error = __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_ALLOC_COW,
> >  			fsb, len);
> > +	if (error)
> > +		return error;
> > +
> > +	/* Add rmap entry */
> > +	return xfs_rmap_alloc_extent(mp, dfops, XFS_FSB_TO_AGNO(mp, fsb),
> > +			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
> >  }
> >  
> >  /* Forget a CoW staging event in the refcount btree. */
> > @@ -1584,9 +1562,17 @@ xfs_refcount_free_cow_extent(
> >  	xfs_fsblock_t			fsb,
> >  	xfs_extlen_t			len)
> >  {
> > +	int				error;
> > +
> >  	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> >  		return 0;
> >  
> > +	/* Remove rmap entry */
> > +	error = xfs_rmap_free_extent(mp, dfops, XFS_FSB_TO_AGNO(mp, fsb),
> > +			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
> > +	if (error)
> > +		return error;
> > +
> >  	return __xfs_refcount_add(mp, dfops, XFS_REFCOUNT_FREE_COW,
> >  			fsb, len);
> >  }
> > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > index 5f3a3d9..fd0e630 100644
> > --- a/fs/xfs/libxfs/xfs_rmap.c
> > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > @@ -484,10 +484,17 @@ xfs_rmap_unmap(
> >  	XFS_WANT_CORRUPTED_GOTO(mp, (flags & XFS_RMAP_UNWRITTEN) ==
> >  			(ltrec.rm_flags & XFS_RMAP_UNWRITTEN), out_error);
> >  
> > -	/* Make sure the extent we found covers the entire freeing range. */
> > -	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno &&
> > -		ltrec.rm_startblock + ltrec.rm_blockcount >=
> > -		bno + len, out_error);
> > +	/*
> > +	 * Make sure the extent we found covers the entire freeing range.
> > +	 * If this is a wildcard free, we're already done, otherwise there's
> > +	 * something wrong with the rmapbt.
> > +	 */
> 
> What does this mean by "we're already done?" This logic appears to mean
> that we don't do anything (as opposed to throwing an error). I think the
> comment would be more clear if it pointed out that/why we have nothing
> to do here (due to OWN_UNKNOWN). I.e., caller passed in a wildcard and
> we essentially didn't find a match..?

"Make sure the extent we found covers the entire freeing range.  Passing
in an owner of OWN_UNKNOWN means that the caller wants to remove any
reverse mapping that may exist for this range of blocks regardless of
owner; if there are no mappings at all, we're done."

> > +	if (ltrec.rm_startblock > bno ||
> > +	    ltrec.rm_startblock + ltrec.rm_blockcount < bno + len) {
> > +		if (owner == XFS_RMAP_OWN_UNKNOWN)
> > +			goto out_done;
> > +		XFS_WANT_CORRUPTED_GOTO(mp, false, out_error);
> > +	}
> >  
> 
> Also... unrelated, but is this check immediately below really intending
> to ignore owner inconsistencies for all !inode owners?

I had my eye on that one too, though I think that could be a
freestanding cleanup.

> >  	/* Make sure the owner matches what we expect to find in the tree. */
> >  	XFS_WANT_CORRUPTED_GOTO(mp, owner == ltrec.rm_owner ||
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 8f22fc5..60a2e12 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -571,6 +571,11 @@ xfs_growfs_data_private(
> >  		 * this doesn't actually exist in the rmap btree.
> >  		 */
> >  		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_NULL);
> > +		error = xfs_rmap_free(tp, bp, agno,
> > +				be32_to_cpu(agf->agf_length) - new,
> > +				new, &oinfo);
> > +		if (error)
> > +			goto error0;
> 
> OWN_NULL makes sense from the perspective of needing to avoid some error
> down in the free code where we need to free some space without needing
> to remove an owner, but what is the purpose of the above? It doesn't
> look like this really does anything beyond checking that the associated
> space is beyond the end of the rmapbt. If that's the intent, then it
> probably makes sense to update this comment as well.

Yes, that's exactly the intent.

Hmm, come to think of it, the rmap xref patch adds a
xfs_rmap_has_record helper that does exactly what we want here (decides
if there are any records covering this range).

--D

> Brian
> 
> >  		error = xfs_free_extent(tp,
> >  				XFS_AGB_TO_FSB(mp, agno,
> >  					be32_to_cpu(agf->agf_length) - new),
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
