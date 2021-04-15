Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9188C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 21:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B89286100B
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 21:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbhDOVZQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Apr 2021 17:25:16 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:52239 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235093AbhDOVZQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Apr 2021 17:25:16 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 342FC114063F;
        Fri, 16 Apr 2021 07:24:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lX9Ti-009jUz-6e; Fri, 16 Apr 2021 07:24:46 +1000
Date:   Fri, 16 Apr 2021 07:24:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] xfs: support shrinking empty AGs
Message-ID: <20210415212446.GQ63242@dread.disaster.area>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
 <20210414195240.1802221-5-hsiangkao@redhat.com>
 <20210415042549.GM63242@dread.disaster.area>
 <20210415052226.GC1864610@xiangao.remote.csb>
 <20210415083312.GO63242@dread.disaster.area>
 <20210415170039.GA3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415170039.GA3122264@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=7-415B0cAAAA:8
        a=lrL-hmHVR_SrQEz9yeIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 15, 2021 at 10:00:39AM -0700, Darrick J. Wong wrote:
> On Thu, Apr 15, 2021 at 06:33:12PM +1000, Dave Chinner wrote:
> > +
> > +void
> > +xfs_perag_drop(
> 
> Naming bikeshed: should this be xfs_perag_rele to match igrab/irele?

Sure, easy enough to do.

> > +	struct xfs_perag	*pag)
> > +{
> > +	if (atomic_dec_and_test(&pag->pag_active_ref))
> > +		wake_up(&pag->pag_active_wq);
> > +}
> > +
> >  /* Check all the superblock fields we care about when reading one in. */
> >  STATIC int
> >  xfs_validate_sb_read(
> > diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> > index f79f9dc632b6..bd3a0b910395 100644
> > --- a/fs/xfs/libxfs/xfs_sb.h
> > +++ b/fs/xfs/libxfs/xfs_sb.h
> > @@ -16,11 +16,16 @@ struct xfs_perag;
> >  /*
> >   * perag get/put wrappers for ref counting
> >   */
> > -extern struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
> > -extern struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
> > -					   int tag);
> > -extern void	xfs_perag_put(struct xfs_perag *pag);
> > -extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
> > +int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
> > +struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
> > +struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
> > +				   int tag);
> > +void	xfs_perag_put(struct xfs_perag *pag);
> > +
> > +struct xfs_perag *xfs_perag_grab(struct xfs_mount *, xfs_agnumber_t);
> > +struct xfs_perag *xfs_perag_grab_tag(struct xfs_mount *, xfs_agnumber_t,
> > +				   int tag);
> > +void	xfs_perag_drop(struct xfs_perag *pag);
> >  
> >  extern void	xfs_log_sb(struct xfs_trans *tp);
> >  extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index 749faa17f8e2..a08f4253d5da 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -576,14 +576,18 @@ xchk_agf(
> >  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
> >  
> >  	/* Do the incore counters match? */
> > -	pag = xfs_perag_get(mp, agno);
> > +	pag = xfs_perag_grab(mp, agno);
> > +	if (!pag) {
> > +		error = -ENOSPC;
> > +		goto out;
> 
> This should be ENOENT, since that's the error code that scrub uses to
> indicate that the resource doesn't exist and can't be checked.

OK. I just used ENOSPC everywhere for this error as a starting
point. I didn't think too hard about what the exact error should be
for all situations, I just needed something that would stand out
from the crowd...

> >  out:
> > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > index aa874607618a..d2e3cf63d237 100644
> > --- a/fs/xfs/scrub/common.c
> > +++ b/fs/xfs/scrub/common.c
> > @@ -554,8 +554,10 @@ xchk_ag_init(
> >  }
> >  
> >  /*
> > - * Grab the per-ag structure if we haven't already gotten it.  Teardown of the
> > + * Get the per-ag structure if we haven't already gotten it.  Teardown of the
> >   * xchk_ag will release it for us.
> > + *
> > + * XXX: does this need to be a grab?
> 
> If owning the buffer lock on the AGI/AGF isn't sufficient to guarantee
> that we can get an active reference to the perag structure, then yes.

No, the buffer is just holding a passive reference to the perag, and
that alone is not enough to protect/serialise against a shrink of
offline AG operation. That's what the active references do.

I was looking at this last night - there's a bunch of cases were we
can use passive references from the buffer, but they all require a
context where there's a higher level object that pins the AG against
shrink. e.g. an inode will pin against shrink, because the existence
of an inode in cache in that AG means the AG is not empty. Shrink
cannot proceed until the inode cache for that AG has been fully
reclaimed and new lookups cannot occur. The example I used was NFS
filehandle lookups need to ESTALE without actually being able to
access the perag, so we need an active reference for xfs_iget() to
be able to populate the cache...

That said, I think as many bp->b_pag use cases possible should be
converted to active references before we take AG header buffer locks
so that the mechanism can (eventually) be used as a general "make no
modifications to the AG" mechanism, rather than just being specific
to the needs of shrink.

> > @@ -167,11 +168,13 @@ xchk_fscount_aggregate_agcounts(
> >  	fsc->fdblocks = 0;
> >  
> >  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > -		pag = xfs_perag_get(mp, agno);
> > +		pag = xfs_perag_grab(mp, agno);
> > +		if (!pag)
> > +			return -ENOSPC;
> 
> Hmmm, not sure what the proper errno is for this case.  If !pag, we know
> the AG is being torn down, but do we know if the free space counters
> have been updated?

Right, that's the question that lead me to just using ENOSPC
everywhere.

> IOWS, should we be serializing this scrubber against shrink operations?
> The usual idiom in scrub is that you'd return EDEADLOCK here, and then
> xfs_scrub_metadata will re-setup and re-run with the TRY_HARDER flag set
> so that xchk_setup_fscounters can lock the world before trying again.

We have to serialise it against shrink in some way, because the AG
could be in the process of being torn down and the agcounts may be
invalid at this point.

I'd like to see these 0..sb_agcount loops go away and get replaced
with perag iterators similar to the one you added to xfs_icache.c:

#define for_each_perag_tag(mp, next_agno, pag, tag) \
        for ((next_agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
                (pag) != NULL; \
                (next_agno) = (pag)->pag_agno + 1, \
                xfs_perag_put(pag), \
                (pag) = xfs_perag_get_tag((mp), (next_agno), (tag)))

Then all of these loops that immediately just get/grab a perag
can hide all of this mess and operate solely on perag structures.
Essentially, everywhere we pass an agno to indicate "operate on this
AG" should pass an actively referenced perag, not a raw agno. We
already do this in some places, but there's still a bunch of cleanup
needed to make this work 100% reliably.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
