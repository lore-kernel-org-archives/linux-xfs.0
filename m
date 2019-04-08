Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:62100 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726223AbfDHARs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Apr 2019 20:17:48 -0400
Date: Mon, 8 Apr 2019 10:17:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: force writes to delalloc regions to unwritten
Message-ID: <20190408001741.GG26298@dastard>
References: <20190320120204.GA28268@bfoster>
 <20190320211019.GS23020@dastard>
 <20190321122740.GB33001@bfoster>
 <20190322015240.GX23020@dastard>
 <20190322124615.GB37888@bfoster>
 <20190403223809.GL5147@magnolia>
 <20190404125054.GA38253@bfoster>
 <20190404220845.GE26298@dastard>
 <20190405112441.GA43111@bfoster>
 <20190405151232.GY5147@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190405151232.GY5147@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Apr 05, 2019 at 08:12:32AM -0700, Darrick J. Wong wrote:
> On Fri, Apr 05, 2019 at 07:24:44AM -0400, Brian Foster wrote:
> > On Fri, Apr 05, 2019 at 09:08:45AM +1100, Dave Chinner wrote:
> > > On Thu, Apr 04, 2019 at 08:50:54AM -0400, Brian Foster wrote:
> > > If we want to expand the writeback range, (i.e. move the offset we
> > > start at) then we need to do that in xfs_vm_writepages(), before we
> > > call write_cache_pages(). This means all the tagged writepages stuff
> > > will continue to work, and we don't end up doing redundant page
> > > cache lookups because we're trying to write back the same range from
> > > two different places.
> > > 
> > 
> > IMO, messing around with writeback like this is a mitigation and/or a
> > contributer to a broader solution, not a fundamental fix by itself. For
> > example, I could see doing something like that if we already put proper
> > writeback vs. append transaction ordering in place and we identify
> > certain corner cases where we want to prevent delaying an on-disk i_size
> > update for too long because a user indirectly triggered writeback of a
> > high index page.

*nod*

Yeah, the problem is when we come to really large files on large
memory machines where there might be gigabytes of dirty pages over a
relatively slow disk...

> > > > I'm not sure if doing that alone is worth the effort if you consider
> > > > it's more of a mitigation than a solution to the underlying problem.
> > > > Once we convert the associated delalloc extent, we're open to stale data
> > > > exposure (assuming we're not protected by on-disk EOF and whatnot) until
> > > > all of the remaining pages over the extent are written back, whether
> > > > that occurs in the current writeback cycle or a subsequent one.
> > > 
> > > If we were to do a read iomap lookup in xfs_vm_writepages() we could
> > > determine if the delalloc conversion would allocate a range outside
> > > the current write that is bing flushed, and either modify the
> > > writeback control range/offset to match the delalloc extent.
> > > 
> > > however, this runs the risk of breaking all the fairness algorithms
> > > in high level writeback, so we'd need to be very careful about how
> > > we extend the write range for writeback inside EOF....
> > > 
> > 
> > Indeed. The more I think about this, the more I think we'd have an
> > easier time trying to schedule the on-disk i_size update vs. trying to
> > control the size and range of writeback in all possible scenarios. The
> > former would still require non-trivial tracking and logic, but that's
> > something writeback control described above could actually help with.
> >
> > For example, we don't currently have any way to track "stale" state of
> > just allocated but not yet fully written extents. If we established a
> > rule that we always wrote back such extents in entirety and via a single
> > ioend, then writeback completion code would simply need to check for
> > delalloc extents within in-core eof to determine when it's safe to
> > update on-disk eof.

The problem with this is that it either limits the size of the
allocation we can make (due to writeback chunk size) or we break the
writeback fairness algorithms by having to write back allocation
sized chunks...

> > If there are cases where we determine we can't
> > writeback an entire delalloc extent because of some fairness reasons or
> > whatever, we could decide to only physically allocate the subset of that
> > delalloc extent that we can write back rather than the whole thing
> > (trading off stale data exposure for some increased fragmentation). That
> > way writeback completion still sees existence of delalloc blocks and
> > knows to hold off on the on-disk size update.

The moment we get concurrent writes we are going to interleave and
fragment the files with this approach. It's the large speculative
delalloc beyond EOF that prevents fragmentation in the this case, so
the moment we decide that we aren't going to allocate the entire
delalloc extent we essentially throw away a significant amount of
the benefit that the speculative delalloc provides us with.

> > One challenge with an approach like that is if we do skip completion
> > time on-disk i_size updates, we'd have to make sure that those updates
> > still happen eventually if the address space happens to change outside
> > of writeback. For example, if those remaining dirty delalloc pages
> > somehow end up invalidated and never become real blocks, we may never
> > see another writeback cycle on the inode and we'd need to update on-disk
> > size from some other context (in a timely fashion).
> > 
> > Of course this only deals with the append case. We'd still need to
> > select a mechanism for dealing with inside EOF allocations (such as the
> > whole write-intent thing or unwritten extents). To me, the intent thing
> > still seems like the most simple/elegant option we've discussed so far
> > because the potential for low impact. Part of me thinks that if we
> > determine we'll fall back to that approach for certain cases anyways
> > (like inside EOF allocs), it might be worth just doing that first and
> > evaluate using it unconditionally.
> 
> /me wonders if we could solve this by using a bitmap to track all the
> in-flight post-ondisk-eof writeback such that when a particular
> writeback completes it can check if there aren't any writeback at a
> lower offset still in progress and only then update the ondisk eof?
> 
> (Where "a bitmap or something" could just use another instance of Dave's
> range lock structure...)

I'm not sure we need to do that. Perhaps all we need is a new
in-core iext_tree record extent type flag. i.e. we have an
unwritten flag that mirrors the on-disk unwritten flag, but what we
are really talking about here is having a new in-memory extent state
that is "allocated but contains no data".

This flag never makes it to disk. When we allocate a delalloc region
we tag the entire extent in with this magic flag, and as IO
completes we do the equivalent of unwritten extent conversion except
it only touches the in-memory tree records. When the entire range
between the current on-disk EOF and end of this completing IO has
the "not yet written" flag cleared, we then log the EOF size change.

For non-random IO, we'll essentially just be trimming one extent and
extending another, so it should be pretty fast. If we want to add
intents (so it works inside EOF), then we can simply log a new DONE
(or UPDATE) intent every time we convert a range. That would leave
log recovery with an allocation intent plus a series of updates that
document written ranges.

This seems to me like it solves the tracking problem for both cases
and provides a simple hook for logging intent completions. It also
seems to me like it would work for direct IO, too, getting rid of
the need for unconditional unwritten extent allocation and
conversion. That's potentially a big win for database and VM folks
who want to write into sparse files safely....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
