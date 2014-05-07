Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-misc-fixes-1-for-3.16,
	created. xfs-for-linus-3.15-rc1-14833-g8cfcc3e
Message-Id: <20140507080922.13C567F4E@oss.sgi.com>
Date: Wed,  7 May 2014 03:09:21 -0500 (CDT)
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

The branch, xfs-misc-fixes-1-for-3.16 has been created
        at  8cfcc3e565bf15870efe801368a25ca98092e6e7 (commit)

- Log -----------------------------------------------------------------
commit 8cfcc3e565bf15870efe801368a25ca98092e6e7
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed May 7 08:05:52 2014 +1000

    xfs: fix directory readahead offset off-by-one
    
    Directory readahead can throw loud scary but harmless warnings
    when multiblock directories are in use a specific pattern of
    discontiguous blocks are found in the directory. That is, if a hole
    follows a discontiguous block, it will throw a warning like:
    
    XFS (dm-1): xfs_da_do_buf: bno 637 dir: inode 34363923462
    XFS (dm-1): [00] br_startoff 637 br_startblock 1917954575 br_blockcount 1 br_state 0
    XFS (dm-1): [01] br_startoff 638 br_startblock -2 br_blockcount 1 br_state 0
    
    And dump a stack trace.
    
    This is because the readahead offset increment loop does a double
    increment of the block index - it does an increment for the loop
    iteration as well as increase the loop counter by the number of
    blocks in the extent. As a result, the readahead offset does not get
    incremented correctly for discontiguous blocks and hence can ask for
    readahead of a directory block from an offset part way through a
    directory block.  If that directory block is followed by a hole, it
    will trigger a mapping warning like the above.
    
    The bad readahead will be ignored, though, because the main
    directory block read loop uses the correct mapping offsets rather
    than the readahead offset and so will ignore the bad readahead
    altogether.
    
    Fix the warning by ensuring that the readahead offset is correctly
    incremented.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit ac983517ec5941da0c58cacdbad10a231dc4e001
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed May 7 08:05:50 2014 +1000

    xfs: don't sleep in xlog_cil_force_lsn on shutdown
    
    Reports of a shutdown hang when fsyncing a directory have surfaced,
    such as this:
    
    [ 3663.394472] Call Trace:
    [ 3663.397199]  [<ffffffff815f1889>] schedule+0x29/0x70
    [ 3663.402743]  [<ffffffffa01feda5>] xlog_cil_force_lsn+0x185/0x1a0 [xfs]
    [ 3663.416249]  [<ffffffffa01fd3af>] _xfs_log_force_lsn+0x6f/0x2f0 [xfs]
    [ 3663.429271]  [<ffffffffa01a339d>] xfs_dir_fsync+0x7d/0xe0 [xfs]
    [ 3663.435873]  [<ffffffff811df8c5>] do_fsync+0x65/0xa0
    [ 3663.441408]  [<ffffffff811dfbc0>] SyS_fsync+0x10/0x20
    [ 3663.447043]  [<ffffffff815fc7d9>] system_call_fastpath+0x16/0x1b
    
    If we trigger a shutdown in xlog_cil_push() from xlog_write(), we
    will never wake waiters on the current push sequence number, so
    anything waiting in xlog_cil_force_lsn() for that push sequence
    number to come up will not get woken and hence stall the shutdown.
    
    Fix this by ensuring we call wake_up_all(&cil->xc_commit_wait) in
    the push abort handling, in the log shutdown code when waking all
    waiters, and adding a shutdown check in the sequence completion wait
    loops to ensure they abort when a wakeup due to a shutdown occurs.
    
    Reported-by: Boris Ranto <branto@redhat.com>
    Reported-by: Eric Sandeen <esandeen@redhat.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 49abc3a8f84146f74daadbaa7cde7d34f2bb40a8
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed May 7 08:05:45 2014 +1000

    xfs: truncate_setsize should be outside transactions
    
    truncate_setsize() removes pages from the page cache, and hence
    requires page locks to be held. It is not valid to lock a page cache
    page inside a transaction context as we can hold page locks when we
    we reserve space for a transaction. If we do, then we expose an ABBA
    deadlock between log space reservation and page locks.
    
    That is, both the write path and writeback lock a page, then start a
    transaction for block allocation, which means they can block waiting
    for a log reservation with the page lock held. If we hold a log
    reservation and then do something that locks a page (e.g.
    truncate_setsize in xfs_setattr_size) then that page lock can block
    on the page locked and waiting for a log reservation. If the
    transaction that is waiting for the page lock is the only active
    transaction in the system that can free log space via a commit,
    then writeback will never make progress and so log space will never
    free up.
    
    This issue with xfs_setattr_size() was introduced back in 2010 by
    commit fa9b227 ("xfs: new truncate sequence") which moved the page
    cache truncate from outside the transaction context (what was
    xfs_itruncate_data()) to inside the transaction context as a call to
    truncate_setsize().
    
    The reason truncate_setsize() was located where in this place was
    that we can't shouldn't change the file size until after we are in
    the transaction context and the operation will either succeed or
    shut down the filesystem on failure. However, block_truncate_page()
    already modifies the file contents before we enter the transaction
    context, so we can't really fulfill this guarantee in any way. Hence
    we may as well ensure that on success or failure, the in-memory
    inode and data is truncated away and that the application cleans up
    the mess appropriately.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit b28fd7b5fe232d7643d7c0595938e998ceb58508
