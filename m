Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0HLt79s179554 for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 15:55:07 -0600
Subject: [GIT PULL] XFS update for 3.3
Message-Id: <20120117215505.8978A426DA7@whiskey.americas.sgi.com>
Date: Tue, 17 Jan 2012 15:55:05 -0600 (CST)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

   Please pull the following XFS changes for 3.3.

Thanks,
	Ben

The following changes since commit c2bc3a316a7281f67e36b34dac2802cbe36a9128:
  Linus Torvalds (1):
        Merge branch 'x86/rdrand' of git://git.kernel.org/.../tip/tip

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (11):
      xfs: remove xfs_itruncate_data
      xfs: cleanup xfs_iomap_eof_align_last_fsb
      xfs: remove the unused dm_attrs structure
      xfs: remove the if_ext_max field in struct xfs_ifork
      xfs: make i_flags an unsigned long
      xfs: replace i_flock with a sleeping bitlock
      xfs: replace i_pin_wait with a bit waitqueue
      xfs: remove the i_size field in struct xfs_inode
      xfs: remove the i_new_size field in struct xfs_inode
      xfs: always return with the iolock held from xfs_file_aio_write_checks
      xfs: cleanup xfs_file_aio_write

 fs/xfs/xfs_aops.c        |   29 ++++---
 fs/xfs/xfs_attr.c        |    4 -
 fs/xfs/xfs_attr_leaf.c   |    9 --
 fs/xfs/xfs_bmap.c        |  116 +++++++++++++---------------
 fs/xfs/xfs_dfrag.c       |   43 +++++-----
 fs/xfs/xfs_file.c        |  184 ++++++++++++-------------------------------
 fs/xfs/xfs_fs_subr.c     |    2 +-
 fs/xfs/xfs_iget.c        |   24 ++++--
 fs/xfs/xfs_inode.c       |  193 +++++++++++-----------------------------------
 fs/xfs/xfs_inode.h       |  114 ++++++++++++++++-----------
 fs/xfs/xfs_inode_item.c  |    8 +-
 fs/xfs/xfs_iomap.c       |   46 ++++++------
 fs/xfs/xfs_iops.c        |   46 +++++++----
 fs/xfs/xfs_qm_syscalls.c |    8 ++-
 fs/xfs/xfs_super.c       |    8 --
 fs/xfs/xfs_sync.c        |    9 +-
 fs/xfs/xfs_trace.h       |   29 ++-----
 fs/xfs/xfs_vnodeops.c    |   44 +++++++----
 18 files changed, 374 insertions(+), 542 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
