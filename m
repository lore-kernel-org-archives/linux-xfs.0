Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1B2277007
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 06:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009066; cv=none; b=Xw0Ftyj+WHf0cR8PybBtkyrj40sIHAav5DO0NJqd78drslFemMdBHhIb2yWe/4AK/BPYwAhNF7TYOqajJEtMtTXrZsrwVF0kLqSfu6eyMYsKnbzaRVD5D27e9+GPLtDkXzk9IRZAygdemnCH70pAsXr18GlmFsTOUV+ImJ5krss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009066; c=relaxed/simple;
	bh=wg16reWH3RaJBWw2KcKt7b9DQtRlp1KPSg2vpuZSEg4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CzbQwEEZFXE3fcEqVbeKSEpZxzsOL/FCxobKtBtgvaaS2FrI6vIrtYutLTiFSQkfQcMAdTFTPs0UEMewNlj7OTd5qWJDbBEEcjE7W11H31c4aF/WU15ckRcOIiL10o+WKPzdsoHn9VPGID1ga+CWMsQVIiTjRvrSw0+PjuW8AwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MaNMMx5H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MaNMMx5H"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 73D5B1F000E9;
	Tue, 14 Jul 2026 06:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784009064;
	bh=ZcZeQontZ72njxL/Ta5JiQlhNqQIwMrEwyFUe/qFPh8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=MaNMMx5Ho6WLlvtk3obGTpWuJvWZS2HdYrq7J9JgLBpuQaeItNasPVFMJt8WIoRiH
	 XGG66T5zIWF7Vsqu6tn68RuMAvBYb5p8I5hw5EhX1PBD5jZLNWjvdJgqeyEn/h8Ahi
	 8w7jGcsfqtigS95Cg3FSe0ClcsPzBw+1tdTpFOXrNbhyjY7nnnF6S7AZMjWij2Ezkm
	 JO0DoOzL28o09F52inPOyVaQd9vMcRQw+lFmg1/QSK5iK7KVmeci81z/YJbmJXPlKD
	 wvXkmjVsCWf3iEsBzybaWG9leq5fQ0hP6fdA6iRiTg1/888PlqBhy0ljx4JIWEi/tY
	 UD1QZIwmryXnA==
Date: Mon, 13 Jul 2026 23:04:24 -0700
Subject: [PATCH 2/8] xfs: make cow repair somewhat flaky when debugging knob
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <178400716411.267810.15891272511669595385.stgit@frogsfrogsfrogs>
In-Reply-To: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
References: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/cow_repair.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index ca3405a26b641c..511a761dca9fe3 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -224,6 +224,29 @@ xrep_cow_mark_missing_staging_rmap(
 			xfs_gbno_to_fsb(cur->bc_group, rec_bno), rec_len);
 }
 
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
+
 /*
  * Find any part of the CoW fork mapping that isn't a single-owner CoW staging
  * extent and mark the corresponding part of the file range in the bitmap.
@@ -293,8 +316,9 @@ xrep_cow_find_bad(
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
 
@@ -375,8 +399,9 @@ xrep_cow_find_bad_rt(
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
 

