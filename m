From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-misc-fixes-for-3.19-2,
	created. v3.18-rc2-20-gb29c70f
Message-Id: <20141204020716.3F93D29DF7@oss.sgi.com>
Date: Wed,  3 Dec 2014 20:07:16 -0600 (CST)
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

The branch, xfs-misc-fixes-for-3.19-2 has been created
        at  b29c70f59870dad0945b0e0b3fe3758ad528e268 (commit)

- Log -----------------------------------------------------------------
commit b29c70f59870dad0945b0e0b3fe3758ad528e268
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Dec 4 09:43:17 2014 +1100

    xfs: split metadata and log buffer completion to separate workqueues
    
    XFS traditionally sends all buffer I/O completion work to a single
    workqueue. This includes metadata buffer completion and log buffer
    completion. The log buffer completion requires a high priority queue to
    prevent stalls due to log forces getting stuck behind other queued work.
    
    Rather than continue to prioritize all buffer I/O completion due to the
    needs of log completion, split log buffer completion off to
    m_log_workqueue and move the high priority flag from m_buf_workqueue to
    m_log_workqueue.
    
    Add a b_ioend_wq wq pointer to xfs_buf to allow completion workqueue
    customization on a per-buffer basis. Initialize b_ioend_wq to
    m_buf_workqueue by default in the generic buffer I/O submission path.
    Finally, override the default wq with the high priority m_log_workqueue
    in the log buffer I/O submission path.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 32296f865e8d41ff8c337ce6f0b97eeda08988a3
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Dec 4 09:43:17 2014 +1100

    xfs: fix set-but-unused warnings
    
    The kernel compile doesn't turn on these checks by default, so it's
    only when I do a kernel-user sync that I find that there are lots of
    compiler warnings waiting to be fixed. Fix up these set-but-unused
    warnings.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 9a2cc41cda189bea1fb9c41ef64d19949d3b2bcd
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Dec 4 09:43:17 2014 +1100

    xfs: move type conversion functions to xfs_dir.h
    
    These are currently considered private to libxfs, but they are
    widely used by the userspace code to decode, walk and check
    directory structures. Hence they really form part of the external
    API and as such need to bemoved to xfs_dir2.h.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 1b767ee386c5f58660ca9be70d3076f2b6484e72
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Dec 4 09:43:17 2014 +1100

    xfs: move ftype conversion functions to libxfs
    
    These functions are needed in userspace for repair and mkfs to
    do the right thing. Move them to libxfs so they can be easily
    shared.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 2d3d0c53df99587e1d58759f805c3aae79fac453
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Dec 4 09:43:13 2014 +1100

    xfs: lobotomise xfs_trans_read_buf_map()
    
    There's a case in that code where it checks for a buffer match in a
    transaction where the buffer is not marked done. i.e. trying to
    catch a buffer we have locked in the transaction but have not
    completed IO on.
    
    The only way we can find a buffer that has not had IO completed on
    it is if it had readahead issued on it, but we never do readahead on
    buffers that we have already joined into a transaction. Hence this
    condition cannot occur, and buffers locked and joined into a
    transaction should always be marked done and not under IO.
    
    Remove this code and re-order xfs_trans_read_buf_map() to remove
    duplicated IO dispatch and error handling code.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit cdc9cec7c0ff521edf8c0e9c9432bf8fdccfc702
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Dec 4 09:42:40 2014 +1100

    xfs: active inodes stat is broken
    
    vn_active only ever gets decremented, so it has a very large
    negative number.  Make it track the inode count we currently have
    allocated properly so we can easily track the size of the inode
    cache via tools like PCP.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 4db431f57be2d32f35f46023b0c0d9f8b6e06e26
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Dec 4 09:42:40 2014 +1100

    xfs: cleanup xfs_bmse_merge returns
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    
    xfs_bmse_merge() has a jump label for return that just returns the
    error value. Convert all the code to just return the error directly
    and use XFS_WANT_CORRUPTED_RETURN. This also allows the final call
    to xfs_bmbt_update() to return directly.
    
    Noticed while reviewing coccinelle return cleanup patches and
    wondering why the same return pattern as in xfs_bmse_shift_one()
    wasn't picked up by the checker pattern...
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit b11bd671ba8a0268753db25684115acde57d3d32
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Dec 4 09:42:24 2014 +1100

    xfs: cleanup xfs_bmse_shift_one goto mess
    
    xfs_bmse_shift_one() jumps around determining whether to shift or
    merge, making the code flow difficult to follow. Clean it up and
    use direct error returns (including XFS_WANT_CORRUPTED_RETURN) to
    make the code flow better and be easier to read.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 7a1df1561609c14ac457d65d9a4a2b6c0f4204ad
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Dec 4 09:42:21 2014 +1100

    xfs: fix premature enospc on inode allocation
    
    After growing a filesystem, XFS can fail to allocate inodes even
    though there is a large amount of space available in the filesystem
    for inodes. The issue is caused by a nearly full allocation group
    having enough free space in it to be considered for inode
    allocation, but not enough contiguous free space to actually
    allocation inodes.  This situation results in successful selection
    of the AG for allocation, then failure of the allocation resulting
    in ENOSPC being reported to the caller.
    
    It is caused by two possible issues. Firstly, we only consider the
    lognest free extent and whether it would fit an inode chunk. If the
    extent is not correctly aligned, then we can't allocate an inode
    chunk in it regardless of the fact that it is large enough. This
    tends to be a permanent error until space in the AG is freed.
    
    The second issue is that we don't actually lock the AGI or AGF when
    we are doing these checks, and so by the time we get to actually
    allocating the inode chunk the space we thought we had in the AG may
    have been allocated. This tends to be a spurious error as it
    requires a race to trigger. Hence this case is ignored in this patch
    as the reported problem is for permanent errors.
    
    The first issue could be addressed by simply taking into account the
    alignment when checking the longest extent. This, however, would
    prevent allocation in AGs that have aligned, exact sized extents
    free. However, this case should be fairly rare compared to the
    number of allocations that occur near ENOSPC that would trigger this
    condition.
    
    Hence, when selecting the inode AG, take into account the inode
    cluster alignment when checking the lognest free extent in the AG.
    If we can't find any AGs with a contiguous free space large
    enough to be aligned, drop the alignment addition and just try for
    an AG that has enough contiguous free space available for an inode
    chunk. This won't prevent issues from occurring, but should avoid
    situations where other AGs have lots of free space but the selected
    AG can't allocate due to alignment constraints.
    
    Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 76b57302526ae289e8094a51d6a71031ff3d058b
Author: Peter Watkins <treestem@gmail.com>
Date:   Thu Dec 4 09:30:51 2014 +1100

    xfs: overflow in xfs_iomap_eof_align_last_fsb
    
    If extsize is set and new_last_fsb is larger than 32 bits, the
    roundup to extsize will overflow the align variable. Instead,
    combine alignments by rounding stripe size up to extsize.
    
    Signed-off-by: Peter Watkins <treestem@gmail.com>
    Reviewed-by: Nathaniel W. Turner <nate@houseofnate.net>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit e77b8547ca9c4b87932e9da3db906bc016885d8d
Merge: db52d09e d254aae
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Dec 4 09:18:21 2014 +1100

    Merge branch 'xfs-coccinelle-cleanups' into xfs-misc-fixes-for-3.19-2

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
