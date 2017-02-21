Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752000AbdBUVsf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Feb 2017 16:48:35 -0500
Date: Tue, 21 Feb 2017 13:48:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: updates for 4.11
Message-ID: <20170221214829.GA14802@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>

Hi Linus,

Here are the XFS changes for 4.11.  We aren't introducing any major
features in this release cycle except for this being the first merge
window I've managed on my own. :)

FYI, linux-next alerted me there might be some slight merge conflicts
between the "constify struct iomaps" patch and some of the dax & iomap
patches in akpm-current.  I just tried a test merge against your HEAD
(b8989bccd) that went cleanly, so I don't anticipate any problems.
However, if you encounter trouble with the merge, I'm happy to sort it
out and try again.

--Darrick

The following changes since commit 566cf877a1fcb6d6dc0126b076aad062054c2637:

  Linux 4.10-rc6 (2017-01-29 14:25:17 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.11-merge-7

for you to fetch changes up to 8d242e932fb7660c24b3a534197e69c241067e0d:

  xfs: remove XFS_ALLOCTYPE_ANY_AG and XFS_ALLOCTYPE_START_AG (2017-02-17 20:32:10 -0800)

----------------------------------------------------------------
Changes since last update:
 - Various cleanups
 - Livelock fixes for eofblocks scanning
 - Improved input verification for on-disk metadata
 - Fix races in the copy on write remap mechanism
 - Fix buffer io error timeout controls
 - Streamlining of directio copy on write
 - Asynchronous discard support
 - Fix asserts when splitting delalloc reservations
 - Don't bloat bmbt when right shifting extents
 - Inode alignment fixes for 32k block sizes

----------------------------------------------------------------
Arnd Bergmann (1):
      xfs: fix len comparison in xfs_extent_busy_trim

Bill O'Donnell (1):
      xfs: correct null checks and error processing in xfs_initialize_perag

Brian Foster (8):
      xfs: pull up iolock from xfs_free_eofblocks()
      xfs: sync eofblocks scans under iolock are livelock prone
      xfs: fix eofblocks race with file extending async dio writes
      xfs: clear delalloc and cache on buffered write failure
      xfs: resurrect debug mode drop buffered writes mechanism
      xfs: handle indlen shortage on delalloc extent merge
      xfs: split indlen reservations fairly when under reserved
      xfs: don't reserve blocks for right shift transactions

Chandan Rajendra (1):
      xfs: Use xfs_icluster_size_fsb() to calculate inode chunk alignment

Christoph Hellwig (14):
      iomap: constify struct iomap_ops
      xfs: reject all unaligned direct writes to reflinked files
      xfs: introduce xfs_aligned_fsb_count
      xfs: return the converted extent in __xfs_reflink_convert_cow
      xfs: go straight to real allocations for direct I/O COW writes
      xfs: allocate direct I/O COW blocks in iomap_begin
      xfs: update ctime and mtime on clone destinatation inodes
      xfs: don't fail xfs_extent_busy allocation
      xfs: improve handling of busy extents in the low-level allocator
      xfs: improve busy extent sorting
      xfs: don't block the log commit handler for discards
      xfs: tune down agno asserts in the bmap code
      xfs: simplify xfs_rtallocate_extent
      xfs: remove XFS_ALLOCTYPE_ANY_AG and XFS_ALLOCTYPE_START_AG

Darrick J. Wong (8):
      xfs: fix toctou race when locking an inode to access the data map
      xfs: fail _dir_open when readahead fails
      xfs: filter out obviously bad btree pointers
      xfs: check for obviously bad level values in the bmbt root
      xfs: verify free block header fields
      xfs: allow unwritten extents in the CoW fork
      xfs: mark speculative prealloc CoW fork extents unwritten
      xfs: fix uninitialized variable in _reflink_convert_cow

Eric Sandeen (5):
      xfs: glean crc status from mp not flags in xfs_btree_init_block_int
      xfs: make xfs_btree_magic more generic
      xfs: remove boilerplate around xfs_btree_init_block
      xfs: remove unused struct declarations
      xfs: remove unused full argument from bmap

Hou Tao (1):
      xfs: reset b_first_retry_time when clear the retry status of xfs_buf_t

 fs/dax.c                        |   6 +-
 fs/ext2/ext2.h                  |   2 +-
 fs/ext2/inode.c                 |   4 +-
 fs/ext4/ext4.h                  |   2 +-
 fs/ext4/inode.c                 |   2 +-
 fs/internal.h                   |   2 +-
 fs/iomap.c                      |  18 +--
 fs/xfs/libxfs/xfs_alloc.c       | 109 ++++++++---------
 fs/xfs/libxfs/xfs_alloc.h       |   4 -
 fs/xfs/libxfs/xfs_bmap.c        | 199 +++++++++++++++++-------------
 fs/xfs/libxfs/xfs_bmap_btree.c  |  10 +-
 fs/xfs/libxfs/xfs_btree.c       |  48 +++++---
 fs/xfs/libxfs/xfs_btree.h       |   8 +-
 fs/xfs/libxfs/xfs_da_btree.c    |   6 +-
 fs/xfs/libxfs/xfs_da_btree.h    |   2 +-
 fs/xfs/libxfs/xfs_dir2_node.c   |  51 +++++++-
 fs/xfs/libxfs/xfs_ialloc.c      |   3 +-
 fs/xfs/libxfs/xfs_inode_fork.c  |   9 +-
 fs/xfs/libxfs/xfs_log_recover.h |   1 -
 fs/xfs/xfs_aops.c               |   6 +
 fs/xfs/xfs_bmap_util.c          |  81 ++++++------
 fs/xfs/xfs_bmap_util.h          |   5 +-
 fs/xfs/xfs_buf_item.c           |   1 +
 fs/xfs/xfs_discard.c            |  29 -----
 fs/xfs/xfs_discard.h            |   1 -
 fs/xfs/xfs_extent_busy.c        | 156 ++++++++++++++++-------
 fs/xfs/xfs_extent_busy.h        |  11 +-
 fs/xfs/xfs_file.c               |  34 +++---
 fs/xfs/xfs_fsops.c              |  39 ++----
 fs/xfs/xfs_icache.c             |  59 +++------
 fs/xfs/xfs_icache.h             |   2 -
 fs/xfs/xfs_inode.c              |  51 ++++----
 fs/xfs/xfs_ioctl.c              |   4 +-
 fs/xfs/xfs_iomap.c              |  75 +++++-------
 fs/xfs/xfs_iomap.h              |  24 +++-
 fs/xfs/xfs_log.h                |   1 -
 fs/xfs/xfs_log_cil.c            |  84 +++++++++++--
 fs/xfs/xfs_log_priv.h           |   1 +
 fs/xfs/xfs_mount.c              |  33 +++--
 fs/xfs/xfs_mount.h              |  17 +--
 fs/xfs/xfs_reflink.c            | 265 ++++++++++++++++++++++++++++------------
 fs/xfs/xfs_reflink.h            |   6 +-
 fs/xfs/xfs_rtalloc.c            |  24 ++--
 fs/xfs/xfs_rtalloc.h            |   3 +-
 fs/xfs/xfs_super.c              |   8 ++
 fs/xfs/xfs_super.h              |   2 +
 fs/xfs/xfs_sysfs.c              |  14 +--
 fs/xfs/xfs_trace.h              |  13 +-
 fs/xfs/xfs_trans.h              |   1 -
 include/linux/dax.h             |   8 +-
 include/linux/iomap.h           |  14 +--
 51 files changed, 920 insertions(+), 638 deletions(-)
