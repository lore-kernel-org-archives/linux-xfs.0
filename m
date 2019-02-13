Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52864 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388727AbfBMUu5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 15:50:57 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1DKcte7140284
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:50:56 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qhre5mbvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:50:55 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1DKosIE002590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:50:55 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1DKosPf026542
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 20:50:54 GMT
Subject: [PATCH 2/3] xfs: don't ever put nlink > 0 inodes on the unlinked
 list
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Feb 2019 12:50:53 -0800
Message-ID: <155009105350.32028.13101526675073908023.stgit@magnolia>
In-Reply-To: <155009104740.32028.193157199378698979.stgit@magnolia>
References: <155009104740.32028.193157199378698979.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When XFS creates an O_TMPFILE file, the inode is created with nlink = 1,
put on the unlinked list, and then the VFS sets nlink = 0 in d_tmpfile.
If we crash before anything logs the inode (it's dirty incore but the
vfs doesn't tell us it's dirty so we never log that change), the iunlink
processing part of recovery will then explode with a pile of:

XFS: Assertion failed: VFS_I(ip)->i_nlink == 0, file:
fs/xfs/xfs_log_recover.c, line: 5072

Worse yet, since nlink is nonzero, the inodes also don't get cleaned up
and they just leak until the next xfs_repair run.

Therefore, change xfs_iunlink to require that inodes being put on the
unlinked list have nlink == 0, change the tmpfile callers to instantiate
nodes that way, and set the nlink to 1 just prior to calling d_tmpfile.
Fix the comment for xfs_iunlink while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   16 ++++++----------
 fs/xfs/xfs_iops.c  |   13 +++++++++++--
 2 files changed, 17 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9aaa3143a277..9d683b455e01 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1332,7 +1332,7 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0, prid, &ip);
+	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2231,11 +2231,8 @@ xfs_iunlink_update_inode(
 }
 
 /*
- * This is called when the inode's link count goes to 0 or we are creating a
- * tmpfile via O_TMPFILE. In the case of a tmpfile, @ignore_linkcount will be
- * set to true as the link count is dropped to zero by the VFS after we've
- * created the file successfully, so we have to add it to the unlinked list
- * while the link count is non-zero.
+ * This is called when the inode's link count has gone to 0 or we are creating
+ * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
  *
  * We place the on-disk inode on a list in the AGI.  It will be pulled from this
  * list when the inode is freed.
@@ -2254,6 +2251,7 @@ xfs_iunlink(
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
 
+	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(VFS_I(ip)->i_mode != 0);
 	trace_xfs_iunlink(ip);
 
@@ -3184,11 +3182,9 @@ xfs_rename_alloc_whiteout(
 
 	/*
 	 * Prepare the tmpfile inode as if it were created through the VFS.
-	 * Otherwise, the link increment paths will complain about nlink 0->1.
-	 * Drop the link count as done by d_tmpfile(), complete the inode setup
-	 * and flag it as linkable.
+	 * Complete the inode setup and flag it as linkable.  nlink is already
+	 * zero, so we can skip the drop_nlink.
 	 */
-	drop_nlink(VFS_I(tmpfile));
 	xfs_setup_iops(tmpfile);
 	xfs_finish_inode_setup(tmpfile);
 	VFS_I(tmpfile)->i_state |= I_LINKABLE;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f48ffd7a8d3e..1efef69a7f1c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -191,9 +191,18 @@ xfs_generic_create(
 
 	xfs_setup_iops(ip);
 
-	if (tmpfile)
+	if (tmpfile) {
+		/*
+		 * The VFS requires that any inode fed to d_tmpfile must have
+		 * nlink == 1 so that it can decrement the nlink in d_tmpfile.
+		 * However, we created the temp file with nlink == 0 because
+		 * we're not allowed to put an inode with nlink > 0 on the
+		 * unlinked list.  Therefore we have to set nlink to 1 so that
+		 * d_tmpfile can immediately set it back to zero.
+		 */
+		set_nlink(inode, 1);
 		d_tmpfile(dentry, inode);
-	else
+	} else
 		d_instantiate(dentry, inode);
 
 	xfs_finish_inode_setup(ip);
