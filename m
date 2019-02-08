Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50074 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfBHHZa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 02:25:30 -0500
Date: Thu, 7 Feb 2019 23:25:17 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] xfs: fixes for v5.0-rc6
Message-ID: <20190208072517.GL7991@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net, hch@lst.de

Hi Linus,

Here are a handful of XFS fixes to fix a data corruption problem, a
crasher bug, and a deadlock.  It merged cleanly against this morning's
master, so please let me know if you encounter any problems.

--D

The following changes since commit 8834f5600cf3c8db365e18a3d5cac2c2780c81e5:

  Linux 5.0-rc5 (2019-02-03 13:48:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.0-fixes-1

for you to fetch changes up to add46b3b021263c02d5a7080c58e5b459479fafd:

  xfs: set buffer ops when repair probes for btree type (2019-02-03 14:03:59 -0800)

----------------------------------------------------------------
Changes since last update:
- Fix cache coherency problem with writeback mappings
- Fix buffer deadlock when shutting fs down
- Fix a null pointer dereference when running online repair

----------------------------------------------------------------
Brian Foster (2):
      xfs: eof trim writeback mapping as soon as it is cached
      xfs: end sync buffer I/O properly on shutdown error

Darrick J. Wong (1):
      xfs: set buffer ops when repair probes for btree type

 fs/xfs/scrub/repair.c | 11 ++++++++---
 fs/xfs/xfs_aops.c     |  2 ++
 fs/xfs/xfs_buf.c      | 19 +++++++++++++++++--
 3 files changed, 27 insertions(+), 5 deletions(-)
