Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S970049AbdAEB55 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Jan 2017 20:57:57 -0500
Date: Wed, 4 Jan 2017 17:57:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: updates for 4.10-rc3
Message-ID: <20170105015753.GB17846@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

Hi Linus,

Could you please have a look at the XFS update from the tag below?  I
think I got everything right, but the branch and the tag could use some
more experienced eyes.  This is my first attempt at a LKML-style pull
request, so I thought I'd send along a few fixes that have crept in
since -rc1, and the MAINTAINERS update[1] promised by Dave last year.

If the tag looks ok, please pull it; otherwise let me know what's wrong
and I'll try again.  I plan to send some more fixes from Christoph soon,
but for my first try at a pull request I want to keep things simple.

--Darrick

[1] https://lkml.org/lkml/2016/12/14/807

The following changes since commit 0c744ea4f77d72b3dcebb7a8f2684633ec79be88:

  Linux 4.10-rc2 (2017-01-01 14:31:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-for-linus-4.10-rc3

for you to fetch changes up to ff97f2399edac1e0fb3fa7851d5fbcbdf04717cf:

  xfs: fix max_retries _show and _store functions (2017-01-03 20:34:17 -0800)

----------------------------------------------------------------
Contained in this update:
- Fixes for crashes and double-cleanup errors
- XFS maintainership handover
- Fix to prevent absurdly large block reservations
- Fix broken sysfs getter/setters

----------------------------------------------------------------
Carlos Maiolino (1):
      xfs: fix max_retries _show and _store functions

Christoph Hellwig (1):
      xfs: fix crash and data corruption due to removal of busy COW extents

Darrick J. Wong (3):
      xfs: fix double-cleanup when CUI recovery fails
      xfs: use the actual AG length when reserving blocks
      xfs: update MAINTAINERS

 MAINTAINERS                        |  4 ++--
 fs/xfs/libxfs/xfs_ag_resv.c        |  3 +++
 fs/xfs/libxfs/xfs_refcount_btree.c |  9 ++++++---
 fs/xfs/libxfs/xfs_refcount_btree.h |  3 ++-
 fs/xfs/libxfs/xfs_rmap_btree.c     | 14 +++++++-------
 fs/xfs/libxfs/xfs_rmap_btree.h     |  3 ++-
 fs/xfs/xfs_fsops.c                 | 14 ++++++++++++++
 fs/xfs/xfs_icache.c                |  3 ++-
 fs/xfs/xfs_refcount_item.c         |  3 ++-
 fs/xfs/xfs_sysfs.c                 |  4 ++--
 10 files changed, 42 insertions(+), 18 deletions(-)
