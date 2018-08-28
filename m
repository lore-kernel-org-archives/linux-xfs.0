Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59978 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbeH1XSG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Aug 2018 19:18:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7SJJSmj081073
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:01 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2m2yrq5tj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:00 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJOxqn019006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:00 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7SJOxm5014927
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:59 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v8 21/28] xfs: add parent attributes to link
Date: Tue, 28 Aug 2018 12:22:34 -0700
Message-Id: <1535484161-11059-22-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This patch modifies xfs_link to add a parent pointer to the inode.
xfs_link will also need to create an attribute fork if the inode does
not already have one.

[bfoster: rebase, use VFS inode fields, fix xfs_bmap_finish() usage]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
	   fixed null pointer bugs]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3f722e6..4a32eb1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1409,6 +1409,7 @@ xfs_link(
 	xfs_trans_t		*tp;
 	int			error;
 	int			resblks;
+	xfs_dir2_dataptr_t	diroffset;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1436,8 +1437,8 @@ xfs_link(
 
 	xfs_lock_two_inodes(sip, XFS_ILOCK_EXCL, tdp, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, sip, 0);
+	xfs_trans_ijoin(tp, tdp, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1466,15 +1467,28 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks, NULL);
+				   resblks, &diroffset);
 	if (error)
-		goto error_return;
+		goto out_defer_cancel;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	error = xfs_bumplink(tp, sip);
 	if (error)
-		goto error_return;
+		goto out_defer_cancel;
+
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		error = xfs_parent_add_deferred(tdp, tp, sip, target_name,
+				       diroffset);
+		if (error)
+			goto out_defer_cancel;
+	}
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -1484,11 +1498,18 @@ xfs_link(
 	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
 		xfs_trans_set_sync(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	return error;
 
- error_return:
+out_defer_cancel:
+	xfs_defer_cancel(tp);
+error_return:
 	xfs_trans_cancel(tp);
- std_return:
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+std_return:
 	return error;
 }
 
-- 
2.7.4
