Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:21735 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbdA0Tqs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Jan 2017 14:46:48 -0500
Date: Fri, 27 Jan 2017 11:43:41 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] xfs: updates for 4.10-rc6
Message-ID: <20170127194341.GA9134@birch.djwong.org>
References: <20170119234147.GM14033@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170119234147.GM14033@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>

Hi Linus,

I have some more fixes this week -- better input validation, corruption
avoidance, build fixes, memory leak fixes, and a couple from Christoph
to avoid an ENOSPC failure.  Could you please pull the changes?

--Darrick

The following changes since commit 7a308bb3016f57e5be11a677d15b821536419d36:

  Linux 4.10-rc5 (2017-01-22 12:54:15 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-for-linus-4.10-rc6-5

for you to fetch changes up to e0d76fa4475ef2cf4b52d18588b8ce95153d021b:

  xfs: prevent quotacheck from overloading inode lru (2017-01-27 09:32:30 -0800)

----------------------------------------------------------------
Contained in this update:
- Fix race conditions in the CoW code
- Fix some incorrect input validation checks
- Avoid crashing fs by running out of space when freeing inodes
- Fix toctou race wrt whether or not an inode has an attr
- Fix build error on arm
- Fix page refcount corruption when readahead fails
- Don't corrupt userspace in the bmap ioctl

----------------------------------------------------------------
Brian Foster (2):
      xfs: remove racy hasattr check from attr ops
      xfs: prevent quotacheck from overloading inode lru

Christoph Hellwig (4):
      xfs: fix COW writeback race
      xfs: only update mount/resv fields on success in __xfs_ag_resv_init
      xfs: use per-AG reservations for the finobt
      xfs: extsize hints are not unlikely in xfs_bmap_btalloc

Darrick J. Wong (3):
      xfs: verify dirblocklog correctly
      xfs: clear _XBF_PAGES from buffers when readahead page
      xfs: fix bmv_count confusion w/ shared extents

 fs/xfs/libxfs/xfs_ag_resv.c      | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr.c         |  6 ------
 fs/xfs/libxfs/xfs_bmap.c         | 48 ++++++++++++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_bmap.h         |  6 +++++-
 fs/xfs/libxfs/xfs_ialloc_btree.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_ialloc_btree.h |  3 +++
 fs/xfs/libxfs/xfs_sb.c           |  2 +-
 fs/xfs/xfs_bmap_util.c           | 28 ++++++++++++++++++----------
 fs/xfs/xfs_buf.c                 |  1 +
 fs/xfs/xfs_inode.c               | 23 ++++++++++++-----------
 fs/xfs/xfs_iomap.c               |  2 +-
 fs/xfs/xfs_mount.h               |  1 +
 fs/xfs/xfs_qm.c                  |  3 ++-
 13 files changed, 220 insertions(+), 63 deletions(-)
