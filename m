Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751412AbdJFVqP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Oct 2017 17:46:15 -0400
Date: Fri, 6 Oct 2017 14:46:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.14-rc4
Message-ID: <20171006214611.GN7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here's the second round of bug fixes for 4.14.

--D

The following changes since commit 5e5c943c1f257c2b3424fc3f8a7b18570152dab3:

  xfs: revert "xfs: factor rmap btree size into the indlen calculations" (2017-09-26 10:55:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-4.14-fixes-4

for you to fetch changes up to e12199f85d0ad1b04ce6c425ad93cd847fe930bb:

   xfs: handle racy AIO in xfs_reflink_end_cow (2017-10-03 21:27:55 -0700)

----------------------------------------------------------------
Changes since last update:
- fix a race between overlapping copy on write aio
- fix cow fork swapping when we defragment reflinked files

----------------------------------------------------------------
Christoph Hellwig (1):
      xfs: handle racy AIO in xfs_reflink_end_cow

Darrick J. Wong (1):
      xfs: always swap the cow forks when swapping extents

 fs/xfs/xfs_bmap_util.c | 24 ++++++++++++++++++++++--
 fs/xfs/xfs_reflink.c   |  9 ++++++++-
 2 files changed, 30 insertions(+), 3 deletions(-)
