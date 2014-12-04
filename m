From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.18-rc2-40-g6044e43
Message-Id: <20141204020738.691957F47@oss.sgi.com>
Date: Wed,  3 Dec 2014 20:07:38 -0600 (CST)
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
  6044e43 Merge branch 'xfs-misc-fixes-for-3.19-2' into for-next
  b29c70f xfs: split metadata and log buffer completion to separate workqueues
  32296f8 xfs: fix set-but-unused warnings
  9a2cc41 xfs: move type conversion functions to xfs_dir.h
  1b767ee xfs: move ftype conversion functions to libxfs
  2d3d0c5 xfs: lobotomise xfs_trans_read_buf_map()
  cdc9cec xfs: active inodes stat is broken
  4db431f xfs: cleanup xfs_bmse_merge returns
  b11bd67 xfs: cleanup xfs_bmse_shift_one goto mess
  7a1df15 xfs: fix premature enospc on inode allocation
  76b5730 xfs: overflow in xfs_iomap_eof_align_last_fsb
  e77b854 Merge branch 'xfs-coccinelle-cleanups' into xfs-misc-fixes-for-3.19-2
      from  c14fc01340dd0afe58d8671acc3ea5e907e707ae (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 6044e4386cd51dece882ea42352cdaaab0f24cad
Merge: c14fc01 b29c70f
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Dec 4 09:46:17 2014 +1100

    Merge branch 'xfs-misc-fixes-for-3.19-2' into for-next
    
    Conflicts:
    	fs/xfs/xfs_iops.c

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/libxfs/xfs_bmap.c       |  68 ++++++++------------
 fs/xfs/libxfs/xfs_da_btree.c   |   4 --
 fs/xfs/libxfs/xfs_dir2.c       |  16 +++++
 fs/xfs/libxfs/xfs_dir2.h       | 140 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2_block.c |   8 ---
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  10 ---
 fs/xfs/libxfs/xfs_dir2_node.c  |  12 ----
 fs/xfs/libxfs/xfs_dir2_priv.h  | 140 -----------------------------------------
 fs/xfs/libxfs/xfs_dir2_sf.c    |  10 ---
 fs/xfs/libxfs/xfs_ialloc.c     |  34 +++++++---
 fs/xfs/xfs_buf.c               |  13 +++-
 fs/xfs/xfs_buf.h               |   3 +-
 fs/xfs/xfs_dir2_readdir.c      |  18 +-----
 fs/xfs/xfs_export.c            |   1 +
 fs/xfs/xfs_icache.c            |   2 +
 fs/xfs/xfs_inode.c             |  12 +---
 fs/xfs/xfs_iomap.c             |  15 ++---
 fs/xfs/xfs_iops.c              |   2 +-
 fs/xfs/xfs_itable.c            |   2 -
 fs/xfs/xfs_log.c               |   4 ++
 fs/xfs/xfs_log_recover.c       |   1 +
 fs/xfs/xfs_mount.c             |   1 +
 fs/xfs/xfs_super.c             |   6 +-
 fs/xfs/xfs_trans_buf.c         | 135 ++++++++++-----------------------------
 24 files changed, 271 insertions(+), 386 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
