Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0VGe9JP113738 for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 10:40:09 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201101311642.p0VGgXTS018851@stout.americas.sgi.com>
Date: Mon, 31 Jan 2011 10:42:33 -0600
Subject: [GIT PULL] XFS update for 2.6.38-rc3
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

Linus, please accept the following updates for XFS, for 2.6.38-rc3
(if it's not too late) or 2.6.38-rc4.

They are all fixes for bugs that have some pretty undesirable
consequences.  They address:
- One spot in which a hang can occur due to neglecting to drop a
  lock
- A bug which in some cases a bogus block number can be recorded in
  a block map btree, resulting in a subsequent BUG_ON().
- Two memory leaks
- Three places in which extent sizes are allowed to exceed various
  size limits
- One place where code depends on behavior that is not well-defined
  by the C standard
- One problem in handling transaction commit errors

Thank you.

					-Alex

The following changes since commit 70d1f365568e0cdbc9f4ab92428e1830fdb09ab0:

  Merge branch 'for-linus' of git://git.infradead.org/ubi-2.6 (2011-01-31 13:04:51 +1000)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (8):
      xfs: fix log ticket leak on forced shutdown.
      xfs: fix efi item leak on forced shutdown
      xfs: speculative delayed allocation uses rounddown_power_of_2 badly
      xfs: limit extent length for allocation to AG size
      xfs: prevent extsize alignment from exceeding maximum extent size
      xfs: limit extsize to size of AGs and/or MAXEXTLEN
      xfs: handle CIl transaction commit failures correctly
      xfs: fix dquot shaker deadlock

bpm@sgi.com (1):
      xfs: xfs_bmap_add_extent_delay_real should init br_startblock

 fs/xfs/linux-2.6/xfs_ioctl.c |   20 ++++++++++++-
 fs/xfs/quota/xfs_qm.c        |   46 ++++++++++++++-----------------
 fs/xfs/xfs_alloc.h           |   16 +++++++++++
 fs/xfs/xfs_bmap.c            |   61 +++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_buf_item.c        |   12 +++++---
 fs/xfs/xfs_extfree_item.c    |    3 +-
 fs/xfs/xfs_iomap.c           |    7 ++++-
 fs/xfs/xfs_log.h             |    2 +-
 fs/xfs/xfs_log_cil.c         |   15 ++++------
 fs/xfs/xfs_trans.c           |   41 ++++++++++++++++++++-------
 10 files changed, 152 insertions(+), 71 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
