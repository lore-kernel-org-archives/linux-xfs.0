Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3728B7F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 11:37:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 083C1304032
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 09:37:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id L6CajFQpiw3i4VH7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 09:37:12 -0700 (PDT)
Date: Wed, 29 Oct 2014 12:37:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v5] xfs: rework zero range to prevent invalid i_size
	updates
Message-ID: <20141029163701.GA14410@bfoster.bfoster>
References: <1413824781-10733-1-git-send-email-bfoster@redhat.com>
	<20141029002253.GE16186@dastard> <20141029012411.GF16186@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141029012411.GF16186@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 29, 2014 at 12:24:11PM +1100, Dave Chinner wrote:
> On Wed, Oct 29, 2014 at 11:22:53AM +1100, Dave Chinner wrote:
> > On Mon, Oct 20, 2014 at 01:06:21PM -0400, Brian Foster wrote:
> > > The zero range operation is analogous to fallocate with the exception of
> > > converting the range to zeroes. E.g., it attempts to allocate zeroed
> > > blocks over the range specified by the caller. The XFS implementation
> > > kills all delalloc blocks currently over the aligned range, converts the
> > > range to allocated zero blocks (unwritten extents) and handles the
> > > partial pages at the ends of the range by sending writes through the
> > > pagecache.
> > > 
> > > The current implementation suffers from several problems associated with
> > > inode size. If the aligned range covers an extending I/O, said I/O is
> > > discarded and an inode size update from a previous write never makes it
> > > to disk. Further, if an unaligned zero range extends beyond eof, the
> > > page write induced for the partial end page can itself increase the
> > > inode size, even if the zero range request is not supposed to update
> > > i_size (via KEEP_SIZE, similar to an fallocate beyond EOF).
> > > 
> > > The latter behavior not only incorrectly increases the inode size, but
> > > can lead to stray delalloc blocks on the inode. Typically, post-eof
> > > preallocation blocks are either truncated on release or inode eviction
> > > or explicitly written to by xfs_zero_eof() on natural file size
> > > extension. If the inode size increases due to zero range, however,
> > > associated blocks leak into the address space having never been
> > > converted or mapped to pagecache pages. A direct I/O to such an
> > > uncovered range cannot convert the extent via writeback and will BUG().
> > > For example:
> > > 
> > > $ xfs_io -fc "pwrite 0 128k" -c "fzero -k 1m 54321" <file>
> > > ...
> > > $ xfs_io -d -c "pread 128k 128k" <file>
> > > <BUG>
> > > 
> > > If the entire delalloc extent happens to not have page coverage
> > > whatsoever (e.g., delalloc conversion couldn't find a large enough free
> > > space extent), even a full file writeback won't convert what's left of
> > > the extent and we'll assert on inode eviction.
> > > 
> > > Rework xfs_zero_file_space() to avoid buffered I/O for partial pages.
> > > Use the existing hole punch and prealloc mechanisms as primitives for
> > > zero range. This implementation is not efficient nor ideal as we
> > > writeback dirty data over the range and remove existing extents rather
> > > than convert to unwrittern. The former writeback, however, is currently
> > > the only mechanism available to ensure consistency between pagecache and
> > > extent state. Even a pagecache truncate/delalloc punch prior to hole
> > > punch has lead to inconsistencies due to racing with writeback.
> > > 
> > > This provides a consistent, correct implementation of zero range that
> > > survives fsstress/fsx testing without assert failures. The
> > > implementation can be optimized from this point forward once the
> > > fundamental issue of pagecache and delalloc extent state consistency is
> > > addressed.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > v5:
> > > - Further simplify to eliminate delalloc block punch.
> > 
> > This now causes xfs/053 to fail, probably because it changes the
> > behaviour to actually write the file and hence change EOF. Can you
> > please check that this is working correctly, and if so submit
> > patches to change xfs/053 to expect the file size to change
> > and contain the correct data?
> 
> Hmm, it appears that I tested the wrong "old kernel" when checking
> for regression. 3.18-rc2 also fails, so we need fixes for the
> xfs/053 test, not this patch....
> 

It's not clear to me what you mean by fixes for the xfs/053 test...

xfs/053 was intended to emphasize the partial writeback of an extent
leading to stale data exposure problem. We had a chat a while ago about
the possibility of stale data exposure after a crash at just the right
time between delalloc extent conversion and writeback. That test was
intended to expose that problem in sort of a hacky way by virtue of the
partial writeback that might occur due to file allocation operations.
Hole punch happens to expose this problem, fzero is now allocated via
hole punch and thus exposes it as well. I think I called this out as a
side effect in one of the previous versions of this patch.

As far as xfs/053 goes, it just uses falloc operations to reproduce the
stale data problem. Now that I think of it, I could look into using
something like sync_file_range() to reproduce in xfs/053 instead. Either
way, I would expect xfs/053 to fail as such until we address the general
extent conversion/writeback problem. I sent the test at the time as I
simply happened to come across it and wanted to make sure the test case
wasn't lost (as opposed to it being any kind of regression test for
fzero).

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
