Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750971AbdFBTW6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jun 2017 15:22:58 -0400
Date: Fri, 2 Jun 2017 12:22:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: updates for 4.12-rc4
Message-ID: <20170602192256.GC5636@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

I've one more bugfix for you for 4.12-rc4.

--Darrick

The following changes since commit a54fba8f5a0dc36161cacdf2aa90f007f702ec1a:

  xfs: Move handling of missing page into one place in xfs_find_get_desired_pgoff() (2017-05-25 09:42:25 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.12-fixes-3

for you to fetch changes up to 63db7c815bc0997c29e484d2409684fdd9fcd93b:

  xfs: use ->b_state to fix buffer I/O accounting release race (2017-05-31 08:22:52 -0700)

----------------------------------------------------------------
Changes since last update:
- Fix an unmount hang due to a race in io buffer accounting.

----------------------------------------------------------------
Brian Foster (1):
      xfs: use ->b_state to fix buffer I/O accounting release race

 fs/xfs/xfs_buf.c | 38 ++++++++++++++++++++++++++------------
 fs/xfs/xfs_buf.h |  5 ++---
 2 files changed, 28 insertions(+), 15 deletions(-)
