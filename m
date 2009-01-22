Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0MMi2b4117989 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 16:44:02 -0600
Date: Thu, 22 Jan 2009 16:43:14 -0600
Subject: [GIT PULL] XFS update for 2.6.29-rc3
MIME-Version: 1.0
Message-Id: <20090122224314.11896155705D@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, xfs@sgi.com, linux-kernel@vger.kernel.org

The following changes since commit f3b8436ad9a8ad36b3c9fa1fe030c7f38e5d3d0b:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (7):
      xfs: fix dentry aliasing issues in open_by_handle
      xfs: use mnt_want_write in compat_attrmulti ioctl
      xfs: add a separate lock class for the per-mount list of dquots
      xfs: lockdep annotations for xfs_dqlock2
      xfs: add a lock class for group/project dquots
      xfs: fix bad_features2 fixups for the root filesystem
      xfs: sanity check attr fork size

Dave Chinner (1):
      Long btree pointers are still 64 bit on disk

Eric Sandeen (1):
      [XFS] Remove the rest of the macro-to-function indirections.

 fs/xfs/Kconfig                 |    1 +
 fs/xfs/linux-2.6/xfs_ioctl.c   |  305 ++++++++++++++++++----------------------
 fs/xfs/linux-2.6/xfs_ioctl.h   |   15 ++-
 fs/xfs/linux-2.6/xfs_ioctl32.c |  184 ++++++++-----------------
 fs/xfs/linux-2.6/xfs_super.c   |   17 ++-
 fs/xfs/quota/xfs_dquot.c       |   38 ++++--
 fs/xfs/quota/xfs_dquot.h       |   10 ++
 fs/xfs/quota/xfs_qm.c          |    9 ++
 fs/xfs/xfs_ag.h                |    6 +-
 fs/xfs/xfs_alloc_btree.c       |    2 +-
 fs/xfs/xfs_attr.c              |   26 ++--
 fs/xfs/xfs_bmap.c              |  166 +++++++++++-----------
 fs/xfs/xfs_bmap.h              |    2 -
 fs/xfs/xfs_bmap_btree.c        |   10 +-
 fs/xfs/xfs_bmap_btree.h        |    4 -
 fs/xfs/xfs_btree.c             |   16 +-
 fs/xfs/xfs_da_btree.c          |    8 +-
 fs/xfs/xfs_ialloc.c            |    6 +-
 fs/xfs/xfs_ialloc.h            |    2 -
 fs/xfs/xfs_ialloc_btree.h      |    1 -
 fs/xfs/xfs_inode.c             |   19 ++-
 fs/xfs/xfs_inode_item.h        |    4 -
 fs/xfs/xfs_iomap.c             |   10 +-
 fs/xfs/xfs_itable.c            |    6 +-
 fs/xfs/xfs_mount.c             |   26 ++--
 fs/xfs/xfs_mount.h             |    9 +-
 fs/xfs/xfs_rename.c            |    2 +-
 fs/xfs/xfs_rtalloc.c           |    2 +-
 fs/xfs/xfs_rw.h                |    1 -
 fs/xfs/xfs_sb.h                |    2 +-
 fs/xfs/xfs_vnodeops.c          |   20 ++--
 31 files changed, 441 insertions(+), 488 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
