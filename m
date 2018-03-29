Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43386 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751968AbeC2Pev (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:34:51 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 04/10] xfs_repair: remove unused fs_aligned_inodes_allowed
Date: Thu, 29 Mar 2018 10:34:16 -0500
Message-Id: <1522337662-26260-5-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
References: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

fs_aligned_inodes_allowed is never set to anything but 1;
remove it and all associated code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/versions.c   | 18 ++----------------
 repair/versions.h   |  2 --
 repair/xfs_repair.c |  1 -
 3 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/repair/versions.c b/repair/versions.c
index 930ed98..d2c5844 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -215,22 +215,8 @@ _("WARNING: you have a V1 inode filesystem. It would be converted to a\n"
 	}
 
 	if (xfs_sb_version_hasalign(sb))  {
-		if (fs_aligned_inodes_allowed)  {
-			fs_aligned_inodes = 1;
-			fs_ino_alignment = sb->sb_inoalignmt;
-		} else   {
-			if (!no_modify)  {
-				do_warn(
-_("WARNING:  you have disallowed aligned inodes but this filesystem\n"
-  "\thas aligned inodes.  The filesystem will be downgraded.\n"
-  "\tThis will permanently degrade the performance of this filesystem.\n"));
-			} else  {
-				do_warn(
-_("WARNING:  you have disallowed aligned inodes but this filesystem\n"
-  "\thas aligned inodes.  The filesystem would be downgraded.\n"
-  "\tThis would permanently degrade the performance of this filesystem.\n"));
-			}
-		}
+		fs_aligned_inodes = 1;
+		fs_ino_alignment = sb->sb_inoalignmt;
 	}
 
 	/*
diff --git a/repair/versions.h b/repair/versions.h
index 1ce51bd..a0688f8 100644
--- a/repair/versions.h
+++ b/repair/versions.h
@@ -27,7 +27,6 @@
  * possible XFS filesystem features
  *
  * inode version 2 (32-bit link counts)		(6.2)
- * aligned inodes				(6.2+)
  *
  * bitmask fields happend after 6.2.
  */
@@ -38,7 +37,6 @@
  * options
  */
 
-EXTERN int		fs_aligned_inodes_allowed;
 EXTERN int		fs_sb_feature_bits_allowed;
 EXTERN int		fs_has_extflgbit_allowed;
 EXTERN int		fs_shared_allowed;
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 20a587c..0b19208 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -207,7 +207,6 @@ process_args(int argc, char **argv)
 	sb_inoalignmt = 0;
 	sb_unit = 0;
 	sb_width = 0;
-	fs_aligned_inodes_allowed = 1;
 	fs_sb_feature_bits_allowed = 1;
 	fs_has_extflgbit_allowed = 1;
 	pre_65_beta = 0;
-- 
1.8.3.1

