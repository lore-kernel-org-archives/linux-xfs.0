Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087DBC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiEEQLd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381725AbiEEQLb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:11:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E2F5C668
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:07:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 958FF61DD3
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F9BC385AC;
        Thu,  5 May 2022 16:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766868;
        bh=Eg2SFFIYcpMb/n+/fC08kOOes3gFg+wzkxOlRhrnH5k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YZnDL9p6lOqjIlg+d3cN/YxNcPgYPRMXZSV97Heg9S4HISJXZf0G4CAWFbCSFNToo
         +Y2AQEgt05xAOtljRo33ckmarnz8oi8GKurjYLu5F2GtiUhIdPHHK/MqV/OHcOwxy/
         4iZie9Z3jUY/DhJhndYFr16/vng7nK7uqZz8kHBd2zUf+tVbhijgJh3fJtNY7qftQO
         kD16QwABnEKwMsXUzyr6WMb1zn9laZtBlIdRYN2vvHBNF1n+mSQgt7zfinODMR+16F
         n45RSwCCxvzdLtffpnojy9AbT4M0W716E9V8cz6kmXfPh7xrbRk7Ro14nESq+eIKoJ
         qjQXC3yl0W7gw==
Subject: [PATCH 1/6] xfs_scrub: collapse trivial file scrub helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:07:47 -0700
Message-ID: <165176686756.252160.8793537742478889025.stgit@magnolia>
In-Reply-To: <165176686186.252160.2880340500532409944.stgit@magnolia>
References: <165176686186.252160.2880340500532409944.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove all these trivial file scrub helper functions since they make
tracing code paths difficult and will become annoying in the patches
that follow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase3.c |   33 +++++--------------
 scrub/scrub.c  |   95 ++++----------------------------------------------------
 scrub/scrub.h  |   18 +----------
 3 files changed, 17 insertions(+), 129 deletions(-)


diff --git a/scrub/phase3.c b/scrub/phase3.c
index c7ce0ada..868f444d 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -20,22 +20,6 @@
 
 /* Phase 3: Scan all inodes. */
 
-/*
- * Run a per-file metadata scanner.  We use the ino/gen interface to
- * ensure that the inode we're checking matches what the inode scan
- * told us to look at.
- */
-static int
-scrub_fd(
-	struct scrub_ctx	*ctx,
-	int			(*fn)(struct scrub_ctx *ctx, uint64_t ino,
-				      uint32_t gen, struct action_list *a),
-	struct xfs_bulkstat	*bs,
-	struct action_list	*alist)
-{
-	return fn(ctx, bs->bs_ino, bs->bs_gen, alist);
-}
-
 struct scrub_inode_ctx {
 	struct ptcounter	*icount;
 	bool			aborted;
@@ -84,7 +68,7 @@ scrub_inode(
 	}
 
 	/* Scrub the inode. */
-	error = scrub_fd(ctx, scrub_inode_fields, bstat, &alist);
+	error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_INODE, &alist);
 	if (error)
 		goto out;
 
@@ -93,13 +77,13 @@ scrub_inode(
 		goto out;
 
 	/* Scrub all block mappings. */
-	error = scrub_fd(ctx, scrub_data_fork, bstat, &alist);
+	error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_BMBTD, &alist);
 	if (error)
 		goto out;
-	error = scrub_fd(ctx, scrub_attr_fork, bstat, &alist);
+	error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_BMBTA, &alist);
 	if (error)
 		goto out;
-	error = scrub_fd(ctx, scrub_cow_fork, bstat, &alist);
+	error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_BMBTC, &alist);
 	if (error)
 		goto out;
 
@@ -109,22 +93,21 @@ scrub_inode(
 
 	if (S_ISLNK(bstat->bs_mode)) {
 		/* Check symlink contents. */
-		error = scrub_symlink(ctx, bstat->bs_ino, bstat->bs_gen,
-				&alist);
+		error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_SYMLINK, &alist);
 	} else if (S_ISDIR(bstat->bs_mode)) {
 		/* Check the directory entries. */
-		error = scrub_fd(ctx, scrub_dir, bstat, &alist);
+		error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_DIR, &alist);
 	}
 	if (error)
 		goto out;
 
 	/* Check all the extended attributes. */
