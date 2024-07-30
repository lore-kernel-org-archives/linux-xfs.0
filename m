Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88A54A2D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301390; cv=none; b=sumsmpom14wNuewaNqE3PTTSra3HSn5JvaU2QqDMsvxkMrDU+AeI/n+BQtopxd5SeuMMPUjwYJl/UqKvAXG980YGuBZGfxpgNvs0xhA3isB76CLHFm2kSIr1svVMwWd2puk/Odz840viYVlkFIvmcpDLKdK00TO3MvtFHHvRzCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301390; c=relaxed/simple;
	bh=p1Vx6zpQ0ANkMlT6xepLOdZFskwtd/P1sd5HM43RxyQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i1KlnpAL6JAGQnzrGt5ATCTg6mTqxbHu+cIHFAl/YDNx/UIwSijU4hokjtRQpxpVe1pD+Q7ZLIjq+71V+bVH2ty0pOvqUJmc9VoXaCrRpoSVvZcvdpGq49l3mhDNvvTDRQ8f3PDSQmpypyi5R0j4DVIWO7WWFpd6chcaZBrY2j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NCuqT9go; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NCuqT9go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B3AC32786;
	Tue, 30 Jul 2024 01:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301390;
	bh=p1Vx6zpQ0ANkMlT6xepLOdZFskwtd/P1sd5HM43RxyQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NCuqT9gotyg+qLf5VleJb3soYMFRLMBn2SzhPvFToTmnIha/oVMPFp8bkpk5/X1DG
	 FZSJP5M039cteBqg5FjBCLci1YMRFeZZc3ICm3HU0Z9S7eyfpdOtvyLxVlT3wEXmj9
	 ed7z55Lfayk7mPaG87JotZVBHNuI2bi1dAfL2GWybTEuE7BGXdHXFhxgf2S1cL8S2i
	 8UuFnBFlw225gHT52gL7T6+6Ps1RoEvCxczrO/DOb3/k0zlaNhQ9K+Mf6HzrSOyRjf
	 kEc2lcIHiAlenqNm+uHQgfGjoxuHNC/U8FVFxAss6pGBzKPTSLnfPWfG6aSDvwf8ls
	 ugOlM+ZtqpEMA==
Date: Mon, 29 Jul 2024 18:03:09 -0700
Subject: [PATCH 8/9] xfs_scrub: retry incomplete repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229846465.1348067.3551407359389464882.stgit@frogsfrogsfrogs>
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

If a repair says it didn't do anything on account of not being able to
complete a scan of the metadata, retry the repair a few times; if even
that doesn't work, we can delay it to phase 4.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/repair.c        |   15 ++++++++++++++-
 scrub/scrub.c         |    3 +--
 scrub/scrub_private.h |   10 ++++++++++
 3 files changed, 25 insertions(+), 3 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 9b4b5d016..2b863bb41 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -58,6 +58,7 @@ xfs_repair_metadata(
 	struct xfs_scrub_metadata	oldm;
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	bool				repair_only;
+	unsigned int			tries = 0;
 	int				error;
 
 	/*
@@ -99,6 +100,7 @@ xfs_repair_metadata(
 		str_info(ctx, descr_render(&dsc),
 				_("Attempting optimization."));
 
+retry:
 	error = -xfrog_scrub_metadata(xfdp, &meta);
 	switch (error) {
 	case 0:
@@ -179,9 +181,20 @@ _("Read-only filesystem; cannot make changes."));
 		return CHECK_DONE;
 	}
 
+	/*
+	 * If the kernel says the repair was incomplete or that there was a
+	 * cross-referencing discrepancy but no obvious corruption, we'll try
+	 * the repair again, just in case the fs was busy.  Only retry so many
+	 * times.
+	 */
+	if (want_retry(&meta) && tries < 10) {
+		tries++;
+		goto retry;
+	}
+
 	if (repair_flags & XRM_FINAL_WARNING)
 		scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
-	if (needs_repair(&meta)) {
+	if (needs_repair(&meta) || is_incomplete(&meta)) {
 		/*
 		 * Still broken; if we've been told not to complain then we
 		 * just requeue this and try again later.  Otherwise we
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 5c14ed209..5fc549f97 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -137,8 +137,7 @@ _("Filesystem is shut down, aborting."));
 	 * we'll try the scan again, just in case the fs was busy.
 	 * Only retry so many times.
 	 */
-	if (tries < 10 && (is_incomplete(meta) ||
-			   (xref_disagrees(meta) && !is_corrupt(meta)))) {
+	if (want_retry(meta) && tries < 10) {
 		tries++;
 		goto retry;
 	}
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index 08b9130cb..53372e1f3 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -49,6 +49,16 @@ static inline bool needs_repair(struct xfs_scrub_metadata *sm)
 	return is_corrupt(sm) || xref_disagrees(sm);
 }
 
+/*
+ * We want to retry an operation if the kernel says it couldn't complete the
+ * scan/repair; or if there were cross-referencing problems but the object was
+ * not obviously corrupt.
+ */
+static inline bool want_retry(struct xfs_scrub_metadata *sm)
+{
+	return is_incomplete(sm) || (xref_disagrees(sm) && !is_corrupt(sm));
+}
+
 void scrub_warn_incomplete_scrub(struct scrub_ctx *ctx, struct descr *dsc,
 		struct xfs_scrub_metadata *meta);
 

