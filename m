Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4A7C4360C
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 17:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2220C21850
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 17:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfI0RSH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Sep 2019 13:18:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56946 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbfI0RSH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Sep 2019 13:18:07 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4DAE710CC20D
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2019 17:18:06 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF19826330
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2019 17:18:05 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 08/11] xfs: refactor and reuse best extent scanning logic
Date:   Fri, 27 Sep 2019 13:17:59 -0400
Message-Id: <20190927171802.45582-9-bfoster@redhat.com>
In-Reply-To: <20190927171802.45582-1-bfoster@redhat.com>
References: <20190927171802.45582-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Fri, 27 Sep 2019 17:18:06 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The bnobt "find best" helper implements a simple btree walker
function. This general pattern, or a subset thereof, is reused in
various parts of a near mode allocation operation. For example, the
bnobt left/right scans are each iterative btree walks along with the
cntbt lastblock scan.

Rework this function into a generic btree walker, add a couple
parameters to control termination behavior from various contexts and
reuse it where applicable.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 110 +++++++++++++++++++-------------------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 32b378c8e16c..85e82e184ec9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -875,6 +875,13 @@ xfs_alloc_cur_check(
 	acur->diff = diff;
 	*new = 1;
 
+	/*
+	 * We're done if we found a perfect allocation. This only deactivates
+	 * the current cursor, but this is just an optimization to terminate a
+	 * cntbt search that otherwise runs to the edge of the tree.
+	 */
+	if (acur->diff == 0 && acur->len == args->maxlen)
+		deactivate = true;
 out:
 	if (deactivate)
 		cur->bc_private.a.priv.abt.active = false;
@@ -1172,30 +1179,38 @@ xfs_alloc_ag_vextent_exact(
 }
 
 /*
- * Search the btree in a given direction and check the records against the good
- * extent we've already found.
+ * Search a given number of btree records in a given direction. Check each
+ * record against the good extent we've already found.
  */
 STATIC int
-xfs_alloc_find_best_extent(
+xfs_alloc_walk_iter(
 	struct xfs_alloc_arg	*args,
 	struct xfs_alloc_cur	*acur,
 	struct xfs_btree_cur	*cur,
-	bool			increment)
+	bool			increment,
+	bool			find_one, /* quit on first candidate */
+	int			count,    /* rec count (-1 for infinite) */
+	int			*stat)
 {
 	int			error;
 	int			i;
 
+	*stat = 0;
+
 	/*
 	 * Search so long as the cursor is active or we find a better extent.
 	 * The cursor is deactivated if it extends beyond the range of the
 	 * current allocation candidate.
 	 */
-	while (xfs_alloc_cur_active(cur)) {
+	while (xfs_alloc_cur_active(cur) && count) {
 		error = xfs_alloc_cur_check(args, acur, cur, &i);
 		if (error)
 			return error;
-		if (i == 1)
-			break;
+		if (i == 1) {
+			*stat = 1;
+			if (find_one)
+				break;
+		}
 		if (!xfs_alloc_cur_active(cur))
 			break;
 
@@ -1207,6 +1222,9 @@ xfs_alloc_find_best_extent(
 			return error;
 		if (i == 0)
 			cur->bc_private.a.priv.abt.active = false;
+
+		if (count > 0)
+			count--;
 	}
 
 	return 0;
@@ -1226,7 +1244,6 @@ xfs_alloc_ag_vextent_near(
 	struct xfs_btree_cur	*fbcur = NULL;
 	int			error;		/* error code */
 	int			i;		/* result code, temporary */
-	int			j;		/* result code, temporary */
 	xfs_agblock_t		bno;
 	xfs_extlen_t		len;
 	bool			fbinc = false;
@@ -1313,19 +1330,12 @@ xfs_alloc_ag_vextent_near(
 			if (!i)
 				break;
 		}
-		i = acur.cnt->bc_ptrs[0];
-		for (j = 1;
-		     !error && j && xfs_alloc_cur_active(acur.cnt) &&
-		     (acur.len < args->maxlen || acur.diff > 0);
-		     error = xfs_btree_increment(acur.cnt, 0, &j)) {
-			/*
-			 * For each entry, decide if it's better than
-			 * the previous best entry.
-			 */
-			error = xfs_alloc_cur_check(args, &acur, acur.cnt, &i);
-			if (error)
-				goto out;
-		}
+
+		error = xfs_alloc_walk_iter(args, &acur, acur.cnt, true, false,
+					    -1, &i);
+		if (error)
+			goto out;
+
 		/*
 		 * It didn't work.  We COULD be in a case where
 		 * there's a good record somewhere, so try again.
@@ -1357,49 +1367,39 @@ xfs_alloc_ag_vextent_near(
 		goto out;
 
 	/*
-	 * Loop going left with the leftward cursor, right with the
-	 * rightward cursor, until either both directions give up or
-	 * we find an entry at least as big as minlen.
+	 * Loop going left with the leftward cursor, right with the rightward
+	 * cursor, until either both directions give up or we find an entry at
+	 * least as big as minlen.
 	 */
 	do {
-		if (xfs_alloc_cur_active(acur.bnolt)) {
-			error = xfs_alloc_cur_check(args, &acur, acur.bnolt, &i);
-			if (error)
-				goto out;
-			if (i == 1) {
-				trace_xfs_alloc_cur_left(args);
-				fbcur = acur.bnogt;
-				fbinc = true;
-				break;
-			}
-			error = xfs_btree_decrement(acur.bnolt, 0, &i);
-			if (error)
-				goto out;
-			if (!i)
-				acur.bnolt->bc_private.a.priv.abt.active = false;
+		error = xfs_alloc_walk_iter(args, &acur, acur.bnolt, false,
+					    true, 1, &i);
+		if (error)
+			goto out;
+		if (i == 1) {
+			trace_xfs_alloc_cur_left(args);
+			fbcur = acur.bnogt;
+			fbinc = true;
+			break;
 		}
-		if (xfs_alloc_cur_active(acur.bnogt)) {
-			error = xfs_alloc_cur_check(args, &acur, acur.bnogt, &i);
-			if (error)
-				goto out;
-			if (i == 1) {
-				trace_xfs_alloc_cur_right(args);
-				fbcur = acur.bnolt;
-				fbinc = false;
-				break;
-			}
-			error = xfs_btree_increment(acur.bnogt, 0, &i);
-			if (error)
-				goto out;
-			if (!i)
-				acur.bnogt->bc_private.a.priv.abt.active = false;
+
+		error = xfs_alloc_walk_iter(args, &acur, acur.bnogt, true, true,
+					    1, &i);
+		if (error)
+			goto out;
+		if (i == 1) {
+			trace_xfs_alloc_cur_right(args);
+			fbcur = acur.bnolt;
+			fbinc = false;
+			break;
 		}
 	} while (xfs_alloc_cur_active(acur.bnolt) ||
 		 xfs_alloc_cur_active(acur.bnogt));
 
 	/* search the opposite direction for a better entry */
 	if (fbcur) {
-		error = xfs_alloc_find_best_extent(args, &acur, fbcur, fbinc);
+		error = xfs_alloc_walk_iter(args, &acur, fbcur, fbinc, true, -1,
+					    &i);
 		if (error)
 			goto out;
 	}
-- 
2.20.1

