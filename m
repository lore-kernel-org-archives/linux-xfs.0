Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Feb 2008 20:15:23 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m174FEfU018005
	for <xfs@oss.sgi.com>; Wed, 6 Feb 2008 20:15:19 -0800
Message-ID: <47AA86E5.5030804@sgi.com>
Date: Thu, 07 Feb 2008 15:19:49 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH V2] make inode reclaim synchronise with xfs_iflush_done()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On a forced shutdown, xfs_finish_reclaim() will skip flushing the inode.
If the inode flush lock is not already held and there is an outstanding
xfs_iflush_done() then we might free the inode prematurely.  By acquiring
and releasing the flush lock we will synchronise with xfs_iflush_done().

Lachlan

--- fs/xfs/xfs_vnodeops.c_1.727	2008-01-10 16:00:48.000000000 +1100
+++ fs/xfs/xfs_vnodeops.c	2008-02-07 15:15:26.000000000 +1100
@@ -3721,12 +3721,12 @@ xfs_finish_reclaim(
  	 * We get the flush lock regardless, though, just to make sure
  	 * we don't free it while it is being flushed.
  	 */
-	if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		if (!locked) {
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
-			xfs_iflock(ip);
-		}
+	if (!locked) {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_iflock(ip);
+	}

+	if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
  		if (ip->i_update_core ||
  		    ((ip->i_itemp != NULL) &&
  		     (ip->i_itemp->ili_format.ilf_fields != 0))) {
@@ -3746,17 +3746,11 @@ xfs_finish_reclaim(
  		ASSERT(ip->i_update_core == 0);
  		ASSERT(ip->i_itemp == NULL ||
  		       ip->i_itemp->ili_format.ilf_fields == 0);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	} else if (locked) {
-		/*
-		 * We are not interested in doing an iflush if we're
-		 * in the process of shutting down the filesystem forcibly.
-		 * So, just reclaim the inode.
-		 */
-		xfs_ifunlock(ip);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
  	}

+	xfs_ifunlock(ip);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
   reclaim:
  	xfs_ireclaim(ip);
  	return 0;
