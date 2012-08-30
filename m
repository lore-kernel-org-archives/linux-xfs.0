Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7UAv6fq182390 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 05:57:06 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mLPWOgWAi7jH6aQ1 for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 03:57:58 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T72Rh-0003hp-F6
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 20:57:57 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T72RX-00005u-Ao
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 20:57:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/13] xfs: remove the xfssyncd mess
Date: Thu, 30 Aug 2012 20:57:29 +1000
Message-Id: <1346324262-32724-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

Folks,

Here's the patchset I talked about here:

http://oss.sgi.com/archives/xfs/2012-06/msg00064.html

to sort out the syncd start/stop unmount race/panic mess once and
for all. I've only smoke tested it so far, but it hasn't let any out
yet.

The overall diffstat is:

 fs/xfs/Makefile                     |    3 +-
 fs/xfs/{xfs_sync.c => xfs_icache.c} |  694 +++++++++++++++++++++-------------
 fs/xfs/{xfs_sync.h => xfs_icache.h} |   14 +-
 fs/xfs/xfs_iget.c                   |  705 -----------------------------------
 fs/xfs/xfs_inode.c                  |  250 +++++++++++++
 fs/xfs/xfs_inode.h                  |   10 +-
 fs/xfs/xfs_iomap.c                  |    3 +-
 fs/xfs/xfs_log.c                    |   83 ++++-
 fs/xfs/xfs_log.h                    |    4 +
 fs/xfs/xfs_log_priv.h               |    1 +
 fs/xfs/xfs_mount.c                  |   32 +-
 fs/xfs/xfs_mount.h                  |    6 +-
 fs/xfs/xfs_qm_syscalls.c            |    1 +
 fs/xfs/xfs_super.c                  |   93 +++--
 fs/xfs/xfs_vnodeops.c               |    3 +-
 15 files changed, 840 insertions(+), 1062 deletions(-)

So it removes a couple of hundred lines of code whilst still
providing exactly the same functionality and fixing some bugs.

e.g. xfs_attr_quiesce() isn't waiting for metadata IO completion
before writing the unmount record, which explains why occasionally
freeze results in a log with more than just an unmount and dummy
record in it.

Comments?

Cheers,

Dave.

PS: it just let the smoke out caused by the
writeback_inodes_sb_if_idle() change in xfs_create(). I think I used
the wrong inode to get the superblock....

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
