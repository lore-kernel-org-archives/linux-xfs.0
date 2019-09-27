Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12468C47404
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 17:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E407D20872
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 17:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfI0RSH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Sep 2019 13:18:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbfI0RSH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Sep 2019 13:18:07 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A00462A09D6
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2019 17:18:06 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E16E26330
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2019 17:18:06 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 09/11] xfs: refactor near mode alloc bnobt scan into separate function
Date:   Fri, 27 Sep 2019 13:18:00 -0400
Message-Id: <20190927171802.45582-10-bfoster@redhat.com>
In-Reply-To: <20190927171802.45582-1-bfoster@redhat.com>
References: <20190927171802.45582-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 27 Sep 2019 17:18:06 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation to enhance the near mode allocation bnobt scan algorithm, lift
it into a separate function. No functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 128 ++++++++++++++++++++++----------------
 1 file changed, 74 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 85e82e184ec9..c1f59bfa8d09 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1230,6 +1230,78 @@ xfs_alloc_walk_iter(
 	return 0;
 }
 
+/*
+ * Search in the by-bno btree to the left and to the right simultaneously until
+ * in each case we find a large enough free extent or run into the edge of the
+ * tree. When we run into the edge of the tree, we deactivate that cursor.
+ */
+STATIC int
+xfs_alloc_ag_vextent_bnobt(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_cur	*acur,
+	int			*stat)
+{
+	struct xfs_btree_cur	*fbcur = NULL;
+	int			error;
+	int			i;
+	bool			fbinc;
+
+	ASSERT(acur->len == 0);
+	ASSERT(args->type == XFS_ALLOCTYPE_NEAR_BNO);
+
+	*stat = 0;
+
+	error = xfs_alloc_lookup_le(acur->bnolt, args->agbno, 0, &i);
+	if (error)
+		return error;
+	error = xfs_alloc_lookup_ge(acur->bnogt, args->agbno, 0, &i);
+	if (error)
+		return error;
+
+	/*
+	 * Loop going left with the leftward cursor, right with the rightward
+	 * cursor, until either both directions give up or we find an entry at
+	 * least as big as minlen.
+	 */
+	while (xfs_alloc_cur_active(acur->bnolt) ||
+	       xfs_alloc_cur_active(acur->bnogt)) {
+		error = xfs_alloc_walk_iter(args, acur, acur->bnolt, false,
+					    true, 1, &i);
+		if (error)
+			return error;
+		if (i == 1) {
+			trace_xfs_alloc_cur_left(args);
+			fbcur = acur->bnogt;
+			fbinc = true;
+			break;
+		}
+
+		error = xfs_alloc_walk_iter(args, acur, acur->bnogt, true, true,
+					    1, &i);
+		if (error)
+			return error;
+		if (i == 1) {
+			trace_xfs_alloc_cur_right(args);
+			fbcur = acur->bnolt;
+			fbinc = false;
+			break;
+		}
+	}
+
+	/* search the opposite direction for a better entry */
+	if (fbcur) {
+		error = xfs_alloc_walk_iter(args, acur, fbcur, fbinc, true, -1,
+					    &i);
+		if (error)
+			return error;
+	}
+
+	if (acur->len)
+		*stat = 1;
+
+	return 0;
+}
+
 /*
  * Allocate a variable extent near bno in the allocation group agno.
  * Extent's length (returned in len) will be between minlen and maxlen,
@@ -1241,12 +1313,10 @@ xfs_alloc_ag_vextent_near(
 	struct xfs_alloc_arg	*args)
 {
 	struct xfs_alloc_cur	acur = {0,};
-	struct xfs_btree_cur	*fbcur = NULL;
 	int			error;		/* error code */
 	int			i;		/* result code, temporary */
 	xfs_agblock_t		bno;
 	xfs_extlen_t		len;
-	bool			fbinc = false;
 #ifdef DEBUG
 	/*
 	 * Randomly don't execute the first algorithm.
@@ -1348,62 +1418,12 @@ xfs_alloc_ag_vextent_near(
 	}
 
 	/*
-	 * Second algorithm.
-	 * Search in the by-bno tree to the left and to the right
-	 * simultaneously, until in each case we find a space big enough,
-	 * or run into the edge of the tree.  When we run into the edge,
-	 * we deallocate that cursor.
-	 * If both searches succeed, we compare the two spaces and pick
-	 * the better one.
-	 * With alignment, it's possible for both to fail; the upper
-	 * level algorithm that picks allocation groups for allocations
-	 * is not supposed to do this.
+	 * Second algorithm. Search the bnobt left and right.
 	 */
-	error = xfs_alloc_lookup_le(acur.bnolt, args->agbno, 0, &i);
-	if (error)
-		goto out;
-	error = xfs_alloc_lookup_ge(acur.bnogt, args->agbno, 0, &i);
+	error = xfs_alloc_ag_vextent_bnobt(args, &acur, &i);
 	if (error)
 		goto out;
 
-	/*
-	 * Loop going left with the leftward cursor, right with the rightward
-	 * cursor, until either both directions give up or we find an entry at
-	 * least as big as minlen.
-	 */
-	do {
-		error = xfs_alloc_walk_iter(args, &acur, acur.bnolt, false,
-					    true, 1, &i);
-		if (error)
-			goto out;
-		if (i == 1) {
-			trace_xfs_alloc_cur_left(args);
-			fbcur = acur.bnogt;
-			fbinc = true;
-			break;
-		}
-
-		error = xfs_alloc_walk_iter(args, &acur, acur.bnogt, true, true,
-					    1, &i);
-		if (error)
-			goto out;
-		if (i == 1) {
-			trace_xfs_alloc_cur_right(args);
-			fbcur = acur.bnolt;
-			fbinc = false;
-			break;
-		}
-	} while (xfs_alloc_cur_active(acur.bnolt) ||
-		 xfs_alloc_cur_active(acur.bnogt));
-
-	/* search the opposite direction for a better entry */
-	if (fbcur) {
-		error = xfs_alloc_walk_iter(args, &acur, fbcur, fbinc, true, -1,
-					    &i);
-		if (error)
-			goto out;
-	}
-
 	/*
 	 * If we couldn't get anything, give up.
 	 */
-- 
2.20.1

