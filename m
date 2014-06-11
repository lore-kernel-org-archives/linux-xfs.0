Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A7B4A7F62
	for <xfs@oss.sgi.com>; Wed, 11 Jun 2014 00:31:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 633D98F8040
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 22:31:22 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	5GlXVn9DOWJypAew for <xfs@oss.sgi.com>;
	Tue, 10 Jun 2014 22:31:15 -0700 (PDT)
Date: Wed, 11 Jun 2014 15:30:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 3.16-rc1
Message-ID: <20140611053043.GK9508@dastard>
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

Can you please pull the changes from the tree below. Lots of changes
all over the place in XFS, the main addition is a new on-disk btree
for tracking free inodes and the associated optimised allocator
rework to make use of it. Most of the rest of the changes are
cleanups or reworking of existing functionality, as well as various
bug fixes.

-Dave.

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-3.16-rc1

for you to fetch changes up to 7691283d0561a350b7517be94818669fb5e3d910:

  Merge branch 'xfs-misc-fixes-3-for-3.16' into for-next (2014-06-10 07:32:56 +1000)

----------------------------------------------------------------

xfs: update for 3.16-rc1

This update contains:
o cleanup removing unused function args
o rework of the filestreams allocator to use dentry cache parent lookups
o new on-disk free inode btree and optimised inode allocator
o various bug fixes
o rework of internal attribute API
o cleanup of superblock feature bit support to remove historic cruft
o more fixes and minor cleanups
o added a new directory/attribute geometry abstraction
o yet more fixes and minor cleanups.

----------------------------------------------------------------
Brian Foster (11):
      xfs: refactor xfs_ialloc_btree.c to support multiple inobt numbers
      xfs: reserve v5 superblock read-only compat. feature bit for finobt
      xfs: support the XFS_BTNUM_FINOBT free inode btree type
      xfs: update inode allocation/free transaction reservations for finobt
      xfs: insert newly allocated inode chunks into the finobt
      xfs: use and update the finobt on inode allocation
      xfs: refactor xfs_difree() inobt bits into xfs_difree_inobt() helper
      xfs: update the finobt on inode free
      xfs: add finobt support to growfs
      xfs: report finobt status in fs geometry
      xfs: enable the finobt feature on v5 superblocks

Christoph Hellwig (15):
      xfs: don't try to use the filestream allocator for metadata allocations
      xfs: split xfs_bmap_btalloc_nullfb
      xfs: handle duplicate entries in xfs_mru_cache_insert
      xfs: embedd mru_elem into parent structure
      xfs: remove XFS_IFILESTREAM
      xfs: rewrite the filestream allocator using the dentry cache
      xfs: don't create a slab cache for filestream items
      xfs: remove xfs_filestream_associate
      xfs: add filestream allocator tracepoints
      xfs: fold xfs_attr_set_int into xfs_attr_set
      xfs: fold xfs_attr_get_int into xfs_attr_get
      xfs: fold xfs_attr_remove_int into xfs_attr_remove
      xfs: simplify attr name setup
      xfs: pass struct da_args to xfs_attr_calc_size
      xfs: tone down writepage/releasepage WARN_ONs

Dan Carpenter (1):
      xfs: small cleanup in xfs_lowbit64()

Dave Chinner (50):
      xfs: remove dquot hints
      xfs: truncate_setsize should be outside transactions
      xfs: don't sleep in xlog_cil_force_lsn on shutdown
      xfs: fix directory readahead offset off-by-one
      xfs: xfs_dir_fsync() returns positive errno
      xfs: fix incorrect error sign in xfs_file_aio_read
      xfs: xfs_commit_metadata returns wrong errno
      xfs: correct error sign on COLLAPSE_RANGE errors
      xfs: fix wrong errno from xfs_initxattrs
      xfs: fix wrong err sign on xfs_set_acl()
      xfs: negate mount workqueue init error value
      xfs: negate xfs_icsb_init_counters error value
      xfs: list_lru_init returns a negative error
      Merge branch 'xfs-unused-args-cleanup' into for-next
      Merge branch 'xfs-filestreams-lookup' into for-next
      Merge branch 'xfs-free-inode-btree' into for-next
      Merge branch 'xfs-misc-fixes-1-for-3.16' into for-next
      Merge branch 'xfs-attr-cleanup' into for-next
      xfs: make superblock version checks reflect reality
      xfs: keep sb_bad_features2 the same a sb_features2
      xfs: turn NLINK feature on by default
      xfs: don't need dirv2 checks anymore
      xfs: remove shared supberlock feature checking
      xfs: log vector rounding leaks log space
      xfs: remove redundant checks from xfs_da_read_buf
      Merge branch 'xfs-misc-fixes-2-for-3.16' into for-next
      Merge branch 'xfs-feature-bit-cleanup' into for-next
      xfs: introduce directory geometry structure
      xfs: move directory block translatiosn to xfs_dir2_priv.h
      xfs: kill XFS_DIR2...FIRSTDB macros
      xfs: convert dir byte/off conversion to xfs_da_geometry
      xfs: convert directory dablk conversion to xfs_da_geometry
      xfs: convert directory db conversion to xfs_da_geometry
      xfs: convert directory segment limits to xfs_da_geometry
      xfs: convert m_dirblkfsbs to xfs_da_geometry
      xfs: convert m_dirblksize to xfs_da_geometry
      xfs: convert dir/attr btree threshold to xfs_da_geometry
      xfs: move node entry counts to xfs_da_geometry
      xfs: reduce direct usage of mp->m_dir_geo
      xfs: remove mp->m_dir_geo from directory logging
      xfs: use xfs_da_geometry for block size in attr code
      xfs: pass xfs_da_args to xfs_attr_leaf_newentsize
      xfs: replace attr LBSIZE with xfs_da_geometry
      xfs: remove redundant geometry information from xfs_da_state
      xfs: block allocation work needs to be kswapd aware
      xfs: xfs_readsb needs to check for magic numbers
      xfs: kill xfs_buf_geterror()
      xfs: fix xfs_da_args sparse warning in xfs_readdir
      Merge branch 'xfs-da-geom' into for-next
      Merge branch 'xfs-misc-fixes-3-for-3.16' into for-next

