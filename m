Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26454 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753496AbdEFQ33 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 May 2017 12:29:29 -0400
Date: Sat, 6 May 2017 09:28:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] xfs: updates for 4.12
Message-ID: <20170506162809.GI5973@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>

Hi Linus,

Here are the XFS changes for 4.12.  The big new feature for this release
is the new space mapping ioctl that we've been discussing since LSF2016,
but other than that most of the patches are larger bug fixes, memory
corruption prevention, and other cleanups.  I tried a test merge against
HEAD about 15 minutes ago and it committed cleanly, so I don't
anticipate any problems.  Let me know if you encounter any problems.

--Darrick

The following changes since commit c02ed2e75ef4c74e41e421acb4ef1494671585e8:

  Linux 4.11-rc4 (2017-03-26 14:15:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.12-merge-7

for you to fetch changes up to 161f55efba5ddccc690139fae9373cafc3447a97:

  xfs: fix use-after-free in xfs_finish_page_writeback (2017-05-05 12:16:48 -0700)

----------------------------------------------------------------
Changes for 4.12:
- various code cleanups
- introduce GETFSMAP ioctl
- various refactoring
- avoid dio reads past eof
- fix memory corruption and other errors with fragmented directory blocks
- fix accidental userspace memory corruptions
- publish fs uuid in superblock
- make fstrim terminatable
- fix race between quotaoff and in-core inode creation
- Avoid use-after-free when finishing up w/ buffer heads
- Reserve enough space to handle bmap tree resizing during cow remap

----------------------------------------------------------------
Amir Goldstein (1):
      xfs: publish UUID in struct super_block

Brian Foster (7):
      xfs: use dedicated log worker wq to avoid deadlock with cil wq
      xfs: drop iolock from reclaim context to appease lockdep
      xfs: prevent multi-fsb dir readahead from reading random blocks
      xfs: fix up quotacheck buffer list error handling
      xfs: support ability to wait on new inodes
      xfs: update ag iterator to support wait on new inodes
      xfs: wait on new inodes during quotaoff dquot release

Calvin Owens (1):
      xfs: Honor FALLOC_FL_KEEP_SIZE when punching ends of files

Chandan Rajendra (1):
      iomap_dio_rw: Prevent reading file data beyond iomap_dio->i_size

Christoph Hellwig (18):
      xfs: factor out a xfs_bmap_is_real_extent helper
      xfs: remove the ISUNWRITTEN macro
      xfs: fold __xfs_trans_roll into xfs_trans_roll
      xfs: fix integer truncation in xfs_bmap_remap_alloc
      xfs: remove attr fork handling in xfs_bmap_finish_one
      xfs: pass individual arguments to xfs_bmap_add_extent_hole_real
      xfs: introduce xfs_bmapi_remap
      xfs: remove xfs_bmap_remap_alloc
      xfs: remove bmap block allocation retries
      xfs: remove the unused XFS_MAXLINK_1 define
      xfs: remove unused values from xfs_exntst_t
      xfs: simplify validation of the unwritten extent bit
      xfs: use NULL instead of 0 to initialize a pointer in xfs_getfsmap
      xfs: use NULL instead of 0 to initialize a pointer in xfs_ioc_getfsmap
      xfs: corruption needs to respect endianess too!
      xfs: fix __user annotations for xfs_ioc_getfsmap
      xfs: don't use bool values in trace buffers
      xfs: remove xfs_trans_ail_delete_bulk

Darrick J. Wong (15):
      xfs: rework the inline directory verifiers
      xfs: fix kernel memory exposure problems
      xfs: fix over-copying of getbmap parameters from userspace
      vfs: add common GETFSMAP ioctl definitions
      xfs: plumb in needed functions for range querying of the freespace btrees
      xfs: provide a query_range function for freespace btrees
      xfs: create a function to query all records in a btree
      xfs: add a couple of queries to iterate free extents in the rtbitmap
      xfs: implement the GETFSMAP ioctl
      xfs: have getfsmap fall back to the freesp btrees when rmap is not present
      xfs: report realtime space information via the rtbitmap
      xfs: actually report xattr extents via iomap
      xfs: fix getfsmap userspace memory corruption while setting OF_LAST
      xfs: better log intent item refcount checking
      xfs: reserve enough blocks to handle btree splits when remapping

Eric Sandeen (6):
      xfs: fix up inode validation failure message
      xfs: simplify xfs_calc_dquots_per_chunk
      xfs: remove custom do_div implementations
      xfs: handle array index overrun in xfs_dir2_leaf_readbuf()
      xfs: remove use of do_div with 32-bit dividend in quota
      xfs: more do_div cleanups

Eryu Guan (1):
      xfs: fix use-after-free in xfs_finish_page_writeback

Hou Tao (1):
      xfs: remove the trailing newline used in the fmt parameter of TP_printk

Lukas Czerner (1):
      xfs: Allow user to kill fstrim process

Nikolay Borisov (1):
      xfs: Remove obsolete declaration of xfs_buf_get_empty

 fs/iomap.c                      |   3 +
 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_alloc.c       |  57 +++
 fs/xfs/libxfs/xfs_alloc.h       |  12 +
 fs/xfs/libxfs/xfs_alloc_btree.c | 172 ++++++--
 fs/xfs/libxfs/xfs_bmap.c        | 354 +++++++--------
 fs/xfs/libxfs/xfs_bmap.h        |  14 +-
 fs/xfs/libxfs/xfs_bmap_btree.c  |  43 --
 fs/xfs/libxfs/xfs_bmap_btree.h  |  22 +-
 fs/xfs/libxfs/xfs_btree.c       |  15 +
 fs/xfs/libxfs/xfs_btree.h       |   2 +
 fs/xfs/libxfs/xfs_dir2_priv.h   |   3 +-
 fs/xfs/libxfs/xfs_dir2_sf.c     |  63 ++-
 fs/xfs/libxfs/xfs_dquot_buf.c   |   7 +-
 fs/xfs/libxfs/xfs_format.h      |  11 -
 fs/xfs/libxfs/xfs_fs.h          |  13 +
 fs/xfs/libxfs/xfs_inode_buf.c   |   2 +-
 fs/xfs/libxfs/xfs_inode_fork.c  | 125 ++----
 fs/xfs/libxfs/xfs_inode_fork.h  |   2 +-
 fs/xfs/libxfs/xfs_rmap.c        |  56 ++-
 fs/xfs/libxfs/xfs_rmap.h        |   4 +
 fs/xfs/libxfs/xfs_rtbitmap.c    |  70 +++
 fs/xfs/libxfs/xfs_trans_space.h |  23 +-
 fs/xfs/xfs_aops.c               |  12 +-
 fs/xfs/xfs_bmap_item.c          |   6 +-
 fs/xfs/xfs_bmap_util.c          |  30 +-
 fs/xfs/xfs_buf.c                |  24 +
 fs/xfs/xfs_buf.h                |   2 +-
 fs/xfs/xfs_dir2_readdir.c       |  15 +-
 fs/xfs/xfs_discard.c            |  10 +-
 fs/xfs/xfs_extfree_item.c       |   1 +
 fs/xfs/xfs_fsmap.c              | 940 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsmap.h              |  53 +++
 fs/xfs/xfs_icache.c             |  58 ++-
 fs/xfs/xfs_icache.h             |   8 +
 fs/xfs/xfs_inode.c              |  28 +-
 fs/xfs/xfs_inode.h              |   4 +-
 fs/xfs/xfs_inode_item.c         |  29 +-
 fs/xfs/xfs_ioctl.c              |  89 +++-
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iomap.c              |   8 +-
 fs/xfs/xfs_itable.c             |   2 +-
 fs/xfs/xfs_linux.h              |  85 ----
 fs/xfs/xfs_log.c                |   4 +-
 fs/xfs/xfs_mount.c              |   4 +
 fs/xfs/xfs_mount.h              |   5 +-
 fs/xfs/xfs_qm.c                 |  11 +-
 fs/xfs/xfs_qm_syscalls.c        |   3 +-
 fs/xfs/xfs_refcount_item.c      |   1 +
 fs/xfs/xfs_reflink.c            |  39 +-
 fs/xfs/xfs_rmap_item.c          |   1 +
 fs/xfs/xfs_rtalloc.h            |  22 +-
 fs/xfs/xfs_super.c              |   8 +
 fs/xfs/xfs_trace.c              |   1 +
 fs/xfs/xfs_trace.h              | 144 ++++--
 fs/xfs/xfs_trans.c              |  39 +-
 fs/xfs/xfs_trans.h              |   3 +-
 fs/xfs/xfs_trans_ail.c          |  71 ++-
 fs/xfs/xfs_trans_priv.h         |  15 +-
 include/uapi/linux/fsmap.h      | 112 +++++
 60 files changed, 2238 insertions(+), 725 deletions(-)
 create mode 100644 fs/xfs/xfs_fsmap.c
 create mode 100644 fs/xfs/xfs_fsmap.h
 create mode 100644 include/uapi/linux/fsmap.h
