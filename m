Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F4177F37
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 20:25:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4FAEE8F8035
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 18:25:07 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	J3uv3Nn1fOa4fDOR for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 18:25:01 -0700 (PDT)
Date: Wed, 29 Oct 2014 12:24:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5] xfs: rework zero range to prevent invalid i_size
	updates
Message-ID: <20141029012411.GF16186@dastard>
References: <1413824781-10733-1-git-send-email-bfoster@redhat.com>
	<20141029002253.GE16186@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141029002253.GE16186@dastard>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 29, 2014 at 11:22:53AM +1100, Dave Chinner wrote:
> On Mon, Oct 20, 2014 at 01:06:21PM -0400, Brian Foster wrote:
> > The zero range operation is analogous to fallocate with the exception of
> > converting the range to zeroes. E.g., it attempts to allocate zeroed
> > blocks over the range specified by the caller. The XFS implementation
> > kills all delalloc blocks currently over the aligned range, converts the
> > range to allocated zero blocks (unwritten extents) and handles the
> > partial pages at the ends of the range by sending writes through the
> > pagecache.
> > 
> > The current implementation suffers from several problems associated with
> > inode size. If the aligned range covers an extending I/O, said I/O is
> > discarded and an inode size update from a previous write never makes it
> > to disk. Further, if an unaligned zero range extends beyond eof, the
> > page write induced for the partial end page can itself increase the
> > inode size, even if the zero range request is not supposed to update
> > i_size (via KEEP_SIZE, similar to an fallocate beyond EOF).
> > 
> > The latter behavior not only incorrectly increases the inode size, but
> > can lead to stray delalloc blocks on the inode. Typically, post-eof
> > preallocation blocks are either truncated on release or inode eviction
> > or explicitly written to by xfs_zero_eof() on natural file size
> > extension. If the inode size increases due to zero range, however,
> > associated blocks leak into the address space having never been
> > converted or mapped to pagecache pages. A direct I/O to such an
> > uncovered range cannot convert the extent via writeback and will BUG().
> > For example:
> > 
> > $ xfs_io -fc "pwrite 0 128k" -c "fzero -k 1m 54321" <file>
> > ...
> > $ xfs_io -d -c "pread 128k 128k" <file>
> > <BUG>
> > 
> > If the entire delalloc extent happens to not have page coverage
> > whatsoever (e.g., delalloc conversion couldn't find a large enough free
> > space extent), even a full file writeback won't convert what's left of
> > the extent and we'll assert on inode eviction.
> > 
> > Rework xfs_zero_file_space() to avoid buffered I/O for partial pages.
> > Use the existing hole punch and prealloc mechanisms as primitives for
> > zero range. This implementation is not efficient nor ideal as we
> > writeback dirty data over the range and remove existing extents rather
> > than convert to unwrittern. The former writeback, however, is currently
> > the only mechanism available to ensure consistency between pagecache and
> > extent state. Even a pagecache truncate/delalloc punch prior to hole
> > punch has lead to inconsistencies due to racing with writeback.
> > 
> > This provides a consistent, correct implementation of zero range that
> > survives fsstress/fsx testing without assert failures. The
> > implementation can be optimized from this point forward once the
> > fundamental issue of pagecache and delalloc extent state consistency is
> > addressed.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > v5:
> > - Further simplify to eliminate delalloc block punch.
> 
> This now causes xfs/053 to fail, probably because it changes the
> behaviour to actually write the file and hence change EOF. Can you
> please check that this is working correctly, and if so submit
> patches to change xfs/053 to expect the file size to change
> and contain the correct data?

Hmm, it appears that I tested the wrong "old kernel" when checking
for regression. 3.18-rc2 also fails, so we need fixes for the
xfs/053 test, not this patch....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
