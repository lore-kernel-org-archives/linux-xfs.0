Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2091CC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 23:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiDYXU0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 19:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbiDYXUZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 19:20:25 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF17B1A3BC
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 16:17:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7DE895345BD
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 09:17:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nj7xC-004XF3-NH
        for linux-xfs@vger.kernel.org; Tue, 26 Apr 2022 09:17:14 +1000
Date:   Tue, 26 Apr 2022 09:17:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs: for-next tree updated to a44a027a8b2a
Message-ID: <20220425231714.GK1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62672bfc
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=NEAV23lmAAAA:8 a=7-415B0cAAAA:8
        a=Ijo-PXENOAVyLxYNxYIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I just pushed out a new for-next branch for the XFS tree. It
contains:

- pending fixes for 5.18
- various miscellaneous fixes
- xlog_write() rework
- conversions to unsigned for trace_printk flags
- large on-disk extent counts

This all passes my local regression testing, though further smoke
testing in different environments would be appreaciated.

I haven't pulled in fixes from late last week yet - I'll work
through those in the next couple of days to get them into the tree
as well.

If I've missed anything you were expecting to see in this update,
let me know and I'll get them sorted for the next update.

Cheers,

Dave.

---------------------------------------------------------------

Head commit:

a44a027a8b2a Merge tag 'large-extent-counters-v9' of https://github.com/chandanr/linux into xfs-5.19-for-next

----------------------------------------------------------------
Chandan Babu R (19):
      xfs: Move extent count limits to xfs_format.h
      xfs: Define max extent length based on on-disk format definition
      xfs: Introduce xfs_iext_max_nextents() helper
      xfs: Use xfs_extnum_t instead of basic data types
      xfs: Introduce xfs_dfork_nextents() helper
      xfs: Use basic types to define xfs_log_dinode's di_nextents and di_anextents
      xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
      xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs feature bit
      xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
      xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
      xfs: Use uint64_t to count maximum blocks that can be used by BMBT
      xfs: Introduce macros to represent new maximum extent counts for data/attr forks
      xfs: Replace numbered inode recovery error messages with descriptive ones
      xfs: Introduce per-inode 64-bit extent counters
      xfs: Directory's data fork extent counter can never overflow
      xfs: Conditionally upgrade existing inodes to use large extent counters
      xfs: Decouple XFS_IBULK flags from XFS_IWALK flags
      xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
      xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags

Christoph Hellwig (2):
      xfs: change the type of ic_datap
      xfs: remove xlog_verify_dest_ptr

Darrick J. Wong (3):
      xfs: pass explicit mount pointer to rtalloc query functions
      xfs: recalculate free rt extents after log recovery
      xfs: use a separate frextents counter for rt extent reservations

Dave Chinner (36):
      xfs: convert buffer flags to unsigned.
      xfs: reorder iunlink remove operation in xfs_ifree
      xfs: factor out the CIL transaction header building
      xfs: only CIL pushes require a start record
      xfs: embed the xlog_op_header in the unmount record
      xfs: embed the xlog_op_header in the commit record
      xfs: log tickets don't need log client id
      xfs: move log iovec alignment to preparation function
      xfs: reserve space and initialise xlog_op_header in item formatting
      xfs: log ticket region debug is largely useless
      xfs: pass lv chain length into xlog_write()
      xfs: introduce xlog_write_full()
      xfs: introduce xlog_write_partial()
      xfs: xlog_write() no longer needs contwr state
      xfs: xlog_write() doesn't need optype anymore
      xfs: CIL context doesn't need to count iovecs
      xfs: convert attr type flags to unsigned.
      xfs: convert scrub type flags to unsigned.
      xfs: convert bmap extent type flags to unsigned.
      xfs: convert bmapi flags to unsigned.
      xfs: convert AGF log flags to unsigned.
      xfs: convert AGI log flags to unsigned.
      xfs: convert btree buffer log flags to unsigned.
      xfs: convert buffer log item flags to unsigned.
      xfs: convert da btree operations flags to unsigned.
      xfs: convert dquot flags to unsigned.
      xfs: convert log item tracepoint flags to unsigned.
      xfs: convert inode lock flags to unsigned.
      xfs: convert ptag flags to unsigned.
      xfs: convert quota options flags to unsigned.
      xfs: convert shutdown reasons to unsigned.
      xfs: convert log ticket and iclog flags to unsigned.
      Merge branch 'guilt/5.19-miscellaneous' into xfs-5.19-for-next
      Merge branch 'guilt/xfs-unsigned-flags-5.18' into xfs-5.19-for-next
      Merge branch 'guilt/xlog-write-rework' into xfs-5.19-for-next
      Merge tag 'large-extent-counters-v9' of https://github.com/chandanr/linux into xfs-5.19-for-next

Jonathan Lassoff (2):
      xfs: Simplify XFS logging methods.
      xfs: Add XFS messages to printk index

