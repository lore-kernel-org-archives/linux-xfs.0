Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48110 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753658AbeFJFHg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:07:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A56Pl1141614
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:36 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2jgecx94mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:36 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5A57ZXP032635
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:35 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5A57Z1U000525
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:35 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v7 17/23] xfs: add parent attributes to link
Date: Sat,  9 Jun 2018 22:05:02 -0700
Message-Id: <1528607108-11059-18-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
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
 fs/xfs/xfs_inode.c | 46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c87bc15..10f885b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1422,6 +1422,7 @@ xfs_link(
 	struct xfs_defer_ops	dfops;
 	xfs_fsblock_t           first_block;
 	int			resblks;
+	xfs_dir2_dataptr_t	diroffset;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1449,8 +1450,8 @@ xfs_link(
 
 	xfs_lock_two_inodes(sip, XFS_ILOCK_EXCL, tdp, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, sip, 0);
+	xfs_trans_ijoin(tp, tdp, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1469,8 +1470,6 @@ xfs_link(
 			goto error_return;
 	}
 
-	xfs_defer_init(&dfops, &first_block);
-
 	/*
 	 * Handle initial link state of O_TMPFILE inode
 	 */
@@ -1480,16 +1479,30 @@ xfs_link(
 			goto error_return;
 	}
 
+	xfs_defer_init(&dfops, &first_block);
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   &first_block, &dfops, resblks, NULL);
+				   &first_block, &dfops, resblks, &diroffset);
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
+		error = xfs_parent_add_deferred(tdp, sip, target_name,
+				       diroffset, &dfops);
+		if (error)
+			goto out_defer_cancel;
+	}
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -1500,16 +1513,21 @@ xfs_link(
 		xfs_trans_set_sync(tp);
 
 	error = xfs_defer_finish(&tp, &dfops);
-	if (error) {
-		xfs_defer_cancel(&dfops);
-		goto error_return;
-	}
+	if (error)
+		goto out_defer_cancel;
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	return error;
 
- error_return:
+out_defer_cancel:
+	xfs_defer_cancel(&dfops);
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

