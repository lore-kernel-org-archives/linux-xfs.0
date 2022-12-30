Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C551C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiL3Wlt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235634AbiL3Wls (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:41:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7468D1573A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:41:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EABDB81C06
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36E2C433EF;
        Fri, 30 Dec 2022 22:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440104;
        bh=lv+kkNEaCXtoYYZUB/f4rogo2c0HBrktmNnqyOewztU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GubAod50T1dUoKeXyHTF0cdTeIITryXorp7D0yJFQZuYQPtJI9vuZTsSRoggqcBdT
         QAymcF/tPRd8X5YSphx6dwxTpyAaAsZzDRfzDvzb7ZBskzB81CP3Zpl/88L3XhR1Us
         8cXPy8Cw5BGusWDu/AQSK6dfMRWiGIFwvu5jELHY6+XyWpTw/cIGCRWEJDR+qQPEOx
         YGFRRYJSblaKWURYzolfV5OQz0o+osN08YzD4O4r20aghoWez9cPrqdkD4YQK/gpqe
         RwrXOzzP6oJ7mqGZ5T5o12uZCZjgNODRF0BPyLtadmnP1II5Z1Qt0TzJPapxQp2XM+
         i49SY+CjVn6OA==
Subject: [PATCH 2/2] xfs: always scrub record/key order of interior records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:22 -0800
Message-ID: <167243828211.684307.6247609605843739354.stgit@magnolia>
In-Reply-To: <167243828182.684307.10793765593002840378.stgit@magnolia>
References: <167243828182.684307.10793765593002840378.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit d47fef9342d0, we removed the firstrec and firstkey fields of
struct xchk_btree because Christoph thought they were unnecessary
because we could use the record index in the btree cursor.  This is
incorrect because bc_ptrs (now bc_levels[].ptr) tracks the cursor
position within a specific btree block, not within the entire level.

The end result is that scrub no longer detects situations where the
rightmost record of a block is identical to the leftmost record of that
block's right sibling.  Fix this regression by reintroducing record
validity booleans so that order checking skips *only* the leftmost
record/key in each level.

Fixes: d47fef9342d0 ("xfs: don't track firstrec/firstkey separately in xchk_btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/btree.c |   14 ++++++++------
 fs/xfs/scrub/btree.h |    8 +++++++-
 2 files changed, 15 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 615f52e56f4e..2dfa3e1d5841 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -151,11 +151,12 @@ xchk_btree_rec(
 
 	trace_xchk_btree_rec(bs->sc, cur, 0);
 
-	/* If this isn't the first record, are they in order? */
-	if (cur->bc_levels[0].ptr > 1 &&
+	/* Are all records across all record blocks in order? */
+	if (bs->lastrec_valid &&
 	    !cur->bc_ops->recs_inorder(cur, &bs->lastrec, rec))
 		xchk_btree_set_corrupt(bs->sc, cur, 0);
 	memcpy(&bs->lastrec, rec, cur->bc_ops->rec_len);
+	bs->lastrec_valid = true;
 
 	if (cur->bc_nlevels == 1)
 		return;
@@ -198,11 +199,12 @@ xchk_btree_key(
 
 	trace_xchk_btree_key(bs->sc, cur, level);
 
-	/* If this isn't the first key, are they in order? */
-	if (cur->bc_levels[level].ptr > 1 &&
-	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level - 1], key))
+	/* Are all low keys across all node blocks in order? */
+	if (bs->lastkey[level - 1].valid &&
+	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level - 1].key, key))
 		xchk_btree_set_corrupt(bs->sc, cur, level);
-	memcpy(&bs->lastkey[level - 1], key, cur->bc_ops->key_len);
+	memcpy(&bs->lastkey[level - 1].key, key, cur->bc_ops->key_len);
+	bs->lastkey[level - 1].valid = true;
 
 	if (level + 1 >= cur->bc_nlevels)
 		return;
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index 26c499925b5e..def8da9c4b4a 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -31,6 +31,11 @@ typedef int (*xchk_btree_rec_fn)(
 	struct xchk_btree		*bs,
 	const union xfs_btree_rec	*rec);
 
+struct xchk_btree_key {
+	union xfs_btree_key		key;
+	bool				valid;
+};
+
 struct xchk_btree {
 	/* caller-provided scrub state */
 	struct xfs_scrub		*sc;
@@ -40,11 +45,12 @@ struct xchk_btree {
 	void				*private;
 
 	/* internal scrub state */
+	bool				lastrec_valid;
 	union xfs_btree_rec		lastrec;
 	struct list_head		to_check;
 
 	/* this element must come last! */
-	union xfs_btree_key		lastkey[];
+	struct xchk_btree_key		lastkey[];
 };
 
 /*

