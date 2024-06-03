Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E78A23A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442649; cv=none; b=gaNY0r+/rmWpBE2MOc8tw7jgUXpOBwu5gUk6PE94r9vWmT3Bu4m40n6UOmtPU3htIZCCW4zvp1cMu/1mZS6vCIcTAWZiqbPUnfKIkcY1IwAd+KFj9bnHBVTH/Z0M5k43gRpryCb/PNIeAeKxd8COSMvYd3C+sHAZ+bwhA2Yixw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442649; c=relaxed/simple;
	bh=O49T+99fOmADMEdO0KR2Brgp7lzIshf+j9nwXCZzpvE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MD30O7dXLYSEtwaY+NY9xr4zBOwZ4zGl5I7KH57Stde1ZD4mFqtwhi+3o/YS0djZ1TXBSTpDOnClXoA72ONZ2OCrf1StUfoFuCrIopR+LeFWUfMONkW5lEswAzF86sem1cU5SzIoh4YrWk1zg2juXe04ofQL/Jhd6XJOjo+AhIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t8WfQWe1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t8WfQWe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F6AC32782;
	Mon,  3 Jun 2024 19:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442649;
	bh=O49T+99fOmADMEdO0KR2Brgp7lzIshf+j9nwXCZzpvE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t8WfQWe17bBAtKEQFFOK4zXINk7ff+6FaE5QSVh5f/KflTwGF1rYcJYyp9/k3lHTL
	 cYDCUggwCisvPGRIKFcIOrgqus14aU0LGDsPxEynslyThWM3jFn4Fkk3fpY/rtg4w1
	 8ngop4/akjMN8vzgWH90nFlj/uhd3v7UkQ9OZCtQ0xUDy9Gyg+9xEuW10UiMoBBiqC
	 pG5KGI3XcMTKmwFpdUDynh0KKhF6wjiuV6CzJwRi1WUSna6lHne1xi0rIouX7lxrTq
	 J+A70gvj6l5Wl/L4MRto25W+w45oAbs8/fy43xoHX9a/5LqK5kALxZeUGCgIA8tkOu
	 NfZBaxBbp55lg==
Date: Mon, 03 Jun 2024 12:24:08 -0700
Subject: [PATCH 5/5] xfs_scrub: upload clean bills of health
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744042448.1449803.6372671519928649561.stgit@frogsfrogsfrogs>
In-Reply-To: <171744042368.1449803.3300792972803173625.stgit@frogsfrogsfrogs>
References: <171744042368.1449803.3300792972803173625.stgit@frogsfrogsfrogs>
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

