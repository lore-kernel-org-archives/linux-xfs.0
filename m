Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43702 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965731AbeAKThw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 14:37:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 5/8] libxfs: use a memory zone for log items
Date: Thu, 11 Jan 2018 13:37:35 -0600
Message-Id: <1515699458-6925-6-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
References: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

In addition to more closely matching the kernel, this will
help us catch any leaks from these allocations.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 libxfs/trans.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/libxfs/trans.c b/libxfs/trans.c
index 035cc22..f79fae9 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -65,13 +65,7 @@ libxfs_trans_add_item(
 	ASSERT(lip->li_mountp == tp->t_mountp);
 	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
 
-	lidp = calloc(sizeof(struct xfs_log_item_desc), 1);
-	if (!lidp) {
-		fprintf(stderr, _("%s: lidp calloc failed (%d bytes): %s\n"),
-			progname, (int)sizeof(struct xfs_log_item_desc),
-			strerror(errno));
-		exit(1);
-	}
+	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP | KM_NOFS);
 
 	lidp->lid_item = lip;
 	lidp->lid_flags = 0;
@@ -80,6 +74,14 @@ libxfs_trans_add_item(
 	lip->li_desc = lidp;
 }
 
+static void
+libxfs_trans_free_item_desc(
+        struct xfs_log_item_desc *lidp)
+{
+	list_del_init(&lidp->lid_trans);
+	kmem_zone_free(xfs_log_item_desc_zone, lidp);
+}
+
 /*
  * Unlink and free the given descriptor.
  */
@@ -87,8 +89,7 @@ void
 libxfs_trans_del_item(
 	struct xfs_log_item	*lip)
 {
-	list_del_init(&lip->li_desc->lid_trans);
-	free(lip->li_desc);
+	libxfs_trans_free_item_desc(lip->li_desc);
 	lip->li_desc = NULL;
 }
 
-- 
1.8.3.1

