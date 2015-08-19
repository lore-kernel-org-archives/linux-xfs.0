Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 859987F4E
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 05:23:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 65BB430405F
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 03:23:39 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	a04SD7gGD2xd9uT6 for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 03:23:36 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZS0Ws-00060H-Mu
	for xfs@oss.sgi.com; Wed, 19 Aug 2015 20:23:34 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ZS0Ws-0004w4-Lw
	for xfs@oss.sgi.com; Wed, 19 Aug 2015 20:23:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: inode lockdep annotations broke non-lockdep build
Date: Wed, 19 Aug 2015 20:23:34 +1000
Message-Id: <1439979814-18934-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Fix CONFIG_LOCKDEP=n build, because asserts I put in to ensure we
aren't overrunning lockdep subclasses in commit 0952c81 ("xfs:
clean up inode lockdep annotations") use a define that doesn't
exist when CONFIG_LOCKDEP=n

Only check the subclass limits when lockdep is actually enabled.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index dd584da..30555f8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -362,6 +362,17 @@ int xfs_lots_retries;
 int xfs_lock_delays;
 #endif
 
+#ifdef CONFIG_LOCKDEP
+static bool
+xfs_lockdep_subclass_ok(
+	int subclass)
+{
+	return subclass < MAX_LOCKDEP_SUBCLASSES;
+}
+#else
+#define xfs_lockdep_subclass_ok(subclass)	(true)
+#endif
+
 /*
  * Bump the subclass so xfs_lock_inodes() acquires each lock with a different
  * value. This can be called for any type of inode lock combination, including
@@ -375,11 +386,12 @@ xfs_lock_inumorder(int lock_mode, int subclass)
 
 	ASSERT(!(lock_mode & (XFS_ILOCK_PARENT | XFS_ILOCK_RTBITMAP |
 			      XFS_ILOCK_RTSUM)));
+	ASSERT(xfs_lockdep_subclass_ok(subclass));
 
 	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)) {
 		ASSERT(subclass <= XFS_IOLOCK_MAX_SUBCLASS);
-		ASSERT(subclass + XFS_IOLOCK_PARENT_VAL <
-						MAX_LOCKDEP_SUBCLASSES);
+		ASSERT(xfs_lockdep_subclass_ok(subclass +
+						XFS_IOLOCK_PARENT_VAL));
 		class += subclass << XFS_IOLOCK_SHIFT;
 		if (lock_mode & XFS_IOLOCK_PARENT)
 			class += XFS_IOLOCK_PARENT_VAL << XFS_IOLOCK_SHIFT;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
