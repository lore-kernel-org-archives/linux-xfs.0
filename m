Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55126 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbfCOQH1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Mar 2019 12:07:27 -0400
Date: Fri, 15 Mar 2019 09:07:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] xfs: minor cleanups for 5.1-rc1
Message-ID: <20190315160706.GI4929@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net, hch@lst.de

Hi Linus,

Here's a few more cleanups that trickled in for the merge window.  It's
all fixes for static checker complaints and slowly unwinding typedef
usage.  The four patches here have gone through a few days worth of
fstest runs with no new problems observed; and they merge cleanly with
master as of a few minutes ago.  Please let me know if you encounter any
problems merging them.

--D

The following changes since commit 1b9598c8fb9965fff901c4caa21fed9644c34df3:

  xfs: fix reporting supported extra file attributes for statx() (2019-03-01 08:57:25 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.1-merge-5

for you to fetch changes up to 6ef50fe9afae63d11220f3f66b5f4c75d09c8bf0:

  xfs: clean up xfs_dir2_leaf_addname (2019-03-12 09:19:38 -0700)

----------------------------------------------------------------
Changes since last update:
- Fix some clang/smatch/sparse warnings about uninitialized variables.
- Clean up some typedef usage.

----------------------------------------------------------------
Darrick J. Wong (3):
      xfs: clean up xfs_dir2_leafn_add
      xfs: zero initialize highstale and lowstale in xfs_dir2_leaf_addname
      xfs: clean up xfs_dir2_leaf_addname

Nathan Chancellor (1):
      xfs: Zero initialize highstale and lowstale in xfs_dir2_leafn_add

 fs/xfs/libxfs/xfs_dir2_leaf.c | 37 +++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_dir2_node.c | 18 ++++++++----------
 2 files changed, 25 insertions(+), 30 deletions(-)
