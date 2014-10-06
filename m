Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5FDE17F4E
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 15:29:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1C9AAC002
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 13:29:29 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7rdg8skiYPzDuHwn for <xfs@oss.sgi.com>;
	Mon, 06 Oct 2014 13:29:24 -0700 (PDT)
Date: Tue, 7 Oct 2014 07:29:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix zero range i_size problems
Message-ID: <20141006202921.GA2301@dastard>
References: <1412255533-8357-1-git-send-email-bfoster@redhat.com>
	<20141006131111.GA61966@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141006131111.GA61966@bfoster.bfoster>
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

On Mon, Oct 06, 2014 at 09:11:11AM -0400, Brian Foster wrote:
> On Thu, Oct 02, 2014 at 09:12:13AM -0400, Brian Foster wrote:
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
> > Update xfs_zero_file_space() to forego using buffered I/O for partial
> > pages. Instead, convert the block aligned (rather than page aligned)
> > range to unwritten extents, update the partial blocks on disk and use
> > existing pagecache functionality to ensure cached pages are consistent
> > with data on disk.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > This passes xfstests and survived an overnight fsx run (+300m ops) on a
> > 1k fsb fs. The tradeoff that I've observed from this implementation is
> > that fzero is now also likely to trigger the problem described in the
> > recently posted xfs/053 test:
> > 
> > http://oss.sgi.com/archives/xfs/2014-09/msg00473.html
> > 
> > This is slightly unfortunate, but as I understand it that problem is
> > more fundamentally associated with extent conversion and writeback vs.
> > any particular fs operation that might expose it.
> > 
> > Brian
> > 
> 
> I spent the past few days trying to reproduce and nail down some of the
> delalloc related asserts reproduced by generic/269 and discovered that
> zero range is at least one cause of the problem. This patch actually
> addresses that particular problem, yet introduces another similar
> variant of the problem.
> 
> The original cause is "leakage" of speculative preallocation blocks into
> the addressable range of the file (within eof) without any pages
> associated with the delalloc extent. This means that it isn't
> necessarily sufficient to writeback a particular delalloc range to
> convert it. This sets a landmine for direct I/O or inode eviction to
> step on when it comes time to perform I/O over the range or clean the
> inode.
> 
> For example:
> 
> # xfs_io -fc "pwrite 0 128k" -c "fzero -k 1m 54321" /mnt/file
> wrote 131072/131072 bytes at offset 0
> 128 KiB, 32 ops; 0.0000 sec (786.164 MiB/sec and 201257.8616 ops/sec)
> # xfs_io -d -c "pread 128k 128k" /mnt/file 
> Segmentation fault
> 
> The first command creates a delalloc extent with preallocation and then
> runs a non-file-size-extending zero range beyond the end of the file
> with an unaligned end offset (note that doing the zero range within the
> same process is required to ensure prealloc isn't trimmed by close()).
> As discussed above, this results in an internal I/O that increases
> i_size and leaks the previous preallocation within eof.

This is a bug within the zero range code - we should never try to
sub-block zeroing beyond EOF unless we are extending the file size
and need to zero blocks/prealloc that already exists. Extending the
file should only be done through xfs_setattr_size(). If the range to
be zeroed beyond EOF is smaller than a block, then we should just
prealloc the entire block because the EOF extension (whenever it is
done) will do IO that results in the block being fully zeroed,
anyway.

> The patch here addresses the zero range problem simply by avoiding
> xfs_iozero(). It introduces a similar problem...

Right, same conclusion, different reasoning. ;)

> > +	/*
> > +	 * Writeback the partial pages if either the start or end is not page
> > +	 * aligned to prevent writeback races with partial block zeroing.
> > +	 * truncate_pagecache_range() handles partial page zeroing if the pages
> > +	 * are cached.
> > +	 */
> > +	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(offset + len)) {
> > +		filemap_write_and_wait_range(VFS_I(ip)->i_mapping, offset,
> > +					     start_boundary);
> > +		filemap_write_and_wait_range(VFS_I(ip)->i_mapping, end_boundary,
> > +					     offset + len);
> > +	}
> > +	truncate_pagecache_range(VFS_I(ip), offset, offset + len - 1);
> 
> ... here because the request can still fail with ENOSPC during block
> allocation after we have truncated pagecache for the entire range but
> before we might have killed the delalloc blocks in the range. This leads
> to the same delalloc blocks not covered by pagecache problem.

Another reason for punching the delalloc blocks first. ;)

> I suspect the fix is to truncate the pagecache in smaller portions as we
> proceed through the function, but I'll have to give it a try. I *think*
> it's important to handle the truncate before making any extent
> modifications lest weird things happen with writeback.

Or we could just punch the delalloc blocks on failure. i.e. punching
delalloc blocks is used only for error handling (like in the buffer
write error handling case). It will at least "zero" the delalloc
portions of the range on failure...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
