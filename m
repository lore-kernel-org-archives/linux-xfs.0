Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:30507 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731172AbfCaWZC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Mar 2019 18:25:02 -0400
Date: Mon, 1 Apr 2019 09:24:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: merge adjacent io completions of the same type
Message-ID: <20190331222456.GN23020@dastard>
References: <20190327030550.GZ1183@magnolia>
 <20190327030634.GA1183@magnolia>
 <20190328141009.GB17056@bfoster>
 <20190328151744.GB18833@magnolia>
 <20190328210628.GJ23020@dastard>
 <20190329125129.GA11664@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329125129.GA11664@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 29, 2019 at 08:51:29AM -0400, Brian Foster wrote:
> On Fri, Mar 29, 2019 at 08:06:28AM +1100, Dave Chinner wrote:
> > On Thu, Mar 28, 2019 at 08:17:44AM -0700, Darrick J. Wong wrote:
> > > On Thu, Mar 28, 2019 at 10:10:10AM -0400, Brian Foster wrote:
> > > > On Tue, Mar 26, 2019 at 08:06:34PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > When we're processing an ioend on the list of io completions, check to
> > > > > see if the next items on the list are both adjacent and of the same
> > > > > type.  If so, we can merge the completions to reduce transaction
> > > > > overhead.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > > > 
> > > > I'm curious of the value of this one... what situations allow for
> > > > batching on the ioend completion side that we haven't already accounted
> > > > for in the ioend construction side?
> > > 
> > > I was skeptical too, but Dave (I think?) pointed out that writeback can
> > > split into 1GB chunks so it actually is possible to end up with adjacent
> > > ioends.
> > 
> > When there amount of writeback for a single file exceeds the
> > measured bandwidth of the device, or there are a number of dirty files
> > that the writeback bandwidthis shared between, then writeback code
> > breaks up the amount of data that can be written in any single
> > writepages call to any single inode. This can get down as low as
> > MIN_WRITEBACK_PAGES (which ends up being 4MB of pages), and so we
> > can end up writing large files in lots of very small chunks.
> > 
> 
> Ok, so in general this has more to do with working around higher level
> writeback behavior than improving our own ioend batching/mapping from a
> single ->writepages() instance.

I wouldn't say "working around", because the higher level stuff is
avoiding inode writeback starvation which is entirely necessary. The
MIN_WRITEBACK_PAGES limit is essentially a mechanism to prevent
falling into thrashing with small IOs to lots of files and becoming
seek bound rather than bandwidth bound on spinning disks.  It's only
when there are so many writers that dirty page throttling occurs
before a process can dirty 4MB of pages that we see writeback chunks
drop below this limit, and that's where the IO being really
efficient at cleaning pages really matters....

> Taking a look at the writeback code, this sounds more relevant to
> background writeback because integrity writeback uses the LONG_MAX chunk
> size for ->writepages() calls. Background writeback calculates a chunk
> size based on bandwidth, etc. as you've noted and looks like it rotors
> across dirty inodes in a given superblock until a higher level writeback
> count is achieved. Makes sense.

*nod*

> 
> > > So I wrote this patch and added a tracepoint, and lo it
> > > actually did trigger when there's a lot of data to flush out, and we
> > > succeed at allocating a single extent for the entire delalloc reservation.
> > 
> > I'd expect it to fire more when there are lots of large files being
> > written concurently than just for single files (i.e. the writeback
> > interleaving fragmentation problem that speculative delalloc
> > avoids).
> > 
> > > > The latter already batches until we
> > > > cross a change in fork type, extent state, or a break in logical or
> > > > physical contiguity. The former looks like it follows similar logic for
> > > > merging with the exceptions of allowing for merges of physically
> > > > discontiguous extents and disallowing merges of those with different
> > > > append status. That seems like a smallish window of opportunity to me..
> > > > am I missing something?
> > > 
> > > Yep, it's a smallish window; small discontiguous writes don't benefit
> > > here at all.
> > > 
> > > > If that is the gist but there is enough benefit for the more lenient
> > > > merging, I also wonder whether it would be more efficient to try and
> > > > also accomplish that on the construction side rather than via completion
> > > > post-processing. For example, could we abstract a single ioend to cover
> > > > an arbitrary list of bio/page -> sector mappings with the same higher
> > > > level semantics? We already have a bio chaining mechanism, it's just
> > > > only used for when a bio is full. Could we reuse that for dealing with
> > > > physical discontiguity?
> > 
> > While possible, I think that's way more complex and problematic than
> > merging successful completions optimistically...
> > 
> 
> Note again that the suggestion above applies only to ioend batching
> within a single ->writepages() instance as opposed to across multiple
> writebacks. It's less relevant given the context you added above around
> potentially optimizing background writeback completion across multiple
> ->writepages() calls.

Ah, ok, I was thinking you were talking about cross-writepages()
clustering....

> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 3619e9e8d359..c9bed8f3cb90 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -654,13 +654,13 @@ xfs_add_to_ioend(
>  	if (!wpc->ioend ||
>  	    wpc->fork != wpc->ioend->io_fork ||
>  	    wpc->imap.br_state != wpc->ioend->io_state ||
> -	    sector != bio_end_sector(wpc->ioend->io_bio) ||
>  	    offset != wpc->ioend->io_offset + wpc->ioend->io_size) {
>  		if (wpc->ioend)
>  			list_add(&wpc->ioend->io_list, iolist);
>  		wpc->ioend = xfs_alloc_ioend(inode, wpc->fork,
>  				wpc->imap.br_state, offset, bdev, sector);
> -	}
> +	} else if (sector != bio_end_sector(wpc->ioend->io_bio))
> +		xfs_chain_bio(wpc->ioend, wbc, bdev, sector);

That might make sense from a completion optimisation POV, but it's
going to have a significant impact on IO latency. i.e. we now delay
the completion of the first IO to after we've seeked to the second
IO and compelted that (and potentially many more). This will
increase the latency of cleaning dirty pages on spinning disks, so i
suspect this would be detrimental under heavy memory pressure and
lots of dirty pages to write back....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
