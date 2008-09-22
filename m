Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Sep 2008 21:58:39 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8M4wXfg013303
	for <xfs@oss.sgi.com>; Sun, 21 Sep 2008 21:58:33 -0700
Message-ID: <48D72864.2020604@sgi.com>
Date: Mon, 22 Sep 2008 15:08:52 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH V2] Unlock inode before calling xfs_idestroy()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Lock debugging reported the ilock was being destroyed without being
unlocked.  We don't need to lock the inode until we are going to
insert it into the radix tree.

--- a/fs/xfs/xfs_iget.c	2008-09-22 14:55:20.000000000 +1000
+++ b/fs/xfs/xfs_iget.c	2008-09-22 13:56:33.000000000 +1000
@@ -210,9 +210,6 @@ finish_inode:
 
 	xfs_itrace_exit_tag(ip, "xfs_iget.alloc");
 
-	if (lock_flags)
-		xfs_ilock(ip, lock_flags);
-
 	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
 		xfs_idestroy(ip);
 		xfs_put_perag(mp, pag);
@@ -228,6 +225,10 @@ finish_inode:
 		delay(1);
 		goto again;
 	}
+
+	if (lock_flags)
+		xfs_ilock(ip, lock_flags);
+
 	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
 	first_index = agino & mask;
 	write_lock(&pag->pag_ici_lock);
@@ -239,6 +240,8 @@ finish_inode:
 		BUG_ON(error != -EEXIST);
 		write_unlock(&pag->pag_ici_lock);
 		radix_tree_preload_end();
+		if (lock_flags)
+			xfs_iunlock(ip, lock_flags);
 		xfs_idestroy(ip);
 		XFS_STATS_INC(xs_ig_dup);
 		goto again;
