Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 810277F4E
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 20:37:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5D0128F8052
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 18:37:48 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5srLKGQagg82FkUm for <xfs@oss.sgi.com>;
	Sun, 12 Oct 2014 18:37:45 -0700 (PDT)
Date: Mon, 13 Oct 2014 12:37:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 3.18-rc1
Message-ID: <20141013013715.GD4503@dastard>
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

Can you please pull the current XFS updates from the tree below?
The changes outlined in the tag description include everything that
is not in your tree, but I has a question about that because there
are commits in the branch that are already in your tree.

i.e. I have generated this pull-req from the base tree I've been working
on (3.17-rc2) but there have already been commits merged into a more
recent upstream tree (3.17-rc4) in this tree. When I generate the
pull request from the underlying 3.17-rc2 branch, it includes all
those commits, both in the summary and the diffstat. If I base the
pull request off 3.17, the base commit is the last one that was
merged into your tree, and the diffstat and commit list reflect
that.

So my question is this: Which tree should I generate the pull
request from? I flipped a coin an generated this one from 3.17-rc2,
but if you'd prefer to see just the commits/diffstat that aren't in
your tree, let me know and I'll do it differently next time....

-Dave.

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs tags/xfs-for-linus-3.18-rc1

for you to fetch changes up to 6889e783cd68b79f8330ad4d10a2571c67c3f7df:

  Merge branch 'xfs-misc-fixes-for-3.18-3' into for-next (2014-10-13 10:22:45 +1100)

----------------------------------------------------------------

xfs: update for 3.18-rc1

This update contains:
o various cleanups
o log recovery debug hooks
o seek hole/data implementation merge
o extent shift rework to fix collapse range bugs
o various sparse warning fixes
o log recovery transaction processing rework to fix use after free bugs
o metadata buffer IO infrastructuer rework to ensure all buffers under IO have
  valid reference counts
o various fixes for ondisk flags, writeback and zero range corner cases

----------------------------------------------------------------
Brian Foster (13):
      xfs: don't log inode unless extent shift makes extent modifications
      xfs: trim eofblocks before collapse range
      xfs: mark all internal workqueues as freezable
      xfs: add debug sysfs attribute set
      xfs: export log_recovery_delay to delay mount time log recovery
      xfs: track collapse via file offset rather than extent index
      xfs: refactor shift-by-merge into xfs_bmse_merge() helper
      xfs: refactor single extent shift into xfs_bmse_shift_one() helper
      xfs: writeback and inval. file range to be shifted by collapse
      xfs: only writeback and truncate pages for the freed range
      xfs: check for inode size overflow in xfs_new_eof()
      xfs: restore buffer_head unwritten bit on ioend cancel
      xfs: flush the range before zero range conversion

Chris Mason (1):
      xfs: don't zero partial page cache pages during O_DIRECT writes

Christoph Hellwig (1):
      xfs: simplify xfs_zero_remaining_bytes

Dave Chinner (39):
      xfs: don't dirty buffers beyond EOF
      xfs: don't zero partial page cache pages during O_DIRECT writes
      xfs: use ranged writeback and invalidation for direct IO
      xfs: xfs_file_collapse_range is delalloc challenged
      Merge branch 'xfs-misc-fixes-for-3.18-1' into for-next
      xfs: ensure WB_SYNC_ALL writeback handles partial pages correctly
      Merge branch 'xfs-shift-extents-rework' into for-next
      xfs: xlog_cil_force_lsn doesn't always wait correctly
      xfs: xfs_buf_write_fail_rl_state can be static
      xfs: xfs_swap_extent_flush can be static
      xfs: flush entire last page of old EOF on truncate up
      Merge branch 'xfs-misc-fixes-for-3.18-2' into for-next
      xfs: refactor xlog_recover_process_data()
      xfs: recovery of XLOG_UNMOUNT_TRANS leaks memory
      xfs: fix double free in xlog_recover_commit_trans
      xfs: reorganise transaction recovery item code
      xfs: refactor recovery transaction start handling
      Merge branch 'xfs-trans-recover-cleanup' into for-next
      xfs: fix use of agi_newino in finobt lookup
      xfs: xfs_qm_dquot_isolate needs locking annotations for sparse
      xfs: xfs_kset should be static
      xfs: annotate user variables passed as void
      Merge branch 'xfs-sparse-fixes' into for-next
      xfs: force the log before shutting down
      xfs: Don't use xfs_buf_iowait in the delwri buffer code
      xfs: synchronous buffer IO needs a reference
      xfs: xfs_buf_ioend and xfs_buf_iodone_work duplicate functionality
      xfs: rework xfs_buf_bio_endio error handling
      xfs: kill xfs_bdstrat_cb
      xfs: xfs_bioerror can die.
      xfs: kill xfs_bioerror_relse
      xfs: introduce xfs_buf_submit[_wait]
      xfs: check xfs_buf_read_uncached returns correctly
      Merge branch 'xfs-buf-iosubmit' into for-next
      xfs: compat_xfs_bstat does not have forkoff
      xfs: kill time.h
      xfs: project id inheritance is a directory only flag
      xfs: only set extent size hint when asked
      Merge branch 'xfs-misc-fixes-for-3.18-3' into for-next

