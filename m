Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:25746 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756206AbdJKFt0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 01:49:26 -0400
Date: Wed, 11 Oct 2017 16:30:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] generic: test race between block map change and writeback
Message-ID: <20171011053025.GC15067@dastard>
References: <20170831040237.16022-1-eguan@redhat.com>
 <20171009161255.GA19847@bfoster.bfoster>
 <20171010043649.GI10593@eguan.usersys.redhat.com>
 <20171010052459.GB15067@dastard>
 <20171010105622.GA23057@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171010105622.GA23057@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Oct 10, 2017 at 06:56:22AM -0400, Brian Foster wrote:
> On Tue, Oct 10, 2017 at 04:24:59PM +1100, Dave Chinner wrote:
> > On Tue, Oct 10, 2017 at 12:36:49PM +0800, Eryu Guan wrote:
> > > On Mon, Oct 09, 2017 at 12:12:55PM -0400, Brian Foster wrote:
> > > > On Thu, Aug 31, 2017 at 12:02:37PM +0800, Eryu Guan wrote:
> > > > > Run delalloc writes & append writes & non-data-integrity syncs
> > > > > concurrently to test the race between block map change vs writeback.
> > > > > 
> > > > > This is to cover an XFS bug that data could be written to wrong
> > > > > block and delay allocated blocks are leaked because the block map
> > > > > was changed due to the removal of speculative allocated eofblocks
> > > > > when writeback is in progress.
> > > > > 
> > > > > And this test partially mimics what lustre-racer[1] test does, using
> > > > > which this bug was first found.
> > > > > 
> > > > > [1] https://git.hpdd.intel.com/?p=fs/lustre-release.git;a=tree;f=lustre/tests/racer;hb=HEAD
> > > > > 
> > > > > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > > > > ---
> > > > > 
> > > > > This may not reproduce the bug on all hosts, but it does reproduce the XFS
> > > > > corruption issue reliably on my different test hosts.
> > > > > 
> > > > 
> > > > Was this problem fixed already or are we still waiting on a fix?
> > > 
> > > It's still an unfixed problem. Dave provided a test patch (which did fix
> > > the bug for me)
> > 
> > The test patch I provided broken the COW writeback path, primarily
> > because it's a separate mapping path and the change I made doesn't
> > work at all well with it....
> > 
> > > then Christoph suggested a fix based on seqlock, and
> > > things stalled there.
> > 
> > I had a look at doing that and got stalled on the fact that, again,
> > the COW writeback is completely separate to the existing block
> > mapping during writeback path and so applying a seqlock algorithm is
> > pretty difficult.
> > 
> > Basically, to fix the problem, we first need to merge the COW and
> > delalloc paths in the writepage code and then we'll have a sane base
> > on which to apply a proper fix...
> > 
> > (we need to do this to get rid of the bufferhead dependency, anyway)
> > 
> > > (I'm happy to pick up the work, but I'm not that
> > > familiar with all the allocation paths that could change the extent map,
> > > so I may need some guidance and time to play with it.)
> > 
> > There's some black magic in amongst it all. I'll spend some time on
> > it again over the next week and see what I come up with...
> > 
> 
> Hmm, is this[1] the test patch/thread associated with this test case? If
> so, I'm still wondering why we can't just trim the mapping to eof like
> the previous code had effectively done for so long..? Eryu, does the
> appended diff address this test case?

I'm not sure that is sufficient. To me addresses the symptom, not
the root problem. The cached extent can go stale at any time, so
we really need to ensure that cannot go unnoticed in any
circumstance, not just EOF trimming....

I'm working on a patch right now that unifies the writeback mapping
mechanisms so we can apply something like a seqlock (a.k.a a
generation number) to a cached extent, and that solves the general
problem of caching extent lookup results without inode locks held.
We do this in several places, and we've had problems in the past
that we've worked around by reducing the number of cached extents
to 1 (e.g. xfs_iomap_write_allocate()).

Hence I think it's something we really need to solve rather than
continuing to add case-by-case work arounds every time we have this
problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
