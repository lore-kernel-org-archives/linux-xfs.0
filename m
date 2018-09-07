Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39080 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726201AbeIGEqR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Sep 2018 00:46:17 -0400
Date: Fri, 7 Sep 2018 10:08:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] mkfs: rework AG header initialisation ordering
Message-ID: <20180907000815.GI27618@dastard>
References: <20180905081932.27478-1-david@fromorbit.com>
 <20180905081932.27478-3-david@fromorbit.com>
 <20180906133123.GB3311@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180906133123.GB3311@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 06, 2018 at 09:31:24AM -0400, Brian Foster wrote:
> On Wed, Sep 05, 2018 at 06:19:30PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When observing the behaviour of an 8EB mkfs execution, I noticed
> > that a phase where there are a massive number of read/modify/write
> > cycles occurring. I didn't wait for it to complete - it was obvious
> > that it was after all the AG headers had been written. That left the
> > AGFL initialisation as the likely cause.
> > 
> > When all the AG headers don't fit in the libxfs buffer cache, the
> > AGFL init requires re-reading the AGF, the AGFL, the free space tree
> > root blocks and the rmap tree root block. They all then get
> > modified and written back out. 10 IOs per AG. When you have 8
> > million AGs, that's a lot of extra IO.
> > 
> > Change the initialisation algorithm to initialise the AGFL
> > immediately after initialising the rest of the headers and
> > calculating the minimum AGFL size for that AG. This means the
> > modifications will all hit the buffer cache and this will remove the
> > IO penalty.
> > 
> > The "worst_freelist" size calculation doesn't change from AG to AG -
> > it's based on the physical configuration of the AG, and all AGs have
> > the same configuration. hence we only need to calculate this once,
> > not for every AG. That allows us to initialise the AGFL immediately
> > after the rest of the AG has been initialised rather than in a
> > separate pass.
> > 
> > TIme to make a filesystem from scratch, using a zeroed device so the
> > force overwrite algorithms are not triggered and -K to avoid
> > discards:
> > 
> > FS size		10PB	100PB	 1EB
> > current mkfs	26.9s	214.8s	2484s
> > patched		11.3s	 70.3s	 709s
> > 
> > In both cases, the IO profile looks identical for the initial AG
> > header writeout loop. The difference is that the old code then
> > does the RMW loop to init the AGFL, and that runs at about half the
> > speed. Hence runtime of the new code is reduce by around 65-70%
> > simply by avoiding all that IO.
> > 
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> This one seems like it stands alone as a nice fixup. Were you planning
> to send this independently as a non-rfc patch?

Eventually. This hasn't gone through xfstests yet, so it may yet let
the smoke out....

> >  mkfs/xfs_mkfs.c | 40 +++++++++++++++++++++++++---------------
> >  1 file changed, 25 insertions(+), 15 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index c153592c705e..d70fbdb6b15a 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3374,7 +3374,7 @@ initialise_ag_headers(
> >  	struct xfs_mount	*mp,
> >  	struct xfs_sb		*sbp,
> >  	xfs_agnumber_t		agno,
> > -	int			*worst_freelist)
> > +	int			*freelist_size)
> >  {
> >  	struct xfs_perag	*pag = libxfs_perag_get(mp, agno);
> >  	struct xfs_agfl		*agfl;
> > @@ -3453,8 +3453,22 @@ initialise_ag_headers(
> >  		agf->agf_longest = cpu_to_be32(agsize -
> >  			XFS_FSB_TO_AGBNO(mp, cfg->logstart) - cfg->logblocks);
> >  	}
> > -	if (libxfs_alloc_min_freelist(mp, pag) > *worst_freelist)
> > -		*worst_freelist = libxfs_alloc_min_freelist(mp, pag);
> > +
> > +	/*
> > +	 * The AGFL size is the same for all AGs because all AGs have the same
> > +	 * layout. If this AG sameness ever changes in the future, we'll need to
> > +	 * revisit how we initialise the AGFLs.
> > +	 */
> 
> This is not necessarily the case if the last AG is not full size, right?
> I think the comment could point that out (and/or that this works so long
> as we don't process the last AG first).

Right. I can add that to the comment.

> BTW, libxfs_alloc_min_freelist() uses the ->pagf_levels values for the
> bno, cnt and rmap btrees to establish the freelist size, and I don't see
> where we've assigned ->pagf_levels[XFS_BTNUM_RMAPi] anywhere.

Well spotted! I'll write another patch for that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
