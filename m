Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39754 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbeLHQgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Dec 2018 11:36:45 -0500
Date: Sat, 8 Dec 2018 08:36:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] xfs: fixes for v4.20-rc6
Message-ID: <20181208163639.GR24487@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net

Hi Linus,

Here are hopefully the last set of fixes for 4.20.  There's a fix for a
longstanding statfs reporting problem with project quotas, a correction
for page cache invalidation behaviors when fallocating near EOF, and a
fix for a broken metadata verifier return code.

Finally, the most important fix is to the pipe splicing code (aka the
generic copy_file_range fallback) to avoid pointless short directio
reads by only asking the filesystem for as much data as there are
available pages in the pipe buffer.  Our previous fix (simulated short
directio reads because the number of pages didn't match the length of
the read requested) caused subtle problems on overlayfs, so that part is
reverted.

Anyhow, this series passes fstests -g all on xfs and overlay+xfs, and
has passed 17 billion fsx operations problem-free since I started
testing; and merges cleanly with master as of last night, so please let
me know if you encounter problems.

--D

The following changes since commit 8c110d43c6bca4b24dd13272a9d4e0ba6f2ec957:

  iomap: readpages doesn't zero page tail beyond EOF (2018-11-21 10:10:54 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.20-fixes-3

for you to fetch changes up to 8f67b5adc030553fbc877124306f3f3bdab89aa8:

  iomap: partially revert 4721a601099 (simulated directio short read on EFAULT) (2018-12-04 09:40:02 -0800)

----------------------------------------------------------------
Changes since last update:
- Fix broken project quota inode counts
- Fix incorrect PAGE_MASK/PAGE_SIZE usage
- Fix incorrect return value in btree verifier
- Fix WARN_ON remap flags false positive
- Fix splice read overflows

----------------------------------------------------------------
Darrick J. Wong (4):
      xfs: fix PAGE_MASK usage in xfs_free_file_space
      vfs: allow some remap flags to be passed to vfs_clone_file_range
      splice: don't read more than available pipe space
      iomap: partially revert 4721a601099 (simulated directio short read on EFAULT)

Eric Sandeen (1):
      xfs: fix inverted return from xfs_btree_sblock_verify_crc

Ye Yin (1):
      fs/xfs: fix f_ffree value for statfs when project quota is set

 fs/iomap.c                | 9 ---------
 fs/read_write.c           | 2 +-
 fs/splice.c               | 7 ++++++-
 fs/xfs/libxfs/xfs_btree.c | 2 +-
 fs/xfs/xfs_bmap_util.c    | 4 ++--
 fs/xfs/xfs_qm_bhv.c       | 2 +-
 6 files changed, 11 insertions(+), 15 deletions(-)
