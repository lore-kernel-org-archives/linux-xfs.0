Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 65D7F29E06
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 16:13:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D1D48F804B
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 14:13:38 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	nAFdfFTps3AZRiB9 for <xfs@oss.sgi.com>;
	Wed, 11 Nov 2015 14:13:35 -0800 (PST)
Date: Thu, 12 Nov 2015 09:13:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 4.4-rc1
Message-ID: <20151111221332.GI14311@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Can you please pull the XFS changes from the tag below? There is
nothing really major here - the only significant addition is the
per-mount operation statistics infrastructure. Otherwises there's
various ACL, xattr, DAX, AIO and logging fixes, and a smattering of
small cleanups and fixes elsewhere.

-Dave.

The following changes since commit 1f93e4a96c9109378204c147b3eec0d0e8100fde:

  Linux 4.3-rc2 (2015-09-20 14:32:34 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.4

for you to fetch changes up to 4e14e49a91e18098fd8ef30743972e0c3cb727c1:

  Merge branch 'xfs-misc-fixes-for-4.4-3' into for-next (2015-11-10 10:20:48 +1100)

----------------------------------------------------------------

xfs: updates for 4.4-rc1

This update contains:
o per-mount operational statistics in sysfs
o fixes for concurrent aio append write submission
o various logging fixes
o detection of zeroed logs and invalid log sequence numbers on v5 filesystems
o memory allocation failure message improvements
o a bunch of xattr/ACL fixes
o fdatasync optimisation
o miscellaneous other fixes and cleanups

----------------------------------------------------------------
Andreas Gruenbacher (4):
      xfs: Validate the length of on-disk ACLs
      xfs: Plug memory leak in xfs_attrmulti_attr_set
      xfs: invalidate cached acl if set via ioctl
      xfs: Fix error path in xfs_get_acl

Bill O'Donnell (7):
      xfs: create global stats and stats_clear in sysfs
      xfs: create symlink proc/fs/xfs/stat to sys/fs/xfs/stats
      xfs: remove unused procfs code
      xfs: consolidate sysfs ops
      xfs: pass xfsstats structures to handlers and macros
      xfs: per-filesystem stats in sysfs
      xfs: per-filesystem stats counter implementation

Brian Foster (8):
      xfs: add missing ilock around dio write last extent alignment
      xfs: log local to remote symlink conversions correctly on v5 supers
      xfs: validate metadata LSNs against log on v5 superblocks
      xfs: always drain dio before extending aio write submission
      xfs: add an xfs_zero_eof() tracepoint
      xfs: pass total block res. as total xfs_bmapi_write() parameter
      xfs: invalidate cached acl if set directly via xattr
      xfs: fix log recovery op header validation assert

Chris Mason (1):
      xfs: give all workqueues rescuer threads

Dan Carpenter (1):
      xfs: fix an error code in xfs_fs_fill_super()

Darrick J. Wong (1):
      xfs: don't leak uuid table on rmmod

Dave Chinner (15):
      Merge branch 'xfs-logging-fixes' into for-next
      Merge branch 'xfs-io-fixes' into for-next
      Merge branch 'xfs-misc-fixes-for-4.4-1' into for-next
      xfs: stats are no longer dependent on CONFIG_PROC_FS
      Merge branch 'xfs-stats-fixes' into for-next
      xfs: fix inode size update overflow in xfs_map_direct()
      xfs: introduce BMAPI_ZERO for allocating zeroed extents
      xfs: Don't use unwritten extents for DAX
      xfs: DAX does not use IO completion callbacks
      xfs: add ->pfn_mkwrite support for DAX
      xfs: xfs_filemap_pmd_fault treats read faults as write faults
      xfs: optimise away log forces on timestamp updates for fdatasync
      Merge branch 'xfs-misc-fixes-for-4.4-2' into for-next
      Merge branch 'xfs-dax-updates' into for-next
      Merge branch 'xfs-misc-fixes-for-4.4-3' into for-next

Eric Sandeen (3):
      xfs: avoid null *src in memcpy call in xlog_write
      xfs: more info from kmem deadlocks and high-level error msgs
      xfs: simplify /proc teardown & error handling

Geliang Tang (1):
      libxfs: fix two comment typos

Jan Tulak (2):
      xfs: prefix XATTR_LIST_MAX with XFS_
      xfs: avoid dependency on Linux XATTR_SIZE_MAX

Jiri Kosina (1):
      xfs: clear PF_NOFREEZE for xfsaild kthread

Tetsuo Handa (1):
      xfs: Print name and pid when memory allocation loops

Zhaohongjiang (1):
      cancel the setfilesize transation when io error happen

 fs/dax.c                           |    5 +
 fs/xfs/Makefile                    |    2 +-
 fs/xfs/kmem.c                      |   10 +-
 fs/xfs/libxfs/xfs_alloc.c          |   30 ++++--
 fs/xfs/libxfs/xfs_alloc.h          |    8 +-
 fs/xfs/libxfs/xfs_attr.c           |    6 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |    3 +
 fs/xfs/libxfs/xfs_attr_remote.c    |    2 +-
 fs/xfs/libxfs/xfs_bmap.c           |   65 +++++++++----
 fs/xfs/libxfs/xfs_bmap.h           |   13 ++-
 fs/xfs/libxfs/xfs_btree.c          |   21 +++-
 fs/xfs/libxfs/xfs_btree.h          |   39 ++++----
 fs/xfs/libxfs/xfs_da_btree.c       |    4 +
 fs/xfs/libxfs/xfs_dir2.c           |    6 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |    3 +
 fs/xfs/libxfs/xfs_dir2_data.c      |    3 +
 fs/xfs/libxfs/xfs_dir2_leaf.c      |    3 +
 fs/xfs/libxfs/xfs_dir2_node.c      |    3 +
 fs/xfs/libxfs/xfs_format.h         |   18 +++-
 fs/xfs/libxfs/xfs_fs.h             |   10 ++
 fs/xfs/libxfs/xfs_ialloc.c         |   10 +-
 fs/xfs/libxfs/xfs_sb.c             |   10 ++
 fs/xfs/libxfs/xfs_symlink_remote.c |    7 ++
 fs/xfs/xfs_acl.c                   |   14 ++-
 fs/xfs/xfs_acl.h                   |    4 +-
 fs/xfs/xfs_aops.c                  |  119 ++++++++++++-----------
 fs/xfs/xfs_aops.h                  |    3 +-
 fs/xfs/xfs_attr_list.c             |    2 +-
 fs/xfs/xfs_bmap_util.c             |   38 +++++++-
 fs/xfs/xfs_buf.c                   |   21 ++--
 fs/xfs/xfs_dir2_readdir.c          |    2 +-
 fs/xfs/xfs_dquot.c                 |   14 +--
 fs/xfs/xfs_file.c                  |  114 +++++++++++++++++-----
 fs/xfs/xfs_icache.c                |   18 ++--
 fs/xfs/xfs_inode.c                 |    8 +-
 fs/xfs/xfs_inode_item.c            |    1 +
 fs/xfs/xfs_inode_item.h            |    1 +
 fs/xfs/xfs_ioctl.c                 |   23 +++--
 fs/xfs/xfs_ioctl32.c               |    2 +-
 fs/xfs/xfs_iomap.c                 |   70 ++++++++++----
 fs/xfs/xfs_iops.c                  |    4 +-
 fs/xfs/xfs_linux.h                 |    7 ++
 fs/xfs/xfs_log.c                   |   93 ++++++++++++++----
 fs/xfs/xfs_log.h                   |    1 +
 fs/xfs/xfs_log_priv.h              |   51 ++++++++++
 fs/xfs/xfs_log_recover.c           |   14 ++-
 fs/xfs/xfs_message.c               |    7 ++
 fs/xfs/xfs_mount.c                 |   21 +++-
 fs/xfs/xfs_mount.h                 |    5 +
 fs/xfs/xfs_pnfs.c                  |    5 +
 fs/xfs/xfs_qm.c                    |   14 +--
 fs/xfs/xfs_stats.c                 |   93 +++++++++---------
 fs/xfs/xfs_stats.h                 |   36 ++++---
 fs/xfs/xfs_super.c                 |   57 ++++++++---
 fs/xfs/xfs_sysctl.c                |   15 +--
 fs/xfs/xfs_sysfs.c                 |  185 +++++++++++++++++++++---------------
 fs/xfs/xfs_sysfs.h                 |    1 +
 fs/xfs/xfs_trace.h                 |    2 +
 fs/xfs/xfs_trans.c                 |    6 +-
 fs/xfs/xfs_trans_ail.c             |   13 +--
 fs/xfs/xfs_trans_inode.c           |    9 ++
 fs/xfs/xfs_xattr.c                 |   31 +++++-
 62 files changed, 994 insertions(+), 411 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
