Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751102AbdKQTqq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 14:46:46 -0500
Date: Fri, 17 Nov 2017 11:46:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.15
Message-ID: <20171117194645.GN5119@magnolia>
References: <20171114014954.GF25227@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171114014954.GF25227@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here are a couple more patches to fix a locking bug and some inconsistent
type usage in some of the new code.

--D

The following changes since commit abc36be236358162202e86ad88616ff95a755101:

  Merge tag 'configfs-for-4.15' of git://git.infradead.org/users/hch/configfs (2017-11-14 14:44:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.15-merge-2

for you to fetch changes up to 2015a63dce8d73a439232a0d5162c88d8513101e:

  xfs: fix type usage (2017-11-16 12:06:45 -0800)

----------------------------------------------------------------
Changes since last update:
- Fix a forgotten rcu read unlock
- Fix some inconsistent integer type usage.

----------------------------------------------------------------
Darrick J. Wong (2):
      xfs: fix forgotten rcu read unlock when skipping inode reclaim
      xfs: fix type usage

 fs/xfs/libxfs/xfs_iext_tree.c  | 2 +-
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 fs/xfs/xfs_inode.c             | 1 +
 3 files changed, 4 insertions(+), 3 deletions(-)
