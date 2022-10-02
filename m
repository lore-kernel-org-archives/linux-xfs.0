Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85507C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiJBScf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiJBScd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:32:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BDD3C15F
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3AD160EDB
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E294C433D6;
        Sun,  2 Oct 2022 18:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735552;
        bh=GL6wUJ0pndQzymSba/vqNX+sy7EKRYfc4bgD8NpXYAc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ffBQtkoDjzMVX9Kj2pF5KjytYiX3ydePY8UigQrD+RMpu+ORQncFuZ4tMSiHOyexF
         YkW/os8b57EBdNsS7bz1paodrTyJnC0kaFLe5VPY64e/oNAOeKEdipgKOBziyccSMd
         FxWn+noGtJac1EED+PNuuwsDWtUFGxwNp65odNJVe48bPEI9T062GaOSNyqGJhX+S0
         JyCRfVxRYgNte4lXvot7mfC54ej/cBlYJlNmmHK8hRhZ2Zr3KcqZ/3/IADE128YzGd
         ontoIGd/FensdCR66LzjU5uTzLYJVwUGzHO4FnF6XZROcwQ1/tyokNQSsMUDXjVnID
         NK8ZL51ZjijLA==
Subject: [PATCH 2/5] xfs: refactor converting btree irec to btree key
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:16 -0700
Message-ID: <166473481613.1084209.14289552157471603973.stgit@magnolia>
In-Reply-To: <166473481572.1084209.5434516873607335909.stgit@magnolia>
References: <166473481572.1084209.5434516873607335909.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We keep doing these conversions to support btree queries, so refactor
this into a helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5710d3ee582a..edea6db8d8e4 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4918,6 +4918,19 @@ xfs_btree_overlapped_query_range(
 	return error;
 }
 
+static inline void
+xfs_btree_key_from_irec(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_key		*key,
+	const union xfs_btree_irec	*irec)
+{
+	union xfs_btree_rec		rec;
+
+	cur->bc_rec = *irec;
+	cur->bc_ops->init_rec_from_cur(cur, &rec);
+	cur->bc_ops->init_key_from_rec(key, &rec);
+}
+
 /*
  * Query a btree for all records overlapping a given interval of keys.  The
  * supplied function will be called with each record found; return one of the
@@ -4932,18 +4945,12 @@ xfs_btree_query_range(
 	xfs_btree_query_range_fn	fn,
 	void				*priv)
 {
-	union xfs_btree_rec		rec;
 	union xfs_btree_key		low_key;
 	union xfs_btree_key		high_key;
 
 	/* Find the keys of both ends of the interval. */
-	cur->bc_rec = *high_rec;
-	cur->bc_ops->init_rec_from_cur(cur, &rec);
-	cur->bc_ops->init_key_from_rec(&high_key, &rec);
-
-	cur->bc_rec = *low_rec;
-	cur->bc_ops->init_rec_from_cur(cur, &rec);
-	cur->bc_ops->init_key_from_rec(&low_key, &rec);
+	xfs_btree_key_from_irec(cur, &high_key, high_rec);
+	xfs_btree_key_from_irec(cur, &low_key, low_rec);
 
 	/* Enforce low key < high key. */
 	if (cur->bc_ops->diff_two_keys(cur, &low_key, &high_key) > 0)
@@ -5069,20 +5076,14 @@ xfs_btree_scan_keyfill(
 	struct xfs_btree_scan_keyfill	info = {
 		.outcome		= XFS_BTREE_KEYFILL_EMPTY,
 	};
-	union xfs_btree_rec		rec;
 	int64_t				res;
 	int				error;
 
 	if (!cur->bc_ops->has_key_gap)
 		return -EOPNOTSUPP;
 
-	cur->bc_rec = *low;
-	cur->bc_ops->init_rec_from_cur(cur, &rec);
-	cur->bc_ops->init_key_from_rec(&info.start_key, &rec);
-
-	cur->bc_rec = *high;
-	cur->bc_ops->init_rec_from_cur(cur, &rec);
-	cur->bc_ops->init_key_from_rec(&info.end_key, &rec);
+	xfs_btree_key_from_irec(cur, &info.start_key, low);
+	xfs_btree_key_from_irec(cur, &info.end_key, high);
 
 	error = xfs_btree_query_range(cur, low, high,
 			xfs_btree_scan_keyfill_helper, &info);

