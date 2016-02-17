Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45F677CA2
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 00:24:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 365538F8035
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 22:24:33 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vBhBqKea52QQBwYl for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 22:24:28 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aVvWc-0004fY-8G
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 17:23:46 +1100
Date: Wed, 17 Feb 2016 17:23:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v4.5.0-rc1 released
Message-ID: <20160217062346.GB19486@dastard>
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
To: xfs@oss.sgi.com

Hi Folks,

The xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged as the first 4.5.0 release
candidate. This update brings the libxfs/ code in sync with the
kernel 4.5-rc2 kernel code. The master branch is now for bug fixes
only until release.  Development for the 4.6.0 release will shift to
the for-next branch at this point.

-Dave.

The new head of the master branch is commit:

1abecda xfsprogs: Release v4.5.0-rc1

New Commits:

Andreas Gruenbacher (1):
      [22b8a86] xfs: Validate the length of on-disk ACLs

Bill O'Donnell (1):
      [7989643] xfs: per-filesystem stats counter implementation

Brian Foster (3):
      [5769a37] xfs: add missing bmap cancel calls in error paths
      [f44fbde] xfs: log local to remote symlink conversions correctly on v5 supers
      [c063b96] xfs: swap leaf buffer into path struct atomically during path shift

Dave Chinner (9):
      [83f4b5a] xfs_fs.h: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR promotion
      [a0363e2] xfs: introduce per-inode DAX enablement
      [7093f63] xfs_io: add support for changing the new inode DAX attribute
      [9542ae1] xfs: introduce BMAPI_ZERO for allocating zeroed extents
      [f07ae2a] xfs: bmapbt checking on debug kernels too expensive
      [736e1cf] xfs: inode recovery readahead can race with inode buffer creation
      [6daba42] xfs: handle dquot buffer readahead in log recovery correctly
      [7ebb764] xfs: stop holding ILOCK over filldir callbacks
      [1abecda] xfsprogs: Release v4.5.0-rc1

Eric Sandeen (2):
      [65ca380] xfs: get mp from bma->ip in xfs_bmap code
      [0b66d45] xfs: eliminate committed arg from xfs_bmap_finish

Geliang Tang (1):
      [eab16f4] libxfs: fix two comment typos

Jia He (1):
      [c5c9f53] libxfs: Optimize the loop for xfs_bitmap_empty


Code Diffstat:

 VERSION                     |   4 +-
 configure.ac                |   2 +-
 doc/CHANGES                 |  19 ++++++
 fsr/xfs_fsr.c               |  16 ++---
 include/darwin.h            |  35 +++++++++++
 include/freebsd.h           |  35 +++++++++++
 include/irix.h              |  38 +++++++++++-
 include/libxfs.h            |   2 -
 include/linux.h             |  39 ++++++++++++
 io/attr.c                   |  45 +++++++-------
 io/bmap.c                   |  16 ++---
 io/open.c                   |  32 +++++-----
 libxcmd/projects.c          |   8 +--
 libxfs/libxfs_api_defs.h    |   1 +
 libxfs/libxfs_io.h          |   2 +
 libxfs/libxfs_priv.h        |   9 ++-
 libxfs/rdwr.c               |   4 +-
 libxfs/util.c               |  52 ++++++++++++----
 libxfs/xfs_alloc.c          |  18 ++++--
 libxfs/xfs_alloc.h          |   8 ++-
 libxfs/xfs_attr.c           | 147 ++++++++------------------------------------
 libxfs/xfs_attr_remote.c    |  31 ++--------
 libxfs/xfs_bit.c            |   6 +-
 libxfs/xfs_bmap.c           |  86 ++++++++++++++++++--------
 libxfs/xfs_bmap.h           |  15 ++++-
 libxfs/xfs_btree.c          |   4 +-
 libxfs/xfs_btree.h          |  41 +++++++-----
 libxfs/xfs_da_btree.c       |  23 ++++---
 libxfs/xfs_dir2.c           |   9 ++-
 libxfs/xfs_dquot_buf.c      |  37 +++++++++--
 libxfs/xfs_format.h         |  19 ++++--
 libxfs/xfs_fs.h             |  54 +++++++---------
 libxfs/xfs_inode_buf.c      |  14 +++--
 libxfs/xfs_quota_defs.h     |   2 +-
 libxfs/xfs_shared.h         |   1 +
 libxfs/xfs_symlink_remote.c |   3 +
 mkfs/proto.c                |  14 ++---
 quota/free.c                |   6 +-
 quota/project.c             |  16 ++---
 repair/dinode.c             |   4 +-
 repair/phase6.c             |  33 ++++------
 rtcp/xfs_rtcp.c             |  12 ++--
 42 files changed, 567 insertions(+), 395 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
