Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17916 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964876AbcI1C7l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:59:41 -0400
Subject: [PATCH 56/63] xfs: set a default CoW extent size of 32 blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:59:38 -0700
Message-ID: <147503157881.30303.13721862607939640317.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

If the admin doesn't set a CoW extent size or a regular extent size
hint, default to creating CoW reservations 32 blocks long to reduce
fragmentation.

Signed-off-by: DarricK J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 07c300b..a9fb223 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -80,7 +80,8 @@ xfs_get_extsz_hint(
 /*
  * Helper function to extract CoW extent size hint from inode.
  * Between the extent size hint and the CoW extent size hint, we
- * return the greater of the two.
+ * return the greater of the two.  If the value is zero (automatic),
+ * default to 32 blocks.
  */
 xfs_extlen_t
 xfs_get_cowextsz_hint(
@@ -93,9 +94,10 @@ xfs_get_cowextsz_hint(
 		a = ip->i_d.di_cowextsize;
 	b = xfs_get_extsz_hint(ip);
 
-	if (a > b)
-		return a;
-	return b;
+	a = max(a, b);
+	if (a == 0)
+		return 32;
+	return a;
 }
 
 /*

