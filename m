Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92DEB7F4E
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 17:04:22 -0600 (CST)
Subject: [GIT PULL] XFS update for 3.9-rc1
Message-Id: <20130219230418.5CF82500B4A@whiskey.americas.sgi.com>
Date: Tue, 19 Feb 2013 17:04:18 -0600 (CST)
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

	Please pull these XFS updates for 3.9-rc1.  Here there are
primarily fixes for regressions and bugs, but there are a few cleanups
too.  There are fixes for compound buffers, quota asserts, dir v2 block
compaction, mount behavior, use-after-free with AIO, swap extents, an
unmount hang, speculative preallocation, write verifiers, the allocator
stack switch, recursion on xa_lock, an xfs_buf_find oops, and a memory
barrier in xfs_ifunlock.  Cleanups include the removal of unused
XFS_TRANS_DEBUG routines, removal of obsolete simple_strto*, removal of
boolean_t, removal of the rest of boolean_t, and replacement of a
hardcoded 128 with the log header size when calculating log space
reservations.

Thanks,
Ben

The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.9-rc1

for you to fetch changes up to 1e82379b018ceed0f0912327c60d73107dacbcb3:

  xfs: xfs_bmap_add_attrfork_local is too generic (2013-02-14 17:35:51 -0600)

----------------------------------------------------------------
xfs: update for 3.9-rc1

For 3.9-rc1 there are primarily bugfixes and a few cleanups.

- fix(es) for compound buffers
- remove unused XFS_TRANS_DEBUG routines
- fix for dquot soft timer asserts due to overflow of d_blk_softlimit
- don't zero allocation args structure members after they are memset(0)
- fix for regression in dir v2 code introduced in commit 20f7e9f3
- remove obsolete simple_strto<foo>
- fix return value when filesystem probe finds no XFS magic, a
  regression introduced in 9802182.
- remove boolean_t typedef completely
- fix stack switch in __xfs_bmapi_allocate by moving the check for stack
  switch up into xfs_bmapi_write.
- fix build error due to incomplete boolean_t removal
- fix oops in _xfs_buf_find by validating that the requested block is
  within the filesystem bounds.
- limit speculative preallocation near ENOSPC.
- fix an unmount hang in xfs_wait_buftarg by freeing the
  xfs_buf_log_item in xfs_buf_item_unlock.
- fix a possible use after free with AIO.
- fix xfs_swap_extents after removal of xfs_flushinval_pages, a
  regression introduced in fb59581404a.
- replace hardcoded 128 with log header size
- add memory barrier before wake_up_bit in xfs_ifunlock
- limit speculative preallocation on sparse files
- fix xa_lock recursion bug introduced in 90810b9e82a3
- fix write verifier for symlinks

----------------------------------------------------------------
Abhijit Pawar (1):
      fs/xfs remove obsolete simple_strto<foo>

Alex Elder (1):
      xfs: memory barrier before wake_up_bit()

Ben Myers (2):
      Merge branch 'xfs-for-3.9'
      xfs: fix fs/xfs/xfs_log.c:1740:39: error: 'B_TRUE' undeclared

Brian Foster (4):
      xfs: remove int casts from debug dquot soft limit timer asserts
      xfs: pull up stack_switch check into xfs_bmapi_write
      xfs: recheck buffer pinned status after push trylock failure
      xfs: remove log force from xfs_buf_trylock()

Dave Chinner (5):
      xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end
      xfs: limit speculative prealloc near ENOSPC thresholds
      xfs: fix shutdown hang on invalid inode during create
      xfs: limit speculative prealloc size on sparse files
      xfs: xfs_bmap_add_attrfork_local is too generic

Eric Sandeen (3):
      xfs: don't zero structure members after a memset(0)
      xfs: recalculate leaf entry pointer after compacting a dir2 block
      xfs: Do not return EFSCORRUPTED when filesystem probe finds no XFS magic

