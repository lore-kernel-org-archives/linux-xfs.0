Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0I1BfgR061460 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 19:11:41 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201001180112.o0I1CaCH001417@stout.americas.sgi.com>
Date: Sun, 17 Jan 2010 19:12:36 -0600
Subject: [GIT PULL] XFS update for 2.6.33-rc4
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

The following changes since commit 7284ce6c9f6153d1777df5f310c959724d1bd446:
  Linus Torvalds (1):
        Linux 2.6.33-rc4

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (7):
      xfs: reclaim inodes under a write lock
      xfs: Avoid inodes in reclaim when flushing from inode cache
      xfs: reclaim all inodes by background tree walks
      xfs: Remove inode iolock held check during allocation
      xfs: fix stale inode flush avoidance
      xfs: fix missing error check in xfs_rtfree_range
      xfs: xfs_swap_extents needs to handle dynamic fork offsets

 fs/xfs/linux-2.6/xfs_super.c   |   14 ++--
 fs/xfs/linux-2.6/xfs_sync.c    |  183 +++++++++++++++++++---------------------
 fs/xfs/linux-2.6/xfs_sync.h    |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |    2 +-
 fs/xfs/xfs_dfrag.c             |  106 ++++++++++++++++++++----
 fs/xfs/xfs_iget.c              |    1 -
 fs/xfs/xfs_inode.c             |   21 ++++--
 fs/xfs/xfs_rtalloc.c           |    2 +
 8 files changed, 201 insertions(+), 130 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
