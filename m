Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762BA4A28
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301485; cv=none; b=YC8zHDmLcnaMt34Y3VOp5L2crSEAXrJDkuE4VAmuZCQhquwPplICxTp9DWP2upk8TPLKPLD+vKdCZS02o5JZj52ThuTU1dCLyfr9FuZvubpSLwwwxJ6ytq82W9koWZ9XLNH3j040hmTPmcwQZOkVP8wZCd5s6c5CEOFS/NEjqIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301485; c=relaxed/simple;
	bh=ZKSHvm0PqwCQMo+V+B4gBlm5xpkY23jRgCMEPkg7qfA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZtKbo1hJ42nepOOzeKYleEFMf4HJXNIUcBdXExkYQDg1C+Z++1CtMCL3eBSWZcqgeDhHLJ6ZzuTnmoLI0zvDaXXoqCcDxvn6r4X2nkH5PaMJ3kS5v3rv2TeLQDUl+i5QHjeTEcUOQn2OniOGzAuhmV1LxIImxdf11Y/vpX39Gvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mfy4jOjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mfy4jOjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48996C32786;
	Tue, 30 Jul 2024 01:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301485;
	bh=ZKSHvm0PqwCQMo+V+B4gBlm5xpkY23jRgCMEPkg7qfA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mfy4jOjP7U/PL660Irn0KVI1uKTYwyZO83rZljRUci+hucs2w1qnib+UGIClD4J9w
	 bJ3f6AV/HxbXCEqmk5n1Ns0oKc8yx+6sCWPrhKpYaFOqPVikijTUw0gKyCA/Y0xP3l
	 HBD3Rz+7xGSI2vRKcbwaEtItZii61DOZESuIEEZbm5qcI/Xwb9SAVTbocBPPSIf4vY
	 Xsu5ytE0ZFyAnrpWVvofxF6Teh/cQEbxUElvqeq0q8FR1b0P+GVFKShf+2Yv9kpiz9
	 PqQQURTfGBj2H6o+KAqrTOsYppvIyHbDMDGhO1D8XvYlFugSwwcowExjgb7JscLqM3
	 o8HkvkpZ9kkug==
Date: Mon, 29 Jul 2024 18:04:44 -0700
Subject: [PATCH 5/5] xfs_scrub: hoist scrub retry loop to
 scrub_item_check_file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229846843.1348436.5577053768645865625.stgit@frogsfrogsfrogs>
In-Reply-To: <172229846763.1348436.17732340268176889954.stgit@frogsfrogsfrogs>
References: <172229846763.1348436.17732340268176889954.stgit@frogsfrogsfrogs>
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

For metadata check calls, use the ioctl retry and freeze permission
tracking in scrub_item that we created in the last patch.  This enables
us to move the check retry loop out of xfs_scrub_metadata and into its
caller to remove a long backwards jump, and gets us closer to
vectorizing scrub calls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/scrub.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index 8c6bf845f..69dfb1eb8 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -88,7 +88,6 @@ xfs_check_metadata(
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	struct xfs_scrub_metadata	meta = { };
 	enum xfrog_scrub_group		group;
-	unsigned int			tries = 0;
 	int				error;
 
 	background_sleep();
@@ -116,7 +115,7 @@ xfs_check_metadata(
 	descr_set(&dsc, &meta);
 
 	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta.sm_flags);
-retry:
+
 	error = -xfrog_scrub_metadata(xfdp, &meta);
 	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
 		meta.sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
@@ -163,10 +162,8 @@ _("Filesystem is shut down, aborting."));
 	 * we'll try the scan again, just in case the fs was busy.
 	 * Only retry so many times.
 	 */
-	if (want_retry(&meta) && tries < 10) {
-		tries++;
-		goto retry;
-	}
+	if (want_retry(&meta) && scrub_item_schedule_retry(sri, scrub_type))
+		return 0;
 
 	/* Complain about incomplete or suspicious metadata. */
 	scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
@@ -304,6 +301,7 @@ scrub_item_check_file(
 	int				override_fd)
 {
 	struct xfs_fd			xfd;
+	struct scrub_item		old_sri;
 	struct xfs_fd			*xfdp = &ctx->mnt;
 	unsigned int			scrub_type;
 	int				error;
@@ -323,7 +321,14 @@ scrub_item_check_file(
 		if (!(sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSCHECK))
 			continue;
 
-		error = xfs_check_metadata(ctx, xfdp, scrub_type, sri);
+		sri->sri_tries[scrub_type] = SCRUB_ITEM_MAX_RETRIES;
+		do {
+			memcpy(&old_sri, sri, sizeof(old_sri));
+			error = xfs_check_metadata(ctx, xfdp, scrub_type, sri);
+			if (error)
+				return error;
+		} while (scrub_item_call_kernel_again(sri, scrub_type,
+					SCRUB_ITEM_NEEDSCHECK, &old_sri));
 
 		/*
 		 * Progress is counted by the inode for inode metadata; for

