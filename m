Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.17-rc3-27-g33044dc
Message-Id: <20140923133105.270587F55@oss.sgi.com>
Date: Tue, 23 Sep 2014 08:31:05 -0500 (CDT)
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
      from  a4241aebe924136d6838fd516da6daa727fcd728 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 33044dc408e6e6bb7f270c0a2e12598ef5592987
Merge: f6d31f4 2ebff7b
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue Sep 23 22:55:51 2014 +1000

    Merge branch 'xfs-misc-fixes-for-3.18-2' into for-next

commit f6d31f4b0462898896ba68e491662958ce37d095
Merge: a4241ae 8b5279e
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue Sep 23 15:51:14 2014 +1000

    Merge branch 'xfs-shift-extents-rework' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/libxfs/xfs_bmap.c      | 365 ++++++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_bmap.h      |   7 +-
 fs/xfs/libxfs/xfs_da_format.c |   1 -
 fs/xfs/xfs_aops.c             |  16 +-
 fs/xfs/xfs_bmap_util.c        |  56 ++++---
 fs/xfs/xfs_buf_item.c         |   2 +-
 fs/xfs/xfs_icache.c           |   1 -
 fs/xfs/xfs_iops.c             |  30 ++++
 fs/xfs/xfs_log_cil.c          |  47 ++++--
 fs/xfs/xfs_rtalloc.c          |   2 +-
 10 files changed, 360 insertions(+), 167 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