-	error = scrub_fd(ctx, scrub_attr, bstat, &alist);
+	error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_XATTR, &alist);
 	if (error)
 		goto out;
 
 	/* Check parent pointers. */
-	error = scrub_fd(ctx, scrub_parent, bstat, &alist);
+	error = scrub_file(ctx, bstat, XFS_SCRUB_TYPE_PARENT, &alist);
 	if (error)
 		goto out;
 
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 4ef19656..0034f11d 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -446,14 +446,13 @@ scrub_estimate_ag_work(
 }
 
 /*
- * Scrub inode metadata.  If errors occur, this function will log them and
- * return nonzero.
+ * Scrub file metadata of some sort.  If errors occur, this function will log
+ * them and return nonzero.
  */
-static int
-__scrub_file(
+int
+scrub_file(
 	struct scrub_ctx		*ctx,
-	uint64_t			ino,
-	uint32_t			gen,
+	const struct xfs_bulkstat	*bstat,
 	unsigned int			type,
 	struct action_list		*alist)
 {
@@ -464,8 +463,8 @@ __scrub_file(
 	assert(xfrog_scrubbers[type].type == XFROG_SCRUB_TYPE_INODE);
 
 	meta.sm_type = type;
-	meta.sm_ino = ino;
-	meta.sm_gen = gen;
+	meta.sm_ino = bstat->bs_ino;
+	meta.sm_gen = bstat->bs_gen;
 
 	/* Scrub the piece of metadata. */
 	fix = xfs_check_metadata(ctx, &meta, true);
@@ -477,86 +476,6 @@ __scrub_file(
 	return scrub_save_repair(ctx, alist, &meta);
 }
 
-int
-scrub_inode_fields(
-	struct scrub_ctx	*ctx,
-	uint64_t		ino,
-	uint32_t		gen,
-	struct action_list	*alist)
-{
-	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_INODE, alist);
-}
-
-int
-scrub_data_fork(
-	struct scrub_ctx	*ctx,
-	uint64_t		ino,
-	uint32_t		gen,
-	struct action_list	*alist)
-{
-	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTD, alist);
-}
-
-int
-scrub_attr_fork(
-	struct scrub_ctx	*ctx,
-	uint64_t		ino,
-	uint32_t		gen,
-	struct action_list	*alist)
-{
-	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTA, alist);
-}
-
-int
-scrub_cow_fork(
-	struct scrub_ctx	*ctx,
-	uint64_t		ino,
-	uint32_t		gen,
-	struct action_list	*alist)
-{
-	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTC, alist);
-}
-
-int
-scrub_dir(
-	struct scrub_ctx	*ctx,
-	uint64_t		ino,
-	uint32_t		gen,
-	struct action_list	*alist)
-{
-	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_DIR, alist);
-}
-
-int
-scrub_attr(
-	struct scrub_ctx	*ctx,
-	uint64_t		ino,
-	uint32_t		gen,
-	struct action_list	*alist)
-{
-	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_XATTR, alist);
-}
-
-int
-scrub_symlink(
-	struct scrub_ctx	*ctx,
-	uint64_t		ino,
-	uint32_t		gen,
-	struct action_list	*alist)
-{
-	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_SYMLINK, alist);
-}
-
-int
-scrub_parent(
-	struct scrub_ctx	*ctx,
-	uint64_t		ino,
-	uint32_t		gen,
-	struct action_list	*alist)
-{
-	return __scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_PARENT, alist);
-}
-
 /*
  * Test the availability of a kernel scrub command.  If errors occur (or the
  * scrub ioctl is rejected) the errors will be logged and this function will
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 537a2ebe..5b5f6b65 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -34,22 +34,8 @@ bool can_scrub_symlink(struct scrub_ctx *ctx);
 bool can_scrub_parent(struct scrub_ctx *ctx);
 bool xfs_can_repair(struct scrub_ctx *ctx);
 
-int scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct action_list *alist);
-int scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct action_list *alist);
-int scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct action_list *alist);
-int scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct action_list *alist);
-int scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct action_list *alist);
-int scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct action_list *alist);
-int scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct action_list *alist);
-int scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct action_list *alist);
+int scrub_file(struct scrub_ctx *ctx, const struct xfs_bulkstat *bstat,
+		unsigned int type, struct action_list *alist);
 
 /* Repair parameters are the scrub inputs and retry count. */
 struct action_item {

