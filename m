Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAAMudcH002438 for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 16:56:39 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201011102258.oAAMw2fT017804@stout.americas.sgi.com>
Date: Wed, 10 Nov 2010 16:58:02 -0600
Subject: [GIT PULL] XFS update for 2.6.37-rc2
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

Linus, please include the following patches in 2.6.37-rc2 (or if
it's too late for that, 2.6.37-rc3).

The first one simply drops a "this is an experimental feature"
warning message; this has been planned for 2.6.37 since earlier this
year.  The next two are simple cleanups, and the fourth makes use of
the newly available hlist_add_fake().

The last four fix real bugs and are the most imporant.

Thanks.

					-Alex

The following changes since commit f6614b7bb405a9b35dd28baea989a749492c46b2:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6 (2010-11-09 10:34:48 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (5):
      xfs: remove experimental tag from the delaylog option
      xfs: tell lockdep about parent iolock usage in filestreams
      xfs: fix a few compiler warnings with CONFIG_XFS_QUOTA=n
      xfs: use hlist_add_fake
      xfs: remove incorrect assert in xfs_vm_writepage

Dave Chinner (2):
      xfs: fix per-ag reference counting in inode reclaim tree walking
      xfs: move delayed write buffer trace

Kulikov Vasiliy (1):
      xfs: xfs_ioctl: fix information leak to userland

 .../filesystems/xfs-delayed-logging-design.txt     |   11 -----------
 fs/xfs/linux-2.6/xfs_aops.c                        |    7 ++++---
 fs/xfs/linux-2.6/xfs_buf.c                         |    2 +-
 fs/xfs/linux-2.6/xfs_ioctl.c                       |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c                        |    3 ++-
 fs/xfs/linux-2.6/xfs_super.c                       |    3 ---
 fs/xfs/linux-2.6/xfs_sync.c                        |    1 +
 fs/xfs/xfs_filestream.c                            |    8 +++++++-
 fs/xfs/xfs_mount.c                                 |    1 +
 fs/xfs/xfs_quota.h                                 |   20 ++++++++++++++++----
 10 files changed, 33 insertions(+), 25 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
