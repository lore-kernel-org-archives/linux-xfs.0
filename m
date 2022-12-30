Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE73CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbiL3Wle (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235634AbiL3Wlc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:41:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A3013CE7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:41:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 685F8B81D95
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2257EC433EF;
        Fri, 30 Dec 2022 22:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440089;
        bh=7L+aOcKLpNLPKvoIugfFJw/fl+zzX+Fq/hpQZ1eJdYs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sDF0c6F8AUNS757HkUUOAcvvFC3aFD6vxBsItqp4dQxEZuQRHkY7h/UbpTW5Mp4w2
         1Qo8PkLZTGaK0tac72LuibeApEiCQwBtPM+rSXzRJOCmu94Pj0c1b5lCxmXu4KNLQj
         3UIu8PVF2BMBrFTwtGO7VyNvl/uMYonl4QSLLFiLvmmzq0k8FfCVufadrMaq+4LUg9
         YeWsPk9+Kt9mk4L1h7s9YETQVyVTnEZriRk7GJGOMsK6tlJdxUzd79+Qq+IE2h/ZQL
         4Rp+PkaAsv/cbvHKMi2xDbME0Gyqyr+58gXokEzpaEKKAV10WkLMXzG73e1znEuJZY
         KV3omH0z2lpJw==
Subject: [PATCH 1/2] xfs: check btree keys reflect the child block
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:22 -0800
Message-ID: <167243828197.684307.5795011464354303562.stgit@magnolia>
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

When scrub is checking a non-root btree block, it should make sure that
the keys in the parent btree block accurately capture the keyspace that
the child block stores.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/btree.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 634c504bac20..615f52e56f4e 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -529,6 +529,48 @@ xchk_btree_check_minrecs(
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
@@ -580,7 +622,12 @@ xchk_btree_get_block(
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

