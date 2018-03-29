Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43388 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751976AbeC2Pew (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:34:52 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 05/10] xfs_repair: remove unused fs_sb_feature_bits_allowed
Date: Thu, 29 Mar 2018 10:34:17 -0500
Message-Id: <1522337662-26260-6-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
References: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

fs_sb_feature_bits_allowed is never set to anything but 1;
remove it and all associated code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/versions.c   | 20 ++------------------
 repair/versions.h   |  3 ---
 repair/xfs_repair.c |  1 -
 3 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/repair/versions.c b/repair/versions.c
index d2c5844..34a3097 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -148,24 +148,8 @@ _("This filesystem contains features not understood by this program.\n"));
 		return(1);
 	}
 
-	if (XFS_SB_VERSION_NUM(sb) >= XFS_SB_VERSION_4)  {
-		if (!fs_sb_feature_bits_allowed)  {
-			if (!no_modify)  {
-				do_warn(
-_("WARNING:  you have disallowed superblock-feature-bits-allowed\n"
-  "\tbut this superblock has feature bits.  The superblock\n"
-  "\twill be downgraded.  This may cause loss of filesystem meta-data\n"));
-			} else   {
-				do_warn(
-_("WARNING:  you have disallowed superblock-feature-bits-allowed\n"
-  "\tbut this superblock has feature bits.  The superblock\n"
-  "\twould be downgraded.  This might cause loss of filesystem\n"
-  "\tmeta-data.\n"));
-			}
-		} else   {
-			fs_sb_feature_bits = 1;
-		}
-	}
+	if (XFS_SB_VERSION_NUM(sb) >= XFS_SB_VERSION_4)
+		fs_sb_feature_bits = 1;
 
 	/* Look for V5 feature flags we don't know about */
 	if (XFS_SB_VERSION_NUM(sb) >= XFS_SB_VERSION_5 &&
diff --git a/repair/versions.h b/repair/versions.h
index a0688f8..94f5775 100644
--- a/repair/versions.h
+++ b/repair/versions.h
@@ -27,8 +27,6 @@
  * possible XFS filesystem features
  *
  * inode version 2 (32-bit link counts)		(6.2)
- *
- * bitmask fields happend after 6.2.
  */
 
 /*
@@ -37,7 +35,6 @@
  * options
  */
 
-EXTERN int		fs_sb_feature_bits_allowed;
 EXTERN int		fs_has_extflgbit_allowed;
 EXTERN int		fs_shared_allowed;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 0b19208..8b81ecc 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -207,7 +207,6 @@ process_args(int argc, char **argv)
 	sb_inoalignmt = 0;
 	sb_unit = 0;
 	sb_width = 0;
-	fs_sb_feature_bits_allowed = 1;
 	fs_has_extflgbit_allowed = 1;
 	pre_65_beta = 0;
 	fs_shared_allowed = 1;
-- 
1.8.3.1

