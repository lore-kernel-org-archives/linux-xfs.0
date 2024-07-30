Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C399101C5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301140; cv=none; b=qD7I5JTtY1cKKkfMOpiBHKPBBd66sOYdRSeofXfDn7uSk8jCCgzXkssAASBjselTuNdZj1U+uNiy5VFrnekKt4zz5M6wbxO2RANGg+m30AHUD1U8OqX6qew09RdSbaqEiKr0PVPjc1oJM2rZ8ykEDGsSiYzQduKKVxqz1+ZRwX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301140; c=relaxed/simple;
	bh=Qor6Rs907wGl9NQAgIkoRNDZGmfAQBk+UF04ff54/tg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MfiTR9KBYMBO8wJsIhXs5hC5hBJXWvU2hwloHleHsxnA8Aw+WXbgborNZ14mHJXhZB945osY1pNitaP/jcxFSYx2JtK2OVQGmswYL0iiAfaRQVMKh5mS67TL0soVCScos0lzN6aXrbef6PxPL5UTAK1SvJN+CvUQfxZgDxdXKks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=islynhe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="islynhe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEDFC32786;
	Tue, 30 Jul 2024 00:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301139;
	bh=Qor6Rs907wGl9NQAgIkoRNDZGmfAQBk+UF04ff54/tg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=islynhe5UGbhvL4uAk0RaBN5rT7R4eh2wTA8yDoHv7Hr8GFyi4ucQbZFMVcGCzlKx
	 OZIEYCB6JdBeJVtcV75Oz7azcxz+BqUcnsYLw7mUFNv1kvTk3gFxmGz0VMeG1i46E3
	 Fb+5OzaksC7VX6GYl+PurW/axs96riLuqXSkyEom0DLUlzshf7zLTCXKRT7NtVwyE/
	 lQBjEhiaxND3hYgUirjHkz8UsHfEl9wSh78mP86UWTptU0WW6bgEMiOYUjNOFXO6MP
	 Ab2btlwvwGWYAjgoZykeeM+HlR6GGSzwTqMn9lWqe1lbtmuA2t4wTSNebmQez+AFH4
	 SVZA9w8HOxEWA==
Date: Mon, 29 Jul 2024 17:58:59 -0700
Subject: [PATCH 5/5] xfs_scrub: actually try to fix summary counters ahead of
 repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229845614.1345742.16716590378668642512.stgit@frogsfrogsfrogs>
In-Reply-To: <172229845539.1345742.12185001279081616156.stgit@frogsfrogsfrogs>
References: <172229845539.1345742.12185001279081616156.stgit@frogsfrogsfrogs>
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

A while ago, I decided to make phase 4 check the summary counters before
it starts any other repairs, having observed that repairs of primary
metadata can fail because the summary counters (incorrectly) claim that
there aren't enough free resources in the filesystem.  However, if
problems are found in the summary counters, the repair work will be run
as part of the AG 0 repairs, which means that it runs concurrently with
other scrubbers.  This doesn't quite get us to the intended goal, so try
to fix the scrubbers ahead of time.  If that fails, tough, we'll get
back to it in phase 7 if scrub gets that far.

Fixes: cbaf1c9d91a0 ("xfs_scrub: check summary counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase4.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index d42e67637..0c67abf64 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -129,6 +129,7 @@ phase4_func(
 	struct scrub_ctx	*ctx)
 {
 	struct xfs_fsop_geom	fsgeom;
+	struct action_list	alist;
 	int			ret;
 
 	if (!have_action_items(ctx))
@@ -136,11 +137,13 @@ phase4_func(
 
 	/*
 	 * Check the summary counters early.  Normally we do this during phase
-	 * seven, but some of the cross-referencing requires fairly-accurate
-	 * counters, so counter repairs have to be put on the list now so that
-	 * they get fixed before we stop retrying unfixed metadata repairs.
+	 * seven, but some of the cross-referencing requires fairly accurate
+	 * summary counters.  Check and try to repair them now to minimize the
+	 * chance that repairs of primary metadata fail due to secondary
+	 * metadata.  If repairs fails, we'll come back during phase 7.
 	 */
-	ret = scrub_fs_counters(ctx, &ctx->action_lists[0]);
+	action_list_init(&alist);
+	ret = scrub_fs_counters(ctx, &alist);
 	if (ret)
 		return ret;
 
@@ -155,11 +158,18 @@ phase4_func(
 		return ret;
 
 	if (fsgeom.sick & XFS_FSOP_GEOM_SICK_QUOTACHECK) {
-		ret = scrub_quotacheck(ctx, &ctx->action_lists[0]);
+		ret = scrub_quotacheck(ctx, &alist);
 		if (ret)
 			return ret;
 	}
 
+	/* Repair counters before starting on the rest. */
+	ret = action_list_process(ctx, -1, &alist,
+			XRM_REPAIR_ONLY | XRM_NOPROGRESS);
+	if (ret)
+		return ret;
+	action_list_discard(&alist);
+
 	ret = repair_everything(ctx);
 	if (ret)
 		return ret;

