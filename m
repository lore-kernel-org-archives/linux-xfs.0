Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Sep 2008 20:05:05 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J3538K010379
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 20:05:03 -0700
Message-ID: <48D3193C.6060201@sgi.com>
Date: Fri, 19 Sep 2008 13:15:08 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Unlock inode before calling xfs_idestroy()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Lock debugging reported the ilock was being destroyed
without being unlocked.

--- a/fs/xfs/xfs_iget.c	2008-09-19 13:03:57.000000000 +1000
+++ b/fs/xfs/xfs_iget.c	2008-09-19 13:12:38.000000000 +1000
@@ -214,6 +214,7 @@ finish_inode:
 		xfs_ilock(ip, lock_flags);
 
 	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
+		xfs_iunlock(ip, lock_flags);
 		xfs_idestroy(ip);
 		xfs_put_perag(mp, pag);
 		return ENOENT;
@@ -224,6 +225,7 @@ finish_inode:
 	 * write spinlock.
 	 */
 	if (radix_tree_preload(GFP_KERNEL)) {
+		xfs_iunlock(ip, lock_flags);
 		xfs_idestroy(ip);
 		delay(1);
 		goto again;
@@ -239,6 +241,7 @@ finish_inode:
 		BUG_ON(error != -EEXIST);
 		write_unlock(&pag->pag_ici_lock);
 		radix_tree_preload_end();
+		xfs_iunlock(ip, lock_flags);
 		xfs_idestroy(ip);
 		XFS_STATS_INC(xs_ig_dup);
 		goto again;
