Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-fixes-for-3.18-rc3,
	created. v3.18-rc2-4-gbae0989
Message-Id: <20141029013357.B043E29DFA@oss.sgi.com>
Date: Tue, 28 Oct 2014 20:33:57 -0500 (CDT)
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

The branch, xfs-fixes-for-3.18-rc3 has been created
        at  bae09893f6a5260c7030499ddfd0911899ae3d0c (commit)

- Log -----------------------------------------------------------------
commit bae09893f6a5260c7030499ddfd0911899ae3d0c
Author: Brian Foster <bfoster@redhat.com>
Date:   Wed Oct 29 11:20:27 2014 +1100

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

commit e9c5e12104c38d1d381a789ddefca2bfef99a8da
Author: Jan Kara <jack@suse.cz>
Date:   Wed Oct 29 11:19:27 2014 +1100

    mm: Remove false WARN_ON from pagecache_isize_extended()
    
    The WARN_ON checking whether i_mutex is held in
    pagecache_isize_extended() was wrong because some filesystems (e.g.
    XFS) use different locks for serialization of truncates / writes. So
    just remove the check.
    
    Signed-off-by: Jan Kara <jack@suse.cz>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 3f7bc307d477036177a86334dd02a95981b34ecc
Author: Jan Kara <jack@suse.cz>
Date:   Wed Oct 29 11:19:22 2014 +1100

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

commit a6bbce54efa9145dbcf3029c885549f7ebc40a3b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Oct 29 08:22:18 2014 +1100

    xfs: bulkstat doesn't release AGI buffer on error
    
    The recent refactoring of the bulkstat code left a small landmine in
    the code. If a inobt read fails, then the tree walk is aborted and
    returns without releasing the AGI buffer or freeing the cursor. This
    can lead to a subsequent bulkstat call hanging trying to grab the
    AGI buffer again.
    
    cc: <stable@vger.kernel.org>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
