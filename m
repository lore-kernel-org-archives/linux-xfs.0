Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3U2JWcY121547 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 21:19:32 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201004300221.o3U2LYZt009176@stout.americas.sgi.com>
Date: Thu, 29 Apr 2010 21:21:34 -0500
Subject: [GIT PULL] XFS update for 2.6.34-rc6 or -rc7
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

I expect this won't make it for 2.6.34-rc6, so if not, please
pull it for 2.6.34-rc7.  This change addresses a regression
that went into 2.6.34-rc1, which can lead to memory exhaustion
in some situations.

					-Alex

The following changes since commit 79dba2eaa771c3173957eccfd288e0e0d12e4d3f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 (2010-04-28 20:40:17 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: add a shrinker to background inode reclaim

 fs/xfs/linux-2.6/xfs_super.c   |    5 ++
 fs/xfs/linux-2.6/xfs_sync.c    |  112 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/linux-2.6/xfs_sync.h    |    7 ++-
 fs/xfs/quota/xfs_qm_syscalls.c |    3 +-
 fs/xfs/xfs_ag.h                |    1 +
 fs/xfs/xfs_mount.h             |    1 +
 6 files changed, 120 insertions(+), 9 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
