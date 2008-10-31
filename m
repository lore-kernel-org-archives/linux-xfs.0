Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Oct 2008 21:57:54 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9V4veoj020640
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 21:57:40 -0700
Date: Fri, 31 Oct 2008 15:57:37 +1100
Subject: [GIT PULL] XFS update for 2.6.28
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081031045737.ECE0E58AE1E9@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

The following changes since commit 721d5dfe7e516954c501d5e9d0dfab379cf4241a:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://neil.brown.name/md

are available in the git repository at:

  git://oss.sgi.com:8090/xfs/linux-2.6 master

Barry Naujok (4):
      [XFS] Remove final remnants of dirv1 macros and other stuff
      [XFS] Sync up kernel and user-space headers
      [XFS] Check agf_btreeblks is valid when reading in the AGF
      [XFS] Show buffer address with debug hexdump on corruption

Christoph Hellwig (42):
      [XFS] kill struct xfs_btree_hdr
      [XFS] split up xfs_btree_init_cursor
      [XFS] add generic btree types
      [XFS] make btree root in inode support generic
      [XFS] add a long pointers flag to xfs_btree_cur
      [XFS] refactor xfs_btree_readahead
      [XFS] refactor btree validation helpers
      [XFS] make btree tracing generic
      [XFS] add get_maxrecs btree operation
      [XFS] add helpers for addressing entities inside a btree block
      [XFS] implement generic xfs_btree_increment
      [XFS] implement generic xfs_btree_decrement
      [XFS] implement generic xfs_btree_lookup
      [XFS] implement generic xfs_btree_updkey
      [XFS] implement generic xfs_btree_update
      [XFS] implement generic xfs_btree_rshift
      [XFS] implement generic xfs_btree_lshift
      [XFS] implement generic xfs_btree_split
      [XFS] implement semi-generic xfs_btree_new_root
      [XFS] move xfs_bmbt_newroot to common code
      [XFS] implement generic xfs_btree_insert/insrec
      [XFS] move xfs_bmbt_killroot to common code
      [XFS] implement generic xfs_btree_delete/delrec
      [XFS] implement generic xfs_btree_get_rec
      [XFS] kill xfs_bmbt_log_block and xfs_bmbt_log_recs
      [XFS] add keys_inorder and recs_inorder btree methods
      [XFS] mark various functions in xfs_btree.c static
      [XFS] make btree tracing generic
      [XFS] Cleanup maxrecs calculation.
      [XFS] cleanup btree record / key / ptr addressing macros.
      [XFS] Always use struct xfs_btree_block instead of short / longform
      [XFS] Move XFS_BMAP_SANITY_CHECK out of line.
      [XFS] split out two helpers from xfs_syncsub
      [XFS] fix instant oops with tracing enabled
      [XFS] kill struct xfs_mount_args
      [XFS] fix the noquota mount option
      [XFS] fix biosize option
      [XFS] Trivial xfs_remove comment fixup
      [XFS] stop using xfs_itobp in xfs_bulkstat
      Inode: export symbol destroy_inode
      [XFS] free partially initialized inodes using destroy_inode
      [XFS] kill sys_cred

