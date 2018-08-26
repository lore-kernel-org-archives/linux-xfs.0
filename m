Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59294 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbeH0APM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 26 Aug 2018 20:15:12 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: verify size-vs-format for symlinks & dirs
Message-ID: <b0919ac0-deb3-4a0c-f755-309dd65c3206@redhat.com>
Date: Sun, 26 Aug 2018 15:31:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: "Xu, Wen" <wen.xu@gatech.edu>

Today, xfs_ifork_verify_data() will simply skip verification if the inode
claims to be in non-local format.  However, nothing catches the case where
the size for the format is too small to be non-local.  xfs_repair tests
for this mismatch in process_check_inode_sizes(), so do the same in this
verifier.

Reported-by: Xu, Wen <wen.xu@gatech.edu>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=200925
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index f9acf1d436f6..e032986d3f67 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -704,12 +704,21 @@ xfs_ifork_verify_data(
 	struct xfs_inode	*ip,
 	struct xfs_ifork_ops	*ops)
 {
-	/* Non-local data fork, we're done. */
-	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
-		return NULL;
+	int			mode = VFS_I(ip)->i_mode;
+
+	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL) {
+		/* Small size for dir & symlink must be local */
+		if ((S_ISDIR(mode) || S_ISLNK(mode)) &&
+		    (ip->i_d.di_size <= XFS_IFORK_DSIZE(ip))) {
+			return __this_address;
+		} else {
+			/* Non-local data fork, we're done. */
+			return NULL;
+		}
+	}
 
 	/* Check the inline data fork if there is one. */
-	switch (VFS_I(ip)->i_mode & S_IFMT) {
+	switch (mode & S_IFMT) {
 	case S_IFDIR:
 		return ops->verify_dir(ip);
 	case S_IFLNK:
