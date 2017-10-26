Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751943AbdJZAdA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Oct 2017 20:33:00 -0400
Date: Wed, 25 Oct 2017 17:32:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: fixes for 4.14-rc7
Message-ID: <20171026003258.GT5483@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here's (hopefully) the last bugfix for 4.14.

--D

The following changes since commit 785545c8982604fe3ba79d16409e83993be77d5e:

  xfs: move two more RT specific functions into CONFIG_XFS_RT (2017-10-16 12:26:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.14-fixes-7

for you to fetch changes up to 942491c9e6d631c012f3c4ea8e7777b0b02edeab:

  xfs: fix AIM7 regression (2017-10-23 18:31:50 -0700)

----------------------------------------------------------------
Changes since last time:
- Rework nowait locking code to reduce locking overhead penalty

----------------------------------------------------------------
Christoph Hellwig (1):
      xfs: fix AIM7 regression

 fs/xfs/xfs_file.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)
