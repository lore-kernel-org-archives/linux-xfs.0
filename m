Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44508 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbeAYTBU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Jan 2018 14:01:20 -0500
Subject: [PATCH 4/8 V2] libxfs: use a memory zone for transactions
From: Eric Sandeen <sandeen@sandeen.net>
References: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
 <1515699458-6925-5-git-send-email-sandeen@sandeen.net>
Message-ID: <e8515b2e-094b-3092-d82c-3394bd5d0ec5@sandeen.net>
Date: Thu, 25 Jan 2018 13:01:19 -0600
MIME-Version: 1.0
In-Reply-To: <1515699458-6925-5-git-send-email-sandeen@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>

In addition to more closely matching the kernel, this will
help us catch any leaks from these allocations.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: remove pointless NULL assignments

diff --git a/libxfs/init.c b/libxfs/init.c
index 302f088..7bde8b7 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -384,6 +384,7 @@ manage_zones(int release)
 	extern kmem_zone_t	*xfs_da_state_zone;
 	extern kmem_zone_t	*xfs_btree_cur_zone;
 	extern kmem_zone_t	*xfs_bmap_free_item_zone;
+	extern kmem_zone_t	*xfs_trans_zone;
 	extern kmem_zone_t	*xfs_log_item_desc_zone;
 	extern void		xfs_dir_startup();
 
@@ -395,6 +396,7 @@ manage_zones(int release)
 		kmem_free(xfs_da_state_zone);
 		kmem_free(xfs_btree_cur_zone);
 		kmem_free(xfs_bmap_free_item_zone);
+		kmem_free(xfs_trans_zone);
 		kmem_free(xfs_log_item_desc_zone);
 		return;
 	}
@@ -413,6 +415,8 @@ manage_zones(int release)
 	xfs_bmap_free_item_zone = kmem_zone_init(
 			sizeof(struct xfs_extent_free_item),
 			"xfs_bmap_free_item");
+	xfs_trans_zone = kmem_zone_init(
+			sizeof(struct xfs_trans), "xfs_trans");
 	xfs_log_item_desc_zone = kmem_zone_init(
 			sizeof(struct xfs_log_item_desc), "xfs_log_item_desc");
 	xfs_dir_startup();
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 57ff3ea..a602eaa 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -36,6 +36,7 @@ static void xfs_trans_free_items(struct xfs_trans *tp);
  * Simple transaction interface
  */
 
+kmem_zone_t	*xfs_trans_zone;
 kmem_zone_t	*xfs_log_item_desc_zone;
 
 /*
@@ -143,6 +144,17 @@ libxfs_trans_roll(
 	return 0;
 }
 
+/*
+ * Free the transaction structure.  If there is more clean up
+ * to do when the structure is freed, add it here.
+ */
+static void
+xfs_trans_free(
+	struct xfs_trans	*tp)
+{
+	kmem_zone_free(xfs_trans_zone, tp);
+}
+
 int
 libxfs_trans_alloc(
 	struct xfs_mount	*mp,
@@ -166,11 +178,8 @@ libxfs_trans_alloc(
 			return -ENOSPC;
 	}
 
-	if ((ptr = calloc(sizeof(xfs_trans_t), 1)) == NULL) {
-		fprintf(stderr, _("%s: xact calloc failed (%d bytes): %s\n"),
-			progname, (int)sizeof(xfs_trans_t), strerror(errno));
-		exit(1);
-	}
+	ptr = kmem_zone_zalloc(xfs_trans_zone,
+		(flags & XFS_TRANS_NOFS) ? KM_NOFS : KM_SLEEP);
 	ptr->t_mountp = mp;
 	ptr->t_blk_res = blocks;
 	INIT_LIST_HEAD(&ptr->t_items);
@@ -212,8 +221,7 @@ libxfs_trans_cancel(
 #endif
 	if (tp != NULL) {
 		xfs_trans_free_items(tp);
-		free(tp);
-		tp = NULL;
+		xfs_trans_free(tp);
 	}
 #ifdef XACT_DEBUG
 	fprintf(stderr, "## cancelled transaction %p\n", otp);
@@ -867,8 +875,7 @@ libxfs_trans_commit(
 		fprintf(stderr, "committed clean transaction %p\n", tp);
 #endif
 		xfs_trans_free_items(tp);
-		free(tp);
-		tp = NULL;
+		xfs_trans_free(tp);
 		return 0;
 	}
 
@@ -891,7 +898,6 @@ libxfs_trans_commit(
 	trans_committed(tp);
 
 	/* That's it for the transaction structure.  Free it. */
-	free(tp);
-	tp = NULL;
+	xfs_trans_free(tp);
 	return 0;
 }

