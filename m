Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2U6IWqT156013 for <xfs@oss.sgi.com>; Tue, 30 Mar 2010 01:18:33 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 705C1121E62A
	for <xfs@oss.sgi.com>; Mon, 29 Mar 2010 23:20:16 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	HL2UVEiG16GDsIaF for <xfs@oss.sgi.com>;
	Mon, 29 Mar 2010 23:20:16 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	18664350-1927428
	for <xfs@oss.sgi.com>; Tue, 30 Mar 2010 16:50:15 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1NwUo9-000526-DT
	for xfs@oss.sgi.com; Tue, 30 Mar 2010 17:20:13 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NwUo6-00050F-JE
	for xfs@oss.sgi.com; Tue, 30 Mar 2010 17:20:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: don't warn on EAGAIN in inode reclaim
Date: Tue, 30 Mar 2010 17:20:10 +1100
Message-Id: <1269930010-19174-1-git-send-email-david@fromorbit.com>
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

Any inode reclaim flush that returns EAGAIN will result in the inode
reclaim being attempted again later. There is no need to issue a
warning into the logs about this situation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 97813e7..5a4731e 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -820,10 +820,10 @@ xfs_reclaim_inode(
 	 * call into reclaim to find it in a clean state instead of waiting for
 	 * it now. We also don't return errors here - if the error is transient
 	 * then the next reclaim pass will flush the inode, and if the error
-	 * is permanent then the next sync reclaim will relcaim the inode and
+	 * is permanent then the next sync reclaim will reclaim the inode and
 	 * pass on the error.
 	 */
-	if (error && !XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+	if (error && error != EAGAIN && !XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_fs_cmn_err(CE_WARN, ip->i_mount,
 			"inode 0x%llx background reclaim flush failed with %d",
 			(long long)ip->i_ino, error);
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
