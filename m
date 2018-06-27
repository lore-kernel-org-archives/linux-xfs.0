Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964840AbeF0SYW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Jun 2018 14:24:22 -0400
Date: Wed, 27 Jun 2018 11:24:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: 4.18 fixes, part 1
Message-ID: <20180627182421.GE5711@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here are some patches for 4.18 to fix regressions, accounting problems,
overflow problems, and to strengthen metadata validation to prevent
corruption.

This series has been run through a full xfstests run over the weekend
and through a quick xfstests run against this morning's master, with no
major failures reported.

--D

The following changes since commit ce397d215ccd07b8ae3f71db689aedb85d56ab40:

  Linux 4.18-rc1 (2018-06-17 08:04:49 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.18-fixes-2

for you to fetch changes up to d8cb5e42378918e00eda58792f3ab86dd1e7d214:

  xfs: fix fdblocks accounting w/ RMAPBT per-AG reservation (2018-06-24 12:00:12 -0700)

----------------------------------------------------------------
Changes since last update:
- More metadata validation strengthening to prevent crashes.
- Fix extent offset overflow problem when insert_range on a 512b block fs
- Fix some off-by-one errors in the realtime fsmap code
- Fix some math errors in the default resblks calculation when free space
  is low
- Fix a problem where stale page contents are exposed via mmap read
  after a zero_range at eof
- Fix accounting problems with per-ag reservations causing statfs
  reports to vary incorrectly

----------------------------------------------------------------
Christoph Hellwig (1):
      xfs: simplify xfs_bmap_punch_delalloc_range

Darrick J. Wong (8):
      xfs: allow empty transactions while frozen
      xfs: don't trip over negative free space in xfs_reserve_blocks
      xfs: don't allow insert-range to shift extents past the maximum offset
      xfs: recheck reflink state after grabbing ILOCK_SHARED for a write
      xfs: fix uninitialized field in rtbitmap fsmap backend
      xfs: fix off-by-one error in xfs_rtalloc_query_range
      xfs: ensure post-EOF zeroing happens after zeroing part of a file
      xfs: fix fdblocks accounting w/ RMAPBT per-AG reservation

Dave Chinner (2):
      xfs: More robust inode extent count validation
      xfs: xfs_iflush_abort() can be called twice on cluster writeback failure

 fs/xfs/libxfs/xfs_ag_resv.c   |  31 ++++++++++--
 fs/xfs/libxfs/xfs_bmap.c      |  26 +++++++++++
 fs/xfs/libxfs/xfs_bmap.h      |   2 +
 fs/xfs/libxfs/xfs_format.h    |   5 ++
 fs/xfs/libxfs/xfs_inode_buf.c |  76 ++++++++++++++++++------------
 fs/xfs/libxfs/xfs_rtbitmap.c  |   4 +-
 fs/xfs/xfs_bmap_util.c        | 106 +++++++++++++++++++++---------------------
 fs/xfs/xfs_fsmap.c            |   4 +-
 fs/xfs/xfs_fsops.c            |   2 +-
 fs/xfs/xfs_inode.c            |  57 +++++++++--------------
 fs/xfs/xfs_iomap.c            |  15 +++++-
 fs/xfs/xfs_trans.c            |   7 ++-
 12 files changed, 205 insertions(+), 130 deletions(-)