Author: From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Date:   Mon May 5 17:30:20 2014 +1000

    xfs: Fix wrong error codes being returned
    
    xfs_{compat_,}attrmulti_by_handle could return an errno with incorrect
    sign in some cases. While at it, make sure ENOMEM is returned instead of
    E2BIG if kmalloc fails.
    
    Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 3c353375761d81abfb66eb054aacceef31658e24
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 5 17:30:15 2014 +1000

    xfs: remove dquot hints
    
    group and project quota hints are currently stored on the user
    dquot. If we are attaching quotas to the inode, then the group and
    project dquots are stored as hints on the user dquot to save having
    to look them up again later.
    
    The thing is, the hints are not used for that inode for the rest of
    the life of the inode - the dquots are attached directly to the
    inode itself - so the only time the hints are used is when an inode
    first has dquots attached.
    
    When the hints on the user dquot don't match the dquots being
    attache dto the inode, they are then removed and replaced with the
    new hints. If a user is concurrently modifying files in different
    group and/or project contexts, then this leads to thrashing of the
    hints attached to user dquot.
    
    If user quotas are not enabled, then hints are never even used.
    
    So, if the hints are used to avoid the cost of the lookup, is the
    cost of the lookup significant enough to justify the hint
    infrstructure? Maybe it was once, when there was a global quota
    manager shared between all XFS filesystems and was hash table based.
    
    However, lookups are now much simpler, requiring only a single lock and
    radix tree lookup local to the filesystem and no hash or LRU
    manipulations to be made. Hence the cost of lookup is much lower
    than when hints were implemented. Turns out that benchmarks show
    that, too, with thir being no differnce in performance when doing
    file creation workloads as a single user with user, group and
    project quotas enabled - the hints do not make the code go any
    faster. In fact, removing the hints shows a 2-3% reduction in the
    time it takes to create 50 million inodes....
    
    So, let's just get rid of the hints and the complexity around them.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit f58522c5a47a1862c6b3fad97ea9285c5d68199d
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon May 5 17:27:06 2014 +1000

    xfs: bulletfproof xfs_qm_scall_trunc_qfiles()
    
    Coverity noticed that if we sent junk into
    xfs_qm_scall_trunc_qfiles(), we could get back an
    uninitialized error value.  So sanitize the flags we
    will accept, and initialize error anyway for good measure.
    
    (This bug may have been introduced via c61a9e39).
    
    Should resolve Coverity CID 1163872.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 9da93f9b7cdf8ab28da6b364cdc1fafc8670b4dc
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Mon May 5 17:25:50 2014 +1000

    xfs: fix Q_XQUOTARM ioctl
    
    The Q_XQUOTARM quotactl was not working properly, because
    we weren't passing around proper flags.  The xfs_fs_set_xstate()
    ioctl handler used the same flags for Q_XQUOTAON/OFF as
    well as for Q_XQUOTARM, but Q_XQUOTAON/OFF look for
    XFS_UQUOTA_ACCT, XFS_UQUOTA_ENFD, XFS_GQUOTA_ACCT etc,
    i.e. quota type + state, while Q_XQUOTARM looks only for
    the type of quota, i.e. XFS_DQ_USER, XFS_DQ_GROUP etc.
    
    Unfortunately these flag spaces overlap a bit, so we
    got semi-random results for Q_XQUOTARM; i.e. the value
    for XFS_DQ_USER == XFS_UQUOTA_ACCT, etc.  yeargh.
    
    Add a new quotactl op vector specifically for the QUOTARM
    operation, since it operates with a different flag space.
    
    This has been broken more or less forever, AFAICT.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Acked-by: Jan Kara <jack@suse.cz>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
