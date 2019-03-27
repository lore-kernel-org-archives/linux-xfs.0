Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:32255 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727500AbfC0BW5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Mar 2019 21:22:57 -0400
Date: Wed, 27 Mar 2019 12:22:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/475 deadlock?
Message-ID: <20190327012253.GG23020@dastard>
References: <20190320174551.GA1186@magnolia>
 <20190320175922.GB29010@bfoster>
 <20190320214938.GU23020@dastard>
 <20190321121152.GA33001@bfoster>
 <20190321211051.GV23020@dastard>
 <20190321215307.GA35644@bfoster>
 <20190321235045.GW23020@dastard>
 <20190322120136.GA37888@bfoster>
 <20190324230327.GZ23020@dastard>
 <20190325123458.GA51547@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325123458.GA51547@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 25, 2019 at 08:34:59AM -0400, Brian Foster wrote:
> On Mon, Mar 25, 2019 at 10:03:27AM +1100, Dave Chinner wrote:
> > > IOW, wouldn't a log force from busy extent context always occur with
> > > locked buffers joined to a transaction? If so, then doesn't the active
> > > transaction hold a bli reference and prevent such items from being
> > > "freed" in log completion context (i.e. xfs_buf_item_unpin()) if they
> > > happened to be pinned? Perhaps I'm missing something...
> > 
> > ... now you've looked at it in more detail that I have.
> > 
> > What you've described is why it was considered to be safe, but now
> > we have things like defered AGFL block freeing that pick up and drop
> > the AGF lock repeatedly as the single transaction rolls and -
> > eventually - starts calling xfs_trans_reserve() on transaction roll.
> > That's something we never used to do.  It may still be safe, but it
> > is unclear to me how this all interacts in the presence of
> > filesystem shutdown conditions.....
> > 
> 
> Some higher level thoughts...
> 
> IME, we've had these kind of quirky shutdown issues since I've been
> working on XFS. Similar to log recovery, it's a rarely enough hit
> scenario that keeping it robust and reliable across new
> features/development is a bit of a challenge. LR is certainly more
> critical and I think our test coverage in both areas has improved
> significantly over the past few years.

Log recovery and shutdown have _always_ been a source of bugs, and
there are some particular parts of the code that are more
problematic than others. e.g. Inode cluster flushing error/shutdown
handling has been a regular source of bugs over the years.

And, yes, we do hammer on them a lot more than we ever had and so
iwe are slowly peeling the onion and finding the imore subtle bugs
that have been there for many, many years.

> The point is just that I don't think it's worth getting too crazy by
> trying to audit every possible path to a sync log force or changing how
> various bits of core infrastructure work just to accommodate a very rare
> shutdown case.

I think we still have to look at them and understand if the way the
problematic shutdowns are done make any sense anymore. They might
have when the shutdown was added, but lots of the code is very
different now, as is the shutdown handling. Hence we might have
shutdowns in places we don't need them anymore (e.g.
xfs_trans_read_buf_map(), xfs_iflush_cluster(), etc).

> If this turns out to be the only place we require an
> object lock in the synchronous log force sequence, it might be best to
> find a way to remove it (as Darrick posited earlier). If not, it might
> also be more useful to figure a way to detect the "sync log force while
> holding (certain) locks" pattern dynamically and provide some assertions
> against it to improve test coverage going forward.  I'm not quite sure
> how to do that off the top of my head. I'll have to think about that
> some more.

That's what lockdep contexts are supposed to be used for. Perhaps
something similar to the memory reclaim contexts could be done here
- locks taken both above and below the shutdown state trigger
warnings....

> I'm sure we could always come up with a test that reproduces
> this particular instance of the problem more reliably, but that test
> becomes far less useful once we address the particular instance it
> reproduces in the kernel.

*nod*

That's why tests like generic/475 are so good - they keep finding
new bugs in shutdown/recovery...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
