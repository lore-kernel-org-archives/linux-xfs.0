Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:15683 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726277AbeJDHyE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 03:54:04 -0400
Date: Thu, 4 Oct 2018 11:03:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: fixes for 4.19-rc6
Message-ID: <20181004010311.GU31060@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: gregkh@linuxfoundation.org
Cc: djwong@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net

Hi Greg,

Can you please pull the XFS from the tag listed below. It's a bit
bigger than that I'd like this late in the cycle, but we've had a
few challenges getting ourselves sorted out this cycle. Details
of the contents are in the pull-req output below. This has been be
run through xfstests over the past week, and merges against 4.19-rc6
cleanly.

FYI, there is likely to be one more XFS fix for this cycle - we've
just tracked down the source of a clone_file_range() data corruption
so I'll send that as a separate pullreq once Darrick's fix is
reviewed and tested.

Cheers,

Dave.

The following changes since commit 5b394b2ddf0347bef56e50c69a58773c94343ff3:

  Linux 4.19-rc1 (2018-08-26 14:11:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux tags/xfs-fixes-for-4.19-rc6

for you to fetch changes up to e55ec4ddbef9897199c307dfb23167e3801fdaf5:

  xfs: fix error handling in xfs_bmap_extents_to_btree (2018-10-01 08:11:07 +1000)

----------------------------------------------------------------
XFS fixes for 4.19-rc6

Accumlated regression and bug fixes for 4.19-rc6, including:

o make iomap correctly mark dirty pages for sub-page block sizes
o fix regression in handling extent-to-btree format conversion errors
o fix torn log wrap detection for new logs
o various corrupt inode detection fixes
o various delalloc state fixes
o cleanup all the missed transaction cancel cases missed from changes merged
  in 4.19-rc1
o fix lockdep false positive on transaction allocation
o fix locking and reference counting on buffer log items

----------------------------------------------------------------
Brian Foster (6):
      xfs: remove last of unnecessary xfs_defer_cancel() callers
      xfs: don't unlock invalidated buf on aborted tx commit
      xfs: clean up xfs_trans_brelse()
      xfs: refactor xfs_buf_log_item reference count handling
      xfs: remove invalid log recovery first/last cycle check
      iomap: set page dirty after partial delalloc on mkwrite

Christoph Hellwig (2):
      xfs: don't bring in extents in xfs_bmap_punch_delalloc_range
      xfs: skip delalloc COW blocks in xfs_reflink_end_cow

Darrick J. Wong (1):
      xfs: don't crash the vfs on a garbage inline symlink

Dave Chinner (3):
      xfs: avoid lockdep false positives in xfs_trans_alloc
      xfs: fix transaction leak in xfs_reflink_allocate_cow()
      xfs: fix error handling in xfs_bmap_extents_to_btree

Eric Sandeen (2):
      xfs: don't treat unknown di_flags2 as corruption in scrub
      xfs: validate inode di_forkoff

YueHaibing (1):
      xfs: remove duplicated include from alloc.c

 fs/iomap.c                      |   2 +-
 fs/xfs/libxfs/xfs_attr.c        |  28 +++-----
 fs/xfs/libxfs/xfs_attr_remote.c |  10 +--
 fs/xfs/libxfs/xfs_bmap.c        |  24 +++----
 fs/xfs/libxfs/xfs_format.h      |   2 +
 fs/xfs/libxfs/xfs_inode_buf.c   |  30 +++++++++
 fs/xfs/scrub/alloc.c            |   1 -
 fs/xfs/scrub/inode.c            |   4 +-
 fs/xfs/xfs_bmap_util.c          |  20 ++----
 fs/xfs/xfs_buf_item.c           | 119 ++++++++++++++++++----------------
 fs/xfs/xfs_buf_item.h           |   1 +
 fs/xfs/xfs_inode.c              |  10 +--
 fs/xfs/xfs_iops.c               |  12 +++-
 fs/xfs/xfs_log_recover.c        |  10 ---
 fs/xfs/xfs_reflink.c            | 137 ++++++++++++++++++++++++----------------
 fs/xfs/xfs_trace.h              |   1 -
 fs/xfs/xfs_trans.c              |  10 ++-
 fs/xfs/xfs_trans_buf.c          |  99 +++++++----------------------
 18 files changed, 256 insertions(+), 264 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
