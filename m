Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:1933 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932433AbdKBAqm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 20:46:42 -0400
Date: Thu, 2 Nov 2017 11:46:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: truncate pagecache before writeback in
 xfs_setattr_size()
Message-ID: <20171102004624.GU5858@dastard>
References: <20171101140540.21542-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171101140540.21542-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 01, 2017 at 10:05:40PM +0800, Eryu Guan wrote:
> On truncate down, if new size is not block size aligned, we zero the
> rest of block to avoid exposing stale data to user, and
> iomap_truncate_page() skips zeroing if the range is already in
> unwritten state or a hole. Then we writeback from on-disk i_size to
> the new size if this range hasn't been written to disk yet, and
> truncate page cache beyond new EOF and set in-core i_size.
> 
> The problem is that we could write data between di_size and newsize
> before removing the page cache beyond newsize, as the extents may
> still be in unwritten state right after a buffer write. As such, the
> page of data that newsize lies in has not been zeroed by page cache
> invalidation before it is written, and xfs_do_writepage() hasn't
> triggered it's "zero data beyond EOF" case because we haven't
> updated in-core i_size yet. Then a subsequent mmap read could see
> non-zeros past EOF.
> 
> I occasionally see this in fsx runs in fstests generic/112, a
> simplified fsx operation sequence is like (assuming 4k block size
> xfs):
> 
>   fallocate 0x0 0x1000 0x0 keep_size
>   write 0x0 0x1000 0x0
>   truncate 0x0 0x800 0x1000
>   punch_hole 0x0 0x800 0x800
>   mapread 0x0 0x800 0x800
> 
> where fallocate allocates unwritten extent but doesn't update
> i_size, buffer write populates the page cache and extent is still
> unwritten, truncate skips zeroing page past new EOF and writes the
> page to disk, punch_hole invalidates the page cache, at last mapread
> reads the block back and sees non-zero beyond EOF.
> 
> Fix it by moving truncate_setsize() to before writeback so the page
> cache invalidation zeros the partial page at the new EOF. This also
> triggers "zero data beyond EOF" in xfs_do_writepage() at writeback
> time, because newsize has been set and page straddles the newsize.
> 
> Also fixed the wrong 'end' param of filemap_write_and_wait_range()
> call while we're at it, the 'end' is inclusive and should be
> 'newsize - 1'.
> 
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Looks sane, but I haven't tested it yet.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
