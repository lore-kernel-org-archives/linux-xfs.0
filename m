Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master, updated. v3.18-rc2
Message-Id: <20141029013251.DB1B37F3F@oss.sgi.com>
Date: Tue, 28 Oct 2014 20:32:51 -0500 (CDT)
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
  d3dc366 Merge branch 'for-3.18/core' of git://git.kernel.dk/linux-block
  6889e78 Merge branch 'xfs-misc-fixes-for-3.18-3' into for-next
  a8b1ee8 xfs: fix agno increment in xfs_inumbers() loop
  5217793 xfs: xfs_iflush_done checks the wrong log item callback
  da5f109 xfs: flush the range before zero range conversion
  07d0868 xfs: restore buffer_head unwritten bit on ioend cancel
  5cca3f6 xfs: check for null dquot in xfs_quota_calc_throttle()
  04dd1a0 xfs: fix crc field handling in xfs_sb_to/from_disk
  6ee49a2 xfs: don't send null bp to xfs_trans_brelse()
  ce57bcf xfs: check for inode size overflow in xfs_new_eof()
  a872703 xfs: only set extent size hint when asked
  9336e3a xfs: project id inheritance is a directory only flag
  e076b0f xfs: kill time.h
  b1d6cc0 xfs: compat_xfs_bstat does not have forkoff
  75e58ce Merge branch 'xfs-buf-iosubmit' into for-next
  8c15612 xfs: simplify xfs_zero_remaining_bytes
  ba37267 xfs: check xfs_buf_read_uncached returns correctly
  595bff7 xfs: introduce xfs_buf_submit[_wait]
  8b13197 xfs: kill xfs_bioerror_relse
  2718775 xfs: xfs_bioerror can die.
  8dac392 xfs: kill xfs_bdstrat_cb
  61be9c5 xfs: rework xfs_buf_bio_endio error handling
  e8aaba9 xfs: xfs_buf_ioend and xfs_buf_iodone_work duplicate functionality
  e11bb80 xfs: synchronous buffer IO needs a reference
  cf53e99 xfs: Don't use xfs_buf_iowait in the delwri buffer code
  a870fe6d xfs: force the log before shutting down
  bd438f8 Merge branch 'xfs-sparse-fixes' into for-next
  b972d07 xfs: annotate user variables passed as void
  e3aed1a xfs: xfs_kset should be static 
  bf1ed38 xfs: xfs_qm_dquot_isolate needs locking annotations for sparse
  e68ed77 xfs: fix use of agi_newino in finobt lookup
  2f43bbd Merge branch 'xfs-trans-recover-cleanup' into for-next
  b818cca xfs: refactor recovery transaction start handling
  7656066 xfs: reorganise transaction recovery item code
  88b863d xfs: fix double free in xlog_recover_commit_trans
  e9131e5 xfs: recovery of XLOG_UNMOUNT_TRANS leaks memory
  eeb1168 xfs: refactor xlog_recover_process_data()
  33044dc Merge branch 'xfs-misc-fixes-for-3.18-2' into for-next
  2ebff7b xfs: flush entire last page of old EOF on truncate up
  7abbb8f xfs: xfs_swap_extent_flush can be static
  02cc187 xfs: xfs_buf_write_fail_rl_state can be static
  ea95961 xfs: xfs_rtget_summary can be static
  e3cf179 xfs: remove second xfs_quota.h inclusion in xfs_icache.c
  fb04013 xfs: don't ASSERT on corrupt ftype
  8af3dcd xfs: xlog_cil_force_lsn doesn't always wait correctly
  f6d31f4 Merge branch 'xfs-shift-extents-rework' into for-next
  8b5279e xfs: only writeback and truncate pages for the freed range
  f71721d xfs: writeback and inval. file range to be shifted by collapse
  a979bdf xfs: refactor single extent shift into xfs_bmse_shift_one() helper
  ddb19e3 xfs: refactor shift-by-merge into xfs_bmse_merge() helper
  2c845f5 xfs: track collapse via file offset rather than extent index
  0d085a5 xfs: ensure WB_SYNC_ALL writeback handles partial pages correctly
  6d11fb4 Merge branch 'for-linus' into for-3.18/core
  a4241ae Merge branch 'xfs-misc-fixes-for-3.18-1' into for-next
  ab6978c xfs: remove rbpp check from xfs_rtmodify_summary_int
  afabfd3 xfs: combine xfs_rtmodify_summary and xfs_rtget_summary
  b16ed7c xfs: combine xfs_dir_canenter into xfs_dir_createname
  94f3cad xfs: check resblks before calling xfs_dir_canenter
  970fd3f xfs: deduplicate xlog_do_recovery_pass()
  59f9c00 xfs: lseek: the "whence" argument is called "whence"
  49c6959 xfs: combine xfs_seek_hole & xfs_seek_data
  2e22717 xfs: export log_recovery_delay to delay mount time log recovery
  65b6573 xfs: add debug sysfs attribute set
  e1b0572 xfs: add a few more verifier tests
  8018ec0 xfs: mark all internal workqueues as freezable
  ff9ea32 block, bdi: an active gendisk always has a request_queue associated with it
  41b9d72 xfs: trim eofblocks before collapse range
  1669a8c xfs: xfs_file_collapse_range is delalloc challenged
  ca446d8 xfs: don't log inode unless extent shift makes extent modifications
  7d4ea3c xfs: use ranged writeback and invalidation for direct IO
  834ffca xfs: don't zero partial page cache pages during O_DIRECT writes
  85e584d xfs: don't zero partial page cache pages during O_DIRECT writes
  22e757a xfs: don't dirty buffers beyond EOF
      from  52addcf9d6669fa439387610bc65c92fa0980cef (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit d3dc366bbaf07c125561e90d6da4bb147741101a
Merge: 511c41d e19a8a0
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Oct 18 11:53:51 2014 -0700

    Merge branch 'for-3.18/core' of git://git.kernel.dk/linux-block
    
    Pull core block layer changes from Jens Axboe:
     "This is the core block IO pull request for 3.18.  Apart from the new
      and improved flush machinery for blk-mq, this is all mostly bug fixes
      and cleanups.
    
       - blk-mq timeout updates and fixes from Christoph.
    
       - Removal of REQ_END, also from Christoph.  We pass it through the
         ->queue_rq() hook for blk-mq instead, freeing up one of the request
         bits.  The space was overly tight on 32-bit, so Martin also killed
         REQ_KERNEL since it's no longer used.
    
       - blk integrity updates and fixes from Martin and Gu Zheng.
    
       - Update to the flush machinery for blk-mq from Ming Lei.  Now we
         have a per hardware context flush request, which both cleans up the
         code should scale better for flush intensive workloads on blk-mq.
    
       - Improve the error printing, from Rob Elliott.
    
       - Backing device improvements and cleanups from Tejun.
    
       - Fixup of a misplaced rq_complete() tracepoint from Hannes.
    
       - Make blk_get_request() return error pointers, fixing up issues
         where we NULL deref when a device goes bad or missing.  From Joe
         Lawrence.
    
       - Prep work for drastically reducing the memory consumption of dm
         devices from Junichi Nomura.  This allows creating clone bio sets
         without preallocating a lot of memory.
    
       - Fix a blk-mq hang on certain combinations of queue depths and
         hardware queues from me.
    
       - Limit memory consumption for blk-mq devices for crash dump
         scenarios and drivers that use crazy high depths (certain SCSI
         shared tag setups).  We now just use a single queue and limited
         depth for that"
    
    * 'for-3.18/core' of git://git.kernel.dk/linux-block: (58 commits)
      block: Remove REQ_KERNEL
      blk-mq: allocate cpumask on the home node
      bio-integrity: remove the needless fail handle of bip_slab creating
      block: include func name in __get_request prints
      block: make blk_update_request print prefix match ratelimited prefix
      blk-merge: don't compute bi_phys_segments from bi_vcnt for cloned bio
      block: fix alignment_offset math that assumes io_min is a power-of-2
      blk-mq: Make bt_clear_tag() easier to read
      blk-mq: fix potential hang if rolling wakeup depth is too high
      block: add bioset_create_nobvec()
      block: use bio_clone_fast() in blk_rq_prep_clone()
      block: misplaced rq_complete tracepoint
      sd: Honor block layer integrity handling flags
      block: Replace strnicmp with strncasecmp
      block: Add T10 Protection Information functions
      block: Don't merge requests if integrity flags differ
      block: Integrity checksum flag
      block: Relocate bio integrity flags
      block: Add a disk flag to block integrity profile
      block: Add prefix to block integrity profile flags
      ...

commit 6d11fb454b161a4565c57be6f1c5527235741003
Merge: b207892 8b95741
Author: Jens Axboe <axboe@fb.com>
Date:   Mon Sep 22 11:57:32 2014 -0600

    Merge branch 'for-linus' into for-3.18/core
    
    Moving patches from for-linus to 3.18 instead, pull in this changes
    that will go to Linus today.

commit ff9ea323816dc1c8ac7144afd4eab3ac97704430
Author: Tejun Heo <tj@kernel.org>
Date:   Mon Sep 8 08:03:56 2014 +0900

    block, bdi: an active gendisk always has a request_queue associated with it
    
    bdev_get_queue() returns the request_queue associated with the
    specified block_device.  blk_get_backing_dev_info() makes use of
    bdev_get_queue() to determine the associated bdi given a block_device.
    
    All the callers of bdev_get_queue() including
    blk_get_backing_dev_info() assume that bdev_get_queue() may return
    NULL and implement NULL handling; however, bdev_get_queue() requires
    the passed in block_device is opened and attached to its gendisk.
    Because an active gendisk always has a valid request_queue associated
    with it, bdev_get_queue() can never return NULL and neither can
    blk_get_backing_dev_info().
    
    Make it clear that neither of the two functions can return NULL and
    remove NULL handling from all the callers.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: Chris Mason <clm@fb.com>
    Cc: Dave Chinner <david@fromorbit.com>
    Signed-off-by: Jens Axboe <axboe@fb.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/kmem.c                 |   1 -
 fs/xfs/libxfs/xfs_alloc.c     |   4 +
 fs/xfs/libxfs/xfs_bmap.c      | 371 +++++++++++++++--------
 fs/xfs/libxfs/xfs_bmap.h      |   7 +-
 fs/xfs/libxfs/xfs_da_btree.c  |   3 +-
 fs/xfs/libxfs/xfs_da_format.c |   1 -
 fs/xfs/libxfs/xfs_dir2.c      |  67 +---
 fs/xfs/libxfs/xfs_dir2.h      |   2 +-
 fs/xfs/libxfs/xfs_ialloc.c    |   7 +-
 fs/xfs/libxfs/xfs_rtbitmap.c  |  49 ++-
 fs/xfs/libxfs/xfs_sb.c        |   7 +
 fs/xfs/time.h                 |  36 ---
 fs/xfs/xfs_aops.c             |  84 ++++-
 fs/xfs/xfs_bmap_util.c        | 120 ++++----
 fs/xfs/xfs_buf.c              | 357 +++++++++++-----------
 fs/xfs/xfs_buf.h              |  15 +-
 fs/xfs/xfs_buf_item.c         |  10 +-
 fs/xfs/xfs_file.c             | 205 +++++--------
 fs/xfs/xfs_fsops.c            |  11 +-
 fs/xfs/xfs_globals.c          |   4 +
 fs/xfs/xfs_icache.c           |   1 -
 fs/xfs/xfs_inode.c            |  34 ++-
 fs/xfs/xfs_inode.h            |   2 +-
 fs/xfs/xfs_inode_item.c       |   2 +-
 fs/xfs/xfs_ioctl.c            |  28 +-
 fs/xfs/xfs_ioctl32.c          |   2 +
 fs/xfs/xfs_ioctl32.h          |   3 +-
 fs/xfs/xfs_iomap.c            |   4 +-
 fs/xfs/xfs_iops.c             |  30 ++
 fs/xfs/xfs_itable.c           |   3 +-
 fs/xfs/xfs_linux.h            |   6 +-
 fs/xfs/xfs_log.c              |  59 ++--
 fs/xfs/xfs_log_cil.c          |  47 ++-
 fs/xfs/xfs_log_recover.c      | 689 ++++++++++++++++++++++--------------------
 fs/xfs/xfs_mount.c            |  58 ++--
 fs/xfs/xfs_mru_cache.c        |   3 +-
 fs/xfs/xfs_qm.c               |   1 +
 fs/xfs/xfs_rtalloc.c          |  85 +-----
 fs/xfs/xfs_rtalloc.h          |   4 +
 fs/xfs/xfs_super.c            |  39 ++-
 fs/xfs/xfs_symlink.c          |   8 +-
 fs/xfs/xfs_sysctl.h           |   5 +
 fs/xfs/xfs_sysfs.c            |  74 +++++
 fs/xfs/xfs_sysfs.h            |   1 +
 fs/xfs/xfs_trace.h            |   3 +-
 fs/xfs/xfs_trans_buf.c        |  16 +-
 fs/xfs/xfs_trans_inode.c      |   2 +-
 47 files changed, 1399 insertions(+), 1171 deletions(-)
 delete mode 100644 fs/xfs/time.h


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
