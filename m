Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752488AbdG1TfH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jul 2017 15:35:07 -0400
Date: Fri, 28 Jul 2017 12:35:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.13-rc3
Message-ID: <20170728193506.GA4477@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here's the first batch of bug fixes for 4.13.

--Darrick

The following changes since commit 5771a8c08880cdca3bfb4a3fc6d309d6bba20877:

  Linux v4.13-rc1 (2017-07-15 15:22:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.13-fixes-2

for you to fetch changes up to 5b094d6dac0451ad89b1dc088395c7b399b7e9e8:

  xfs: fix multi-AG deadlock in xfs_bunmapi (2017-07-26 08:20:03 -0700)

----------------------------------------------------------------
Changes since last update:
- Fix firstfsb variables that we left uninitialized, which could lead to
  locking problems.
- Check for NULL metadata buffer pointers before using them.
- Don't allow btree cursor manipulation if the btree block is corrupt.
  Better to just shut down.
- Fix infinite loop problems in quotacheck.
- Fix buffer overrun when validating directory blocks.
- Fix deadlock problem in bunmapi.

----------------------------------------------------------------
Brian Foster (1):
      xfs: fix quotacheck dquot id overflow infinite loop

Christoph Hellwig (1):
      xfs: fix multi-AG deadlock in xfs_bunmapi

Darrick J. Wong (4):
      xfs: check _btree_check_block value
      xfs: set firstfsb to NULLFSBLOCK before feeding it to _bmapi_write
      xfs: check _alloc_read_agf buffer pointer before using
      xfs: check that dir block entries don't off the end of the buffer

 fs/xfs/libxfs/xfs_bmap.c      | 21 +++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.c     |  6 ++++--
 fs/xfs/libxfs/xfs_dir2_data.c |  4 ++++
 fs/xfs/libxfs/xfs_refcount.c  |  4 ++++
 fs/xfs/xfs_qm.c               |  3 +++
 fs/xfs/xfs_reflink.c          |  4 +++-
 6 files changed, 39 insertions(+), 3 deletions(-)
