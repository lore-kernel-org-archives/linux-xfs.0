Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:59566 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbfCODkm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 23:40:42 -0400
Date: Fri, 15 Mar 2019 14:40:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: force writes to delalloc regions to unwritten
Message-ID: <20190315034038.GK23020@dastard>
References: <155259893433.30230.6566995969675098053.stgit@magnolia>
 <155259894630.30230.10064390935593758177.stgit@magnolia>
 <20190314230841.GJ23020@dastard>
 <20190315031302.GF4929@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190315031302.GF4929@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 14, 2019 at 08:13:03PM -0700, Darrick J. Wong wrote:
> On Fri, Mar 15, 2019 at 10:08:41AM +1100, Dave Chinner wrote:
> > On Thu, Mar 14, 2019 at 02:29:06PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > When writing to a delalloc region in the data fork, commit the new
> > > allocations (of the da reservation) as unwritten so that the mappings
> > > are only marked written once writeback completes successfully.  This
> > > fixes the problem of stale data exposure if the system goes down during
> > > targeted writeback of a specific region of a file, as tested by
> > > generic/042.
> > 
> > So what does this do to buffered sequential and random write
> > performance?
> 
> Whacks it quite a bit -- 10-20% depending on how fast the storage is in
> the first place.  I barely noticed on my usb thumb drive, however. :P

I figured that would be the case, with random writes being much
worse...

> That said, shovelling that many writes through the completion workqueues
> creates a thundering herd problem on the ILOCK so maybe it wouldn't be
> so bad if we simply dumped the completions on a per-inode queue and only
> had one thread handling the completions.
> 
> (As we've been discussing on IRC.)

*nod*

> > Next, if the entire delalloc extent being allocated is beyond the
> > on-disk EOF (typical for extending sequential buffered writes), why
> > do we want those to be allocated as unwritten? i.e. isn't "allocate
> > as unwritten" only necessary for delalloc extent allocation
> > inside EOF?
> 
> I wasn't sure on this point -- for delalloc extents that start at or
> above EOF, we can continue go straight to real like we do today.  We
> still have to use the setfilesize transaction to update isize on disk,
> so it probably doesn't make that big of a difference.

We have to keep the setfilesize completion code, anyway (think
partial last block file extensions), but the setfilesize stuff is
much, much lower overhead than unwritten extent conversion so i
think we want to avoid unwritten extents where-ever they are
unnecessary.


> If the delalloc extent crosses EOF then I think it makes sense to map it
> in as unwritten, issue the write, and convert the extent to real during
> io completion, and not split it up just to avoid having unwritten
> extents past EOF.

Yup, makes sense. For a sequential write, they should always be
beyond EOF. For anything else, we use unwritten.

> IOWS, there wasn't any particular intentionality behind having the code
> not set PREALLOC if the extent is totally beyond EOF; this was just the
> bare minimum to get a discussion started. :)

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
