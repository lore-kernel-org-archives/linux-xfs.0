Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27945 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfDENHm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Apr 2019 09:07:42 -0400
Date: Fri, 5 Apr 2019 09:07:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/10] xfs: scrub/repair should update filesystem
 metadata health
Message-ID: <20190405130739.GB43111@bfoster>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
 <155413867262.4966.18080677522827911800.stgit@magnolia>
 <20190404115009.GB37737@bfoster>
 <20190404180133.GS5147@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404180133.GS5147@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 04, 2019 at 11:01:33AM -0700, Darrick J. Wong wrote:
> On Thu, Apr 04, 2019 at 07:50:11AM -0400, Brian Foster wrote:
> > On Mon, Apr 01, 2019 at 10:11:12AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Now that we have the ability to track sick metadata in-core, make scrub
> > > and repair update those health assessments after doing work.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/Makefile       |    1 
> > >  fs/xfs/scrub/health.c |  180 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/scrub/health.h |   12 +++
> > >  fs/xfs/scrub/scrub.c  |    8 ++
> > >  fs/xfs/scrub/scrub.h  |   11 +++
> > >  5 files changed, 212 insertions(+)
> > >  create mode 100644 fs/xfs/scrub/health.c
> > >  create mode 100644 fs/xfs/scrub/health.h
> > > 
> > > 
> > ...
> > > diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
> > > new file mode 100644
> > > index 000000000000..dd9986500801
> > > --- /dev/null
> > > +++ b/fs/xfs/scrub/health.c
> > > @@ -0,0 +1,180 @@
> > ...
> > > +/* Update filesystem health assessments based on what we found and did. */
> > > +void
> > > +xchk_update_health(
> > > +	struct xfs_scrub	*sc,
> > > +	bool			already_fixed)
> > > +{
> > > +	/*
> > > +	 * If the scrubber finds errors, we mark sick whatever's mentioned in
> > > +	 * sick_mask, no matter whether this is a first scan or an evaluation
> > > +	 * of repair effectiveness.
> > > +	 *
> > > +	 * If there is no direct corruption and we're called after a repair,
> > > +	 * clear whatever's in heal_mask because that's what we fixed.
> > > +	 *
> > > +	 * Otherwise, there's no direct corruption and we didn't repair
> > > +	 * anything, so mark whatever's in sick_mask as healthy.
> > > +	 */
> > > +	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > > +		xchk_mark_sick(sc, sc->sick_mask);
> > > +	else if (already_fixed)
> > > +		xchk_mark_healthy(sc, sc->heal_mask);
> > > +	else
> > > +		xchk_mark_healthy(sc, sc->sick_mask);
> > > +}
> > 
> > Hmm, I think I follow what we're doing here but it's a bit confusing
> > without the additional context of where these bits will be set/cleared
> > at the lower scrub layers (or at least without an example). Some
> > questions on that below...
> > 
> > ...
> > > diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> > > index 1b2344d00525..b1519dfc5811 100644
> > > --- a/fs/xfs/scrub/scrub.c
> > > +++ b/fs/xfs/scrub/scrub.c
> > > @@ -40,6 +40,7 @@
> > >  #include "scrub/trace.h"
> > >  #include "scrub/btree.h"
> > >  #include "scrub/repair.h"
> > > +#include "scrub/health.h"
> > >  
> > >  /*
> > >   * Online Scrub and Repair
> > > @@ -468,6 +469,7 @@ xfs_scrub_metadata(
> > >  {
> > >  	struct xfs_scrub		sc;
> > >  	struct xfs_mount		*mp = ip->i_mount;
> > > +	unsigned int			heal_mask;
> > >  	bool				try_harder = false;
> > >  	bool				already_fixed = false;
> > >  	int				error = 0;
> > > @@ -488,6 +490,7 @@ xfs_scrub_metadata(
> > >  	error = xchk_validate_inputs(mp, sm);
> > >  	if (error)
> > >  		goto out;
> > > +	heal_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
> > >  
> > >  	xchk_experimental_warning(mp);
> > >  
> > > @@ -499,6 +502,8 @@ xfs_scrub_metadata(
> > >  	sc.ops = &meta_scrub_ops[sm->sm_type];
> > >  	sc.try_harder = try_harder;
> > >  	sc.sa.agno = NULLAGNUMBER;
> > > +	sc.heal_mask = heal_mask;
> > > +	sc.sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
> > 
> > Ok, so we initialize the heal/sick masks based on the scrub type that
> > was requested on the first pass through...
> > 
> > >  	error = sc.ops->setup(&sc, ip);
> > >  	if (error)
> > >  		goto out_teardown;
> > > @@ -519,6 +524,8 @@ xfs_scrub_metadata(
> > >  	} else if (error)
> > >  		goto out_teardown;
> > >  
> > > +	xchk_update_health(&sc, already_fixed);
> > > +
> > 
> > ... then update the in-core fs health state based on the sick mask. Is
> > it possible for the scrub operation to set more sick mask bits based on
> > what it finds?
> 
> Theoretically, yes, but in practice none of the current scrubbers need
> to touch sick_mask.
> 
> heal_mask, OTOH, will be adjusted by the free space / inode repair
> functions since they rebuild multiple structures.
> 

Ok..

> > More specifically, I'm wondering why the masks wouldn't start as zero
> > and toggle based on finding/fixing corruption(s).
> 
> sick_mask is also the mask we feed to xfs_*_mark_healthy if the scan
> returns clean, which is why we set the default value before dispatching
> the scrub.
> 
> > Or if the sick mask value is essentially fixed, whether we need to
> > store it in the xfs_scrub context...
> 
> We could probably get away with generating it in xchk_update_health at
> the end, but it feels weird to have heal_mask in the scrub context but
> sick_mask gets auto-generated.
> 

Ok.. hmm. Both feel a little weird to me, but this is really just an
aesthetic/factoring thing so I'll think about it a bit more and come
back to it.

> > 
> > >  	if ((sc.sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) && !already_fixed) {
> > >  		bool needs_fix;
> > >  
> > > @@ -551,6 +558,7 @@ xfs_scrub_metadata(
> > >  				xrep_failure(mp);
> > >  				goto out;
> > >  			}
> > > +			heal_mask = sc.heal_mask;
> > 
> > And if we end up doing a repair, we presumably can repair multiple
> > things and so we track that separately and persist the heal mask across
> > a potential retry.
> 
> Right.
> 
> > What about the case where we don't retry, but scrub finds something
> > and then immediately repairs it?
> 
> The repair jumps back to retry_op if either (a) we couldn't get all the
> resources we needed and therefore sc.try_harder = true and we need to
> start over; or (b) repair thinks it fixed a thing, so we need to scrub
> the thing again to see if it's really fixed...
> 
> > Should we update the fs state after both detecting and clearing the
> > problem, or does that happen elsewhere?
> 
> ...so if scrub immediately repairs a thing, we preserve heal_mask, jump
> back to the scrub, and if the scrub says clean we'll mark heal mask
> healthy.
> 
> If the repair has to retry then the we'll call the repair function
> again, which (presumably) will set (again) the heal_mask appropriately,
> and then we have the same post-repair state updating as above.
> 
> Does that make sense? :)
> 

Ah, Ok. I didn't realize that a successful repair looped back to the
scrub code (and thus the health update). Yes, that makes more sense.

> > Also, if repair can potentially clear multiple bits, what's the
> > possibility of a repair clearing one failure and then failing on
> > another, causing the broader repair op to return an error or jump into
> > this retry?
> 
> Scrub doesn't touch the fs health state at all until after the ->scrub
> or ->repair function succeeds.  If the scrub or the repair functions
> fail for any non-retry reason, we back out to userspace without updating
> anything.  It's as if we'd never called the failed function.
> 

Right.. what I was getting at above is seeing whether we'd actually
update partial repair state in-core. E.g., suppose things A and B are
faulted in-core and it's one of these cases where repair can fix A and B
at the same time. If it fixes thing A and fails on thing B, it sounds
like we'd not clear the in-core fault state on A even though it's
technically repaired.

> Maybe some worked examples will help?
> 
> Let's say both inode btrees are corrupt.  We run xfs_scrub -n,
> xchk_inobt will record the corruption, and (assuming it hits no runtime
> errors) once we return to xfs_scrub_metadata, it'll set
> XFS_SICK_AG_INOBT.  Presumably xfs_scrub will also call the finobt scrub
> and SICK_AG_FINOBT will also get set.
> 
> If we run xfs_scrub without the -n, xchk_inobt will record the
> corruption and set SICK_AG_INOBT per above.  Then it'll run xrep_inobt,
> which will set heal_mask to SICK_AG_INOBT | SICK_AG_FINOBT.  If the
> repair fails with a non-retry runtime error, we exit to userspace and
> ignore heal_mask.
> 

Ok, this sounds like the case I'm theorizing about above (where suppose
repair fixed the inobt and then failed on the finobt, but hasn't cleared
faults for either..).

> If instead the repair succeeds, we scan the inobt again.  If that comes
> up clear then we use heal_mask to clear SICK_AG_INOBT | SICK_AG_FINOBT.
> xfs_scrub will call again later to repair the finobt, but the initial
> finobt scan will see no errors in the finobt, clear SICK_AG_FINOBT
> (which isn't set) and exit.
> 

So it sounds like the state would have to be cleared by a subsequent
scrub request. The scan would find thing A healthy and mark it so
regardless, to clear any potential previous faults that might have
already been repaired. Right?

> If the inobt repair function is buggy and says it repaired the inode
> btrees but leaves corruptions, then the rescan of the inobt will notice
> and set SICK_AG_INOBT (which is already set) and exit.  Similarly, when
> xfs_scrub calls back about the finobt, it will notice the corrupt
> finobt, try to set SICK_AG_FINOBT (also already set), try to fix it, and
> the rescan of the finobt will notice that the finobt is still corrupt
> and try to set SICK_AG_FINOBT (which is still set).
> 
> The end result (I think) is that we always set the sick bits if a scan
> shows problems, and we only clear the sick bits for things if we can
> prove that the things are no longer sick.  Does that help?
> 

Yes, thanks for the explanation. I think the confusion is mostly due to
not being able to fully see how these scrub states are managed,
particularly the bits that warranted the creation of separate masks in
the first place.

This does still have me wondering if separate masks are necessary, if we
perhaps had more selective health update logic, for example. I think it
might be better to either bundle this patch with whatever other changes
actually make use of the separate masks, or alternatively to simplify
the current logic and just defer the separate mask thing until those
more complex repair algorithms come along..

Brian

> > ISTM that it might be possible to skip clearing one fail state bit so
> > long as the original thing remained corrupted, but I feel like I'm
> > still missing some context on the bigger picture scrub tracking...
> 
> Yeah, the state machine is pretty squirrely. :/
> 
> --D
> 
> > Brian
> > 
> > >  			goto retry_op;
> > >  		}
> > >  	}
> > > diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> > > index 22f754fba8e5..05f1ad242a35 100644
> > > --- a/fs/xfs/scrub/scrub.h
> > > +++ b/fs/xfs/scrub/scrub.h
> > > @@ -62,6 +62,17 @@ struct xfs_scrub {
> > >  	struct xfs_inode		*ip;
> > >  	void				*buf;
> > >  	uint				ilock_flags;
> > > +
> > > +	/* Metadata to be marked sick if scrub finds errors. */
> > > +	unsigned int			sick_mask;
> > > +
> > > +	/*
> > > +	 * Metadata to be marked healthy if repair fixes errors.  Some repair
> > > +	 * functions can fix multiple data structures at once, so we have to
> > > +	 * treat sick and heal masks separately.
> > > +	 */
> > > +	unsigned int			heal_mask;
> > > +
> > >  	bool				try_harder;
> > >  	bool				has_quotaofflock;
> > >  
> > > 
