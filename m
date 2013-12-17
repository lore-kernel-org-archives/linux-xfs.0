Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-for-linus-v3.13-rc5,
	created. xfs-for-linus-v3.13-rc4-9-gac8809f
Message-Id: <20131217155308.F1E6729DF8@oss.sgi.com>
Date: Tue, 17 Dec 2013 09:53:08 -0600 (CST)
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

The branch, xfs-for-linus-v3.13-rc5 has been created
        at  ac8809f9ab01a73de1a47b5a37bd8dcca8712fb3 (commit)

- Log -----------------------------------------------------------------
commit ac8809f9ab01a73de1a47b5a37bd8dcca8712fb3
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Dec 12 16:34:38 2013 +1100

    xfs: abort metadata writeback on permanent errors
    
    If we are doing aysnc writeback of metadata, we can get write errors
    but have nobody to report them to. At the moment, we simply attempt
    to reissue the write from io completion in the hope that it's a
    transient error.
    
    When it's not a transient error, the buffer is stuck forever in
    this loop, and we cannot break out of it. Eventually, unmount will
    hang because the AIL cannot be emptied and everything goes downhill
    from them.
    
    To solve this problem, only retry the write IO once before aborting
    it. We don't throw the buffer away because some transient errors can
    last minutes (e.g.  FC path failover) or even hours (thin
    provisioned devices that have run out of backing space) before they
    go away. Hence we really want to keep trying until we can't try any
    more.
    
    Because the buffer was not cleaned, however, it does not get removed
    from the AIL and hence the next pass across the AIL will start IO on
    it again. As such, we still get the "retry forever" semantics that
    we currently have, but we allow other access to the buffer in the
    mean time. Meanwhile the filesystem can continue to modify the
    buffer and relog it, so the IO errors won't hang the log or the
    filesystem.
    
    Now when we are pushing the AIL, we can see all these "permanent IO
    error" buffers and we can issue a warning about failures before we
    retry the IO. We can also catch these buffers when unmounting an
    issue a corruption warning, too.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 33177f05364c6cd13b06d0f3500dad07cf4647c2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Dec 12 16:34:36 2013 +1100

    xfs: swalloc doesn't align allocations properly
    
    When swalloc is specified as a mount option, allocations are
    supposed to be aligned to the stripe width rather than the stripe
    unit of the underlying filesystem. However, it does not do this.
    
    What the implementation does is round up the allocation size to a
    stripe width, hence ensuring that all allocations span a full stripe
    width. It does not, however, ensure that that allocation is aligned
    to a stripe width, and hence the allocations can span multiple
    underlying stripes and so still see RMW cycles for things like
    direct IO on MD RAID.
    
    So, if the swalloc mount option is set, change the allocation
    alignment in xfs_bmap_btalloc() to use the stripe width rather than
    the stripe unit.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 83a0adc3f93aae4ab9c59113e3145c7bdb2b4a8c
Author: Christoph Hellwig <hch@infradead.org>
Date:   Tue Dec 17 00:03:52 2013 -0800

    xfs: remove xfsbdstrat error
    
    The xfsbdstrat helper is a small but useless wrapper for xfs_buf_iorequest that
    handles the case of a shut down filesystem.  Most of the users have private,
    uncached buffers that can just be freed in this case, but the complex error
    handling in xfs_bioerror_relse messes up the case when it's called without
    a locked buffer.
    
    Remove xfsbdstrat and opencode the error handling in the callers.  All but
    one can simply return an error and don't need to deal with buffer state,
    and the one caller that cares about the buffer state could do with a major
    cleanup as well, but we'll defer that to later.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 6e708bcf6583f663da9fe7bc5292cc62f0a8410d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Nov 22 10:41:16 2013 +1100

    xfs: align initial file allocations correctly
    
    The function xfs_bmap_isaeof() is used to indicate that an
    allocation is occurring at or past the end of file, and as such
    should be aligned to the underlying storage geometry if possible.
    
    Commit 27a3f8f ("xfs: introduce xfs_bmap_last_extent") changed the
    behaviour of this function for empty files - it turned off
    allocation alignment for this case accidentally. Hence large initial
    allocations from direct IO are not getting correctly aligned to the
    underlying geometry, and that is cause write performance to drop in
    alignment sensitive configurations.
    
    Fix it by considering allocation into empty files as requiring
    aligned allocation again.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit f9b395a8ef8f34d19cae2cde361e19c96e097fad)

