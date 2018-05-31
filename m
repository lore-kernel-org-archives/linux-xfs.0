Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750739AbeEaVPp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 17:15:45 -0400
Date: Thu, 31 May 2018 14:15:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: hair on fire fixes for 4.17-rc7
Message-ID: <20180531211544.GX12940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Theodore Ts'o <tytso@mit.edu>

Hi Linus,

This last minute fix prevents writeback error state from persisting past
the end of the in-core inode lifecycle and causing EIO errors to be
reported to userspace when no error has occurred.

This fix for the behavioral regression has been soaking in for-next for
a while, but various fs developers persuaded me to try to get it
upstream for 4.17 because the patch that broke things was introduced in
4.17-rc4.  It merges cleanly with master as of this morning.

(If you prefer I hold it for 4.18 and send it to stable for 4.17.1 as
originally planned, that's fine too.)

--D

The following changes since commit 021ba8e98fe5c6691b3cc3669faafa02403aa211:

  xfs: cap the length of deduplication requests (2018-05-02 09:21:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.17-fixes-3

for you to fetch changes up to 829bc787c1a0403e4d886296dd4d90c5f9c1744a:

  fs: clear writeback errors in inode_init_always (2018-05-30 19:43:53 -0700)

----------------------------------------------------------------
Changes since last update:
- Clear out i_mapping error state when we're reinitializing inodes.

----------------------------------------------------------------
Darrick J. Wong (1):
      fs: clear writeback errors in inode_init_always

 fs/inode.c | 1 +
 1 file changed, 1 insertion(+)
