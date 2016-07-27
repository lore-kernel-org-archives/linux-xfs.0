Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B79F87CA0
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2016 21:12:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F28F8F8037
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2016 19:12:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	fQi4vGTqy567vOqV for <xfs@oss.sgi.com>;
	Tue, 26 Jul 2016 19:12:33 -0700 (PDT)
Date: Wed, 27 Jul 2016 12:08:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: update for 4.8-rc1
Message-ID: <20160727020841.GH12670@dastard>
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

Can you please pull the XFS update from the tag below? You will get
a merge conflict against fs/xfs/xfs_ioctl.c - I committed "xfs: fix
type confusion in xfs_ioc_swapext" with an additional comment to
explain why such a unique test was being done in the ioctl code.

As for the rest of the changes, the major addition is the new iomap
based block mapping infrastructure. We've been kicking this about
locally for years, but there are other filesystems want to use it
too (e.g.  gfs2). Now it is fully working, reviewed and ready for
merge and be used by other filesystems.  There are a lot of other
fixes and cleanups in the tree, but those are XFS internal things
and none are of the scale or visibility of the iomap changes. See
the tag description below for details.

I am likely to send another pull request next week - we're ijust
about ready to merge some new functionality (on disk block->owner
reverse mapping infrastructure), but that's a huge chunk of code (74
files changed, 7283 insertions(+), 1114 deletions(-)) so I'm keeping
that separate to all the "normal" pull request changes so they don't
get lost in the noise.

-Dave.

