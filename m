Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p68EYUEU248095 for <xfs@oss.sgi.com>; Fri, 8 Jul 2011 09:34:31 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201107081434.p68EYQcs020701@stout.americas.sgi.com>
Date: Fri, 08 Jul 2011 09:34:26 -0500
Subject: [GIT PULL] XFS update for 3.0-rc7
MIME-Version: 1.0
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

Linus, please pull the following XFS fix in for 3.0-rc7 (or final).

Previously, a dubious trick was used to avoid a race involving
inodes in the active item list.  This fix is pretty simple, and the
result is a much cleaner and more direct (and reliable) solution to
the problem.

It looks like I missed the last -next build for a while.  But I have
done a merge of my branch with your current master branch (shown
below).  The result has no conflicts and builds and tests just fine.

Thank you.

					-Alex

The following changes since commit f1bb20a8365f6753e0f7b6e94981ca2b662bae13:

  Merge branch 'for-30-rc5/all-i2c' of git://git.fluff.org/bjdooks/linux (2011-07-07 16:29:29 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: unpin stale inodes directly in IOP_COMMITTED

 fs/xfs/xfs_inode_item.c |   14 ++++++++------
 fs/xfs/xfs_trans.c      |    4 ++--
 2 files changed, 10 insertions(+), 8 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
