Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbfGRQSZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jul 2019 12:18:25 -0400
Date: Thu, 18 Jul 2019 09:18:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: cleanups for 5.3
Message-ID: <20190718161824.GE7093@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org, sandeen@sandeen.net, hch@lst.de

Hi Linus,

We had a few more lateish cleanup patches come in for 5.3 -- a couple of
syncups with the userspace libxfs code and a conversion of the XFS
administrator's guide to ReST format.

The branch does /not/ merge cleanly against this morning's HEAD due to a
conflict in Documentation/admin-guide/index.rst.  The conflict can be
resolved by adding the "xfs" line after "binderfs".  The series survived
an overnight run of xfstests.

Please let me know if you run into anything weird, I promise I drank two
cups of coffee this time around. :)

--D

The following changes since commit 488ca3d8d088ec4658c87aaec6a91e98acccdd54:

  xfs: chain bios the right way around in xfs_rw_bdev (2019-07-10 10:04:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.3-merge-13

for you to fetch changes up to 89b408a68b9dd163b2705b6f73d8e3cc3579b457:

  Documentation: filesystem: Convert xfs.txt to ReST (2019-07-15 09:15:09 -0700)

----------------------------------------------------------------
Also new for 5.3:
- Bring fs/xfs/libxfs/xfs_trans_inode.c in sync with userspace libxfs.
- Convert the xfs administrator guide to rst and move it into the
  official admin guide under Documentation

----------------------------------------------------------------
Eric Sandeen (2):
      xfs: move xfs_trans_inode.c to libxfs/
      xfs: sync up xfs_trans_inode with userspace

Sheriff Esseson (1):
      Documentation: filesystem: Convert xfs.txt to ReST

 Documentation/admin-guide/index.rst                |   1 +
 .../{filesystems/xfs.txt => admin-guide/xfs.rst}   | 132 ++++++++++-----------
 Documentation/filesystems/dax.txt                  |   2 +-
 MAINTAINERS                                        |   3 +-
 fs/xfs/Makefile                                    |   4 +-
 fs/xfs/{ => libxfs}/xfs_trans_inode.c              |   4 +
 6 files changed, 73 insertions(+), 73 deletions(-)
 rename Documentation/{filesystems/xfs.txt => admin-guide/xfs.rst} (80%)
 rename fs/xfs/{ => libxfs}/xfs_trans_inode.c (96%)
