Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 46F927F80
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 23:05:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9F90AC005
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 21:05:03 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Px8124HgXXXxyJzA for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 21:05:00 -0700 (PDT)
Date: Tue, 30 Jun 2015 14:04:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 4.2-rc1
Message-ID: <20150630040458.GM22807@dastard>
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

Can you please pull the XFS updates from the tag below? There's a
couple of small API changes to the core DAX code which required
small changes to the ext2 and ext4 code bases, but otherwise
everything is within the XFS codebase. See the tag below for more
detail on the individual changes.

-Dave.

The following changes since commit 22419ac9fe5e79483596cebdbd1d1209c18bac1a:

  xfs: fix broken i_nlink accounting for whiteout tmpfile inode (2015-05-29 08:14:55 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-for-linus-4.2-rc1

for you to fetch changes up to de50e16ffabf64d30ca9372f39dc855a7553e305:

  Merge branch 'xfs-misc-fixes-for-4.2-3' into for-next (2015-06-23 08:49:01 +1000)

----------------------------------------------------------------

xfs: update for 4.2-rc1

This update contains:

o A new sparse on-disk inode record format to allow small extents to
  be used for inode allocation when free space is fragmented.
o DAX support. This includes minor changes to the DAX core code to
  fix problems with lock ordering and bufferhead mapping abuse.
o transaction commit interface cleanup
o removal of various unnecessary XFS specific type definitions
o cleanup and optimisation of freelist preparation before allocation
o various minor cleanups
o bug fixes for
	- transaction reservation leaks
	- incorrect inode logging in unwritten extent conversion
	- mmap lock vs freeze ordering
	- remote symlink mishandling
	- attribute fork removal issues.

----------------------------------------------------------------
Brian Foster (23):
      xfs: create individual inode alloc. helper
      xfs: update free inode record logic to support sparse inode records
      xfs: support min/max agbno args in block allocator
      xfs: add sparse inode chunk alignment superblock field
      xfs: use sparse chunk alignment for min. inode allocation requirement
      xfs: sparse inode chunks feature helpers and mount requirements
      xfs: add fs geometry bit for sparse inode chunks
      xfs: introduce inode record hole mask for sparse inode chunks
      xfs: use actual inode count for sparse records in bulkstat/inumbers
      xfs: pass inode count through ordered icreate log item
      xfs: handle sparse inode chunks in icreate log recovery
      xfs: helper to convert holemask to inode alloc. bitmap
      xfs: allocate sparse inode chunks on full chunk allocation failure
      xfs: randomly do sparse inode allocations in DEBUG mode
      xfs: filter out sparse regions from individual inode allocation
      xfs: only free allocated regions of inode chunks
      xfs: skip unallocated regions of inode chunks in xfs_ifree_cluster()
      xfs: enable sparse inode chunks for v5 superblocks
      xfs: always log the inode on unwritten extent conversion
      xfs: fix quota block reservation leak when tp allocates and frees blocks
      xfs: fix sparse inodes 32-bit compile failure
      xfs: check min blks for random debug mode sparse allocations
      xfs: don't truncate attribute extents if no extents exist

Christoph Hellwig (10):
      xfs: switch remaining xfs_trans_dup users to xfs_trans_roll
      xfs: pass a boolean flag to xfs_trans_free_items
      xfs: remove the flags argument to xfs_trans_cancel
      xfs: saner xfs_trans_commit interface
      xfs: fix xfs_log_done interface
      xfs: remove __psint_t and __psunsigned_t
      xfs: remove inst_t
      xfs: return a void pointer from xfs_buf_offset
      xfs: use void pointers in log validation helpers
      xfs: remove xfs_caddr_t

Dave Chinner (19):
      Merge branch 'xfs-misc-fixes-for-4.2' into for-next
      Merge branch 'xfs-sparse-inode' into for-next
      xfs: mmap lock needs to be inside freeze protection
      dax: don't abuse get_block mapping for endio callbacks
      dax: expose __dax_fault for filesystems with locking constraints
      xfs: add DAX file operations support
      xfs: add DAX block zeroing support
      xfs: add DAX truncate support
      xfs: add DAX IO path support
      xfs: add initial DAX support
      Merge branch 'xfs-dax-support' into for-next
      Merge branch 'xfs-misc-fixes-for-4.2-2' into for-next
      Merge branch 'xfs-commit-cleanup' into for-next
      xfs: xfs_alloc_fix_freelist() can use incore perag structures
      xfs: factor out free space extent length check
      xfs: sanitise error handling in xfs_alloc_fix_freelist
      xfs: clean up XFS_MIN_FREELIST macros
      Merge branch 'xfs-freelist-cleanup' into for-next
      Merge branch 'xfs-misc-fixes-for-4.2-3' into for-next

Eric Sandeen (2):
      xfs: don't cast string literals
      xfs: fix remote symlinks on V5/CRC filesystems

Fanael Linithien (1):
      xfs: fix kernel version in docs

Nan Jia (1):
      xfs: Clean up xfs_trans_dup_dqinfo

 Documentation/filesystems/xfs.txt |   12 +-
 fs/dax.c                          |   34 ++-
 fs/ext2/file.c                    |    4 +-
 fs/ext4/file.c                    |   16 +-
 fs/ext4/inode.c                   |   21 +-
 fs/xfs/libxfs/xfs_alloc.c         |  281 +++++++++++--------
 fs/xfs/libxfs/xfs_alloc.h         |   10 +-
 fs/xfs/libxfs/xfs_attr.c          |   25 +-
 fs/xfs/libxfs/xfs_bmap.c          |   29 +-
 fs/xfs/libxfs/xfs_format.h        |   65 +++--
 fs/xfs/libxfs/xfs_fs.h            |    1 +
 fs/xfs/libxfs/xfs_ialloc.c        |  542 +++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_ialloc.h        |   15 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c  |   93 ++++++-
 fs/xfs/libxfs/xfs_ialloc_btree.h  |   10 +
 fs/xfs/libxfs/xfs_inode_buf.c     |    8 +-
 fs/xfs/libxfs/xfs_sb.c            |   34 ++-
 fs/xfs/libxfs/xfs_shared.h        |    6 -
 fs/xfs/libxfs/xfs_trans_resv.h    |    4 +-
 fs/xfs/libxfs/xfs_trans_space.h   |    2 +-
 fs/xfs/xfs_aops.c                 |  158 ++++++++---
 fs/xfs/xfs_aops.h                 |    7 +-
 fs/xfs/xfs_attr_inactive.c        |   16 +-
 fs/xfs/xfs_bmap_util.c            |   89 +++---
 fs/xfs/xfs_buf.c                  |    6 +-
 fs/xfs/xfs_buf.h                  |    2 +-
 fs/xfs/xfs_dquot.c                |    8 +-
 fs/xfs/xfs_error.c                |    4 +-
 fs/xfs/xfs_error.h                |    4 +-
 fs/xfs/xfs_extfree_item.c         |    2 +-
 fs/xfs/xfs_file.c                 |  166 +++++++-----
 fs/xfs/xfs_filestream.c           |    3 +-
 fs/xfs/xfs_fsops.c                |   10 +-
 fs/xfs/xfs_inode.c                |  204 +++++---------
 fs/xfs/xfs_ioctl.c                |   14 +-
 fs/xfs/xfs_iomap.c                |   18 +-
 fs/xfs/xfs_iops.c                 |   48 ++--
 fs/xfs/xfs_itable.c               |   13 +-
 fs/xfs/xfs_linux.h                |   14 -
 fs/xfs/xfs_log.c                  |   51 ++--
 fs/xfs/xfs_log.h                  |   13 +-
 fs/xfs/xfs_log_cil.c              |   12 +-
 fs/xfs/xfs_log_priv.h             |    2 +-
 fs/xfs/xfs_log_recover.c          |   97 ++++---
 fs/xfs/xfs_mount.c                |   16 ++
 fs/xfs/xfs_mount.h                |    4 +
 fs/xfs/xfs_pnfs.c                 |    4 +-
 fs/xfs/xfs_qm.c                   |    7 +-
 fs/xfs/xfs_qm_syscalls.c          |   20 +-
 fs/xfs/xfs_quota.h                |    1 -
 fs/xfs/xfs_rtalloc.c              |   16 +-
 fs/xfs/xfs_super.c                |   25 +-
 fs/xfs/xfs_symlink.c              |   19 +-
 fs/xfs/xfs_trace.h                |   47 ++++
 fs/xfs/xfs_trans.c                |   91 +++----
 fs/xfs/xfs_trans.h                |    7 +-
 fs/xfs/xfs_trans_ail.c            |    6 +-
 fs/xfs/xfs_trans_dquot.c          |   32 ++-
 fs/xfs/xfs_trans_priv.h           |    2 +-
 include/linux/fs.h                |    9 +-
 60 files changed, 1611 insertions(+), 868 deletions(-)

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
