Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2HWkrc091774 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 11:32:46 -0600
Subject: [GIT PULL] XFS update for 3.2-rc5
Message-Id: <20111202173306.91F81426DA7@whiskey.americas.sgi.com>
Date: Fri,  2 Dec 2011 11:33:06 -0600 (CST)
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

Subject: [GIT PULL] XFS update for 3.2-rc5

Linus, please pull the following bug fixes for XFS for 3.2-rc5.

fa8b18e fixes memory corruption if the on-disk ACL is corrupted,
4dd2cb4 fixes a delay in inode reclaim, and
4c393a6 fixes a reproducible crash when operating on the attribute fork.

Thanks,
	Ben



The following changes since commit 5983fe2b29df5885880d7fa3b91aca306c7564ef:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (3):
      xfs: validate acl count
      xfs: force buffer writeback before blocking on the ilock in inode reclaim
      xfs: fix attr2 vs large data fork assert

 fs/xfs/xfs_acl.c       |    2 +
 fs/xfs/xfs_attr_leaf.c |   64 +++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_inode.c     |   21 +++++++++++++++
 fs/xfs/xfs_inode.h     |    1 +
 fs/xfs/xfs_sync.c      |   11 ++++++++
 5 files changed, 74 insertions(+), 25 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
