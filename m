Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n524QfE6070255 for <xfs@oss.sgi.com>; Mon, 1 Jun 2009 23:26:41 -0500
Date: Mon, 01 Jun 2009 23:26:53 -0500
Subject: [GIT PULL] XFS update for 2.6.30-rc8
MIME-Version: 1.0
Message-Id: <20090602042653.66DB5A1FAB93@attica.americas.sgi.com>
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
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

The following changes since commit d9244b5d2fbfe9fa540024b410047af13ceec90f:
  Linus Torvalds (1):
        Merge branch 'hwmon-for-linus' of git://git.kernel.org/.../jdelvare/staging

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Eric Sandeen (1):
      xfs: fix overflow in xfs_growfs_data_private

Felix Blyakher (2):
      xfs: fix double unlock in xfs_swap_extents()
      xfs: prevent deadlock in xfs_qm_shake()

 fs/xfs/linux-2.6/kmem.h |    2 +-
 fs/xfs/xfs_dfrag.c      |    8 +++++---
 fs/xfs/xfs_fsops.c      |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
