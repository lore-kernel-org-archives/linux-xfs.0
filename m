Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752052AbeCHSsB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Mar 2018 13:48:01 -0500
Date: Thu, 8 Mar 2018 10:48:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.16-rc5
Message-ID: <20180308184800.GA18989@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here's a few more fixes for locking problems and incorrect copy on
write behaviors on 4.16.  It should merge cleanly, but please let me
know if it doesn't.

--Darrick

The following changes since commit 5b4c845ea4f4b86c43096eb924354c83a2e26f3c:

  xfs: fix potential memory leak in mount option parsing (2018-02-26 10:02:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.16-fixes-3

for you to fetch changes up to ff3d8b9c4cb95180ae6ef9eed28409840525b9fa:

  xfs: don't block on the ilock for RWF_NOWAIT (2018-03-01 14:12:45 -0800)

----------------------------------------------------------------
Changes since last update:
- Fix some iomap locking problems
- Don't allocate cow blocks when we're zeroing file data

----------------------------------------------------------------
Christoph Hellwig (3):
      xfs: don't allocate COW blocks for zeroing holes or unwritten extents
      xfs: don't start out with the exclusive ilock for direct I/O
      xfs: don't block on the ilock for RWF_NOWAIT

 fs/xfs/xfs_iomap.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)
