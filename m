Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753789AbeEAQBb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 May 2018 12:01:31 -0400
Date: Tue, 1 May 2018 09:01:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.17-rc4
Message-ID: <20180501160130.GD4127@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here are a few more bug fixes for xfs for 4.17-rc4.  Most of them are
fixes for bad behavior.

This series has been run through a full xfstests run during LSF and
through a quick xfstests run against this morning's master, with no
major failures reported.  Let me know if there are any merge problems.

--D

The following changes since commit 60cc43fc888428bb2f18f08997432d426a243338:

  Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.17-fixes-1

for you to fetch changes up to 7b38460dc8e4eafba06c78f8e37099d3b34d473c:

  xfs: don't fail when converting shortform attr to long form during ATTR_REPLACE (2018-04-17 19:10:15 -0700)

----------------------------------------------------------------
Changes since last update:
- Enhance inode fork verifiers to prevent loading of corrupted metadata.
- Fix a crash when we try to convert extents format inodes to btree
  format, we run out of space, but forget to revert the in-core state
  changes.
- Fix file size checks when doing INSERT_RANGE that could cause files
  to end up negative size if there previously was an extent mapped at
  s_maxbytes.
- Fix a bug when doing a remove-then-add ATTR_REPLACE xattr update where
  we forget to clear ATTR_REPLACE after the remove, which causes the
  attr to be lost and the fs to shut down due to (what it thinks is)
  inconsistent in-core state.

----------------------------------------------------------------
Darrick J. Wong (2):
      xfs: prevent creating negative-sized file via INSERT_RANGE
      xfs: don't fail when converting shortform attr to long form during ATTR_REPLACE

Eric Sandeen (2):
      xfs: enhance dinode verifier
      xfs: set format back to extents if xfs_bmap_extents_to_btree

 fs/xfs/libxfs/xfs_attr.c      |  9 ++++++++-
 fs/xfs/libxfs/xfs_bmap.c      |  4 ++++
 fs/xfs/libxfs/xfs_inode_buf.c | 21 +++++++++++++++++++++
 fs/xfs/xfs_file.c             | 14 +++++++++-----
 4 files changed, 42 insertions(+), 6 deletions(-)