Eric Sandeen (22):
      xfs: remove unused tp arg from xfs_bmap_last_offset() and callers
      xfs: remove unused mp arg from xfs_attr3_rmt_hdr_ok()
      xfs: remove unused mp arg from xfs_bmdr_maxrecs()
      xfs: remove unused mp arg from xfs_bmap_forkoff_reset()
      xfs: remove unused level arg from xfs_btree_read_buf_block()
      xfs: remove unused blocksize arg from xfs_setsize_buftarg()
      xfs: remove unused args from xfs_alloc_buftarg()
      xfs: remove unused flags arg from _xfs_buf_get_pages()
      xfs: remove unused bip arg from xfs_buf_item_log_segment()
      xfs: remove unused tp arg from xfs_da_reada_buf & callers
      xfs: remove unused mp arg from xfs_dir2 dataptr/byte functions
      xfs: remove unused mp arg from xfs_calc_dquots_per_chunk()
      xfs: remove unused length arg from alloc_block ops
      xfs: remove unused pag ptr arg from iterator execute functions
      xfs: remove unused bp arg from xfs_iflush_fork()
      xfs: remove unused xfs_mount arg from xfs_symlink_hdr_ok()
      xfs: remove unused ail pointer arg from xfs_trans_ail_cursor_done()
      xfs: remove unused trans pointer arg from xlog_recover_unmount_trans()
      xfs: remove pointless pointer increment in xfs_dir2_block_compact()
      xfs: remove unused calculation in xfs_dir2_sf_addname()
      xfs: fix Q_XQUOTARM ioctl
      xfs: bulletfproof xfs_qm_scall_trunc_qfiles()

Tuomas Tynkkynen (1):
      xfs: Fix wrong error codes being returned

Jan Kara (1):
      xfs: Fix rounding in xfs_alloc_fix_len()

Jie Liu (1):
      xfs: fix infinite loop at xfs_vm_writepage on 32bit system

Namjae Jeon (1):
      xfs: remove XFS_TRANS_RESERVE in collapse range

