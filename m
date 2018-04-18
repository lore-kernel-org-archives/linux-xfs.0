Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39688 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752414AbeDRQDB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 12:03:01 -0400
Date: Wed, 18 Apr 2018 09:02:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/11] xfs: skip scrub xref if corruption already noted
Message-ID: <20180418160241.GR24738@magnolia>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401917356.11465.5404373936588816069.stgit@magnolia>
 <20180418150307.GA19870@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418150307.GA19870@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 18, 2018 at 11:03:08AM -0400, Brian Foster wrote:
> On Tue, Apr 17, 2018 at 07:39:33PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Don't bother looking for cross-referencing problems if the metadata is
> > already corrupt or we've already found a cross-referencing problem.
> > Since we added a helper function for flags testing, convert existing
> > users to use it.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/alloc.c    |    2 +-
> >  fs/xfs/scrub/common.c   |    4 ++++
> >  fs/xfs/scrub/common.h   |    6 ++++++
> >  fs/xfs/scrub/ialloc.c   |    2 +-
> >  fs/xfs/scrub/refcount.c |    4 ++--
> >  fs/xfs/scrub/rmap.c     |    4 ++--
> >  fs/xfs/scrub/rtbitmap.c |    3 +++
> >  fs/xfs/scrub/scrub.c    |    3 +--
> >  8 files changed, 20 insertions(+), 8 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> > index 517c079..f5c6993 100644
> > --- a/fs/xfs/scrub/alloc.c
> > +++ b/fs/xfs/scrub/alloc.c
> > @@ -172,7 +172,7 @@ xfs_scrub_xref_is_used_space(
> >  	bool				is_freesp;
> >  	int				error;
> >  
> > -	if (!sc->sa.bno_cur)
> > +	if (!sc->sa.bno_cur || xfs_scrub_found_corruption(sc->sm))
> >  		return;
> >  
> >  	error = xfs_alloc_has_record(sc->sa.bno_cur, agbno, len, &is_freesp);
> > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > index 8ed91d5..3f72176 100644
> > --- a/fs/xfs/scrub/common.c
> > +++ b/fs/xfs/scrub/common.c
> > @@ -727,6 +727,10 @@ xfs_scrub_should_check_xref(
> >  	int				*error,
> >  	struct xfs_btree_cur		**curpp)
> >  {
> > +	/* No point in xref if we already know we're corrupt. */
> > +	if (xfs_scrub_found_corruption(sc->sm))
> > +		return false;
> > +
> 
> This seems like a fairly innocuous change for not being terribly
> familiar with the scrub code, but a high level thought...
> 
> This function has 30+ callers, then we have a bunch of these
> found_corruption() checks as well, one of which is the former. The new
> callers of the found_corruption() functions look like they easily have
> tens of callers throughout the scrub xref code, which kind of makes this
> look like quite the maze of logic just to shortcut various checks.
> 
> This is not an objection to this patch, but it makes me wonder how much
> "empty" processing is involved in a situation where we assume an xref
> error is detected early on in a scrub. Secondarily, the logic makes this
> hard enough to follow that the only way to really surmise that is to
> trace through all of the scrub code. It also looks like we have some
> places where it's checked multiple times.

Yep.  Originally I designed scrub always to run all the way to the end
so that we could find and stream to userspace every corruption &
discrepancy that we found.  Then I started looking into how to actually
communicate with userspace in a sane way, found none, and decided to
migrate towards bailing out as soon as we know something's bad:

 1. Stop checking at the first outright corruption we see.
 2. Stop cross-referencing at the first xref discrepancy we see.

The goal is to revise the structure of the scrubbing code like so:

1. for each record:
   a. call function that:
        i. look for corruption errors
       ii. if corruption errors then return
      iii. for each thing we can cross-reference with:
           A. if xref errors, break out of loop
           B. confirm cross-reference
   b. if corruption errors, break out of loop

Note: the xref checks in 1.a.iii.B. should never set OFLAG_CORRUPT.

Therefore I have to outfit every xref helper and subfunction with a
check that skips the xref if there are xref errors...

> For example, xfs_scrub_inode_xref() checks the corrupt flag and then
> calls a bunch of sub-handlers that call either found_corruption() or
> the should_check_xref(). One of the latter callers is
> xfs_scrub_inode_xref_finobt(), which does a btree lookup before it
> ever gets to this call only to then bail on the corruption flag being
> set.

...but I see what you're saying and I think I just plain missed those. :(

> Granted, this would probably only execute if the flag was set after the
> higher level scrub_inode_xref() check, but isn't it kind of strange to
> bury a check that is intended to control high-level xref execution flow
> in a call that is (also) designed to check the error of some btree
> lookup that shouldn't be required at all if the xref was going to be
> skipped anyways? I'm wondering if this would be more clear with
> consistent but separate error/corruption checks at the top of every xref
> helper to dictate high-level scrub execution flow and leave
> scrub_should_check_xref() to continue to care only about local
> processing decisions specific to the current branch of the scan (i.e.,
> my btree lookup failed and so we must set the corrupt flag and not
> proceed).

Yep, exactly right.  I'll go scan the source code again.

(My filthy excuse for missing things is distraction on account of making
sure that scrub reliably triggers repair, and that repair works
correctly.)

--D

> Brian
> 
> >  	if (*error == 0)
> >  		return true;
> >  
> > diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> > index deaf604..30e9039 100644
> > --- a/fs/xfs/scrub/common.h
> > +++ b/fs/xfs/scrub/common.h
> > @@ -157,4 +157,10 @@ int xfs_scrub_setup_inode_contents(struct xfs_scrub_context *sc,
> >  				   struct xfs_inode *ip, unsigned int resblks);
> >  void xfs_scrub_buffer_recheck(struct xfs_scrub_context *sc, struct xfs_buf *bp);
> >  
> > +static inline bool xfs_scrub_found_corruption(struct xfs_scrub_metadata *sm)
> > +{
> > +	return sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
> > +			       XFS_SCRUB_OFLAG_XCORRUPT);
> > +}
> > +
> >  #endif	/* __XFS_SCRUB_COMMON_H__ */
> > diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> > index 106ca4b..05e6191 100644
> > --- a/fs/xfs/scrub/ialloc.c
> > +++ b/fs/xfs/scrub/ialloc.c
> > @@ -496,7 +496,7 @@ xfs_scrub_xref_inode_check(
> >  	bool				has_inodes;
> >  	int				error;
> >  
> > -	if (!(*icur))
> > +	if (!(*icur) || xfs_scrub_found_corruption(sc->sm))
> >  		return;
> >  
> >  	error = xfs_ialloc_has_inodes_at_extent(*icur, agbno, len, &has_inodes);
> > diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> > index 400f156..823bda3 100644
> > --- a/fs/xfs/scrub/refcount.c
> > +++ b/fs/xfs/scrub/refcount.c
> > @@ -460,7 +460,7 @@ xfs_scrub_xref_is_cow_staging(
> >  	int				has_refcount;
> >  	int				error;
> >  
> > -	if (!sc->sa.refc_cur)
> > +	if (!sc->sa.refc_cur || xfs_scrub_found_corruption(sc->sm))
> >  		return;
> >  
> >  	/* Find the CoW staging extent. */
> > @@ -504,7 +504,7 @@ xfs_scrub_xref_is_not_shared(
> >  	bool				shared;
> >  	int				error;
> >  
> > -	if (!sc->sa.refc_cur)
> > +	if (!sc->sa.refc_cur || xfs_scrub_found_corruption(sc->sm))
> >  		return;
> >  
> >  	error = xfs_refcount_has_record(sc->sa.refc_cur, agbno, len, &shared);
> > diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
> > index 8f2a7c3..9ca92e4 100644
> > --- a/fs/xfs/scrub/rmap.c
> > +++ b/fs/xfs/scrub/rmap.c
> > @@ -207,7 +207,7 @@ xfs_scrub_xref_check_owner(
> >  	bool				has_rmap;
> >  	int				error;
> >  
> > -	if (!sc->sa.rmap_cur)
> > +	if (!sc->sa.rmap_cur || xfs_scrub_found_corruption(sc->sm))
> >  		return;
> >  
> >  	error = xfs_rmap_record_exists(sc->sa.rmap_cur, bno, len, oinfo,
> > @@ -250,7 +250,7 @@ xfs_scrub_xref_has_no_owner(
> >  	bool				has_rmap;
> >  	int				error;
> >  
> > -	if (!sc->sa.rmap_cur)
> > +	if (!sc->sa.rmap_cur || xfs_scrub_found_corruption(sc->sm))
> >  		return;
> >  
> >  	error = xfs_rmap_has_record(sc->sa.rmap_cur, bno, len, &has_rmap);
> > diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> > index 39c41dfe..c8672f7 100644
> > --- a/fs/xfs/scrub/rtbitmap.c
> > +++ b/fs/xfs/scrub/rtbitmap.c
> > @@ -110,6 +110,9 @@ xfs_scrub_xref_is_used_rt_space(
> >  	bool				is_free;
> >  	int				error;
> >  
> > +	if (xfs_scrub_found_corruption(sc->sm))
> > +		return;
> > +
> >  	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
> >  	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, fsbno, len,
> >  			&is_free);
> > diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> > index 26c7596..cb1e727 100644
> > --- a/fs/xfs/scrub/scrub.c
> > +++ b/fs/xfs/scrub/scrub.c
> > @@ -446,8 +446,7 @@ xfs_scrub_metadata(
> >  	} else if (error)
> >  		goto out_teardown;
> >  
> > -	if (sc.sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
> > -			       XFS_SCRUB_OFLAG_XCORRUPT))
> > +	if (xfs_scrub_found_corruption(sc.sm))
> >  		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
> >  
> >  out_teardown:
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
