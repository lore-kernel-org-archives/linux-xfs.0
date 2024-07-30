Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B474A28
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301328; cv=none; b=GZhjd7s0MDp0GlL9TotosX0iKk0v+Fd7/aahDoS+JS2/WZMykeXPcQlMs7lmMV5wODFlNcTs6tMZSMKl3lXwXgyNC83mWRvH22tNUP6kX7CzxpSfX62rEjuw2aKnEEKb2YzMVT7CZOp4Q51pYsGjCqCuuHPQPEAz6DTcIrnOgOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301328; c=relaxed/simple;
	bh=c9fdnPGoh31lB1zKb4hoD6ZG+Bz/wdVuxylnyOtz6Vs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CsCAHrsdSX1vNrfkPU+F3IzCuPqI8dh4gkL/P+9Fmv52E6nrF/ZMP65FllzOb4xtmBInfdkVaxzls4uQeB9TWTKQZIQ1zLFxhRTAdbCLPVaLS1nFwnKpL+Ckc2g/dhIjPZTwrbbo3qBHc5jqvUl3WJ3NOMboCu5NUX+MAX4UR7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qQ0/YHWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQ0/YHWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD96C32786;
	Tue, 30 Jul 2024 01:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301328;
	bh=c9fdnPGoh31lB1zKb4hoD6ZG+Bz/wdVuxylnyOtz6Vs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qQ0/YHWzmDo5pNpiVRzZfX3YAVjIHbh7NytywSu2AVQlWMazNQEPrChc46M2nKNWw
	 5ugPt8uc21jVy/1EUL9H8MQtvwJkbAtwqzCfPte4qCKcVLmKow/v+EQNgq9niHiFs6
	 ocQ0ChVA58D6lZwVdUvJ6XWEsN+fctAK63Jopqji7UAkoigvlj75vHpfqSE0cZ+zBA
	 mKJpeb00phDlGm+vfBKbcjQn+Uc+9dRg8ma50w/vKwULk8D42LCtT6mu+16EMF1MlT
	 4r2UMHxZGz/ZOeQzJvdw1N/DVmdYM5qwZNEgevoYgTGvuQIwdPn0h4NkbXhXHCqOWV
	 7JpmiOSXHxJLQ==
Date: Mon, 29 Jul 2024 18:02:07 -0700
Subject: [PATCH 4/9] xfs_scrub: remove scrub_metadata_file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229846410.1348067.9285926878170650896.stgit@frogsfrogsfrogs>
In-Reply-To: <172229846343.1348067.12285575950038094861.stgit@frogsfrogsfrogs>
References: <172229846343.1348067.12285575950038094861.stgit@frogsfrogsfrogs>
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

Collapse this function with scrub_meta_type.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase2.c |    2 +-
 scrub/scrub.c  |   12 ------------
 scrub/scrub.h  |    2 --
 3 files changed, 1 insertion(+), 15 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 4d4552d84..4d90291ed 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -131,7 +131,7 @@ scan_fs_metadata(
 		goto out;
 
 	scrub_item_init_fs(&sri);
-	ret = scrub_fs_metadata(ctx, type, &sri);
+	ret = scrub_meta_type(ctx, type, &sri);
 	if (ret) {
 		sctl->aborted = true;
 		goto out;
diff --git a/scrub/scrub.c b/scrub/scrub.c
index ca3eea42e..5c14ed209 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -317,18 +317,6 @@ scrub_ag_metadata(
 	return scrub_group(ctx, XFROG_SCRUB_GROUP_PERAG, sri);
 }
 
-/* Scrub whole-filesystem metadata. */
-int
-scrub_fs_metadata(
-	struct scrub_ctx		*ctx,
-	unsigned int			type,
-	struct scrub_item		*sri)
-{
-	ASSERT(xfrog_scrubbers[type].group == XFROG_SCRUB_GROUP_FS);
-
-	return scrub_meta_type(ctx, type, sri);
-}
-
 /* Scrub all FS summary metadata. */
 int
 scrub_summary_metadata(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index b2e91efac..874e1fe13 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -82,8 +82,6 @@ void scrub_item_dump(struct scrub_item *sri, unsigned int group_mask,
 void scrub_report_preen_triggers(struct scrub_ctx *ctx);
 int scrub_ag_headers(struct scrub_ctx *ctx, struct scrub_item *sri);
 int scrub_ag_metadata(struct scrub_ctx *ctx, struct scrub_item *sri);
-int scrub_fs_metadata(struct scrub_ctx *ctx, unsigned int scrub_type,
-		struct scrub_item *sri);
 int scrub_iscan_metadata(struct scrub_ctx *ctx, struct scrub_item *sri);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct scrub_item *sri);
 int scrub_meta_type(struct scrub_ctx *ctx, unsigned int type,

