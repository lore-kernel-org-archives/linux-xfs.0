Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4A25wbx039263 for <xfs@oss.sgi.com>; Mon, 9 May 2011 21:05:59 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1107944013A
	for <xfs@oss.sgi.com>; Mon,  9 May 2011 19:05:56 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	cMcmMUTyxqMmisDA for <xfs@oss.sgi.com>;
	Mon, 09 May 2011 19:05:56 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QJcKb-0001AP-Pw
	for xfs@oss.sgi.com; Tue, 10 May 2011 12:05:49 +1000
Received: from dave by disappointment with local (Exim 4.75)
	(envelope-from <dave@disappointment.disaster>) id 1QJcKc-0003zl-UU
	for xfs@oss.sgi.com; Tue, 10 May 2011 12:05:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix duplicate workqueue initialisation
Date: Tue, 10 May 2011 12:05:50 +1000
Message-Id: <1304993150-15327-1-git-send-email-david@fromorbit.com>
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

The workqueue initialisation function is called twice when
initialising the XFS subsystem. Remove the second initialisation
call.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 29c0ccb..365375c 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1800,10 +1800,6 @@ init_xfs_fs(void)
 	if (error)
 		goto out_cleanup_procfs;
 
-	error = xfs_init_workqueues();
-	if (error)
-		goto out_sysctl_unregister;
-
 	vfs_initquota();
 
 	error = register_filesystem(&xfs_fs_type);
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
