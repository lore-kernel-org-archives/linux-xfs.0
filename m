Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 35ED329DFB
	for <xfs@oss.sgi.com>; Sat, 28 Sep 2013 10:33:17 -0500 (CDT)
Subject: [GIT PULL] XFS fixes for 3.12-rc3
Message-Id: <20130928153316.09D864266DC@whiskey.americas.sgi.com>
Date: Sat, 28 Sep 2013 10:33:16 -0500 (CDT)
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

	Please pull these bugfixes for xfs.  There is a fix for an
	assert caused by a spurious directory block collapse, a fix for
	recovery of a block over stale metadata from a previous mkfs, a
	cleanup for the eofblocks ioctl, and fixes for locking issues in
	xfs_inode_free and log item removal from the active item list.

Thanks,
       Ben

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/xfs-for-linus-v3.12-rc3

for you to fetch changes up to 997def25e4b9cee3b01609e18a52f926bca8bd2b:

  xfs: fix node forward in xfs_node_toosmall (2013-09-26 10:38:17 -0500)

----------------------------------------------------------------
xfs: bugfixes for 3.12-rc3

- fix for directory node collapse regression
- fix for recovery over stale on disk structures
- fix for eofblocks ioctl
- fix asserts in xfs_inode_free
- lock the ail before removing an item from it

----------------------------------------------------------------
Dave Chinner (4):
      xfs: lock the AIL before removing the buffer item
      xfs: asserting lock not held during freeing not valid
      xfs: fix XFS_IOC_FREE_EOFBLOCKS definition
      xfs: log recovery lsn ordering needs uuid check

Mark Tinguely (1):
      xfs: fix node forward in xfs_node_toosmall

 fs/xfs/xfs_buf_item.c    |  1 +
 fs/xfs/xfs_da_btree.c    |  5 ++--
 fs/xfs/xfs_fs.h          |  2 +-
 fs/xfs/xfs_icache.c      |  9 +++---
 fs/xfs/xfs_log_recover.c | 73 ++++++++++++++++++++++++++++++++++++++----------
 5 files changed, 68 insertions(+), 22 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
