Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754572AbdFWSVX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jun 2017 14:21:23 -0400
Date: Fri, 23 Jun 2017 11:21:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: updates for 4.12-rc7
Message-ID: <20170623182121.GA4733@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

I've one more bugfix for you for 4.12-rc7 to fix a disk corruption
problem.

--Darrick

The following changes since commit 95989c46d2a156365867b1d795fdefce71bce378:

  xfs: fix spurious spin_is_locked() assert failures on non-smp kernels (2017-06-08 08:23:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.12-fixes-5

for you to fetch changes up to eb5e248d502bec191bd99f04cae8b49992b3abde:

  xfs: don't allow bmap on rt files (2017-06-21 20:27:35 -0700)

----------------------------------------------------------------
Changes since last update:
- don't allow swapon on files on the realtime device, because the swap
  code will swap pages out to blocks on the data device, thereby
  corrupting the filesystem

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: don't allow bmap on rt files

 fs/xfs/xfs_aops.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)
