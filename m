Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC0527CA0
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 00:15:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2EF21AC001
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 22:15:25 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bxbO3NOtLNHAnzTL for <xfs@oss.sgi.com>;
	Thu, 18 Aug 2016 22:15:22 -0700 (PDT)
Date: Fri, 19 Aug 2016 15:14:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs, iomap: fixes for 4.8-rc3
Message-ID: <20160819051449.GF22388@dastard>
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

Can you please pull the fixes from the tag list below? This update
contains fixes for most of the outstanding regressions introduced
with the 4.8-rc1 XFS and iomap infrastructure merge.

The only regression that isn't addressed by this pullreq is the aim7
write regression.  I'm still testing Christophs patches that address
the simple cases we've reproduced, but the cause of the aim7
regression is still not clear so there's more work to be done there.
Still, that's no reason to hold up all the other issues we have
tested fixes for.

Thanks!

-Dave.

The following changes since commit 694d0d0bb2030d2e36df73e2d23d5770511dbc8d:

  Linux 4.8-rc2 (2016-08-14 19:11:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-iomap-for-linus-4.8-rc3

for you to fetch changes up to 32438cf9d54bd53b531f6d98814e84dd278360c1:

  Merge branch 'iomap-fixes-4.8-rc3' into for-next (2016-08-17 11:13:37 +1000)

----------------------------------------------------------------
xfs, iomap: update for 4.8-rc3

Changes in this update
- regression fixes for XFS changes introduce in 4.8-rc1
	- buffer IO accounting assert failure
	- ENOSPC block accounting reservation issue
	- DAX IO path page cache invalidation fix
	- rmapbt on-disk block count in agf
	- correct classification of rmap block type when updating AGFL.
	- iomap support for attribute fork mapping
- regression fixes for iomap infrastructure in 4.8-rc1
	- fiemap: honor FIEMAP_FLAG_SYNC
	- fiemap: implement FIEMAP_FLAG_XATTR support to fix XFS regression
	- make mark_page_accessed and pagefault_disable usage consistent with
	  other IO paths

----------------------------------------------------------------
Brian Foster (1):
      xfs: don't assert fail on non-async buffers on ioacct decrement

Christoph Hellwig (6):
      xfs: fix bogus space reservation in xfs_iomap_write_allocate
      iomap: remove superflous mark_page_accessed from iomap_write_actor
      iomap: remove superflous pagefault_disable from iomap_write_actor
      iomap: mark ->iomap_end as optional
      xfs: simplify xfs_file_iomap_begin
      xfs: (re-)implement FIEMAP_FLAG_XATTR

Darrick J. Wong (2):
      xfs: store rmapbt block count in the AGF
      xfs: remove OWN_AG rmap when allocating a block from the AGFL

Dave Chinner (4):
      xfs: don't invalidate whole file on DAX read/write
      iomap: fiemap should honor the FIEMAP_FLAG_SYNC flag
      iomap: prepare iomap_fiemap for attribute mappings
      Merge branch 'iomap-fixes-4.8-rc3' into for-next

 fs/iomap.c                     | 21 ++++++++-----
 fs/xfs/libxfs/xfs_alloc.c      | 14 +++++++++
 fs/xfs/libxfs/xfs_format.h     | 11 +++++--
 fs/xfs/libxfs/xfs_rmap_btree.c |  6 ++++
 fs/xfs/xfs_buf.c               |  1 -
 fs/xfs/xfs_file.c              | 13 +++++++-
 fs/xfs/xfs_fsops.c             |  1 +
 fs/xfs/xfs_iomap.c             | 69 ++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_iomap.h             |  1 +
 fs/xfs/xfs_iops.c              |  9 +++++-
 fs/xfs/xfs_trace.h             |  1 -
 11 files changed, 119 insertions(+), 28 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
