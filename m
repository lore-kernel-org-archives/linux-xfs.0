Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750785AbdLMWtx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Dec 2017 17:49:53 -0500
Date: Wed, 13 Dec 2017 14:49:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.15-rc4
Message-ID: <20171213224950.GR19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here are a few more bug fixes & cleanups for 4.15-rc4.

--D

The following changes since commit 373b0589dc8d58bc09c9a28d03611ae4fb216057:

  xfs: Properly retry failed dquot items in case of error during buffer writeback (2017-11-30 08:47:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.15-fixes-5

for you to fetch changes up to b7e0b6ff54dd92febbb1914ab93cd6a21622e169:

  xfs: make iomap_begin functions trim iomaps consistently (2017-12-08 17:51:05 -0800)

----------------------------------------------------------------
Changes since last update:
- Clean up duplicate includes
- Remove ancient 'no-alloc' crap code that occasionally caused hard fs
  shutdowns due to lack of proper space reservations
- Fix regression in FIEMAP behavior when reporting xattr extents

----------------------------------------------------------------
Christoph Hellwig (1):
      xfs: remove "no-allocation" reservations for file creations

Darrick J. Wong (1):
      xfs: make iomap_begin functions trim iomaps consistently

Pravin Shedge (1):
      fs: xfs: remove duplicate includes

 fs/xfs/libxfs/xfs_ialloc.c | 10 +++-------
 fs/xfs/libxfs/xfs_ialloc.h |  1 -
 fs/xfs/scrub/scrub.c       |  1 -
 fs/xfs/scrub/trace.c       |  1 -
 fs/xfs/xfs_inode.c         | 33 +++++++--------------------------
 fs/xfs/xfs_inode.h         |  2 +-
 fs/xfs/xfs_iomap.c         |  2 +-
 fs/xfs/xfs_qm.c            |  4 ++--
 fs/xfs/xfs_reflink.c       |  2 --
 fs/xfs/xfs_symlink.c       | 15 +--------------
 fs/xfs/xfs_trace.c         |  1 -
 11 files changed, 15 insertions(+), 57 deletions(-)
