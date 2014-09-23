Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-shift-extents-rework,
	created. xfs-for-linus-3.17-rc3-6-g8b5279e
Message-Id: <20140923133029.5C0777F47@oss.sgi.com>
Date: Tue, 23 Sep 2014 08:30:29 -0500 (CDT)
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

The branch, xfs-shift-extents-rework has been created
        at  8b5279e33f241a074a9c8649bba8f77a2167b798 (commit)

- Log -----------------------------------------------------------------
commit 8b5279e33f241a074a9c8649bba8f77a2167b798
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Sep 23 15:39:05 2014 +1000

    xfs: only writeback and truncate pages for the freed range
    
    xfs_free_file_space() only affects the range of the file for which space
    is being freed. It currently writes and truncates the page cache from
    the start offset of the free to EOF.
    
    Modify xfs_free_file_space() to write back and truncate page cache of
    just the range being freed.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit f71721d061e872a39b2680d13f309c1eb6893438
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Sep 23 15:39:05 2014 +1000

    xfs: writeback and inval. file range to be shifted by collapse
    
    The collapse range operation currently writes the entire file before
    starting the collapse to avoid changes in the in-core extent list due to
    writeback causing the extent count to change. Now that collapse range is
    fsb based rather than extent index based it can sustain changes in the
    extent list during the shift sequence without disruption.
    
    Modify xfs_collapse_file_space() to writeback and invalidate pages
    associated with the range of the file to be shifted.
    xfs_free_file_space() currently has similar behavior, but the space free
    need only affect the region of the file that is freed and this could
    change in the future.
    
    Also update the comments to reflect the current implementation. We
    retain the eofblocks trim permanently as a best option for dealing with
    delalloc extents. We don't shift delalloc extents because this scenario
    only occurs with post-eof preallocation (since data must be flushed such
    that the cache can be invalidated and data can be shifted). That means
    said space must also be initialized before being shifted into the
    accessible region of the file only to be immediately truncated off as
    the last part of the collapse. In other words, the eofblocks trim will
    happen anyways, we just run it first to ensure the file remains in a
    consistent state throughout the collapse.
    
    Finally, detect and fail explicitly in the event of a delalloc extent
    during the extent shift. The implementation does not support delalloc
    extents and the caller is expected to prevent this scenario in advance
    as is done by collapse.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit a979bdfea10a61dce0055b4d416d640f4f5f495e
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Sep 23 15:39:04 2014 +1000

    xfs: refactor single extent shift into xfs_bmse_shift_one() helper
    
    xfs_bmap_shift_extents() has a variety of conditions and error checks
    that make the logic difficult to follow and indent heavy. Refactor the
    loop body of this function into a new xfs_bmse_shift_one() helper. This
    simplifies the error checks, eliminates index decrement on merge hack by
    pushing the index increment down into the helper, and makes the code
    more readable by reducing multiple levels of indentation.
    
    This is a code refactor only. The behavior of extent shift and collapse
    range is not modified.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit ddb19e3180fa42362a04e86771d758be1de0bb13
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Sep 23 15:38:09 2014 +1000

    xfs: refactor shift-by-merge into xfs_bmse_merge() helper
    
    The extent shift mechanism in xfs_bmap_shift_extents() is complicated
    and handles several different, non-deterministic scenarios. These
    include extent shifts, extent merges and potential btree updates in
    either of the former scenarios.
    
    Refactor the code to be more linear and readable. The loop logic in
    xfs_bmap_shift_extents() and some initial error checking is adjusted
    slightly. The associated btree lookup and update/delete operations are
    condensed into single blocks of code. This reduces the number of
    btree-specific blocks and facilitates the separation of the merge
    operation into a new xfs_bmse_merge() and xfs_bmse_can_merge() helpers.
    
    This is a code refactor only. The behavior of extent shift and collapse
    range is not modified.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 2c845f5a5f238f42376b6551a7f7716952c8f509
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Sep 23 15:37:09 2014 +1000

    xfs: track collapse via file offset rather than extent index
    
    The collapse range implementation uses a transaction per extent shift.
    The progress of the overall operation is tracked via the current extent
    index of the in-core extent list. This is racy because the ilock must be
    dropped and reacquired for each transaction according to locking and log
    reservation rules. Therefore, writeback to prior regions of the file is
    possible and can change the extent count. This changes the extent to
    which the current index refers and causes the collapse to fail mid
    operation. To avoid this problem, the entire file is currently written
    back before the collapse operation starts.
    
    To eliminate the need to flush the entire file, use the file offset
    (fsb) to track the progress of the overall extent shift operation rather
    than the extent index. Modify xfs_bmap_shift_extents() to
    unconditionally convert the start_fsb parameter to an extent index and
    return the file offset of the extent where the shift left off, if
    further extents exist. The bulk of ths function can remain based on
    extent index as ilock is held by the caller. xfs_collapse_file_space()
    now uses the fsb output as the starting point for the subsequent shift.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 0d085a529b427d97710e6a41f8a4f23e1757cd12
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 23 15:36:27 2014 +1000

    xfs: ensure WB_SYNC_ALL writeback handles partial pages correctly
    
    XFS has been having trouble with stray delayed allocation extents
    beyond EOF for a long time. Recent changes to the collapse range
    code has triggered erroneous EBUSY errors on page invalidtion for
    block size smaller than page size filesystems. These
    have been caused by dirty buffers beyond EOF on a partial page which
    do not get written to disk during a sync.
    
    The issue is that write-ahead in xfs_cluster_write() finds such a
    partial page and handles it by leaving the page dirty but pushing it
    into a writeback state. This used to work just fine, as the
    write_cache_pages() code would then find the dirty partial page in
    the next mapping tree lookup as the dirty tag is still set.
    
    Unfortunately, when we moved to a mark and sweep approach to
    writeback to fix other writeback sync issues, we broken this. THe
    act of marking the page as under writeback now clears the TOWRITE
    tag in the radix tree, even though the page is still dirty. This
    causes the TOWRITE tag to be cleared, and hence the next lookup on
    the mapping tree does not find the dirty partial page and so doesn't
    try to write it again.
    
    This same writeback bug was found recently in ext4 and fixed in
    commit 1c8349a ("ext4: fix data integrity sync in ordered mode")
    without communication to the wider filesystem community. We can use
    exactly the same fix here so the TOWRITE flag is not cleared on
    partial page writes.
    
    cc: stable@vger.kernel.org # dependent on 1c8349a17137b93f0a83f276c764a6df1b9a116e
    Root-cause-found-by: Brian Foster <bfoster@redhat.com>
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
