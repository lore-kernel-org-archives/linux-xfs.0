Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E6CC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiJBScN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiJBScN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:32:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149123C15B
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:32:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4EBD60EDB
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1043AC433C1;
        Sun,  2 Oct 2022 18:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735531;
        bh=u6RvONEunvB6XRMzbLUX5KQA1oV2h+zbLWHw8DnLo5Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iIK6b0RmsB2dzOR/TEr9TbZzoyilwgPypuOANce1FgpLY/0mFmTzO7H3haHQtZZ3m
         Q1a2haq0kA+1vVB74KyZY2zxTEilUPwGKy23d0eK0AFnNKc4RovTatDQd7nV6X7Kgk
         Yg7cXAkvT7SxGS1fNiHqOqgztmh+JZ1190MLH/mIvc0tZThXCABNAcaqbyqmbiuZpn
         g3fEMAl/UjmAGHM5ZP4iOG6KIq8MPs+RCzq93sFusrzE/xlqeJqNUWv9Bsq4K69Fmo
         QyZ7+mogg4IBFG45sBkQir+ECHOKo2bmr69G4VKi05oGzG/AWyFk59L8J5UGK4KJGB
         9q4x1VJud54yQ==
Subject: [PATCH 2/2] xfs: check btree keys reflect the child block
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:12 -0700
Message-ID: <166473481277.1084112.2602696039943979101.stgit@magnolia>
In-Reply-To: <166473481246.1084112.5533985608121370791.stgit@magnolia>
References: <166473481246.1084112.5533985608121370791.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When scrub is checking a non-root btree block, it should make sure that
the keys in the parent btree block accurately capture the keyspace that
the child block stores.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/btree.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 47fa14311d17..2e2aa0773858 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -517,6 +517,48 @@ xchk_btree_check_minrecs(
 		xchk_btree_set_corrupt(bs->sc, cur, level);
 }
 
+/*
+ * If this btree block has a parent, make sure that the parent's keys capture
+ * the keyspace contained in this block.
+ */
+STATIC void
+xchk_btree_block_check_keys(
+	struct xchk_btree	*bs,
+	int			level,
+	struct xfs_btree_block	*block)
+{
+	union xfs_btree_key	block_key;
+	union xfs_btree_key	*block_high_key;
+	union xfs_btree_key	*parent_low_key, *parent_high_key;
+	struct xfs_btree_cur	*cur = bs->cur;
+	struct xfs_btree_block	*parent_block;
+	struct xfs_buf		*bp;
+
+	if (level == cur->bc_nlevels - 1)
+		return;
+
+	xfs_btree_get_keys(cur, block, &block_key);
+
+	/* Make sure the low key of this block matches the parent. */
+	parent_block = xfs_btree_get_block(cur, level + 1, &bp);
+	parent_low_key = xfs_btree_key_addr(cur, cur->bc_levels[level + 1].ptr,
+			parent_block);
+	if (cur->bc_ops->diff_two_keys(cur, &block_key, parent_low_key)) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
+		return;
+	}
+
+	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
+		return;
+
+	/* Make sure the high key of this block matches the parent. */
+	parent_high_key = xfs_btree_high_key_addr(cur,
+			cur->bc_levels[level + 1].ptr, parent_block);
+	block_high_key = xfs_btree_high_key_from_key(cur, &block_key);
+	if (cur->bc_ops->diff_two_keys(cur, block_high_key, parent_high_key))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
+}
+
 /*
  * Grab and scrub a btree block given a btree pointer.  Returns block
  * and buffer pointers (if applicable) if they're ok to use.
@@ -568,7 +610,12 @@ xchk_btree_get_block(
 	 * Check the block's siblings; this function absorbs error codes
 	 * for us.
 	 */
-	return xchk_btree_block_check_siblings(bs, *pblock);
+	error = xchk_btree_block_check_siblings(bs, *pblock);
+	if (error)
+		return error;
+
+	xchk_btree_block_check_keys(bs, level, *pblock);
+	return 0;
 }
 
 /*

