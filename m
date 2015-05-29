Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7281D7F56
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 17:56:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5F526304053
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 15:56:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UiW1DgnWcZHIH1u1 for <xfs@oss.sgi.com>;
	Fri, 29 May 2015 15:56:06 -0700 (PDT)
Date: Sat, 30 May 2015 08:55:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: update for v4.1-rc6
Message-ID: <20150529225546.GF4316@dastard>
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
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Can you please pull the fixes from the tag below? It's a little
larger than I'd like late in the release cycle, but all the fixes
are for regressions introduced in the 4.1-rc1 merge, or are needed
back in -stable kernels fairly quickly as they are filesystem
corruption or userspace visible correctness issues.

Thanks!

-Dave.

The following changes since commit 5ebe6afaf0057ac3eaeb98defd5456894b446d22:

  Linux 4.1-rc2 (2015-05-03 19:22:23 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.1-rc6

for you to fetch changes up to 22419ac9fe5e79483596cebdbd1d1209c18bac1a:

  xfs: fix broken i_nlink accounting for whiteout tmpfile inode (2015-05-29 08:14:55 +1000)

----------------------------------------------------------------
xfs: update for 4.1-rc6

Changes in this update:
o regression fix for new rename whiteout code
o regression fixes for new superblock generic per-cpu counter code
o fix for incorrect error return sign introduced in 3.17
o metadata corruption fixes that need to go back to -stable kernels

----------------------------------------------------------------
Brian Foster (1):
      xfs: fix broken i_nlink accounting for whiteout tmpfile inode

Dave Chinner (5):
      percpu_counter: batch size aware __percpu_counter_compare()
      xfs: inode and free block counters need to use __percpu_counter_compare
      xfs: extent size hints can round up extents past MAXEXTLEN
      xfs: xfs_attr_inactive leaves inconsistent attr fork state behind
      xfs: xfs_iozero can return positive errno

George Wang (1):
      xfs: use percpu_counter_read_positive for mp->m_icount

 fs/xfs/libxfs/xfs_attr_leaf.c  |    8 ++--
 fs/xfs/libxfs/xfs_attr_leaf.h  |    2 +-
 fs/xfs/libxfs/xfs_bmap.c       |   31 +++++++++------
 fs/xfs/libxfs/xfs_ialloc.c     |    9 +++--
 fs/xfs/xfs_attr_inactive.c     |   83 ++++++++++++++++++++++++----------------
 fs/xfs/xfs_file.c              |    2 +-
 fs/xfs/xfs_inode.c             |   22 ++++++-----
 fs/xfs/xfs_mount.c             |   34 +++++++++-------
 include/linux/percpu_counter.h |   13 ++++++-
 lib/percpu_counter.c           |    6 +--
 10 files changed, 127 insertions(+), 83 deletions(-)

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
