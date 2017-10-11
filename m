Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752111AbdJKNr6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Oct 2017 09:47:58 -0400
Date: Wed, 11 Oct 2017 09:47:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] generic: test race between block map change and writeback
Message-ID: <20171011134756.GG32909@bfoster.bfoster>
References: <20170831040237.16022-1-eguan@redhat.com>
 <20171009161255.GA19847@bfoster.bfoster>
 <20171010043649.GI10593@eguan.usersys.redhat.com>
 <20171010052459.GB15067@dastard>
 <20171010105622.GA23057@bfoster.bfoster>
 <20171011053025.GC15067@dastard>
 <20171011094553.GB32909@bfoster.bfoster>
 <20171011104234.GG15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171011104234.GG15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 09:42:34PM +1100, Dave Chinner wrote:
> On Wed, Oct 11, 2017 at 05:45:53AM -0400, Brian Foster wrote:
> > On Wed, Oct 11, 2017 at 04:30:25PM +1100, Dave Chinner wrote:
> > > On Tue, Oct 10, 2017 at 06:56:22AM -0400, Brian Foster wrote:
> > > > On Tue, Oct 10, 2017 at 04:24:59PM +1100, Dave Chinner wrote:
> > > > > On Tue, Oct 10, 2017 at 12:36:49PM +0800, Eryu Guan wrote:
> > > > > > On Mon, Oct 09, 2017 at 12:12:55PM -0400, Brian Foster
> > > > > > wrote:
> > > > > > > On Thu, Aug 31, 2017 at 12:02:37PM +0800, Eryu Guan
> > > > > > > wrote:
> > > > > > > > Run delalloc writes & append writes &
> > > > > > > > non-data-integrity syncs concurrently to test the race
> > > > > > > > between block map change vs writeback.
> > > > > > > > 
> > > > > > > > This is to cover an XFS bug that data could be written
> > > > > > > > to wrong block and delay allocated blocks are leaked
> > > > > > > > because the block map was changed due to the removal
> > > > > > > > of speculative allocated eofblocks when writeback is
> > > > > > > > in progress.
> > > > > > > > 
> > > > > > > > And this test partially mimics what lustre-racer[1]
> > > > > > > > test does, using which this bug was first found.
> > > > > > > > 
> > > > > > > > [1]
> > > > > > > > https://git.hpdd.intel.com/?p=fs/lustre-release.git;a=tree;f=lustre/tests/racer;hb=HEAD
> > > > > > > > 
> > > > > > > > Signed-off-by: Eryu Guan <eguan@redhat.com> ---
> > > > > > > > 
> > > > > > > > This may not reproduce the bug on all hosts, but it
> > > > > > > > does reproduce the XFS corruption issue reliably on my
> > > > > > > > different test hosts.
> > > > > > > > 
> > > > > > > 
> > > > > > > Was this problem fixed already or are we still waiting
> > > > > > > on a fix?
> > > > > > 
> > > > > > It's still an unfixed problem. Dave provided a test patch
> > > > > > (which did fix the bug for me)
> > > > > 
> > > > > The test patch I provided broken the COW writeback path,
> > > > > primarily because it's a separate mapping path and the
> > > > > change I made doesn't work at all well with it....
> > > > > 
> > > > > > then Christoph suggested a fix based on seqlock, and
> > > > > > things stalled there.
> > > > > 
> > > > > I had a look at doing that and got stalled on the fact that,
> > > > > again, the COW writeback is completely separate to the
> > > > > existing block mapping during writeback path and so applying
> > > > > a seqlock algorithm is pretty difficult.
> > > > > 
> > > > > Basically, to fix the problem, we first need to merge the
> > > > > COW and delalloc paths in the writepage code and then we'll
> > > > > have a sane base on which to apply a proper fix...
> > > > > 
> > > > > (we need to do this to get rid of the bufferhead dependency,
> > > > > anyway)
> > > > > 
> > > > > > (I'm happy to pick up the work, but I'm not that familiar
> > > > > > with all the allocation paths that could change the extent
> > > > > > map, so I may need some guidance and time to play with
> > > > > > it.)
> > > > > 
> > > > > There's some black magic in amongst it all. I'll spend some
> > > > > time on it again over the next week and see what I come up
> > > > > with...
> > > > > 
> > > > 
> > > > Hmm, is this[1] the test patch/thread associated with this
> > > > test case? If so, I'm still wondering why we can't just trim
> > > > the mapping to eof like the previous code had effectively done
> > > > for so long..? Eryu, does the appended diff address this test
> > > > case?
> > > 
> > > I'm not sure that is sufficient. To me addresses the symptom,
> > > not the root problem. The cached extent can go stale at any
> > > time, so we really need to ensure that cannot go unnoticed in
> > > any circumstance, not just EOF trimming....
> > > 
> > 
> > I agree that it may not be sufficient. But the fact remains that
> > the only currently reproducible component of this is a regression
> > as of the page writeback rework that killed off the old
> > cluster_write() bits. I've asked a couple times about proving out
> > the broader design flaw of the mapping going stale leading to a
> > tangible problem (using instrumentation, if necessary) without any
> > feedback so far, so I'm going to consider that a theoretical
> > problem until that happens.
> 
> It's most definitely not theoretical - I can show you the scars if
> you want.  We know it's a real problem and have for years, so i see
> no need to "prove" anything here. The recent regression was
> introduced because we broke one of the badly documented bandaids
> we did years ago to solve a specific xfstests failure.
> 

