Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20724 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750814AbdFOUgd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2017 16:36:33 -0400
Subject: [PATCH 06/12] xfs_repair: replace rmap_compare with libxfs version
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 15 Jun 2017 13:36:26 -0700
Message-ID: <149755898600.3625.4950582443683509213.stgit@birch.djwong.org>
In-Reply-To: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
References: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that libxfs has a function to compare rmaps, replace xfs_repair's
helper function with that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/rmap.c            |   32 ++------------------------------
 2 files changed, 3 insertions(+), 30 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 34716c4..d299b7a 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -145,5 +145,6 @@
 #define xfs_refcount_get_rec		libxfs_refcount_get_rec
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
 #define xfs_refc_block			libxfs_refc_block
+#define xfs_rmap_compare		libxfs_rmap_compare
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/repair/rmap.c b/repair/rmap.c
index 7508973..ab6e583 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -49,37 +49,9 @@ static struct xfs_ag_rmap *ag_rmaps;
 static bool rmapbt_suspect;
 static bool refcbt_suspect;
 
-/*
- * Compare rmap observations for array sorting.
- */
-static int
-rmap_compare(
-	const void		*a,
-	const void		*b)
+static inline int rmap_compare(const void *a, const void *b)
 {
-	const struct xfs_rmap_irec	*pa;
-	const struct xfs_rmap_irec	*pb;
-	__u64			oa;
-	__u64			ob;
-
-	pa = a; pb = b;
-	oa = libxfs_rmap_irec_offset_pack(pa);
-	ob = libxfs_rmap_irec_offset_pack(pb);
-
-	if (pa->rm_startblock < pb->rm_startblock)
-		return -1;
-	else if (pa->rm_startblock > pb->rm_startblock)
-		return 1;
-	else if (pa->rm_owner < pb->rm_owner)
-		return -1;
-	else if (pa->rm_owner > pb->rm_owner)
-		return 1;
-	else if (oa < ob)
-		return -1;
-	else if (oa > ob)
-		return 1;
-	else
-		return 0;
+	return libxfs_rmap_compare(a, b);
 }
 
 /*

