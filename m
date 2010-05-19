Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JKsjHU154733 for <xfs@oss.sgi.com>; Wed, 19 May 2010 15:54:45 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201005192056.o4JKuua2012029@stout.americas.sgi.com>
Date: Wed, 19 May 2010 15:56:56 -0500
Subject: [GIT PULL] XFS update for 2.6.35-rc1
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

FYI, I have a second batch of changes for XFS for 2.6.35-rc1.  I'll
send a separate pull request for them in another day or two.

					-Alex

The following changes since commit 537b60d17894b7c19a6060feae40299d7109d6e7:

  Merge branch 'x86-uv-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-05-18 09:46:35 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (12):
      xfs: add const qualifiers to xfs error function args
      xfs: fix min bufsize bugs in two places
      xfs: simplify XLOG_SECTOR_ROUND*()
      xfs: kill XLOG_SECTOR_ROUND*()
      xfs: encapsulate bbcount validity checking
      xfs: nothing special about 1-block log sector
      xfs: change a few labels in xfs_log_recover.c
      xfs: avoid repeated pointer dereferences
      xfs: minor odds and ends in xfs_log_recover.c
      xfs: record log sector size rather than log2(that)
      xfs: kill off l_sectbb_mask
      Merge branch 'master' into for-linus

Andrea Gelmini (1):
      xfs: xfs_trace.c: duplicated include

Christoph Hellwig (23):
      xfs: clean up xfs_trans_commit logic even more
      xfs: reindent xlog_write
      xfs: clean up xlog_write_adv_cnt
      xfs: remove xfs_dqmarker
      xfs: remove periodic superblock writeback
      xfs: enforce synchronous writes in xfs_bwrite
      xfs: wait for direct I/O to complete in fsync and write_inode
      xfs: access quotainfo structure directly
      xfs: remove a few macro indirections in the quota code
      xfs: removed unused XFS_QMOPT_ flags
      xfs: remove dead XFS_LOUD_RECOVERY code
      xfs: simplify buffer to transaction matching
      xfs: limit xfs_imap_to_bmap to a single mapping
      xfs: remove iomap_target
      xfs: remove iomap_delta
      xfs: report iomap_offset and iomap_bsize in block base
      xfs: report iomap_bn in block base
      xfs: kill struct xfs_iomap
      xfs: move I/O type flags into xfs_aops.c
      xfs: clean up xfs_iomap_valid
      xfs: clean up mapping size calculation in __xfs_get_blocks
      xfs: clean up end index calculation in xfs_page_state_convert
      xfs: mark xfs_iomap_write_ helpers static

Dave Chinner (16):
      xfs: factor log item initialisation
      xfs: Add inode pin counts to traces
      xfs: remove stale parameter from ->iop_unpin method
      xfs: fix reservation release commit flag in xfs_bmap_add_attrfork()
      xfs: split out iclog writing from xfs_trans_commit()
      xfs: update and factor xfs_trans_committed()
      xfs: Clean up xfs_trans_committed code after factoring
      xfs: log ticket reservation underestimates the number of iclogs
      xfs: factor xlog_write
      xfs: introduce new internal log vector structure
      xfs: add log item recovery tracing
      xfs: convert the per-mount dquot list to use list heads
      xfs: remove duplicate code from dquot reclaim
      xfs: convert the dquot hash list to use list heads
      xfs: convert the dquot free list to use list heads
      xfs: make the log ticket transaction id random

Jan Engelhardt (1):
      xfs: add blockdev name to kthreads

Tao Ma (1):
      xfs: Make fiemap work in query mode.

Zhitong Wang (1):
      xfs: Fix integer overflow in fs/xfs/linux-2.6/xfs_ioctl*.c

 fs/xfs/linux-2.6/xfs_aops.c    |  231 +++++++-----
 fs/xfs/linux-2.6/xfs_buf.c     |   27 +-
 fs/xfs/linux-2.6/xfs_buf.h     |    2 +-
 fs/xfs/linux-2.6/xfs_file.c    |    2 +
 fs/xfs/linux-2.6/xfs_ioctl.c   |    4 +
 fs/xfs/linux-2.6/xfs_ioctl32.c |    4 +
 fs/xfs/linux-2.6/xfs_iops.c    |    5 +-
 fs/xfs/linux-2.6/xfs_super.c   |   10 +-
 fs/xfs/linux-2.6/xfs_sync.c    |   91 ++----
 fs/xfs/linux-2.6/xfs_trace.c   |    4 +-
 fs/xfs/linux-2.6/xfs_trace.h   |  150 ++++++++-
 fs/xfs/quota/xfs_dquot.c       |  193 +++++------
 fs/xfs/quota/xfs_dquot.h       |   35 +--
 fs/xfs/quota/xfs_dquot_item.c  |   30 +-
 fs/xfs/quota/xfs_qm.c          |  609 ++++++++++++--------------------
 fs/xfs/quota/xfs_qm.h          |   23 +-
 fs/xfs/quota/xfs_qm_stats.c    |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |  152 ++++-----
 fs/xfs/quota/xfs_quota_priv.h  |  102 ------
 fs/xfs/quota/xfs_trans_dquot.c |   29 +-
 fs/xfs/xfs_bmap.c              |    2 +-
 fs/xfs/xfs_buf_item.c          |   55 ++--
 fs/xfs/xfs_buf_item.h          |    2 +-
 fs/xfs/xfs_error.c             |   30 +-
 fs/xfs/xfs_error.h             |    9 +-
 fs/xfs/xfs_extfree_item.c      |   18 +-
 fs/xfs/xfs_inode.c             |    2 +
 fs/xfs/xfs_inode_item.c        |   21 +-
 fs/xfs/xfs_iomap.c             |  123 ++-----
 fs/xfs/xfs_iomap.h             |   47 +---
 fs/xfs/xfs_log.c               |  702 +++++++++++++++++++++++--------------
 fs/xfs/xfs_log.h               |   13 +
 fs/xfs/xfs_log_priv.h          |   12 +-
 fs/xfs/xfs_log_recover.c       |  311 ++++++++---------
 fs/xfs/xfs_mount.c             |    7 -
 fs/xfs/xfs_quota.h             |    3 -
 fs/xfs/xfs_trans.c             |  760 +++++++++++++++++++---------------------
 fs/xfs/xfs_trans.h             |   14 +-
 fs/xfs/xfs_trans_buf.c         |  187 +++--------
 39 files changed, 1905 insertions(+), 2118 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
