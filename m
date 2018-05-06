Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38906 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751873AbeEFR1M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 May 2018 13:27:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w46HQYEj095338
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:12 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2hs24sa429-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 06 May 2018 17:27:11 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w46HRBkx014877
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:11 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w46HRBRv021693
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:11 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 17/21] xfs: remove parent pointers in unlink
Date: Sun,  6 May 2018 10:24:50 -0700
Message-Id: <1525627494-12873-18-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This patch removes the parent pointer attribute during unlink

[bfoster: rebase, use VFS inode generation]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t
	   implemented xfs_attr_remove_parent]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c        | 21 ++++++++++++++++-----
 fs/xfs/xfs_parent_utils.c | 19 +++++++++++++++++++
 fs/xfs/xfs_parent_utils.h |  4 ++++
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3a68e72..b18b20c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2624,6 +2624,7 @@ xfs_remove(
 	struct xfs_defer_ops	dfops;
 	xfs_fsblock_t           first_block;
 	uint			resblks;
+	xfs_dir2_dataptr_t	dir_offset;
 
 	trace_xfs_remove(dp, name);
 
@@ -2661,8 +2662,8 @@ xfs_remove(
 
 	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
 	 * If we're removing a directory perform some additional validation.
@@ -2704,12 +2705,18 @@ xfs_remove(
 
 	xfs_defer_init(&dfops, &first_block);
 	error = xfs_dir_removename(tp, dp, name, ip->i_ino, &first_block,
-				   &dfops, resblks, NULL);
+				   &dfops, resblks, &dir_offset);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_bmap_cancel;
 	}
 
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		error = xfs_parent_remove_deferred(dp, ip, dir_offset, &dfops);
+		if (error)
+			goto out_bmap_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2724,17 +2731,21 @@ xfs_remove(
 
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto std_return;
+		goto out_unlock;
 
 	if (is_dir && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
-	return 0;
+	error = 0;
+	goto out_unlock;
 
  out_bmap_cancel:
 	xfs_defer_cancel(&dfops);
  out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
  std_return:
 	return error;
 }
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index cf4a7e2..0fd48b8 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -49,3 +49,22 @@ xfs_parent_add_deferred(
 		(void *)child_name->name, child_name->len, ATTR_PARENT);
 }
 
+/*
+ * Remove a parent record from a child inode.
+ */
+int
+xfs_parent_remove_deferred(
+	struct xfs_inode	*parent,
+	struct xfs_inode	*child,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_defer_ops	*dfops)
+{
+	struct xfs_parent_name_rec rec;
+
+	xfs_init_parent_name_rec(&rec, parent->i_ino,
+				 VFS_I(parent)->i_generation, diroffset);
+
+	return xfs_attr_remove_deferred(child, dfops, &rec, sizeof(rec),
+					ATTR_PARENT);
+}
+
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
index a667d1d..9e0ac13 100644
--- a/fs/xfs/xfs_parent_utils.h
+++ b/fs/xfs/xfs_parent_utils.h
@@ -23,4 +23,8 @@
 int xfs_parent_add_deferred(struct xfs_inode *parent, struct xfs_inode *child,
 	       struct xfs_name *child_name, uint32_t diroffset,
 	       struct xfs_defer_ops *dfops);
+int xfs_parent_remove_deferred(struct xfs_inode *parent,
+			       struct xfs_inode *child,
+			       xfs_dir2_dataptr_t diroffset,
+			       struct xfs_defer_ops *dfops);
 #endif	/* __XFS_PARENT_UTILS_H__ */
-- 
2.7.4

