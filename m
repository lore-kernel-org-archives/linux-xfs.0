Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750742AbdLAUvl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Dec 2017 15:51:41 -0500
Date: Fri, 1 Dec 2017 12:51:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.15-rc2
Message-ID: <20171201205139.GV21412@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here are some bug fixes for 4.15-rc2.

--D

The following changes since commit 4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323:

  Linux 4.15-rc1 (2017-11-26 16:01:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.15-fixes-4

for you to fetch changes up to 373b0589dc8d58bc09c9a28d03611ae4fb216057:

  xfs: Properly retry failed dquot items in case of error during buffer writeback (2017-11-30 08:47:40 -0800)

----------------------------------------------------------------
Changes since last update:
- Fix memory leaks that appeared after removing ifork inline data buffer
- Recover deferred rmap update log items in correct order
- Fix memory leaks when buffer construction fails
- Fix memory leaks when bmbt is corrupt
- Fix some uninitialized variables and math problems in the quota scrubber
- Add some omitted attribution tags on the log replay commit
- Fix some UBSAN complaints about integer overflows with large sparse files
- Implement an effective inode mode check in online fsck
- Fix log's inability to retry quota item writeout due to transient errors

----------------------------------------------------------------
Carlos Maiolino (1):
      xfs: Properly retry failed dquot items in case of error during buffer writeback

Darrick J. Wong (5):
      xfs: always free inline data before resetting inode fork during ifree
      xfs: log recovery should replay deferred ops in order
      xfs: ubsan fixes
      xfs: remove unused parameter from xfs_writepage_map
      xfs: scrub inode mode properly

Eric Sandeen (3):
      xfs: fix leaks on corruption errors in xfs_bmap.c
      xfs: fix uninitialized variable in xfs_scrub_quota
      xfs: calculate correct offset in xfs_scrub_quota_item

Michal Hocko (1):
      xfs: fortify xfs_alloc_buftarg error handling

 fs/xfs/libxfs/xfs_bmap.c   |  6 ++--
 fs/xfs/scrub/inode.c       | 14 ++++++++-
 fs/xfs/scrub/quota.c       |  4 +--
 fs/xfs/xfs_aops.c          | 12 ++++----
 fs/xfs/xfs_bmap_item.c     | 23 +++++---------
 fs/xfs/xfs_bmap_item.h     |  3 +-
 fs/xfs/xfs_buf.c           | 15 ++++++----
 fs/xfs/xfs_dquot.c         | 14 +++++++--
 fs/xfs/xfs_dquot_item.c    | 40 +++++++++++++++++++++++--
 fs/xfs/xfs_inode.c         | 21 +++++++++++++
 fs/xfs/xfs_log_recover.c   | 75 +++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_refcount_item.c | 21 +++++--------
 fs/xfs/xfs_refcount_item.h |  3 +-
 13 files changed, 190 insertions(+), 61 deletions(-)
