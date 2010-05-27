Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4R1utZG103870 for <xfs@oss.sgi.com>; Wed, 26 May 2010 20:56:55 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A23E109F70C
	for <xfs@oss.sgi.com>; Wed, 26 May 2010 19:01:05 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	o71R4d7EqnJuvtoh for <xfs@oss.sgi.com>;
	Wed, 26 May 2010 19:01:05 -0700 (PDT)
Received: from dastard (unverified [121.45.174.97])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	25867136-1927428
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 11:29:16 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OHSNP-0001nF-HC
	for xfs@oss.sgi.com; Thu, 27 May 2010 11:59:15 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OHSNG-0008C1-CF
	for xfs@oss.sgi.com; Thu, 27 May 2010 11:59:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: Re-initialise lockdep context for all inodes in reclaim
Date: Thu, 27 May 2010 11:59:06 +1000
Message-Id: <1274925546-31468-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

We re-initialise the lockdep context for inode iolocks when dropping an inode,
but not when we delete an inode. Now that we can reclaim inodes from a shrinker,
we can get get false lockdep warnings about inode iolock inversions during
reclaim of deleted inodes. Hence we need to re-initialise the iolock in the
delete path as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 8119d1b..ba0e884 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -911,6 +911,20 @@ xfs_fs_destroy_inode(
 
 	XFS_STATS_INC(vn_reclaim);
 
+	/*
+	 * The iolock is used by the file system to coordinate reads,
+	 * writes, and block truncates.  Up to this point the lock
+	 * protected concurrent accesses by users of the inode.  But
+	 * from here forward we're doing some final processing of the
+	 * inode because we're done with it, and although we reuse the
+	 * iolock for protection it is really a distinct lock class
+	 * (in the lockdep sense) from before.  To keep lockdep happy
+	 * (and basically indicate what we are doing), we explicitly
+	 * re-init the iolock here.
+	 */
+	ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
+	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
+
 	/* bad inode, get out here ASAP */
 	if (is_bad_inode(inode))
 		goto out_reclaim;
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
