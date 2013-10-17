Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.12-rc3-16-g59e5a0e
Message-Id: <20131017222359.B60FA7F54@oss.sgi.com>
Date: Thu, 17 Oct 2013 17:23:59 -0500 (CDT)
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
  59e5a0e xfs: don't break from growfs ag update loop on error
  31625f2 xfs: don't emit corruption noise on fs probes
  08e96e1 xfs: remove newlines from strings passed to __xfs_printk
  2c6e24c xfs: prevent deadlock trying to cover an active log
      from  74564fb48cbfcb5b433c1baec1f3158ea638b203 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 59e5a0e821d838854b3afd030d31f82cee3ecd58
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Fri Oct 11 14:14:05 2013 -0500

    xfs: don't break from growfs ag update loop on error
    
    When xfs_growfs_data_private() is updating backup superblocks,
    it bails out on the first error encountered, whether reading or
    writing:
    
    * If we get an error writing out the alternate superblocks,
    * just issue a warning and continue.  The real work is
    * already done and committed.
    
    This can cause a problem later during repair, because repair
    looks at all superblocks, and picks the most prevalent one
    as correct.  If we bail out early in the backup superblock
    loop, we can end up with more "bad" matching superblocks than
    good, and a post-growfs repair may revert the filesystem to
    the old geometry.
    
    With the combination of superblock verifiers and old bugs,
    we're more likely to encounter read errors due to verification.
    
    And perhaps even worse, we don't even properly write any of the
    newly-added superblocks in the new AGs.
    
    Even with this change, growfs will still say:
    
      xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs cleaning
      data blocks changed from 319815680 to 335216640
    
    which might be confusing to the user, but it at least communicates
    that something has gone wrong, and dmesg will probably highlight
    the need for an xfs_repair.
    
    And this is still best-effort; if verifiers fail on more than
    half the backup supers, they may still "win" - but that's probably
    best left to repair to more gracefully handle by doing its own
    strict verification as part of the backup super "voting."
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Acked-by: Dave Chinner <david@fromorbit.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 31625f28ad7be67701dc4cefcf52087addd88af4
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Fri Oct 11 14:12:31 2013 -0500

    xfs: don't emit corruption noise on fs probes
    
    If we get EWRONGFS due to probing of non-xfs filesystems,
    there's no need to issue the scary corruption error and backtrace.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 08e96e1a3c5fd823f846df813b0b8be8e734c6c2
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Fri Oct 11 20:59:05 2013 -0500

    xfs: remove newlines from strings passed to __xfs_printk
    
    __xfs_printk adds its own "\n".  Having it in the original string
    leads to unintentional blank lines from these messages.
    
    Most format strings have no newline, but a few do, leading to
    i.e.:
    
    [ 7347.119911] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
    [ 7347.119911]
    [ 7347.119919] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
    [ 7347.119919]
    
    Fix them all.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 2c6e24ce1aa6b3b147c75d488c2797ee258eb22b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 15 09:17:49 2013 +1100

    xfs: prevent deadlock trying to cover an active log
    
    Recent analysis of a deadlocked XFS filesystem from a kernel
    crash dump indicated that the filesystem was stuck waiting for log
    space. The short story of the hang on the RHEL6 kernel is this:
    
    	- the tail of the log is pinned by an inode
    	- the inode has been pushed by the xfsaild
    	- the inode has been flushed to it's backing buffer and is
    	  currently flush locked and hence waiting for backing
    	  buffer IO to complete and remove it from the AIL
    	- the backing buffer is marked for write - it is on the
    	  delayed write queue
    	- the inode buffer has been modified directly and logged
    	  recently due to unlinked inode list modification
    	- the backing buffer is pinned in memory as it is in the
    	  active CIL context.
    	- the xfsbufd won't start buffer writeback because it is
    	  pinned
    	- xfssyncd won't force the log because it sees the log as
    	  needing to be covered and hence wants to issue a dummy
    	  transaction to move the log covering state machine along.
    
    Hence there is no trigger to force the CIL to the log and hence
    unpin the inode buffer and therefore complete the inode IO, remove
    it from the AIL and hence move the tail of the log along, allowing
    transactions to start again.
    
    Mainline kernels also have the same deadlock, though the signature
    is slightly different - the inode buffer never reaches the delayed
    write lists because xfs_buf_item_push() sees that it is pinned and
    hence never adds it to the delayed write list that the xfsaild
    flushes.
    
    There are two possible solutions here. The first is to simply force
    the log before trying to cover the log and so ensure that the CIL is
    emptied before we try to reserve space for the dummy transaction in
    the xfs_log_worker(). While this might work most of the time, it is
    still racy and is no guarantee that we don't get stuck in
    xfs_trans_reserve waiting for log space to come free. Hence it's not
    the best way to solve the problem.
    
    The second solution is to modify xfs_log_need_covered() to be aware
    of the CIL. We only should be attempting to cover the log if there
    is no current activity in the log - covering the log is the process
    of ensuring that the head and tail in the log on disk are identical
    (i.e. the log is clean and at idle). Hence, by definition, if there
    are items in the CIL then the log is not at idle and so we don't
    need to attempt to cover it.
    
    When we don't need to cover the log because it is active or idle, we
    issue a log force from xfs_log_worker() - if the log is idle, then
    this does nothing.  However, if the log is active due to there being
    items in the CIL, it will force the items in the CIL to the log and
    unpin them.
    
    In the case of the above deadlock scenario, instead of
    xfs_log_worker() getting stuck in xfs_trans_reserve() attempting to
    cover the log, it will instead force the log, thereby unpinning the
    inode buffer, allowing IO to be issued and complete and hence
    removing the inode that was pinning the tail of the log from the
    AIL. At that point, everything will start moving along again. i.e.
    the xfs_log_worker turns back into a watchdog that can alleviate
    deadlocks based around pinned items that prevent the tail of the log
    from being moved...
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_bmap.c        |  2 +-
 fs/xfs/xfs_buf.c         |  6 +++---
 fs/xfs/xfs_dir2_node.c   |  2 +-
 fs/xfs/xfs_error.c       |  2 +-
 fs/xfs/xfs_fsops.c       | 22 ++++++++++++---------
 fs/xfs/xfs_iomap.c       |  2 +-
 fs/xfs/xfs_log.c         | 50 +++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_log_cil.c     | 14 ++++++++++++++
 fs/xfs/xfs_log_priv.h    | 10 ++++------
 fs/xfs/xfs_log_recover.c |  6 +++---
 fs/xfs/xfs_qm_syscalls.c | 12 ++++++------
 fs/xfs/xfs_sb.c          |  9 +++++----
 fs/xfs/xfs_super.c       |  2 +-
 13 files changed, 83 insertions(+), 56 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
