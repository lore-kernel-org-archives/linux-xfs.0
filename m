Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.12-rc1-11-g74ffa79
Message-Id: <20130910224911.1BD177F5A@oss.sgi.com>
Date: Tue, 10 Sep 2013 17:49:10 -0500 (CDT)
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
  74ffa79 xfs: don't assert fail on bad inode numbers
  46f9d2e xfs: aborted buf items can be in the AIL.
  fdd3cce xfs: factor all the kmalloc-or-vmalloc fallback allocations
  2dc164f xfs: fix memory allocation failures with ACLs
  0a4edc8 xfs: ensure we copy buffer type in da btree root splits
  daf7b79 xfs: set remote symlink buffer type for recovery
  638f4416 xfs: recovery of swap extents operations for CRC filesystems
  21b5c97 xfs: swap extents operations for CRC filesystems
      from  0f295a214bb7658ca37bd61a8a1f0cd4a9d86c1f (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 74ffa796e127906883cacedcf3871494192c9e42
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 3 21:47:38 2013 +1000

    xfs: don't assert fail on bad inode numbers
    
    Let the inode verifier do it's work by returning an error when we
    fail to find correct magic numbers in an inode buffer.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 46f9d2eb37849a328011b182729990d2db3f4d52
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 3 21:47:37 2013 +1000

    xfs: aborted buf items can be in the AIL.
    
    Saw this on generic/270 after a DQALLOC transaction overrun
    shutdown:
    
    XFS: Assertion failed: !(bip->bli_item.li_flags & XFS_LI_IN_AIL), file: fs/xfs/xfs_buf_item.c, line: 952
    .....
     xfs_buf_item_relse+0x4f/0xd0
     xfs_buf_item_unlock+0x1b4/0x1e0
     xfs_trans_free_items+0x7d/0xb0
     xfs_trans_cancel+0x13c/0x1b0
     xfs_symlink+0x37e/0xa60
    ....
    
    When a transaction abort occured.
    
    If we are aborting a transaction and trigger this code path, then
    the item may be dirty. If the item is dirty, then it may be in the
    AIL. Hence if we are aborting, we need to check if the item is in
    the AIL and remove it before freeing it.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit fdd3cceef46f2c18c618669cfae5c0f47d6982f9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 2 20:53:00 2013 +1000

    xfs: factor all the kmalloc-or-vmalloc fallback allocations
    
    We have quite a few places now where we do:
    
    	x = kmem_zalloc(large size)
    	if (!x)
    		x = kmem_zalloc_large(large size)
    
    and do a similar dance when freeing the memory. kmem_free() already
    does the correct freeing dance, and kmem_zalloc_large() is only ever
    called in these constructs, so just factor it all into
    kmem_zalloc_large() and kmem_free().
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 2dc164f2965b92a6efd2edb9e2813271741e96db
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 2 20:52:59 2013 +1000

    xfs: fix memory allocation failures with ACLs
    
    Ever since increasing the number of supported ACLs from 25 to as
    many as can fit in an xattr, there have been reports of order 4
    memory allocations failing in the ACL code. Fix it in the same way
    we've fixed all the xattr read/write code that has the same problem.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 0a4edc8f0b54cd5f613e7fda7dc8106cb9869bc9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 2 10:32:01 2013 +1000

    xfs: ensure we copy buffer type in da btree root splits
    
    When splitting the root of the da btree, we shuffled data between
    buffers and the structures that track them. At one point, we copy
    data and state from one buffer to another, including the ops
    associated with the buffer. When we do this, we also need to copy
    the buffer type associated with the buf log item so that the buffer
    is logged correctly. If we don't do that, log recovery won't
    recognise it and hence it won't recalculate the CRC on the buffer
    after recovery. This leads to a directory block that can't be read
    after recovery has run.
    
    Found by inspection after finding the same problem with remote
    symlink buffers.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit daf7b799a944d28a50caaa512011f5a0eb5a4076
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 2 10:32:00 2013 +1000

    xfs: set remote symlink buffer type for recovery
    
    The logging of a remote symlink block does not set the buffer type
    being logged, and hence on recovery the type of buffer is not
    recognised and hence CRCs are not calculated after replay. This
    results in log recoery throwing:
    
    XFS (vdc): Unknown buffer type 0
    
    errors, and subsequent reads of the symlink failing CRC
    verification. Found via fsstress + godown.
    
    Reported by: Michael L. Semon <mlsemon35@gmail.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 638f44163d57f87d0905fbed7d54202beff916fc
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Aug 30 10:23:45 2013 +1000

    xfs: recovery of swap extents operations for CRC filesystems
    
    This is the recovery side of the btree block owner change operation
    performed by swapext on CRC enabled filesystems. We detect that an
    owner change is needed by the flag that has been placed on the inode
    log format flag field. Because the inode recovery is being replayed
    after the buffers that make up the BMBT in the given checkpoint, we
    can walk all the buffers and directly modify them when we see the
    flag set on an inode.
    
    Because the inode can be relogged and hence present in multiple
    chekpoints with the "change owner" flag set, we could do multiple
    passes across the inode to do this change. While this isn't optimal,
    we can't directly ignore the flag as there may be multiple
    independent swap extent operations being replayed on the same inode
    in different checkpoints so we can't ignore them.
    
    Further, because the owner change operation uses ordered buffers, we
    might have buffers that are newer on disk than the current
    checkpoint and so already have the owner changed in them. Hence we
    cannot just peek at a buffer in the tree and check that it has the
    correct owner and assume that the change was completed.
    
    So, for the moment just brute force the owner change every time we
    see an inode with the flag set. Note that we have to be careful here
    because the owner of the buffers may point to either the old owner
    or the new owner. Currently the verifier can't verify the owner
    directly, so there is no failure case here right now. If we verify
    the owner exactly in future, then we'll have to take this into
    account.
    
    This was tested in terms of normal operation via xfstests - all of
    the fsr tests now pass without failure. however, we really need to
    modify xfs/227 to stress v3 inodes correctly to ensure we fully
    cover this case for v5 filesystems.
    
    In terms of recovery testing, I used a hacked version of xfs_fsr
    that held the temp inode open for a few seconds before exiting so
    that the filesystem could be shut down with an open owner change
    recovery flags set on at least the temp inode. fsr leaves the temp
    inode unlinked and in btree format, so this was necessary for the
    owner change to be reliably replayed.
    
    logprint confirmed the tmp inode in the log had the correct flag set:
    
    INO: cnt:3 total:3 a:0x69e9e0 len:56 a:0x69ea20 len:176 a:0x69eae0 len:88
            INODE: #regs:3   ino:0x44  flags:0x209   dsize:88
    	                                 ^^^^^
    
    0x200 is set, indicating a data fork owner change needed to be
    replayed on inode 0x44.  A printk in the revoery code confirmed that
    the inode change was recovered:
    
    XFS (vdc): Mounting Filesystem
    XFS (vdc): Starting recovery (logdev: internal)
    recovering owner change ino 0x44
    XFS (vdc): Version 5 superblock detected. This kernel L support enabled!
    Use of these features in this kernel is at your own risk!
    XFS (vdc): Ending recovery (logdev: internal)
    
    The script used to test this was:
    
    $ cat ./recovery-fsr.sh
    #!/bin/bash
    
    dev=/dev/vdc
    mntpt=/mnt/scratch
    testfile=$mntpt/testfile
    
    umount $mntpt
    mkfs.xfs -f -m crc=1 $dev
    mount $dev $mntpt
    chmod 777 $mntpt
    
    for i in `seq 10000 -1 0`; do
            xfs_io -f -d -c "pwrite $(($i * 4096)) 4096" $testfile > /dev/null 2>&1
    done
    xfs_bmap -vp $testfile |head -20
    
    xfs_fsr -d -v $testfile &
    sleep 10
    /home/dave/src/xfstests-dev/src/godown -f $mntpt
    wait
    umount $mntpt
    
    xfs_logprint -t $dev |tail -20
    time mount $dev $mntpt
    xfs_bmap -vp $testfile
    umount $mntpt
    $
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 21b5c9784bceb8b8e0095f87355f3b138ebac2d0
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Aug 30 10:23:44 2013 +1000

    xfs: swap extents operations for CRC filesystems
    
    For CRC enabled filesystems, we can't just swap inode forks from one
    inode to another when defragmenting a file - the blocks in the inode
    fork bmap btree contain pointers back to the owner inode. Hence if
    we are to swap the inode forks we have to atomically modify every
    block in the btree during the transaction.
    
    We are doing an entire fork swap here, so we could create a new
    transaction item type that indicates we are changing the owner of a
    certain structure from one value to another. If we combine this with
    ordered buffer logging to modify all the buffers in the tree, then
    we can change the buffers in the tree without needing log space for
    the operation. However, this then requires log recovery to perform
    the modification of the owner information of the objects/structures
    in question.
    
    This does introduce some interesting ordering details into recovery:
    we have to make sure that the owner change replay occurs after the
    change that moves the objects is made, not before. Hence we can't
    use a separate log item for this as we have no guarantee of strict
    ordering between multiple items in the log due to the relogging
    action of asynchronous transaction commits. Hence there is no
    "generic" method we can use for changing the ownership of arbitrary
    metadata structures.
    
    For inode forks, however, there is a simple method of communicating
    that the fork contents need the owner rewritten - we can pass a
    inode log format flag for the fork for the transaction that does a
    fork swap. This flag will then follow the inode fork through
    relogging actions so when the swap actually gets replayed the
    ownership can be changed immediately by log recovery.  So that gives
    us a simple method of "whole fork" exchange between two inodes.
    
    This is relatively simple to implement, so it makes sense to do this
    as an initial implementation to support xfs_fsr on CRC enabled
    filesytems in the same manner as we do on existing filesystems. This
    commit introduces the swapext driven functionality, the recovery
    functionality will be in a separate patch.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/kmem.c            |  15 ++++-
 fs/xfs/kmem.h            |   9 +--
 fs/xfs/xfs_acl.c         |  12 ++--
 fs/xfs/xfs_bmap_btree.c  |  44 ++++++++++++
 fs/xfs/xfs_bmap_btree.h  |   4 ++
 fs/xfs/xfs_bmap_util.c   |  69 ++++++++++++-------
 fs/xfs/xfs_btree.c       | 170 ++++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_btree.h       |  19 ++++--
 fs/xfs/xfs_buf_item.c    |  24 +++++--
 fs/xfs/xfs_da_btree.c    |   1 +
 fs/xfs/xfs_icache.c      |   4 +-
 fs/xfs/xfs_icache.h      |   4 ++
 fs/xfs/xfs_inode_buf.c   |  10 ++-
 fs/xfs/xfs_inode_buf.h   |  18 ++---
 fs/xfs/xfs_ioctl.c       |  34 +++-------
 fs/xfs/xfs_ioctl32.c     |  18 ++---
 fs/xfs/xfs_itable.c      |   2 +-
 fs/xfs/xfs_log_format.h  |   8 ++-
 fs/xfs/xfs_log_recover.c | 123 +++++++++++++++++++++++++++-------
 fs/xfs/xfs_symlink.c     |   2 +
 20 files changed, 439 insertions(+), 151 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
