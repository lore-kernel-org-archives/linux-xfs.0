Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o974QqWY148770 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 23:26:52 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201010070427.o974RmcC012153@stout.americas.sgi.com>
Date: Wed, 06 Oct 2010 23:27:48 -0500
Subject: [GIT PULL] XFS fix for 2.6.36
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

I'm hoping this XFS change can make it in to 2.6.36.  It fixes a bug
that causes allocation groups to be needlessly scanned for reclaim,
because some reclaim state in XFS is never properly cleared when an
inode gets reclaimed.  The result can make filesystems appear to
have an ever-increasing number of reclaimable objects, even if there
is nothing to do.

					-Alex

The following changes since commit cb655d0f3d57c23db51b981648e452988c0223f9:

  Linux 2.6.36-rc7 (2010-10-06 13:39:52 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Johannes Weiner (1):
      xfs: properly account for reclaimed inodes

 fs/xfs/linux-2.6/xfs_sync.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
