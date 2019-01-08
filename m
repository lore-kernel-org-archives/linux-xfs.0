Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbfAHO5F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jan 2019 09:57:05 -0500
Date: Tue, 8 Jan 2019 09:57:03 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [Bug 202053] [xfstests generic/464]: XFS corruption and
 Assertion failed: 0, file: fs/xfs/xfs_super.c, line: 985
Message-ID: <20190108145702.GC6330@bfoster>
References: <bug-202053-201763@https.bugzilla.kernel.org/>
 <bug-202053-201763-R7nWMjQIjy@https.bugzilla.kernel.org/>
 <20190104123217.GA16751@bfoster>
 <20190105213120.GS4205@dastard>
 <20190106215737.GT4205@dastard>
 <20190107144114.GB5506@bfoster>
 <20190107191101.GC5506@bfoster>
 <20190108055518.GW4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108055518.GW4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org

On Tue, Jan 08, 2019 at 04:55:18PM +1100, Dave Chinner wrote:
> On Mon, Jan 07, 2019 at 02:11:01PM -0500, Brian Foster wrote:
> > On Mon, Jan 07, 2019 at 09:41:14AM -0500, Brian Foster wrote:
> > > On Mon, Jan 07, 2019 at 08:57:37AM +1100, Dave Chinner wrote:
> > > For example, I'm concerned that something like sustained buffered writes
> > > could completely break the writeback imap cache by continuously
> > > invalidating it. I think speculative preallocation should help with this
> > > in the common case by already spreading those writes over fewer
> > > allocations, but do we care enough about the case where preallocation
> > > might be turned down/off to try and restrict where we bump the sequence
> > > number (to > i_size changes, for example)? Maybe it's not worth the
> > > trouble just to optimize out a shared ilock cycle and lookup, since the
> > > extent list is still in-core after all.
> > > 
> > 
> > A follow up FWIW... a quick test of some changes to reuse the existing
> > mechanism doesn't appear to show much of a problem in this regard, even
> > with allocsize=4k. I think another thing that minimizes impact is that
> > even if we end up revalidating the same imap over and over, the ioend
> > construction logic is distinct and based on contiguity. IOW, writeback
> > is still sending the same sized I/Os for contiguous blocks...
> 
> Ah, I think you discovered that the delay between write(),
> ->writepages() and the incoming write throttling in
> balance_dirty_pages() creates a large enough dirty page window that
> we avoid lock-stepping write and writepage in a determental way....
> 

That certainly may be another factor, but note that I am able to
reproduce a significant number of spurious invalidations and thus a
significant increase in imap lookups (in the allocsize=4k case). Taking
another look at some trace data, I also see sequences of xfs_iomap_alloc
and xfs_map_blocks_found events in lockstep, though those sequences
aren't terribly long and aren't sustained (which perhaps may be to your
point wrt to buffered write throttling).

I think the larger point is that the following factors altogether:

- buffered write throttling (via dirty pages)
- speculative preallocation in XFS throttling fork changes in the common
  sequential write (file copy) use case
- cached map lookup being fairly cheap (i.e., no extra I/Os) relative to
  I/O
- spurious cached map revals not affecting I/O sizes

... mean that this isn't some blatant problem that makes global
invalidation as such a nonstarter for common usage patterns. I wouldn't
rule out other problems precisely because the spurious invals are there,
as noted above, but so far it seems it's not worth worrying about or
overcomplicating things unless/until we find a use case and workload
noticeably affected by it.

Brian

> AFAICT, the only time we have to worry about this is if we are so
> short of memory the kernel is cleaning every page as soon as it is
> dirtied. If we get into that situation, invalidating the cached map
> is the least of our worries :P
> 
> Cheers,
> 
> dave.
> -- 
> Dave Chinner
> david@fromorbit.com
