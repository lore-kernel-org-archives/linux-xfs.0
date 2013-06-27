Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. v3.10-rc1-54-gddf6ad0
Message-Id: <20130627194537.574397F4E@oss.sgi.com>
Date: Thu, 27 Jun 2013 14:45:36 -0500 (CDT)
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

The branch, master has been updated
  ddf6ad0 xfs: Use inode create transaction
  28c8e41 xfs: Inode create item recovery
  b8402b4 xfs: Inode create transaction reservations
  3ebe7d2 xfs: Inode create log items
  5f6bed7 xfs: Introduce an ordered buffer item
  fd63875 xfs: Introduce ordered log vector support
  1baaed8 xfs: xfs_ifree doesn't need to modify the inode buffer
  cca9f93 xfs: don't do IO when creating an new inode
  133eeb1 xfs: don't use speculative prealloc for small files
  34eefc0 xfs: plug directory buffer readahead
  cbb2864 xfs: add pluging for bulkstat readahead
      from  80a4049813a2ae0977d8e5db78e711c7f21c420b (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit ddf6ad01434e72bfc8423e1619abdaa0af9394a8
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Jun 27 16:04:56 2013 +1000

    xfs: Use inode create transaction
    
    Replace the use of buffer based logging of inode initialisation,
    uses the new logical form to describe the range to be initialised
    in recovery. We continue to "log" the inode buffers to push them
    into the AIL and ensure that the inode create transaction is not
    removed from the log before the inode buffers are written to disk.
    
    Update the transaction identifier and reservations to match the
    changed implementation.
    
    Signed-off-by: Dave Chinner <david@fromorbit.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 28c8e41af693e4b5cd2d68218f144cf40ce15781
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Jun 27 16:04:55 2013 +1000

    xfs: Inode create item recovery
    
    When we find a icreate transaction, we need to get and initialise
    the buffers in the range that has been passed. Extract and verify
    the information in the item record, then loop over the range
    initialising and issuing the buffer writes delayed.
    
    Support an arbitrary size range to initialise so that in
    future when we allocate inodes in much larger chunks all kernels
    that understand this transaction can still recover them.
    
    Signed-off-by: Dave Chinner <david@fromorbit.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit b8402b4729495ac719a3f532c2e33ac653b222a8
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Jun 27 16:04:54 2013 +1000

    xfs: Inode create transaction reservations
    
    Define the log and space transaction sizes. Factor the current
    create log reservation macro into the two logical halves and reuse
    one half for the new icreate transactions. The icreate transaction
    is transparent to all the high level create code - the
    pre-calculated reservations will correctly set the reservations
    dependent on whether the filesystem supports the icreate
    transaction.
    
    Signed-off-by: Dave Chinner <david@fromorbit.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 3ebe7d2d73179c4874aee4f32e043eb5acd9fa0f
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Jun 27 16:04:53 2013 +1000

    xfs: Inode create log items
    
    Introduce the inode create log item type for logical inode create logging.
    Instead of logging the changes in buffers, pass the range to be
    initialised through the log by a new transaction type.  This reduces
    the amount of log space required to record initialisation during
    allocation from about 128 bytes per inode to a small fixed amount
    per inode extent to be initialised.
    
    This requires a new log item type to track it through the log
    and the AIL. This is a relatively simple item - most callbacks are
    noops as this item has the same life cycle as the transaction.
    
    Signed-off-by: Dave Chinner <david@fromorbit.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 5f6bed76c0c85cb4d04885a5de00b629deee550b
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Jun 27 16:04:52 2013 +1000

    xfs: Introduce an ordered buffer item
    
    If we have a buffer that we have modified but we do not wish to
    physically log in a transaction (e.g. we've logged a logical
    change), we still need to ensure that transactional integrity is
    maintained. Hence we must not move the tail of the log past the
    transaction that the buffer is associated with before the buffer is
    written to disk.
    
    This means these special buffers still need to be included in the
    transaction and added to the AIL just like a normal buffer, but we
    do not want the modifications to the buffer written into the
    transaction. IOWs, what we want is an "ordered buffer" that
    maintains the same transactional life cycle as a physically logged
    buffer, just without the transcribing of the modifications to the
    log.
    
    Hence we need to flag the buffer as an "ordered buffer" to avoid
    including it in vector size calculations or formatting during the
    transaction. Once the transaction is committed, the buffer appears
    for all intents to be the same as a physically logged buffer as it
    transitions through the log and AIL.
    
    Relogging will also work just fine for such an ordered buffer - the
    logical transaction will be replayed before the subsequent
    modifications that relog the buffer, so everything will be
    reconstructed correctly by recovery.
    
    Signed-off-by: Dave Chinner <david@fromorbit.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit fd63875cc4cd60b9e5c609c24d75eaaad3e6d1c4
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Jun 27 16:04:51 2013 +1000

    xfs: Introduce ordered log vector support
    
    And "ordered log vector" is a log vector that is used for
    tracking a log item through the CIL and into the AIL as part of the
    log checkpointing. These ordered log vectors are special in that
    they are not written to to journal in any way, and are not accounted
    to the checkpoint being written.
    
    The reason for this behaviour is to allow operations to attach items
    to transactions and have them follow the normal transactional
    lifecycle without actually having to write them to the journal. This
    allows logging of items that track high level logical changes and
    writing them to the log, while the physical items being modified
    pass through into the AIL and pin the tail of the log (and therefore
    the logical item in the log) until all the modified items are
    physically written to disk.
    
    IOWs, it allows us to write metadata without physically logging
    every individual change but still maintain the full transactional
    integrity guarantees we currently have w.r.t. crash recovery.
    
    This change modifies some of the CIL item insertion loops, as
    ordered log vectors introduce some new constraints as they don't
    track any data. One advantage of this change is that it combines
    two log vector chain walks into a single pass, so there is less
    overhead in the transaction commit pass as well. It also kills some
    unused code in the log vector walk loop when committing the CIL.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 1baaed8fa955ab0d23aab24477dae566ed6a105b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Jun 27 16:04:50 2013 +1000

    xfs: xfs_ifree doesn't need to modify the inode buffer
    
    Long ago, bulkstat used to read inodes directly from the backing
    buffer for speed. This had the unfortunate problem of being cache
    incoherent with unlinks, and so xfs_ifree() had to mark the inode
    as free directly in the backing buffer. bulkstat was changed some
    time ago to use inode cache coherent lookups, and so will never see
    unlinked inodes in it's lookups. Hence xfs_ifree() does not need to
    touch the inode backing buffer anymore.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit cca9f93a52d2ead50b5da59ca83d5f469ee4be5f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Jun 27 16:04:49 2013 +1000

    xfs: don't do IO when creating an new inode
    
    When we are allocating a new inode, we read the inode cluster off
    disk to increment the generation number. We are already using a
    random generation number for newly allocated inodes, so if we are not
    using the ikeep mode, we can just generate a new generation number
    when we initialise the newly allocated inode.
    
    This avoids the need for reading the inode buffer during inode
    creation. This will speed up allocation of inodes in cold, partially
    allocated clusters as they will no longer need to be read from disk
    during allocation. It will also reduce the CPU overhead of inode
    allocation by not having the process the buffer read, even on cache
    hits.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 133eeb1747c33b6d75483c074b27d4e5e02286dc
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Jun 27 16:04:48 2013 +1000

    xfs: don't use speculative prealloc for small files
    
    Dedicated small file workloads have been seeing significant free
    space fragmentation causing premature inode allocation failure
    when large inode sizes are in use. A particular test case showed
    that a workload that runs to a real ENOSPC on 256 byte inodes would
    fail inode allocation with ENOSPC about about 80% full with 512 byte
    inodes, and at about 50% full with 1024 byte inodes.
    
    The same workload, when run with -o allocsize=4096 on 1024 byte
    inodes would run to being 100% full before giving ENOSPC. That is,
    no freespace fragmentation at all.
    
    The issue was caused by the specific IO pattern the application had
    - the framework it was using did not support direct IO, and so it
    was emulating it by using fadvise(DONT_NEED). The result was that
    the data was getting written back before the speculative prealloc
    had been trimmed from memory by the close(), and so small single
    block files were being allocated with 2 blocks, and then having one
    truncated away. The result was lots of small 4k free space extents,
    and hence each new 8k allocation would take another 8k from
    contiguous free space and turn it into 4k of allocated space and 4k
    of free space.
    
    Hence inode allocation, which requires contiguous, aligned
    allocation of 16k (256 byte inodes), 32k (512 byte inodes) or 64k
    (1024 byte inodes) can fail to find sufficiently large freespace and
    hence fail while there is still lots of free space available.
    
    There's a simple fix for this, and one that has precendence in the
    allocator code already - don't do speculative allocation unless the
    size of the file is larger than a certain size. In this case, that
    size is the minimum default preallocation size:
    mp->m_writeio_blocks. And to keep with the concept of being nice to
    people when the files are still relatively small, cap the prealloc
    to mp->m_writeio_blocks until the file goes over a stripe unit is
    size, at which point we'll fall back to the current behaviour based
    on the last extent size.
    
    This will effectively turn off speculative prealloc for very small
    files, keep preallocation low for small files, and behave as it
    currently does for any file larger than a stripe unit. This
    completely avoids the freespace fragmentation problem this
    particular IO pattern was causing.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 34eefc06a06f496b92c3267a0601129a932c7174
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Jun 27 16:04:47 2013 +1000

    xfs: plug directory buffer readahead
    
    Similar to bulkstat inode chunk readahead, we need to plug directory
    data buffer readahead during getdents to ensure that we can merge
    adjacent readahead requests and sort out of order requests optimally
    before they are dispatched. This improves the readahead efficiency
    and reduces the IO load it generates as the IO patterns are
    significantly better for both contiguous and fragmented directories.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit cbb2864aa48977205c76291ba5a23331393b2578
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Jun 27 16:04:46 2013 +1000

    xfs: add pluging for bulkstat readahead
    
    I was running some tests on bulkstat on CRC enabled filesystems when
    I noticed that all the IO being issued was 8k in size, regardless of
    the fact taht we are issuing sequential 8k buffers for inodes
    clusters. The IO size should be 16k for 256 byte inodes, and 32k for
    512 byte inodes, but this wasn't happening.
    
    blktrace showed that there was an explict plug and unplug happening
    around each readahead IO from _xfs_buf_ioapply, and the unplug was
    causing the IO to be issued immediately. Hence no opportunity was
    being given to the elevator to merge adjacent readahead requests and
    dispatch them as a single IO.
    
    Add plugging around the inode chunk readahead dispatch loop in
    bulkstat to ensure that we don't unplug the queue between adjacent
    inode buffer readahead IOs and so we get fewer, larger IO requests
    hitting the storage subsystem for bulkstat.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/Makefile           |   1 +
 fs/xfs/xfs_buf_item.c     |  87 ++++++++++++++-------
 fs/xfs/xfs_buf_item.h     |   4 +-
 fs/xfs/xfs_dir2_leaf.c    |   3 +
 fs/xfs/xfs_ialloc.c       |  67 ++++++++++++----
 fs/xfs/xfs_ialloc.h       |   8 ++
 fs/xfs/xfs_icreate_item.c | 195 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icreate_item.h |  52 +++++++++++++
 fs/xfs/xfs_inode.c        |  68 ++++++++--------
 fs/xfs/xfs_iomap.c        |  13 ++++
 fs/xfs/xfs_itable.c       |   3 +
 fs/xfs/xfs_log.c          |  22 +++++-
 fs/xfs/xfs_log.h          |   5 +-
 fs/xfs/xfs_log_cil.c      |  75 ++++++++++++------
 fs/xfs/xfs_log_recover.c  | 114 +++++++++++++++++++++++++--
 fs/xfs/xfs_super.c        |   8 ++
 fs/xfs/xfs_trace.h        |   4 +
 fs/xfs/xfs_trans.c        | 118 ++++++++++++++++++----------
 fs/xfs/xfs_trans.h        |   5 +-
 fs/xfs/xfs_trans_buf.c    |  34 +++++++-
 20 files changed, 724 insertions(+), 162 deletions(-)
 create mode 100644 fs/xfs/xfs_icreate_item.c
 create mode 100644 fs/xfs/xfs_icreate_item.h


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
