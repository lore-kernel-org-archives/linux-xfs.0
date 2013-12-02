Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.13-rc1-2-13360-gdc1ccc4
Message-Id: <20131202223732.A3FFE29E10@oss.sgi.com>
Date: Mon,  2 Dec 2013 16:37:31 -0600 (CST)
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
  6ea9786 Merge tag 'xfs-for-linus-v3.13-rc1-2' of git://oss.sgi.com/xfs/xfs
  7e1a1e9 Merge tag 'xfs-for-linus-v3.13-rc1' of git://oss.sgi.com/xfs/xfs
  c4a391b writeback: do not sync data dirtied after sync start
  b2a42f7 xfs: Use kmem_free() instead of free()
  9b3b77f xfs: fix memory leak in xlog_recover_add_to_trans
  6d31349 xfs: dirent dtype presence is dependent on directory magic numbers
  89c6c89 xfs: lockdep needs to know about 3 dquot-deep nesting
      from  2fe8c1c08b3fbd87dd2641c8f032ff6e965d5803 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 6ea9786e76d74350aee6cd9339c6f7cb765ba291
Merge: 24f971a 2fe8c1c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Nov 22 08:37:47 2013 -0800

    Merge tag 'xfs-for-linus-v3.13-rc1-2' of git://oss.sgi.com/xfs/xfs
    
    Pull second xfs update from Ben Myers:
     "There are a couple of patches that I wasn't quite sure about in time
      for our initial 3.13 pull request, a bugfix, and an update to add Dave
      to MAINTAINERS:
    
      Here we have a performance fix for inode iversion, increased inode
      cluster size for v5 superblock filesystems, a fix for error handling
      in xfs_bmap_add_attrfork, and a MAINTAINERS update to add Dave"
    
    * tag 'xfs-for-linus-v3.13-rc1-2' of git://oss.sgi.com/xfs/xfs:
      xfs: open code inc_inode_iversion when logging an inode
      xfs: increase inode cluster size for v5 filesystems
      xfs: fix unlock in xfs_bmap_add_attrfork
      xfs: update maintainers

