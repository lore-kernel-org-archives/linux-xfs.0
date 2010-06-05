Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o55BEiIf022833 for <xfs@oss.sgi.com>; Sat, 5 Jun 2010 06:14:44 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006051117.o55BH8KB006254@stout.americas.sgi.com>
Date: Sat, 05 Jun 2010 06:17:07 -0500
Subject: [GIT PULL] XFS update for 2.6.35-rc2
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

The following changes since commit 7f0d384cafabfbb56663ee6944c18fc0450fc5d6:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6 (2010-06-04 21:12:39 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch 'master' into for-linus

Christoph Hellwig (6):
      xfs: cleanup log reservation calculactions
      xfs: clean up xlog_align
      xfs: fix access to upper inodes without inode64
      xfs: remove done roadmap item from xfs-delayed-logging-design.txt
      xfs: skip writeback from reclaim context
      xfs: improve xfs_isilocked

Dave Chinner (3):
      xfs: Check new inode size is OK before preallocating
      xfs: fix might_sleep() warning when initialising per-ag tree
      xfs: fix race in inode cluster freeing failing to stale inodes

Eric Sandeen (2):
      xfs: replace E2BIG with EFBIG where appropriate
      xfs: be more explicit if RT mount fails due to config

Huang Weiyi (2):
      xfs: xfs_trace.c: remove duplicated #include
      xfs: remove duplicated #include

Julia Lawall (1):
      fs/xfs/quota: Add missing mutex_unlock

Li Zefan (1):
      xfs: convert more trace events to DEFINE_EVENT

 .../filesystems/xfs-delayed-logging-design.txt     |    5 -
 fs/xfs/linux-2.6/xfs_aops.c                        |   15 +
 fs/xfs/linux-2.6/xfs_iops.c                        |   16 +-
 fs/xfs/linux-2.6/xfs_quotaops.c                    |    1 -
 fs/xfs/linux-2.6/xfs_sync.c                        |    9 -
 fs/xfs/linux-2.6/xfs_trace.c                       |    1 -
 fs/xfs/linux-2.6/xfs_trace.h                       |  356 ++++++++--------
 fs/xfs/quota/xfs_qm.c                              |    4 +-
 fs/xfs/xfs_ag.h                                    |    1 -
 fs/xfs/xfs_iget.c                                  |   29 +-
 fs/xfs/xfs_inode.c                                 |  144 +++----
 fs/xfs/xfs_log_recover.c                           |   11 +-
 fs/xfs/xfs_mount.c                                 |   68 ++--
 fs/xfs/xfs_rtalloc.c                               |    4 +-
 fs/xfs/xfs_rtalloc.h                               |   11 +-
 fs/xfs/xfs_trans.c                                 |  446 ++++++++++++++++++--
 fs/xfs/xfs_trans.h                                 |  411 ------------------
 fs/xfs/xfs_vnodeops.c                              |    2 +-
 18 files changed, 736 insertions(+), 798 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
