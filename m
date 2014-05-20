Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.15-rc6-69-gb70f14e
Message-Id: <20140520054134.B4CA37F63@oss.sgi.com>
Date: Tue, 20 May 2014 00:41:34 -0500 (CDT)
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
  b70f14e Merge branch 'xfs-feature-bit-cleanup' into for-next
  0d907a3 Merge branch 'xfs-misc-fixes-2-for-3.16' into for-next
  376c2f3 xfs: fix compile error when libxfs header used in C++ code
  8695d27 xfs: fix infinite loop at xfs_vm_writepage on 32bit system
  7c16635 xfs: remove redundant checks from xfs_da_read_buf
  110dc24 xfs: log vector rounding leaks log space
  ce576f1 xfs: remove XFS_TRANS_RESERVE in collapse range
  ab3e57b xfs: remove shared supberlock feature checking
  5d074a4 xfs: don't need dirv2 checks anymore
  263997a xfs: turn NLINK feature on by default
  32bf1de xfs: keep sb_bad_features2 the same a sb_features2
  f68a373 xfs: make superblock version checks reflect reality
      from  2d6dcc6d7e95cc83046b2f97e179e6bbb7921245 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit b70f14e1ffbb47369b1cc2cdf558c3468ae9e484
Merge: 0d907a3 ab3e57b
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue May 20 08:57:02 2014 +1000

    Merge branch 'xfs-feature-bit-cleanup' into for-next
    
    Conflicts:
    	fs/xfs/xfs_inode.c

commit 0d907a3bb4a77cffebebd17c323e898048301aa3
Merge: 2d6dcc6 376c2f3
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue May 20 08:56:00 2014 +1000

    Merge branch 'xfs-misc-fixes-2-for-3.16' into for-next
    
    Conflicts:
    	fs/xfs/xfs_ialloc.c

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_aops.c       |  49 +++++++++--
 fs/xfs/xfs_bmap_util.c  |   2 -
 fs/xfs/xfs_da_btree.c   |  41 ---------
 fs/xfs/xfs_dir2.c       |   2 +-
 fs/xfs/xfs_fsops.c      |   9 +-
 fs/xfs/xfs_ialloc.c     |  14 ++-
 fs/xfs/xfs_ialloc.h     |   2 +-
 fs/xfs/xfs_inode.c      | 111 +++---------------------
 fs/xfs/xfs_inode.h      |   1 -
 fs/xfs/xfs_inode_buf.c  |  17 ++--
 fs/xfs/xfs_inode_item.c |  32 +------
 fs/xfs/xfs_ioctl.c      |   9 +-
 fs/xfs/xfs_log.h        |  19 ++--
 fs/xfs/xfs_log_cil.c    |   7 +-
 fs/xfs/xfs_mount.c      |   6 ++
 fs/xfs/xfs_sb.c         |  12 +--
 fs/xfs/xfs_sb.h         | 225 ++++++++++++++----------------------------------
 17 files changed, 167 insertions(+), 391 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
