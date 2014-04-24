Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.15-rc2-43-gb8b39d3
Message-Id: <20140424061624.8B9BC7F53@oss.sgi.com>
Date: Thu, 24 Apr 2014 01:16:24 -0500 (CDT)
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
  b8b39d3 Merge branch 'xfs-free-inode-btree' into for-next
  53801fd xfs: enable the finobt feature on v5 superblocks
  0c153c1 xfs: report finobt status in fs geometry
  a3fa516 xfs: add finobt support to growfs
  3efa4ff xfs: update the finobt on inode free
  2b64ee5 xfs: refactor xfs_difree() inobt bits into xfs_difree_inobt() helper
  6dd8638 xfs: use and update the finobt on inode allocation
  0aa0a75 xfs: insert newly allocated inode chunks into the finobt
  9d43b18 xfs: update inode allocation/free transaction reservations for finobt
  aafc3c2 xfs: support the XFS_BTNUM_FINOBT free inode btree type
  8e2c84d xfs: reserve v5 superblock read-only compat. feature bit for finobt
  57bd3db xfs: refactor xfs_ialloc_btree.c to support multiple inobt numbers
      from  7043507bfa1af648512e36d95cca484757df0b64 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit b8b39d39f94c0d3ea5771d1df3151c569599c20a
Merge: 7043507 53801fd
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Apr 24 16:11:57 2014 +1000

    Merge branch 'xfs-free-inode-btree' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_ag.h           |  36 ++-
 fs/xfs/xfs_btree.c        |   6 +-
 fs/xfs/xfs_btree.h        |   3 +
 fs/xfs/xfs_format.h       |  14 +-
 fs/xfs/xfs_fs.h           |   1 +
 fs/xfs/xfs_fsops.c        |  36 ++-
 fs/xfs/xfs_ialloc.c       | 695 +++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_ialloc_btree.c |  68 ++++-
 fs/xfs/xfs_ialloc_btree.h |   3 +-
 fs/xfs/xfs_inode.c        |  28 +-
 fs/xfs/xfs_itable.c       |   6 +-
 fs/xfs/xfs_log_recover.c  |   2 +
 fs/xfs/xfs_sb.h           |  10 +-
 fs/xfs/xfs_stats.c        |   1 +
 fs/xfs/xfs_stats.h        |  18 +-
 fs/xfs/xfs_trans_resv.c   |  53 +++-
 fs/xfs/xfs_trans_space.h  |   7 +-
 fs/xfs/xfs_types.h        |   2 +-
 18 files changed, 852 insertions(+), 137 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
