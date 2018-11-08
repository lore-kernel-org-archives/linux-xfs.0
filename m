Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43740 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbeKIIRr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 03:17:47 -0500
Date: Thu, 8 Nov 2018 14:40:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] xfs: fixes for v4.20-rc2
Message-ID: <20181108224000.GB15721@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net

Hi Linus,

Here's the start of the stabilization fixes for 4.20.  Let me know if
there are any problems merging; I just did it against current master and
saw no issues.

--D

The following changes since commit 651022382c7f8da46cb4872a545ee1da6d097d2a:

  Linux 4.20-rc1 (2018-11-04 15:37:52 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.20-fixes-1

for you to fetch changes up to 837514f7a4ca4aca06aec5caa5ff56d33ef06976:

  xfs: fix overflow in xfs_attr3_leaf_verify (2018-11-06 07:50:50 -0800)

----------------------------------------------------------------
Changes since last update:
- fix incorrect dropping of error code from bmap
- print buffer offsets instead of useless hashed pointers when dumping
  corrupt metadata
- fix integer overflow in attribute verifier

----------------------------------------------------------------
Christophe JAILLET (1):
      xfs: Fix error code in 'xfs_ioc_getbmap()'

Darrick J. Wong (1):
      xfs: print buffer offsets when dumping corrupt buffers

Dave Chinner (1):
      xfs: fix overflow in xfs_attr3_leaf_verify

 fs/xfs/libxfs/xfs_attr_leaf.c | 11 +++++++++--
 fs/xfs/xfs_ioctl.c            |  2 +-
 fs/xfs/xfs_message.c          |  2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)
