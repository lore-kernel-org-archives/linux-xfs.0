Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbeHDHQi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 4 Aug 2018 03:16:38 -0400
Date: Fri, 3 Aug 2018 22:17:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: 4.18 fixes, part 3
Message-ID: <20180804051718.GY30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

Hi Linus,

Here's one more patch for 4.18 to fix a coding error in the iomap_bmap
function introduced in -rc1.

This series has been run through a full xfstests run during the week and
through a quick xfstests run against this morning's master, with no
major failures reported.

--D

The following changes since commit d4a34e16555708bab5b67e679a95f055d8ef9882:

  xfs: properly handle free inodes in extent hint validators (2018-07-24 11:34:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.18-fixes-5

for you to fetch changes up to 79b3dbe4adb3420e74cf755b4beb5d2b43d5928d:

  fs: fix iomap_bmap position calculation (2018-08-02 13:09:27 -0700)

----------------------------------------------------------------
Changes since last update:
- Fix incorrect shifting in the iomap bmap functions.

----------------------------------------------------------------
Eric Sandeen (1):
      fs: fix iomap_bmap position calculation

 fs/iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
