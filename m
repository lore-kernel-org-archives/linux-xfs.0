Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E558C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235598AbiL3XpR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235741AbiL3Xou (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:44:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE5F1E3DF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:44:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FA1761C4E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C139C433EF;
        Fri, 30 Dec 2022 23:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443882;
        bh=BzjS+k+8aJ9G1rGnppytleBGI3J1h3/8oXDbvmo7BpM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Aau/BZ62axgxLj8eTSQ+7fmTzgbITLAcATFKud3AOv1W6Dnc25jqUxNBAL/kU+fXq
         q0378wTFXtSLYj0LdYuILA5phRNZgWhATZZRf8dH3rCZXW79NTS78gVM1ZB+P8IzXt
         adWRyJYgwcU27hz6jKrZIh2fyLRP5GnrmJHhyypwOaXoj+WktuV+aG3OQPfu0ghVN7
         LnLop8lc4z+r0OJzH8Ni0Ie96TqMQ5C2emWRtSYgUEq5YhGjDcZG9INKGAwsHdRUYO
         41vchH99uyotySG3JRj+wjOYuAc7KZ5vjypekEH687pn7IDSLsjOKJEF0fpURBuxtK
         qd+MkaFDXC4QA==
Subject: [PATCH 3/9] xfs: export some of the btree ops structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:34 -0800
Message-ID: <167243841411.696890.12846803140872622597.stgit@magnolia>
In-Reply-To: <167243841359.696890.6518296492918665756.stgit@magnolia>
References: <167243841359.696890.6518296492918665756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Export these btree ops structures so that we can reference them in the
AG initialization code in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    4 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    4 ++--
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 +-
 fs/xfs/libxfs/xfs_shared.h         |    9 +++++++++
 6 files changed, 16 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 5505cbb75cb6..6f17fee31872 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -454,7 +454,7 @@ xfs_allocbt_keys_contiguous(
 				 be32_to_cpu(key2->alloc.ar_startblock));
 }
 
-static const struct xfs_btree_ops xfs_bnobt_ops = {
+const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 
@@ -477,7 +477,7 @@ static const struct xfs_btree_ops xfs_bnobt_ops = {
 	.keys_contiguous	= xfs_allocbt_keys_contiguous,
 };
 
-static const struct xfs_btree_ops xfs_cntbt_ops = {
+const struct xfs_btree_ops xfs_cntbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 	.geom_flags		= XFS_BTREE_LASTREC_UPDATE,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 60bd5f94de3e..82a1e06aeac6 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -529,7 +529,7 @@ xfs_bmbt_keys_contiguous(
 				 be64_to_cpu(key2->bmbt.br_startoff));
 }
 
-static const struct xfs_btree_ops xfs_bmbt_ops = {
+const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
 	.geom_flags		= XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE,
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 5a59e105c801..84094e326a6e 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -399,7 +399,7 @@ xfs_inobt_keys_contiguous(
 				 be32_to_cpu(key2->inobt.ir_startino));
 }
 
-static const struct xfs_btree_ops xfs_inobt_ops = {
+const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 
@@ -421,7 +421,7 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.keys_contiguous	= xfs_inobt_keys_contiguous,
 };
 
-static const struct xfs_btree_ops xfs_finobt_ops = {
+const struct xfs_btree_ops xfs_finobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 8ba9768c0b3b..b037fd949f8c 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -323,7 +323,7 @@ xfs_refcountbt_keys_contiguous(
 				 be32_to_cpu(key2->refc.rc_startblock));
 }
 
-static const struct xfs_btree_ops xfs_refcountbt_ops = {
+const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 0040e2620c24..31dc40358bf9 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -486,7 +486,7 @@ xfs_rmapbt_keys_contiguous(
 				 be32_to_cpu(key2->rmap.rm_startblock));
 }
 
-static const struct xfs_btree_ops xfs_rmapbt_ops = {
+const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
 	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING,
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 57a52fa76a49..d1b3f210326e 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -43,6 +43,15 @@ extern const struct xfs_buf_ops xfs_sb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 
+/* btree ops */
+extern const struct xfs_btree_ops xfs_bnobt_ops;
+extern const struct xfs_btree_ops xfs_cntbt_ops;
+extern const struct xfs_btree_ops xfs_inobt_ops;
+extern const struct xfs_btree_ops xfs_finobt_ops;
+extern const struct xfs_btree_ops xfs_bmbt_ops;
+extern const struct xfs_btree_ops xfs_refcountbt_ops;
+extern const struct xfs_btree_ops xfs_rmapbt_ops;
+
 /* log size calculation functions */
 int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
 int	xfs_log_calc_minimum_size(struct xfs_mount *);

