Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7250E14295
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716348052; cv=none; b=GJsqFBKRRZvBq833eo/vzlMi4X0RQhORBkmPBSFHfGWD0Z1ND+By+t/+Gd+4Ciz2SmaRQxTtwNSbWKUX/faPMLCjHhrxhxVhjJxapSLoEkwkXcy+ETAvYLnMYPywBDFoeGfzOERrgowNChID1NyleHZ+thUoQ+S6olLCZTCVVRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716348052; c=relaxed/simple;
	bh=O49T+99fOmADMEdO0KR2Brgp7lzIshf+j9nwXCZzpvE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YX+x2FaeTtLxTs2ERJIGr70l7nmhCC+AAoagwH4lfelFlaKjoFIX7WJy++wupkMDBWI7pOigHUbEMsQk6glGJdDB8D2LGaeE5ZSLw106KATfeMMoSh/QrUaR8uXIGp5jeXj/tRHvOjL0J+QMx9dvyth54PyplTo3XHIq8ZujZt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RaLmft6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RaLmft6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A20C2BD11;
	Wed, 22 May 2024 03:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716348052;
	bh=O49T+99fOmADMEdO0KR2Brgp7lzIshf+j9nwXCZzpvE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RaLmft6GQ8RimwlD7fZ5hT92nWDhwRdExDPq+Uscs/xf0M3xeGFi5i47U6CTD2FIM
	 O33awEyC1il2GQwNzLdf7tHLfds6zVOYHzoDloCxU70q4UieEZZ7/L50JVRsTM8MNu
	 1/5AWEgyGBTnmX+fffwbIG6VV3sIVkadr9nLjqGXn1b6RfqhCwaNnrHqboHMHCu2qQ
	 /QzyYUS48MXY6SKMxOa+eoHsE74FcHjxr1IbhkvdGGhF/13SA1R2KqUObPtZ5YIb/X
	 urTpnwa9ok/lUbi+HYQeT9UIFH0QwBbhEOOvjLRpB8bt86z8SVTC6vvJlUqtWYpS0X
	 gBlk0SwQJzipQ==
Date: Tue, 21 May 2024 20:20:51 -0700
Subject: [PATCH 5/5] xfs_scrub: upload clean bills of health
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634534787.2482960.2432140369998421080.stgit@frogsfrogsfrogs>
In-Reply-To: <171634534709.2482960.7052575979502113240.stgit@frogsfrogsfrogs>
References: <171634534709.2482960.7052575979502113240.stgit@frogsfrogsfrogs>
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

If scrub terminates with a clean bill of health, tell the kernel that
the result of the scan is that everything's healthy.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase1.c |   38 ++++++++++++++++++++++++++++++++++++++
 scrub/repair.c |   15 +++++++++++++++
 scrub/repair.h |    1 +
 scrub/scrub.c  |    9 +++++++++
 scrub/scrub.h  |    1 +
 5 files changed, 64 insertions(+)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 48ca8313b..96138e03e 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -44,6 +44,40 @@ xfs_shutdown_fs(
 		str_errno(ctx, ctx->mntpoint);
 }
 
+/*
+ * If we haven't found /any/ problems at all, tell the kernel that we're giving
+ * the filesystem a clean bill of health.
+ */
+static int
+report_to_kernel(
+	struct scrub_ctx	*ctx)
+{
+	struct action_list	alist;
+	int			ret;
+
+	if (!ctx->scrub_setup_succeeded || ctx->corruptions_found ||
+	    ctx->runtime_errors || ctx->unfixable_errors ||
+	    ctx->warnings_found)
+		return 0;
+
+	action_list_init(&alist);
+	ret = scrub_clean_health(ctx, &alist);
+	if (ret)
+		return ret;
+
+	/*
+	 * Complain if we cannot fail the clean bill of health, unless we're
+	 * just testing repairs.
+	 */
+	if (action_list_length(&alist) > 0 &&
+	    !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
+		str_info(ctx, _("Couldn't upload clean bill of health."), NULL);
+		action_list_discard(&alist);
+	}
+
+	return 0;
+}
+
 /* Clean up the XFS-specific state data. */
 int
 scrub_cleanup(
@@ -51,6 +85,10 @@ scrub_cleanup(
 {
 	int			error;
 
+	error = report_to_kernel(ctx);
+	if (error)
+		return error;
+
 	action_lists_free(&ctx->action_lists);
 	if (ctx->fshandle)
 		free_handle(ctx->fshandle, ctx->fshandle_len);
diff --git a/scrub/repair.c b/scrub/repair.c
index 3cb7224f7..9ade805e1 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -172,6 +172,21 @@ action_lists_alloc(
 	return 0;
 }
 
+/* Discard repair list contents. */
+void
+action_list_discard(
+	struct action_list		*alist)
+{
+	struct action_item		*aitem;
+	struct action_item		*n;
+
+	list_for_each_entry_safe(aitem, n, &alist->list, list) {
+		alist->nr--;
+		list_del(&aitem->list);
+		free(aitem);
+	}
+}
+
 /* Free the repair lists. */
 void
 action_lists_free(
diff --git a/scrub/repair.h b/scrub/repair.h
index 486617f1c..aa3ea1361 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -24,6 +24,7 @@ static inline bool action_list_empty(const struct action_list *alist)
 
 unsigned long long action_list_length(struct action_list *alist);
 void action_list_add(struct action_list *dest, struct action_item *item);
+void action_list_discard(struct action_list *alist);
 void action_list_splice(struct action_list *dest, struct action_list *src);
 
 void action_list_find_mustfix(struct action_list *actions,
diff --git a/scrub/scrub.c b/scrub/scrub.c
index cf0567795..7cb94af3d 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -444,6 +444,15 @@ scrub_nlinks(
 	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_NLINKS, 0, alist);
 }
 
+/* Update incore health records if we were clean. */
+int
+scrub_clean_health(
+	struct scrub_ctx		*ctx,
+	struct action_list		*alist)
+{
+	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_HEALTHY, 0, alist);
+}
+
 /* How many items do we have to check? */
 unsigned int
 scrub_estimate_ag_work(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 5e3f40bf1..cb33ddb46 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -29,6 +29,7 @@ int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_nlinks(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_clean_health(struct scrub_ctx *ctx, struct action_list *alist);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);

