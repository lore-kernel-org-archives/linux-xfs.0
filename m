Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 21:52:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4N4qg5D004802
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 21:52:46 -0700
Message-ID: <48364E43.3030108@sgi.com>
Date: Fri, 23 May 2008 14:55:31 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH V2] make inode reclaim wait for log I/O to complete
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

During a forced shutdown a xfs inode can be destroyed before log
I/O involving that inode is complete.  We need to wait for the
inode to be unpinned before tearing it down.  Version 2 cleans up
the code a bit by relying on xfs_iflush() to do the unpinning and
forced shutdown check.

--- fs/xfs/xfs_inode.c_1.504	2008-05-23 11:19:21.000000000 +1000
+++ fs/xfs/xfs_inode.c	2008-05-23 11:21:14.000000000 +1000
@@ -3082,8 +3082,6 @@ xfs_iflush(
 	 * flush lock and do nothing.
 	 */
 	if (xfs_inode_clean(ip)) {
-		ASSERT((iip != NULL) ?
-			 !(iip->ili_item.li_flags & XFS_LI_IN_AIL) : 1);
 		xfs_ifunlock(ip);
 		return 0;
 	}
--- fs/xfs/xfs_vnodeops.c_1.760	2008-05-22 16:01:09.000000000 +1000
+++ fs/xfs/xfs_vnodeops.c	2008-05-23 11:52:54.000000000 +1000
@@ -3260,7 +3260,6 @@ xfs_finish_reclaim(
 {
 	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
 	bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
-	int		error;
 
 	if (vp && VN_BAD(vp))
 		goto reclaim;
@@ -3303,29 +3302,16 @@ xfs_finish_reclaim(
 		xfs_iflock(ip);
 	}
 
-	if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		if (ip->i_update_core ||
-		    ((ip->i_itemp != NULL) &&
-		     (ip->i_itemp->ili_format.ilf_fields != 0))) {
-			error = xfs_iflush(ip, sync_mode);
-			/*
-			 * If we hit an error, typically because of filesystem
-			 * shutdown, we don't need to let vn_reclaim to know
-			 * because we're gonna reclaim the inode anyway.
-			 */
-			if (error) {
-				xfs_iunlock(ip, XFS_ILOCK_EXCL);
-				goto reclaim;
-			}
-			xfs_iflock(ip); /* synchronize with xfs_iflush_done */
-		}
-
-		ASSERT(ip->i_update_core == 0);
-		ASSERT(ip->i_itemp == NULL ||
-		       ip->i_itemp->ili_format.ilf_fields == 0);
+	/*
+	 * In the case of a forced shutdown we rely on xfs_iflush() to
+	 * wait for the inode to be unpinned before returning an error.
+	 */
+	if (xfs_iflush(ip, sync_mode) == 0) {
+		/* synchronize with xfs_iflush_done */
+		xfs_iflock(ip);
+		xfs_ifunlock(ip);
 	}
 
-	xfs_ifunlock(ip);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
  reclaim:
