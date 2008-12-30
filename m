Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBU38tvK028581 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 21:08:55 -0600
Date: Tue, 30 Dec 2008 14:08:45 +1100
Subject: [GIT PULL] XFS update for 2.6.29
MIME-Version: 1.0
Message-Id: <20081230030845.A4F0558AE206@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

The following changes since commit 3c92ec8ae91ecf59d88c798301833d7cf83f2179:
  Linus Torvalds (1):
        Merge branch 'next' of git://git.kernel.org/.../paulus/powerpc

are available in the git repository at:

  git://oss.sgi.com/oss/git/xfs/xfs.git for-linus

Barry Naujok (4):
      [XFS] Remove final remnants of dirv1 macros and other stuff
      [XFS] Sync up kernel and user-space headers
      [XFS] Check agf_btreeblks is valid when reading in the AGF
      [XFS] Show buffer address with debug hexdump on corruption

Christoph Hellwig (91):
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
      [XFS] fix NULL pointer dereference in xfs_log_force_umount
      [XFS] wire up ->open for directories
      [XFS] allow inode64 mount option on 32 bit systems
      [XFS] fix spurious gcc warnings
      [XFS] remove bhv_statvfs_t typedef
      [XFS] remove xfs_vfs.h
      [XFS] remove xfs_vfsops.h
      [XFS] factor out xfs_read_agi helper
      [XFS] factor out xfs_read_agf helper
      [XFS] sanitize xlog_in_core_t definition
      [XFS] kill xfs_ialloc_log_di
      [XFS] kill xfs_dinode_core_t
      [XFS] kill XFS_DINODE_VERSION_ defines
      [XFS] split up xlog_recover_process_iunlinks
      [XFS] stop using xfs_itobp in xfs_iread
      [XFS] remove dead code for old inode item recovery
      [XFS] merge xfs_imap into xfs_dilocate
      [XFS] embededd struct xfs_imap into xfs_inode
      [XFS] kill the XFS_IMAP_BULKSTAT flag
      [XFS] move inode allocation out xfs_iread
      [XFS] fix error handling in xlog_recover_process_one_iunlink
      [XFS] fix compile on 32 bit systems
      remove useless mnt_want_write call in xfs_write
      remove unused behvavior cruft in xfs_super.h
      remove unused prototypes for xfs_ihash_init / xfs_ihash_free
      cleanup the inode reclaim path
      kill xfs_buf_iostart
      stop using igrab in xfs_vn_link
      reduce l_icloglock roundtrips
      remove dead code from sv_t implementation
      kill dead quota flags
      cleanup xfs_sb.h feature flag helpers
      kill dead inode flags
      remove unused m_inode_quiesce member from struct xfs_mount
      remove leftovers of shared read-only support
      use xfs_trans_ijoin in xfs_trans_iget
      no explicit xfs_iflush for special inodes during unmount
      kill xfs_unmount_flush
      kill vn_ioerror
      move vn_iowait / vn_iowake into xfs_aops.c
      move inode tracing out of xfs_vnode.
      [XFS] Fix compile with CONFIG_COMPAT enabled
      [XFS] replace b_fspriv with b_mount
      [XFS] simplify projid check in xfs_rename
      [XFS] resync headers with libxfs
      [XFS] add a FMODE flag to make XFS invisible I/O less hacky
      [XFS] use inode_change_ok for setattr permission checking
      [XFS] avoid memory allocations in xfs_fs_vcmn_err
      [XFS] handle unaligned data in xfs_bmbt_disk_get_all

Dave Chinner (8):
      [XFS] handle memory allocation failures during log initialisation
      [XFS] fix uninitialised variable bug in dquot release
      [XFS] Avoid using inodes that haven't been completely initialised
      [XFS] Fix double free of log tickets
      [XFS] fix error inversion problems with data flushing
      [XFS] fix uninitialised variable bug in dquot release.
      [XFS] remove i_gen from incore inode
      [XFS] Fix hang after disallowed rename across directory quota domains

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

Eric Sandeen (3):
      [XFS] convert xfs_getbmap to take formatter functions
      [XFS] Add new getbmap flags.
      [XFS] Hook up the fiemap ioctl.

Lachlan McIlroy (21):
      [XFS] Remove kmem_zone_t argument from xfs_inode_init_once()
      [XFS] Use xfs_idestroy() to cleanup an inode.
      [XFS] Fix use-after-free with log and quotas
      [XFS] Unlock inode before calling xfs_idestroy()
      [XFS] Wait for all I/O on truncate to zero file size
      [XFS] Make xfs_btree_check_ptr() debug-only code.
      [XFS] Fix build warning - xfs_fs_alloc_inode() needs a return statement
      Merge git://git.kernel.org/.../torvalds/linux-2.6
      [XFS] Check return value of xfs_buf_get_noaddr()
      [XFS] Remove unused variable in ktrace_free()
      [XFS] Remove unnecessary assertion
      Merge git://git.kernel.org/.../torvalds/linux-2.6
      [XFS] Remove unused tracing code
      [XFS] set b_error from bio error in xfs_buf_bio_end_io
      Merge branch 'master' of git+ssh://git.melbourne.sgi.com/git/xfs
      [XFS] Fix merge conflict in fs/xfs/xfs_rename.c
      [XFS] Use the incore inode size in xfs_file_readdir()
      [XFS] Remove XFS_BUF_SHUT() and friends
      [XFS] Fix speculative allocation beyond eof
      [XFS] Fix race in xfs_write() between direct and buffered I/O with DMAPI
      [XFS] Fix merge failures

Niv Sardi (1):
      Merge branch 'master' of git://oss.sgi.com:8090/xfs/linux-2.6

Peter Leckie (2):
      [XFS] Clean up dquot pincount code.
      [XFS] Fix build brakage from patch "Clean up dquot pincount code"

Stephen Rothwell (1):
      fs: xfs needs inode_wait to be exported

Tim Shimmin (2):
      [XFS] remove restricted chown parameter from xfs linux
      [XFS] remove restricted chown parameter from xfs linux

