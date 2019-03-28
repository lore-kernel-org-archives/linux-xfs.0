Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:56461
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbfC1VGd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Mar 2019 17:06:33 -0400
Date: Fri, 29 Mar 2019 08:06:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: merge adjacent io completions of the same type
Message-ID: <20190328210628.GJ23020@dastard>
References: <20190327030550.GZ1183@magnolia>
 <20190327030634.GA1183@magnolia>
 <20190328141009.GB17056@bfoster>
 <20190328151744.GB18833@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328151744.GB18833@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 28, 2019 at 08:17:44AM -0700, Darrick J. Wong wrote:
> On Thu, Mar 28, 2019 at 10:10:10AM -0400, Brian Foster wrote:
> > On Tue, Mar 26, 2019 at 08:06:34PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > When we're processing an ioend on the list of io completions, check to
> > > see if the next items on the list are both adjacent and of the same
> > > type.  If so, we can merge the completions to reduce transaction
> > > overhead.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > 
> > I'm curious of the value of this one... what situations allow for
> > batching on the ioend completion side that we haven't already accounted
> > for in the ioend construction side?
> 
> I was skeptical too, but Dave (I think?) pointed out that writeback can
> split into 1GB chunks so it actually is possible to end up with adjacent
> ioends.

When there amount of writeback for a single file exceeds the
measured bandwidth of the device, or there are a number of dirty files
that the writeback bandwidthis shared between, then writeback code
breaks up the amount of data that can be written in any single
writepages call to any single inode. This can get down as low as
MIN_WRITEBACK_PAGES (which ends up being 4MB of pages), and so we
can end up writing large files in lots of very small chunks.

> So I wrote this patch and added a tracepoint, and lo it
> actually did trigger when there's a lot of data to flush out, and we
> succeed at allocating a single extent for the entire delalloc reservation.

I'd expect it to fire more when there are lots of large files being
written concurently than just for single files (i.e. the writeback
interleaving fragmentation problem that speculative delalloc
avoids).

> > The latter already batches until we
> > cross a change in fork type, extent state, or a break in logical or
> > physical contiguity. The former looks like it follows similar logic for
> > merging with the exceptions of allowing for merges of physically
> > discontiguous extents and disallowing merges of those with different
> > append status. That seems like a smallish window of opportunity to me..
> > am I missing something?
> 
> Yep, it's a smallish window; small discontiguous writes don't benefit
> here at all.
> 
> > If that is the gist but there is enough benefit for the more lenient
> > merging, I also wonder whether it would be more efficient to try and
> > also accomplish that on the construction side rather than via completion
> > post-processing. For example, could we abstract a single ioend to cover
> > an arbitrary list of bio/page -> sector mappings with the same higher
> > level semantics? We already have a bio chaining mechanism, it's just
> > only used for when a bio is full. Could we reuse that for dealing with
> > physical discontiguity?

While possible, I think that's way more complex and problematic than
merging successful completions optimistically...

In reality, we need some numbers to prove whether this is worthwhile
or not. If we can't find obvious workloads where it actually makes a
difference (either in throughput, IO latency or CPU usage) then,
like most things, we write off as an interesting experiement that
didn't provide the benefit we thought it might...

> The other thing is that directio completions look very similar to
> writeback completions, including the potential for having the thundering
> herds pounding on the ILOCK.  I was thinking about refactoring those to
> use the per-inode queue as a next step, though the directio completion
> paths are murky.

Yeah, i think there can be benefit here for AIO+DIO when issuing
multiple concurrent sequential writes. I'm looking at making xfs-fsr
use AIO so it can pipeline the data movement (rather than being
synchronous) and I can see having completion batching for unwritten
extent conversion having a positive effect on such operations....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
