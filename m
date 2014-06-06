Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.15-rc6-94-g1d2378a
Message-Id: <20140606070149.B375C7F56@oss.sgi.com>
Date: Fri,  6 Jun 2014 02:01:49 -0500 (CDT)
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
  1d2378a Merge branch 'xfs-misc-fixes-3-for-3.16' into for-next
  3026511 xfs: Fix rounding in xfs_alloc_fix_len()
  448011e xfs: tone down writepage/releasepage WARN_ONs
  72208ee xfs: small cleanup in xfs_lowbit64()
  36de955 xfs: kill xfs_buf_geterror()
  556b888 xfs: xfs_readsb needs to check for magic numbers
  1f6d648 xfs: block allocation work needs to be kswapd aware
  8cd5674 Merge branch 'xfs-da-geom' into for-next
  b2a21e7 xfs: remove redundant geometry information from xfs_da_state
  c2c4c47 xfs: replace attr LBSIZE with xfs_da_geometry
  c59f0ad xfs: pass xfs_da_args to xfs_attr_leaf_newentsize
  33a6039 xfs: use xfs_da_geometry for block size in attr code
  bc85178 xfs: remove mp->m_dir_geo from directory logging
  53f82db xfs: reduce direct usage of mp->m_dir_geo
  7ab610f xfs: move node entry counts to xfs_da_geometry
  ed358c0 xfs: convert dir/attr btree threshold to xfs_da_geometry
  8f66193 xfs: convert m_dirblksize to xfs_da_geometry
  d6cf130 xfs: convert m_dirblkfsbs to xfs_da_geometry
  7dda6e8 xfs: convert directory segment limits to xfs_da_geometry
  3002803 xfs: convert directory db conversion to xfs_da_geometry
  2998ab1 xfs: convert directory dablk conversion to xfs_da_geometry
  9b3b552 xfs: convert dir byte/off conversion to xfs_da_geometry
  8c44a28 xfs: kill XFS_DIR2...FIRSTDB macros
  892e3f3 xfs: move directory block translatiosn to xfs_dir2_priv.h
  0650b55 xfs: introduce directory geometry structure
      from  b70f14e1ffbb47369b1cc2cdf558c3468ae9e484 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 1d2378a4e89bcef25f3800ef00b94cd07069c876
Merge: 8cd5674 3026511
Author: Dave Chinner <david@fromorbit.com>
Date:   Fri Jun 6 16:17:47 2014 +1000

    Merge branch 'xfs-misc-fixes-3-for-3.16' into for-next

commit 8cd56740f64b10fb75aba326cf188282970eee5b
Merge: b70f14e b2a21e7
Author: Dave Chinner <david@fromorbit.com>
Date:   Fri Jun 6 15:25:24 2014 +1000

    Merge branch 'xfs-da-geom' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_alloc.c        |  19 ++---
 fs/xfs/xfs_aops.c         |   6 +-
 fs/xfs/xfs_attr.c         |  17 +---
 fs/xfs/xfs_attr_leaf.c    | 184 +++++++++++++++++++++---------------------
 fs/xfs/xfs_attr_leaf.h    |   3 +-
 fs/xfs/xfs_attr_list.c    |   1 +
 fs/xfs/xfs_attr_remote.c  |  55 +++++++------
 fs/xfs/xfs_bit.h          |   7 +-
 fs/xfs/xfs_bmap.c         |   3 +-
 fs/xfs/xfs_bmap_util.c    |  16 +++-
 fs/xfs/xfs_bmap_util.h    |  13 +--
 fs/xfs/xfs_btree.c        |  12 +--
 fs/xfs/xfs_buf.h          |   5 --
 fs/xfs/xfs_buf_item.c     |   2 +-
 fs/xfs/xfs_da_btree.c     |  65 +++++++--------
 fs/xfs/xfs_da_btree.h     |  20 ++++-
 fs/xfs/xfs_da_format.c    |  36 +++++----
 fs/xfs/xfs_da_format.h    | 154 -----------------------------------
 fs/xfs/xfs_dir2.c         | 132 +++++++++++++++++++-----------
 fs/xfs/xfs_dir2.h         |  30 ++++---
 fs/xfs/xfs_dir2_block.c   |  88 ++++++++++----------
 fs/xfs/xfs_dir2_data.c    |  80 +++++++++----------
 fs/xfs/xfs_dir2_leaf.c    | 200 ++++++++++++++++++++++++----------------------
 fs/xfs/xfs_dir2_node.c    | 188 ++++++++++++++++++++++---------------------
 fs/xfs/xfs_dir2_priv.h    | 138 +++++++++++++++++++++++++++++++-
 fs/xfs/xfs_dir2_readdir.c | 142 ++++++++++++++++----------------
 fs/xfs/xfs_dir2_sf.c      |  18 +++--
 fs/xfs/xfs_dquot.c        |   6 +-
 fs/xfs/xfs_fsops.c        |   4 +-
 fs/xfs/xfs_ialloc.c       |   1 -
 fs/xfs/xfs_log.c          |   2 +-
 fs/xfs/xfs_log_rlimit.c   |   2 +-
 fs/xfs/xfs_mount.c        |  39 ++++++---
 fs/xfs/xfs_mount.h        |  12 +--
 fs/xfs/xfs_rtbitmap.c     |   1 -
 fs/xfs/xfs_symlink.c      |   1 +
 fs/xfs/xfs_trans_resv.c   |   3 +-
 fs/xfs/xfs_trans_space.h  |   5 +-
 38 files changed, 879 insertions(+), 831 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