David Chinner (44):
      [XFS] Make use of the init-once slab optimisation.
      [XFS] add new btree statistics
      [XFS] move sync code to its own file
      [XFS] move xfssyncd code to xfs_sync.c
      [XFS] Remove xfs_iflush_all and clean up xfs_finish_reclaim_all()
      [XFS] don't block in xfs_qm_dqflush() during async writeback.
      [XFS] Use the inode tree for finding dirty inodes
      [XFS] Traverse inode trees when releasing dquots
      [XFS] remove the mount inode list
      [XFS] Use struct inodes instead of vnodes to kill vn_grab
      [XFS] use xfs_sync_inodes rather than xfs_syncsub
      [XFS] kill xfs_syncsub
      [XFS] xfssyncd: don't call xfs_sync
      [XFS] make SYNC_ATTR no longer use xfs_sync
      [XFS] make SYNC_DELWRI no longer use xfs_sync
      [XFS] Kill SYNC_CLOSE
      [XFS] Kill xfs_sync()
      [XFS] Move remaining quiesce code.
      [XFS] factor xfs_iget_core() into hit and miss cases
      [XFS] Never call mark_inode_dirty_sync() directly
      Inode: Allow external initialisers
      Inode: Allow external list initialisation
      [XFS] Combine the XFS and Linux inodes
      [XFS] Prevent use-after-free caused by synchronous inode reclaim
      [XFS] move inode reclaim functions to xfs_sync.c
      [XFS] rename inode reclaim functions
      [XFS] mark inodes for reclaim via a tag in the inode radix tree
      [XFS] use the inode radix tree for reclaiming inodes
      [XFS] kill deleted inodes list
      [XFS] Prevent looping in xfs_sync_inodes_ag
      [XFS] Account for allocated blocks when expanding directories
      [XFS] Allocate the struct xfs_ail
      [XFS] Use a cursor for AIL traversal.
      [XFS] move the AIl traversal over to a consistent interface
      [XFS] Allow 64 bit machines to avoid the AIL lock during flushes
      [XFS] Move the AIL lock into the struct xfs_ail
      [XFS] Given the log a pointer to the AIL
      [XFS] Add ail pointer into log items
      [XFS] Finish removing the mount pointer from the AIL API
      [XFS] XFS: Check for valid transaction headers in recovery
      [XFS] Can't lock inodes in radix tree preload region
      [XFS] avoid all reclaimable inodes in xfs_sync_inodes_ag
      [XFS] correctly select first log item to push
      [XFS] Fix race when looking up reclaimable inodes

David Howells (1):
      CRED: Wrap task credential accesses in the XFS filesystem

Lachlan McIlroy (7):
      [XFS] Remove kmem_zone_t argument from xfs_inode_init_once()
      [XFS] Use xfs_idestroy() to cleanup an inode.
      [XFS] Fix use-after-free with log and quotas
      [XFS] Unlock inode before calling xfs_idestroy()
      [XFS] Wait for all I/O on truncate to zero file size
      [XFS] Make xfs_btree_check_ptr() debug-only code.
      [XFS] Fix build warning - xfs_fs_alloc_inode() needs a return statement

Peter Leckie (2):
      [XFS] Clean up dquot pincount code.
      [XFS] Fix build brakage from patch "Clean up dquot pincount code"

