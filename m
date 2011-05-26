Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4QGjopo215165 for <xfs@oss.sgi.com>; Thu, 26 May 2011 11:45:50 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201105261645.p4QGjjOv026256@stout.americas.sgi.com>
Date: Thu, 26 May 2011 11:45:45 -0500
Subject: [GIT PULL] XFS update 2 for 2.6.40-rc1
MIME-Version: 1.0
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
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

The following changes since commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5:

  tmpfs: fix XATTR N overriding POSIX_ACL Y (2011-05-25 19:53:02 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (11):
      xfs: add online discard support
      xfs: do not discard alloc btree blocks
      xfs: remove the unused XFS_BMAPI_RSVBLOCKS flag
      xfs: remove if_lastex
      xfs: do not use unchecked extent indices in xfs_bmap_add_extent_*
      xfs: do not use unchecked extent indices in xfs_bmapi
      xfs: do not use unchecked extent indices in xfs_bunmapi
      xfs: do not do pointer arithmetic on extent records
      xfs: fix up asserts in xfs_iflush_fork
      xfs: check for valid indices in xfs_iext_get_ext and xfs_iext_idx_to_irec
      xfs: correctly decrement the extent buffer index in xfs_bmap_del_extent

 Documentation/filesystems/xfs.txt |    6 +
 fs/xfs/linux-2.6/xfs_discard.c    |   29 ++
 fs/xfs/linux-2.6/xfs_discard.h    |    2 +
 fs/xfs/linux-2.6/xfs_super.c      |   18 +-
 fs/xfs/xfs_ag.h                   |    3 +
 fs/xfs/xfs_alloc.c                |   35 ++-
 fs/xfs/xfs_alloc.h                |    5 +-
 fs/xfs/xfs_alloc_btree.c          |    3 +-
 fs/xfs/xfs_bmap.c                 |  549 +++++++++++++++++--------------------
 fs/xfs/xfs_bmap.h                 |    2 -
 fs/xfs/xfs_inode.c                |   15 +-
 fs/xfs/xfs_inode.h                |    1 -
 fs/xfs/xfs_log_cil.c              |   13 +-
 fs/xfs/xfs_mount.h                |    1 +
 fs/xfs/xfs_trans.c                |    2 +-
 15 files changed, 366 insertions(+), 318 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
