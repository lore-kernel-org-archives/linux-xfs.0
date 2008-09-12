Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Sep 2008 01:33:18 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8C8VQWI008130
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 01:31:26 -0700
Message-ID: <48CA2B23.4020405@sgi.com>
Date: Fri, 12 Sep 2008 18:41:07 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Fix use-after-free with log and quotas
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Destroying the quota stuff on unmount can access the log - ie XFS_QM_DONE()
ends up in xfs_dqunlock() which calls xfs_trans_unlocked_item() and then
xfs_log_move_tail().  By this time the log has already been destroyed.
Just move the cleanup of the quota code earlier in xfs_unmountfs() before
the call to xfs_log_unmount().  Moving XFS_QM_DONE() up near
XFS_QM_DQPURGEALL() seems like a good spot.

--- a/fs/xfs/xfs_mount.c	2008-09-12 18:24:09.000000000 +1000
+++ b/fs/xfs/xfs_mount.c	2008-09-12 18:31:22.000000000 +1000
@@ -1245,6 +1245,9 @@ xfs_unmountfs(
 
 	XFS_QM_DQPURGEALL(mp, XFS_QMOPT_QUOTALL | XFS_QMOPT_UMOUNTING);
 
+	if (mp->m_quotainfo)
+		XFS_QM_DONE(mp);
+
 	/*
 	 * Flush out the log synchronously so that we know for sure
 	 * that nothing is pinned.  This is important because bflush()
@@ -1297,8 +1300,6 @@ xfs_unmountfs(
 	xfs_errortag_clearall(mp, 0);
 #endif
 	xfs_free_perag(mp);
-	if (mp->m_quotainfo)
-		XFS_QM_DONE(mp);
 }
 
 STATIC void
