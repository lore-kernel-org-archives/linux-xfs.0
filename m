Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92Iasun074281 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 13:36:54 -0500
Received: from whiskey.americas.sgi.com (eagdhcp-232-197.americas.sgi.com
	[128.162.232.197])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B9B068F8040
	for <xfs@oss.sgi.com>; Tue,  2 Oct 2012 11:38:15 -0700 (PDT)
Subject: [GIT PULL] XFS update for 3.7-rc1
Message-Id: <20121002180147.DE9534266DC@whiskey.americas.sgi.com>
Date: Tue,  2 Oct 2012 13:01:47 -0500 (CDT)
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

Please pull these XFS updates for 3.7-rc1.  inode32/64 mount options have been
remountable, and there are SEEK_HOLE/SEEK_DATA enhancements.  I believe you
have already merged all of the bug fixes.

Thanks,
	Ben

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.7-rc1

for you to fetch changes up to 2ea0392983a82f7dc3055568ae0f2558724d119b:

  xfs: Make inode32 a remountable option (2012-09-26 16:01:28 -0500)

----------------------------------------------------------------
xfs: update for 3.7-rc1

Several enhancements and cleanups:

- make inode32 and inode64 remountable options
- SEEK_HOLE/SEEK_DATA enhancements
- cleanup struct declarations in xfs_mount.h

----------------------------------------------------------------
Alex Elder (1):
      xfs: kill struct declarations in xfs_mount.h

Ben Myers (1):
      xfs: stop the sync worker before xfs_unmountfs

Carlos Maiolino (8):
      xfs: fix race while discarding buffers [V4]
      Make inode64 a remountable option
      xfs: Fix m_agirotor reset during AG selection
      xfs: make inode64 as the default allocation mode
      xfs: reduce code duplication handling inode32/64 options
      xfs: Fix mp->m_maxagi update during inode64 remount
      xfs: add inode64->inode32 transition into xfs_set_inode32()
      xfs: Make inode32 a remountable option

Christoph Hellwig (1):
      xfs: unlock the AGI buffer when looping in xfs_dialloc

Dave Chinner (1):
      xfs: fix uninitialised variable in xfs_rtbuf_get()

Jeff Liu (4):
      xfs: Remove type argument from xfs_seek_data()/xfs_seek_hole()
      xfs: Introduce a helper routine to probe data or hole offset from page cache
      xfs: xfs_seek_data() refinement with unwritten extents check up from page cache
      xfs: xfs_seek_hole() refinement with hole searching from page cache for unwritten extents

Tomas Racek (1):
      xfs: check for possible overflow in xfs_ioc_trim

 fs/xfs/xfs_buf.c     |   5 +-
 fs/xfs/xfs_buf.h     |  41 +++---
 fs/xfs/xfs_discard.c |   6 +-
 fs/xfs/xfs_file.c    | 379 ++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_ialloc.c  |  19 +--
 fs/xfs/xfs_mount.c   |  43 +-----
 fs/xfs/xfs_mount.h   |   5 -
 fs/xfs/xfs_rtalloc.c |   2 +-
 fs/xfs/xfs_super.c   |  96 ++++++++++++-
 fs/xfs/xfs_super.h   |   2 +
 fs/xfs/xfs_trace.h   |   1 +
 11 files changed, 490 insertions(+), 109 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
