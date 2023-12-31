Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D56C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g63OhbPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB88C433C8;
	Sun, 31 Dec 2023 22:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062296;
	bh=bUPVsEaU9/ZU+YZZgzPa/m8S3yi4vT8I+UHnQ9q5xUw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g63OhbPuP3JMIc62rmmpW6ftTndoc1GuIWIIQAZr5PoGXvnpOH0Pa90X7cHSRu0Z5
	 RwsVQiQHzFLqB/Hn2IwoiJZ4L8zRx1Xy3iNd9eT1cQs/sRuyf2QPKcjNR2biJFDv+q
	 I/jD1F00kHKpRRR3ZYykOp2Adu2k6sTz3ciSuZJCCj9IGTHd2J/eMz9pgPhRvM7bsr
	 2MEWGIQ7OIg8gjDsMehLSDApGyeJiF8M9OwUt9tb1AODEn0y9yNL8VVVifsmfLywBU
	 jKjv2AXXgANA0krMs1OMBijrsADaf+Z8I+0RN7jaWtmNZXu9GkRfb5mQy6IXl4LKTd
	 sBaGkdQiJyqbQ==
Date: Sun, 31 Dec 2023 14:38:15 -0800
Subject: [PATCH 7/7] xfs_scrub: actually try to fix summary counters ahead of
 repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404998739.1797322.2676507559663047353.stgit@frogsfrogsfrogs>
In-Reply-To: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
References: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
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
---
 scrub/phase4.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index d42e67637d8..0c67abf64a3 100644
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

