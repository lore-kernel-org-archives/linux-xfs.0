Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EAu5Bw121079 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:56:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B92F1E6530D
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 03:56:52 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	xYSf2mFP0ukbjsdP for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 03:56:52 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	38734977-1927428
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 20:26:51 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OvTBx-0004Oj-Cp
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:49 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OvTBb-0000Q6-1A
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/18] xfs: don't use vfs writeback for pure metadata
	modifications
Date: Tue, 14 Sep 2010 20:56:06 +1000
Message-Id: <1284461777-1496-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1284461777-1496-1-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
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

Under heavy multi-way parallel create workloads, the VFS struggles to write
back all the inodes that have been changed in age order. The bdi flusher thread
becomes CPU bound, spending 85% of it's time in the VFS code, mostly traversing
the superblock dirty inode list to separate dirty inodes old enough to flush.

We already keep an index of all metadata changes in age order - in the AIL -
and continued log pressure will do age ordered writeback without any extra
overhead at all. If there is no pressure on the log, the xfssyncd will
periodically write back metadata in ascending disk address offset order so will
be very efficient.

Hence we can stop marking VFS inodes dirty during transaction commit or when
changing timestamps during transactions. This will keep the inodes in the
superblock dirty list to those containing data or unlogged metadata changes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |   18 +++++-------------
 fs/xfs/xfs_inode_item.c     |    9 ---------
 2 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 1e084ff..8f21765 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -95,9 +95,11 @@ xfs_mark_inode_dirty(
 }
 
 /*
- * Change the requested timestamp in the given inode.
- * We don't lock across timestamp updates, and we don't log them but
- * we do record the fact that there is dirty information in core.
+ * Change the requested timestamp in the given inode.  We don't lock across
+ * timestamp updates, and we don't log them directly.  However, all timestamp
+ * changes occur within transactions that log the inode core, so the timestamp
+ * changes will be copied back into the XFS inode during transaction commit.
+ * Hence we do not need to dirty the inode here.
  */
 void
 xfs_ichgtime(
@@ -106,27 +108,17 @@ xfs_ichgtime(
 {
 	struct inode	*inode = VFS_I(ip);
 	timespec_t	tv;
-	int		sync_it = 0;
 
 	tv = current_fs_time(inode->i_sb);
 
 	if ((flags & XFS_ICHGTIME_MOD) &&
 	    !timespec_equal(&inode->i_mtime, &tv)) {
 		inode->i_mtime = tv;
-		sync_it = 1;
 	}
 	if ((flags & XFS_ICHGTIME_CHG) &&
 	    !timespec_equal(&inode->i_ctime, &tv)) {
 		inode->i_ctime = tv;
-		sync_it = 1;
 	}
-
-	/*
-	 * Update complete - now make sure everyone knows that the inode
-	 * is dirty.
-	 */
-	if (sync_it)
-		xfs_mark_inode_dirty_sync(ip);
 }
 
 /*
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index fe00777..c7ac020 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -223,15 +223,6 @@ xfs_inode_item_format(
 	nvecs	     = 1;
 
 	/*
-	 * Make sure the linux inode is dirty. We do this before
-	 * clearing i_update_core as the VFS will call back into
-	 * XFS here and set i_update_core, so we need to dirty the
-	 * inode first so that the ordering of i_update_core and
-	 * unlogged modifications still works as described below.
-	 */
-	xfs_mark_inode_dirty_sync(ip);
-
-	/*
 	 * Clear i_update_core if the timestamps (or any other
 	 * non-transactional modification) need flushing/logging
 	 * and we're about to log them with the rest of the core.
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
