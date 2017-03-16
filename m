Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753550AbdCPTKy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Mar 2017 15:10:54 -0400
Date: Thu, 16 Mar 2017 12:10:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.11-rc3
Message-ID: <20170316191035.GK5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>

Hi Linus,

Here's a single fix for -rc3 to improve input validation on inline
directory metadata.  Could you pull it please?

(After the 4.10 cycle was over Dave told me that it's not customary to
keep rebasing the -fixes branch with every rc, so this time around I'm
sticking to appending fixes until the next merge window.  Let me know
if you have a problem with that.  I tried a test merge against HEAD
and it finished without issues.)

--D

The following changes since commit 2fcc319d2467a5f5b78f35f79fd6e22741a31b1e:

  xfs: try any AG when allocating the first btree block when reflinking (2017-03-08 10:38:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.11-fixes-2

for you to fetch changes up to 630a04e79dd41ff746b545d4fc052e0abb836120:

  xfs: verify inline directory data forks (2017-03-15 00:24:25 -0700)

----------------------------------------------------------------
Changes since last time:
- Validate inline directory data to prevent buffer overruns due to corrupt
  metadata.

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: verify inline directory data forks

 fs/xfs/libxfs/xfs_dir2_priv.h  |  2 +
 fs/xfs/libxfs/xfs_dir2_sf.c    | 87 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.c | 26 +++++++++++--
 fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
 fs/xfs/xfs_dir2_readdir.c      | 11 ------
 fs/xfs/xfs_inode.c             | 12 ++++--
 6 files changed, 122 insertions(+), 18 deletions(-)
