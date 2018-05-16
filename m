Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:62016 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751028AbeEPWgZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 18:36:25 -0400
Date: Thu, 17 May 2018 08:36:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/22] xfs: recover AG btree roots from rmap data
Message-ID: <20180516223622.GY23861@dastard>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642365045.1556.6221144971800322852.stgit@magnolia>
 <20180516085151.GT23861@dastard>
 <20180516183729.GL23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516183729.GL23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 16, 2018 at 11:37:29AM -0700, Darrick J. Wong wrote:
> On Wed, May 16, 2018 at 06:51:52PM +1000, Dave Chinner wrote:
> > On Tue, May 15, 2018 at 03:34:10PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Add a helper function to help us recover btree roots from the rmap data.
> > > Callers pass in a list of rmap owner codes, buffer ops, and magic
> > > numbers.  We iterate the rmap records looking for owner matches, and
> > > then read the matching blocks to see if the magic number & uuid match.
> > > If so, we then read-verify the block, and if that passes then we retain
> > > a pointer to the block with the highest level, assuming that by the end
> > > of the call we will have found the root.  This will be used to reset the
> > > AGF/AGI btree root fields during their rebuild procedures.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> > > +	/* Ignore this block if it's lower in the tree than we've seen. */
> > > +	if (fab->root != NULLAGBLOCK &&
> > > +	    xfs_btree_get_level(btblock) < fab->height)
> > > +		goto out;
> > > +
> > > +	/* Make sure we pass the verifiers. */
> > > +	bp->b_ops->verify_read(bp);
> > > +	if (bp->b_error)
> > > +		goto out;
> > > +	fab->root = agbno;
> > > +	fab->height = xfs_btree_get_level(btblock) + 1;
> > > +	*found_it = true;
> > > +
> > > +	trace_xfs_repair_findroot_block(mp, ri->sc->sa.agno, agbno,
> > > +			be32_to_cpu(btblock->bb_magic), fab->height - 1);
> > > +out:
> > > +	xfs_trans_brelse(ri->sc->tp, bp);
> > 
> > So we release the buffer once we've found it, which also unlocks it.
> > That means when we come back to it later, it may have been accessed
> > and changed by something else and no longer be the block we are
> > looking for. How do you protect against this sort of race given we
> > are unlocking the buffer? Perhaps it should be held on the fab
> > structure, and released when a better candidate is found?
> 
> The two callers of this function are the AGF and AGI repair functions.
> AGF repair holds the locked AGF buffer, and AGI repair holds the locked
> AGF & AGI buffers, which should be enough to prevent anyone else from
> accessing the AG btrees.  They keep the all the AG header buffers locked
> until they're completely finished with rebuilding the headers (i.e.
> xfs_scrub_teardown) and it's safe for the shape to change.
> 
> How about I add to the comment for this function:
> 
> /*
>  * The caller must lock the applicable per-AG header buffers (AGF, AGI)
>  * to prevent other threads from changing the shape of the btrees that
>  * we are looking for.  It must maintain those locks until it's safe for
>  * other threads to change the btrees' shapes.
>  */

That's helpful. :) Can you sprinkle some checks like
ASSERT(xfs_buf_islocked(agbp)) to remind readers of the
leaf/callback functions that they expect the AGF/AGI to be locked on
entry?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
