Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751345AbdI1UUA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Sep 2017 16:20:00 -0400
Date: Thu, 28 Sep 2017 13:19:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.14-rc3
Message-ID: <20170928201957.GS5020@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <djwong@kernel.org>

Hi Linus,

Here's the first round of bug fixes for 4.14.

--D

The following changes since commit 2bd6bf03f4c1c59381d62c61d03f6cc3fe71f66e:

  Linux 4.14-rc1 (2017-09-16 15:47:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.14-fixes-2

for you to fetch changes up to 5e5c943c1f257c2b3424fc3f8a7b18570152dab3:

  xfs: revert "xfs: factor rmap btree size into the indlen calculations" (2017-09-26 10:55:20 -0700)

----------------------------------------------------------------
Changes since last update:
- fix various problems with the copy-on-write extent maps getting freed
  at the wrong time
- fix printk format specifier problems
- report zeroing operation outcomes instead of dropping them on the
  floor
- fix some crashes when dio operations partially fail
- fix a race condition between unwritten extent conversion & dio read
- fix some incorrect tests in the inode log item processing
- correct the delayed allocation space reservations on rmap filesystems
- fix some problems checking for dax support

----------------------------------------------------------------
Carlos Maiolino (1):
      xfs: Capture state of the right inode in xfs_iflush_done

Chandan Rajendra (1):
      iomap_dio_rw: Allocate AIO completion queue before submitting dio

Colin Ian King (1):
      xfs: remove redundant re-initialization of total_nr_pages

Darrick J. Wong (4):
      xfs: don't unconditionally clear the reflink flag on zero-block files
      xfs: evict CoW fork extents when performing finsert/fcollapse
      xfs: perag initialization should only touch m_ag_max_usable for AG 0
      xfs: revert "xfs: factor rmap btree size into the indlen calculations"

Eryu Guan (3):
      xfs: kill meaningless variable 'zero'
      xfs: report zeroed or not correctly in xfs_zero_range()
      xfs: update i_size after unwritten conversion in dio completion

Helge Deller (1):
      fs/xfs: Use %pS printk format for direct addresses

Kenjiro Nakayama (1):
      xfs: Output warning message when discard option was enabled even though the device does not support discard

Ross Zwisler (1):
      xfs: validate bdev support for DAX inode flag

 fs/iomap.c                  | 14 +++++++-------
 fs/xfs/libxfs/xfs_ag_resv.c | 12 ++++++++++--
 fs/xfs/libxfs/xfs_bmap.c    | 17 ++---------------
 fs/xfs/xfs_aops.c           |  3 ++-
 fs/xfs/xfs_bmap_util.c      | 14 +++++++++++++-
 fs/xfs/xfs_buf.c            |  2 --
 fs/xfs/xfs_error.c          |  2 +-
 fs/xfs/xfs_file.c           | 39 +++++++++++++++++++++------------------
 fs/xfs/xfs_inode.c          |  8 +++++---
 fs/xfs/xfs_inode_item.c     |  2 +-
 fs/xfs/xfs_ioctl.c          |  3 ++-
 fs/xfs/xfs_iomap.c          |  7 +++++--
 fs/xfs/xfs_iomap.h          |  2 +-
 fs/xfs/xfs_pnfs.c           |  2 +-
 fs/xfs/xfs_super.c          | 10 ++++++++++
 15 files changed, 81 insertions(+), 56 deletions(-)
