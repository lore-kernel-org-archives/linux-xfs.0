Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAM5kPH135415 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 16:05:46 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201111102205.pAAM5e4f019587@stout.americas.sgi.com>
Date: Thu, 10 Nov 2011 16:05:40 -0600
Subject: [GIT PULL] XFS update for 3.2-rc2
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

Linus, please pull the following changes for XFS for 3.2-rc2.
The first two address some security concerns, the last one is
a bug fix.  Thanks.

					-Alex

The following changes since commit 5e442a493fc59fa536c76db1fff5b49ca36a88c5:

  Revert "proc: fix races against execve() of /proc/PID/fd**" (2011-11-09 18:16:00 -0500)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Carlos Maiolino (1):
      xfs: Fix possible memory corruption in xfs_readlink

Christoph Hellwig (2):
      xfs: constify xfs_item_ops
      xfs: fix force shutdown handling in xfs_end_io

 fs/xfs/xfs_aops.c         |    2 +-
 fs/xfs/xfs_buf_item.c     |    2 +-
 fs/xfs/xfs_dquot_item.c   |    6 +++---
 fs/xfs/xfs_extfree_item.c |    4 ++--
 fs/xfs/xfs_inode_item.c   |    2 +-
 fs/xfs/xfs_log.c          |    2 +-
 fs/xfs/xfs_log.h          |    2 +-
 fs/xfs/xfs_trans.h        |    6 +++---
 fs/xfs/xfs_vnodeops.c     |   14 ++++++++++----
 9 files changed, 23 insertions(+), 17 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
