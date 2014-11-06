Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.18-rc2-11-g0027589
Message-Id: <20141106214228.7AA267F51@oss.sgi.com>
Date: Thu,  6 Nov 2014 15:42:28 -0600 (CST)
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

The branch, for-next has been updated
  discards  31692c5fe617d28d8099a9308d345e26f3e22dca (commit)
  discards  bae09893f6a5260c7030499ddfd0911899ae3d0c (commit)
  discards  3f7bc307d477036177a86334dd02a95981b34ecc (commit)
  0027589 xfs: track bulkstat progress by agino
  febe3cb xfs: bulkstat error handling is broken
  6e57c542 xfs: bulkstat main loop logic is a mess
  2b831ac xfs: bulkstat chunk-formatter has issues
  bf4a5af xfs: bulkstat chunk formatting cursor is broken
  afa947c xfs: bulkstat btree walk doesn't terminate
  5d11fb4 xfs: rework zero range to prevent invalid i_size updates
  7a19dee xfs: Check error during inode btree iteration in xfs_bulkstat()
      from  31692c5fe617d28d8099a9308d345e26f3e22dca (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 002758992693ae63c04122603ea9261a0a58d728
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Nov 7 08:33:52 2014 +1100

    xfs: track bulkstat progress by agino
    
    The bulkstat main loop progress is tracked by the "lastino"
    variable, which is a full 64 bit inode. However, the loop actually
    works on agno/agino pairs, and so there's a significant disconnect
    between the rest of the loop and the main cursor. Convert this to
    use the agino, and pass the agino into the chunk formatting function
    and convert it too.
    
    This gets rid of the inconsistency in the loop processing, and
    finally makes it simple for us to skip inodes at any point in the
    loop simply by incrementing the agino cursor.
    
    cc: <stable@vger.kernel.org> # 3.17
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit febe3cbe38b0bc0a925906dc90e8d59048851f87
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Nov 7 08:31:15 2014 +1100

    xfs: bulkstat error handling is broken
    
    The error propagation is a horror - xfs_bulkstat() returns
    a rval variable which is only set if there are formatter errors. Any
    sort of btree walk error or corruption will cause the bulkstat walk
    to terminate but will not pass an error back to userspace. Worse
    is the fact that formatter errors will also be ignored if any inodes
    were correctly formatted into the user buffer.
    
    Hence bulkstat can fail badly yet still report success to userspace.
    This causes significant issues with xfsdump not dumping everything
    in the filesystem yet reporting success. It's not until a restore
    fails that there is any indication that the dump was bad and tha
    bulkstat failed. This patch now triggers xfsdump to fail with
    bulkstat errors rather than silently missing files in the dump.
    
    This now causes bulkstat to fail when the lastino cookie does not
    fall inside an existing inode chunk. The pre-3.17 code tolerated
    that error by allowing the code to move to the next inode chunk
    as the agino target is guaranteed to fall into the next btree
    record.
    
    With the fixes up to this point in the series, xfsdump now passes on
    the troublesome filesystem image that exposes all these bugs.
    
    cc: <stable@vger.kernel.org>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>

commit 6e57c542cb7e0e580eb53ae76a77875c7d92b4b1
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Nov 7 08:31:13 2014 +1100

    xfs: bulkstat main loop logic is a mess
    
    There are a bunch of variables tha tare more wildy scoped than they
    need to be, obfuscated user buffer checks and tortured "next inode"
    tracking. This all needs cleaning up to expose the real issues that
    need fixing.
    
    cc: <stable@vger.kernel.org> # 3.17
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 2b831ac6bc87d3cbcbb1a8816827b6923403e461
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Nov 7 08:30:58 2014 +1100

    xfs: bulkstat chunk-formatter has issues
    
    The loop construct has issues:
    	- clustidx is completely unused, so remove it.
    	- the loop tries to be smart by terminating when the
    	  "freecount" tells it that all inodes are free. Just drop
    	  it as in most cases we have to scan all inodes in the
    	  chunk anyway.
    	- move the "user buffer left" condition check to the only
    	  point where we consume space int eh user buffer.
    	- move the initialisation of agino out of the loop, leaving
    	  just a simple loop control logic using the clusteridx.
    
    Also, double handling of the user buffer variables leads to problems
    tracking the current state - use the cursor variables directly
    rather than keeping local copies and then having to update the
    cursor before returning.
    
    cc: <stable@vger.kernel.org> # 3.17
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit bf4a5af20d25ecc8876978ad34b8db83b4235f3c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Nov 7 08:30:30 2014 +1100

    xfs: bulkstat chunk formatting cursor is broken
    
    The xfs_bulkstat_agichunk formatting cursor takes buffer values from
    the main loop and passes them via the structure to the chunk
    formatter, and the writes the changed values back into the main loop
    local variables. Unfortunately, this complex dance is full of corner
    cases that aren't handled correctly.
    
    The biggest problem is that it is double handling the information in
    both the main loop and the chunk formatting function, leading to
    inconsistent updates and endless loops where progress is not made.
    
    To fix this, push the struct xfs_bulkstat_agichunk outwards to be
    the primary holder of user buffer information. this removes the
    double handling in the main loop.
    
    Also, pass the last inode processed by the chunk formatter as a
    separate parameter as it purely an output variable and is not
    related to the user buffer consumption cursor.
    
    Finally, the chunk formatting code is not shared by anyone, so make
    it local to xfs_itable.c.
    
    cc: <stable@vger.kernel.org> # 3.17
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit afa947cb52a8e73fe71915a0b0af6fcf98dfbe1a
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Nov 7 08:29:57 2014 +1100

    xfs: bulkstat btree walk doesn't terminate
    
    The bulkstat code has several different ways of detecting the end of
    an AG when doing a walk. They are not consistently detected, and the
    code that checks for the end of AG conditions is not consistently
    coded. Hence the are conditions where the walk code can get stuck in
    an endless loop making no progress and not triggering any
    termination conditions.
    
    Convert all the "tmp/i" status return codes from btree operations
    to a common name (stat) and apply end-of-ag detection to these
    operations consistently.
    
    cc: <stable@vger.kernel.org> # 3.17
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 5d11fb4b9a1d90983452c029b5e1377af78fda49
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Oct 30 10:35:11 2014 +1100

    xfs: rework zero range to prevent invalid i_size updates
    
    The zero range operation is analogous to fallocate with the exception of
    converting the range to zeroes. E.g., it attempts to allocate zeroed
    blocks over the range specified by the caller. The XFS implementation
    kills all delalloc blocks currently over the aligned range, converts the
    range to allocated zero blocks (unwritten extents) and handles the
    partial pages at the ends of the range by sending writes through the
    pagecache.
    
    The current implementation suffers from several problems associated with
    inode size. If the aligned range covers an extending I/O, said I/O is
    discarded and an inode size update from a previous write never makes it
    to disk. Further, if an unaligned zero range extends beyond eof, the
    page write induced for the partial end page can itself increase the
    inode size, even if the zero range request is not supposed to update
    i_size (via KEEP_SIZE, similar to an fallocate beyond EOF).
    
    The latter behavior not only incorrectly increases the inode size, but
    can lead to stray delalloc blocks on the inode. Typically, post-eof
    preallocation blocks are either truncated on release or inode eviction
    or explicitly written to by xfs_zero_eof() on natural file size
    extension. If the inode size increases due to zero range, however,
    associated blocks leak into the address space having never been
    converted or mapped to pagecache pages. A direct I/O to such an
    uncovered range cannot convert the extent via writeback and will BUG().
    For example:
    
    $ xfs_io -fc "pwrite 0 128k" -c "fzero -k 1m 54321" <file>
    ...
    $ xfs_io -d -c "pread 128k 128k" <file>
    <BUG>
    
    If the entire delalloc extent happens to not have page coverage
    whatsoever (e.g., delalloc conversion couldn't find a large enough free
    space extent), even a full file writeback won't convert what's left of
    the extent and we'll assert on inode eviction.
    
    Rework xfs_zero_file_space() to avoid buffered I/O for partial pages.
    Use the existing hole punch and prealloc mechanisms as primitives for
    zero range. This implementation is not efficient nor ideal as we
    writeback dirty data over the range and remove existing extents rather
    than convert to unwrittern. The former writeback, however, is currently
    the only mechanism available to ensure consistency between pagecache and
    extent state. Even a pagecache truncate/delalloc punch prior to hole
    punch has lead to inconsistencies due to racing with writeback.
    
    This provides a consistent, correct implementation of zero range that
    survives fsstress/fsx testing without assert failures. The
    implementation can be optimized from this point forward once the
    fundamental issue of pagecache and delalloc extent state consistency is
    addressed.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 7a19dee116c8fae7ba7a778043c245194289f5a2
Author: Jan Kara <jack@suse.cz>
Date:   Thu Oct 30 10:34:52 2014 +1100

    xfs: Check error during inode btree iteration in xfs_bulkstat()
    
    xfs_bulkstat() doesn't check error return from xfs_btree_increment(). In
    case of specific fs corruption that could result in xfs_bulkstat()
    entering an infinite loop because we would be looping over the same
    chunk over and over again. Fix the problem by checking the return value
    and terminating the loop properly.
    
    Coverity-id: 1231338
    cc: <stable@vger.kernel.org>
    Signed-off-by: Jan Kara <jack@suse.cz>
    Reviewed-by: Jie Liu <jeff.u.liu@gmail.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_itable.c | 234 ++++++++++++++++++++++++----------------------------
 fs/xfs/xfs_itable.h |  16 ----
 2 files changed, 110 insertions(+), 140 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