commit 7e1a1e9378018aeea2c7e8a3dd2ceb1db1523b0b
Merge: fcd7476 359d992
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Nov 14 17:16:35 2013 +0900

    Merge tag 'xfs-for-linus-v3.13-rc1' of git://oss.sgi.com/xfs/xfs
    
    Pull xfs update from Ben Myers:
     "For 3.13-rc1 we have an eclectic assortment of bugfixes, cleanups, and
      refactoring.  Bugfixes that stand out are the fix for the AGF/AGI
      deadlock, incore extent list fixes, verifier fixes for v4 superblocks
      and growfs, and memory leaks.  There are some asserts, warnings, and
      strings that were cleaned up.  There was further rearrangement of code
      to make libxfs and the kernel sync up more easily, differences between
      v2 and v3 directory code were abstracted using an ops vector,
      xfs_inactive was reworked, and the preallocation/hole punching code
      was refactored.
    
       - simplify kmem_zone_zalloc
       - add traces for AGF/AGI read ops
       - add additional AIL traces
       - fix xfs_remove AGF vs AGI deadlock
       - fix the extent count of new incore extent page in the indirection
         array
       - don't fail bad secondary superblocks verification on v4 filesystems
         due to unzeroed bits after v4 fields
       - fix possible NULL dereference in xlog_verify_iclog
       - remove redundant assert in xfs_dir2_leafn_split
       - prevent stack overflows from page cache allocation
       - fix some sparse warnings
       - fix directory block format verifier to check the leaf entry count
       - abstract the differences in dir2/dir3 via an ops vector
       - continue process of reorganization to make libxfs/kernel code
         merges easier
       - refactor the preallocation and hole punching code
       - fix for growfs and verifiers
       - remove unnecessary scary corruption error when probing non-xfs
         filesystems
       - remove extra newlines from strings passed to printk
       - prevent deadlock trying to cover an active log
       - rework xfs_inactive()
       - add the inode directory type support to XFS_IOC_FSGEOM
       - cleanup (remove) usage of is_bad_inode
       - fix miscalculation in xfs_iext_realloc_direct which results in
         oversized direct extent list
       - remove unnecessary count arg to xfs_iomap_write_allocate
       - fix memory leak in xlog_recover_add_to_trans
       - check superblock instead of block magic to determine if dtype field
         is present
       - fix lockdep annotation due to project quotas
       - fix regression in xfs_node_toosmall which can lead to incorrect
         directory btree node collapse
       - make log recovery verify filesystem uuid of recovering blocks
       - fix XFS_IOC_FREE_EOFBLOCKS definition
       - remove invalid assert in xfs_inode_free
       - fix for AIL lock regression"
    
    * tag 'xfs-for-linus-v3.13-rc1' of git://oss.sgi.com/xfs/xfs: (49 commits)
      xfs: simplify kmem_{zone_}zalloc
      xfs: add tracepoints to AGF/AGI read operations
      xfs: trace AIL manipulations
      xfs: xfs_remove deadlocks due to inverted AGF vs AGI lock ordering
      xfs: fix the extent count when allocating an new indirection array entry
      xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields
      xfs: fix possible NULL dereference in xlog_verify_iclog
      xfs:xfs_dir2_node.c: pointer use before check for null
      xfs: prevent stack overflows from page cache allocation
      xfs: fix static and extern sparse warnings
      xfs: validity check the directory block leaf entry count
      xfs: make dir2 ftype offset pointers explicit
      xfs: convert directory vector functions to constants
      xfs: convert directory vector functions to constants
      xfs: vectorise encoding/decoding directory headers
      xfs: vectorise DA btree operations
      xfs: vectorise directory leaf operations
      xfs: vectorise directory data operations part 2
      xfs: vectorise directory data operations
      xfs: vectorise remaining shortform dir2 ops
      ...

commit c4a391b53a72d2df4ee97f96f78c1d5971b47489
Author: Jan Kara <jack@suse.cz>
Date:   Tue Nov 12 15:07:51 2013 -0800

    writeback: do not sync data dirtied after sync start
    
    When there are processes heavily creating small files while sync(2) is
    running, it can easily happen that quite some new files are created
    between WB_SYNC_NONE and WB_SYNC_ALL pass of sync(2).  That can happen
    especially if there are several busy filesystems (remember that sync
    traverses filesystems sequentially and waits in WB_SYNC_ALL phase on one
    fs before starting it on another fs).  Because WB_SYNC_ALL pass is slow
    (e.g.  causes a transaction commit and cache flush for each inode in
    ext3), resulting sync(2) times are rather large.
    
    The following script reproduces the problem:
    
      function run_writers
      {
        for (( i = 0; i < 10; i++ )); do
          mkdir $1/dir$i
          for (( j = 0; j < 40000; j++ )); do
            dd if=/dev/zero of=$1/dir$i/$j bs=4k count=4 &>/dev/null
          done &
        done
      }
    
      for dir in "$@"; do
        run_writers $dir
      done
    
      sleep 40
      time sync
    
    Fix the problem by disregarding inodes dirtied after sync(2) was called
    in the WB_SYNC_ALL pass.  To allow for this, sync_inodes_sb() now takes
    a time stamp when sync has started which is used for setting up work for
    flusher threads.
    
    To give some numbers, when above script is run on two ext4 filesystems
    on simple SATA drive, the average sync time from 10 runs is 267.549
    seconds with standard deviation 104.799426.  With the patched kernel,
    the average sync time from 10 runs is 2.995 seconds with standard
    deviation 0.096.
    
    Signed-off-by: Jan Kara <jack@suse.cz>
    Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit b2a42f78ab475f4730300b0e9568bc3b2587d112
