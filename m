Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5P16GPD054651 for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 20:06:17 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A634D402769
	for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 18:08:58 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	ONjF7hO5sQGMXFBU for <xfs@oss.sgi.com>;
	Thu, 24 Jun 2010 18:08:58 -0700 (PDT)
Received: from dastard (unverified [121.45.182.52])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	17569317-1927428
	for <xfs@oss.sgi.com>; Fri, 25 Jun 2010 10:38:57 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1ORxPS-0000Iy-25
	for xfs@oss.sgi.com; Fri, 25 Jun 2010 11:08:46 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1ORxPM-00075U-UM
	for xfs@oss.sgi.com; Fri, 25 Jun 2010 11:08:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: unregister inode shrinker before freeing filesystem
	structures
Date: Fri, 25 Jun 2010 11:08:40 +1000
Message-Id: <1277428120-27216-1-git-send-email-david@fromorbit.com>
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

Currently we don't remove the XFS mount from the shrinker list until late in
the unmount path. By this time, we have already torn down the internals of the
filesystem (e.g. the per-ag structures), and hence if the shrinker is executed
between the teardown and the unregistering, the shrinker will get NULL per-ag
structure pointers and panic trying to dereference them.

Fix this by removingthe xfs mount from the shrinker list before tearing down
it's internal structures.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index e3de46c..4605cd4 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1156,9 +1156,13 @@ xfs_fs_put_super(
 
 	XFS_bflush(mp->m_ddev_targp);
 
+	/*
+	 * Unregister the memory shrinker before we tear down the mount
+	 * structure so we don't have memory reclaim racing with us here.
+	 */
+	xfs_inode_shrinker_unregister(mp);
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
-	xfs_inode_shrinker_unregister(mp);
 	xfs_icsb_destroy_counters(mp);
 	xfs_close_devices(mp);
 	xfs_free_fsname(mp);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
