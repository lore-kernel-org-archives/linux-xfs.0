Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 174837F95
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 15:43:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8E6EAC001
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 13:43:29 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WT3EfwAOwHNwFsNU for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 13:43:27 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Y8yNy-0005Hq-8M
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:43:26 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Y8yNy-0001vb-7C
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:43:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: remove deprecated sysctls
Date: Thu,  8 Jan 2015 08:43:26 +1100
Message-Id: <1420667006-7377-1-git-send-email-david@fromorbit.com>
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

xfsbufd_centisecs and age_buffer_centisecs were due for removal in
3.14. We forgot to do that - it's now well past time to remove these
deprecated, unused sysctls.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 Documentation/filesystems/xfs.txt | 17 +++++++----------
 fs/xfs/xfs_sysctl.c               | 18 ------------------
 2 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 5be51fd..7077103 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -348,16 +348,13 @@ The following sysctls are available for the XFS filesystem:
 Deprecated Sysctls
 ==================
 
-  fs.xfs.xfsbufd_centisecs	(Min: 50  Default: 100	Max: 3000)
-	Dirty metadata is now tracked by the log subsystem and
-	flushing is driven by log space and idling demands. The
-	xfsbufd no longer exists, so this syctl does nothing.
+None at present.
 
-	Due for removal in 3.14.
 
-  fs.xfs.age_buffer_centisecs	(Min: 100  Default: 1500  Max: 720000)
-	Dirty metadata is now tracked by the log subsystem and
-	flushing is driven by log space and idling demands. The
-	xfsbufd no longer exists, so this syctl does nothing.
+Removed Sysctls
+===============
 
-	Due for removal in 3.14.
+  Name				Removed
+  ----				-------
+  fs.xfs.xfsbufd_centisec	v3.20
+  fs.xfs.age_buffer_centisecs	v3.20
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 1743b9f..a0c8067 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -149,24 +149,6 @@ static struct ctl_table xfs_table[] = {
 		.extra2		= &xfs_params.inherit_noatim.max
 	},
 	{
-		.procname	= "xfsbufd_centisecs",
-		.data		= &xfs_params.xfs_buf_timer.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.xfs_buf_timer.min,
-		.extra2		= &xfs_params.xfs_buf_timer.max
-	},
-	{
-		.procname	= "age_buffer_centisecs",
-		.data		= &xfs_params.xfs_buf_age.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.xfs_buf_age.min,
-		.extra2		= &xfs_params.xfs_buf_age.max
-	},
-	{
 		.procname	= "inherit_nosymlinks",
 		.data		= &xfs_params.inherit_nosym.val,
 		.maxlen		= sizeof(int),
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
