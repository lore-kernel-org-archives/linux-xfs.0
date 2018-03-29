Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43392 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751981AbeC2Pew (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:34:52 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 07/10] xfs_repair: remove unused fs_shared_allowed variable
Date: Thu, 29 Mar 2018 10:34:19 -0500
Message-Id: <1522337662-26260-8-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
References: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The fs_shared_allowed global was set to 1 and then ignored, and
in fact the feature is never actualy allowed.  Remove it and
the last stragglers of the old features comment.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/versions.h   | 15 ---------------
 repair/xfs_repair.c |  1 -
 2 files changed, 16 deletions(-)

diff --git a/repair/versions.h b/repair/versions.h
index 8b95fc2..1fac278 100644
--- a/repair/versions.h
+++ b/repair/versions.h
@@ -24,20 +24,6 @@
 #endif /* EXTERN */
 
 /*
- * possible XFS filesystem features
- *
- * inode version 2 (32-bit link counts)		(6.2)
- */
-
-/*
- * filesystem feature global vars, set to 1 if the feature
- * is *allowed*, 0 otherwise.  These can be set via command-line
- * options
- */
-
-EXTERN int		fs_shared_allowed;
-
-/*
  * filesystem feature global vars, set to 1 if the feature
  * is on, 0 otherwise
  */
@@ -49,7 +35,6 @@ EXTERN int		fs_quotas;
 EXTERN int		fs_aligned_inodes;
 EXTERN int		fs_sb_feature_bits;
 EXTERN int		fs_has_extflgbit;
-EXTERN int		fs_shared;
 
 /*
  * inode chunk alignment, fsblocks
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index a2f3f62..3caf9bb 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -208,7 +208,6 @@ process_args(int argc, char **argv)
 	sb_unit = 0;
 	sb_width = 0;
 	pre_65_beta = 0;
-	fs_shared_allowed = 1;
 	ag_stride = 0;
 	thread_count = 1;
 	report_interval = PROG_RPT_DEFAULT;
-- 
1.8.3.1