It's not so much about proving it in general as opposed to doing so from
the context of writeback and also attempting to ensure we have a test
case that sufficiently verifies a fix in that context.

> Keep in mind that these bandaids were done back when nobody had the
> knowledge to realise that there was a general problem.  SGI had bled
> away all of it's original XFS expertise and most of us working on it
> only had a couple of years experience. Nobody really understood the
> big picture about any of the complex XFS code
> 
> Hence the result was that the stupid moron who kept tripping over
> the problems only knew just enough to work around the problems. He
> didn't have the knoweldge base needed to recognise there was a
> common underlying cause to many of the problems that were occurring
> in algorithms inherited from the Irix code base. We were struggling
> just to get tests to pass without data corruption or filesystem
> shutdowns being reported.
> 
> e.g. the xfs_map_buffer -> xfs_iomap_write_allocate map coherency
> problem that concurrent fsstress tests in xfstests kept tripping
> over got "fixed" like this:
> 
> commit e4143a1cf5973e3443c0650fc4c35292d3b7baa8
> Author: David Chinner <dgc@sgi.com>
> Date:   Fri Nov 23 16:29:11 2007 +1100
> 
>     [XFS] Fix transaction overrun during writeback.
>     
>     Prevent transaction overrun in xfs_iomap_write_allocate() if we race with
>     a truncate that overlaps the delalloc range we were planning to allocate.
>     
>     If we race, we may allocate into a hole and that requires block
>     allocation. At this point in time we don't have a reservation for block
>     allocation (apart from metadata blocks) and so allocating into a hole
>     rather than a delalloc region results in overflowing the transaction block
>     reservation.
>     
>     Fix it by only allowing a single extent to be allocated at a time.
>     
>     SGI-PV: 972757
>     SGI-Modid: xfs-linux-melb:xfs-kern:30005a
>     
>     Signed-off-by: David Chinner <dgc@sgi.com>
>     Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
> 
> IOWs, if we passed two maps from xfs_bmapi_read() to
> xfs_iomap_write_allocate() then the second map might be stale by
> the time we used it. The fix didn't solve the cached map problem -
> it just mitigated it to the point where it didn't cause corruption
> or shutdowns.
> 
> And so here we are, 10 years later, dealing with the same "cached
> map without locks held is stale" problems in the writeback code....
> 

Ok, thanks for the background. That suggests a broader approach is
worthwhile regardless of whether this variant is "theoretical." While I
don't have this historical context, note again that I'm not contending
we don't have (or never had) this kind of mapping issue anywhere in XFS.

> And, FWIW, it looks to me like the new COW writeback code has a
> bunch of interesting coherency issues that have been worked around
> because there isn't a general solution for ensuring cached maps are
> valid. Yeah, I tripped over XFS_BMAPI_DELALLOC today for the first
> time today and could not understand what it was there for from the
> code....
> 
> > I think it would be a bit of a shame to fix this kind of longstanding
> > design flaw using a regression test that only tests for a particular
> > symptom, as you put it. Simple changes to speculative preallocation in
> > the future could potentially render it (silently) ineffective.
> 
> As I've just mentioned, there's a bunch of existing xfstests that
> trip over the stale cached extent problem I describe above. That's
> how we found them and patched them in the first place.
> 
> > The workaround doesn't elide the need for the design fix. The latter can
> > essentially replace the former, but a workaround first allows us to fix
> > the regression more quickly and with limited risk to older kernels. It
> > looks like this regression was introduced in v4.6, thus taking over a
> > year to be teased out.
> 
> I guess the difference here is that I'm just not interested in
> trying to work around problems like this anymore. We need to
> understand and fix them properly to ensure we kill them dead for
> good and they won't rise from the dead ten years later and bite us
> again. Then we can decide if a targetted workaround is appropriate
> as a first step for backports....
> 

The following items:

1.) The severity of the bug as a file/fs corruption vector.

2.) We don't yet have a fix more than a month after the regression was
reported and diagnosed to a fairly trivial change in behavior associated
with the writeback rework.

3.) We have a regression test that the workaround addresses and from
feedback so far, the only known problem it has is it doesn't implement a
generic enough solution to prevent the same problem we've had
historically in other places.

4.) We need to backport whatever fix we end up with back to v4.6 (before
reflink/COW was relevant) and to distro kernels.

5.) A quick glance at the commit log alone of the rfc to fix whatever is
wrong with writeback mapping (to facilitate the broader fix) shows that
it is notably more complex than the workaround.

... are together, more than enough to suggest to me that a workaround is
worthwhile. The writeback problem really should have been fixed by now
and doing so doesn't mean we have to stop pursuing a broader fix for
related problems.

I think I'm going to post that patch in the meantime and as suggested
earlier, I'll try to play around with another test in addition to this
one to see if we can have something that reproduces any other writeback
problems outside of the scope of speculative preallocation.

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
