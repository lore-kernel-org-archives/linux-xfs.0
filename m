Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751801AbdJKJpy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Oct 2017 05:45:54 -0400
Date: Wed, 11 Oct 2017 05:45:53 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] generic: test race between block map change and writeback
Message-ID: <20171011094553.GB32909@bfoster.bfoster>
References: <20170831040237.16022-1-eguan@redhat.com>
 <20171009161255.GA19847@bfoster.bfoster>
 <20171010043649.GI10593@eguan.usersys.redhat.com>
 <20171010052459.GB15067@dastard>
 <20171010105622.GA23057@bfoster.bfoster>
 <20171011053025.GC15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011053025.GC15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 04:30:25PM +1100, Dave Chinner wrote:
> On Tue, Oct 10, 2017 at 06:56:22AM -0400, Brian Foster wrote:
> > On Tue, Oct 10, 2017 at 04:24:59PM +1100, Dave Chinner wrote:
> > > On Tue, Oct 10, 2017 at 12:36:49PM +0800, Eryu Guan wrote:
> > > > On Mon, Oct 09, 2017 at 12:12:55PM -0400, Brian Foster wrote:
> > > > > On Thu, Aug 31, 2017 at 12:02:37PM +0800, Eryu Guan wrote:
> > > > > > Run delalloc writes & append writes & non-data-integrity syncs
> > > > > > concurrently to test the race between block map change vs writeback.
> > > > > > 
> > > > > > This is to cover an XFS bug that data could be written to wrong
> > > > > > block and delay allocated blocks are leaked because the block map
> > > > > > was changed due to the removal of speculative allocated eofblocks
> > > > > > when writeback is in progress.
> > > > > > 
> > > > > > And this test partially mimics what lustre-racer[1] test does, using
> > > > > > which this bug was first found.
> > > > > > 
> > > > > > [1] https://git.hpdd.intel.com/?p=fs/lustre-release.git;a=tree;f=lustre/tests/racer;hb=HEAD
> > > > > > 
> > > > > > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > > > > > ---
> > > > > > 
> > > > > > This may not reproduce the bug on all hosts, but it does reproduce the XFS
> > > > > > corruption issue reliably on my different test hosts.
> > > > > > 
> > > > > 
> > > > > Was this problem fixed already or are we still waiting on a fix?
> > > > 
> > > > It's still an unfixed problem. Dave provided a test patch (which did fix
> > > > the bug for me)
> > > 
> > > The test patch I provided broken the COW writeback path, primarily
> > > because it's a separate mapping path and the change I made doesn't
> > > work at all well with it....
> > > 
> > > > then Christoph suggested a fix based on seqlock, and
> > > > things stalled there.
> > > 
> > > I had a look at doing that and got stalled on the fact that, again,
> > > the COW writeback is completely separate to the existing block
> > > mapping during writeback path and so applying a seqlock algorithm is
> > > pretty difficult.
> > > 
> > > Basically, to fix the problem, we first need to merge the COW and
> > > delalloc paths in the writepage code and then we'll have a sane base
> > > on which to apply a proper fix...
> > > 
> > > (we need to do this to get rid of the bufferhead dependency, anyway)
> > > 
> > > > (I'm happy to pick up the work, but I'm not that
> > > > familiar with all the allocation paths that could change the extent map,
> > > > so I may need some guidance and time to play with it.)
> > > 
> > > There's some black magic in amongst it all. I'll spend some time on
> > > it again over the next week and see what I come up with...
> > > 
> > 
> > Hmm, is this[1] the test patch/thread associated with this test case? If
> > so, I'm still wondering why we can't just trim the mapping to eof like
> > the previous code had effectively done for so long..? Eryu, does the
> > appended diff address this test case?
> 
> I'm not sure that is sufficient. To me addresses the symptom, not
> the root problem. The cached extent can go stale at any time, so
> we really need to ensure that cannot go unnoticed in any
> circumstance, not just EOF trimming....
> 

I agree that it may not be sufficient. But the fact remains that the
only currently reproducible component of this is a regression as of the
page writeback rework that killed off the old cluster_write() bits. I've
asked a couple times about proving out the broader design flaw of the
mapping going stale leading to a tangible problem (using
instrumentation, if necessary) without any feedback so far, so I'm going
to consider that a theoretical problem until that happens. To put it
another way, I don't think this test is sufficient validation of the
root problem. ;)

The intent is not to avoid fixing the root problem, but to suggest that
we classify it as a second part of a two part fix. I think the benefits
of doing so are twofold:

1.) The aforementioned change provides a straightforward and practical
fix for a reproducible regression (i.e., the workaround is more likely
-rc material and stable fodder).

2.) Using the simple regression fix to address this particular test
nudges us to also consider a better, more thorough test for the broader
design flaw.

I think it would be a bit of a shame to fix this kind of longstanding
design flaw using a regression test that only tests for a particular
symptom, as you put it. Simple changes to speculative preallocation in
the future could potentially render it (silently) ineffective.

> I'm working on a patch right now that unifies the writeback mapping
> mechanisms so we can apply something like a seqlock (a.k.a a
> generation number) to a cached extent, and that solves the general
> problem of caching extent lookup results without inode locks held.
> We do this in several places, and we've had problems in the past
> that we've worked around by reducing the number of cached extents
> to 1 (e.g. xfs_iomap_write_allocate()).
> 

Sounds interesting.

> Hence I think it's something we really need to solve rather than
> continuing to add case-by-case work arounds every time we have this
> problem...
> 

The workaround doesn't elide the need for the design fix. The latter can
essentially replace the former, but a workaround first allows us to fix
the regression more quickly and with limited risk to older kernels. It
looks like this regression was introduced in v4.6, thus taking over a
year to be teased out.

If we assume that you are going to continue to work out a design fix for
the root problem of the writeback mapping becoming invalid (and perhaps
I'll take a stab at another test that more thoroughly tests that
problem), do you see any problems with the patch itself? If not, do you
object to getting it posted for review in the meantime?

Brian

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
