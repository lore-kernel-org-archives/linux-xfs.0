Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52638 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729626AbfC2NdY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 09:33:24 -0400
Date: Fri, 29 Mar 2019 06:33:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] xfs: bug fixes for 5.1-rc3
Message-ID: <20190329133311.GD18833@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net, hch@lst.de

Hi Linus,

Here are a few fixes for some corruption bugs and uninitialized variable
problems.  The few patches here have gone through a few days worth of
fstest runs with no new problems observed; and they merge cleanly with
master as of a few hours ago.  Please let me know if you encounter any
problems merging them.

--D

The following changes since commit 9e98c678c2d6ae3a17cb2de55d17f69dddaa231b:

  Linux 5.1-rc1 (2019-03-17 14:22:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.1-fixes-1

for you to fetch changes up to 2032a8a27b5cc0f578d37fa16fa2494b80a0d00a:

  xfs: serialize unaligned dio writes against all other dio writes (2019-03-26 08:37:55 -0700)

----------------------------------------------------------------
Changes since last update:
- Fix a bunch of static checker complaints about uninitialized variables
  and insufficient range checks.
- Avoid a crash when incore extent map data are corrupt.
- Disallow FITRIM when we haven't recovered the log and know the
  metadata are stale.
- Fix a data corruption when doing unaligned overlapping dio writes.

----------------------------------------------------------------
Brian Foster (2):
      xfs: don't trip over uninitialized buffer on extent read of corrupted inode
      xfs: serialize unaligned dio writes against all other dio writes

Darrick J. Wong (4):
      xfs: dabtree scrub needs to range-check level
      xfs: fix btree scrub checking with regards to root-in-inode
      xfs: always init bma in xfs_bmapi_write
      xfs: prohibit fstrim in norecovery mode

 fs/xfs/libxfs/xfs_bmap.c | 15 +++++++++------
 fs/xfs/scrub/btree.c     | 11 ++++++++++-
 fs/xfs/scrub/dabtree.c   |  5 +++++
 fs/xfs/xfs_discard.c     |  8 ++++++++
 fs/xfs/xfs_file.c        | 27 +++++++++++++++++----------
 5 files changed, 49 insertions(+), 17 deletions(-)
