Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750782AbdJRSiH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Oct 2017 14:38:07 -0400
Date: Wed, 18 Oct 2017 11:38:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.14-rc6
Message-ID: <20171018183806.GD4703@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here's a fourth round of fixes for bugs and other build problems.

--D

The following changes since commit 33d930e59a98fa10a0db9f56c7fa2f21a4aef9b9:

  Linux 4.14-rc5 (2017-10-15 21:01:12 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.14-fixes-6

for you to fetch changes up to 785545c8982604fe3ba79d16409e83993be77d5e:

  xfs: move two more RT specific functions into CONFIG_XFS_RT (2017-10-16 12:26:50 -0700)

----------------------------------------------------------------
Changes since last update:
- fix some more CONFIG_XFS_RT related build problems
- fix data loss when writeback at eof races eofblocks gc and loses
- invalidate page cache after fs finishes a dio write
- remove dirty page state when invalidating pages so releasepage does
  the right thing when handed a dirty page

----------------------------------------------------------------
Arnd Bergmann (1):
      xfs: move two more RT specific functions into CONFIG_XFS_RT

Brian Foster (1):
      xfs: trim writepage mapping to within eof

Dave Chinner (1):
      xfs: cancel dirty pages on invalidation

Eryu Guan (1):
      fs: invalidate page cache after end_io() in dio completion

 fs/direct-io.c           | 20 ++++++++++++--------
 fs/iomap.c               | 41 ++++++++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_bmap.c | 11 +++++++++++
 fs/xfs/libxfs/xfs_bmap.h |  1 +
 fs/xfs/xfs_aops.c        | 47 +++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_fsmap.c       | 48 ++++++++++++++++++++++++------------------------
 6 files changed, 107 insertions(+), 61 deletions(-)
