Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:13145 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753248AbcKJEjZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Nov 2016 23:39:25 -0500
Date: Thu, 10 Nov 2016 15:38:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: updates for 4.9-rc5
Message-ID: <20161110043830.GF28922@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org

Hi Linus,

Can you please pull the XFS fix from the tag below. It's a fix for
an unmount hang (regression) when the filesystem is shutdown. It
was supposed to go to you for -rc3, but I accidentally tagged the
commit prior to it in that pullreq.

Thanks,

-Dave.

The following changes since commit c17a8ef43d6b80ed3519b828c37d18645445949f:

  xfs: clear cowblocks tag when cow fork is emptied (2016-10-24 14:21:08 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-fixes-for-linus-4.9-rc5

for you to fetch changes up to b77428b12b55437b28deae738d9ce8b2e0663b55:

  xfs: defer should abort intent items if the trans roll fails (2016-10-24 14:21:18 +1100)

----------------------------------------------------------------
xfs: update for 4.9-rc5

In this update:
o fix for aborting deferred transactions on filesystem shutdown.

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: defer should abort intent items if the trans roll fails

 fs/xfs/libxfs/xfs_defer.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
