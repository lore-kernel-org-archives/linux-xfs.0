Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750761AbdFQGZy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 17 Jun 2017 02:25:54 -0400
Date: Fri, 16 Jun 2017 23:25:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: updates for 4.12-rc6
Message-ID: <20170617062553.GI5421@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

I've one more bugfix for you for 4.12-rc6 to fix something that came up
in an earlier rc.

--Darrick

The following changes since commit 63db7c815bc0997c29e484d2409684fdd9fcd93b:

  xfs: use ->b_state to fix buffer I/O accounting release race (2017-05-31 08:22:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.12-fixes-4

for you to fetch changes up to 95989c46d2a156365867b1d795fdefce71bce378:

  xfs: fix spurious spin_is_locked() assert failures on non-smp kernels (2017-06-08 08:23:07 -0700)

----------------------------------------------------------------
Changes since last update:
- Fix some bogus ASSERT failures on CONFIG_SMP=n and CONFIG_XFS_DEBUG=y.

----------------------------------------------------------------
Brian Foster (1):
      xfs: fix spurious spin_is_locked() assert failures on non-smp kernels

 fs/xfs/xfs_buf.c    | 2 +-
 fs/xfs/xfs_icache.c | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)
