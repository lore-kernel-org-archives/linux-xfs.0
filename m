Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41116 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfDPAyt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 20:54:49 -0400
Date: Mon, 15 Apr 2019 17:54:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/5] xfs: hoist the already_fixed variable to the scrub
 context
Message-ID: <20190416005442.GI4752@magnolia>
References: <155537397092.27935.16073573221774618735.stgit@magnolia>
 <155537398946.27935.9233257960413346572.stgit@magnolia>
 <20190416005104.GI29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416005104.GI29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Tue, Apr 16, 2019 at 10:51:04AM +1000, Dave Chinner wrote:
> On Mon, Apr 15, 2019 at 05:19:49PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Now that we no longer memset the scrub context, we can move the
> > already_fixed variable into the scrub context's state flags instead of
> > passing around pointers to separate stack variables.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Minor comment below, otherwise
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> > index 60359e7de930..1b23bf141438 100644
> > --- a/fs/xfs/scrub/scrub.h
> > +++ b/fs/xfs/scrub/scrub.h
> > @@ -63,16 +63,17 @@ struct xfs_scrub {
> >  	void				*buf;
> >  	uint				ilock_flags;
> >  
> > -	/* See the XCHK state flags below. */
> > +	/* See the XCHK/XREP state flags below. */
> >  	unsigned int			flags;
> >  
> >  	/* State tracking for single-AG operations. */
> >  	struct xchk_ag			sa;
> >  };
> >  
> > -/* XCHK state flags */
> > +/* XCHK/XREP state flags */
> >  #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
> >  #define XCHK_HAS_QUOTAOFFLOCK	(1 << 1)  /* we hold the quotaoff lock */
> > +#define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
> >  
> 
> Can you just put a comment here saying xchk flags grow from the
> bottom up, XREP grow from the top down?

Ok, will do.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
