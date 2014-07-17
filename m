Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A0B967F8E
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 18:37:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 163368F8039
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 16:37:54 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	LPCgefiGwriw1ZGL for <xfs@oss.sgi.com>;
	Thu, 17 Jul 2014 16:37:52 -0700 (PDT)
Date: Fri, 18 Jul 2014 09:37:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: fixes for 3.16-rc5
Message-ID: <20140717233750.GE20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Can you please pull the updates listed below? These are regression
fixes for issues recently introduced - the change in the stack
switch location is fairly important, so I've held off sending this
update until I was sure that it still addresses the stack usage
problem the original solved. So while the commits in the xfs tree
are recent, it has been under tested for several weeks now.

-Dave.

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-3.16-rc5

for you to fetch changes up to 03e01349c654fbdea80d3d9b4ab599244eb55bb7:

  xfs: null unused quota inodes when quota is on (2014-07-15 07:28:41 +1000)

----------------------------------------------------------------
xfs: fixes for 3.15-rc5

Fixes for low memory perforamnce regressions and a quota inode handling
regression.

----------------------------------------------------------------
Dave Chinner (3):
      Revert "xfs: block allocation work needs to be kswapd aware"
      xfs: refine the allocation stack switch
      xfs: null unused quota inodes when quota is on

 fs/xfs/xfs_bmap.c      |    7 ++-----
 fs/xfs/xfs_bmap.h      |    4 +---
 fs/xfs/xfs_bmap_util.c |   53 -----------------------------------------------------
 fs/xfs/xfs_bmap_util.h |    4 ----
 fs/xfs/xfs_btree.c     |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_iomap.c     |    3 +--
 fs/xfs/xfs_sb.c        |   25 +++++++++++++++++++++----
 7 files changed, 106 insertions(+), 72 deletions(-)


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
