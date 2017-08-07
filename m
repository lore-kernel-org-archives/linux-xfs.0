Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33646 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751800AbdHGTWM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2017 15:22:12 -0400
Date: Mon, 7 Aug 2017 12:22:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] xfs: fixes for 4.13-rc5
Message-ID: <20170807192205.GN24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

I have a couple more bug fixes for you today.

--Darrick

The following changes since commit 5b094d6dac0451ad89b1dc088395c7b399b7e9e8:

  xfs: fix multi-AG deadlock in xfs_bunmapi (2017-07-26 08:20:03 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.13-fixes-3

for you to fetch changes up to 56bdf855e676f1f2ed7033f288f57dfd315725ba:

  xfs: Fix per-inode DAX flag inheritance (2017-08-04 13:43:36 -0700)

----------------------------------------------------------------
Changes since last update:
- Fix memory leak when issuing discard
- Fix propagation of the dax inode flag

----------------------------------------------------------------
Jan Kara (1):
      xfs: Fix leak of discard bio

Lukas Czerner (1):
      xfs: Fix per-inode DAX flag inheritance

 fs/xfs/xfs_inode.c   | 12 +++++++-----
 fs/xfs/xfs_log_cil.c |  1 +
 2 files changed, 8 insertions(+), 5 deletions(-)
