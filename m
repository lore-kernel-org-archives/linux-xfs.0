Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AEBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiLaAYM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiLaAYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:24:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B80FD104
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:24:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 279E261CE2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CBEC433EF;
        Sat, 31 Dec 2022 00:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446249;
        bh=r4KoeO7sXxeqp4oAUJrgOf8pHnzBa18ko+n8vo0w2fY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QIvZP2ITPo5E4xXqMzmmRoNgC84auS4YpKotjd8IKv/aLPOer2q5riMuzolo+AwT9
         Xs2FAkgrQ0gV1B3+JWrfm1qlptyAjv3o9FdI2Rj314o96PccUH1/eTPZwUAMv0qVNH
         1dV3FMgkZlHQYvcNBqDq86Jo9s0eVdBetWTwJ5ovpjQ/XKYGEwpKYbO7HsJiOYqMT+
         FBpBTL/VqYm0lZ0qEJdpcfOegGdvKp/1iskeBVTub+cx8F4JX8By7nmfvg8qVpt2qM
         Vw++xlvTj1jEos3EKKxVpy0RXHBjKRB35cnL0Dzd3TZqc+zSaPfs5SJHwY5BcBsmJ+
         tx1xmTNj9dEHA==
Subject: [PATCH 1/1] xfs: map xfile pages directly into xfs_buf
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:07 -0800
Message-ID: <167243868762.714598.3181270732734956525.stgit@magnolia>
In-Reply-To: <167243868750.714598.6299645052246352439.stgit@magnolia>
References: <167243868750.714598.6299645052246352439.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Map the xfile pages directly into xfs_buf to reduce memory overhead.
It's silly to use memory to stage changes to shmem pages for ephemeral
btrees that don't care about transactionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree_mem.h  |    6 ++++++
 libxfs/xfs_rmap_btree.c |    1 +
 2 files changed, 7 insertions(+)


diff --git a/libxfs/xfs_btree_mem.h b/libxfs/xfs_btree_mem.h
index ee142b97283..8feb104522b 100644
--- a/libxfs/xfs_btree_mem.h
+++ b/libxfs/xfs_btree_mem.h
@@ -17,8 +17,14 @@ struct xfbtree_config {
 
 	/* Owner of this btree. */
 	unsigned long long		owner;
+
+	/* XFBTREE_* flags */
+	unsigned int			flags;
 };
 
+/* buffers should be directly mapped from memory */
+#define XFBTREE_DIRECT_MAP		(1U << 0)
+
 #ifdef CONFIG_XFS_IN_MEMORY_BTREE
 unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp);
 
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index d6db7dfe22f..bc953516a98 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -668,6 +668,7 @@ xfs_rmapbt_mem_create(
 		.btree_ops	= &xfs_rmapbt_mem_ops,
 		.target		= target,
 		.owner		= agno,
+		.flags		= XFBTREE_DIRECT_MAP,
 	};
 
 	return xfbtree_create(mp, &cfg, xfbtreep);

