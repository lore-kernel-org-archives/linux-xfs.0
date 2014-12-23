Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.19-rc1
Message-Id: <20141223214506.DEE517F56@oss.sgi.com>
Date: Tue, 23 Dec 2014 15:45:06 -0600 (CST)
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
  c05e14f Merge tag 'xfs-for-linus-3.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs
  1366f5d Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
  17ef4fd xfs: Set allowed quota types
      from  6044e4386cd51dece882ea42352cdaaab0f24cad (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit c05e14f7b3145ac89635fa398934438240dace40
Merge: 9bfccec 6044e43
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Dec 12 09:48:17 2014 -0800

    Merge tag 'xfs-for-linus-3.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs
    
    Pull xfs update from Dave Chinner:
     "There's relatively little change in this update; it is mainly bug
      fixes, cleanups and more of the on-going libxfs restructuring and
      on-disk format header consolidation work.
    
      Details:
       - more on-disk format header consolidation
       - move some structures shared with userspace to libxfs
       - new per-mount workqueue to fix for deadlocks between nested loop
         mounted filesystems
       - various bug fixes for ENOSPC, stats, quota off and preallocation
       - a bunch of compiler warning fixes for set-but-unused variables
       - various code cleanups"
    
    * tag 'xfs-for-linus-3.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs: (24 commits)
      xfs: split metadata and log buffer completion to separate workqueues
      xfs: fix set-but-unused warnings
      xfs: move type conversion functions to xfs_dir.h
      xfs: move ftype conversion functions to libxfs
      xfs: lobotomise xfs_trans_read_buf_map()
      xfs: active inodes stat is broken
      xfs: cleanup xfs_bmse_merge returns
      xfs: cleanup xfs_bmse_shift_one goto mess
      xfs: fix premature enospc on inode allocation
      xfs: overflow in xfs_iomap_eof_align_last_fsb
      xfs: fix simple_return.cocci warning in xfs_bmse_shift_one
      xfs: fix simple_return.cocci warning in xfs_file_readdir
      libxfs: fix simple_return.cocci warnings
      xfs: remove unnecessary null checks
      xfs: merge xfs_inum.h into xfs_format.h
      xfs: move most of xfs_sb.h to xfs_format.h
      xfs: merge xfs_ag.h into xfs_format.h
      xfs: move acl structures to xfs_format.h
      xfs: merge xfs_dinode.h into xfs_format.h
      xfs: catch invalid negative blknos in _xfs_buf_find()
      ...

commit 1366f5d3129f2abde606214de7afc3dd61781fa3
Merge: 4b0a268 fdf2657
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Dec 10 15:43:30 2014 -0800

    Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
    
    Pull quota updates from Jan Kara:
     "Quota improvements and some minor cleanups.
    
      The main portion in the pull request are changes which move i_dquot
      array from struct inode into fs-private part of an inode which saves
      memory for filesystems which don't use VFS quotas"
    
    * 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs:
      udf: One function call less in udf_fill_super() after error detection
      udf: Deletion of unnecessary checks before the function call "iput"
      jbd: Deletion of an unnecessary check before the function call "iput"
      vfs: Remove i_dquot field from inode
      jfs: Convert to private i_dquot field
      reiserfs: Convert to private i_dquot field
      ocfs2: Convert to private i_dquot field
      ext4: Convert to private i_dquot field
      ext3: Convert to private i_dquot field
      ext2: Convert to private i_dquot field
      quota: Use function to provide i_dquot pointers
      xfs: Set allowed quota types
      gfs2: Set allowed quota types
      quota: Allow each filesystem to specify which quota types it supports
      quota: Remove const from function declarations
      quota: Add log level to printk

commit 17ef4fdd379dc7bcbdf46b2630d33958244d0053
Author: Jan Kara <jack@suse.cz>
Date:   Tue Sep 30 22:35:33 2014 +0200

    xfs: Set allowed quota types
    
    We support user, group, and project quotas. Tell VFS about it.
    
    CC: xfs@oss.sgi.com
    CC: Dave Chinner <david@fromorbit.com>
    Acked-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Jan Kara <jack@suse.cz>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_super.c | 1 +
 1 file changed, 1 insertion(+)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
