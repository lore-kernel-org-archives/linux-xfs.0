Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 18:11:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m321Aogq014887
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 18:10:55 -0700
Date: Wed, 2 Apr 2008 10:17:58 +1000
From: David Chinner <dgc@sgi.com>
Subject: [Patch] fix lock inversion in forced unmount
Message-ID: <20080402001758.GY103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Fix lock inversion in forced shutdown.

Recent changes to xlog_state_release_iclog() placed the grant_lock
inside the icloglock. forced unmount of the log does this the opposite
way around, but does not depend on the order for correct working.
Fix the inversion by changing the order locks are gained in
xfs_log_force_umount().

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2008-04-01 21:00:13.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2008-04-02 08:35:20.282633878 +1000
@@ -3502,8 +3502,8 @@ xfs_log_force_umount(
 	 * before we mark the filesystem SHUTDOWN and wake
 	 * everybody up to tell the bad news.
 	 */
-	spin_lock(&log->l_grant_lock);
 	spin_lock(&log->l_icloglock);
+	spin_lock(&log->l_grant_lock);
 	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
 	XFS_BUF_DONE(mp->m_sb_bp);
 	/*
