Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43396 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752006AbeC2Pew (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:34:52 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 09/10] xfs_repair: test XFS_SB_VERSION_SHAREDBIT only once
Date: Thu, 29 Mar 2018 10:34:21 -0500
Message-Id: <1522337662-26260-10-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
References: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Remove 2 of the 3 identical tests for XFS_SB_VERSION_SHAREDBIT

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/versions.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/repair/versions.c b/repair/versions.c
index e33bda2..e96ee5c 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -107,16 +107,6 @@ parse_sb_version(xfs_sb_t *sb)
 		return 1;
 	}
 
-	if (sb->sb_versionnum & XFS_SB_VERSION_SHAREDBIT) {
-		do_warn(_("Shared Version bit set. Not supported. Ever.\n"));
-		return 1;
-	}
-
-	if (sb->sb_versionnum & XFS_SB_VERSION_SHAREDBIT) {
-		do_warn(_("Shared Version bit set. Not supported. Ever.\n"));
-		return 1;
-	}
-
 	/*
 	 * ok, check to make sure that the sb isn't newer
 	 * than we are
-- 
1.8.3.1

