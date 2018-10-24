Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:23872 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbeJXLtP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Oct 2018 07:49:15 -0400
Date: Wed, 24 Oct 2018 11:00:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: 4.20 merge
Message-ID: <20181024000022.GP18822@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: djwong@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net

Hi Linus,

Can you please pull the XFS 4.20 update from the tag listed below?
There's not a huge amount of change in this cycle - Darrick has been
out of action for a couple of months (hence me sending the last few
pull requests), so we decided a quiet cycle mainly focussed on bug
fixes was a good idea. Darrick will take the helm again at the end of
this merge window.

The branch has applied cleanly to your current tree, so you
shouldn't see any problems with it.

FYI, I may be sending another update later in the cycle - there's a
pending rework of the clone/dedupe_file_range code that fixes
numerous bugs that is spread amongst the VFS, XFS and ocfs2 code. It
has been reviewed and tested, Al and I just need to work out the
details of the merge, so it may come from him rather than me.

Thanks!

-Dave.


The following changes since commit b39989009bdb84992915c9869f58094ed5becf10:

  xfs: fix data corruption w/ unaligned reflink ranges (2018-10-06 11:44:39 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux tags/xfs-4.20-merge-1

for you to fetch changes up to 96987eea537d6ccd98704a71958f9ba02da80843:

  xfs: cancel COW blocks before swapext (2018-10-18 17:21:55 +1100)

----------------------------------------------------------------
xfs: Changes for 4.20

- only support filesystems with unwritten extents
- add definition for statfs XFS magic number
- remove unused parameters around reflink code
- more debug for dangling delalloc extents
- cancel COW extents on extent swap targets
- fix quota stats output and clean up the code
- refactor some of the attribute code in preparation for parent pointers
- fix several buffer handling bugs

----------------------------------------------------------------
Adam Borowski (1):
      xfs: add a define for statfs magic to uapi

Allison Henderson (4):
      xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
      xfs: Add helper function xfs_attr_try_sf_addname
      xfs: Add attibute set and helper functions
      xfs: Add attibute remove and helper functions

Brian Foster (1):
      xfs: clear ail delwri queued bufs on unmount of shutdown fs

Carlos Maiolino (2):
      xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
      xfs: use offsetof() in place of offset macros for __xfsstats

Christoph Hellwig (8):
      xfs: remove XFS_IO_INVALID
      xfs: remove suport for filesystems without unwritten extent flag
      xfs: handle zeroing in xfs_file_iomap_begin_delay
      xfs: remove the unused shared argument to xfs_reflink_reserve_cow
      xfs: remove the unused trimmed argument from xfs_reflink_trim_around_shared
      xfs: fix fork selection in xfs_find_trim_cow_extent
      xfs: print dangling delalloc extents
      xfs: cancel COW blocks before swapext

Darrick J. Wong (3):
      xfs: xrep_findroot_block should reject root blocks with siblings
      xfs: always assign buffer verifiers when one is provided
      xfs: fix buffer state management in xrep_findroot_block

Dave Chinner (2):
      xfs: issue log message on user force shutdown
      xfs: fix use-after-free race in xfs_buf_rele

 fs/xfs/libxfs/xfs_attr.c       | 236 ++++++++++++++++++++++++-----------------
 fs/xfs/{ => libxfs}/xfs_attr.h |   2 +
 fs/xfs/libxfs/xfs_bmap.c       |  70 ++++++------
 fs/xfs/libxfs/xfs_bmap.h       |   1 +
 fs/xfs/libxfs/xfs_format.h     |   8 +-
 fs/xfs/libxfs/xfs_sb.c         |   5 +-
 fs/xfs/scrub/repair.c          | 128 +++++++++++++++++-----
 fs/xfs/scrub/scrub.c           |  13 ---
 fs/xfs/xfs_aops.c              |   4 +-
 fs/xfs/xfs_aops.h              |  14 ++-
 fs/xfs/xfs_bmap_util.c         |  61 ++---------
 fs/xfs/xfs_buf.c               | 109 +++++++++++++++----
 fs/xfs/xfs_buf.h               |   2 +
 fs/xfs/xfs_fsops.c             |  50 ++++-----
 fs/xfs/xfs_ioctl.c             |   8 --
 fs/xfs/xfs_iomap.c             |  53 ++++++---
 fs/xfs/xfs_reflink.c           |  33 +++---
 fs/xfs/xfs_reflink.h           |   4 +-
 fs/xfs/xfs_stats.c             |  52 ++++-----
 fs/xfs/xfs_stats.h             |  28 +----
 fs/xfs/xfs_super.c             |  38 ++++++-
 fs/xfs/xfs_trans.h             |   1 +
 fs/xfs/xfs_trans_ail.c         |  28 +++--
 fs/xfs/xfs_trans_buf.c         |  42 ++++++++
 include/uapi/linux/magic.h     |   1 +
 25 files changed, 608 insertions(+), 383 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_attr.h (97%)

-- 
Dave Chinner
david@fromorbit.com
