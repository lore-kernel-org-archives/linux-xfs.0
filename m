Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E11C129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3ogzQS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4F3C433C7;
	Sun, 31 Dec 2023 22:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062484;
	bh=/zOO9hlp/QwysXdyL5i3ozIfutgrORhvOmhAGiyOgQQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L3ogzQS+ED+E9dLKiJFTwcCYeERwZC+tSzd+ND/6F+Yr+FBjiHK2G+IiVbsJ+vrbL
	 a5aku8Am06//g+scjlG73lvB4Op9iTLQoamraBpz9NqGQ1BXpSN/T9aSknXodMXKX9
	 vdtV1vtawSyKQuWbm0FCdd6FtImWFU2HsdJQp/hBSWJVR06L1aSh9qIBKSXMJD5gvl
	 Gp5FW38jF4mRYQOiAwaIX0+1NEZW43gjmUOw4cuhoiabkYQTiMCrD4oOyf2CgSlnhD
	 sPSYehmom0rGTjptBfAs5ZorUgxpOD+Hj1/21s5tqsURY6ebFzV7nKAlTOfpJL1EAR
	 rYNrgkEZQGBaA==
Date: Sun, 31 Dec 2023 14:41:24 -0800
Subject: [PATCH 4/9] xfs_scrub: remove scrub_metadata_file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999499.1797790.4054299004240774717.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
References: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
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
---
 scrub/phase2.c |    2 +-
 scrub/scrub.c  |   12 ------------
 scrub/scrub.h  |    2 --
 3 files changed, 1 insertion(+), 15 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 4d4552d8477..4d90291ed14 100644
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
index ca3eea42ece..5c14ed2092e 100644
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
index b2e91efac70..874e1fe1319 100644
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