Jan Kara (1):
      xfs: Fix possible use-after-free with AIO

Jeff Liu (13):
      xfs: add a helper to figure out the space log reservation per item
      xfs: make use of xfs_calc_buf_res() in xfs_trans.c
      xfs: calculate XFS_TRANS_QM_SBCHANGE space log reservation at mount time
      xfs: calculate xfs_qm_write_sb_changes() space log reservation at mount time
      xfs: calcuate XFS_TRANS_QM_SETQLIM space log reservation at mount time
      xfs: calculate XFS_TRANS_QM_DQALLOC space log reservation at mount time
      xfs: calculate XFS_TRANS_QM_QUOTAOFF space log reservation at mount time
      xfs: calculate XFS_TRANS_QM_QUOTAOFF_END space log reservation at mount time
      xfs: introduce XFS_SB_LOG_RES() for transactions that modify sb on disk
      xfs: make use of XFS_SB_LOG_RES() at xfs_log_sbcount()
      xfs: make use of XFS_SB_LOG_RES() at xfs_mount_log_sb()
      xfs: make use of XFS_SB_LOG_RES() at xfs_fs_log_dummy()
      xfs: refactor space log reservation for XFS_TRANS_ATTR_SET

Mark Tinguely (5):
      xfs: use b_maps[] for discontiguous buffers
      xfs: rename bli_format to avoid confusion with bli_formats
      xfs: fix segment in xfs_buf_item_format_segment
      xfs: fix the multi-segment log buffer format
      xfs remove the XFS_TRANS_DEBUG routines

Thiago Farina (1):
      xfs: Remove boolean_t typedef completely.

Torsten Kaiser (1):
      xfs: Fix xfs_swap_extents() after removal of xfs_flushinval_pages()

 fs/xfs/xfs_alloc.c       |   2 -
 fs/xfs/xfs_aops.c        |   2 +-
 fs/xfs/xfs_attr.c        |   9 +-
 fs/xfs/xfs_bmap.c        | 124 ++++++++++++----
 fs/xfs/xfs_buf.c         |  34 ++++-
 fs/xfs/xfs_buf.h         |   6 +-
 fs/xfs/xfs_buf_item.c    | 177 +++++++---------------
 fs/xfs/xfs_buf_item.h    |  16 +-
 fs/xfs/xfs_dfrag.c       |   4 +-
 fs/xfs/xfs_dir2_block.c  |   6 +-
 fs/xfs/xfs_dquot.c       |  12 +-
 fs/xfs/xfs_fsops.c       |   4 +-
 fs/xfs/xfs_ialloc.c      |   4 -
 fs/xfs/xfs_inode.c       |   6 -
 fs/xfs/xfs_inode.h       |   1 +
 fs/xfs/xfs_inode_item.c  |  16 --
 fs/xfs/xfs_inode_item.h  |   4 -
 fs/xfs/xfs_iomap.c       |  86 +++++++++--
 fs/xfs/xfs_log.c         |  10 +-
 fs/xfs/xfs_mount.c       |  14 +-
 fs/xfs/xfs_mount.h       |   9 +-
 fs/xfs/xfs_qm.c          |   7 +-
 fs/xfs/xfs_qm_bhv.c      |   2 +-
 fs/xfs/xfs_qm_syscalls.c |  32 ++--
 fs/xfs/xfs_super.c       |  29 ++--
 fs/xfs/xfs_trace.h       |   1 +
 fs/xfs/xfs_trans.c       | 376 ++++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_trans.h       |  18 ++-
 fs/xfs/xfs_trans_ail.c   |  14 --
 fs/xfs/xfs_trans_buf.c   |  27 ++--
 fs/xfs/xfs_trans_dquot.c |  10 +-
 fs/xfs/xfs_trans_inode.c |  41 ------
 fs/xfs/xfs_types.h       |   1 -
 fs/xfs/xfs_vnodeops.c    |  12 +-
 34 files changed, 613 insertions(+), 503 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
