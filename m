Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759944AbdEZTHL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 May 2017 15:07:11 -0400
Date: Fri, 26 May 2017 12:07:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: updates for 4.12-rc3
Message-ID: <20170526190709.GV4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

I have a few miscellaneous bug fixes & cleanups for you for 4.12-rc3.

--Darrick

The following changes since commit 2ea659a9ef488125eb46da6eb571de5eae5c43f6:

  Linux 4.12-rc1 (2017-05-13 13:19:49 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.12-fixes-2

for you to fetch changes up to a54fba8f5a0dc36161cacdf2aa90f007f702ec1a:

  xfs: Move handling of missing page into one place in xfs_find_get_desired_pgoff() (2017-05-25 09:42:25 -0700)

----------------------------------------------------------------
Changed since last update:
- Fix indlen block reservation accounting bug when splitting delalloc extent
- Fix warnings about unused variables that appeared in -rc1.
- Don't spew errors when bmapping a local format directory
- Fix an off-by-one error in a delalloc eof assertion
- Make fsmap only return inode information for CAP_SYS_ADMIN
- Fix a potential mount time deadlock recovering cow extents
- Fix unaligned memory access in _btree_visit_blocks
- Fix various SEEK_HOLE/SEEK_DATA bugs

----------------------------------------------------------------
Brian Foster (1):
      xfs: fix indlen accounting error on partial delalloc conversion

Darrick J. Wong (4):
      xfs: BMAPX shouldn't barf on inline-format directories
      xfs: fix warnings about unused stack variables
      xfs: only return detailed fsmap info if the caller has CAP_SYS_ADMIN
      xfs: avoid mount-time deadlock in CoW extent recovery

Eric Sandeen (1):
      xfs: fix unaligned access in xfs_btree_visit_blocks

Eryu Guan (1):
      xfs: fix off-by-one on max nr_pages in xfs_find_get_desired_pgoff()

Jan Kara (3):
      xfs: Fix missed holes in SEEK_HOLE implementation
      xfs: Fix off-by-in in loop termination in xfs_find_get_desired_pgoff()
      xfs: Move handling of missing page into one place in xfs_find_get_desired_pgoff()

Zorro Lang (1):
      xfs: bad assertion for delalloc an extent that start at i_size

 fs/xfs/libxfs/xfs_bmap.c     |  9 +++---
 fs/xfs/libxfs/xfs_btree.c    |  2 +-
 fs/xfs/libxfs/xfs_refcount.c | 43 +++++++++++++++++++--------
 fs/xfs/xfs_bmap_util.c       | 10 +++++--
 fs/xfs/xfs_file.c            | 71 ++++++++++++--------------------------------
 fs/xfs/xfs_fsmap.c           |  5 +++-
 6 files changed, 66 insertions(+), 74 deletions(-)
