Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751908AbdCIWGG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Mar 2017 17:06:06 -0500
Date: Thu, 9 Mar 2017 14:05:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.11-rc2
Message-ID: <20170309220554.GT5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>

Hi Linus,

Here are some bug fixes for -rc2 to clean up the copy on write handling
and to remove a cause of hangs.  Could you pull them, please?

--Darrick

The following changes since commit c1ae3cfa0e89fa1a7ecc4c99031f5e9ae99d9201:

  Linux 4.11-rc1 (2017-03-05 12:59:56 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.11-fixes-1

for you to fetch changes up to 2fcc319d2467a5f5b78f35f79fd6e22741a31b1e:

  xfs: try any AG when allocating the first btree block when reflinking (2017-03-08 10:38:53 -0800)

----------------------------------------------------------------
Changes since last update:
- Fix various iomap bugs
- Fix overly aggressive CoW preallocation garbage collection
- Fixes to CoW endio error handling
- Fix some incorrect geometry calculations
- Remove a potential system hang in bulkstat
- Try to allocate blocks more aggressively to reduce ENOSPC errors

----------------------------------------------------------------
Brian Foster (1):
      xfs: use iomap new flag for newly allocated delalloc blocks

Chandan Rajendra (1):
      xfs: Use xfs_icluster_size_fsb() to calculate inode alignment mask

Christoph Hellwig (3):
      xfs: only reclaim unwritten COW extents periodically
      xfs: fix and streamline error handling in xfs_end_io
      xfs: try any AG when allocating the first btree block when reflinking

Darrick J. Wong (1):
      xfs: remove kmem_zalloc_greedy

Eryu Guan (1):
      iomap: invalidate page caches should be after iomap_dio_complete() in direct write

 fs/iomap.c                     | 17 +++++++-----
 fs/xfs/kmem.c                  | 18 -------------
 fs/xfs/kmem.h                  |  2 --
 fs/xfs/libxfs/xfs_bmap.c       | 34 ++++++++++++++----------
 fs/xfs/libxfs/xfs_bmap_btree.c |  6 ++---
 fs/xfs/xfs_aops.c              | 59 +++++++++++++++++++-----------------------
 fs/xfs/xfs_icache.c            |  2 +-
 fs/xfs/xfs_inode.c             |  2 +-
 fs/xfs/xfs_iomap.c             | 25 +++++++++++++-----
 fs/xfs/xfs_itable.c            |  6 ++---
 fs/xfs/xfs_mount.c             |  3 +--
 fs/xfs/xfs_reflink.c           | 23 +++++++++++-----
 fs/xfs/xfs_reflink.h           |  4 +--
 fs/xfs/xfs_super.c             |  2 +-
 14 files changed, 103 insertions(+), 100 deletions(-)
