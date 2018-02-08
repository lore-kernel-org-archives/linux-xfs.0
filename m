Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:59249 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750961AbeBHWtd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Feb 2018 17:49:33 -0500
Date: Fri, 9 Feb 2018 09:49:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: account only rmapbt-used blocks against rmapbt
 perag res
Message-ID: <20180208224930.GG20266@dastard>
References: <20180205174601.51574-1-bfoster@redhat.com>
 <20180205174601.51574-5-bfoster@redhat.com>
 <20180207000350.GO4849@magnolia>
 <20180207144934.GB9789@bfoster.bfoster>
 <20180208022037.GF5433@magnolia>
 <20180208131938.GC13929@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180208131938.GC13929@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Feb 08, 2018 at 08:19:38AM -0500, Brian Foster wrote:
> On Wed, Feb 07, 2018 at 06:20:37PM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 07, 2018 at 09:49:35AM -0500, Brian Foster wrote:
> > > On Tue, Feb 06, 2018 at 04:03:50PM -0800, Darrick J. Wong wrote:
> > > We've since applied it to things like the finobt (which I'm still not
> > > totally convinced was the right thing to do based on the vague
> > > justification for it), which kind of blurs the line between where it's
> > > a requirement vs. nice-to-have/band-aid for me.
> > 
> > I think the finobt reservation is required: Suppose you have a
> > filesystem with a lot of empty files, a lot of single-block files, and a
> > lot of big files such that there's no free space anywhere.  Suppose
> > further that there's an AG where every finobt block is exactly full,
> > there's an inode chunk with exactly 64 inodes in use, and every block in
> > that AG is in use (meaning zero AGFL blocks).  Now find one of the empty
> > inodes in that totally-full chunk and try to free it.  Truncation
> > doesn't free up any blocks, but we have to expand the finobt to add the
> > record for the chunk.  We can't find any blocks in that AG so we shut
> > down.
> > 
> 
> Yes, I suppose the problem makes sense (I wish the original commit had
> such an explanation :/). We do have the transaction block reservation in
> the !perag res case, but I suppose we're susceptible to the same global
> reservation problem as above.
> 
> Have we considered a per-ag + per-transaction mechanism at any point
> through all of this?

That's kind of what I was suggesting to Darrick on IRC a while back.
i.e. the per-ag reservation of at least 4-8MB of space similar to
the global reservation pool we have, and when it dips below that
threshold we reserve more free space.

But yeah, it doesn't completely solve the finobt growth at ENOSPC
problem, but then again the global reservation pool doesn't
completely solve the "run out of free space for IO completion
processing at ENOSPC" problem either. That mechanism is just a
simple solution that is good enough for 99.99% of XFS users, and if
you are outside this there's a way to increase the pool size to make
it more robust (e.g. for those 4096 CPU MPI jobs all doing
concurrent DIO writeback at ENOSPC).

So the question I'm asking here is this: do we need a "perfect
solution" or does a simple, small, dynamic reservation pool provide
"good enough protection" for the vast majority of our users?

> I ask because something that has been in the back
> of my mind (which I think was an idea from Dave originally) for a while
> is to simply queue inactive inode processing when it can't run at a
> particular point in time, but that depends on actually knowing whether
> we can proceed to inactivate an inode or not.

Essentially defer the xfs_ifree() processing step from
xfs_inactive(), right? i.e. leave the inode on the unlinked list
until we've got space to free it? This could be determined by a
simple AG space/resv space check before removign the inode from
the unlinked list...

FWIW, if we keep a list of inactivated but not yet freed inodes for
background processing, we could allocate inodes from that list, too,
simply by removing them from the unlinked list...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
