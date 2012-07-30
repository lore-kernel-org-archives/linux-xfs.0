Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6UIoEHa079445 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 13:50:14 -0500
Subject: [GIT PULL] XFS update for 3.6-rc1
Message-Id: <20120730185009.AF6AB4266DC@whiskey.americas.sgi.com>
Date: Mon, 30 Jul 2012 13:50:09 -0500 (CDT)
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

Please pull these XFS updates for 3.6-rc1.  There are numerous cleanups and
several bugfixes.  Here are the highlights:

	* Discontiguous directory buffer support
	* Inode allocator refactoring
	* Removal of the IO lock in inode reclaim
	* Implementation of .update_time
	* Fix for handling of EOF in xfs_vm_writepage
	* Fix for races in xfsaild, and idle mode is re-enabled
	* Fix for a crash in xfs_buf completion handlers on unmount.

Thanks,
	Ben

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.6-rc1

for you to fetch changes up to 9a57fa8ee7c29e11c2a29ce058573ba99157eda7:

  xfs: wait for the write the superblock on unmount (2012-07-29 16:34:19 -0500)

----------------------------------------------------------------
xfs: update for 3.6-rc1

Numerous cleanups and several bug fixes.  Here are some highlights:

* Discontiguous directory buffer support
* Inode allocator refactoring
* Removal of the IO lock in inode reclaim
* Implementation of .update_time
* Fix for handling of EOF in xfs_vm_writepage
* Fix for races in xfsaild, and idle mode is re-enabled
* Fix for a crash in xfs_buf completion handlers on unmount.

----------------------------------------------------------------
Alain Renaud (2):
      xfs: xfs_vm_writepage clear iomap_valid when !buffer_uptodate (REV2)
      Prefix IO_XX flags with XFS_IO_XX to avoid namespace colision.

Ben Myers (1):
      xfs: shutdown xfs_sync_worker before the log

Brian Foster (2):
      xfs: check for stale inode before acquiring iflock on push
      xfs: re-enable xfsaild idle mode and fix associated races

Chen Baozi (2):
      xfs: fix typo in comment of xfs_dinode_t.
      xfs: fix comment typo of struct xfs_da_blkinfo.

Christoph Hellwig (17):
      xfs: prevent recursion in xfs_buf_iorequest
      xfs: do not call xfs_bdstrat_cb in xfs_buf_iodone_callbacks
      xfs: implement ->update_time
      xfs: handle EOF correctly in xfs_vm_writepage
      xfs: merge xfs_itobp into xfs_imap_to_bp
      xfs: remove xfs_inotobp
      xfs: remove xfs_ialloc_find_free
      xfs: split xfs_dialloc
      xfs: remove the alloc_done argument to xfs_dialloc
      xfs: add a short cut to xfs_dialloc for the non-NULL agbp case
      xfs: refactor xfs_ialloc_ag_select
      xfs: do not read the AGI buffer in xfs_dialloc until nessecary
      xfs: clean up xfs_inactive
      xfs: remove xfs_inactive_attrs
      xfs: do not take the iolock in xfs_inactive
      xfs: avoid the iolock in xfs_free_eofblocks for evicted inodes
      xfs: remove iolock lock classes

Dave Chinner (15):
      xfs: m_maxioffset is redundant
      xfs: make largest supported offset less shouty
      xfs: kill copy and paste segment checks in xfs_file_aio_read
      xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near
      xfs: struct xfs_buf_log_format isn't variable sized.
      xfs: separate buffer indexing from block map
      xfs: convert internal buffer functions to pass maps
      xfs: add discontiguous buffer map interface
      xfs: add discontiguous buffer support to transactions
      xfs: support discontiguous buffers in the xfs_buf_log_item
      xfs: use discontiguous xfs_buf support in dabuf wrappers
      xfs: remove struct xfs_dabuf and infrastructure
      xfs: factor buffer reading from xfs_dir2_leaf_getdents
      xfs: really fix the cursor leak in xfs_alloc_ag_vextent_near
      xfs: don't defer metadata allocation to the workqueue

