Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64338F40
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301815; cv=none; b=ZTSAgeeqi/jjJM6tATd2ArKiqF5EmKoOppgnV/si4cGJYnZ5be0hK/eU+8eWJyQr5ETLuljyWCCse6wlY+amjaNdbFLaTatMjy2WUrdy8mLDb7Ht9jqor0Vy3l/OyjJVeXnVnBtlzHNLFCTe0VQEMTxZhBHlJnyD4ylbFcGAZ+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301815; c=relaxed/simple;
	bh=elHh/OJYcjGgqqAvBkoF7q3Jyy07/IqTsX03PTirwj8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oR+n8iRz0DSBQMOqMjDEjkF9QH07l2WdFut2Lj5uWyBQz7JabETWGPDhM3bDjD1amf4VdmDVnkGGYPYH+mqM68LLicXzCS6+oQoma9E9g3Ptb+G9s+vpHlR5mycLjYLwUhFKGI501h2liC/bcb8NFGp7JJuawktnCbNI87W0jw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQzw8uVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQzw8uVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E40C32786;
	Tue, 30 Jul 2024 01:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301814;
	bh=elHh/OJYcjGgqqAvBkoF7q3Jyy07/IqTsX03PTirwj8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VQzw8uVX1kh2G56qIJd0MKsHXHPnh6lN9/k7AioGy0do5iee5X8mSB59+7BGBHiiT
	 WgoJn/Q0cNdTYKgcd+WeYmRqBIAueEG583r4KApXQHyPVdqPvz0i/ZYUe+PvasuZmQ
	 2dEvLEXq5tUsiQ+asiVlcIQzw6gHseL97u1dEXVORxg66MpSGuwQeGoIGjqmXNcEMx
	 hf3wSvqHGaxCzp4lIpivja7vFrj+/Oacocik8hv5y/pxlUdmokjlYf7yfgUSZllrJs
	 tJLNr0iS0XFMQuQXgMySQTpOUW9EERUvRAHzPqNDORjam0ySBhPwfg/OxJde0aqtYq
	 /DKnYkmfF/Z9Q==
Date: Mon, 29 Jul 2024 18:10:13 -0700
Subject: [PATCH 4/7] xfs_scrub: fix the work estimation for phase 8
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848093.1349330.5114879856116788288.stgit@frogsfrogsfrogs>
In-Reply-To: <172229848026.1349330.12889405227098722037.stgit@frogsfrogsfrogs>
References: <172229848026.1349330.12889405227098722037.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase8.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index e577260a9..dfe62e8d9 100644
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

