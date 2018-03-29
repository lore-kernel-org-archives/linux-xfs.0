Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43382 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751935AbeC2Pev (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:34:51 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 02/10] xfs_repair: remove unused fs_attributes2_allowed
Date: Thu, 29 Mar 2018 10:34:14 -0500
Message-Id: <1522337662-26260-3-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
References: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

fs_attributes2_allowed is never set to anything but 1;
remove it and all associated code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/versions.c   | 23 +++--------------------
 repair/versions.h   |  1 -
 repair/xfs_repair.c |  1 -
 3 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/repair/versions.c b/repair/versions.c
index cbf660d..1fe0dbc 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -34,10 +34,8 @@ update_sb_version(xfs_mount_t *mp)
 	if (fs_attributes && !xfs_sb_version_hasattr(sb))
 		xfs_sb_version_addattr(sb);
 
-	if (fs_attributes2 && !xfs_sb_version_hasattr2(sb))  {
-		ASSERT(fs_attributes2_allowed);
+	if (fs_attributes2 && !xfs_sb_version_hasattr2(sb))
 		xfs_sb_version_addattr2(sb);
-	}
 
 	/* V2 inode conversion is now always going to happen */
 	if (!(sb->sb_versionnum & XFS_SB_VERSION_NLINKBIT))
@@ -188,23 +186,8 @@ _("Superblock has unknown compat/rocompat/incompat features (0x%x/0x%x/0x%x).\n"
 	if (xfs_sb_version_hasattr(sb))
 		fs_attributes = 1;
 
-	if (xfs_sb_version_hasattr2(sb))  {
-		if (!fs_attributes2_allowed)  {
-			if (!no_modify)  {
-				do_warn(
-_("WARNING:  you have disallowed attr2 attributes but this filesystem\n"
-  "\thas attributes.  The filesystem will be downgraded and\n"
-  "\tall attr2 attributes will be removed.\n"));
-			} else  {
-				do_warn(
-_("WARNING:  you have disallowed attr2 attributes but this filesystem\n"
-  "\thas attributes.  The filesystem would be downgraded and\n"
-  "\tall attr2 attributes would be removed.\n"));
-			}
-		} else   {
-			fs_attributes2 = 1;
-		}
-	}
+	if (xfs_sb_version_hasattr2(sb))
+		fs_attributes2 = 1;
 
 	if (!(sb->sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
 		if (!no_modify) {
diff --git a/repair/versions.h b/repair/versions.h
index 354a797..c487976 100644
--- a/repair/versions.h
+++ b/repair/versions.h
@@ -39,7 +39,6 @@
  * options
  */
 
-EXTERN int		fs_attributes2_allowed;
 EXTERN int		fs_quotas_allowed;
 EXTERN int		fs_aligned_inodes_allowed;
 EXTERN int		fs_sb_feature_bits_allowed;
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 137a39c..006f6cc 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -207,7 +207,6 @@ process_args(int argc, char **argv)
 	sb_inoalignmt = 0;
 	sb_unit = 0;
 	sb_width = 0;
-	fs_attributes2_allowed = 1;
 	fs_quotas_allowed = 1;
 	fs_aligned_inodes_allowed = 1;
 	fs_sb_feature_bits_allowed = 1;
-- 
1.8.3.1

