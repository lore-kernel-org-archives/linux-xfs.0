Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A553C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQopkcvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979E1C433C8;
	Sun, 31 Dec 2023 22:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062640;
	bh=ZFEhrmrjLxNx/PrG/ryYU2KyercbveM4+sOf1/NInXM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FQopkcvnGUwu2uzsgFxbvG1g+7gEpfScmaZwdchtx1sPmbS/DjYEXVkQZF8XT6qw4
	 V1Wf/bKv3e2MscO/qh6ed1k6qsUNEePipwestOsoc/9NfZ2mHsHDFsskzBMXspmadI
	 HladDifn+SoffOGbiKGhjniduoCg/oST3MywFODbrE//po/aVZgmFasjf44Rp90Rxi
	 N+6UDOO37RJlz/FPfcli+d8rEr0Kw3EkAf4GVHcDEexqbcK2UjCnH8nqm/KeaTNrjI
	 ts6G2ObPznFT7CK7L6UeI60+9o9pu43VymTb2CujQunaaV8MDGtUTOOsyRekfulQhc
	 7nffa11QpWE3Q==
Date: Sun, 31 Dec 2023 14:44:00 -0800
Subject: [PATCH 5/5] xfs_scrub: hoist scrub retry loop to
 scrub_item_check_file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999930.1798060.1234122907296127847.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999861.1798060.18204009464583067612.stgit@frogsfrogsfrogs>
References: <170404999861.1798060.18204009464583067612.stgit@frogsfrogsfrogs>
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
---
 scrub/scrub.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index 8c6bf845fd9..69dfb1eb84d 100644
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