Jan Kara (1):
      xfs: Fix overallocation in xfs_buf_allocate_memory()

Jeff Liu (1):
      xfs: fix debug_object WARN at xfs_alloc_vextent()

Mark Tinguely (3):
      xfs: rename log structure to xlog
      xfs: remove xlog_t typedef
      xfs: wait for the write the superblock on unmount

 fs/xfs/xfs_alloc.c       |  20 +-
 fs/xfs/xfs_alloc_btree.h |  14 -
 fs/xfs/xfs_aops.c        |  90 ++++--
 fs/xfs/xfs_aops.h        |  14 +-
 fs/xfs/xfs_attr.c        |  78 +++--
 fs/xfs/xfs_attr_leaf.c   | 255 ++++++++-------
 fs/xfs/xfs_attr_leaf.h   |  21 +-
 fs/xfs/xfs_bmap.c        |   2 +-
 fs/xfs/xfs_buf.c         | 303 +++++++++++------
 fs/xfs/xfs_buf.h         | 117 +++++--
 fs/xfs/xfs_buf_item.c    | 347 ++++++++++++++------
 fs/xfs/xfs_buf_item.h    |  38 +--
 fs/xfs/xfs_da_btree.c    | 823 +++++++++++++++++++----------------------------
 fs/xfs/xfs_da_btree.h    |  38 +--
 fs/xfs/xfs_dinode.h      |   2 +-
 fs/xfs/xfs_dir2.c        |   4 +-
 fs/xfs/xfs_dir2_block.c  | 118 +++----
 fs/xfs/xfs_dir2_data.c   |  50 +--
 fs/xfs/xfs_dir2_leaf.c   | 621 ++++++++++++++++++-----------------
 fs/xfs/xfs_dir2_node.c   | 236 ++++++--------
 fs/xfs/xfs_dir2_priv.h   |  46 +--
 fs/xfs/xfs_dir2_sf.c     |   4 +-
 fs/xfs/xfs_file.c        |  19 +-
 fs/xfs/xfs_ialloc.c      | 446 +++++++++++++------------
 fs/xfs/xfs_ialloc.h      |   2 -
 fs/xfs/xfs_iget.c        |  15 -
 fs/xfs/xfs_inode.c       | 208 ++++--------
 fs/xfs/xfs_inode.h       |  13 +-
 fs/xfs/xfs_inode_item.c  |  17 +-
 fs/xfs/xfs_iomap.c       |   6 +-
 fs/xfs/xfs_iops.c        |  45 +++
 fs/xfs/xfs_itable.c      |   2 +-
 fs/xfs/xfs_log.c         | 296 ++++++++++-------
 fs/xfs/xfs_log_cil.c     |  22 +-
 fs/xfs/xfs_log_priv.h    |  62 ++--
 fs/xfs/xfs_log_recover.c | 180 ++++++-----
 fs/xfs/xfs_mount.c       |  11 +-
 fs/xfs/xfs_mount.h       |   7 +-
 fs/xfs/xfs_qm.c          |   2 +-
 fs/xfs/xfs_super.c       |  88 +----
 fs/xfs/xfs_sync.c        |  45 +--
 fs/xfs/xfs_trace.h       |  20 +-
 fs/xfs/xfs_trans.h       |  50 ++-
 fs/xfs/xfs_trans_ail.c   |  35 +-
 fs/xfs/xfs_trans_buf.c   |  68 ++--
 fs/xfs/xfs_trans_priv.h  |   1 +
 fs/xfs/xfs_types.h       |  14 +
 fs/xfs/xfs_utils.c       |  17 +-
 fs/xfs/xfs_vnodeops.c    | 285 +++++-----------
 49 files changed, 2641 insertions(+), 2576 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
