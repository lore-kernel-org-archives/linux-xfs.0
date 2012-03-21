Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2LIa69X109418 for <xfs@oss.sgi.com>; Wed, 21 Mar 2012 13:36:06 -0500
Subject: [GIT PULL] XFS update for 3.4-rc1
Message-Id: <20120321183613.2C93F426DA7@whiskey.americas.sgi.com>
Date: Wed, 21 Mar 2012 13:36:13 -0500 (CDT)
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

   Please pull from git://oss.sgi.com/xfs/xfs for-linus

   Bugfixes and cleanups.

Thanks,
	Ben

The following changes since commit 31f6765266417c0d99f0e922fe82848a7c9c2ae9:

  Merge tag 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging (2012-03-21 10:37:25 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Amit Sahrawat (1):
      xfs: kill the unused XFS_BB_FSB_OFFSET macro

Chandra Seetharaman (4):
      Define a new function xfs_this_quota_on()
      Define a new function xfs_inode_dquot()
      Change xfs_sb_from_disk() interface to take a mount pointer
      Define new macro XFS_ALL_QUOTA_ACTIVE and simply some usage

Christoph Hellwig (1):
      xfs: use a normal shrinker for the dquot freelist

Jesper Juhl (1):
      XFS: xfs_trans_add_item() - don't assign in ASSERT() when compare is intended

Mitsuo Hayasaka (3):
      xfs: show uuid when mount fails due to duplicate uuid
      xfs: change available ranges of softlimit and hardlimit in quota check
      xfs: make inode quota check more general

 fs/xfs/kmem.h            |    6 -
 fs/xfs/xfs_dquot.c       |  164 ++++++++------------------
 fs/xfs/xfs_dquot.h       |   30 ++++-
 fs/xfs/xfs_log_recover.c |    8 +-
 fs/xfs/xfs_mount.c       |    8 +-
 fs/xfs/xfs_mount.h       |    2 +-
 fs/xfs/xfs_qm.c          |  293 ++++++++++++++++++----------------------------
 fs/xfs/xfs_qm.h          |   14 ---
 fs/xfs/xfs_qm_stats.c    |    4 +-
 fs/xfs/xfs_qm_syscalls.c |    4 +-
 fs/xfs/xfs_quota.h       |    2 +
 fs/xfs/xfs_sb.h          |    1 -
 fs/xfs/xfs_super.c       |    7 +-
 fs/xfs/xfs_trace.h       |    5 +-
 fs/xfs/xfs_trans.c       |    4 +-
 fs/xfs/xfs_trans_dquot.c |   10 +-
 16 files changed, 216 insertions(+), 346 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
