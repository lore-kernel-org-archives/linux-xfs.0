Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3E5vPDE039621 for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 00:57:25 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE0E412FD431
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 22:59:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	4gsuFlBrg9o1HZNv for <xfs@oss.sgi.com>;
	Tue, 13 Apr 2010 22:59:18 -0700 (PDT)
Date: Wed, 14 Apr 2010 15:59:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] reviewed patches for -dev tree
Message-ID: <20100414055915.GI2493@dastard>
References: <20100413080357.GV2493@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100413080357.GV2493@dastard>
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

On Tue, Apr 13, 2010 at 06:03:57PM +1000, Dave Chinner wrote:
> Alex,
> 
> Can you please pull from the tree indicated below. It contains all
> the outstanding reviewed patches not you committed to the xfs-dev
> tree.
> 
> Also, the following commits in the pull request need to be pushed to
> mainline for 2.6.34:
> 
> 	xfs: ensure that sync updates the log tail correctly
> 	xfs: don't warn on EAGAIN in inode reclaim
> 
> The first addresses a regression introduced in 2.6.34-rc1, the
> second silences a needless warning that is being reported on
> 2.6.33.

I just updated the branch with this commit appended:

	xfs: make the log ticket transaction id random

So it now looks like:

The following changes since commit 68a2ac777cca40ccc993512bcf457999be71cc36:
  Christoph Hellwig (1):
        xfs: clean up xlog_write_adv_cnt

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git ..BRANCH.NOT.VERIFIED..

Alex Elder (6):
      xfs: add const qualifiers to xfs error function args
      xfs: fix min bufsize bugs in two places
      xfs: simplify XLOG_SECTOR_ROUND*()
      xfs: kill XLOG_SECTOR_ROUND*()
      xfs: encapsulate bbcount validity checking
      xfs: nothing special about 1-block log sector

Christoph Hellwig (1):
      xfs: remove xfs_dqmarker

Dave Chinner (8):
      xfs: ensure that sync updates the log tail correctly
      xfs: don't warn on EAGAIN in inode reclaim
      xfs: add log item recovery tracing
      xfs: convert the per-mount dquot list to use list heads
      xfs: remove duplicate code from dquot reclaim
      xfs: convert the dquot hash list to use list heads
      xfs: convert the dquot free list to use list heads
      xfs: make the log ticket transaction id random

 fs/xfs/linux-2.6/xfs_sync.c    |    4 +-
 fs/xfs/linux-2.6/xfs_trace.c   |    3 +
 fs/xfs/linux-2.6/xfs_trace.h   |  141 +++++++++++-
 fs/xfs/quota/xfs_dquot.c       |  120 ++++------
 fs/xfs/quota/xfs_dquot.h       |   35 +---
 fs/xfs/quota/xfs_qm.c          |  515 ++++++++++++++--------------------------
 fs/xfs/quota/xfs_qm.h          |   23 +--
 fs/xfs/quota/xfs_qm_stats.c    |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |   38 ++--
 fs/xfs/quota/xfs_quota_priv.h  |   75 ------
 fs/xfs/xfs_buf_item.h          |    2 +-
 fs/xfs/xfs_error.c             |   30 ++--
 fs/xfs/xfs_error.h             |    9 +-
 fs/xfs/xfs_log.c               |   40 ++-
 fs/xfs/xfs_log_recover.c       |  155 +++++++++----
 fs/xfs/xfs_trans.h             |    9 +
 16 files changed, 563 insertions(+), 638 deletions(-)

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
