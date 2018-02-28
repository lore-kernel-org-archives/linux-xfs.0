Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753021AbeB1TV0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Feb 2018 14:21:26 -0500
Date: Wed, 28 Feb 2018 11:21:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.16-rc4
Message-ID: <20180228192125.GM19312@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here's the first round of bugfixes for 4.16.  It should merge cleanly,
but please let me know if it doesn't.

--Darrick

The following changes since commit 7928b2cbe55b2a410a0f5c1f154610059c57b1b2:

  Linux 4.16-rc1 (2018-02-11 15:04:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.16-fixes-2

for you to fetch changes up to 5b4c845ea4f4b86c43096eb924354c83a2e26f3c:

  xfs: fix potential memory leak in mount option parsing (2018-02-26 10:02:13 -0800)

----------------------------------------------------------------
Changes since last update:
- Fix some compiler warnings
- Fix block rservations for transactions created during log recovery
- Fix resource leaks when respecifying mount options

----------------------------------------------------------------
Chengguang Xu (1):
      xfs: fix potential memory leak in mount option parsing

Darrick J. Wong (1):
      xfs: reserve blocks for refcount / rmap log item recovery

Eric Sandeen (1):
      xfs: use memset to initialize xfs_scrub_agfl_info

 fs/xfs/scrub/agheader.c    | 3 ++-
 fs/xfs/xfs_refcount_item.c | 9 ++++++---
 fs/xfs/xfs_rmap_item.c     | 4 +++-
 fs/xfs/xfs_super.c         | 2 ++
 4 files changed, 13 insertions(+), 5 deletions(-)