Eric Sandeen (13):
      xfs: add a few more verifier tests
      xfs: combine xfs_seek_hole & xfs_seek_data
      xfs: lseek: the "whence" argument is called "whence"
      xfs: deduplicate xlog_do_recovery_pass()
      xfs: check resblks before calling xfs_dir_canenter
      xfs: combine xfs_dir_canenter into xfs_dir_createname
      xfs: combine xfs_rtmodify_summary and xfs_rtget_summary
      xfs: remove rbpp check from xfs_rtmodify_summary_int
      xfs: don't ASSERT on corrupt ftype
      xfs: don't send null bp to xfs_trans_brelse()
      xfs: fix crc field handling in xfs_sb_to/from_disk
      xfs: check for null dquot in xfs_quota_calc_throttle()
      xfs: fix agno increment in xfs_inumbers() loop

Fabian Frederick (1):
      xfs: remove second xfs_quota.h inclusion in xfs_icache.c

Fengguang Wu (1):
      xfs: xfs_rtget_summary can be static

Mark Tinguely (1):
      xfs: xfs_iflush_done checks the wrong log item callback

 fs/xfs/kmem.c                 |    1 -
 fs/xfs/libxfs/xfs_alloc.c     |    4 +
 fs/xfs/libxfs/xfs_bmap.c      |  371 ++++++++++++++--------
 fs/xfs/libxfs/xfs_bmap.h      |    7 +-
 fs/xfs/libxfs/xfs_da_btree.c  |    3 +-
 fs/xfs/libxfs/xfs_da_format.c |    1 -
 fs/xfs/libxfs/xfs_dir2.c      |   67 +---
 fs/xfs/libxfs/xfs_dir2.h      |    2 +-
 fs/xfs/libxfs/xfs_ialloc.c    |    7 +-
 fs/xfs/libxfs/xfs_rtbitmap.c  |   49 ++-
 fs/xfs/libxfs/xfs_sb.c        |    7 +
 fs/xfs/time.h                 |   36 ---
 fs/xfs/xfs_aops.c             |   84 ++++-
 fs/xfs/xfs_bmap_util.c        |  120 +++----
 fs/xfs/xfs_buf.c              |  355 ++++++++++-----------
 fs/xfs/xfs_buf.h              |   15 +-
 fs/xfs/xfs_buf_item.c         |   10 +-
 fs/xfs/xfs_file.c             |  205 +++++-------
 fs/xfs/xfs_fsops.c            |   11 +-
 fs/xfs/xfs_globals.c          |    4 +
 fs/xfs/xfs_icache.c           |    1 -
 fs/xfs/xfs_inode.c            |   34 +-
 fs/xfs/xfs_inode.h            |    2 +-
 fs/xfs/xfs_inode_item.c       |    2 +-
 fs/xfs/xfs_ioctl.c            |   28 +-
 fs/xfs/xfs_ioctl32.c          |    2 +
 fs/xfs/xfs_ioctl32.h          |    3 +-
 fs/xfs/xfs_iomap.c            |    4 +-
 fs/xfs/xfs_iops.c             |   30 ++
 fs/xfs/xfs_itable.c           |    3 +-
 fs/xfs/xfs_linux.h            |    6 +-
 fs/xfs/xfs_log.c              |   59 ++--
 fs/xfs/xfs_log_cil.c          |   47 ++-
 fs/xfs/xfs_log_recover.c      |  689 +++++++++++++++++++++--------------------
 fs/xfs/xfs_mount.c            |   58 ++--
 fs/xfs/xfs_mru_cache.c        |    3 +-
 fs/xfs/xfs_qm.c               |    1 +
 fs/xfs/xfs_rtalloc.c          |   85 +----
 fs/xfs/xfs_rtalloc.h          |    4 +
 fs/xfs/xfs_super.c            |   39 ++-
 fs/xfs/xfs_symlink.c          |    8 +-
 fs/xfs/xfs_sysctl.h           |    5 +
 fs/xfs/xfs_sysfs.c            |   74 +++++
 fs/xfs/xfs_sysfs.h            |    1 +
 fs/xfs/xfs_trace.h            |    3 +-
 fs/xfs/xfs_trans_buf.c        |   16 +-
 fs/xfs/xfs_trans_inode.c      |    2 +-
 47 files changed, 1399 insertions(+), 1169 deletions(-)
 delete mode 100644 fs/xfs/time.h
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
