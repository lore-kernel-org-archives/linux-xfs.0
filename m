Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33136 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbeKYDyh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Nov 2018 22:54:37 -0500
Date: Sat, 24 Nov 2018 09:05:40 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] xfs: fixes for v4.20-rc4
Message-ID: <20181124170540.GY6792@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net

Hi Linus,

Dave and I have continued our work fixing corruption problems that can
be found when running long-term burn-in exercisers on xfs.  Here are
some patches fixing most of the problems, but there will likely be more.
:/

Anyhow, this series merges cleanly with master as of last night, so
please let me know if you encounter problems.

--D

The following changes since commit 837514f7a4ca4aca06aec5caa5ff56d33ef06976:

  xfs: fix overflow in xfs_attr3_leaf_verify (2018-11-06 07:50:50 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.20-fixes-2

for you to fetch changes up to 8c110d43c6bca4b24dd13272a9d4e0ba6f2ec957:

  iomap: readpages doesn't zero page tail beyond EOF (2018-11-21 10:10:54 -0800)

----------------------------------------------------------------
Changes since last update:
- Numerous corruption fixes for copy on write
- Numerous corruption fixes for blocksize < pagesize writes
- Don't miscalculate AG reservations for small final AGs
- Fix page cache truncation to work properly for reflink and extent
  shifting
- Fix use-after-free when retrying failed inode/dquot buffer logging
- Fix corruptions seen when using copy_file_range in directio mode

----------------------------------------------------------------
Brian Foster (1):
      xfs: fix shared extent data corruption due to missing cow reservation

Dave Chinner (11):
      xfs: uncached buffer tracing needs to print bno
      xfs: fix transient reference count error in xfs_buf_resubmit_failed_buffers
      xfs: finobt AG reserves don't consider last AG can be a runt
      xfs: extent shifting doesn't fully invalidate page cache
      xfs: flush removing page cache in xfs_reflink_remap_prep
      xfs: delalloc -> unwritten COW fork allocation can go wrong
      iomap: FUA is wrong for DIO O_DSYNC writes into unwritten extents
      iomap: sub-block dio needs to zeroout beyond EOF
      iomap: dio data corruption and spurious errors when pipes fill
      vfs: vfs_dedupe_file_range() doesn't return EOPNOTSUPP
      iomap: readpages doesn't zero page tail beyond EOF

Eric Biggers (1):
      xfs: make xfs_file_remap_range() static

 fs/iomap.c                       | 53 +++++++++++++++++++++++++++++++---------
 fs/read_write.c                  | 15 ++++++------
 fs/xfs/libxfs/xfs_bmap.c         |  5 +++-
 fs/xfs/libxfs/xfs_ialloc_btree.c | 11 ++++++---
 fs/xfs/xfs_bmap_util.c           | 10 ++------
 fs/xfs/xfs_bmap_util.h           |  3 +++
 fs/xfs/xfs_buf_item.c            | 28 +++++++++++++++------
 fs/xfs/xfs_file.c                |  2 +-
 fs/xfs/xfs_reflink.c             | 18 +++++++++++---
 fs/xfs/xfs_trace.h               |  5 +++-
 10 files changed, 104 insertions(+), 46 deletions(-)
