Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A6B07CA2
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 17:27:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A19A304039
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 15:27:06 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	TidzBujGsYPScMiy for <xfs@oss.sgi.com>;
	Thu, 01 Sep 2016 15:27:04 -0700 (PDT)
Date: Fri, 2 Sep 2016 08:27:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs, iomap: fixes for 4.8-rc5
Message-ID: <20160901222702.GX22388@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Can you please pull this XFS and iomap update from the tag below?
Most of these changes are small regression fixes that address
problems introduced in the 4.8-rc1 window. The two fixes that aren't
(IO completion fix and superblock inprogress check) are fixes for
problems introduced some time ago and need to be pushed back to
stable kernels.

Thanks!

Dave.

--

The following changes since commit 32438cf9d54bd53b531f6d98814e84dd278360c1:

  Merge branch 'iomap-fixes-4.8-rc3' into for-next (2016-08-17 11:13:37 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-iomap-for-linus-4.8-rc5

for you to fetch changes up to ea78d80866ce375defb2fdd1c8a3aafec95e0f85:

  xfs: track log done items directly in the deferred pending work item (2016-08-30 13:51:39 +1000)

----------------------------------------------------------------
xfs: updates for 4.8-rc5

Changes in this update:
o iomap FIEMAP_EXTENT_MERGED usage fix
o additional mount-time feature restrictions
o rmap btree query fixes
o freeze/unmount io completion workqueue fix
o memory corruption fix for deferred operations handling

----------------------------------------------------------------
Brian Foster (1):
      xfs: prevent dropping ioend completions during buftarg wait

Christoph Hellwig (1):
      iomap: don't set FIEMAP_EXTENT_MERGED for extent based filesystems

Darrick J. Wong (6):
      xfs: don't perform lookups on zero-height btrees
      xfs: disallow mounting of realtime + rmap filesystems
      xfs: don't log the entire end of the AGF
      xfs: fix some key handling problems in _btree_simple_query_range
      xfs: simple btree query range should look right if LE lookup fails
      xfs: track log done items directly in the deferred pending work item

Dave Chinner (1):
      xfs: fix superblock inprogress check

 fs/iomap.c                 |  5 ++++-
 fs/xfs/libxfs/xfs_alloc.c  |  2 ++
 fs/xfs/libxfs/xfs_btree.c  | 14 +++++++++++++-
 fs/xfs/libxfs/xfs_defer.c  | 17 ++++-------------
 fs/xfs/libxfs/xfs_defer.h  |  2 +-
 fs/xfs/libxfs/xfs_format.h |  6 ++++--
 fs/xfs/libxfs/xfs_sb.c     |  3 ++-
 fs/xfs/xfs_buf.c           |  2 +-
 fs/xfs/xfs_super.c         |  9 ++++++++-
 fs/xfs/xfs_trace.h         |  2 +-
 include/linux/iomap.h      |  8 +++++++-
 11 files changed, 47 insertions(+), 23 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
