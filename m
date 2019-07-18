Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37821 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXGa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 19:06:30 -0400
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5/9] xfs: don't ever put nlink > 0 inodes on the unlinked list
Date: Thu, 18 Jul 2019 23:06:13 +0000
Message-Id: <20190718230617.7439-6-mcgrof@kernel.org>
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, zlang@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Luis Chamberlain <mcgrof@kernel.org>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit c4a6bf7f6cc7eb4cce120fb7eb1e1fb8b2d65e09 upstream.

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_inode.c | 16 ++++++----------
 fs/xfs/xfs_iops.c  | 13 +++++++++++--
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ae07baa7bdbf..5ed84d6c7059 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1332,7 +1332,7 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0, prid, &ip);
+	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, &ip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1907,11 +1907,8 @@ xfs_inactive(
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
@@ -1931,6 +1928,7 @@ xfs_iunlink(
 	int		offset;
 	int		error;
 
+	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(VFS_I(ip)->i_mode != 0);
 
 	/*
@@ -2837,11 +2835,9 @@ xfs_rename_alloc_whiteout(
 
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
-- 
2.20.1
