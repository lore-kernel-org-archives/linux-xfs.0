Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T5QZ1k041183 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 00:26:35 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09FE52FC98C
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 22:28:38 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	F9Ktd6E3piJDtFbS for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 22:28:38 -0700 (PDT)
Date: Thu, 29 Apr 2010 15:28:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] fixes for 2.6.34-rc6
Message-ID: <20100429052835.GE2512@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

Hi Alex,

Another couple of fixes for the dev tree, and at least the shrinker
addition needs to go Linus pretty quickly as that's a regression
we've introduced fixing the previous rounds on inode reclaim
probelms. Once that's in mainline, I'll have to backport it to
.32-stable and .33-stable as well.

TIA.

The following changes since commit 29db3370a1369541d58d692fbfb168b8a0bd7f41:
  Alex Elder (1):
        xfs: kill off l_sectbb_mask

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git for-dev

Dave Chinner (1):
      xfs: add a shrinker to background inode reclaim

Tao Ma (1):
      xfs: Make fiemap work in query mode.

 fs/xfs/linux-2.6/xfs_iops.c    |    5 ++-
 fs/xfs/linux-2.6/xfs_super.c   |    5 ++
 fs/xfs/linux-2.6/xfs_sync.c    |  112 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/linux-2.6/xfs_sync.h    |    7 ++-
 fs/xfs/quota/xfs_qm_syscalls.c |    3 +-
 fs/xfs/xfs_ag.h                |    1 +
 fs/xfs/xfs_mount.h             |    1 +
 7 files changed, 124 insertions(+), 10 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