sandeen@sandeen.net (12):
      [XFS] Move copy_from_user calls out of ioctl helpers into ioctl switch.
      [XFS] Move compat ioctl structs & numbers into xfs_ioctl32.h
      [XFS] Clean up some existing compat ioctl calls
      [XFS] Add compat handlers for swapext ioctl
      [XFS] Add compat handlers for data & rt growfs ioctls
      [XFS] Make the bulkstat_one compat ioctl handling more sane
      [XFS] Fix xfs_bulkstat_one size checks & error handling
      [XFS] Fix compat XFS_IOC_FSBULKSTAT_SINGLE ioctl
      [XFS] Hook up compat XFS_IOC_ATTRLIST_BY_HANDLE ioctl handler
      [XFS] Hook up compat XFS_IOC_ATTRMULTI_BY_HANDLE ioctl handler
      [XFS] Hook up compat XFS_IOC_FSSETDM_BY_HANDLE ioctl handler
      [XFS] Reorder xfs_ioctl32.c for some tidiness

 Documentation/filesystems/xfs.txt |    4 -
 fs/inode.c                        |  209 ++-
 fs/xfs/Makefile                   |    6 +-
 fs/xfs/linux-2.6/sv.h             |   22 +-
 fs/xfs/linux-2.6/xfs_aops.c       |   66 +-
 fs/xfs/linux-2.6/xfs_aops.h       |    3 +
 fs/xfs/linux-2.6/xfs_buf.c        |   87 +-
 fs/xfs/linux-2.6/xfs_buf.h        |   30 +-
 fs/xfs/linux-2.6/xfs_cred.h       |    8 -
 fs/xfs/linux-2.6/xfs_export.c     |    1 -
 fs/xfs/linux-2.6/xfs_file.c       |  189 +--
 fs/xfs/linux-2.6/xfs_fs_subr.c    |   23 +-
 fs/xfs/linux-2.6/xfs_globals.c    |    8 -
 fs/xfs/linux-2.6/xfs_globals.h    |    1 -
 fs/xfs/linux-2.6/xfs_ioctl.c      |  223 ++--
 fs/xfs/linux-2.6/xfs_ioctl.h      |   82 +
 fs/xfs/linux-2.6/xfs_ioctl32.c    |  849 ++++++---
 fs/xfs/linux-2.6/xfs_ioctl32.h    |  214 +++-
 fs/xfs/linux-2.6/xfs_iops.c       |  122 ++-
 fs/xfs/linux-2.6/xfs_iops.h       |    1 -
 fs/xfs/linux-2.6/xfs_linux.h      |   13 +-
 fs/xfs/linux-2.6/xfs_lrw.c        |   50 +-
 fs/xfs/linux-2.6/xfs_stats.c      |    6 +-
 fs/xfs/linux-2.6/xfs_stats.h      |   65 +
 fs/xfs/linux-2.6/xfs_super.c      |  884 +++------
 fs/xfs/linux-2.6/xfs_super.h      |   15 -
 fs/xfs/linux-2.6/xfs_sync.c       |  762 ++++++++
 fs/xfs/linux-2.6/xfs_sync.h       |   55 +
 fs/xfs/linux-2.6/xfs_sysctl.c     |   11 -
 fs/xfs/linux-2.6/xfs_sysctl.h     |    3 +-
 fs/xfs/linux-2.6/xfs_vfs.h        |   77 -
 fs/xfs/linux-2.6/xfs_vnode.c      |  145 --
 fs/xfs/linux-2.6/xfs_vnode.h      |   72 +-
 fs/xfs/quota/xfs_dquot.c          |   39 +-
 fs/xfs/quota/xfs_dquot.h          |    4 +-
 fs/xfs/quota/xfs_dquot_item.c     |   45 +-
 fs/xfs/quota/xfs_qm.c             |   57 +-
 fs/xfs/quota/xfs_qm.h             |    3 +-
 fs/xfs/quota/xfs_qm_bhv.c         |    5 +-
 fs/xfs/quota/xfs_qm_syscalls.c    |  151 +-
 fs/xfs/support/debug.c            |   39 +-
 fs/xfs/support/debug.h            |    2 -
 fs/xfs/support/ktrace.c           |    9 +-
 fs/xfs/xfs.h                      |    2 +-
 fs/xfs/xfs_acl.c                  |    2 +-
 fs/xfs/xfs_ag.h                   |   15 +-
 fs/xfs/xfs_alloc.c                |  264 ++-
 fs/xfs/xfs_alloc.h                |   27 +-
 fs/xfs/xfs_alloc_btree.c          | 2387 ++++---------------------
 fs/xfs/xfs_alloc_btree.h          |  107 +-
 fs/xfs/xfs_arch.h                 |   39 +-
 fs/xfs/xfs_bit.h                  |    3 +-
 fs/xfs/xfs_bmap.c                 |  410 +++--
 fs/xfs/xfs_bmap.h                 |   72 +-
 fs/xfs/xfs_bmap_btree.c           | 2617 +++++----------------------
 fs/xfs/xfs_bmap_btree.h           |  171 +--
 fs/xfs/xfs_btree.c                | 3596 ++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_btree.h                |  392 +++--
 fs/xfs/xfs_btree_trace.c          |  249 +++
 fs/xfs/xfs_btree_trace.h          |  116 ++
 fs/xfs/xfs_buf_item.c             |   45 +-
 fs/xfs/xfs_clnt.h                 |  105 --
 fs/xfs/xfs_da_btree.h             |   24 +-
 fs/xfs/xfs_dfrag.c                |    8 +-
 fs/xfs/xfs_dfrag.h                |    2 +-
 fs/xfs/xfs_dinode.h               |  148 +-
 fs/xfs/xfs_dir2_sf.h              |    7 -
 fs/xfs/xfs_dmops.c                |    5 +-
 fs/xfs/xfs_error.c                |   15 -
 fs/xfs/xfs_error.h                |   12 +-
 fs/xfs/xfs_extfree_item.c         |   45 +-
 fs/xfs/xfs_fs.h                   |   22 +-
 fs/xfs/xfs_fsops.c                |   30 +-
 fs/xfs/xfs_ialloc.c               |  449 +++--
 fs/xfs/xfs_ialloc.h               |   31 +-
 fs/xfs/xfs_ialloc_btree.c         | 2193 +++--------------------
 fs/xfs/xfs_ialloc_btree.h         |  111 +-
 fs/xfs/xfs_iget.c                 |  735 ++++----
 fs/xfs/xfs_imap.h                 |   40 -
 fs/xfs/xfs_inode.c                |  587 ++-----
 fs/xfs/xfs_inode.h                |  375 +++--
 fs/xfs/xfs_inode_item.c           |   45 +-
 fs/xfs/xfs_inode_item.h           |   41 +-
 fs/xfs/xfs_iomap.c                |   28 +-
 fs/xfs/xfs_itable.c               |  102 +-
 fs/xfs/xfs_itable.h               |   14 +
 fs/xfs/xfs_log.c                  |   81 +-
 fs/xfs/xfs_log.h                  |    4 +
 fs/xfs/xfs_log_priv.h             |   48 +-
 fs/xfs/xfs_log_recover.c          |  416 ++---
 fs/xfs/xfs_mount.c                |   81 +-
 fs/xfs/xfs_mount.h                |   73 +-
 fs/xfs/xfs_qmops.c                |    5 +-
 fs/xfs/xfs_quota.h                |    8 +-
 fs/xfs/xfs_rename.c               |   61 +-
 fs/xfs/xfs_rtalloc.c              |   41 +-
 fs/xfs/xfs_rw.c                   |    2 +-
 fs/xfs/xfs_sb.h                   |  167 +-
 fs/xfs/xfs_trans.c                |   22 +-
 fs/xfs/xfs_trans.h                |  322 ++--
 fs/xfs/xfs_trans_ail.c            |  362 +++--
 fs/xfs/xfs_trans_buf.c            |    7 +-
 fs/xfs/xfs_trans_inode.c          |   30 +-
 fs/xfs/xfs_trans_item.c           |   10 +
 fs/xfs/xfs_trans_priv.h           |   98 +-
 fs/xfs/xfs_utils.c                |   12 +-
 fs/xfs/xfs_vfsops.c               |  757 --------
 fs/xfs/xfs_vfsops.h               |   16 -
 fs/xfs/xfs_vnodeops.c             |  354 +---
 fs/xfs/xfs_vnodeops.h             |   10 +-
 include/linux/fs.h                |   10 +
 kernel/sysctl_check.c             |    1 -
 112 files changed, 10496 insertions(+), 12850 deletions(-)
 create mode 100644 fs/xfs/linux-2.6/xfs_ioctl.h
 create mode 100644 fs/xfs/linux-2.6/xfs_sync.c
 create mode 100644 fs/xfs/linux-2.6/xfs_sync.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_vfs.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_vnode.c
 create mode 100644 fs/xfs/xfs_btree_trace.c
 create mode 100644 fs/xfs/xfs_btree_trace.h
 delete mode 100644 fs/xfs/xfs_clnt.h
 delete mode 100644 fs/xfs/xfs_imap.h
 delete mode 100644 fs/xfs/xfs_vfsops.c
 delete mode 100644 fs/xfs/xfs_vfsops.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
