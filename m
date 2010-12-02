Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB2GfNXO029777 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 10:41:23 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201012021643.oB2Gh3JL006178@stout.americas.sgi.com>
Date: Thu, 02 Dec 2010 10:43:03 -0600
Subject: [GIT PULL] XFS update for 2.6.37-rc5
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

Linus, please pull the following five XFS bug fixes for 2.6.37.

					-Alex

The following changes since commit 22a5b566c8c442b0b35b3b106795e2f2b3578096:

  Merge branch 'for_linus' of git://github.com/at91linux/linux-2.6-at91 (2010-11-30 17:57:57 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (5):
      xfs: fix failed write truncation handling.
      xfs: push stale, pinned buffers on trylock failures
      xfs: delayed alloc blocks beyond EOF are valid after writeback
      xfs: avoid moving stale inodes in the AIL
      xfs: only run xfs_error_test if error injection is active

 fs/xfs/linux-2.6/xfs_aops.c |   94 ++++++++++++++++++------------------------
 fs/xfs/linux-2.6/xfs_buf.c  |   35 +++++++---------
 fs/xfs/xfs_bmap.c           |   85 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_bmap.h           |    5 ++
 fs/xfs/xfs_dfrag.c          |   13 ++++++
 fs/xfs/xfs_error.c          |    3 +
 fs/xfs/xfs_error.h          |    5 +-
 fs/xfs/xfs_inode_item.c     |   31 +++++++++++---
 8 files changed, 188 insertions(+), 83 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