commit 809625ca544bdc9e02a5728c1939a76dc29decb1
Author: Namjae Jeon <namjae.jeon@samsung.com>
Date:   Sun Dec 8 23:33:50 2013 +0900

    MAINTAINERS: fix incorrect mail address of XFS maintainer
    
    When I tried to send the patches to XFS Maintainers,
    I got returned mail included delivery fail message for Dave's mail.
    Maybe, Dave Chinner mail address is incorrect.
    I try to fix it correctly.
    
    Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit db10bddc7d4f412bcd8630fc479fa1eb009e325b)

commit 718cc6f88cbfc4fbd39609f28c4c86883945f90d
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Tue Nov 26 21:38:49 2013 +0800

    xfs: fix infinite loop by detaching the group/project hints from user dquot
    
    xfs_quota(8) will hang up if trying to turn group/project quota off
    before the user quota is off, this could be 100% reproduced by:
      # mount -ouquota,gquota /dev/sda7 /xfs
      # mkdir /xfs/test
      # xfs_quota -xc 'off -g' /xfs <-- hangs up
      # echo w > /proc/sysrq-trigger
      # dmesg
    
      SysRq : Show Blocked State
      task                        PC stack   pid father
      xfs_quota       D 0000000000000000     0 27574   2551 0x00000000
      [snip]
      Call Trace:
      [<ffffffff81aaa21d>] schedule+0xad/0xc0
      [<ffffffff81aa327e>] schedule_timeout+0x35e/0x3c0
      [<ffffffff8114b506>] ? mark_held_locks+0x176/0x1c0
      [<ffffffff810ad6c0>] ? call_timer_fn+0x2c0/0x2c0
      [<ffffffffa0c25380>] ? xfs_qm_shrink_count+0x30/0x30 [xfs]
      [<ffffffff81aa3306>] schedule_timeout_uninterruptible+0x26/0x30
      [<ffffffffa0c26155>] xfs_qm_dquot_walk+0x235/0x260 [xfs]
      [<ffffffffa0c059d8>] ? xfs_perag_get+0x1d8/0x2d0 [xfs]
      [<ffffffffa0c05805>] ? xfs_perag_get+0x5/0x2d0 [xfs]
      [<ffffffffa0b7707e>] ? xfs_inode_ag_iterator+0xae/0xf0 [xfs]
      [<ffffffffa0c22280>] ? xfs_trans_free_dqinfo+0x50/0x50 [xfs]
      [<ffffffffa0b7709f>] ? xfs_inode_ag_iterator+0xcf/0xf0 [xfs]
      [<ffffffffa0c261e6>] xfs_qm_dqpurge_all+0x66/0xb0 [xfs]
      [<ffffffffa0c2497a>] xfs_qm_scall_quotaoff+0x20a/0x5f0 [xfs]
      [<ffffffffa0c2b8f6>] xfs_fs_set_xstate+0x136/0x180 [xfs]
      [<ffffffff8136cf7a>] do_quotactl+0x53a/0x6b0
      [<ffffffff812fba4b>] ? iput+0x5b/0x90
      [<ffffffff8136d257>] SyS_quotactl+0x167/0x1d0
      [<ffffffff814cf2ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
      [<ffffffff81abcd19>] system_call_fastpath+0x16/0x1b
    
    It's fine if we turn user quota off at first, then turn off other
    kind of quotas if they are enabled since the group/project dquot
    refcount is decreased to zero once the user quota if off. Otherwise,
    those dquots refcount is non-zero due to the user dquot might refer
    to them as hint(s).  Hence, above operation cause an infinite loop
    at xfs_qm_dquot_walk() while trying to purge dquot cache.
    
    This problem has been around since Linux 3.4, it was introduced by:
      [ b84a3a9675 xfs: remove the per-filesystem list of dquots ]
    
    Originally we will release the group dquot pointers because the user
    dquots maybe carrying around as a hint via xfs_qm_detach_gdquots().
    However, with above change, there is no such work to be done before
    purging group/project dquot cache.
    
    In order to solve this problem, this patch introduces a special routine
    xfs_qm_dqpurge_hints(), and it would release the group/project dquot
    pointers the user dquots maybe carrying around as a hint, and then it
    will proceed to purge the user dquot cache if requested.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit df8052e7dae00bde6f21b40b6e3e1099770f3afc)

