Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42357 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdJDRvO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2017 13:51:14 -0400
Date: Wed, 4 Oct 2017 10:51:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/25] xfs: create helpers to scan an allocation group
Message-ID: <20171004175111.GR6503@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706330006.19351.11655503679984316123.stgit@magnolia>
 <20171004004603.GU3666@dastard>
 <20171004035853.GL6503@magnolia>
 <20171004055956.GA3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004055956.GA3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2017 at 04:59:56PM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 08:58:53PM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 04, 2017 at 11:46:03AM +1100, Dave Chinner wrote:
> > > On Tue, Oct 03, 2017 at 01:41:40PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Add some helpers to enable us to lock an AG's headers, create btree
> > > > cursors for all btrees in that allocation group, and clean up
> > > > afterwards.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/scrub/common.c |  173 +++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/scrub/common.h |   10 +++
> > > >  fs/xfs/scrub/scrub.c  |    4 +
> > > >  fs/xfs/scrub/scrub.h  |   21 ++++++
> > > >  4 files changed, 208 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > > > index a84ba19..b056c9d 100644
> > > > --- a/fs/xfs/scrub/common.c
> > > > +++ b/fs/xfs/scrub/common.c
> > > > @@ -44,6 +44,7 @@
> > > >  #include "scrub/scrub.h"
> > > >  #include "scrub/common.h"
> > > >  #include "scrub/trace.h"
> > > > +#include "scrub/btree.h"
> > > >  
> > > >  /* Common code for the metadata scrubbers. */
> > > >  
> > > > @@ -298,6 +299,178 @@ xfs_scrub_set_incomplete(
> > > >  	trace_xfs_scrub_incomplete(sc, __return_address);
> > > >  }
> > > >  
> > > > +/*
> > > > + * AG scrubbing
> > > > + *
> > > > + * These helpers facilitate locking an allocation group's header
> > > > + * buffers, setting up cursors for all btrees that are present, and
> > > > + * cleaning everything up once we're through.
> > > > + */
> > > > +
> > > > +/* Grab all the headers for an AG. */
> > > > +int
> > > > +xfs_scrub_ag_read_headers(
> > > > +	struct xfs_scrub_context	*sc,
> > > > +	xfs_agnumber_t			agno,
> > > > +	struct xfs_buf			**agi,
> > > > +	struct xfs_buf			**agf,
> > > > +	struct xfs_buf			**agfl)
> > > > +{
> > > > +	struct xfs_mount		*mp = sc->mp;
> > > > +	int				error;
> > > > +
> > > > +	error = xfs_ialloc_read_agi(mp, sc->tp, agno, agi);
> > > > +	if (error)
> > > > +		goto out;
> > > > +
> > > > +	error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, agf);
> > > > +	if (error)
> > > > +		goto out;
> > > > +	if (!*agf) {
> > > > +		error = -ENOMEM;
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	error = xfs_alloc_read_agfl(mp, sc->tp, agno, agfl);
> > > > +	if (error)
> > > > +		goto out;
> > > > +
> > > > +out:
> > > > +	return error;
> > > > +}
> > > 
> > > It's not immediately obvious what releases the buffers on error.
> > > Maybe add a comment to say cleanup/release on error is unconditional
> > > through xfs_scrub_ag_free()?
> > > 
> > > Hmmm - now there's a question - is the reference we get here freed
> > > through cancelling the fake transaction, or via the manual
> > > xfs_trans_brelse() call in the free function? which one happens
> > > first? add that to the comment?
> > 
> > The AG headers /should/ always be released by the xfs_trans_brelse calls
> > in the ag_free function, with a failsafe that the trans_cancel will dump
> > anything else that we came across during our check, just in case all
> > heck broke loose while we were checking.
> 
> Ok, comments. :P

Done.

> > > And given this locks out the AG from allocation for an arbitrary
> > > length of time, I'm wondering if we should add a flag into the pag
> > > somewhere to say "being scrubbed" so the extent and inode allocation
> > > code can skip over this AG and no block trying to lock it...
> > 
> > That might be a good idea for a end-of-series enhancement.
> 
> *nod*
> 
> > 
> > Though it could use a little more engineering thought -- what about
> > a more general ability to mark an AG offline?  ISTR we discussed growing
> > the ability to shut down an AG (rather than the whole FS) if scrub finds
> > problems, and/or being able to control that from spaceman.  The patch
> > was "spaceman: AG state control".
> 
> Well, only a small part of making an AG offline is preventing
> allocation from blocking in it.  What I suggested above is
> completely internal functionality that users would never even know
> about, so if we later want to add offline AG controls we can rework
> the implementation scrub uses to fit into that model....

Yes, I think that sounds fairly straightforward.

> > xfs_scrub has an -e option that allows the admin to specify what happens
> > on an error.  Right now it'll just shut down the filesystem, but
> > presumably it could react to a per-ag metadata problem by shutting down
> > the AG.
> 
> Not that simple, I'm afraid. Think about modifying a directory that
> has blocks that span multiple AGs. If we mark an AG as offline, then
> what do we do with an attempt to modify that directory block? Even
> if we can read it, do we allow the modification to proceed? How do
> we even know ahead of time that a directory has blocks in an offline
> AG?  And if the AG is shut down, then the attempt to read the
> directory block will get EIO, which will cause a dirty transaction
> cancellation, which will cause a filesystem wide shutdown...
> 
> Let's not complicate a simple optimisation specific to scrub by
> trying to make it work wth blue-sky functionality that requires us
> to solve a bunch of "OMFG HARD!" problems we haven't even thought
> about yet, let alone have answers for....

Heh, ok, no more OMFG HARD than there already is. :)

--D

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
