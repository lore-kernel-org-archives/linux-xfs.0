Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C173710E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301469; cv=none; b=mH4f0O+2/TuWdsvSkV/YegMOVKkld/hxjPw4/Ze9vp3LEWP3a1lECnKyDUxPLF5iO//6q14+8LCn1zMJKDC0b2dd5HXIvVXuz197QPH2ybdOWayjn22ukBkz+BofKZlXkX50YkupKG5+RGL+nHImhKNxYCU50cyfnM1l1q8R9sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301469; c=relaxed/simple;
	bh=oxmKAorrUZU8pgYbvCXRseLqLKXKH+XsN8VAqtT3E/g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OwkrEu2UHJi1BMeSKJsk7voQkTlPE7NJCjT7vU0XqVSDS/OiPSSw8yfl7znoY65i0UvXYpj1aoQwX8thyXLgShv+csLO2A7rjloOSF8zXqtgMR075WhxEc+9u9+1wwYOb8p2dAJez5sw4LP8a+LIp4iCdESIFwdWfrLWhSlBzoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ag3sAxUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ag3sAxUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC3EC32786;
	Tue, 30 Jul 2024 01:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301469;
	bh=oxmKAorrUZU8pgYbvCXRseLqLKXKH+XsN8VAqtT3E/g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ag3sAxUlHrfJKJpXDM6AYss9bHe/Cy2DilMHv5p2ecjvVZxX3SORTzZ3SHYWWugNd
	 Q7HkrKOKsRIcF2+pSgQSXV8sWbYk1FPytghobNymciyXV/owIyztI4hg9wWNQQ+Aoq
	 QHdsmhz9Z6Q85dMHfF3ZbgZiIwM6ThgXmjZpkR2puTACsi4/gOtVHUTLTsusM+KxTY
	 I/jXT7kZCh5/HE3ovPZEvQpdJCiIG7qmKnzgzQP/q5YuAWuXdlF9Qbnp+OQ0orER+o
	 bbCuwuwnJiq2fTxdaK6mnoz9qQ7gKvcoIzdqUqZxGfgACl4kMyYf1G5s5QjXuQVewB
	 0/jQi109/4mPA==
Date: Mon, 29 Jul 2024 18:04:28 -0700
Subject: [PATCH 4/5] xfs_scrub: hoist repair retry loop to repair_item_class
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229846828.1348436.3427780026764629216.stgit@frogsfrogsfrogs>
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

