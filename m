Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 May 2008 06:15:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4GDF7Ri029494
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 06:15:08 -0700
Date: Fri, 16 May 2008 23:15:48 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] update check on valid sb fields being modified on mount
Message-ID: <20080516131548.GX103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Recent changes to update the version number during mount
(attr2 stuff) failed to change the assert that checked for
calid flags being changed on mount. Clearly this path hasn't
been exercised by the test code....

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_mount.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2008-05-16 23:08:18.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2008-05-16 23:10:00.224848630 +1000
@@ -1887,7 +1887,8 @@ xfs_mount_log_sb(
 	int		error;
 
 	ASSERT(fields & (XFS_SB_UNIT | XFS_SB_WIDTH | XFS_SB_UUID |
-			 XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2));
+			 XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2 |
+			 XFS_SB_VERSIONNUM));
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SB_UNIT);
 	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
