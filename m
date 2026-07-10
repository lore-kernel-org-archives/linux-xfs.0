Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F4924336D
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2026 05:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783660934; cv=none; b=jG2pEawGgLuViqiGzIQ67t/+ezZTH5Hap4qLqrtz3ok0ClX/JUcpWSGxlKLGR854hHabrc2uJiOytCuZqsj4j8p3zHM7Jew9EhwQIRyj+6L5lMulgyT6wMHUeDMNbIkuxvMI03cSlhXo/eFXXHbdcfYuYuxLq+mu8zAfjimLkjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783660934; c=relaxed/simple;
	bh=MSYZuTX7mfyKEl7RMR2bd+FfdTR0jNq4zvnEmjnuBHM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bFC2rRXIxHx/u7sC8ewaywt+sVb4y746LY3mzZiP0HgGMtqjRx8A/nCJtZtiRz83G+byn/HJX82juhv0G+hH/gysaQDb5ULWCasIL+H/ThKR2j/K4+lGKNMUmjYAUR6q5mfvVecppXpYuDBTkJ03hJnzAkla9hty1tKdfrbjYj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TqK0Npoi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TqK0Npoi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 837C71F000E9;
	Fri, 10 Jul 2026 05:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783660932;
	bh=0XsYDKInfsRMy9dJsZzHrUijBklXWRG84DEjod5n/U8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=TqK0NpoiwQQ7dBbz2ZwmvMYQEd7bxI2vpIrjb46/3P38qJMngbLlmNcgr5awjWEcA
	 Oq9n39bDXoMcW+RlFdBoEE/GqTZ77sJyx6QDZQLjivww/edRxCFVf28U9L0bEoKpFQ
	 PcnlbT/EQ11Hht5jpmhbQrZ0i7gbYKfpo7W5WFRaw963SI2pxbsI6kfZyHGCGmWB/N
	 4BRMX7zGkwrDiEc22/xYCLMk35uvn11mMADSoUCDnAWthte+XGwj+KExWPXnjQL0Rb
	 ct3lUxFviHmclt4KrZK1E4kFFzeSEGDxr+GxHTiwvCdrP4rpku/IO0zYH0lSZlhleg
	 5rGDLJLYEhL9g==
Date: Thu, 09 Jul 2026 22:22:12 -0700
Subject: [PATCH 2/8] xfs: make cow repair somewhat flaky when debugging knob
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <178366081035.1173468.11677090109948628757.stgit@frogsfrogsfrogs>
In-Reply-To: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs>
References: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Introduce a new behavior for the cow fork repair code: if the debugging
knob is enabled, we'll pick a random subrange of each cow fork mapping
to mark as bad.  This will exercise the xrep_cow_replace_mapping more
thoroughly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/cow_repair.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index ca3405a26b641c..8507a1185b2b45 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -224,6 +224,31 @@ xrep_cow_mark_missing_staging_rmap(
 			xfs_gbno_to_fsb(cur->bc_group, rec_bno), rec_len);
 }
 
+#ifdef DEBUG
+/*
+ * Trim the start and end of the current mapping by up to 1/4 of the length
+ * and mark that as "bad" to test the cow fork repair mechanism.
+ */
+static inline int
+xrep_cow_debug_replacement(
+	struct xrep_cow		*xc)
+{
+	xfs_fsblock_t		fsbno = xc->irec.br_startblock;
+	xfs_extlen_t		len = xc->irec.br_blockcount;
+	uint32_t		trim;
+
+	/* get_random_u32_below requires a nonzero argument */
+	trim = len > 4 ? get_random_u32_below(len / 4) : 0;
+	len -= trim;
+
+	trim = len > 4 ? get_random_u32_below(len / 4) : 0;
+	fsbno += trim;
+	len -= trim;
+
+	return xrep_cow_mark_file_range(xc, fsbno, len);
+}
+#endif
+
 /*
  * Find any part of the CoW fork mapping that isn't a single-owner CoW staging
  * extent and mark the corresponding part of the file range in the bitmap.
@@ -293,8 +318,9 @@ xrep_cow_find_bad(
 	 * If userspace is forcing us to rebuild the CoW fork or someone turned
 	 * on the debugging knob, replace everything in the CoW fork.
 	 */
-	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
-	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
+	if (XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
+		error = xrep_cow_debug_replacement(xc);
+	else if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD)
 		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
 				xc->irec.br_blockcount);
 
@@ -375,8 +401,9 @@ xrep_cow_find_bad_rt(
 	 * turned on the debugging knob, replace everything in the
 	 * CoW fork and then scan for staging extents in the refcountbt.
 	 */
-	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
-	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
+	if (XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
+		error = xrep_cow_debug_replacement(xc);
+	else if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD)
 		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
 				xc->irec.br_blockcount);
 

