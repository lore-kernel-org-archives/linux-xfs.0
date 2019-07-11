Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728421AbfGKOS0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jul 2019 10:18:26 -0400
Date: Thu, 11 Jul 2019 07:18:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] vfs: standardize parameter checking for
 SETFLAGS/FSSETXATTR ioctls
Message-ID: <20190711141825.GV1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org, sandeen@sandeen.net, hch@lst.de, linux-ext4 <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>

Hi Linus,

Here's a patch series that sets up common parameter checking functions
for the FS_IOC_SETFLAGS and FS_IOC_FSSETXATTR ioctl implementations.
The goal here is to reduce the amount of behaviorial variance between
the filesystems where those ioctls originated (ext2 and XFS,
respectively) and everybody else.

The branch merges cleanly against this morning's HEAD and survived an
overnight run of xfstests.  The merge was completely straightforward, so
please let me know if you run into anything weird.

--D

The following changes since commit d1fdb6d8f6a4109a4263176c84b899076a5f8008:

  Linux 5.2-rc4 (2019-06-08 20:24:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/vfs-fix-ioctl-checking-3

for you to fetch changes up to dbc77f31e58b2902a5e7643761c04bf69f57a32a:

  vfs: only allow FSSETXATTR to set DAX flag on files and dirs (2019-07-01 08:25:36 -0700)

----------------------------------------------------------------
New for 5.3:
- Standardize parameter checking for the SETFLAGS and FSSETXATTR ioctls
  (which were the file attribute setters for ext4 and xfs and have now
  been hoisted to the vfs)
- Only allow the DAX flag to be set on files and directories.

----------------------------------------------------------------
Darrick J. Wong (5):
      vfs: create a generic checking and prep function for FS_IOC_SETFLAGS
      vfs: create a generic checking function for FS_IOC_FSSETXATTR
      vfs: teach vfs_ioc_fssetxattr_check to check project id info
      vfs: teach vfs_ioc_fssetxattr_check to check extent size hints
      vfs: only allow FSSETXATTR to set DAX flag on files and dirs

 fs/btrfs/ioctl.c    |  30 ++++------
 fs/efivarfs/file.c  |  26 ++++++---
 fs/ext2/ioctl.c     |  16 ++----
 fs/ext4/ioctl.c     |  51 +++++------------
 fs/gfs2/file.c      |  42 +++++++++-----
 fs/hfsplus/ioctl.c  |  21 ++++---
 fs/inode.c          |  86 +++++++++++++++++++++++++++++
 fs/jfs/ioctl.c      |  22 +++-----
 fs/nilfs2/ioctl.c   |   9 +--
 fs/ocfs2/ioctl.c    |  13 +----
 fs/orangefs/file.c  |  37 ++++++++++---
 fs/reiserfs/ioctl.c |  10 ++--
 fs/ubifs/ioctl.c    |  13 +----
 fs/xfs/xfs_ioctl.c  | 154 +++++++++++++++++++++++-----------------------------
 include/linux/fs.h  |  12 ++++
 15 files changed, 300 insertions(+), 242 deletions(-)
