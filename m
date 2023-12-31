Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E735C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMrn6yVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF59C433C7;
	Sun, 31 Dec 2023 22:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062968;
	bh=jrFosdQWgW4PQM65ZOpOf1p4y0J3lPuPqfI5Es8bdbs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YMrn6yVrAaLjBGskP55EQcI2kiEH2a/6YDG2muHuaA8J/J2W8OpTCbgJPoJVhw5w1
	 woyMeG9MXzEsu9AeM1VTXfX7R04aRKCYtxwcbXTv2/x/zA/NEp1xQs5fWFe47SAWHP
	 1sPp+5iOrKO6VGGP9a9bTW1k4rqKTGjczmPbA+GIbFCWyVAxszd0bkh1Mwjct7c4Lu
	 zofMDhMN9FOC0RMjj7CqVXgUfCguMomaDpiAAIDpZEII4NTdWi+VXKSSOxOK/u/J04
	 Uy2BKfHTa828vgUYdoQRJGrvxnIQmBEFQjw7zzMKJhjYMvEo4e4GhC5T/djRrZPP3k
	 +zw7+85hkG7FA==
Date: Sun, 31 Dec 2023 14:49:28 -0800
Subject: [PATCH 4/8] xfs_scrub: fix the work estimation for phase 8
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001102.1798752.9143123897906517770.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
References: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
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

If there are latent errors on the filesystem, we aren't going to do any
work during phase 8 and it makes no sense to add that into the work
estimate for the progress bar.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index e577260a93d..dfe62e8d97b 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -21,23 +21,35 @@
 
 /* Phase 8: Trim filesystem. */
 
-/* Trim the filesystem, if desired. */
-int
-phase8_func(
+static inline bool
+fstrim_ok(
 	struct scrub_ctx	*ctx)
 {
-	if (action_list_empty(ctx->fs_repair_list) &&
-	    action_list_empty(ctx->file_repair_list))
-		goto maybe_trim;
-
 	/*
 	 * If errors remain on the filesystem, do not trim anything.  We don't
 	 * have any threads running, so it's ok to skip the ctx lock here.
 	 */
-	if (ctx->corruptions_found || ctx->unfixable_errors != 0)
+	if (!action_list_empty(ctx->fs_repair_list))
+		return false;
+	if (!action_list_empty(ctx->file_repair_list))
+		return false;
+
+	if (ctx->corruptions_found != 0)
+		return false;
+	if (ctx->unfixable_errors != 0)
+		return false;
+
+	return true;
+}
+
+/* Trim the filesystem, if desired. */
+int
+phase8_func(
+	struct scrub_ctx	*ctx)
+{
+	if (!fstrim_ok(ctx))
 		return 0;
 
-maybe_trim:
 	fstrim(ctx);
 	progress_add(1);
 	return 0;
@@ -51,7 +63,11 @@ phase8_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = 1;
+	*items = 0;
+
+	if (fstrim_ok(ctx))
+		*items = 1;
+
 	*nr_threads = 1;
 	*rshift = 0;
 	return 0;

