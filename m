Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387950AbfHCQdO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 3 Aug 2019 12:33:14 -0400
Date: Sat, 3 Aug 2019 09:33:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: cleanups for 5.3-rc3
Message-ID: <20190803163312.GK7138@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org, sandeen@sandeen.net, hch@lst.de

Hi Linus,

Here are a couple more bug fixes that trickled in since -rc1.  It's
survived the usual xfstests runs and merges cleanly with this morning's
master.  Please let me know if anything strange happens.

--D

The following changes since commit 609488bc979f99f805f34e9a32c1e3b71179d10b:

  Linux 5.3-rc2 (2019-07-28 12:47:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.3-fixes-1

for you to fetch changes up to afa1d96d1430c2138c545fb76e6dcb21222098d4:

  xfs: Fix possible null-pointer dereferences in xchk_da_btree_block_check_sibling() (2019-07-30 11:28:20 -0700)

----------------------------------------------------------------
Changes since last update:
- Avoid leaking kernel stack contents to userspace.
- Fix a potential null pointer dereference in the dabtree scrub code.

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: fix stack contents leakage in the v1 inumber ioctls

Jia-Ju Bai (1):
      xfs: Fix possible null-pointer dereferences in xchk_da_btree_block_check_sibling()

 fs/xfs/scrub/dabtree.c | 6 +++++-
 fs/xfs/xfs_itable.c    | 3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)
