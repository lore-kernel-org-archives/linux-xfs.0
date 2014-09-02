Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-for-3.17-rc3,
	created. xfs-for-linus-3.17-rc1-13183-g41b9d72
Message-Id: <20140902021933.51E217F74@oss.sgi.com>
Date: Mon,  1 Sep 2014 21:19:32 -0500 (CDT)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, xfs-for-3.17-rc3 has been created
        at  41b9d7263ea1e270019c5d04fa0ab15db50b9725 (commit)

- Log -----------------------------------------------------------------
commit 41b9d7263ea1e270019c5d04fa0ab15db50b9725
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Sep 2 12:12:53 2014 +1000

    xfs: trim eofblocks before collapse range
    
    xfs_collapse_file_space() currently writes back the entire file
    undergoing collapse range to settle things down for the extent shift
    algorithm. While this prevents changes to the extent list during the
    collapse operation, the writeback itself is not enough to prevent
    unnecessary collapse failures.
    
    The current shift algorithm uses the extent index to iterate the in-core
    extent list. If a post-eof delalloc extent persists after the writeback
    (e.g., a prior zero range op where the end of the range aligns with eof
    can separate the post-eof blocks such that they are not written back and
    converted), xfs_bmap_shift_extents() becomes confused over the encoded
    br_startblock value and fails the collapse.
    
    As with the full writeback, this is a temporary fix until the algorithm
    is improved to cope with a volatile extent list and avoid attempts to
    shift post-eof extents.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 1669a8ca2105968f660cf7d84ba38fd18075cd99
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 2 12:12:53 2014 +1000

    xfs: xfs_file_collapse_range is delalloc challenged
    
    If we have delalloc extents on a file before we run a collapse range
    opertaion, we sync the range that we are going to collapse to
    convert delalloc extents in that region to real extents to simplify
    the shift operation.
    
    However, the shift operation then assumes that the extent list is
    not going to change as it iterates over the extent list moving
    things about. Unfortunately, this isn't true because we can't hold
    the ILOCK over all the operations. We can prevent new IO from
    modifying the extent list by holding the IOLOCK, but that doesn't
    prevent writeback from running....
    
    And when writeback runs, it can convert delalloc extents is the
    range of the file prior to the region being collapsed, and this
    changes the indexes of all the extents in the file. That causes the
    collapse range operation to Go Bad.
    
    The right fix is to rewrite the extent shift operation not to be
    dependent on the extent list not changing across the entire
    operation, but this is a fairly significant piece of work to do.
    Hence, as a short-term workaround for the problem, sync the entire
    file before starting a collapse operation to remove all delalloc
    ranges from the file and so avoid the problem of concurrent
    writeback changing the extent list.
    
    Diagnosed-and-Reported-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit ca446d880c399bb31301e7d8eefbd7fe3c504c4e
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Sep 2 12:12:53 2014 +1000

    xfs: don't log inode unless extent shift makes extent modifications
    
    The file collapse mechanism uses xfs_bmap_shift_extents() to collapse
    all subsequent extents down into the specified, previously punched out,
    region. This function performs some validation, such as whether a
    sufficient hole exists in the target region of the collapse, then shifts
    the remaining exents downward.
    
    The exit path of the function currently logs the inode unconditionally.
    While we must log the inode (and abort) if an error occurs and the
    transaction is dirty, the initial validation paths can generate errors
    before the transaction has been dirtied. This creates an unnecessary
    filesystem shutdown scenario, as the caller will cancel a transaction
    that has been marked dirty.
    
    Modify xfs_bmap_shift_extents() to OR the logflags bits as modifications
    are made to the inode bmap. Only log the inode in the exit path if
    logflags has been set. This ensures we only have to cancel a dirty
    transaction if modifications have been made and prevents an unnecessary
    filesystem shutdown otherwise.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 7d4ea3ce63a6bc532abb334c469c18481798af8c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 2 12:12:53 2014 +1000

    xfs: use ranged writeback and invalidation for direct IO
    
    Now we are not doing silly things with dirtying buffers beyond EOF
    and using invalidation correctly, we can finally reduce the ranges of
    writeback and invalidation used by direct IO to match that of the IO
    being issued.
    
    Bring the writeback and invalidation ranges back to match the
    generic direct IO code - this will greatly reduce the perturbation
    of cached data when direct IO and buffered IO are mixed, but still
    provide the same buffered vs direct IO coherency behaviour we
    currently have.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 834ffca6f7e345a79f6f2e2d131b0dfba8a4b67a
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 2 12:12:52 2014 +1000

    xfs: don't zero partial page cache pages during O_DIRECT writes
    
    Similar to direct IO reads, direct IO writes are using
    truncate_pagecache_range to invalidate the page cache. This is
    incorrect due to the sub-block zeroing in the page cache that
    truncate_pagecache_range() triggers.
    
    This patch fixes things by using invalidate_inode_pages2_range
    instead.  It preserves the page cache invalidation, but won't zero
    any pages.
    
    cc: stable@vger.kernel.org
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 85e584da3212140ee80fd047f9058bbee0bc00d5
Author: Chris Mason <clm@fb.com>
Date:   Tue Sep 2 12:12:52 2014 +1000

    xfs: don't zero partial page cache pages during O_DIRECT writes
    
    xfs is using truncate_pagecache_range to invalidate the page cache
    during DIO reads.  This is different from the other filesystems who
    only invalidate pages during DIO writes.
    
    truncate_pagecache_range is meant to be used when we are freeing the
    underlying data structs from disk, so it will zero any partial
    ranges in the page.  This means a DIO read can zero out part of the
    page cache page, and it is possible the page will stay in cache.
    
    buffered reads will find an up to date page with zeros instead of
    the data actually on disk.
    
    This patch fixes things by using invalidate_inode_pages2_range
    instead.  It preserves the page cache invalidation, but won't zero
    any pages.
    
    [dchinner: catch error and warn if it fails. Comment.]
    
    cc: stable@vger.kernel.org
    Signed-off-by: Chris Mason <clm@fb.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 22e757a49cf010703fcb9c9b4ef793248c39b0c2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 2 12:12:51 2014 +1000

    xfs: don't dirty buffers beyond EOF
    
    generic/263 is failing fsx at this point with a page spanning
    EOF that cannot be invalidated. The operations are:
    
    1190 mapwrite   0x52c00 thru    0x5e569 (0xb96a bytes)
    1191 mapread    0x5c000 thru    0x5d636 (0x1637 bytes)
    1192 write      0x5b600 thru    0x771ff (0x1bc00 bytes)
    
    where 1190 extents EOF from 0x54000 to 0x5e569. When the direct IO
    write attempts to invalidate the cached page over this range, it
    fails with -EBUSY and so any attempt to do page invalidation fails.
    
    The real question is this: Why can't that page be invalidated after
    it has been written to disk and cleaned?
    
    Well, there's data on the first two buffers in the page (1k block
    size, 4k page), but the third buffer on the page (i.e. beyond EOF)
    is failing drop_buffers because it's bh->b_state == 0x3, which is
    BH_Uptodate | BH_Dirty.  IOWs, there's dirty buffers beyond EOF. Say
    what?
    
    OK, set_buffer_dirty() is called on all buffers from
    __set_page_buffers_dirty(), regardless of whether the buffer is
    beyond EOF or not, which means that when we get to ->writepage,
    we have buffers marked dirty beyond EOF that we need to clean.
    So, we need to implement our own .set_page_dirty method that
    doesn't dirty buffers beyond EOF.
    
    This is messy because the buffer code is not meant to be shared
    and it has interesting locking issues on the buffer dirty bits.
    So just copy and paste it and then modify it to suit what we need.
    
    Note: the solutions the other filesystems and generic block code use
    of marking the buffers clean in ->writepage does not work for XFS.
    It still leaves dirty buffers beyond EOF and invalidations still
    fail. Hence rather than play whack-a-mole, this patch simply
    prevents those buffers from being dirtied in the first place.
    
    cc: <stable@kernel.org>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
