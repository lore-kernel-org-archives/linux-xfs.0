Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-misc-fixes-for-3.18-2,
	created. v3.16-11814-g2ebff7b
Message-Id: <20140923133047.BB95A7F51@oss.sgi.com>
Date: Tue, 23 Sep 2014 08:30:47 -0500 (CDT)
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

The branch, xfs-misc-fixes-for-3.18-2 has been created
        at  2ebff7bbd785c86e12956388b9e6f6bb8ea5d21e (commit)

- Log -----------------------------------------------------------------
commit 2ebff7bbd785c86e12956388b9e6f6bb8ea5d21e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 23 22:55:00 2014 +1000

    xfs: flush entire last page of old EOF on truncate up
    
    On a sub-page sized filesystem, truncating a mapped region down
    leaves us in a world of hurt. We truncate the pagecache, zeroing the
    newly unused tail, then punch blocks out from under the page. If we
    then truncate the file back up immediately, we expose that unmapped
    hole to a dirty page mapped into the user application, and that's
    where it all goes wrong.
    
    In truncating the page cache, we avoid unmapping the tail page of
    the cache because it still contains valid data. The problem is that
    it also contains a hole after the truncate, but nobody told the mm
    subsystem that. Therefore, if the page is dirty before the truncate,
    we'll never get a .page_mkwrite callout after we extend the file and
    the application writes data into the hole on the page.  Hence when
    we come to writing that region of the page, it has no blocks and no
    delayed allocation reservation and hence we toss the data away.
    
    This patch adds code to the truncate up case to solve it, by
    ensuring the partial page at the old EOF is always cleaned after we
    do any zeroing and move the EOF upwards. We can't actually serialise
    the page writeback and truncate against page faults (yes, that
    problem AGAIN) so this is really just a best effort and assumes it
    is extremely unlikely that someone is concurrently writing to the
    page at the EOF while extending the file.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 7abbb8f928e5b7cea1edd077131b2ace665c6712
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue Sep 23 16:20:11 2014 +1000

    xfs: xfs_swap_extent_flush can be static
    
    Fix sparse warning introduced by commit 4ef897a ("xfs: flush both
    inodes in xfs_swap_extents").
    
    Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 02cc18764c753befcdc163d1bc668a6599a54585
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue Sep 23 16:15:45 2014 +1000

    xfs: xfs_buf_write_fail_rl_state can be static
    
    Fix sparse warning introduced by commit ac8809f9 ("xfs: abort
    metadata writeback on permanent errors").
    
    Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit ea95961df714f7fc446aa4bedfc61510ed1b59cc
Author: Fengguang Wu <fengguang.wu@intel.com>
Date:   Tue Sep 23 16:11:43 2014 +1000

    xfs: xfs_rtget_summary can be static
    
    Fix sparse warning introduced by commit afabfd3 ("xfs: combine
    xfs_rtmodify_summary and xfs_rtget_summary").
    
    Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit e3cf17962a757e59fed2cbcbda6373c1b35a35dd
Author: Fabian Frederick <fabf@skynet.be>
Date:   Tue Sep 23 16:05:55 2014 +1000

    xfs: remove second xfs_quota.h inclusion in xfs_icache.c
    
    xfs_quota.h was included twice.
    
    Signed-off-by: Fabian Frederick <fabf@skynet.be>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit fb040131561a6b34cefb92cdf598218104abeda0
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Sep 23 16:05:32 2014 +1000

    xfs: don't ASSERT on corrupt ftype
    
    xfs_dir3_data_get_ftype() gets the file type off disk, but ASSERTs
    if it's invalid:
    
         ASSERT(type < XFS_DIR3_FT_MAX);
    
    We shouldn't ASSERT on bad values read from disk.  V3 dirs are
    CRC-protected, but V2 dirs + ftype are not.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 8af3dcd3c89aef10375bdd79d5f336b22b57487c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 23 15:57:59 2014 +1000

    xfs: xlog_cil_force_lsn doesn't always wait correctly
    
    When running a tight mount/unmount loop on an older kernel, RedHat
    QE found that unmount would occasionally hang in
    xfs_buf_unpin_wait() on the superblock buffer. Tracing and other
    debug work by Eric Sandeen indicated that it was hanging on the
    writing of the superblock during unmount immediately after logging
    the superblock counters in a synchronous transaction. Further debug
    indicated that the synchronous transaction was not waiting for
    completion correctly, and we narrowed it down to
    xlog_cil_force_lsn() returning NULLCOMMITLSN and hence not pushing
    the transaction in the iclog buffer to disk correctly.
    
    While this unmount superblock write code is now very different in
    mainline kernels, the xlog_cil_force_lsn() code is identical, and it
    was bisected to the backport of commit f876e44 ("xfs: always do log
    forces via the workqueue"). This commit made the CIL push
    asynchronous for log forces and hence exposed a race condition that
    couldn't occur on a synchronous push.
    
    Essentially, the xlog_cil_force_lsn() relied implicitly on the fact
    that the sequence push would be complete by the time
    xlog_cil_push_now() returned, resulting in the context being pushed
    being in the committing list. When it was made asynchronous, it was
    recognised that there was a race condition in detecting whether an
    asynchronous push has started or not and code was added to handle
    it.
    
    Unfortunately, the fix was not quite right and left a race condition
    where it it would detect an empty CIL while a push was in progress
    before the context had been added to the committing list. This was
    incorrectly seen as a "nothing to do" condition and so would tell
    xfs_log_force_lsn() that there is nothing to wait for, and hence it
    would push the iclogbufs in memory.
    
    The fix is simple, but explaining the logic and the race condition
    is a lot more complex. The fix is to add the context to the
    committing list before we start emptying the CIL. This allows us to
    detect the difference between an empty "do nothing" push and a push
    that has not started by adding a discrete "emptying the CIL" state
    to avoid the transient, incorrect "empty" condition that the
    (unchanged) waiting code was seeing.
    
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
