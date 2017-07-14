Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751004AbdGNXhv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jul 2017 19:37:51 -0400
Date: Fri, 14 Jul 2017 16:37:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: updates for 4.13, part 2
Message-ID: <20170714233750.GD4224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here are some more changes for you for 4.13; they're largely debugging
and regression fixes.  The branch merges against this afternoon's HEAD
without issue; a quick overnight xfstests run against yesterday's HEAD
came out cleanly.  Let me know if there are any problems.

--Darrick

The following changes since commit cd87d867920155911d0d2e6485b769d853547750:

  xfs: don't crash on unexpected holes in dir/attr btrees (2017-07-07 18:55:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.13-merge-6

for you to fetch changes up to d6ab17f261919d212ec0a9e33d01f46df0ec1fde:

  vfs: in iomap seek_{hole,data}, return -ENXIO for negative offsets (2017-07-13 14:55:05 -0700)

----------------------------------------------------------------
Changes since last update:
- Add some locking assertions for the _ilock helpers.
- Revert the XFS_QMOPT_NOLOCK patch; after discussion with hch the
  online fsck patch that would have needed it has been redesigned and
  no longer needs it.
- Fix behavioral regression of SEEK_HOLE/DATA with negative offsets to match
  4.12-era XFS behavior.

----------------------------------------------------------------
Christoph Hellwig (4):
      xfs: fixup xfs_attr_get_ilocked
      xfs: assert locking precondіtion in xfs_attr_list_int_ilocked
      xfs: assert locking precondition in xfs_readlink_bmap_ilocked
      Revert "xfs: grab dquots without taking the ilock"

Darrick J. Wong (1):
      vfs: in iomap seek_{hole,data}, return -ENXIO for negative offsets

 fs/iomap.c                     |  8 ++++----
 fs/xfs/libxfs/xfs_attr.c       |  4 +++-
 fs/xfs/libxfs/xfs_quota_defs.h |  2 --
 fs/xfs/xfs_attr_list.c         |  2 ++
 fs/xfs/xfs_dquot.c             | 14 ++++----------
 fs/xfs/xfs_symlink.c           |  2 ++
 6 files changed, 15 insertions(+), 17 deletions(-)
