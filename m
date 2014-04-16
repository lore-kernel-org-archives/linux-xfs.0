Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-fixes-for-3.15-rc2,
	updated. xfs-for-linus-3.15-rc1-14836-g330033d
Message-Id: <20140416234420.69B7A7F58@oss.sgi.com>
Date: Wed, 16 Apr 2014 18:44:19 -0500 (CDT)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4310070565481343512=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4310070565481343512==
Content-Type: text/plain

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, xfs-fixes-for-3.15-rc2 has been updated
  discards  b90159297f95491c348354344e52a4b3da440234 (commit)
  discards  341fcf35d5c111e27c4ef5c2e179a463ff2fc1b5 (commit)
  discards  b7f6608b9de371c79498cd3db4b5346718430a0c (commit)
  discards  d7cc0f34d9b8bdba7f426463ce1dc50a69bcac63 (commit)
  discards  5425a32d36703bf4099d597bb4eea5581efc2660 (commit)
  discards  68c1fb5d82c8206e78895169810298f181b9183a (commit)
  330033d xfs: fix tmpfile/selinux deadlock and initialize security
  8d6c121 xfs: fix buffer use after free on IO error
  07d5035 xfs: wrong error sign conversion during failed DIO writes
  9c23ecc xfs: unmount does not wait for shutdown during unmount
  d39a2ce xfs: collapse range is delalloc challenged
  0e1f789 xfs: don't map ranges that span EOF for direct IO
      from  b90159297f95491c348354344e52a4b3da440234 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 330033d697ed8d296fa52b5303db9d802ad901cc
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Apr 17 08:15:30 2014 +1000

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

commit 8d6c121018bf60d631c05a4a2efc468a392b97bb
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Apr 17 08:15:28 2014 +1000

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

commit 07d5035a289f8bebe0ea86c293b2d5412478c481
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Apr 17 08:15:27 2014 +1000

    xfs: wrong error sign conversion during failed DIO writes
    
    We negate the error value being returned from a generic function
    incorrectly. The code path that it is running in returned negative
    errors, so there is no need to negate it to get the correct error
    signs here.
    
    This was uncovered by generic/019.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 9c23eccc1e746f64b18fab070a37189b4422e44a
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Apr 17 08:15:26 2014 +1000

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

commit d39a2ced0fa0172faa46df0866fc22419b876e2a
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Apr 17 08:15:25 2014 +1000

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

commit 0e1f789d0dc38db79dfc4ddfd9cf541a8c198b7a
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Apr 17 08:15:19 2014 +1000

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
    
    [ dchinner: Fix for __divdi3 build error:
    
    	Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
    	Tested-by: Paul Gortmaker <paul.gortmaker@windriver.com>
    	Signed-off-by: Mark Tinguely <tinguely@sgi.com>
    	Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    ]
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Tested-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_aops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


hooks/post-receive
-- 
XFS development tree


--===============4310070565481343512==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4310070565481343512==--
