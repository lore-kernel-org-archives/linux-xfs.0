Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752488AbeDLURM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Apr 2018 16:17:12 -0400
Date: Thu, 12 Apr 2018 13:17:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: cleanups & fixes for 4.17
Message-ID: <20180412201711.GA32099@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here's the second round of patches for XFS for 4.17.  Most of these are
code cleanups, but there are a couple of notable use-after-free bug
fixes.

This series has been run through a full xfstests run over the week
and through a quick xfstests run against this morning's master, with no
major failures reported.  Let me know if there are any merge problems.

--D

The following changes since commit dc1baa715bbfbb1902da942d06497e79b40e7bc7:

  xfs: do not log/recover swapext extent owner changes for deleted inodes (2018-03-29 10:19:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.17-merge-4

for you to fetch changes up to 8c81dd46ef3c416b3b95e3020fb90dbd44e6140b:

  Force log to disk before reading the AGF during a fstrim (2018-04-10 22:39:04 -0700)

----------------------------------------------------------------
Changes since last update:
- Cleanup unnecessary function call parameters
- Fix a use-after-free bug when aborting logging intents
- Refactor filestreams state data to avoid use-after-free bug
- Fix incorrect removal of cow extents when truncating extended
  attributes.
- Refactor open-coded __set_page_dirty in favor of using vfs function.
- Fix a deadlock when fstrim and fs shutdown race.

----------------------------------------------------------------
Carlos Maiolino (1):
      Force log to disk before reading the AGF during a fstrim

Chandan Rajendra (1):
      xfs: Remove "committed" argument of xfs_dir_ialloc

Christoph Hellwig (1):
      xfs: remove filestream item xfs_inode reference

Darrick J. Wong (1):
      xfs: only cancel cow blocks when truncating the data fork

Dave Chinner (1):
      xfs: fix intent use-after-free on abort

Eric Sandeen (1):
      xfs: non-scrub - remove unused function parameters

Matthew Wilcox (1):
      Export __set_page_dirty

 fs/buffer.c                        |  3 ++-
 fs/xfs/libxfs/xfs_alloc.c          |  6 ++----
 fs/xfs/libxfs/xfs_alloc.h          |  5 ++---
 fs/xfs/libxfs/xfs_bmap.c           |  3 +--
 fs/xfs/libxfs/xfs_bmap.h           |  2 +-
 fs/xfs/libxfs/xfs_btree.c          |  2 --
 fs/xfs/libxfs/xfs_btree.h          |  6 ++----
 fs/xfs/libxfs/xfs_ialloc.c         |  2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  2 +-
 fs/xfs/libxfs/xfs_refcount.c       | 22 ++++++++-------------
 fs/xfs/libxfs/xfs_refcount_btree.c |  5 ++---
 fs/xfs/libxfs/xfs_refcount_btree.h |  3 +--
 fs/xfs/libxfs/xfs_rmap.c           |  3 +--
 fs/xfs/libxfs/xfs_rmap_btree.c     |  5 ++---
 fs/xfs/libxfs/xfs_rmap_btree.h     |  2 +-
 fs/xfs/libxfs/xfs_sb.c             | 10 ++++------
 fs/xfs/libxfs/xfs_trans_resv.c     | 10 ++++------
 fs/xfs/xfs_aops.c                  | 15 ++-------------
 fs/xfs/xfs_bmap_item.c             | 39 +++++++++++++++++++-------------------
 fs/xfs/xfs_bmap_util.c             |  3 +--
 fs/xfs/xfs_buf.c                   |  1 -
 fs/xfs/xfs_buf.h                   |  2 +-
 fs/xfs/xfs_discard.c               | 14 +++++++-------
 fs/xfs/xfs_extfree_item.c          | 38 ++++++++++++++++++-------------------
 fs/xfs/xfs_filestream.c            | 21 ++++++++++----------
 fs/xfs/xfs_inode.c                 | 31 ++++++++++++------------------
 fs/xfs/xfs_inode.h                 |  6 +++---
 fs/xfs/xfs_iops.c                  |  2 +-
 fs/xfs/xfs_log.c                   |  1 -
 fs/xfs/xfs_log.h                   |  3 +--
 fs/xfs/xfs_log_cil.c               |  2 +-
 fs/xfs/xfs_mru_cache.c             |  8 +++++---
 fs/xfs/xfs_mru_cache.h             |  8 ++++----
 fs/xfs/xfs_qm.c                    |  4 +---
 fs/xfs/xfs_refcount_item.c         | 39 +++++++++++++++++++-------------------
 fs/xfs/xfs_rmap_item.c             | 38 ++++++++++++++++++-------------------
 fs/xfs/xfs_super.c                 | 13 ++++++-------
 fs/xfs/xfs_symlink.c               |  2 +-
 fs/xfs/xfs_trace.h                 | 14 +++++++-------
 include/linux/mm.h                 |  1 +
 40 files changed, 177 insertions(+), 219 deletions(-)