Author: Thierry Reding <thierry.reding@gmail.com>
Date:   Tue Oct 1 16:47:53 2013 +0200

    xfs: Use kmem_free() instead of free()
    
    This fixes a build failure caused by calling the free() function which
    does not exist in the Linux kernel.
    
    Signed-off-by: Thierry Reding <treding@nvidia.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit aaaae98022efa4f3c31042f1fdf9e7a0c5f04663)

commit 9b3b77fe661875f19ed748b67fb1eeb57d602b7e
Author: tinguely@sgi.com <tinguely@sgi.com>
Date:   Fri Sep 27 09:00:55 2013 -0500

    xfs: fix memory leak in xlog_recover_add_to_trans
    
    Free the memory in error path of xlog_recover_add_to_trans().
    Normally this memory is freed in recovery pass2, but is leaked
    in the error path.
    
    Signed-off-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 519ccb81ac1c8e3e4eed294acf93be00b43dcad6)

commit 6d313498f035abc9d8ad3a1b3295f133bfab9638
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 30 09:37:04 2013 +1000

    xfs: dirent dtype presence is dependent on directory magic numbers
    
    The determination of whether a directory entry contains a dtype
    field originally was dependent on the filesystem having CRCs
    enabled. This meant that the format for dtype beign enabled could be
    determined by checking the directory block magic number rather than
    doing a feature bit check. This was useful in that it meant that we
    didn't need to pass a struct xfs_mount around to functions that
    were already supplied with a directory block header.
    
    Unfortunately, the introduction of dtype fields into the v4
    structure via a feature bit meant this "use the directory block
    magic number" method of discriminating the dirent entry sizes is
    broken. Hence we need to convert the places that use magic number
    checks to use feature bit checks so that they work correctly and not
    by chance.
    
    The current code works on v4 filesystems only because the dirent
    size roundup covers the extra byte needed by the dtype field in the
    places where this problem occurs.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 367993e7c6428cb7617ab7653d61dca54e2fdede)

commit 89c6c89af2ef41cb127c9694ef7783e585e96337
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 30 09:37:03 2013 +1000

    xfs: lockdep needs to know about 3 dquot-deep nesting
    
    Michael Semon reported that xfs/299 generated this lockdep warning:
    
    =============================================
    [ INFO: possible recursive locking detected ]
    3.12.0-rc2+ #2 Not tainted
    ---------------------------------------------
    touch/21072 is trying to acquire lock:
     (&xfs_dquot_other_class){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64
    
    but task is already holding lock:
     (&xfs_dquot_other_class){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64
    
    other info that might help us debug this:
     Possible unsafe locking scenario:
    
           CPU0
           ----
      lock(&xfs_dquot_other_class);
      lock(&xfs_dquot_other_class);
    
     *** DEADLOCK ***
    
     May be due to missing lock nesting notation
    
    7 locks held by touch/21072:
     #0:  (sb_writers#10){++++.+}, at: [<c11185b6>] mnt_want_write+0x1e/0x3e
     #1:  (&type->i_mutex_dir_key#4){+.+.+.}, at: [<c11078ee>] do_last+0x245/0xe40
     #2:  (sb_internal#2){++++.+}, at: [<c122c9e0>] xfs_trans_alloc+0x1f/0x35
     #3:  (&(&ip->i_lock)->mr_lock/1){+.+...}, at: [<c126cd1b>] xfs_ilock+0x100/0x1f1
     #4:  (&(&ip->i_lock)->mr_lock){++++-.}, at: [<c126cf52>] xfs_ilock_nowait+0x105/0x22f
     #5:  (&dqp->q_qlock){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64
     #6:  (&xfs_dquot_other_class){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64
    
    The lockdep annotation for dquot lock nesting only understands
    locking for user and "other" dquots, not user, group and quota
    dquots. Fix the annotations to match the locking heirarchy we now
    have.
    
    Reported-by: Michael L. Semon <mlsemon35@gmail.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit f112a049712a5c07de25d511c3c6587a2b1a015e)

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
