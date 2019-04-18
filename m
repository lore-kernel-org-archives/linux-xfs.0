Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41534 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729331AbfDRAJe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 20:09:34 -0400
Date: Wed, 17 Apr 2019 17:07:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] xfs: track delayed allocation reservations across
Message-ID: <20190418000729.GD5072@magnolia>
References: <155546519998.176278.8300210828717055034.stgit@magnolia>
 <155546520611.176278.16800498529488238281.stgit@magnolia>
 <20190417214031.GR29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417214031.GR29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 18, 2019 at 07:40:31AM +1000, Dave Chinner wrote:
> On Tue, Apr 16, 2019 at 06:40:06PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a percpu counter to track the number of blocks directly reserved for
> > delayed allocations on the data device.  This counter (in contrast to
> > i_delayed_blks) does not track allocated CoW staging extents or anything
> > going on with the realtime device.  It will be used in the upcoming
> > summary counter scrub function to check the free block counts without
> > having to freeze the filesystem or walk all the inodes to find the
> > delayed allocations.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hmmm. Given that a lot of modifcations to this counter are going to
> be large quantities (much greater than the percpu counter batch size
> of 32) this effectively just degrades to spin lock protected global
> counter, yes? This is the reason we have XFS_FDBLOCKS_BATCH (1024)
> for the free block percpu counter so that changes from frequent
> updates via lots of smallish write()s don't need to take the global
> aggregation lock very often...
> 
> So I'm guessing that this counter needs similar treatment for
> scalability on large machines. If it doesn't then an atomic64_t
> is all that is necessary here...

I wrote a silly little test to grow the delalloc count by one from a
number of threads.  It does cause an observable increase in time waiting
for spinlocks.  Since the only users of this counter are unmount check
and the fscounter scrubber I think it's safe to use XFS_FDBLOCKS_BATCH
for this because we aren't making any decisions that need high precision
to maintain correct functioning of the system.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
