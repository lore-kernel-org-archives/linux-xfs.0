Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751145AbdKUTpI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Nov 2017 14:45:08 -0500
Date: Tue, 21 Nov 2017 11:45:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: more fixes for 4.15
Message-ID: <20171121194505.GD2135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here are a couple more patches to fix a memory leak and some refactoring
to make it easier to keep xfsprogs' libxfs in sync with the kernel.

--D

The following changes since commit 2015a63dce8d73a439232a0d5162c88d8513101e:

  xfs: fix type usage (2017-11-16 12:06:45 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.15-merge-3

for you to fetch changes up to 274e0a1f4777b9362fc03a34e86358cc36003e48:

  xfs: abstract out dev_t conversions (2017-11-21 01:44:53 -0800)

----------------------------------------------------------------
Changes since last update:
- Fix a memory leak in the new in-core extent map.
- Refactor the xfs_dev_t conversions for easier xfsprogs porting

----------------------------------------------------------------
Christoph Hellwig (1):
      xfs: abstract out dev_t conversions

Shu Wang (1):
      xfs: fix memory leak in xfs_iext_free_last_leaf

 fs/xfs/libxfs/xfs_iext_tree.c  |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  8 ++------
 fs/xfs/xfs_linux.h             | 10 ++++++++++
 3 files changed, 13 insertions(+), 7 deletions(-)
