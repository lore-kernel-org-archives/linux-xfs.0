Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37362 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751827AbdLFWGK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Dec 2017 17:06:10 -0500
Date: Wed, 6 Dec 2017 14:06:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: always honor OWN_UNKNOWN rmap removal requests
Message-ID: <20171206220605.GN19219@magnolia>
References: <20171205185524.GB42206@bfoster.bfoster>
 <20171205233420.GG19219@magnolia>
 <20171206141406.GA46723@bfoster.bfoster>
 <20171206175300.GJ19219@magnolia>
 <20171206204945.GB46723@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206204945.GB46723@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 06, 2017 at 03:49:46PM -0500, Brian Foster wrote:
> On Wed, Dec 06, 2017 at 09:53:00AM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 06, 2017 at 09:14:07AM -0500, Brian Foster wrote:
> > > On Tue, Dec 05, 2017 at 03:34:20PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Calling xfs_rmap_free with an unknown owner is supposed to remove any
> > > > rmaps covering that range regardless of owner.  This is used by the EFI
> > > > recovery code to say "we're freeing this, it mustn't be owned by
> > > > anything anymore", but for whatever reason xfs_free_ag_extent filters
> > > > them out.
> > > > 
> > > > Therefore, remove the filter and make xfs_rmap_unmap actually treat it
> > > > as a wildcard owner -- free anything that's already there, and if
> > > > there's no owner at all then that's fine too.
> > > > 
> > > > There are two existing callers of bmap_add_free that take care the rmap
> > > > deferred ops themselves and use OWN_UNKNOWN to skip the EFI-based rmap
> > > > cleanup; convert these to use OWN_NULL, and ensure that the RUI gets
> > > > added to the defer ops ahead of any EFI.
> > > > 
> > > > Lastly, now that xfs_free_extent filters out OWN_NULL rmap free requests,
> > > > growfs will have to consult directly with the rmap to ensure that there
> > > > aren't any rmaps in the grown region.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > 
> ...
> > > > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > > > index 5f3a3d9..fd0e630 100644
> > > > --- a/fs/xfs/libxfs/xfs_rmap.c
> > > > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > > > @@ -484,10 +484,17 @@ xfs_rmap_unmap(
> > > >  	XFS_WANT_CORRUPTED_GOTO(mp, (flags & XFS_RMAP_UNWRITTEN) ==
> > > >  			(ltrec.rm_flags & XFS_RMAP_UNWRITTEN), out_error);
> > > >  
> > > > -	/* Make sure the extent we found covers the entire freeing range. */
> > > > -	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno &&
> > > > -		ltrec.rm_startblock + ltrec.rm_blockcount >=
> > > > -		bno + len, out_error);
> > > > +	/*
> > > > +	 * Make sure the extent we found covers the entire freeing range.
> > > > +	 * If this is a wildcard free, we're already done, otherwise there's
> > > > +	 * something wrong with the rmapbt.
> > > > +	 */
> > > 
> > > What does this mean by "we're already done?" This logic appears to mean
> > > that we don't do anything (as opposed to throwing an error). I think the
> > > comment would be more clear if it pointed out that/why we have nothing
> > > to do here (due to OWN_UNKNOWN). I.e., caller passed in a wildcard and
> > > we essentially didn't find a match..?
> > 
> > "Make sure the extent we found covers the entire freeing range.  Passing
> > in an owner of OWN_UNKNOWN means that the caller wants to remove any
> > reverse mapping that may exist for this range of blocks regardless of
> > owner; if there are no mappings at all, we're done."
> > 
> 
> Looking at this again, I find it a bit confusing how this check seems to
> double as a "nothing to do" in the unknown case and a corruption error
> otherwise. For example, is something still technically wrong if we get
> an UNKNOWN unmap request (aka an extent free) to unmap a range that
> overlaps with but starts before or extends past the range in the rmapbt?

I .... hmm, bear with my stream of consciousness:

Start with the assumption that for each rmap free request there is
exactly one rmap that overlaps with the request (X and Y are existing
rmaps, R is the range we want to remove):

XXXXX....YYYY
   RR

XXXXX....YYYY
         RR

XXXXX....YYYY
 RR

XXXXX....YYYY
RRRRR

(Note that we also assume that the rmapbt never has two mergeable
records.  rm_blockcount is 32-bit which is large enough to cover an
entire AG if need be.)

On the regular logging path, we have two choices: (1) pass the owner to
xfs_free_extent and let the EFI-finish remove the rmap, or (2) queue our
own deferred rmap unmap and pass OWN_NULL to bmap_add_free in which case
the EFI-finish will not try to remove an rmap.

