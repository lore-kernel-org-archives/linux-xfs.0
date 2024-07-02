Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72524BE49
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882110; cv=none; b=dZ7q4LSQXzkfBCS38qr7eAkRDPCuFrQPVNGyqEAMK4LvKn/0WfR+BFguxMpN11uI5ZhHB6OpXLytuL24UKZPQFXJjASGIKqK1LSmBdO2xK75Pp3TWmplCK7rByZAmq/+TINgL/te0/GN0Yof4DQGXGyfWjdn85IL8ZUBH7Hwj6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882110; c=relaxed/simple;
	bh=zEtc0sBjoiCx2y6nVyxJf0NjaIYKMOe6NJQ9UpEyipM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T0+QwTlT7b6JO06uV8stCfTXH051k21A3xhm+lvbrfeyi+T9Bht0r2rDvGrhQyNOFB/PCt+WJnJ5gT6wrDRCxWUWpyagPcUteRHK2WrxGX5LSSbLS0Yvb0kbq9dShFujzYKM4nCHPJRPBbE/a7KfdR+pZ63cr6R5dScExf8rsA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JGC2kino; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JGC2kino"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F31C4AF11;
	Tue,  2 Jul 2024 01:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882110;
	bh=zEtc0sBjoiCx2y6nVyxJf0NjaIYKMOe6NJQ9UpEyipM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JGC2kinofvMLDTvFN9c4pTJqNUIvuiolk8/pgGrVwwuTc+Qg0J89XQTdcbUSdwDSY
	 yANCdL0LqOMaT/dMRy4+ucB4DjsrjdW4BPJMdkT5Km51XhQXW4r9WA9XWTsgR6p6uX
	 VLhiExDHpPI0bI5lQ4pHfhOpLeaLBCmGBI2QCI01QiGb9bwTqBsQCA2S1mN65Z4hbu
	 +8/MPZgReeM7JujkZ+tKyCFDxgoMQXlwRZsg4g3b9ATjmemJuox0E5k1UyWapzzLhZ
	 Zb6xEJfYwmBPJPWkJSn9x3wuYAW5M0xQTwU38imbK29a5tM0iwTEnaSl66xgwn4Jzl
	 BJ625K5pJtkog==
Date: Mon, 01 Jul 2024 18:01:49 -0700
Subject: [PATCH 4/8] xfs_scrub: fix the work estimation for phase 8
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118191.2007602.10091096037746377494.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
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
index e577260a93dd..dfe62e8d97be 100644
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

