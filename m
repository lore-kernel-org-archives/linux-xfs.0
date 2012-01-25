Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0PKPKbt069037 for <xfs@oss.sgi.com>; Wed, 25 Jan 2012 14:25:20 -0600
Subject: [GIT PULL] XFS update for 3.3-rc1
Message-Id: <20120125202519.907DB426DA7@whiskey.americas.sgi.com>
Date: Wed, 25 Jan 2012 14:25:19 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

   Please pull in the following bugfix for xfs.  We forgot to drop a lock on
   error in xfs_readlink.  It hasn't been through -next yet, but there is no
   -next tree tomorrow.  The fix is clear so I'm sending this request today.

Thanks,
	Ben

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:
  Linus Torvalds (1):
        Linux 3.3-rc1

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git for-linus

Jan Kara (1):
      xfs: Fix missing xfs_iunlock() on error recovery path in xfs_readlink()

 fs/xfs/xfs_vnodeops.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
