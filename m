Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.15-rc2-31-g7043507
Message-Id: <20140422223050.B50D67F51@oss.sgi.com>
Date: Tue, 22 Apr 2014 17:30:50 -0500 (CDT)
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
To: xfs@oss.sgi.com

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, for-next has been updated
  7043507 Merge branch 'xfs-filestreams-lookup' into for-next
  b94acd4 xfs: add filestream allocator tracepoints
  3b8d907 xfs: remove xfs_filestream_associate
  1919add xfs: don't create a slab cache for filestream items
  2cd2ef6 xfs: rewrite the filestream allocator using the dentry cache
  f37211c xfs: remove XFS_IFILESTREAM
  22328d7 xfs: embedd mru_elem into parent structure
  ce695c6 xfs: handle duplicate entries in xfs_mru_cache_insert
  c977eb1 xfs: split xfs_bmap_btalloc_nullfb
  c24c775 Merge branch 'xfs-unused-args-cleanup' into for-next
  8b90a33 xfs: don't try to use the filestream allocator for metadata allocations
  5e06d14 xfs: remove unused calculation in xfs_dir2_sf_addname()
  e5e98bc xfs: remove pointless pointer increment in xfs_dir2_block_compact()
  bbe4c66 xfs: remove unused trans pointer arg from xlog_recover_unmount_trans()
  e4a1e29 xfs: remove unused ail pointer arg from xfs_trans_ail_cursor_done()
  bda65ef xfs: remove unused xfs_mount arg from xfs_symlink_hdr_ok()
  fd9fdba xfs: remove unused bp arg from xfs_iflush_fork()
  e009400 xfs: remove unused pag ptr arg from iterator execute functions
  6f8950c xfs: remove unused length arg from alloc_block ops
  6ea94bb xfs: remove unused mp arg from xfs_calc_dquots_per_chunk()
  2599405 xfs: remove unused mp arg from xfs_dir2 dataptr/byte functions
  9df2dd0 xfs: remove unused tp arg from xfs_da_reada_buf & callers
  72b0636 xfs: remove unused bip arg from xfs_buf_item_log_segment()
  87937bf xfs: remove unused flags arg from _xfs_buf_get_pages()
  34dcefd xfs: remove unused args from xfs_alloc_buftarg()
  a96c415 xfs: remove unused blocksize arg from xfs_setsize_buftarg()
  0d7409b xfs: remove unused level arg from xfs_btree_read_buf_block()
  6a9edd3 xfs: remove unused mp arg from xfs_bmap_forkoff_reset()
  152d93b xfs: remove unused mp arg from xfs_bmdr_maxrecs()
  6d0081a xfs: remove unused mp arg from xfs_attr3_rmt_hdr_ok()
  7fb2cd4 xfs: remove unused tp arg from xfs_bmap_last_offset() and callers
      from  330033d697ed8d296fa52b5303db9d802ad901cc (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 7043507bfa1af648512e36d95cca484757df0b64
Merge: c24c775 b94acd4
Author: Dave Chinner <david@fromorbit.com>
Date:   Wed Apr 23 07:12:35 2014 +1000

    Merge branch 'xfs-filestreams-lookup' into for-next

commit c24c775c5e3657d329ede70f744ba075095bb53d
Merge: 330033d 5e06d14
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue Apr 22 19:21:42 2014 +1000

    Merge branch 'xfs-unused-args-cleanup' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_alloc_btree.c    |   1 -
 fs/xfs/xfs_attr_remote.c    |   3 +-
 fs/xfs/xfs_bmap.c           | 208 ++++++++------
 fs/xfs/xfs_bmap.h           |   4 +-
 fs/xfs/xfs_bmap_btree.c     |   9 +-
 fs/xfs/xfs_bmap_btree.h     |   2 +-
 fs/xfs/xfs_btree.c          |  38 ++-
 fs/xfs/xfs_btree.h          |   2 +-
 fs/xfs/xfs_buf.c            |  17 +-
 fs/xfs/xfs_buf.h            |   4 +-
 fs/xfs/xfs_buf_item.c       |   3 +-
 fs/xfs/xfs_da_btree.c       |   8 +-
 fs/xfs/xfs_da_btree.h       |   6 +-
 fs/xfs/xfs_da_format.h      |  10 +-
 fs/xfs/xfs_dir2.c           |  26 +-
 fs/xfs/xfs_dir2.h           |   4 +-
 fs/xfs/xfs_dir2_block.c     |   9 +-
 fs/xfs/xfs_dir2_data.c      |   3 +-
 fs/xfs/xfs_dir2_leaf.c      |   2 +-
 fs/xfs/xfs_dir2_node.c      |   2 +-
 fs/xfs/xfs_dir2_priv.h      |   4 +-
 fs/xfs/xfs_dir2_readdir.c   |  14 +-
 fs/xfs/xfs_dir2_sf.c        |  21 +-
 fs/xfs/xfs_dquot_buf.c      |   5 +-
 fs/xfs/xfs_file.c           |   2 +-
 fs/xfs/xfs_filestream.c     | 684 ++++++++++----------------------------------
 fs/xfs/xfs_filestream.h     |  34 +--
 fs/xfs/xfs_ialloc_btree.c   |   1 -
 fs/xfs/xfs_icache.c         |  12 +-
 fs/xfs/xfs_icache.h         |   6 +-
 fs/xfs/xfs_inode.c          |  39 +--
 fs/xfs/xfs_inode.h          |   4 +-
 fs/xfs/xfs_inode_fork.c     |   3 +-
 fs/xfs/xfs_inode_fork.h     |   3 +-
 fs/xfs/xfs_iomap.c          |   2 +-
 fs/xfs/xfs_log_recover.c    |   9 +-
 fs/xfs/xfs_mru_cache.c      | 151 ++++------
 fs/xfs/xfs_mru_cache.h      |  31 +-
 fs/xfs/xfs_qm.c             |   3 +-
 fs/xfs/xfs_qm_syscalls.c    |   1 -
 fs/xfs/xfs_quota_defs.h     |   2 +-
 fs/xfs/xfs_shared.h         |   2 +-
 fs/xfs/xfs_super.c          |  22 +-
 fs/xfs/xfs_symlink.c        |   2 +-
 fs/xfs/xfs_symlink_remote.c |   1 -
 fs/xfs/xfs_trace.c          |   1 +
 fs/xfs/xfs_trace.h          |  58 ++++
 fs/xfs/xfs_trans.c          |   2 +-
 fs/xfs/xfs_trans_ail.c      |   5 +-
 fs/xfs/xfs_trans_priv.h     |   3 +-
 50 files changed, 516 insertions(+), 972 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
