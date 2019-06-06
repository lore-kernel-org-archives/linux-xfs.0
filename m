Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729109AbfFFPRa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Jun 2019 11:17:30 -0400
Date: Thu, 6 Jun 2019 08:17:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 5.2-rc4
Message-ID: <20190606151727.GH1200785@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net, hch@lst.de

Hi Linus,

Here are a couple more bug fixes for 5.2.  They've survived a few days
of fstests and merge cleanly with upstream as of a few minutes ago.  Let
me know if there are problems.

--D

The following changes since commit 5cd213b0fec640a46adc5e6e4dfc7763aa54b3b2:

  xfs: don't reserve per-AG space for an internal log (2019-05-20 11:25:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.2-fixes-2

for you to fetch changes up to 025197ebb08a77eea702011c479ece1229a9525b:

  xfs: inode btree scrubber should calculate im_boffset correctly (2019-06-03 09:18:40 -0700)

----------------------------------------------------------------
Changes since last update:
- Fix some forgotten strings in a log debugging function
- Fix incorrect unit conversion in online fsck code

----------------------------------------------------------------
Darrick J. Wong (2):
      xfs: fix broken log reservation debugging
      xfs: inode btree scrubber should calculate im_boffset correctly

 fs/xfs/scrub/ialloc.c |  3 ++-
 fs/xfs/xfs_log.c      | 11 +++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)
