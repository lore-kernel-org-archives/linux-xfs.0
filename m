Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q274omB8020649 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 22:50:48 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Ggcpr8cy6nlnrNSn for <xfs@oss.sgi.com>;
	Tue, 06 Mar 2012 20:50:46 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S58pm-0001o8-Fe
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:42 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S58pc-0007V3-8V
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/10] xfs: initialise xfssync work before running quotachecks
Date: Wed,  7 Mar 2012 15:50:26 +1100
Message-Id: <1331095828-28742-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1331095828-28742-1-git-send-email-david@fromorbit.com>
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
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

Because the mount process can run a quotacheck and consume lots of
inodes, we need to be able to run periodic inode reclaim during the
mount process. This will prevent running the system out of memory
during quota checks.

This essentially reverts 2bcf6e97, but that is safe to do now that
the quota sync code that was causing problems during long quotacheck
executions is now gone.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_super.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 13fa0cf..150d8f4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1343,22 +1343,22 @@ xfs_fs_fill_super(
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
 
-	error = xfs_mountfs(mp);
+	error = xfs_syncd_init(mp);
 	if (error)
 		goto out_filestream_unmount;
 
-	error = xfs_syncd_init(mp);
+	error = xfs_mountfs(mp);
 	if (error)
-		goto out_unmount;
+		goto out_syncd_stop;
 
 	root = igrab(VFS_I(mp->m_rootip));
 	if (!root) {
 		error = ENOENT;
-		goto out_syncd_stop;
+		goto out_unmount;
 	}
 	if (is_bad_inode(root)) {
 		error = EINVAL;
-		goto out_syncd_stop;
+		goto out_unmount;
 	}
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
@@ -1368,6 +1368,8 @@ xfs_fs_fill_super(
 
 	return 0;
 
+ out_syncd_stop:
+	xfs_syncd_stop(mp);
  out_filestream_unmount:
 	xfs_filestream_unmount(mp);
  out_free_sb:
@@ -1384,8 +1386,6 @@ xfs_fs_fill_super(
 
  out_iput:
 	iput(root);
- out_syncd_stop:
-	xfs_syncd_stop(mp);
  out_unmount:
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
@@ -1397,6 +1397,7 @@ xfs_fs_fill_super(
 	xfs_flush_buftarg(mp->m_ddev_targp, 1);
 
 	xfs_unmountfs(mp);
+	xfs_syncd_stop(mp);
 	goto out_free_sb;
 }
 
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
