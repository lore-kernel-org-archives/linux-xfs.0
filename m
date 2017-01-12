Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45016 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750698AbdALFak (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jan 2017 00:30:40 -0500
Date: Wed, 11 Jan 2017 21:30:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] xfs: updates for 4.10-rc4
Message-ID: <20170112053005.GW14038@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>

Hi Linus,

As promised last week, here's some stability fixes from Christoph and
Jan Kara.  I think they fall within the guidelines for non-merge window
patches.  Could you please pull the changes?

--Darrick

The following changes since commit a121103c922847ba5010819a3f250f1f7fc84ab8:

  Linux 4.10-rc3 (2017-01-08 14:18:17 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-for-linus-4.10-rc4-1

for you to fetch changes up to 0a417b8dc1f10b03e8f558b8a831f07ec4c23795:

  xfs: Timely free truncated dirty pages (2017-01-11 10:20:04 -0800)

----------------------------------------------------------------
Contained in this update:
- Fix free space request handling when low on disk space
- Remove redundant log failure error messages
- Free truncate dirty pages instead of letting them build up forever

----------------------------------------------------------------
Christoph Hellwig (5):
      xfs: bump up reserved blocks in xfs_alloc_set_aside
      xfs: fix bogus minleft manipulations
      xfs: adjust allocation length in xfs_alloc_space_available
      xfs: don't rely on ->total in xfs_alloc_space_available
      xfs: don't print warnings when xfs_log_force fails

Jan Kara (1):
      xfs: Timely free truncated dirty pages

 fs/xfs/libxfs/xfs_alloc.c      | 115 ++++++++++-------------------------------
 fs/xfs/libxfs/xfs_alloc.h      |   2 +-
 fs/xfs/libxfs/xfs_bmap.c       |   3 --
 fs/xfs/libxfs/xfs_bmap_btree.c |   3 +-
 fs/xfs/xfs_aops.c              |  19 ++++---
 fs/xfs/xfs_log.c               |  12 +----
 6 files changed, 43 insertions(+), 111 deletions(-)
