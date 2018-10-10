Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:32591 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726035AbeJKHUH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 03:20:07 -0400
Date: Thu, 11 Oct 2018 10:55:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: fixes for v4.19-rc7
Message-ID: <20181010235534.GA8838@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: gregkh@linuxfoundation.org
Cc: djwong@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net

Hi Greg,

Can you please pull the XFS update from the tag listed below? This
contains the fix for the clone_file_range data corruption issue I
mentioned in my -rc6 pull request (zero post-eof blocks), as well as
fixes for several other equally serious problems we found while
auditing the clone/dedupe ioctls for other issues. The rest of the
problems we found (there were a *lot*) will be addressed in the 4.20
cycle.

Cheers,

Dave.

The following changes since commit e55ec4ddbef9897199c307dfb23167e3801fdaf5:

  xfs: fix error handling in xfs_bmap_extents_to_btree (2018-10-01 08:11:07 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux tags/xfs-fixes-for-4.19-rc7

for you to fetch changes up to b39989009bdb84992915c9869f58094ed5becf10:

  xfs: fix data corruption w/ unaligned reflink ranges (2018-10-06 11:44:39 +1000)

----------------------------------------------------------------
xfs: fixes for 4.19-rc7

Update for 4.19-rc7 to fix numerous file clone and deduplication issues.

----------------------------------------------------------------
Darrick J. Wong (3):
      xfs: refactor clonerange preparation into a separate helper
      xfs: zero posteof blocks when cloning above eof
      xfs: update ctime and remove suid before cloning files

Dave Chinner (2):
      xfs: fix data corruption w/ unaligned dedupe ranges
      xfs: fix data corruption w/ unaligned reflink ranges

 fs/xfs/xfs_reflink.c | 200 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 165 insertions(+), 35 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
