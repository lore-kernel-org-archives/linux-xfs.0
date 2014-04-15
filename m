Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-fixes-for-3.15-rc2,
	created. xfs-for-linus-3.15-rc1-14836-gb901592
Message-Id: <20140415224519.C690F7F4E@oss.sgi.com>
Date: Tue, 15 Apr 2014 17:45:19 -0500 (CDT)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7613263070656622526=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7613263070656622526==
Content-Type: text/plain

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, xfs-fixes-for-3.15-rc2 has been created
        at  b90159297f95491c348354344e52a4b3da440234 (commit)

- Log -----------------------------------------------------------------
commit b90159297f95491c348354344e52a4b3da440234
Author: Brian Foster <bfoster@redhat.com>
Date:   Wed Apr 16 08:17:52 2014 +1000

    xfs: fix tmpfile/selinux deadlock and initialize security
    
    xfstests generic/004 reproduces an ilock deadlock using the tmpfile
    interface when selinux is enabled. This occurs because
    xfs_create_tmpfile() takes the ilock and then calls d_tmpfile(). The
    latter eventually calls into xfs_xattr_get() which attempts to get the
    lock again. E.g.:
    
    xfs_io          D ffffffff81c134c0  4096  3561   3560 0x00000080
    ffff8801176a1a68 0000000000000046 ffff8800b401b540 ffff8801176a1fd8
    00000000001d5800 00000000001d5800 ffff8800b401b540 ffff8800b401b540
    ffff8800b73a6bd0 fffffffeffffffff ffff8800b73a6bd8 ffff8800b5ddb480
    Call Trace:
    [<ffffffff8177f969>] schedule+0x29/0x70
    [<ffffffff81783a65>] rwsem_down_read_failed+0xc5/0x120
    [<ffffffffa05aa97f>] ? xfs_ilock_attr_map_shared+0x1f/0x50 [xfs]
    [<ffffffff813b3434>] call_rwsem_down_read_failed+0x14/0x30
    [<ffffffff810ed179>] ? down_read_nested+0x89/0xa0
    [<ffffffffa05aa7f2>] ? xfs_ilock+0x122/0x250 [xfs]
    [<ffffffffa05aa7f2>] xfs_ilock+0x122/0x250 [xfs]
    [<ffffffffa05aa97f>] xfs_ilock_attr_map_shared+0x1f/0x50 [xfs]
    [<ffffffffa05701d0>] xfs_attr_get+0x90/0xe0 [xfs]
    [<ffffffffa0565e07>] xfs_xattr_get+0x37/0x50 [xfs]
    [<ffffffff8124842f>] generic_getxattr+0x4f/0x70
    [<ffffffff8133fd9e>] inode_doinit_with_dentry+0x1ae/0x650
    [<ffffffff81340e0c>] selinux_d_instantiate+0x1c/0x20
    [<ffffffff813351bb>] security_d_instantiate+0x1b/0x30
    [<ffffffff81237db0>] d_instantiate+0x50/0x70
    [<ffffffff81237e85>] d_tmpfile+0xb5/0xc0
    [<ffffffffa05add02>] xfs_create_tmpfile+0x362/0x410 [xfs]
    [<ffffffffa0559ac8>] xfs_vn_tmpfile+0x18/0x20 [xfs]
    [<ffffffff81230388>] path_openat+0x228/0x6a0
    [<ffffffff810230f9>] ? sched_clock+0x9/0x10
    [<ffffffff8105a427>] ? kvm_clock_read+0x27/0x40
    [<ffffffff8124054f>] ? __alloc_fd+0xaf/0x1f0
    [<ffffffff8123101a>] do_filp_open+0x3a/0x90
    [<ffffffff817845e7>] ? _raw_spin_unlock+0x27/0x40
    [<ffffffff8124054f>] ? __alloc_fd+0xaf/0x1f0
    [<ffffffff8121e3ce>] do_sys_open+0x12e/0x210
    [<ffffffff8121e4ce>] SyS_open+0x1e/0x20
    [<ffffffff8178eda9>] system_call_fastpath+0x16/0x1b
    
    xfs_vn_tmpfile() also fails to initialize security on the newly created
    inode.
    
    Pull the d_tmpfile() call up into xfs_vn_tmpfile() after the transaction
    has been committed and the inode unlocked. Also, initialize security on
    the inode based on the parent directory provided via the tmpfile call.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 341fcf35d5c111e27c4ef5c2e179a463ff2fc1b5
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Apr 16 08:17:18 2014 +1000

    xfs: fix buffer use after free on IO error
    
    When testing exhaustion of dm snapshots, the following appeared
    with CONFIG_DEBUG_OBJECTS_FREE enabled:
    
    ODEBUG: free active (active state 0) object type: work_struct hint: xfs_buf_iodone_work+0x0/0x1d0 [xfs]
    
    indicating that we'd freed a buffer which still had a pending reference,
    down this path:
    
    [  190.867975]  [<ffffffff8133e6fb>] debug_check_no_obj_freed+0x22b/0x270
    [  190.880820]  [<ffffffff811da1d0>] kmem_cache_free+0xd0/0x370
    [  190.892615]  [<ffffffffa02c5924>] xfs_buf_free+0xe4/0x210 [xfs]
    [  190.905629]  [<ffffffffa02c6167>] xfs_buf_rele+0xe7/0x270 [xfs]
    [  190.911770]  [<ffffffffa034c826>] xfs_trans_read_buf_map+0x7b6/0xac0 [xfs]
    
    At issue is the fact that if IO fails in xfs_buf_iorequest,
    we'll queue completion unconditionally, and then call
    xfs_buf_rele; but if IO failed, there are no IOs remaining,
    and xfs_buf_rele will free the bp while work is still queued.
    
    Fix this by not scheduling completion if the buffer has
    an error on it; run it immediately.  The rest is only comment
    changes.
    
    Thanks to dchinner for spotting the root cause.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit b7f6608b9de371c79498cd3db4b5346718430a0c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Apr 16 08:17:16 2014 +1000

    xfs: wrong error sign conversion during failed DIO writes
    
    We negate the error value being returned from a generic function
    incorrectly. The code path that it is running in returned negative
    errors, so there is no need to negate it to get the correct error
    signs here.
    
    This was uncovered by generic/019.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit d7cc0f34d9b8bdba7f426463ce1dc50a69bcac63
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Apr 16 08:17:14 2014 +1000

    xfs: unmount does not wait for shutdown during unmount
    
    And interesting situation can occur if a log IO error occurs during
    the unmount of a filesystem. The cases reported have the same
    signature - the update of the superblock counters fails due to a log
    write IO error:
    
    XFS (dm-16): xfs_do_force_shutdown(0x2) called from line 1170 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa08a44a1
    XFS (dm-16): Log I/O Error Detected.  Shutting down filesystem
    XFS (dm-16): Unable to update superblock counters. Freespace may not be correct on next mount.
    XFS (dm-16): xfs_log_force: error 5 returned.
    XFS (¿-¿¿¿): Please umount the filesystem and rectify the problem(s)
    
    It can be seen that the last line of output contains a corrupt
    device name - this is because the log and xfs_mount structures have
    already been freed by the time this message is printed. A kernel
    oops closely follows.
    
    The issue is that the shutdown is occurring in a separate IO
    completion thread to the unmount. Once the shutdown processing has
    started and all the iclogs are marked with XLOG_STATE_IOERROR, the
    log shutdown code wakes anyone waiting on a log force so they can
    process the shutdown error. This wakes up the unmount code that
    is doing a synchronous transaction to update the superblock
    counters.
    
    The unmount path now sees all the iclogs are marked with
    XLOG_STATE_IOERROR and so never waits on them again, knowing that if
    it does, there will not be a wakeup trigger for it and we will hang
    the unmount if we do. Hence the unmount runs through all the
    remaining code and frees all the filesystem structures while the
    xlog_iodone() is still processing the shutdown. When the log
    shutdown processing completes, xfs_do_force_shutdown() emits the
    "Please umount the filesystem and rectify the problem(s)" message,
    and xlog_iodone() then aborts all the objects attached to the iclog.
    An iclog that has already been freed....
    
    The real issue here is that there is no serialisation point between
    the log IO and the unmount. We have serialisations points for log
    writes, log forces, reservations, etc, but we don't actually have
    any code that wakes for log IO to fully complete. We do that for all
    other types of object, so why not iclogbufs?
    
    Well, it turns out that we can easily do this. We've got xfs_buf
    handles, and that's what everyone else uses for IO serialisation.
    i.e. bp->b_sema. So, lets hold iclogbufs locked over IO, and only
    release the lock in xlog_iodone() when we are finished with the
    buffer. That way before we tear down the iclog, we can lock and
    unlock the buffer to ensure IO completion has finished completely
    before we tear it down.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Tested-by: Mike Snitzer <snitzer@redhat.com>
    Tested-by: Bob Mastors <bob.mastors@solidfire.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 5425a32d36703bf4099d597bb4eea5581efc2660
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Apr 14 18:16:30 2014 +1000

    xfs: collapse range is delalloc challenged
    
    FSX has been detecting data corruption after to collapse range
    calls. The key observation is that the offset of the last extent in
    the file was not being shifted, and hence when the file size was
    adjusted it was truncating away data because the extents handled
    been correctly shifted.
    
    Tracing indicated that before the collapse, the extent list looked
    like:
    
    ....
    ino 0x5788 state  idx 6 offset 26 block 195904 count 10 flag 0
    ino 0x5788 state  idx 7 offset 39 block 195917 count 35 flag 0
    ino 0x5788 state  idx 8 offset 86 block 195964 count 32 flag 0
    
    and after the shift of 2 blocks:
    
    ino 0x5788 state  idx 6 offset 24 block 195904 count 10 flag 0
    ino 0x5788 state  idx 7 offset 37 block 195917 count 35 flag 0
    ino 0x5788 state  idx 8 offset 86 block 195964 count 32 flag 0
    
    Note that the last extent did not change offset. After the changing
    of the file size:
    
    ino 0x5788 state  idx 6 offset 24 block 195904 count 10 flag 0
    ino 0x5788 state  idx 7 offset 37 block 195917 count 35 flag 0
    ino 0x5788 state  idx 8 offset 86 block 195964 count 30 flag 0
    
    You can see that the last extent had it's length truncated,
    indicating that we've lost data.
    
    The reason for this is that the xfs_bmap_shift_extents() loop uses
    XFS_IFORK_NEXTENTS() to determine how many extents are in the inode.
    This, unfortunately, doesn't take into account delayed allocation
    extents - it's a count of physically allocated extents - and hence
    when the file being collapsed has a delalloc extent like this one
    does prior to the range being collapsed:
    
    ....
    ino 0x5788 state  idx 4 offset 11 block 4503599627239429 count 1 flag 0
    ....
    
    it gets the count wrong and terminates the shift loop early.
    
    Fix it by using the in-memory extent array size that includes
    delayed allocation extents to determine the number of extents on the
    inode.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Tested-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 68c1fb5d82c8206e78895169810298f181b9183a
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Apr 14 18:15:45 2014 +1000

    xfs: don't map ranges that span EOF for direct IO
    
    Al Viro tracked down the problem that has caused generic/263 to fail
    on XFS since the test was introduced. If is caused by
    xfs_get_blocks() mapping a single extent that spans EOF without
    marking it as buffer-new() so that the direct IO code does not zero
    the tail of the block at the new EOF. This is a long standing bug
    that has been around for many, many years.
    
    Because xfs_get_blocks() starts the map before EOF, it can't set
    buffer_new(), because that causes he direct IO code to also zero
    unaligned sectors at the head of the IO. This would overwrite valid
    data with zeros, and hence we cannot validly return a single extent
    that spans EOF to direct IO.
    
    Fix this by detecting a mapping that spans EOF and truncate it down
    to EOF. This results in the the direct IO code doing the right thing
    for unaligned data blocks before EOF, and then returning to get
    another mapping for the region beyond EOF which XFS treats correctly
    by setting buffer_new() on it. This makes direct Io behave correctly
    w.r.t. tail block zeroing beyond EOF, and fsx is happy about that.
    
    Again, thanks to Al Viro for finding what I couldn't.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Tested-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 897b73b6a2ee5d3c06648b601beb1724f7fbd678
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Apr 14 18:15:11 2014 +1000

    xfs: zeroing space needs to punch delalloc blocks
    
    When we are zeroing space andit is covered by a delalloc range, we
    need to punch the delalloc range out before we truncate the page
    cache. Failing to do so leaves and inconsistency between the page
    cache and the extent tree, which we later trip over when doing
    direct IO over the same range.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Tested-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit aad3f3755e7f043789b772856d1a2935f2b41a4b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Apr 14 18:14:11 2014 +1000

    xfs: xfs_vm_write_end truncates too much on failure
    
    Similar to the write_begin problem, xfs-vm_write_end will truncate
    back to the old EOF, potentially removing page cache from over the
    top of delalloc blocks with valid data in them. Fix this by
    truncating back to just the start of the failed write.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Tested-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 72ab70a19b4ebb19dbe2a79faaa6a4ccead58e70
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Apr 14 18:13:29 2014 +1000

    xfs: write failure beyond EOF truncates too much data
    
    If we fail a write beyond EOF and have to handle it in
    xfs_vm_write_begin(), we truncate the inode back to the current inode
    size. This doesn't take into account the fact that we may have
    already made successful writes to the same page (in the case of block
    size < page size) and hence we can truncate the page cache away from
    blocks with valid data in them. If these blocks are delayed
    allocation blocks, we now have a mismatch between the page cache and
    the extent tree, and this will trigger - at minimum - a delayed
    block count mismatch assert when the inode is evicted from the cache.
    We can also trip over it when block mapping for direct IO - this is
    the most common symptom seen from fsx and fsstress when run from
    xfstests.
    
    Fix it by only truncating away the exact range we are updating state
    for in this write_begin call.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Tested-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 4ab9ed578e82851645f3dd69d36d91ae77564d6c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Apr 14 18:11:58 2014 +1000

    xfs: kill buffers over failed write ranges properly
    
    When a write fails, if we don't clear the delalloc flags from the
    buffers over the failed range, they can persist beyond EOF and cause
    problems. writeback will see the pages in the page cache, see they
    are dirty and continually retry the write, assuming that the page
    beyond EOF is just racing with a truncate. The page will eventually
    be released due to some other operation (e.g. direct IO), and it
    will not pass through invalidation because it is dirty. Hence it
    will be released with buffer_delay set on it, and trigger warnings
    in xfs_vm_releasepage() and assert fail in xfs_file_aio_write_direct
    because invalidation failed and we didn't write the corect amount.
    
    This causes failures on block size < page size filesystems in fsx
    and fsstress workloads run by xfstests.
    
    Fix it by completely trashing any state on the buffer that could be
    used to imply that it contains valid data when the delalloc range
    over the buffer is punched out during the failed write handling.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Tested-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree


--===============7613263070656622526==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7613263070656622526==--