The following changes since commit 1a695a905c18548062509178b98bc91e67510864:

  Linux 4.7-rc1 (2016-05-29 09:29:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.8-rc1

for you to fetch changes up to f2bdfda9a1c668539bc85baf5625f6f14bc510b1:

  Merge branch 'xfs-4.8-misc-fixes-4' into for-next (2016-07-22 14:10:56 +1000)

----------------------------------------------------------------
xfs: update for 4.8-rc1

Changes in this update:
o generic iomap based IO path infrastructure
o generic iomap based fiemap implementation
o xfs iomap based Io path implementation
o buffer error handling fixes
o tracking of in flight buffer IO for unmount serialisation
o direct IO and DAX io path separation and simplification
o shortform directory format definition changes for wider platform compatibility
o various buffer cache fixes
o cleanups in preparation for rmap merge
o error injection cleanups and fixes
o log item format buffer memory allocation restructuring to prevent rare OOM
  reclaim deadlocks
o sparse inode chunks are now fully supported.

----------------------------------------------------------------
Arnd Bergmann (1):
      xfs: remove dax code from object file when disabled

Brian Foster (7):
      xfs: fix broken multi-fsb buffer logging
      xfs: remove spurious shutdown type check from xfs_bmap_finish()
      xfs: cancel eofblocks background trimming on remount read-only
      xfs: refactor xfs_reserve_blocks() to handle ENOSPC correctly
      xfs: exclude never-released buffers from buftarg I/O accounting
      xfs: track and serialize in-flight async buffers against unmount
      xfs: skip dirty pages in ->releasepage()

Christoph Hellwig (25):
      xfs: define XFS_IOC_FREEZE even if FIFREEZE is defined
      fs: move struct iomap from exportfs.h to a separate header
      fs: introduce iomap infrastructure
      fs: support DAX based iomap zeroing
      fs: iomap based fiemap implementation
      xfs: make xfs_bmbt_to_iomap available outside of xfs_pnfs.c
      xfs: reorder zeroing and flushing sequence in truncate
      xfs: implement iomap based buffered write path
      xfs: remove buffered write support from __xfs_get_blocks
      xfs: use iomap fiemap implementation
      xfs: use iomap infrastructure for DAX zeroing
      xfs: handle 64-bit length in xfs_iozero
      xfs: use xfs_zero_range in xfs_zero_eof
      xfs: split xfs_free_file_space in manageable pieces
      xfs: kill xfs_zero_remaining_bytes
      xfs: don't pass ioflags around in the ioctl path
      xfs: kill ioflags
      xfs: remove s_maxbytes enforcement in xfs_file_read_iter
      xfs: split xfs_file_read_iter into buffered and direct I/O helpers
      xfs: stop using generic_file_read_iter for direct I/O
      xfs: direct calls in the direct I/O path
      xfs: split direct I/O and DAX path
      xfs: kill xfs_dir2_sf_off_t
      xfs: kill xfs_dir2_inou_t
      xfs: remove __arch_pack

Dan Carpenter (1):
      xfs: don't allow negative error tags

Darrick J. Wong (6):
      xfs: check offsets of variable length structures
      xfs: enable buffer deadlock postmortem diagnosis via ftrace
      xfs: check for a valid error_tag in errortag_add
      xfs: rearrange xfs_bmap_add_free parameters
      xfs: convert list of extents to free into a regular list
      xfs: refactor btree maxlevels computation

Dave Chinner (14):
      xfs: reduce lock hold times in buffer writeback
      Merge branch 'fs-4.8-iomap-infrastructure' into for-next
      Merge branch 'xfs-4.8-iomap-write' into for-next
      xfs: separate freelist fixing into a separate helper
      Merge branch 'xfs-4.8-misc-fixes-2' into for-next
      Merge branch 'xfs-4.8-misc-fixes-3' into for-next
      Merge branch 'xfs-4.8-buf-fixes' into for-next
      Merge branch 'xfs-4.8-split-dax-dio' into for-next
      Merge branch 'xfs-4.8-dir2-sf-fixes' into for-next
      libxfs: directory node splitting does not have an extra block
      xfs: allocate log vector buffers outside CIL context lock
      xfs: bufferhead chains are invalid after end_page_writeback
      xfs: remove EXPERIMENTAL tag from sparse inode feature
      Merge branch 'xfs-4.8-misc-fixes-4' into for-next

Eric Sandeen (4):
      xfs: make several functions static
      xfs: fix xfs_error_get_cfg for negative errnos
      xfs: remove extraneous buffer flag changes
      xfs: don't reset b_retries to 0 on every failure

Hou Tao (1):
      xfs: remove the magic numbers in xfs_btree_block-related len macros

Jann Horn (1):
      xfs: fix type confusion in xfs_ioc_swapext

Kaho Ng (1):
      xfs: indentation fix in xfs_btree_get_iroot()

 fs/Kconfig                     |   3 +
 fs/Makefile                    |   1 +
 fs/buffer.c                    |  76 ++++++-
 fs/internal.h                  |   3 +
 fs/iomap.c                     | 497 +++++++++++++++++++++++++++++++++++++++++
 fs/nfsd/blocklayout.c          |   1 +
 fs/nfsd/blocklayoutxdr.c       |   1 +
 fs/xfs/Kconfig                 |   1 +
 fs/xfs/libxfs/xfs_alloc.c      | 101 +++++----
 fs/xfs/libxfs/xfs_alloc.h      |   9 +-
 fs/xfs/libxfs/xfs_attr_leaf.h  |   3 -
 fs/xfs/libxfs/xfs_bmap.c       |  51 ++---
 fs/xfs/libxfs/xfs_bmap.h       |  18 +-
 fs/xfs/libxfs/xfs_bmap_btree.c |   2 +-
 fs/xfs/libxfs/xfs_btree.c      |  27 ++-
 fs/xfs/libxfs/xfs_btree.h      |   2 +
 fs/xfs/libxfs/xfs_da_btree.c   |  59 +++--
 fs/xfs/libxfs/xfs_da_format.c  |  31 ++-
 fs/xfs/libxfs/xfs_da_format.h  |  43 +---
 fs/xfs/libxfs/xfs_dir2_sf.c    |  38 +---
 fs/xfs/libxfs/xfs_format.h     |  66 +++---
 fs/xfs/libxfs/xfs_fs.h         |   8 +-
 fs/xfs/libxfs/xfs_ialloc.c     |  28 +--
 fs/xfs/libxfs/xfs_rtbitmap.c   |   2 +-
 fs/xfs/xfs_aops.c              | 332 ++++-----------------------
 fs/xfs/xfs_aops.h              |   3 +
 fs/xfs/xfs_attr_inactive.c     |   2 +-
 fs/xfs/xfs_attr_list.c         |   2 +-
 fs/xfs/xfs_bmap_util.c         | 381 +++++++++++++------------------
 fs/xfs/xfs_bmap_util.h         |   3 -
 fs/xfs/xfs_buf.c               | 236 +++++++++++++------
 fs/xfs/xfs_buf.h               |   7 +-
 fs/xfs/xfs_buf_item.c          |  31 ++-
 fs/xfs/xfs_dquot.c             |   1 +
 fs/xfs/xfs_dquot_item.c        |   2 +
 fs/xfs/xfs_error.c             |   5 +-
 fs/xfs/xfs_error.h             |   2 +-
 fs/xfs/xfs_extfree_item.c      |   2 +
 fs/xfs/xfs_file.c              | 425 ++++++++++++++++-------------------
 fs/xfs/xfs_fsops.c             | 105 +++++----
 fs/xfs/xfs_icache.c            |   2 +-
 fs/xfs/xfs_icache.h            |   1 +
 fs/xfs/xfs_inode.c             |  16 +-
 fs/xfs/xfs_inode.h             |  20 +-
 fs/xfs/xfs_inode_item.c        |   1 +
 fs/xfs/xfs_ioctl.c             |  33 +--
 fs/xfs/xfs_ioctl.h             |   3 -
 fs/xfs/xfs_ioctl32.c           |   6 +-
 fs/xfs/xfs_iomap.c             | 171 ++++++++++++++
 fs/xfs/xfs_iomap.h             |   7 +
 fs/xfs/xfs_iops.c              | 113 ++--------
 fs/xfs/xfs_linux.h             |   7 -
 fs/xfs/xfs_log.c               |  13 +-
 fs/xfs/xfs_log.h               |   5 -
 fs/xfs/xfs_log_cil.c           | 258 +++++++++++++++------
 fs/xfs/xfs_mount.c             |  10 +-
 fs/xfs/xfs_ondisk.h            |  31 ++-
 fs/xfs/xfs_pnfs.c              |  27 +--
 fs/xfs/xfs_rtalloc.h           |   2 -
 fs/xfs/xfs_super.c             |  19 +-
 fs/xfs/xfs_super.h             |   2 -
 fs/xfs/xfs_sysfs.c             |   3 +
 fs/xfs/xfs_trace.h             |  25 ++-
 fs/xfs/xfs_trans.h             |   1 +
 include/linux/exportfs.h       |  16 +-
 include/linux/iomap.h          |  70 ++++++
 66 files changed, 2032 insertions(+), 1440 deletions(-)
 create mode 100644 fs/iomap.c
 create mode 100644 include/linux/iomap.h
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
