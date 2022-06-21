Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0A0C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jun 2022 01:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbiFUBj0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jun 2022 21:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiFUBjZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jun 2022 21:39:25 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9D951EADD
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jun 2022 18:39:24 -0700 (PDT)
Received: by sandeen.net (Postfix, from userid 500)
        id 673F54D1B91; Mon, 20 Jun 2022 20:38:36 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: [PATCH V2] xfs: add selinux labels to whiteout inodes
Date:   Mon, 20 Jun 2022 20:38:36 -0500
Message-Id: <1655775516-8936-1-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655765731-21078-1-git-send-email-sandeen@redhat.com>
References: <1655765731-21078-1-git-send-email-sandeen@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We got a report that "renameat2() with flags=RENAME_WHITEOUT doesn't
apply an SELinux label on xfs" as it does on other filesystems
(for example, ext4 and tmpfs.)  While I'm not quite sure how labels
may interact w/ whiteout files, leaving them as unlabeled seems
inconsistent at best. Now that xfs_init_security is not static,
rename it to xfs_inode_init_security per dchinner's suggestion.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 14 +++++++++++++-
 fs/xfs/xfs_iops.c  | 11 +++++------
 fs/xfs/xfs_iops.h  |  3 +++
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 52d6f2c..58513a1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3046,10 +3046,12 @@ struct xfs_iunlink {
 static int
 xfs_rename_alloc_whiteout(
 	struct user_namespace	*mnt_userns,
+	struct xfs_name		*src_name,
 	struct xfs_inode	*dp,
 	struct xfs_inode	**wip)
 {
 	struct xfs_inode	*tmpfile;
+	struct qstr		name;
 	int			error;
 
 	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
@@ -3057,6 +3059,15 @@ struct xfs_iunlink {
 	if (error)
 		return error;
 
+	name.name = src_name->name;
+	name.len = src_name->len;
+	error = xfs_inode_init_security(VFS_I(tmpfile), VFS_I(dp), &name);
+	if (error) {
+		xfs_finish_inode_setup(tmpfile);
+		xfs_irele(tmpfile);
+		return error;
+	}
+
 	/*
 	 * Prepare the tmpfile inode as if it were created through the VFS.
 	 * Complete the inode setup and flag it as linkable.  nlink is already
@@ -3107,7 +3118,8 @@ struct xfs_iunlink {
 	 * appropriately.
 	 */
 	if (flags & RENAME_WHITEOUT) {
-		error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
+		error = xfs_rename_alloc_whiteout(mnt_userns, src_name,
+						  target_dp, &wip);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 29f5b8b8..6720b60 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -75,9 +75,8 @@
  * these attrs can be journalled at inode creation time (along with the
  * inode, of course, such that log replay can't cause these to be lost).
  */
-
-STATIC int
-xfs_init_security(
+int
+xfs_inode_init_security(
 	struct inode	*inode,
 	struct inode	*dir,
 	const struct qstr *qstr)
@@ -122,7 +121,7 @@
 
 	/* Oh, the horror.
 	 * If we can't add the ACL or we fail in
-	 * xfs_init_security we must back out.
+	 * xfs_inode_init_security we must back out.
 	 * ENOSPC can hit here, among other things.
 	 */
 	xfs_dentry_to_name(&teardown, dentry);
@@ -208,7 +207,7 @@
 
 	inode = VFS_I(ip);
 
-	error = xfs_init_security(inode, dir, &dentry->d_name);
+	error = xfs_inode_init_security(inode, dir, &dentry->d_name);
 	if (unlikely(error))
 		goto out_cleanup_inode;
 
@@ -424,7 +423,7 @@
 
 	inode = VFS_I(cip);
 
-	error = xfs_init_security(inode, dir, &dentry->d_name);
+	error = xfs_inode_init_security(inode, dir, &dentry->d_name);
 	if (unlikely(error))
 		goto out_cleanup_inode;
 
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 2789490..cb5fc68 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -17,4 +17,7 @@
 int xfs_vn_setattr_size(struct user_namespace *mnt_userns,
 		struct dentry *dentry, struct iattr *vap);
 
+int xfs_inode_init_security(struct inode *inode, struct inode *dir,
+		const struct qstr *qstr);
+
 #endif /* __XFS_IOPS_H__ */
-- 
1.8.3.1

