Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.12-rc1-4-g566055d
Message-Id: <20130924200708.5C34829DFB@oss.sgi.com>
Date: Tue, 24 Sep 2013 15:07:08 -0500 (CDT)
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
  566055d xfs: log recovery lsn ordering needs uuid check
  b771af2 xfs: fix XFS_IOC_FREE_EOFBLOCKS definition
  b313a5f xfs: asserting lock not held during freeing not valid
  4885235 xfs: lock the AIL before removing the buffer item
      from  272b98c6455f00884f0350f775c5342358ebb73f (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 566055d33a91ddddb1cb31220b01ac4abd2d2bdd
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 24 16:01:16 2013 +1000

    xfs: log recovery lsn ordering needs uuid check
    
    After a fair number of xfstests runs, xfs/182 started to fail
    regularly with a corrupted directory - a directory read verifier was
    failing after recovery because it found a block with a XARM magic
    number (remote attribute block) rather than a directory data block.
    
    The first time I saw this repeated failure I did /something/ and the
    problem went away, so I was never able to find the underlying
    problem. Test xfs/182 failed again today, and I found the root
    cause before I did /something else/ that made it go away.
    
    Tracing indicated that the block in question was being correctly
    logged, the log was being flushed by sync, but the buffer was not
    being written back before the shutdown occurred. Tracing also
    indicated that log recovery was also reading the block, but then
    never writing it before log recovery invalidated the cache,
    indicating that it was not modified by log recovery.
    
    More detailed analysis of the corpse indicated that the filesystem
    had a uuid of "a4131074-1872-4cac-9323-2229adbcb886" but the XARM
    block had a uuid of "8f32f043-c3c9-e7f8-f947-4e7f989c05d3", which
    indicated it was a block from an older filesystem. The reason that
    log recovery didn't replay it was that the LSN in the XARM block was
    larger than the LSN of the transaction being replayed, and so the
    block was not overwritten by log recovery.
    
    Hence, log recovery cant blindly trust the magic number and LSN in
    the block - it must verify that it belongs to the filesystem being
    recovered before using the LSN. i.e. if the UUIDs don't match, we
    need to unconditionally recovery the change held in the log.
    
    This patch was first tested on a block device that was repeatedly
    causing xfs/182 to fail with the same failure on the same block with
    the same directory read corruption signature (i.e. XARM block). It
    did not fail, and hasn't failed since.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit b771af2fcb4a8a2df7e9b8784cd80e1774c34198
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 24 16:01:15 2013 +1000

    xfs: fix XFS_IOC_FREE_EOFBLOCKS definition
    
    It uses a kernel internal structure in it's definition rather than
    the user visible structure that is passed to the ioctl.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit b313a5f1cb0bf3276d5457b52b9f75a940e7b5e9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 24 16:01:14 2013 +1000

    xfs: asserting lock not held during freeing not valid
    
    When we free an inode, we do so via RCU. As an RCU lookup can occur
    at any time before we free an inode, and that lookup takes the inode
    flags lock, we cannot safely assert that the flags lock is not held
    just before marking it dead and running call_rcu() to free the
    inode.
    
    We check on allocation of a new inode structre that the lock is not
    held, so we still have protection against locks being leaked and
    hence not correctly initialised when allocated out of the slab.
    Hence just remove the assert...
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 4885235806bb95c3fad5a5238e323cb746c3a49b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Sep 24 16:01:13 2013 +1000

    xfs: lock the AIL before removing the buffer item
    
    Regression introduced by commit 46f9d2e ("xfs: aborted buf items can
    be in the AIL") which fails to lock the AIL before removing the
    item. Spinlock debugging throws a warning about this.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_buf_item.c    |  1 +
 fs/xfs/xfs_fs.h          |  2 +-
 fs/xfs/xfs_icache.c      |  9 +++---
 fs/xfs/xfs_log_recover.c | 73 ++++++++++++++++++++++++++++++++++++++----------
 4 files changed, 65 insertions(+), 20 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
