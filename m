Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:25466 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727263AbfDDWIt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Apr 2019 18:08:49 -0400
Date: Fri, 5 Apr 2019 09:08:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: force writes to delalloc regions to unwritten
Message-ID: <20190404220845.GE26298@dastard>
References: <20190318215014.GA21231@bfoster>
 <20190319180249.GS4929@magnolia>
 <20190319202537.GR23020@dastard>
 <20190320120204.GA28268@bfoster>
 <20190320211019.GS23020@dastard>
 <20190321122740.GB33001@bfoster>
 <20190322015240.GX23020@dastard>
 <20190322124615.GB37888@bfoster>
 <20190403223809.GL5147@magnolia>
 <20190404125054.GA38253@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404125054.GA38253@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Apr 04, 2019 at 08:50:54AM -0400, Brian Foster wrote:
> On Wed, Apr 03, 2019 at 03:38:09PM -0700, Darrick J. Wong wrote:
> > On Fri, Mar 22, 2019 at 08:46:15AM -0400, Brian Foster wrote:
> > > On Fri, Mar 22, 2019 at 12:52:40PM +1100, Dave Chinner wrote:
> > > > On Thu, Mar 21, 2019 at 08:27:40AM -0400, Brian Foster wrote:
> > > > > On Thu, Mar 21, 2019 at 08:10:19AM +1100, Dave Chinner wrote:
> > > > > > On Wed, Mar 20, 2019 at 08:02:05AM -0400, Brian Foster wrote:
> > > > > > > On Wed, Mar 20, 2019 at 07:25:37AM +1100, Dave Chinner wrote:
> > > > > > > > > > The broader point is that by controlling writeback ordering, we can
> > > > > > > > > > explicitly demonstrate stale data exposure. If fixed properly, we should
> > > > > > > > > > never expect stale data exposure even in the event of out of order
> > > > > > > > > > writeback completion, regardless of the cause.
> > > > > > > > > 
> > > > > > > > > Agree.  Even if s_f_r is a giant trash fire, if we're exposing stale
> > > > > > > > > disk contents it's game over anyway and we ought to fix it.
> > > > > > > > 
> > > > > > > > Well, that's exactly the problem with SFR, isn't it? The dirty data
> > > > > > > > is outside the range the user asks to sync and the implementation
> > > > > > > > doesn't go anywhere near the filesystem so we can't actually do the
> > > > > > > > right thing here. So we are left to either hack fixes around a
> > > > > > > > shitty, broken interface and everyone pays the penalty, or we ignore
> > > > > > > > it. We've simply ignored it for the past 10+ years because it really
> > > > > > > > can't be used safely for it's intended purposes (as everyone who
> > > > > > > > tries to use it finds out eventually)...
> > > > > > > > 
> > > > > > > 
> > > > > > > Just to make this abundantly clear, there is nothing unique, magic or
> > > > > > > special required of sync_file_range() to reproduce this stale data
> > > > > > > exposure. See the following variation of a command sequence from the
> > > > > > > fstest I posted the other day:
> > > > > > > 
> > > > > > > ...
> > > > > > > # xfs_io -fc "pwrite 0 68k" -c fsync -c "pwrite 96k 4k" \
> > > > > > > 	-c "fpunch 96k 4k" <file>
> > > > > > > ...
> > > > > > > # hexdump <file>
> > > > > > > 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
> > > > > > > *
> > > > > > > 0011000 abab abab abab abab abab abab abab abab
> > > > > > > *
> > > > > > > 0018000 0000 0000 0000 0000 0000 0000 0000 0000
> > > > > > > *
> > > > > > > 0019000
> > > > > > > 
> > > > > > > Same problem, and it can be reproduced just as easily with a reflink or
> > > > > > > even an overlapping direct I/O.
> > > > > > 
> > > > > > How does overlapping direct IO cause stale data exposure given that
> > > > > > it uses unwritten extent allocation? That, of course, is ignoring
> > > > > > the fact that the result of overlapping concurent direct IO is, by
> > > > > > definition, undefined and an application bug if it occurs....
> > > > > > 
> > > > > 
> > > > > It's overlapping a buffered write and so starts with a flush instead of
> > > > 
> > > > Ok, but that's not the normal usage of the phrase "overlapping
> > > > direct IO".  Overlapping direct IO means two concurrent direct IOs
> > > > to the same LBA range in the device underlying the filesystem. i.e.
> > > > they overlap in both the temporal and physical (device LBA) domains.
> > > > 
> > > > Subtle difference, yes, but a very important one.
> > > > 
> > > 
> > > Yeah, I just referenced it in passing and was unclear. The point is just
> > > that there are multiple vectors to the problem, some of which are sane
> > > sequences and some apparently not, and I'd rather not get caught up in
> > > the minutiae of why some of those sequences are not sane. I'm trying to
> > > see if we can find a solution to the fundamental data exposure problem.
> > 
> > Is there a way to increase the amount of writeback?  Say for example
> > that we have a delalloc reservation for blocks 0-9, and writeback asks
> > us to write back block 7.  If we succeed at converting the entire
> > 10-block reservation into a real extent, why can't we come back and say
> > "Hey, we also need to flush the pages for blocks 0-6,8-9"?  Are we going
> > to need something like that for blocksize > pagesize filesystems too?
> > 
> 
> That might be possible in various places. In fact, I think we used to do
> something like this in XFS (perhaps not for this purpose). I just jumped
> back to v2.6.32 and see that the xfs_cluster_write() mechanism still
> exists at that point down in the ->writepage() path.

We /really/ don't want to go back to that. This caused us to have to
essentially implement write_cache_pages() inside ->writepage.

If we want to expand the writeback range, (i.e. move the offset we
start at) then we need to do that in xfs_vm_writepages(), before we
call write_cache_pages(). This means all the tagged writepages stuff
will continue to work, and we don't end up doing redundant page
cache lookups because we're trying to write back the same range from
two different places.

> I'm not sure if doing that alone is worth the effort if you consider
> it's more of a mitigation than a solution to the underlying problem.
> Once we convert the associated delalloc extent, we're open to stale data
> exposure (assuming we're not protected by on-disk EOF and whatnot) until
> all of the remaining pages over the extent are written back, whether
> that occurs in the current writeback cycle or a subsequent one.

If we were to do a read iomap lookup in xfs_vm_writepages() we could
determine if the delalloc conversion would allocate a range outside
the current write that is bing flushed, and either modify the
writeback control range/offset to match the delalloc extent.

however, this runs the risk of breaking all the fairness algorithms
in high level writeback, so we'd need to be very careful about how
we extend the write range for writeback inside EOF....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
