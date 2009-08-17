Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7H6qDxH055775 for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 01:52:24 -0500
Received: from attica.americas.sgi.com (attica.americas.sgi.com
	[128.162.236.44])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DC53D3040D8
	for <xfs@oss.sgi.com>; Sun, 16 Aug 2009 23:53:01 -0700 (PDT)
Date: Mon, 17 Aug 2009 01:44:47 -0500
Subject: [GIT PULL] XFS update for 2.6.31-rc7
MIME-Version: 1.0
Message-Id: <20090817064448.0CF1DA4A9DC6@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

The following changes since commit 894ef820b10d77e2d6d717342fc408bdd9825139:
  Randy Dunlap (1):
        dm-log-userspace: fix printk format warning

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (1):
      xfs: fix locking in xfs_iget_cache_hit

 fs/xfs/linux-2.6/xfs_sync.c |   13 ++++-
 fs/xfs/linux-2.6/xfs_sync.h |    1 +
 fs/xfs/xfs_iget.c           |  113 ++++++++++++++++++++++---------------------
 3 files changed, 70 insertions(+), 57 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
