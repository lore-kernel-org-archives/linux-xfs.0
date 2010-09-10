Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ALeAjf166532 for <xfs@oss.sgi.com>; Fri, 10 Sep 2010 16:40:10 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201009102140.o8ALeu1o011316@stout.americas.sgi.com>
Date: Fri, 10 Sep 2010 16:40:56 -0500
Subject: [GIT PULL] XFS update #2 for 2.6.36-rc4
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

Two more XFS changes for 2.6.36--one fixes a security problem
and the other addresses a regression due to the recent
workqueue updates.

					-Alex

The following changes since commit df423dc7f2a801b9a45d7c501a8eb5c529455ea1:

  Merge branch 'upstream-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev (2010-09-09 20:28:19 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dan Rosenberg (1):
      xfs: prevent reading uninitialized stack memory

Dave Chinner (1):
      xfs: log IO completion workqueue is a high priority queue

 fs/xfs/linux-2.6/xfs_buf.c   |    3 ++-
 fs/xfs/linux-2.6/xfs_ioctl.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
