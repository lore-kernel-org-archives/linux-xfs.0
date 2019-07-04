Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33516 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbfGDPDA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jul 2019 11:03:00 -0400
Date: Thu, 4 Jul 2019 08:02:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: vfs-for-next updated to 7e328e5930ad
Message-ID: <20190704150258.GA1404256@magnolia>
References: <20190701160656.GM1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701160656.GM1404256@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

Hi folks,

The vfs-for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  This is a resend of an earlier announcement about the
SETFLAGS and FSSETXATTR refactoring that I've started for 5.3 and will
continue for 5.4 so that these ioctls will have more consistent
behavior with the filesystems that originally created them.

The new head of the vfs-for-next branch is commit:

7e328e5930ad mm/fs: don't allow writes to immutable files

New Commits:

Darrick J. Wong (6):
      [5aca284210ce] vfs: create a generic checking and prep function for FS_IOC_SETFLAGS
      [7b0e492e6b80] vfs: create a generic checking function for FS_IOC_FSSETXATTR
      [f991492ed110] vfs: teach vfs_ioc_fssetxattr_check to check project id info
      [ca29be753445] vfs: teach vfs_ioc_fssetxattr_check to check extent size hints
      [dbc77f31e58b] vfs: only allow FSSETXATTR to set DAX flag on files and dirs
      [7e328e5930ad] mm/fs: don't allow writes to immutable files


Code Diffstat:

 fs/attr.c           |  13 ++---
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
 mm/filemap.c        |   3 +
 mm/memory.c         |   4 ++
 mm/mmap.c           |   8 ++-
 19 files changed, 319 insertions(+), 251 deletions(-)
