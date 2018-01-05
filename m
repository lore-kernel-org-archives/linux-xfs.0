Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751933AbeAERmY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jan 2018 12:42:24 -0500
Date: Fri, 5 Jan 2018 09:42:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.15-rc7
Message-ID: <20180105174223.GJ5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

I have just a few fixes for bugs and resource cleanup problems this week.
It merges cleanly against your tree as of ~5min ago.

--Darrick

The following changes since commit 68c58e9b9a88c1a9d0c2eaf6c7acefb00f5fbbfb:

  xfs: only skip rmap owner checks for unknown-owner rmap removal (2017-12-21 08:48:38 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.15-fixes-10

for you to fetch changes up to b4d8ad7fd3a18e6d92d4ebe858185c704604a57d:

  xfs: fix s_maxbytes overflow problems (2018-01-02 10:16:32 -0800)

----------------------------------------------------------------
Changes since last update:
- Fix resource cleanup of failed quota initialization
- Fix integer overflow problems wrt s_maxbytes

----------------------------------------------------------------
Aliaksei Karaliou (2):
      xfs: quota: fix missed destroy of qi_tree_lock
      xfs: quota: check result of register_shrinker()

Darrick J. Wong (1):
      xfs: fix s_maxbytes overflow problems

 fs/xfs/xfs_aops.c  |  4 ++--
 fs/xfs/xfs_iomap.c |  2 +-
 fs/xfs/xfs_qm.c    | 46 ++++++++++++++++++++++++++++++----------------
 3 files changed, 33 insertions(+), 19 deletions(-)