If we have to log-recover (1), then neither the rmap nor the free space
btrees got updated, so there should be a single rmap covering the whole
EFI extent.  The EFI recovery will do an OWN_UNKNOWN rmap free, which
will find that full rmap and remove as necessary.

If we have to log-recover (2) then (assuming we queued the RUI before
the EFI like we're supposed to) the RUI recovery will remove the
rmapping and the EFI recovery's OWN_UNKNOWN rmap free will find nothing.

So far so good?  Let's see what happens if our assumption is false:

XXXXX....YYYY
  RRRRR

XXXXX....YYYY
      RRRRR

XXXXX....YYYY
   RRRRRRRR

Then we started with a filesystem that only had a partial rmapping for a
mapped region.  For a known-owner removal we'll only ever see rmap X and
trigger this corruption report.  This holds true even for an
unknown-owner removal, so I think you're definitely onto something here.
The rework of this hunk was incorrect; I should have left it alone.

XXXXX....YYYY
      RR

So this is this case where EFI recovery needs to delete an rmap and
there's already nothing there, ideally because a previous RUI already
did the work for us.

I /think/ the proper fix is that if ltrec precedes the range being
removed then we increment to check the next extent, and if there's no
overlap with the right extent (or no right extent), then the rmappings
were already cleared out and therefore we can just exit:

/*
 * If we're doing an unknown-owner removal and there are no rmaps
 * overlapping the other end of range, we're done.
 */
if (owner == UNKNOWN && ltrec.rm_startblock + ltrec.rm_blockcount <= bno) {
	struct xfs_rmap_irec	rtrec;

	xfs_btree_increment(rmap_cur, &has);
	if (!has)
		return 0;
	xfs_btree_getrec(rmap_cur, &rtrec);
	if (rtrec.rm_startblock > bno + len)
		return 0;
}

/* Make sure the extent we found covers the entire freeing range. */
XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno &&
	ltrec.rm_startblock + ltrec.rm_blockcount >=
	bno + len, out_error);

Good catch!  This whole thing has turned my brain into a lump of
spaghetti.  Well that and the three simultaneous internal bug hunts...

--D

> I could easily be missing something here, but otherwise I wonder if this
> would be better as separate checks so we don't lose some of the error
> checking coverage.
> 
> Brian
> 
> > > > +	if (ltrec.rm_startblock > bno ||
> > > > +	    ltrec.rm_startblock + ltrec.rm_blockcount < bno + len) {
> > > > +		if (owner == XFS_RMAP_OWN_UNKNOWN)
> > > > +			goto out_done;
> > > > +		XFS_WANT_CORRUPTED_GOTO(mp, false, out_error);
> > > > +	}
> > > >  
> > > 
> > > Also... unrelated, but is this check immediately below really intending
> > > to ignore owner inconsistencies for all !inode owners?
> > 
> > I had my eye on that one too, though I think that could be a
> > freestanding cleanup.
> > 
> > > >  	/* Make sure the owner matches what we expect to find in the tree. */
> > > >  	XFS_WANT_CORRUPTED_GOTO(mp, owner == ltrec.rm_owner ||
> > > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > > index 8f22fc5..60a2e12 100644
> > > > --- a/fs/xfs/xfs_fsops.c
> > > > +++ b/fs/xfs/xfs_fsops.c
> > > > @@ -571,6 +571,11 @@ xfs_growfs_data_private(
> > > >  		 * this doesn't actually exist in the rmap btree.
> > > >  		 */
> > > >  		xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_NULL);
> > > > +		error = xfs_rmap_free(tp, bp, agno,
> > > > +				be32_to_cpu(agf->agf_length) - new,
> > > > +				new, &oinfo);
> > > > +		if (error)
> > > > +			goto error0;
> > > 
> > > OWN_NULL makes sense from the perspective of needing to avoid some error
> > > down in the free code where we need to free some space without needing
> > > to remove an owner, but what is the purpose of the above? It doesn't
> > > look like this really does anything beyond checking that the associated
> > > space is beyond the end of the rmapbt. If that's the intent, then it
> > > probably makes sense to update this comment as well.
> > 
> > Yes, that's exactly the intent.
> > 
> > Hmm, come to think of it, the rmap xref patch adds a
> > xfs_rmap_has_record helper that does exactly what we want here (decides
> > if there are any records covering this range).
> > 
> > --D
> > 
> > > Brian
> > > 
> > > >  		error = xfs_free_extent(tp,
> > > >  				XFS_AGB_TO_FSB(mp, agno,
> > > >  					be32_to_cpu(agf->agf_length) - new),
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
