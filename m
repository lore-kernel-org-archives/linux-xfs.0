Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 550F37F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 22:12:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2671630405F
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 20:12:36 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KZPDuer0TjzUG3N6 for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2016 20:12:32 -0800 (PST)
Date: Thu, 14 Jan 2016 15:11:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 4.5-rc1
Message-ID: <20160114041123.GS10456@dastard>
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

Can you please pull the XFS update from the location below? There's
not a lot in this - the main addition is the CRC validation of the
entire region of the log that the will be recovered, along with
several log recovery fixes. Most of the rest is small bug fixes and
cleanups.

I have 3 bug fixes still pending, all that address recently
fixed regressions that I will send to next week after they've had
some time in for-next.

-Dave.

The following changes since commit 168309855a7d1e16db751e9c647119fe2d2dc878:

  Linux 4.4-rc8 (2016-01-03 15:15:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.5

for you to fetch changes up to dde7f55bd000696acc38296c21241971e1840142:

  Merge branch 'xfs-misc-fixes-for-4.5-2' into for-next (2016-01-12 07:04:30 +1100)

----------------------------------------------------------------

xfs: updates for 4.5-rc1

This update contains:
o extensive CRC validation during log recovery
o several log recovery bug fixes
o Various DAX support fixes
o AGFL size calculation fix
o various cleanups in preparation for new functionality
o project quota ENOSPC notification via netlink
o tracing and debug improvements

----------------------------------------------------------------
Alexander Kuleshov (1):
      xfs: make xfs_buf_ioend_async() static

Brian Foster (8):
      xfs: detect and handle invalid iclog size set by mkfs
      xfs: refactor log record unpack and data processing
      xfs: refactor and open code log record crc check
      xfs: return start block of first bad log record during recovery
      xfs: support a crc verification only log record pass
      xfs: refactor log record start detection into a new helper
      xfs: detect and trim torn writes during log recovery
      xfs: debug mode log record crc error injection

Darrick J. Wong (5):
      libxfs: make xfs_alloc_fix_freelist non-static
      xfs: fix log ticket type printing
      libxfs: use a convenience variable instead of open-coding the fork
      libxfs: pack the agfl header structure so XFS_AGFL_SIZE is correct
      libxfs: refactor short btree block verification

Dave Chinner (9):
      xfs: Don't use reserved blocks for data blocks with DAX
      xfs: fix recursive splice read locking with DAX
      Merge branch 'xfs-misc-fixes-for-4.5' into for-next
      Merge branch 'xfs-dax-fixes-for-4.5' into for-next
      xfs: add tracepoints to readpage calls
      xfs: bmapbt checking on debug kernels too expensive
      xfs: inode recovery readahead can race with inode buffer creation
      xfs: handle dquot buffer readahead in log recovery correctly
      Merge branch 'xfs-misc-fixes-for-4.5-2' into for-next

Eric Sandeen (3):
      xfs: print name of verifier if it fails
      xfs: get mp from bma->ip in xfs_bmap code
      xfs: eliminate committed arg from xfs_bmap_finish

Jia He (1):
      libxfs: Optimize the loop for xfs_bitmap_empty

Markus Elfring (1):
      XFS: Use a signed return type for suffix_kstrtoint()

Masatake YAMATO (1):
      xfs: send warning of project quota to userspace via netlink

 fs/xfs/libxfs/xfs_alloc.c          |    4 +-
 fs/xfs/libxfs/xfs_alloc.h          |    1 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |   35 +--
 fs/xfs/libxfs/xfs_attr.c           |  141 ++-------
 fs/xfs/libxfs/xfs_attr_leaf.c      |    1 +
 fs/xfs/libxfs/xfs_attr_remote.c    |   32 +-
 fs/xfs/libxfs/xfs_bit.c            |    6 +-
 fs/xfs/libxfs/xfs_bmap.c           |   43 +--
 fs/xfs/libxfs/xfs_bmap.h           |    2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |    1 +
 fs/xfs/libxfs/xfs_btree.c          |   58 ++++
 fs/xfs/libxfs/xfs_btree.h          |    3 +
 fs/xfs/libxfs/xfs_da_btree.c       |    1 +
 fs/xfs/libxfs/xfs_dir2_block.c     |    1 +
 fs/xfs/libxfs/xfs_dir2_data.c      |    2 +
 fs/xfs/libxfs/xfs_dir2_leaf.c      |    2 +
 fs/xfs/libxfs/xfs_dir2_node.c      |    1 +
 fs/xfs/libxfs/xfs_dquot_buf.c      |   37 ++-
 fs/xfs/libxfs/xfs_format.h         |    2 +-
 fs/xfs/libxfs/xfs_ialloc.c         |    1 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   27 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |   16 +-
 fs/xfs/libxfs/xfs_log_recover.h    |    1 +
 fs/xfs/libxfs/xfs_quota_defs.h     |    2 +-
 fs/xfs/libxfs/xfs_sb.c             |    2 +
 fs/xfs/libxfs/xfs_shared.h         |    1 +
 fs/xfs/libxfs/xfs_symlink_remote.c |    1 +
 fs/xfs/xfs_aops.c                  |    2 +
 fs/xfs/xfs_bmap_util.c             |   43 +--
 fs/xfs/xfs_buf.c                   |    9 +-
 fs/xfs/xfs_buf.h                   |    1 +
 fs/xfs/xfs_dquot.c                 |   13 +-
 fs/xfs/xfs_error.c                 |    4 +-
 fs/xfs/xfs_file.c                  |   25 +-
 fs/xfs/xfs_inode.c                 |   25 +-
 fs/xfs/xfs_iomap.c                 |   21 +-
 fs/xfs/xfs_log.c                   |   51 +++-
 fs/xfs/xfs_log_priv.h              |    3 +
 fs/xfs/xfs_log_recover.c           |  581 +++++++++++++++++++++++++++++-------
 fs/xfs/xfs_rtalloc.c               |    3 +-
 fs/xfs/xfs_super.c                 |    2 +-
 fs/xfs/xfs_symlink.c               |   12 +-
 fs/xfs/xfs_sysfs.c                 |   36 +++
 fs/xfs/xfs_trace.h                 |   26 ++
 fs/xfs/xfs_trans_dquot.c           |   14 +-
 45 files changed, 852 insertions(+), 443 deletions(-)

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
