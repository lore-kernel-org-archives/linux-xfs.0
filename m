Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:13435 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753466AbeGDCZa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 22:25:30 -0400
Date: Wed, 4 Jul 2018 12:25:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/21] xfs: repair free space btrees
Message-ID: <20180704022526.GM2234@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986824747.3155.3861118263934672652.stgit@magnolia>
 <20180627032123.GF19934@dastard>
 <20180704021504.GA32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180704021504.GA32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 07:15:04PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 27, 2018 at 01:21:23PM +1000, Dave Chinner wrote:
> > On Sun, Jun 24, 2018 at 12:24:07PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Rebuild the free space btrees from the gaps in the rmap btree.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > ......
> > > +	if (error)
> > > +		goto err;
> > > +	xfs_repair_cancel_btree_extents(sc, &ra.nobtlist);
> > > +	return 0;
> > > +
> > > +err:
> > > +	xfs_repair_cancel_btree_extents(sc, &ra.nobtlist);
> > > +	if (cur)
> > > +		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> > > +	return error;
> > 
> > Error stacking here can be cleaned up - we don't need an extra stack
> > as the cursor is NULL when finished with. Hence it could just be:
> > 
> > 	/* Compute the old bnobt/cntbt blocks. */
> > 	error = xfs_repair_subtract_extents(sc, old_allocbt_blocks,
> > 			&ra.nobtlist);
> > err:
> > 	xfs_repair_cancel_btree_extents(sc, &ra.nobtlist);
> > 	if (cur)
> > 		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> 
> TBH I've been tempted for years to refactor this thing to take error
> directly rather than require this XFS_BTREE_{NO,}ERROR business.
> There's only two choices, and we nearly always decide using error == 0.

Yeah, that would make for a nice cleanup. Add it to the TODO list?
Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
