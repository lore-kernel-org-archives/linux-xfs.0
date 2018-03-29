Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43390 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbeC2Pew (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:34:52 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 06/10] xfs_repair: remove unused fs_has_extflgbit_allowed
Date: Thu, 29 Mar 2018 10:34:18 -0500
Message-Id: <1522337662-26260-7-git-send-email-sandeen@sandeen.net>
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
 repair/versions.c   | 18 +-----------------
 repair/versions.h   |  1 -
 repair/xfs_repair.c |  1 -
 3 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/repair/versions.c b/repair/versions.c
index 34a3097..e33bda2 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -90,8 +90,6 @@ update_sb_version(xfs_mount_t *mp)
 int
 parse_sb_version(xfs_sb_t *sb)
 {
-	int issue_warning;
-
 	fs_attributes = 0;
 	fs_attributes2 = 0;
 	fs_inode_nlink = 1;
@@ -103,7 +101,6 @@ parse_sb_version(xfs_sb_t *sb)
 	have_uquotino = 0;
 	have_gquotino = 0;
 	have_pquotino = 0;
-	issue_warning = 0;
 
 	if (sb->sb_versionnum & XFS_SB_VERSION_SHAREDBIT) {
 		do_warn(_("Shared Version bit set. Not supported. Ever.\n"));
@@ -124,21 +121,8 @@ parse_sb_version(xfs_sb_t *sb)
 	 * ok, check to make sure that the sb isn't newer
 	 * than we are
 	 */
-	if (xfs_sb_version_hasextflgbit(sb))  {
+	if (xfs_sb_version_hasextflgbit(sb))
 		fs_has_extflgbit = 1;
-		if (!fs_has_extflgbit_allowed)  {
-			issue_warning = 1;
-			do_warn(
-			_("This filesystem has uninitialized extent flags.\n"));
-		}
-	}
-
-	if (issue_warning)  {
-		do_warn(
-_("This filesystem uses feature(s) not yet supported in this release.\n"
-  "Please run a more recent version of xfs_repair.\n"));
-		return(1);
-	}
 
 	if (!xfs_sb_good_version(sb))  {
 		do_warn(_("WARNING:  unknown superblock version %d\n"),
diff --git a/repair/versions.h b/repair/versions.h
index 94f5775..8b95fc2 100644
--- a/repair/versions.h
+++ b/repair/versions.h
@@ -35,7 +35,6 @@
  * options
  */
 
-EXTERN int		fs_has_extflgbit_allowed;
 EXTERN int		fs_shared_allowed;
 
 /*
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 8b81ecc..a2f3f62 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -207,7 +207,6 @@ process_args(int argc, char **argv)
 	sb_inoalignmt = 0;
 	sb_unit = 0;
 	sb_width = 0;
-	fs_has_extflgbit_allowed = 1;
 	pre_65_beta = 0;
 	fs_shared_allowed = 1;
 	ag_stride = 0;
-- 
1.8.3.1

