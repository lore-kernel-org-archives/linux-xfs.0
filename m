Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43384 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751938AbeC2Pev (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:34:51 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 03/10] xfs_repair: remove unused fs_has_extflgbit_allowed
Date: Thu, 29 Mar 2018 10:34:15 -0500
Message-Id: <1522337662-26260-4-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
References: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

fs_has_extflgbit_allowed is never set to anything but 1;
remove it and all associated code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/versions.c   | 35 ++++++++---------------------------
 repair/versions.h   |  2 --
 repair/xfs_repair.c |  1 -
 3 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/repair/versions.c b/repair/versions.c
index 1fe0dbc..930ed98 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -47,10 +47,8 @@ update_sb_version(xfs_mount_t *mp)
 	 * have quotas.
 	 */
 	if (fs_quotas)  {
-		if (!xfs_sb_version_hasquota(sb))  {
-			ASSERT(fs_quotas_allowed);
+		if (!xfs_sb_version_hasquota(sb))
 			xfs_sb_version_addquota(sb);
-		}
 
 		/*
 		 * protect against stray bits in the quota flag field
@@ -204,33 +202,16 @@ _("WARNING: you have a V1 inode filesystem. It would be converted to a\n"
 	}
 
 	if (xfs_sb_version_hasquota(sb))  {
-		if (!fs_quotas_allowed)  {
-			if (!no_modify)  {
-				do_warn(
-_("WARNING:  you have disallowed quotas but this filesystem\n"
-  "\thas quotas.  The filesystem will be downgraded and\n"
-  "\tall quota information will be removed.\n"));
-			} else  {
-				do_warn(
-_("WARNING:  you have disallowed quotas but this filesystem\n"
-  "\thas quotas.  The filesystem would be downgraded and\n"
-  "\tall quota information would be removed.\n"));
-			}
-		} else   {
-			fs_quotas = 1;
+		fs_quotas = 1;
 
-			if (sb->sb_uquotino != 0 &&
-					sb->sb_uquotino != NULLFSINO)
-				have_uquotino = 1;
+		if (sb->sb_uquotino != 0 && sb->sb_uquotino != NULLFSINO)
+			have_uquotino = 1;
 
-			if (sb->sb_gquotino != 0 &&
-					sb->sb_gquotino != NULLFSINO)
-				have_gquotino = 1;
+		if (sb->sb_gquotino != 0 && sb->sb_gquotino != NULLFSINO)
+			have_gquotino = 1;
 
-			if (sb->sb_pquotino != 0 &&
-					sb->sb_pquotino != NULLFSINO)
-				have_pquotino = 1;
-		}
+		if (sb->sb_pquotino != 0 && sb->sb_pquotino != NULLFSINO)
+			have_pquotino = 1;
 	}
 
 	if (xfs_sb_version_hasalign(sb))  {
diff --git a/repair/versions.h b/repair/versions.h
index c487976..1ce51bd 100644
--- a/repair/versions.h
+++ b/repair/versions.h
@@ -27,7 +27,6 @@
  * possible XFS filesystem features
  *
  * inode version 2 (32-bit link counts)		(6.2)
- * quotas					(6.2+)
  * aligned inodes				(6.2+)
  *
  * bitmask fields happend after 6.2.
@@ -39,7 +38,6 @@
  * options
  */
 
-EXTERN int		fs_quotas_allowed;
 EXTERN int		fs_aligned_inodes_allowed;
 EXTERN int		fs_sb_feature_bits_allowed;
 EXTERN int		fs_has_extflgbit_allowed;
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 006f6cc..20a587c 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -207,7 +207,6 @@ process_args(int argc, char **argv)
 	sb_inoalignmt = 0;
 	sb_unit = 0;
 	sb_width = 0;
-	fs_quotas_allowed = 1;
 	fs_aligned_inodes_allowed = 1;
 	fs_sb_feature_bits_allowed = 1;
 	fs_has_extflgbit_allowed = 1;
-- 
1.8.3.1

