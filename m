Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48026 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729649AbfHOMzl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Aug 2019 08:55:41 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4FA34308A9E0
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2019 12:55:41 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C54D5DA8B
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2019 12:55:40 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 4/4] xfs: refactor successful AG allocation accounting code
Date: Thu, 15 Aug 2019 08:55:38 -0400
Message-Id: <20190815125538.49570-5-bfoster@redhat.com>
In-Reply-To: <20190815125538.49570-1-bfoster@redhat.com>
References: <20190815125538.49570-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The higher level allocation code is unnecessarily split across
xfs_alloc_ag_vextent() and xfs_alloc_ag_vextent_type(). In
preparation for condensing this code, factor out the AG accounting
bits and move the caller down after the generic allocation structure
and function definitions to pick them up without the need for
declarations. No functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 75 +++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d550aa5597bf..4ae4cfa0ed7f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1364,6 +1364,48 @@ xfs_alloc_ag_vextent_near(
 	return error;
 }
 
+/*
+ * Various AG accounting updates for a successful allocation. This includes
+ * updating the rmapbt, AG free block accounting and AG reservation accounting.
+ */
+STATIC int
+xfs_alloc_ag_vextent_accounting(
+	struct xfs_alloc_arg	*args)
+{
+	int			error = 0;
+
+	ASSERT(args->agbno != NULLAGBLOCK);
+	ASSERT(args->len >= args->minlen);
+	ASSERT(args->len <= args->maxlen);
+	ASSERT(!args->wasfromfl || args->resv != XFS_AG_RESV_AGFL);
+	ASSERT(args->agbno % args->alignment == 0);
+
+	/* if not file data, insert new block into the reverse map btree */
+	if (!xfs_rmap_should_skip_owner_update(&args->oinfo)) {
+		error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
+				       args->agbno, args->len, &args->oinfo);
+		if (error)
+			return error;
+	}
+
+	if (!args->wasfromfl) {
+		error = xfs_alloc_update_counters(args->tp, args->pag,
+						  args->agbp,
+						  -((long)(args->len)));
+		if (error)
+			return error;
+
+		ASSERT(!xfs_extent_busy_search(args->mp, args->agno,
+					      args->agbno, args->len));
+	}
+
+	xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
+
+	XFS_STATS_INC(args->mp, xs_allocx);
+	XFS_STATS_ADD(args->mp, xs_allocb, args->len);
+	return error;
+}
+
 /*
  * Allocate a variable extent in the allocation group agno.
  * Type and bno are used to determine where in the allocation group the
@@ -1402,38 +1444,11 @@ xfs_alloc_ag_vextent(
 		ASSERT(0);
 		/* NOTREACHED */
 	}
-
-	if (error || args->agbno == NULLAGBLOCK)
+	if (error)
 		return error;
 
-	ASSERT(args->len >= args->minlen);
-	ASSERT(args->len <= args->maxlen);
-	ASSERT(!args->wasfromfl || args->resv != XFS_AG_RESV_AGFL);
-	ASSERT(args->agbno % args->alignment == 0);
-
-	/* if not file data, insert new block into the reverse map btree */
-	if (!xfs_rmap_should_skip_owner_update(&args->oinfo)) {
-		error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
-				       args->agbno, args->len, &args->oinfo);
-		if (error)
-			return error;
-	}
-
-	if (!args->wasfromfl) {
-		error = xfs_alloc_update_counters(args->tp, args->pag,
-						  args->agbp,
-						  -((long)(args->len)));
-		if (error)
-			return error;
-
-		ASSERT(!xfs_extent_busy_search(args->mp, args->agno,
-					      args->agbno, args->len));
-	}
-
-	xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
-
-	XFS_STATS_INC(args->mp, xs_allocx);
-	XFS_STATS_ADD(args->mp, xs_allocb, args->len);
+	if (args->agbno != NULLAGBLOCK)
+		error = xfs_alloc_ag_vextent_accounting(args);
 	return error;
 }
 
-- 
2.20.1