Kaixu Xia (1):
      xfs: simplify local variable assignment in file write code

Matthew Wilcox (Oracle) (1):
      xfs: Use generic_file_open()

Tiezhu Yang (1):
      MAINTAINERS: update IOMAP FILESYSTEM LIBRARY and XFS FILESYSTEM

 MAINTAINERS                     |   3 -
 fs/xfs/libxfs/xfs_alloc.c       |  12 +-
 fs/xfs/libxfs/xfs_alloc.h       |   2 +-
 fs/xfs/libxfs/xfs_attr.c        |   3 +
 fs/xfs/libxfs/xfs_bmap.c        | 145 +++++++++-----------
 fs/xfs/libxfs/xfs_bmap.h        |  58 ++++----
 fs/xfs/libxfs/xfs_bmap_btree.c  |   9 +-
 fs/xfs/libxfs/xfs_btree.c       |  10 +-
 fs/xfs/libxfs/xfs_btree.h       |  26 ++--
 fs/xfs/libxfs/xfs_da_btree.h    |  17 +--
 fs/xfs/libxfs/xfs_da_format.h   |   9 +-
 fs/xfs/libxfs/xfs_dir2.c        |   8 ++
 fs/xfs/libxfs/xfs_format.h      | 180 ++++++++++++++++++-------
 fs/xfs/libxfs/xfs_fs.h          |  41 ++++--
 fs/xfs/libxfs/xfs_ialloc.c      |   8 +-
 fs/xfs/libxfs/xfs_ialloc.h      |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c   |  83 +++++++++---
 fs/xfs/libxfs/xfs_inode_fork.c  |  39 +++++-
 fs/xfs/libxfs/xfs_inode_fork.h  |  76 +++++++++--
 fs/xfs/libxfs/xfs_log_format.h  |  34 ++++-
 fs/xfs/libxfs/xfs_quota_defs.h  |  49 ++++---
 fs/xfs/libxfs/xfs_rtbitmap.c    |   9 +-
 fs/xfs/libxfs/xfs_sb.c          |  10 ++
 fs/xfs/libxfs/xfs_trans_resv.c  |  11 +-
 fs/xfs/libxfs/xfs_types.h       |  11 +-
 fs/xfs/scrub/bmap.c             |   2 +-
 fs/xfs/scrub/inode.c            |  20 +--
 fs/xfs/scrub/rtbitmap.c         |   9 +-
 fs/xfs/xfs_bmap_item.c          |   2 +
 fs/xfs/xfs_bmap_util.c          |  27 +++-
 fs/xfs/xfs_buf.c                |   6 +-
 fs/xfs/xfs_buf.h                |  42 +++---
 fs/xfs/xfs_buf_item.h           |  24 ++--
 fs/xfs/xfs_dquot.c              |   3 +
 fs/xfs/xfs_error.h              |  20 +--
 fs/xfs/xfs_file.c               |  24 ++--
 fs/xfs/xfs_fsmap.c              |   6 +-
 fs/xfs/xfs_fsops.c              |   7 +-
 fs/xfs/xfs_icache.c             |   9 +-
 fs/xfs/xfs_inode.c              | 104 ++++-----------
 fs/xfs/xfs_inode.h              |  29 ++--
 fs/xfs/xfs_inode_item.c         |  23 +++-
 fs/xfs/xfs_inode_item_recover.c | 141 ++++++++++++++------
 fs/xfs/xfs_ioctl.c              |   3 +
 fs/xfs/xfs_iomap.c              |  33 +++--
 fs/xfs/xfs_itable.c             |  15 ++-
 fs/xfs/xfs_itable.h             |   5 +-
 fs/xfs/xfs_iwalk.h              |   2 +-
 fs/xfs/xfs_log.c                | 766 +++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------
 fs/xfs/xfs_log.h                |  57 +++-----
 fs/xfs/xfs_log_cil.c            | 169 ++++++++++++++++--------
 fs/xfs/xfs_log_priv.h           |  55 ++------
 fs/xfs/xfs_message.c            |  58 ++++----
 fs/xfs/xfs_message.h            |  55 +++++---
 fs/xfs/xfs_mount.c              |  91 +++++++------
 fs/xfs/xfs_mount.h              |  32 +++--
 fs/xfs/xfs_reflink.c            |   5 +
 fs/xfs/xfs_rtalloc.c            |  41 ++++++
 fs/xfs/xfs_rtalloc.h            |   9 +-
 fs/xfs/xfs_super.c              |  18 ++-
 fs/xfs/xfs_symlink.c            |   5 -
 fs/xfs/xfs_trace.h              |  28 +---
 fs/xfs/xfs_trans.c              |  49 +++++--
 fs/xfs/xfs_trans.h              |  10 +-
 64 files changed, 1585 insertions(+), 1274 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