Tim Shimmin (2):
      [XFS] remove restricted chown parameter from xfs linux
      [XFS] remove restricted chown parameter from xfs linux

 Documentation/filesystems/xfs.txt |    4 -
 fs/inode.c                        |  208 ++-
 fs/xfs/Makefile                   |    4 +-
 fs/xfs/linux-2.6/xfs_aops.c       |    2 +-
 fs/xfs/linux-2.6/xfs_cred.h       |   10 +-
 fs/xfs/linux-2.6/xfs_globals.c    |    8 -
 fs/xfs/linux-2.6/xfs_globals.h    |    1 -
 fs/xfs/linux-2.6/xfs_ioctl.c      |    9 +-
 fs/xfs/linux-2.6/xfs_iops.c       |   25 +-
 fs/xfs/linux-2.6/xfs_linux.h      |    2 +-
 fs/xfs/linux-2.6/xfs_stats.c      |    4 +
 fs/xfs/linux-2.6/xfs_stats.h      |   65 +
 fs/xfs/linux-2.6/xfs_super.c      |  840 +++------
 fs/xfs/linux-2.6/xfs_super.h      |    3 -
 fs/xfs/linux-2.6/xfs_sync.c       |  763 ++++++++
 fs/xfs/linux-2.6/xfs_sync.h       |   55 +
 fs/xfs/linux-2.6/xfs_sysctl.c     |   11 -
 fs/xfs/linux-2.6/xfs_sysctl.h     |    3 +-
 fs/xfs/linux-2.6/xfs_vfs.h        |   31 -
 fs/xfs/linux-2.6/xfs_vnode.c      |   15 +-
 fs/xfs/linux-2.6/xfs_vnode.h      |    5 -
 fs/xfs/quota/xfs_dquot.c          |   39 +-
 fs/xfs/quota/xfs_dquot.h          |    4 +-
 fs/xfs/quota/xfs_dquot_item.c     |   45 +-
 fs/xfs/quota/xfs_qm.c             |   13 +-
 fs/xfs/quota/xfs_qm.h             |    1 -
 fs/xfs/quota/xfs_qm_bhv.c         |    1 -
 fs/xfs/quota/xfs_qm_syscalls.c    |  137 +-
 fs/xfs/support/debug.c            |    2 +-
 fs/xfs/xfs.h                      |    2 +-
 fs/xfs/xfs_acl.c                  |    8 +-
 fs/xfs/xfs_ag.h                   |   10 +-
 fs/xfs/xfs_alloc.c                |  195 ++-
 fs/xfs/xfs_alloc.h                |   27 +-
 fs/xfs/xfs_alloc_btree.c          | 2387 ++++---------------------
 fs/xfs/xfs_alloc_btree.h          |  107 +-
 fs/xfs/xfs_arch.h                 |   39 +-
 fs/xfs/xfs_bit.h                  |    3 +-
 fs/xfs/xfs_bmap.c                 |  296 ++--
 fs/xfs/xfs_bmap.h                 |   61 +-
 fs/xfs/xfs_bmap_btree.c           | 2614 +++++----------------------
 fs/xfs/xfs_bmap_btree.h           |  171 +--
 fs/xfs/xfs_btree.c                | 3596 ++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_btree.h                |  392 +++--
 fs/xfs/xfs_btree_trace.c          |  249 +++
 fs/xfs/xfs_btree_trace.h          |  116 ++
 fs/xfs/xfs_buf_item.c             |   25 +-
 fs/xfs/xfs_clnt.h                 |  105 --
 fs/xfs/xfs_da_btree.c             |    5 +
 fs/xfs/xfs_da_btree.h             |   24 +-
 fs/xfs/xfs_dinode.h               |    5 +-
 fs/xfs/xfs_dir2.c                 |    6 +
 fs/xfs/xfs_dmops.c                |    5 +-
 fs/xfs/xfs_extfree_item.c         |   45 +-
 fs/xfs/xfs_fsops.c                |   24 +-
 fs/xfs/xfs_ialloc.c               |  132 ++-
 fs/xfs/xfs_ialloc.h               |   21 +-
 fs/xfs/xfs_ialloc_btree.c         | 2193 +++--------------------
 fs/xfs/xfs_ialloc_btree.h         |  111 +-
 fs/xfs/xfs_iget.c                 |  501 ++----
 fs/xfs/xfs_imap.h                 |    2 -
 fs/xfs/xfs_inode.c                |  292 ++--
 fs/xfs/xfs_inode.h                |  288 ++--
 fs/xfs/xfs_inode_item.c           |   30 +-
 fs/xfs/xfs_inode_item.h           |   41 +-
 fs/xfs/xfs_itable.c               |   33 +-
 fs/xfs/xfs_log.c                  |   10 +-
 fs/xfs/xfs_log_priv.h             |    1 +
 fs/xfs/xfs_log_recover.c          |  105 +-
 fs/xfs/xfs_mount.c                |   47 +-
 fs/xfs/xfs_mount.h                |   54 +-
 fs/xfs/xfs_qmops.c                |    5 +-
 fs/xfs/xfs_trans.c                |   13 +-
 fs/xfs/xfs_trans.h                |  322 ++--
 fs/xfs/xfs_trans_ail.c            |  362 +++--
 fs/xfs/xfs_trans_buf.c            |    7 +-
 fs/xfs/xfs_trans_item.c           |   10 +
 fs/xfs/xfs_trans_priv.h           |   98 +-
 fs/xfs/xfs_vfsops.c               |  617 +-------
 fs/xfs/xfs_vfsops.h               |    2 -
 fs/xfs/xfs_vnodeops.c             |  141 +--
 fs/xfs/xfs_vnodeops.h             |    6 +-
 include/linux/fs.h                |    2 +
 kernel/sysctl_check.c             |    1 -
 84 files changed, 8096 insertions(+), 10178 deletions(-)
 create mode 100644 fs/xfs/linux-2.6/xfs_sync.c
 create mode 100644 fs/xfs/linux-2.6/xfs_sync.h
 create mode 100644 fs/xfs/xfs_btree_trace.c
 create mode 100644 fs/xfs/xfs_btree_trace.h
 delete mode 100644 fs/xfs/xfs_clnt.h
