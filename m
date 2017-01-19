Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753145AbdASXlv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jan 2017 18:41:51 -0500
Date: Thu, 19 Jan 2017 15:41:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: updates for 4.10-rc5
Message-ID: <20170119234147.GM14033@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Amir Goldstein <amir73il@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, Arnd Bergmann <arnd@arndb.de>

Hi Linus,

I have a few more patches this week -- one to make the behavior of a
quota id ioctl consistent with the other filesystems, and the rest
improve validation of i_mode & i_size values coming into xfs so that we
don't read off the ends of arrays or crash when handed garbage disk
data.  Could you please pull the changes?

--Darrick

The following changes since commit 49def1853334396f948dcb4cedb9347abb318df5:

  Linux 4.10-rc4 (2017-01-15 16:21:59 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-for-linux-4.10-rc5-1

for you to fetch changes up to fd29f7af75b7adf250beccffa63746c6a88e2b74:

  xfs: fix xfs_mode_to_ftype() prototype (2017-01-18 12:39:21 -0800)

----------------------------------------------------------------
Contained in this update:
- Inode i_mode sanitization
- Prevent overflows in getnextquota
- Minor build fix for the i_mode sanitizatoin

----------------------------------------------------------------
Amir Goldstein (6):
      xfs: make the ASSERT() condition likely
      xfs: sanity check directory inode di_size
      xfs: add missing include dependencies to xfs_dir2.h
      xfs: replace xfs_mode_to_ftype table with switch statement
      xfs: sanity check inode mode when creating new dentry
      xfs: sanity check inode di_mode

Arnd Bergmann (1):
      xfs: fix xfs_mode_to_ftype() prototype

Eric Sandeen (1):
      xfs: don't wrap ID in xfs_dq_get_next_id

 fs/xfs/libxfs/xfs_dir2.c      | 39 ++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_dir2.h      |  8 +++++---
 fs/xfs/libxfs/xfs_inode_buf.c | 10 ++++++++--
 fs/xfs/xfs_dquot.c            |  4 ++++
 fs/xfs/xfs_iops.c             | 50 ++++++++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_linux.h            |  6 +++---
 6 files changed, 84 insertions(+), 33 deletions(-)
