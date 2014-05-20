Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-misc-fixes-2-for-3.16,
	created. xfs-for-linus-3.15-rc5-1271-g376c2f3
Message-Id: <20140520054109.EBFD17F5F@oss.sgi.com>
Date: Tue, 20 May 2014 00:41:09 -0500 (CDT)
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

The branch, xfs-misc-fixes-2-for-3.16 has been created
        at  376c2f3a5f0706868b08ccf043bf3532936a03b1 (commit)

- Log -----------------------------------------------------------------
commit 376c2f3a5f0706868b08ccf043bf3532936a03b1
Author: Roger Willcocks <roger@filmlight.ltd.uk>
Date:   Tue May 20 08:52:21 2014 +1000

    xfs: fix compile error when libxfs header used in C++ code
    
    xfs_ialloc.h:102: error: expected ',' or '...' before 'delete'
    
    Simple parameter rename, no changes to behaviour.
    
    Signed-off-by: Roger Willcocks <roger@filmlight.ltd.uk>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 8695d27ec34b19c58a0dc25bfcce3f2c6cf0699d
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Tue May 20 08:24:26 2014 +1000

    xfs: fix infinite loop at xfs_vm_writepage on 32bit system
    
    Write to a file with an offset greater than 16TB on 32-bit system and
    then trigger page write-back via sync(1) will cause task hang.
    
    # block_size=4096
    # offset=$(((2**32 - 1) * $block_size))
    # xfs_io -f -c "pwrite $offset $block_size" /storage/test_file
    # sync
    
    INFO: task sync:2590 blocked for more than 120 seconds.
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    sync            D c1064a28     0  2590   2097 0x00000000
    .....
    Call Trace:
    [<c1064a28>] ? ttwu_do_wakeup+0x18/0x130
    [<c1066d0e>] ? try_to_wake_up+0x1ce/0x220
    [<c1066dbf>] ? wake_up_process+0x1f/0x40
    [<c104fc2e>] ? wake_up_worker+0x1e/0x30
    [<c15b6083>] schedule+0x23/0x60
    [<c15b3c2d>] schedule_timeout+0x18d/0x1f0
    [<c12a143e>] ? do_raw_spin_unlock+0x4e/0x90
    [<c10515f1>] ? __queue_delayed_work+0x91/0x150
    [<c12a12ef>] ? do_raw_spin_lock+0x3f/0x100
    [<c12a143e>] ? do_raw_spin_unlock+0x4e/0x90
    [<c15b5b5d>] wait_for_completion+0x7d/0xc0
    [<c1066d60>] ? try_to_wake_up+0x220/0x220
    [<c116a4d2>] sync_inodes_sb+0x92/0x180
    [<c116fb05>] sync_inodes_one_sb+0x15/0x20
    [<c114a8f8>] iterate_supers+0xb8/0xc0
    [<c116faf0>] ? fdatawrite_one_bdev+0x20/0x20
    [<c116fc21>] sys_sync+0x31/0x80
    [<c15be18d>] sysenter_do_call+0x12/0x28
    
    This issue can be triggered via xfstests/generic/308.
    
    The reason is that the end_index is unsigned long with maximum value
    '2^32-1=4294967295' on 32-bit platform, and the given offset cause it
    wrapped to 0, so that the following codes will repeat again and again
    until the task schedule time out:
    
    end_index = offset >> PAGE_CACHE_SHIFT;
    last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
    if (page->index >= end_index) {
    	unsigned offset_into_page = offset & (PAGE_CACHE_SIZE - 1);
            /*
             * Just skip the page if it is fully outside i_size, e.g. due
             * to a truncate operation that is in progress.
             */
            if (page->index >= end_index + 1 || offset_into_page == 0) {
    	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    		unlock_page(page);
    		return 0;
    	}
    
    In order to check if a page is fully outsids i_size or not, we can fix
    the code logic as below:
    	if (page->index > end_index ||
    	    (page->index == end_index && offset_into_page == 0))
    
    Secondly, there still has another similar issue when calculating the
    end offset for mapping the filesystem blocks to the file blocks for
    delalloc.  With the same tests to above, run unmount(8) will cause
    kernel panic if CONFIG_XFS_DEBUG is enabled:
    
    XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || \
    	ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 964
    
    kernel BUG at fs/xfs/xfs_message.c:108!
    invalid opcode: 0000 [#1] SMP
    task: edddc100 ti: ec6ee000 task.ti: ec6ee000
    EIP: 0060:[<f83d87cb>] EFLAGS: 00010296 CPU: 1
    EIP is at assfail+0x2b/0x30 [xfs]
    ..............
    Call Trace:
    [<f83d9cd4>] xfs_fs_destroy_inode+0x74/0x120 [xfs]
    [<c115ddf1>] destroy_inode+0x31/0x50
    [<c115deff>] evict+0xef/0x170
    [<c115dfb2>] dispose_list+0x32/0x40
    [<c115ea3a>] evict_inodes+0xca/0xe0
    [<c1149706>] generic_shutdown_super+0x46/0xd0
    [<c11497b9>] kill_block_super+0x29/0x70
    [<c1149a14>] deactivate_locked_super+0x44/0x70
    [<c114a427>] deactivate_super+0x47/0x60
    [<c1161c3d>] mntput_no_expire+0xcd/0x120
    [<c1162ae8>] SyS_umount+0xa8/0x370
    [<c1162dce>] SyS_oldumount+0x1e/0x20
    [<c15be18d>] sysenter_do_call+0x12/0x28
    
    That because the end_offset is evaluated to 0 which is the same reason
    to above, hence the mapping and covertion for dealloc file blocks to
    file system blocks did not happened.
    
    This patch just fixed both issues.
    
    Reported-by: Michael L. Semon <mlsemon35@gmail.com>
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 7c166350b15cbec4ed9357563461b6e1d2a44ea9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 20 08:23:06 2014 +1000

    xfs: remove redundant checks from xfs_da_read_buf
    
    All of the verification checks of magic numbers are now done by
    verifiers, so ther eis no need to check them again once the buffer
    has been successfully read. If the magic number is bad, it won't
    even get to that code to verify it so it really serves no purpose at
    all anymore. Remove it.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 110dc24ad2ae4e9b94b08632fe1eb2fcdff83045
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 20 08:18:09 2014 +1000

    xfs: log vector rounding leaks log space
    
    The addition of direct formatting of log items into the CIL
    linear buffer added alignment restrictions that the start of each
    vector needed to be 64 bit aligned. Hence padding was added in
    xlog_finish_iovec() to round up the vector length to ensure the next
    vector started with the correct alignment.
    
    This adds a small number of bytes to the size of
    the linear buffer that is otherwise unused. The issue is that we
    then use the linear buffer size to determine the log space used by
    the log item, and this includes the unused space. Hence when we
    account for space used by the log item, it's more than is actually
    written into the iclogs, and hence we slowly leak this space.
    
    This results on log hangs when reserving space, with threads getting
    stuck with these stack traces:
    
    Call Trace:
    [<ffffffff81d15989>] schedule+0x29/0x70
    [<ffffffff8150d3a2>] xlog_grant_head_wait+0xa2/0x1a0
    [<ffffffff8150d55d>] xlog_grant_head_check+0xbd/0x140
    [<ffffffff8150ee33>] xfs_log_reserve+0x103/0x220
    [<ffffffff814b7f05>] xfs_trans_reserve+0x2f5/0x310
    .....
    
    The 4 bytes is significant. Brain Foster did all the hard work in
    tracking down a reproducable leak to inode chunk allocation (it went
    away with the ikeep mount option). His rough numbers were that
    creating 50,000 inodes leaked 11 log blocks. This turns out to be
    roughly 800 inode chunks or 1600 inode cluster buffers. That
    works out at roughly 4 bytes per cluster buffer logged, and at that
    I started looking for a 4 byte leak in the buffer logging code.
    
    What I found was that a struct xfs_buf_log_format structure for an
    inode cluster buffer is 28 bytes in length. This gets rounded up to
    32 bytes, but the vector length remains 28 bytes. Hence the CIL
    ticket reservation is decremented by 32 bytes (via lv->lv_buf_len)
    for that vector rather than 28 bytes which are written into the log.
    
    The fix for this problem is to separately track the bytes used by
    the log vectors in the item and use that instead of the buffer
    length when accounting for the log space that will be used by the
    formatted log item.
    
    Again, thanks to Brian Foster for doing all the hard work and long
    hours to isolate this leak and make finding the bug relatively
    simple.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit ce576f1c5688caade085ae9bba729e886b7ab1d9
Author: Namjae Jeon <namjae.jeon@samsung.com>
Date:   Tue May 20 08:15:57 2014 +1000

    xfs: remove XFS_TRANS_RESERVE in collapse range
    
    There is no need to dip into reserve pool. Reserve pool is used for much
    more important things. And xfs_trans_reserve will never return ENOSPC
    because punch hole is already done. If we get ENOSPC, collapse range
    will be simply failed.
    
    Cc: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
    Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
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