commit 5c22727895bf61cb851835be0d30260fb36de648
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Tue Nov 26 21:38:34 2013 +0800

    xfs: fix assertion failure at xfs_setattr_nonsize
    
    For CRC enabled v5 super block, change a file's ownership can simply
    trigger an ASSERT failure at xfs_setattr_nonsize() if both group and
    project quota are enabled, i.e,
    
    [  305.337609] XFS: Assertion failed: !XFS_IS_PQUOTA_ON(mp), file: fs/xfs/xfs_iops.c, line: 621
    [  305.339250] Kernel BUG at ffffffffa0a7fa32 [verbose debug info unavailable]
    [  305.383939] Call Trace:
    [  305.385536]  [<ffffffffa0a7d95a>] xfs_setattr_nonsize+0x69a/0x720 [xfs]
    [  305.387142]  [<ffffffffa0a7dea9>] xfs_vn_setattr+0x29/0x70 [xfs]
    [  305.388727]  [<ffffffff811ca388>] notify_change+0x1a8/0x350
    [  305.390298]  [<ffffffff811ac39d>] chown_common+0xfd/0x110
    [  305.391868]  [<ffffffff811ad6bf>] SyS_fchownat+0xaf/0x110
    [  305.393440]  [<ffffffff811ad760>] SyS_lchown+0x20/0x30
    [  305.394995]  [<ffffffff8170f7dd>] system_call_fastpath+0x1a/0x1f
    [  305.399870] RIP  [<ffffffffa0a7fa32>] assfail+0x22/0x30 [xfs]
    
    This fix adjust the assertion to check if the super block support both
    quota inodes or not.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 5a01dd54f4a7fb513062070c5acef20d13cad980)

commit 30d161c9aacb4b719789c30623b9eec7d1aa1d08
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Tue Nov 26 21:38:54 2013 +0800

    xfs: fix false assertion at xfs_qm_vop_create_dqattach
    
    After the previous fix, there still has another ASSERT failure if turning
    off any type of quota while fsstress is running at the same time.
    
    Backtrace in this case:
    
    [   50.867897] XFS: Assertion failed: XFS_IS_GQUOTA_ON(mp), file: fs/xfs/xfs_qm.c, line: 2118
    [   50.867924] ------------[ cut here ]------------
    ... <snip>
    [   50.867957] Kernel BUG at ffffffffa0b55a32 [verbose debug info unavailable]
    [   50.867999] invalid opcode: 0000 [#1] SMP
    [   50.869407] Call Trace:
    [   50.869446]  [<ffffffffa0bc408a>] xfs_qm_vop_create_dqattach+0x19a/0x2d0 [xfs]
    [   50.869512]  [<ffffffffa0b9cc45>] xfs_create+0x5c5/0x6a0 [xfs]
    [   50.869564]  [<ffffffffa0b5307c>] xfs_vn_mknod+0xac/0x1d0 [xfs]
    [   50.869615]  [<ffffffffa0b531d6>] xfs_vn_mkdir+0x16/0x20 [xfs]
    [   50.869655]  [<ffffffff811becd5>] vfs_mkdir+0x95/0x130
    [   50.869689]  [<ffffffff811bf63a>] SyS_mkdirat+0xaa/0xe0
    [   50.869723]  [<ffffffff811bf689>] SyS_mkdir+0x19/0x20
    [   50.869757]  [<ffffffff8170f7dd>] system_call_fastpath+0x1a/0x1f
    [   50.869793] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 <snip>
    [   50.870003] RIP  [<ffffffffa0b55a32>] assfail+0x22/0x30 [xfs]
    [   50.870050]  RSP <ffff88002941fd60>
    [   50.879251] ---[ end trace c93a2b342341c65b ]---
    
    We're hitting the ASSERT(XFS_IS_*QUOTA_ON(mp)) in xfs_qm_vop_create_dqattach(),
    however the assertion itself is not right IMHO.  While performing quota off, we
    firstly clear the XFS_*QUOTA_ACTIVE bit(s) from struct xfs_mount without taking
    any special locks, see xfs_qm_scall_quotaoff().  Hence there is no guarantee
    that the desired quota is still active.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 37eb9706ebf5b99d14c6086cdeef2c2f73f9c9fb)

commit 3a8c92086d1c05ae1cf6a52ffd8dde2851e6b1d3
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Sat Oct 5 21:48:25 2013 -0500

    xfs: fix memory leak in xfs_dir2_node_removename
    
    Fix the leak of kernel memory in xfs_dir2_node_removename()
    when xfs_dir2_leafn_remove() returns an error code.
    
    Signed-off-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit ef701600fd26cace9d513ee174688a2b83832126)

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
