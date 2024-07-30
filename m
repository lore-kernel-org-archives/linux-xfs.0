Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A08029AF
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301171; cv=none; b=U8OZ1ahGIe9MPhL3r3vTJJj02n8Dv84Ik4h07Qd/+dDWHzI6fjLLoE2EKaRwFeYGmSnSlIok1EoDElsOOKHMT22T6dmtBaGCl31etmKj+GFiJ9t8Y6qDRKV61XWS5NTEgN6XxLvYXyV/099El9/BYJ2OkhCFDzJ/G9+XWIiowrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301171; c=relaxed/simple;
	bh=FnakemZQVpFRKUbGUINGT6Z7U6waQBqY+J/guphC7dI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JZlKSmLFLESSL9ObAche4DxwoLNeMTXmSDg5dwTu6ZdICoi1pG+K1Y9VloIDsTSDxSddsjf6lrPAMnEM9PqKycGzc86fcmEvZtg72HglssT9igAZykZovhT0/xg62CL0WtfqOwlGhOOeewrZIPu2ebK0zl/LP/uEdKlbzyWJovA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZhNiJgGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZhNiJgGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD6EC32786;
	Tue, 30 Jul 2024 00:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301171;
	bh=FnakemZQVpFRKUbGUINGT6Z7U6waQBqY+J/guphC7dI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZhNiJgGU6c3wozPxL8QbpRPALKGmCBChjwiZc5r84to8poNiE3MC6HqwgRkJ3cRiw
	 TtL5NZngDwXtdNfdM3gba3cRN+Vo6NC9wTOBsH4w0nC0ja7YOZ5l7mnEU2P6ALbDOG
	 B74zO5ydvdK5Pulem1OWm8lmeH/RkhLd3HMZkoIlYnzqSW39fITmnTTd/EHox+teKw
	 y3Cg3YEJfVn6YjBc3zdyLAf7kKf2QEdl5YJVRDIkoQk2co/Dyrx/oiUTSyC2aD2J5O
	 CSmwAAzXhh8LECM/tGbEzI9lbwSzz9p5XMv2xHXGqrFJORSDNHia6bFIsg8HMX7n8E
	 rz1SajeSVa4LQ==
Date: Mon, 29 Jul 2024 17:59:30 -0700
Subject: [PATCH 2/8] xfs_scrub: collapse trivial superblock scrub helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229845960.1345965.14663701295588505014.stgit@frogsfrogsfrogs>
In-Reply-To: <172229845921.1345965.6707043699978988202.stgit@frogsfrogsfrogs>
References: <172229845921.1345965.6707043699978988202.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Remove the trivial primary super scrub helper function since it makes
tracing code paths difficult and will become annoying in the patches
that follow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase2.c |    9 +++++----
 scrub/scrub.c  |   16 +---------------
 scrub/scrub.h  |    3 ++-
 3 files changed, 8 insertions(+), 20 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 2d49c604e..ec72bb5b7 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -166,12 +166,13 @@ phase2_func(
 	}
 
 	/*
-	 * In case we ever use the primary super scrubber to perform fs
-	 * upgrades (followed by a full scrub), do that before we launch
-	 * anything else.
+	 * Scrub primary superblock.  This will be useful if we ever need to
+	 * hook a filesystem-wide pre-scrub activity (e.g. enable filesystem
+	 * upgrades) off of the sb 0 scrubber (which currently does nothing).
+	 * If errors occur, this function will log them and return nonzero.
 	 */
 	action_list_init(&alist);
-	ret = scrub_primary_super(ctx, &alist);
+	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, &alist);
 	if (ret)
 		goto out_wq;
 	ret = action_list_process(ctx, -1, &alist,
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 595839130..c2e56e5f1 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -259,7 +259,7 @@ scrub_save_repair(
  * Returns 0 for success.  If errors occur, this function will log them and
  * return a positive error code.
  */
-static int
+int
 scrub_meta_type(
 	struct scrub_ctx		*ctx,
 	unsigned int			type,
@@ -325,20 +325,6 @@ scrub_group(
 	return 0;
 }
 
-/*
- * Scrub primary superblock.  This will be useful if we ever need to hook
- * a filesystem-wide pre-scrub activity off of the sb 0 scrubber (which
- * currently does nothing).  If errors occur, this function will log them and
- * return nonzero.
- */
-int
-scrub_primary_super(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
-{
-	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, alist);
-}
-
 /* Scrub each AG's header blocks. */
 int
 scrub_ag_headers(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 133445e8d..fef8a5960 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -17,7 +17,6 @@ enum check_outcome {
 struct action_item;
 
 void scrub_report_preen_triggers(struct scrub_ctx *ctx);
-int scrub_primary_super(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct action_list *alist);
 int scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
@@ -30,6 +29,8 @@ int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_nlinks(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_clean_health(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_meta_type(struct scrub_ctx *ctx, unsigned int type,
+		xfs_agnumber_t agno, struct action_list *alist);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);

