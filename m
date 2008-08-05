Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 23:36:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m756a5Rl015846
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 23:36:05 -0700
Message-ID: <4897F691.6010806@sgi.com>
Date: Tue, 05 Aug 2008 16:43:29 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Move vn_iowait() earlier in the reclaim path
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

Currently by the time we get to vn_iowait() in xfs_reclaim() we have already
gone through xfs_inactive()/xfs_free() and recycled the inode.  Any I/O
completions still running (file size updates and unwritten extent conversions)
may be working on an inode that is no longer valid.

--- a/fs/xfs/linux-2.6/xfs_super.c	2008-08-05 16:27:57.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_super.c	2008-08-05 13:54:41.000000000 +1000
@@ -935,6 +935,7 @@ xfs_fs_clear_inode(
 		XFS_STATS_INC(vn_reclaim);
 		XFS_STATS_DEC(vn_active);
 
+		vn_iowait(ip);
 		xfs_inactive(ip);
 		xfs_iflags_clear(ip, XFS_IMODIFIED);
 		if (xfs_reclaim(ip))
--- a/fs/xfs/xfs_vnodeops.c	2008-08-05 16:27:57.000000000 +1000
+++ b/fs/xfs/xfs_vnodeops.c	2008-08-05 13:54:43.000000000 +1000
@@ -2802,8 +2802,6 @@ xfs_reclaim(
 		return 0;
 	}
 
-	vn_iowait(ip);
-
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
 
 	/*
