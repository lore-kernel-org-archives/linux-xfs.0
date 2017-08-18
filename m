Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751693AbdHRUra (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Aug 2017 16:47:30 -0400
Date: Fri, 18 Aug 2017 13:47:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.13-rc6
Message-ID: <20170818204729.GN4796@magnolia>
References: <20170807192205.GN24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170807192205.GN24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

A handful more bug fixes for you today.

--Darrick

The following changes since commit 56bdf855e676f1f2ed7033f288f57dfd315725ba:

  xfs: Fix per-inode DAX flag inheritance (2017-08-04 13:43:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.13-fixes-5

for you to fetch changes up to 77aff8c76425c8f49b50d0b9009915066739e7d2:

  xfs: don't leak quotacheck dquots when cow recovery (2017-08-17 12:40:33 -0700)

----------------------------------------------------------------
Changes since last time:
- Don't leak resources when mount fails
- Don't accidentally clobber variables when looking for free inodes

----------------------------------------------------------------
Christoph Hellwig (1):
      iomap: fix integer truncation issues in the zeroing and dirtying helpers

Darrick J. Wong (2):
      xfs: clear MS_ACTIVE after finishing log recovery
      xfs: don't leak quotacheck dquots when cow recovery

Omar Sandoval (1):
      xfs: fix inobt inode allocation search optimization

 fs/iomap.c                 |  4 ++--
 fs/xfs/libxfs/xfs_ialloc.c |  2 +-
 fs/xfs/xfs_log.c           | 11 +++++++++++
 fs/xfs/xfs_mount.c         | 12 ++----------
 4 files changed, 16 insertions(+), 13 deletions(-)
