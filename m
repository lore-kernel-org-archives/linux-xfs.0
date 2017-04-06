Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751266AbdDFVZL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 17:25:11 -0400
Date: Thu, 6 Apr 2017 14:25:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.11-rc6
Message-ID: <20170406212505.GA4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here are three more fixes for 4.11.  The first one reworks the inline
directory verifier to check the working copy of the directory metadata
and to avoid triggering a periodic crash in xfs/348.  The second patch
fixes a regression in hole punching at EOF that corrupts files; and the
third patch closes a kernel memory disclosure bug.

--Darrick

The following changes since commit 630a04e79dd41ff746b545d4fc052e0abb836120:

  xfs: verify inline directory data forks (2017-03-15 00:24:25 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.11-fixes-3

for you to fetch changes up to bf9216f922612d2db7666aae01e65064da2ffb3a:

  xfs: fix kernel memory exposure problems (2017-04-03 12:22:39 -0700)

----------------------------------------------------------------
Changes since last update:
- Rework the inline directory verifier to avoid crashes on disk corruption
- Don't change file size when punching holes w/ KEEP_SIZE
- Close a kernel memory exposure bug

----------------------------------------------------------------
Calvin Owens (1):
      xfs: Honor FALLOC_FL_KEEP_SIZE when punching ends of files

Darrick J. Wong (2):
      xfs: rework the inline directory verifiers
      xfs: fix kernel memory exposure problems

 fs/xfs/libxfs/xfs_dir2_priv.h  |  3 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    | 63 +++++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_inode_fork.c | 35 +++++++++--------------
 fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
 fs/xfs/xfs_bmap_util.c         | 10 ++++++-
 fs/xfs/xfs_inode.c             | 19 +++++++------
 fs/xfs/xfs_itable.c            |  2 +-
 7 files changed, 76 insertions(+), 58 deletions(-)
