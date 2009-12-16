Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBGLPY32096216 for <xfs@oss.sgi.com>; Wed, 16 Dec 2009 15:25:34 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <200912162126.nBGLQAbZ012632@stout.americas.sgi.com>
Date: Wed, 16 Dec 2009 15:26:10 -0600
Subject: [GIT PULL] XFS update for 2.6.33-rc1
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

One more XFS update for -rc1, now that the new XFS tracing code has
been committed.

					-Alex

The following changes since commit 5ac4d630eb87656bd4dc313b910776d54d88ea28:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (2):
      xfs: check for not fully initialized inodes in xfs_ireclaim
      xfs: kill xfs_bmbt_rec_32/64 types

Dave Chinner (2):
      xfs: improve metadata I/O merging in the elevator
      XFS: Free buffer pages array unconditionally

 fs/xfs/linux-2.6/xfs_buf.c |   10 +++++++---
 fs/xfs/linux-2.6/xfs_buf.h |    1 +
 fs/xfs/xfs_bmap_btree.h    |   14 +++-----------
 fs/xfs/xfs_iget.c          |   12 ++++++++----
 fs/xfs/xfs_inode_item.h    |    6 +++---
 fs/xfs/xfs_log.c           |    2 ++
 include/linux/fs.h         |    1 +
 7 files changed, 25 insertions(+), 21 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