For metadata repair calls, move the ioctl retry and freeze permission
tracking into scrub_item.  This enables us to move the repair retry loop
out of xfs_repair_metadata and into its caller to remove a long
backwards jump, and gets us closer to vectorizing scrub calls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/repair.c        |   21 ++++++++++++---------
 scrub/scrub.c         |   32 ++++++++++++++++++++++++++++++--
 scrub/scrub.h         |    6 ++++++
 scrub/scrub_private.h |   14 ++++++++++++++
 4 files changed, 62 insertions(+), 11 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index f888441aa..c427e6e95 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -58,7 +58,6 @@ xfs_repair_metadata(
 	struct xfs_scrub_metadata	oldm;
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	bool				repair_only;
-	unsigned int			tries = 0;
 	int				error;
 
 	/*
@@ -100,7 +99,6 @@ xfs_repair_metadata(
 		str_info(ctx, descr_render(&dsc),
 				_("Attempting optimization."));
 
-retry:
 	error = -xfrog_scrub_metadata(xfdp, &meta);
 	switch (error) {
 	case 0:
@@ -187,10 +185,8 @@ _("Read-only filesystem; cannot make changes."));
 	 * the repair again, just in case the fs was busy.  Only retry so many
 	 * times.
 	 */
-	if (want_retry(&meta) && tries < 10) {
-		tries++;
-		goto retry;
-	}
+	if (want_retry(&meta) && scrub_item_schedule_retry(sri, scrub_type))
+		return 0;
 
 	if (repair_flags & XRM_FINAL_WARNING)
 		scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
@@ -541,6 +537,7 @@ repair_item_class(
 	unsigned int			flags)
 {
 	struct xfs_fd			xfd;
+	struct scrub_item		old_sri;
 	struct xfs_fd			*xfdp = &ctx->mnt;
 	unsigned int			scrub_type;
 	int				error = 0;
@@ -575,9 +572,15 @@ repair_item_class(
 		    !repair_item_dependencies_ok(sri, scrub_type))
 			continue;
 
-		error = xfs_repair_metadata(ctx, xfdp, scrub_type, sri, flags);
-		if (error)
-			break;
+		sri->sri_tries[scrub_type] = SCRUB_ITEM_MAX_RETRIES;
+		do {
+			memcpy(&old_sri, sri, sizeof(old_sri));
+			error = xfs_repair_metadata(ctx, xfdp, scrub_type, sri,
+					flags);
+			if (error)
+				return error;
+		} while (scrub_item_call_kernel_again(sri, scrub_type,
+					repair_mask, &old_sri));
 
 		/* Maybe update progress if we fixed the problem. */
 		if (!(flags & XRM_NOPROGRESS) &&
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 5f0cacbde..8c6bf845f 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -268,6 +268,34 @@ scrub_item_schedule_group(
 	}
 }
 
+/* Decide if we call the kernel again to finish scrub/repair activity. */
+bool
+scrub_item_call_kernel_again(
+	struct scrub_item	*sri,
+	unsigned int		scrub_type,
+	uint8_t			work_mask,
+	const struct scrub_item	*old)
+{
+	uint8_t			statex;
+
+	/* If there's nothing to do, we're done. */
+	if (!(sri->sri_state[scrub_type] & work_mask))
+		return false;
+
+	/*
+	 * We are willing to go again if the last call had any effect on the
+	 * state of the scrub item that the caller cares about, if the freeze
+	 * flag got set, or if the kernel asked us to try again...
+	 */
+	statex = sri->sri_state[scrub_type] ^ old->sri_state[scrub_type];
+	if (statex & work_mask)
+		return true;
+	if (sri->sri_tries[scrub_type] != old->sri_tries[scrub_type])
+		return true;
+
+	return false;
+}
+
 /* Run all the incomplete scans on this scrub principal. */
 int
 scrub_item_check_file(
@@ -383,9 +411,9 @@ scrub_item_dump(
 		unsigned int	g = 1U << xfrog_scrubbers[i].group;
 
 		if (g & group_mask)
-			printf("[%u]: type '%s' state 0x%x\n", i,
+			printf("[%u]: type '%s' state 0x%x tries %u\n", i,
 					xfrog_scrubbers[i].name,
-					sri->sri_state[i]);
+					sri->sri_state[i], sri->sri_tries[i]);
 	}
 	fflush(stdout);
 }
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 24fb24449..246c923f4 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -45,6 +45,9 @@ enum xfrog_scrub_group;
 				 SCRUB_ITEM_XFAIL | \
 				 SCRUB_ITEM_XCORRUPT)
 
+/* Maximum number of times we'll retry a scrub ioctl call. */
+#define SCRUB_ITEM_MAX_RETRIES	10
+
 struct scrub_item {
 	/*
 	 * Information we need to call the scrub and repair ioctls.  Per-AG
@@ -58,6 +61,9 @@ struct scrub_item {
 
 	/* Scrub item state flags, one for each XFS_SCRUB_TYPE. */
 	__u8			sri_state[XFS_SCRUB_TYPE_NR];
+
+	/* Track scrub and repair call retries for each scrub type. */
+	__u8			sri_tries[XFS_SCRUB_TYPE_NR];
 };
 
 #define foreach_scrub_type(loopvar) \
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index 53372e1f3..234b30ef2 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -89,4 +89,18 @@ scrub_item_type_boosted(
 	return sri->sri_state[scrub_type] & SCRUB_ITEM_BOOST_REPAIR;
 }
 
+/* Decide if we want to retry this operation and update bookkeeping if yes. */
+static inline bool
+scrub_item_schedule_retry(struct scrub_item *sri, unsigned int scrub_type)
+{
+	if (sri->sri_tries[scrub_type] == 0)
+		return false;
+	sri->sri_tries[scrub_type]--;
+	return true;
+}
+
+bool scrub_item_call_kernel_again(struct scrub_item *sri,
+		unsigned int scrub_type, uint8_t work_mask,
+		const struct scrub_item *old);
+
 #endif /* XFS_SCRUB_SCRUB_PRIVATE_H_ */

