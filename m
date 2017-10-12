Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752096AbdJLVnL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Oct 2017 17:43:11 -0400
Date: Thu, 12 Oct 2017 14:43:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.14-rc5
Message-ID: <20171012214309.GK7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here's round three of bug fixes and other build problems.

--D

The following changes since commit e12199f85d0ad1b04ce6c425ad93cd847fe930bb:

   xfs: handle racy AIO in xfs_reflink_end_cow (2017-10-03 21:27:55 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.14-fixes-5

for you to fetch changes up to 93e8befc17f6d6ea92b0aee3741ceac8bca4590f:

  xfs: handle error if xfs_btree_get_bufs fails (2017-10-11 10:21:07 -0700)

----------------------------------------------------------------
Changes since last update:
- Fix a stale kernel memory exposure when logging inodes.
- Fix some build problems with CONFIG_XFS_RT=n
- Don't change inode mode if the acl write fails, leaving the file totally
  inaccessible.
- Fix a dangling pointer problem when removing an attr fork under memory
  pressure.
- Don't crash while trying to invalidate a null buffer associated with a
  corrupt metadata pointer.

----------------------------------------------------------------
Brian Foster (1):
      xfs: reinit btree pointer on attr tree inactivation walk

Dave Chinner (3):
      xfs: Don't log uninitialised fields in inode structures
      xfs: move more RT specific code under CONFIG_XFS_RT
      xfs: don't change inode mode if ACL update fails

Eric Sandeen (1):
      xfs: handle error if xfs_btree_get_bufs fails

Thomas Meyer (1):
      xfs: Fix bool initialization/comparison

 fs/xfs/libxfs/xfs_alloc.c      |  8 +++++
 fs/xfs/libxfs/xfs_bmap.c       |  4 +--
 fs/xfs/libxfs/xfs_ialloc.c     |  4 +--
 fs/xfs/libxfs/xfs_log_format.h | 27 +++++----------
 fs/xfs/xfs_acl.c               | 22 ++++++++----
 fs/xfs/xfs_attr_inactive.c     |  2 ++
 fs/xfs/xfs_bmap_util.c         |  2 ++
 fs/xfs/xfs_bmap_util.h         | 13 +++++++
 fs/xfs/xfs_file.c              |  4 +--
 fs/xfs/xfs_fsmap.c             | 12 +++++++
 fs/xfs/xfs_inode_item.c        | 79 ++++++++++++++++++++++--------------------
 fs/xfs/xfs_log.c               |  2 +-
 fs/xfs/xfs_mount.c             |  2 +-
 fs/xfs/xfs_ondisk.h            |  2 +-
 14 files changed, 111 insertions(+), 72 deletions(-)
