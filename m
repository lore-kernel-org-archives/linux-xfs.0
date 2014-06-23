Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. xfs-for-linus-3.16-rc1-13101-ga497c3b
Message-Id: <20140623025606.736157F47@oss.sgi.com>
Date: Sun, 22 Jun 2014 21:56:04 -0500 (CDT)
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

The branch, master has been updated
  16b9057 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
  9c1d528 Merge commit '9f12600fe425bc28f0ccba034a77783c09c15af4' into for-linus
  8d02076 ->splice_write() via ->write_iter()
  412dd3a Merge tag 'xfs-for-linus-3.16-rc1' of git://oss.sgi.com/xfs/xfs
  23adbe1 fs,userns: Change inode_capable to capable_wrt_inode_uidgid
  7691283 Merge branch 'xfs-misc-fixes-3-for-3.16' into for-next
  8612c7e Merge branch 'xfs-da-geom' into for-next
  35f46c5 xfs: fix xfs_da_args sparse warning in xfs_readdir
  3026511 xfs: Fix rounding in xfs_alloc_fix_len()
  448011e xfs: tone down writepage/releasepage WARN_ONs
  72208ee xfs: small cleanup in xfs_lowbit64()
  36de955 xfs: kill xfs_buf_geterror()
  556b888 xfs: xfs_readsb needs to check for magic numbers
  1f6d648 xfs: block allocation work needs to be kswapd aware
  b2a21e7 xfs: remove redundant geometry information from xfs_da_state
  c2c4c47 xfs: replace attr LBSIZE with xfs_da_geometry
  c59f0ad xfs: pass xfs_da_args to xfs_attr_leaf_newentsize
  33a6039 xfs: use xfs_da_geometry for block size in attr code
  bc85178 xfs: remove mp->m_dir_geo from directory logging
  53f82db xfs: reduce direct usage of mp->m_dir_geo
  7ab610f xfs: move node entry counts to xfs_da_geometry
  ed358c0 xfs: convert dir/attr btree threshold to xfs_da_geometry
  8f66193 xfs: convert m_dirblksize to xfs_da_geometry
  d6cf130 xfs: convert m_dirblkfsbs to xfs_da_geometry
  7dda6e8 xfs: convert directory segment limits to xfs_da_geometry
  3002803 xfs: convert directory db conversion to xfs_da_geometry
  2998ab1 xfs: convert directory dablk conversion to xfs_da_geometry
  9b3b552 xfs: convert dir byte/off conversion to xfs_da_geometry
  8c44a28 xfs: kill XFS_DIR2...FIRSTDB macros
  892e3f3 xfs: move directory block translatiosn to xfs_dir2_priv.h
  0650b55 xfs: introduce directory geometry structure
  b70f14e Merge branch 'xfs-feature-bit-cleanup' into for-next
  0d907a3 Merge branch 'xfs-misc-fixes-2-for-3.16' into for-next
  376c2f3 xfs: fix compile error when libxfs header used in C++ code
  8695d27 xfs: fix infinite loop at xfs_vm_writepage on 32bit system
  7c16635 xfs: remove redundant checks from xfs_da_read_buf
  110dc24 xfs: log vector rounding leaks log space
  ce576f1 xfs: remove XFS_TRANS_RESERVE in collapse range
  ab3e57b xfs: remove shared supberlock feature checking
  5d074a4 xfs: don't need dirv2 checks anymore
  263997a xfs: turn NLINK feature on by default
  32bf1de xfs: keep sb_bad_features2 the same a sb_features2
  f68a373 xfs: make superblock version checks reflect reality
  2d6dcc6 Merge branch 'xfs-attr-cleanup' into for-next
  ff14ee4 Merge branch 'xfs-misc-fixes-1-for-3.16' into for-next
  b767692 Merge branch 'xfs-free-inode-btree' into for-next
  232c2f5 Merge branch 'xfs-filestreams-lookup' into for-next
  fdd3a2a Merge branch 'xfs-unused-args-cleanup' into for-next
  ee4eec4 xfs: list_lru_init returns a negative error
  bc14782 xfs: negate xfs_icsb_init_counters error value 
  4568764 xfs: negate mount workqueue init error value
  6670232 xfs: fix wrong err sign on xfs_set_acl()
  a5a14de xfs: fix wrong errno from xfs_initxattrs
  65149e3 xfs: correct error sign on COLLAPSE_RANGE errors
  b38a134 xfs: xfs_commit_metadata returns wrong errno
  8ff1e67 xfs: fix incorrect error sign in xfs_file_aio_read
  43ec146 xfs: xfs_dir_fsync() returns positive errno
  6c888af xfs: pass struct da_args to xfs_attr_calc_size
  67fd718 xfs: simplify attr name setup
  1bc426a xfs: fold xfs_attr_remove_int into xfs_attr_remove
  b87d022 xfs: fold xfs_attr_get_int into xfs_attr_get
  c5b4ac3 xfs: fold xfs_attr_set_int into xfs_attr_set
  8cfcc3e xfs: fix directory readahead offset off-by-one
  ac98351 xfs: don't sleep in xlog_cil_force_lsn on shutdown
  49abc3a xfs: truncate_setsize should be outside transactions
  bf97f3b xfs: switch to ->write_iter()
  b4f5d2c xfs: switch to ->read_iter()
  b318891 xfs: trim the argument lists of xfs_file_{dio,buffered}_aio_write()
  0c94933 iov_iter_truncate()
  71d8e53 start adding the tag to iov_iter
  31b1403 switch {__,}blockdev_direct_IO() to iov_iter
  a6cbcd4 get rid of pointless iov_length() in ->direct_IO()
  d8d3d94 pass iov_iter to ->direct_IO()
  cb66a7a kill generic_segment_checks()
  f8579f8 generic_file_direct_write(): switch to iov_iter
  b28fd7b xfs: Fix wrong error codes being returned
  3c35337 xfs: remove dquot hints
  f58522c xfs: bulletfproof xfs_qm_scall_trunc_qfiles()
  9da93f9 xfs: fix Q_XQUOTARM ioctl
  53801fd xfs: enable the finobt feature on v5 superblocks
  0c153c1 xfs: report finobt status in fs geometry
  a3fa516 xfs: add finobt support to growfs
  3efa4ff xfs: update the finobt on inode free
  2b64ee5 xfs: refactor xfs_difree() inobt bits into xfs_difree_inobt() helper
  6dd8638 xfs: use and update the finobt on inode allocation
  0aa0a75 xfs: insert newly allocated inode chunks into the finobt
  9d43b18 xfs: update inode allocation/free transaction reservations for finobt
  aafc3c2 xfs: support the XFS_BTNUM_FINOBT free inode btree type
  8e2c84d xfs: reserve v5 superblock read-only compat. feature bit for finobt
  57bd3db xfs: refactor xfs_ialloc_btree.c to support multiple inobt numbers
  b94acd4 xfs: add filestream allocator tracepoints
  3b8d907 xfs: remove xfs_filestream_associate
  1919add xfs: don't create a slab cache for filestream items
  2cd2ef6 xfs: rewrite the filestream allocator using the dentry cache
  f37211c xfs: remove XFS_IFILESTREAM
  22328d7 xfs: embedd mru_elem into parent structure
  ce695c6 xfs: handle duplicate entries in xfs_mru_cache_insert
  c977eb1 xfs: split xfs_bmap_btalloc_nullfb
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
      from  d6d211db37e75de2ddc3a4f979038c40df7cc79c (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 16b9057804c02e2d351e9c8f606e909b43cbd9e7
Merge: 5c02c39 c2338f2
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jun 12 10:30:18 2014 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
    
    Pull vfs updates from Al Viro:
     "This the bunch that sat in -next + lock_parent() fix.  This is the
      minimal set; there's more pending stuff.
    
      In particular, I really hope to get acct.c fixes merged this cycle -
      we need that to deal sanely with delayed-mntput stuff.  In the next
      pile, hopefully - that series is fairly short and localized
      (kernel/acct.c, fs/super.c and fs/namespace.c).  In this pile: more
      iov_iter work.  Most of prereqs for ->splice_write with sane locking
      order are there and Kent's dio rewrite would also fit nicely on top of
      this pile"
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs: (70 commits)
      lock_parent: don't step on stale ->d_parent of all-but-freed one
      kill generic_file_splice_write()
      ceph: switch to iter_file_splice_write()
      shmem: switch to iter_file_splice_write()
      nfs: switch to iter_splice_write_file()
      fs/splice.c: remove unneeded exports
      ocfs2: switch to iter_file_splice_write()
      ->splice_write() via ->write_iter()
      bio_vec-backed iov_iter
      optimize copy_page_{to,from}_iter()
      bury generic_file_aio_{read,write}
      lustre: get rid of messing with iovecs
      ceph: switch to ->write_iter()
      ceph_sync_direct_write: stop poking into iov_iter guts
      ceph_sync_read: stop poking into iov_iter guts
      new helper: copy_page_from_iter()
      fuse: switch to ->write_iter()
      btrfs: switch to ->write_iter()
      ocfs2: switch to ->write_iter()
      xfs: switch to ->write_iter()
      ...

commit 9c1d5284c79fea050f115eadeec1dd1758e5c630
Merge: 5f07385 9f12600
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Jun 12 00:27:11 2014 -0400

    Merge commit '9f12600fe425bc28f0ccba034a77783c09c15af4' into for-linus
    
    Backmerge of dcache.c changes from mainline.  It's that, or complete
    rebase...
    
    Conflicts:
    	fs/splice.c
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 8d0207652cbe27d1f962050737848e5ad4671958
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Apr 5 04:27:08 2014 -0400

    ->splice_write() via ->write_iter()
    
    iter_file_splice_write() - a ->splice_write() instance that gathers the
    pipe buffers, builds a bio_vec-based iov_iter covering those and feeds
    it to ->write_iter().  A bunch of simple cases coverted to that...
    
    [AV: fixed the braino spotted by Cyrill]
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 412dd3a6daf0cadce1b2d6a34fa3713f40255579
Merge: 23d4ed5 7691283
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jun 11 09:03:47 2014 -0700

    Merge tag 'xfs-for-linus-3.16-rc1' of git://oss.sgi.com/xfs/xfs
    
    Pull xfs updates from Dave Chinner:
     "This update contains:
       - cleanup removing unused function args
       - rework of the filestreams allocator to use dentry cache parent
         lookups
       - new on-disk free inode btree and optimised inode allocator
       - various bug fixes
       - rework of internal attribute API
       - cleanup of superblock feature bit support to remove historic cruft
       - more fixes and minor cleanups
       - added a new directory/attribute geometry abstraction
       - yet more fixes and minor cleanups"
    
    * tag 'xfs-for-linus-3.16-rc1' of git://oss.sgi.com/xfs/xfs: (86 commits)
      xfs: fix xfs_da_args sparse warning in xfs_readdir
      xfs: Fix rounding in xfs_alloc_fix_len()
      xfs: tone down writepage/releasepage WARN_ONs
      xfs: small cleanup in xfs_lowbit64()
      xfs: kill xfs_buf_geterror()
      xfs: xfs_readsb needs to check for magic numbers
      xfs: block allocation work needs to be kswapd aware
      xfs: remove redundant geometry information from xfs_da_state
      xfs: replace attr LBSIZE with xfs_da_geometry
      xfs: pass xfs_da_args to xfs_attr_leaf_newentsize
      xfs: use xfs_da_geometry for block size in attr code
      xfs: remove mp->m_dir_geo from directory logging
      xfs: reduce direct usage of mp->m_dir_geo
      xfs: move node entry counts to xfs_da_geometry
      xfs: convert dir/attr btree threshold to xfs_da_geometry
      xfs: convert m_dirblksize to xfs_da_geometry
      xfs: convert m_dirblkfsbs to xfs_da_geometry
      xfs: convert directory segment limits to xfs_da_geometry
      xfs: convert directory db conversion to xfs_da_geometry
      xfs: convert directory dablk conversion to xfs_da_geometry
      ...

commit 23adbe12ef7d3d4195e80800ab36b37bee28cd03
Author: Andy Lutomirski <luto@amacapital.net>
Date:   Tue Jun 10 12:45:42 2014 -0700

    fs,userns: Change inode_capable to capable_wrt_inode_uidgid
    
    The kernel has no concept of capabilities with respect to inodes; inodes
    exist independently of namespaces.  For example, inode_capable(inode,
    CAP_LINUX_IMMUTABLE) would be nonsense.
    
    This patch changes inode_capable to check for uid and gid mappings and
    renames it to capable_wrt_inode_uidgid, which should make it more
    obvious what it does.
    
    Fixes CVE-2014-4014.
    
    Cc: Theodore Ts'o <tytso@mit.edu>
    Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
    Cc: "Eric W. Biederman" <ebiederm@xmission.com>
    Cc: Dave Chinner <david@fromorbit.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Andy Lutomirski <luto@amacapital.net>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit bf97f3bc0c32140c43fe5ca53d23514ea46a54ca
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 14:20:23 2014 -0400

    xfs: switch to ->write_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit b4f5d2c6d1f88c79e48f1296076b3a6a22f58c0f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 14:37:59 2014 -0400

    xfs: switch to ->read_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit b318891929c2750055a4002bee3e7636ca3684de
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 07:06:30 2014 -0400

    xfs: trim the argument lists of xfs_file_{dio,buffered}_aio_write()
    
    pos is redundant (it's iocb->ki_pos), and iov/nr_segs/count are taken
    care of by lifting iov_iter into the caller.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 0c949334a9e2581646c6ff0d1470a805b1e5be99
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Mar 22 06:51:37 2014 -0400

    iov_iter_truncate()
    
    Now It Can Be Done(tm) - we don't need to do iov_shorten() in
    generic_file_direct_write() anymore, now that all ->direct_IO()
    instances are converted to proper iov_iter methods and honour
    iter->count and iter->iov_offset properly.
    
    Get rid of count/ocount arguments of generic_file_direct_write(),
    while we are at it.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 71d8e532b1549a478e6a6a8a44f309d050294d00
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Mar 5 19:28:09 2014 -0500

    start adding the tag to iov_iter
    
    For now, just use the same thing we pass to ->direct_IO() - it's all
    iovec-based at the moment.  Pass it explicitly to iov_iter_init() and
    account for kvec vs. iovec in there, by the same kludge NFS ->direct_IO()
    uses.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 31b140398ce56ab41646eda7f02bcb78d6a4c916
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Mar 5 01:33:16 2014 -0500

    switch {__,}blockdev_direct_IO() to iov_iter
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit a6cbcd4a4a85e2fdb0b3344b88df2e8b3d526b9e
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Mar 4 22:38:00 2014 -0500

    get rid of pointless iov_length() in ->direct_IO()
    
    all callers have iov_length(iter->iov, iter->nr_segs) == iov_iter_count(iter)
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit d8d3d94b80aa1a1c0ca75c58b8abdc7356f38418
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Mar 4 21:27:34 2014 -0500

    pass iov_iter to ->direct_IO()
    
    unmodified, for now
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit cb66a7a1f149ff705fa37cad6d1252b046e0ad4f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Mar 4 15:24:06 2014 -0500

    kill generic_segment_checks()
    
    all callers of ->aio_read() and ->aio_write() have iov/nr_segs already
    checked - generic_segment_checks() done after that is just an odd way
    to spell iov_length().
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit f8579f8673b7ecdb7a81d5d5bb1d981093d9aa94
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Mon Mar 3 22:03:20 2014 -0500

    generic_file_direct_write(): switch to iov_iter
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_ag.h             |  36 ++-
 fs/xfs/xfs_alloc.c          |  19 +-
 fs/xfs/xfs_alloc_btree.c    |   1 -
 fs/xfs/xfs_aops.c           |  72 +++--
 fs/xfs/xfs_attr.c           | 343 ++++++++-------------
 fs/xfs/xfs_attr_leaf.c      | 184 ++++++------
 fs/xfs/xfs_attr_leaf.h      |   3 +-
 fs/xfs/xfs_attr_list.c      |   1 +
 fs/xfs/xfs_attr_remote.c    |  58 ++--
 fs/xfs/xfs_bit.h            |   7 +-
 fs/xfs/xfs_bmap.c           | 211 +++++++------
 fs/xfs/xfs_bmap.h           |   4 +-
 fs/xfs/xfs_bmap_btree.c     |   9 +-
 fs/xfs/xfs_bmap_btree.h     |   2 +-
 fs/xfs/xfs_bmap_util.c      |  18 +-
 fs/xfs/xfs_bmap_util.h      |  13 +-
 fs/xfs/xfs_btree.c          |  56 ++--
 fs/xfs/xfs_btree.h          |   5 +-
 fs/xfs/xfs_buf.c            |  17 +-
 fs/xfs/xfs_buf.h            |   9 +-
 fs/xfs/xfs_buf_item.c       |   5 +-
 fs/xfs/xfs_da_btree.c       | 114 ++-----
 fs/xfs/xfs_da_btree.h       |  26 +-
 fs/xfs/xfs_da_format.c      |  36 ++-
 fs/xfs/xfs_da_format.h      | 154 ----------
 fs/xfs/xfs_dir2.c           | 136 +++++----
 fs/xfs/xfs_dir2.h           |  30 +-
 fs/xfs/xfs_dir2_block.c     |  97 +++---
 fs/xfs/xfs_dir2_data.c      |  83 +++---
 fs/xfs/xfs_dir2_leaf.c      | 202 +++++++------
 fs/xfs/xfs_dir2_node.c      | 190 ++++++------
 fs/xfs/xfs_dir2_priv.h      | 142 ++++++++-
 fs/xfs/xfs_dir2_readdir.c   | 155 +++++-----
 fs/xfs/xfs_dir2_sf.c        |  39 ++-
 fs/xfs/xfs_dquot.c          |  59 +---
 fs/xfs/xfs_dquot.h          |   2 -
 fs/xfs/xfs_dquot_buf.c      |   5 +-
 fs/xfs/xfs_export.c         |   2 +-
 fs/xfs/xfs_file.c           | 129 ++------
 fs/xfs/xfs_filestream.c     | 684 +++++++++---------------------------------
 fs/xfs/xfs_filestream.h     |  34 +--
 fs/xfs/xfs_format.h         |  14 +-
 fs/xfs/xfs_fs.h             |   1 +
 fs/xfs/xfs_fsops.c          |  49 ++-
 fs/xfs/xfs_ialloc.c         | 704 +++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_ialloc.h         |   2 +-
 fs/xfs/xfs_ialloc_btree.c   |  69 ++++-
 fs/xfs/xfs_ialloc_btree.h   |   3 +-
 fs/xfs/xfs_icache.c         |  12 +-
 fs/xfs/xfs_icache.h         |   6 +-
 fs/xfs/xfs_inode.c          | 178 +++--------
 fs/xfs/xfs_inode.h          |   5 +-
 fs/xfs/xfs_inode_buf.c      |  17 +-
 fs/xfs/xfs_inode_fork.c     |   3 +-
 fs/xfs/xfs_inode_fork.h     |   3 +-
 fs/xfs/xfs_inode_item.c     |  32 +-
 fs/xfs/xfs_ioctl.c          |  16 +-
 fs/xfs/xfs_ioctl32.c        |   5 +-
 fs/xfs/xfs_iomap.c          |   2 +-
 fs/xfs/xfs_iops.c           |  32 +-
 fs/xfs/xfs_itable.c         |   6 +-
 fs/xfs/xfs_log.c            |  11 +-
 fs/xfs/xfs_log.h            |  19 +-
 fs/xfs/xfs_log_cil.c        |  57 +++-
 fs/xfs/xfs_log_recover.c    |  11 +-
 fs/xfs/xfs_log_rlimit.c     |   2 +-
 fs/xfs/xfs_mount.c          |  45 ++-
 fs/xfs/xfs_mount.h          |  12 +-
 fs/xfs/xfs_mru_cache.c      | 151 ++++------
 fs/xfs/xfs_mru_cache.h      |  31 +-
 fs/xfs/xfs_qm.c             | 243 +++------------
 fs/xfs/xfs_qm_syscalls.c    |   6 +-
 fs/xfs/xfs_quota_defs.h     |   2 +-
 fs/xfs/xfs_quotaops.c       |  29 +-
 fs/xfs/xfs_rtbitmap.c       |   1 -
 fs/xfs/xfs_sb.c             |  12 +-
 fs/xfs/xfs_sb.h             | 235 +++++----------
 fs/xfs/xfs_shared.h         |   2 +-
 fs/xfs/xfs_stats.c          |   1 +
 fs/xfs/xfs_stats.h          |  18 +-
 fs/xfs/xfs_super.c          |  26 +-
 fs/xfs/xfs_symlink.c        |   3 +-
 fs/xfs/xfs_symlink_remote.c |   1 -
 fs/xfs/xfs_trace.c          |   1 +
 fs/xfs/xfs_trace.h          |  59 +++-
 fs/xfs/xfs_trans.c          |   2 +-
 fs/xfs/xfs_trans_ail.c      |   5 +-
 fs/xfs/xfs_trans_priv.h     |   3 +-
 fs/xfs/xfs_trans_resv.c     |  56 +++-
 fs/xfs/xfs_trans_space.h    |  12 +-
 fs/xfs/xfs_types.h          |   2 +-
 91 files changed, 2696 insertions(+), 2913 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