Roger Willcocks (1):
      xfs: fix compile error when libxfs header used in C++ code

 fs/quota/quota.c            |   14 +-
 fs/xfs/xfs_ag.h             |   36 ++-
 fs/xfs/xfs_alloc.c          |   19 +-
 fs/xfs/xfs_alloc_btree.c    |    1 -
 fs/xfs/xfs_aops.c           |   55 +++-
 fs/xfs/xfs_attr.c           |  343 ++++++++-------------
 fs/xfs/xfs_attr_leaf.c      |  184 ++++++-----
 fs/xfs/xfs_attr_leaf.h      |    3 +-
 fs/xfs/xfs_attr_list.c      |    1 +
 fs/xfs/xfs_attr_remote.c    |   58 ++--
 fs/xfs/xfs_bit.h            |    7 +-
 fs/xfs/xfs_bmap.c           |  211 +++++++------
 fs/xfs/xfs_bmap.h           |    4 +-
 fs/xfs/xfs_bmap_btree.c     |    9 +-
 fs/xfs/xfs_bmap_btree.h     |    2 +-
 fs/xfs/xfs_bmap_util.c      |   18 +-
 fs/xfs/xfs_bmap_util.h      |   13 +-
 fs/xfs/xfs_btree.c          |   56 ++--
 fs/xfs/xfs_btree.h          |    5 +-
 fs/xfs/xfs_buf.c            |   17 +-
 fs/xfs/xfs_buf.h            |    9 +-
 fs/xfs/xfs_buf_item.c       |    5 +-
 fs/xfs/xfs_da_btree.c       |  114 ++-----
 fs/xfs/xfs_da_btree.h       |   26 +-
 fs/xfs/xfs_da_format.c      |   36 ++-
 fs/xfs/xfs_da_format.h      |  154 ----------
 fs/xfs/xfs_dir2.c           |  136 ++++++---
 fs/xfs/xfs_dir2.h           |   30 +-
 fs/xfs/xfs_dir2_block.c     |   97 +++---
 fs/xfs/xfs_dir2_data.c      |   83 +++--
 fs/xfs/xfs_dir2_leaf.c      |  202 +++++++------
 fs/xfs/xfs_dir2_node.c      |  190 ++++++------
 fs/xfs/xfs_dir2_priv.h      |  142 ++++++++-
 fs/xfs/xfs_dir2_readdir.c   |  155 +++++-----
 fs/xfs/xfs_dir2_sf.c        |   39 ++-
 fs/xfs/xfs_dquot.c          |   59 +---
 fs/xfs/xfs_dquot.h          |    2 -
 fs/xfs/xfs_dquot_buf.c      |    5 +-
 fs/xfs/xfs_export.c         |    2 +-
 fs/xfs/xfs_file.c           |   10 +-
 fs/xfs/xfs_filestream.c     |  684 +++++++++--------------------------------
 fs/xfs/xfs_filestream.h     |   34 +--
 fs/xfs/xfs_format.h         |   14 +-
 fs/xfs/xfs_fs.h             |    1 +
 fs/xfs/xfs_fsops.c          |   49 ++-
 fs/xfs/xfs_ialloc.c         |  704 ++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_ialloc.h         |    2 +-
 fs/xfs/xfs_ialloc_btree.c   |   69 ++++-
 fs/xfs/xfs_ialloc_btree.h   |    3 +-
 fs/xfs/xfs_icache.c         |   12 +-
 fs/xfs/xfs_icache.h         |    6 +-
 fs/xfs/xfs_inode.c          |  178 +++--------
 fs/xfs/xfs_inode.h          |    5 +-
 fs/xfs/xfs_inode_buf.c      |   17 +-
 fs/xfs/xfs_inode_fork.c     |    3 +-
 fs/xfs/xfs_inode_fork.h     |    3 +-
 fs/xfs/xfs_inode_item.c     |   32 +-
 fs/xfs/xfs_ioctl.c          |   14 +-
 fs/xfs/xfs_ioctl32.c        |    5 +-
 fs/xfs/xfs_iomap.c          |    2 +-
 fs/xfs/xfs_iops.c           |   32 +-
 fs/xfs/xfs_itable.c         |    6 +-
 fs/xfs/xfs_log.c            |   11 +-
 fs/xfs/xfs_log.h            |   19 +-
 fs/xfs/xfs_log_cil.c        |   57 +++-
 fs/xfs/xfs_log_recover.c    |   11 +-
 fs/xfs/xfs_log_rlimit.c     |    2 +-
 fs/xfs/xfs_mount.c          |   45 ++-
 fs/xfs/xfs_mount.h          |   12 +-
 fs/xfs/xfs_mru_cache.c      |  151 ++++------
 fs/xfs/xfs_mru_cache.h      |   31 +-
 fs/xfs/xfs_qm.c             |  243 +++------------
 fs/xfs/xfs_qm_syscalls.c    |    6 +-
 fs/xfs/xfs_quota_defs.h     |    2 +-
 fs/xfs/xfs_quotaops.c       |   29 +-
 fs/xfs/xfs_rtbitmap.c       |    1 -
 fs/xfs/xfs_sb.c             |   12 +-
 fs/xfs/xfs_sb.h             |  235 +++++----------
 fs/xfs/xfs_shared.h         |    2 +-
 fs/xfs/xfs_stats.c          |    1 +
 fs/xfs/xfs_stats.h          |   18 +-
 fs/xfs/xfs_super.c          |   26 +-
 fs/xfs/xfs_symlink.c        |    3 +-
 fs/xfs/xfs_symlink_remote.c |    1 -
 fs/xfs/xfs_trace.c          |    1 +
 fs/xfs/xfs_trace.h          |   58 ++++
 fs/xfs/xfs_trans.c          |    2 +-
 fs/xfs/xfs_trans_ail.c      |    5 +-
 fs/xfs/xfs_trans_priv.h     |    3 +-
 fs/xfs/xfs_trans_resv.c     |   56 +++-
 fs/xfs/xfs_trans_space.h    |   12 +-
 fs/xfs/xfs_types.h          |    2 +-
 include/linux/quota.h       |    1 +
 93 files changed, 2675 insertions(+), 2810 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
