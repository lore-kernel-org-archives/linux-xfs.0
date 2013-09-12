Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DB9B17F55
	for <xfs@oss.sgi.com>; Thu, 12 Sep 2013 17:14:34 -0500 (CDT)
Subject: [GIT PULL] XFS updates #2 for 3.12-rc1
Message-Id: <20130912221433.A15A64266DC@whiskey.americas.sgi.com>
Date: Thu, 12 Sep 2013 17:14:33 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
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
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

   Please pull these XFS updates for 3.12-rc1.  There is a feature to support
   defrag on CRC enabled filesystems, some bugfixes, and cleanups.

Thanks,
	Ben

The following changes since commit 1d03c6fa88af35e55047a1f2ab116f0fdf2f55aa:

  xfs: XFS_MOUNT_QUOTA_ALL needed by userspace (2013-09-03 15:00:06 -0500)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/xfs-for-linus-v3.12-rc1-2

for you to fetch changes up to 08474ed639e971e9d5a877cf7aba7ef91d847ae9:

  xfs: remove dead code from xlog_recover_inode_pass2 (2013-09-12 09:51:49 -0500)

----------------------------------------------------------------
xfs: update #2 for v3.12-rc1

Here we have defrag support for v5 superblock, a number of bugfixes and
a cleanup or two.

- defrag support for CRC filesystems
- fix endian worning in xlog_recover_get_buf_lsn
- fixes for sparse warnings
- fix for assert in xfs_dir3_leaf_hdr_from_disk
- fix for log recovery of remote symlinks
- fix for log recovery of btree root splits
- fixes formemory allocation failures with ACLs
- fix for assert in xfs_buf_item_relse
- fix for assert in xfs_inode_buf_verify
- fix an assignment in an assert that should be a test in
  xfs_bmbt_change_owner
- remove dead code in xlog_recover_inode_pass2

----------------------------------------------------------------
Dan Carpenter (1):
      xfs: = vs == typo in ASSERT()

Dave Chinner (11):
      xfs: fix endian warning in xlog_recover_get_buf_lsn()
      xfs: fix some minor sparse warnings
      xfs: check magic numbers in dir3 leaf verifier first
      xfs: swap extents operations for CRC filesystems
      xfs: recovery of swap extents operations for CRC filesystems
      xfs: set remote symlink buffer type for recovery
      xfs: ensure we copy buffer type in da btree root splits
      xfs: fix memory allocation failures with ACLs
      xfs: factor all the kmalloc-or-vmalloc fallback allocations
      xfs: aborted buf items can be in the AIL.
      xfs: don't assert fail on bad inode numbers

Mark Tinguely (1):
      xfs: remove dead code from xlog_recover_inode_pass2

 fs/xfs/kmem.c            |  15 ++++-
 fs/xfs/kmem.h            |   9 +--
 fs/xfs/xfs_acl.c         |  12 ++--
 fs/xfs/xfs_bmap.c        |   2 +-
 fs/xfs/xfs_bmap_btree.c  |  44 ++++++++++++
 fs/xfs/xfs_bmap_btree.h  |   4 ++
 fs/xfs/xfs_bmap_util.c   |  69 ++++++++++++-------
 fs/xfs/xfs_btree.c       | 170 ++++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_btree.h       |  19 ++++--
 fs/xfs/xfs_buf_item.c    |  24 +++++--
 fs/xfs/xfs_da_btree.c    |   1 +
 fs/xfs/xfs_dir2_leaf.c   |  20 ++++--
 fs/xfs/xfs_dquot_item.c  |   3 +-
 fs/xfs/xfs_extent_busy.c |   3 +-
 fs/xfs/xfs_icache.c      |   4 +-
 fs/xfs/xfs_icache.h      |   4 ++
 fs/xfs/xfs_inode_buf.c   |  10 ++-
 fs/xfs/xfs_inode_buf.h   |  18 ++---
 fs/xfs/xfs_ioctl.c       |  36 ++++------
 fs/xfs/xfs_ioctl32.c     |  18 ++---
 fs/xfs/xfs_itable.c      |   7 +-
 fs/xfs/xfs_log.c         |   3 +-
 fs/xfs/xfs_log_format.h  |   8 ++-
 fs/xfs/xfs_log_recover.c | 122 +++++++++++++++++++++++++++-------
 fs/xfs/xfs_symlink.c     |   2 +
 25 files changed, 461 insertions(+), 166 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
