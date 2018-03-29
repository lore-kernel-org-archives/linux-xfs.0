Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43380 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751161AbeC2Pev (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:34:51 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 01/10] xfs_repair: remove unused fs_attributes_allowed
Date: Thu, 29 Mar 2018 10:34:13 -0500
Message-Id: <1522337662-26260-2-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
References: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

fs_attributes_allowed is never set to anything but 1;
remove it and all associated code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/versions.c   | 23 +++--------------------
 repair/versions.h   |  2 --
 repair/xfs_repair.c |  1 -
 3 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/repair/versions.c b/repair/versions.c
index 978f48b..cbf660d 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -31,10 +31,8 @@ update_sb_version(xfs_mount_t *mp)
 
 	sb = &mp->m_sb;
 
-	if (fs_attributes && !xfs_sb_version_hasattr(sb))  {
-		ASSERT(fs_attributes_allowed);
+	if (fs_attributes && !xfs_sb_version_hasattr(sb))
 		xfs_sb_version_addattr(sb);
-	}
 
 	if (fs_attributes2 && !xfs_sb_version_hasattr2(sb))  {
 		ASSERT(fs_attributes2_allowed);
@@ -187,23 +185,8 @@ _("Superblock has unknown compat/rocompat/incompat features (0x%x/0x%x/0x%x).\n"
 		return 1;
 	}
 
-	if (xfs_sb_version_hasattr(sb))  {
-		if (!fs_attributes_allowed)  {
-			if (!no_modify)  {
-				do_warn(
-_("WARNING:  you have disallowed attributes but this filesystem\n"
-  "\thas attributes.  The filesystem will be downgraded and\n"
-  "\tall attributes will be removed.\n"));
-			} else  {
-				do_warn(
-_("WARNING:  you have disallowed attributes but this filesystem\n"
-  "\thas attributes.  The filesystem would be downgraded and\n"
-  "\tall attributes would be removed.\n"));
-			}
-		} else   {
-			fs_attributes = 1;
-		}
-	}
+	if (xfs_sb_version_hasattr(sb))
+		fs_attributes = 1;
 
 	if (xfs_sb_version_hasattr2(sb))  {
 		if (!fs_attributes2_allowed)  {
diff --git a/repair/versions.h b/repair/versions.h
index 36a5262..354a797 100644
--- a/repair/versions.h
+++ b/repair/versions.h
@@ -26,7 +26,6 @@
 /*
  * possible XFS filesystem features
  *
- * attributes					(6.2)
  * inode version 2 (32-bit link counts)		(6.2)
  * quotas					(6.2+)
  * aligned inodes				(6.2+)
@@ -40,7 +39,6 @@
  * options
  */
 
-EXTERN int		fs_attributes_allowed;
 EXTERN int		fs_attributes2_allowed;
 EXTERN int		fs_quotas_allowed;
 EXTERN int		fs_aligned_inodes_allowed;
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 6bb8ea2..137a39c 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -207,7 +207,6 @@ process_args(int argc, char **argv)
 	sb_inoalignmt = 0;
 	sb_unit = 0;
 	sb_width = 0;
-	fs_attributes_allowed = 1;
 	fs_attributes2_allowed = 1;
 	fs_quotas_allowed = 1;
 	fs_aligned_inodes_allowed = 1;
-- 
1.8.3.1

