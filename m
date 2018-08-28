Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60966 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbeH1XSF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Aug 2018 19:18:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7SJJDVV097188
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:00 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2m2xhtnxry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:00 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJOxb7013094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:00 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJOx3n003508
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:59 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v8 22/28] xfs: remove parent pointers in unlink
Date: Tue, 28 Aug 2018 12:22:35 -0700
Message-Id: <1535484161-11059-23-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
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
 fs/xfs/xfs_inode.c        | 20 ++++++++++++++++----
 fs/xfs/xfs_parent_utils.c | 18 ++++++++++++++++++
 fs/xfs/xfs_parent_utils.h |  4 ++++
 3 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4a32eb1..300ba90 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2577,6 +2577,7 @@ xfs_remove(
 	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
 	int                     error = 0;
 	uint			resblks;
+	xfs_dir2_dataptr_t	dir_offset;
 
 	trace_xfs_remove(dp, name);
 
@@ -2614,8 +2615,8 @@ xfs_remove(
 
 	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
 	 * If we're removing a directory perform some additional validation.
@@ -2655,12 +2656,18 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, &dir_offset);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
 	}
 
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		error = xfs_parent_remove_deferred(dp, tp, ip, dir_offset);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2671,15 +2678,20 @@ xfs_remove(
 
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto std_return;
+		goto out_unlock;
 
 	if (is_dir && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
  std_return:
 	return error;
 }
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index f84a4fd..8f35afe 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -50,3 +50,21 @@ xfs_parent_add_deferred(
 		(void *)child_name->name, child_name->len, ATTR_PARENT);
 }
 
+/*
+ * Remove a parent record from a child inode.
+ */
+int
+xfs_parent_remove_deferred(
+	struct xfs_inode	*parent,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*child,
+	xfs_dir2_dataptr_t	diroffset)
+{
+	struct xfs_parent_name_rec rec;
+
+	xfs_init_parent_name_rec(&rec, parent, diroffset);
+
+	return xfs_attr_remove_deferred(child, tp, &rec, sizeof(rec),
+		ATTR_PARENT);
+}
+
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
index 82453d2..010e517 100644
--- a/fs/xfs/xfs_parent_utils.h
+++ b/fs/xfs/xfs_parent_utils.h
@@ -23,4 +23,8 @@
 int xfs_parent_add_deferred(struct xfs_inode *parent, struct xfs_trans *tp,
 	       struct xfs_inode *child, struct xfs_name *child_name,
 	       uint32_t diroffset);
+int xfs_parent_remove_deferred(struct xfs_inode *parent,
+			       struct xfs_trans *tp,
+			       struct xfs_inode *child,
+			       xfs_dir2_dataptr_t diroffset);
 #endif	/* __XFS_PARENT_UTILS_H__ */
-- 
2.7.4
