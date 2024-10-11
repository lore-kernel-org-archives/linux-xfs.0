Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184CB8F5E
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609485; cv=none; b=mpt5e3Z/vfhB6AhxpMFEKHIxXslsdhLwyw6zEc2n9Z9NzDE7rCfwNL48xkT2BslsPpVcPpzhTG7Ad1uy9JffN3n3cGsV5pp7NMM0CEISNd6h0IQNEMvxnwA/xhB5XqNYhNmQHtf+Occ0pUZFdbN6kBP5X7NOVH9uEId68DEGU3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609485; c=relaxed/simple;
	bh=5N63vBi+X0vUni0Bb9k62clEbrh/DNIpyUkKs64pWoA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dAbosv/koXhwo6azLr3SbHewbUMeOUzV5YMMj7dheyyvbhc1W42T+umfex+WCUcJlO3mfs4tsE2Jv3sDLbdjnvjeFaL8yfMe/8o7FLwakC7o+gQslmvLTryE6LaZx7jIrvcIAl7eGhp6hxwM7BYY37T33fVeJihatCfrl1Io4vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZgoGUbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZgoGUbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ECAC4CEC5;
	Fri, 11 Oct 2024 01:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609485;
	bh=5N63vBi+X0vUni0Bb9k62clEbrh/DNIpyUkKs64pWoA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EZgoGUbtlPxKMCZjLRD9eAq+xuA6grVFq9znrhS898aJJdccu+8gbQUv0VyKdFJMP
	 G+k5phqfJ0G70lK4Vnz1WJi3tYDBzLNPIKOXROTxjP/j/wuNwHOFunRcOeRGwRhOZo
	 GE++WwF5uA2lPvMWTVJ1CT7Mdol3BGoS53Op7ibdgBsLCVviRIS8kRsmTrTQ+DweMi
	 J9CpW/QelJGCfHCptp5N6lIYpTSZXXO8YJO4OGMMt6/VcM3hRTdlhyMaNKtBEDyMaL
	 5WCXKvdyIvzk4LW1/2Hmqc9HMpUsfy1L6OcBvuUdjjAeBHED+3OgXKRWRsrbDVnpgE
	 elA1+zP4CHiRg==
Date: Thu, 10 Oct 2024 18:18:04 -0700
Subject: [PATCH 15/38] xfs_scrub: re-run metafile scrubbers during phase 5
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654206.4183231.3578172834884661604.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

For metadata files on a metadir filesystem, re-run the scrubbers during
phase 5 to ensure that the metadata files are still connected.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase5.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 scrub/scrub.h  |    7 ++++
 2 files changed, 103 insertions(+), 1 deletion(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 69b1cae5c5e2c0..4d0a76a529b55d 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -745,6 +745,87 @@ run_kernel_fs_scan_scrubbers(
 	return ret;
 }
 
+/* Queue one metapath scrubber. */
+static int
+queue_metapath_scan(
+	struct workqueue	*wq,
+	bool			*abortedp,
+	uint64_t		type)
+{
+	struct fs_scan_item	*item;
+	struct scrub_ctx	*ctx = wq->wq_ctx;
+	int			ret;
+
+	item = malloc(sizeof(struct fs_scan_item));
+	if (!item) {
+		ret = ENOMEM;
+		str_liberror(ctx, ret, _("setting up metapath scan"));
+		return ret;
+	}
+	scrub_item_init_metapath(&item->sri, type);
+	scrub_item_schedule(&item->sri, XFS_SCRUB_TYPE_METAPATH);
+	item->abortedp = abortedp;
+
+	ret = -workqueue_add(wq, fs_scan_worker, 0, item);
+	if (ret)
+		str_liberror(ctx, ret, _("queuing metapath scan work"));
+
+	return ret;
+}
+
+/*
+ * Scrub metadata directory file paths to ensure that fs metadata are still
+ * connected where the fs needs to find them.
+ */
+static int
+run_kernel_metadir_path_scrubbers(
+	struct scrub_ctx	*ctx)
+{
+	struct workqueue	wq;
+	const struct xfrog_scrub_descr	*sc;
+	uint64_t		type;
+	unsigned int		nr_threads = scrub_nproc_workqueue(ctx);
+	bool			aborted = false;
+	int			ret, ret2;
+
+	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx, nr_threads);
+	if (ret) {
+		str_liberror(ctx, ret, _("setting up metapath scan workqueue"));
+		return ret;
+	}
+
+	/*
+	 * Scan all the metadata files in parallel if metadata directories
+	 * are enabled, because the phase 3 scrubbers might have taken out
+	 * parts of the metadir tree.
+	 */
+	for (type = 0; type < XFS_SCRUB_METAPATH_NR; type++) {
+		sc = &xfrog_metapaths[type];
+		if (sc->group != XFROG_SCRUB_GROUP_FS)
+			continue;
+
+		ret = queue_metapath_scan(&wq, &aborted, type);
+		if (ret) {
+			str_liberror(ctx, ret,
+ _("queueing metapath scrub work"));
+			goto wait;
+		}
+	}
+
+wait:
+	ret2 = -workqueue_terminate(&wq);
+	if (ret2) {
+		str_liberror(ctx, ret2, _("joining metapath scan workqueue"));
+		if (!ret)
+			ret = ret2;
+	}
+	if (aborted && !ret)
+		ret = ECANCELED;
+
+	workqueue_destroy(&wq);
+	return ret;
+}
+
 /* Check directory connectivity. */
 int
 phase5_func(
@@ -753,6 +834,16 @@ phase5_func(
 	struct ncheck_state	ncs = { .ctx = ctx };
 	int			ret;
 
+	/*
+	 * Make sure metadata files are still connected to the metadata
+	 * directory tree now that phase 3 pruned all corrupt directory tree
+	 * links.
+	 */
+	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_METADIR) {
+		ret = run_kernel_metadir_path_scrubbers(ctx);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * Check and fix anything that requires a full filesystem scan.  We do
@@ -805,8 +896,12 @@ phase5_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
+	unsigned int		scans = 2;
+
 	*items = scrub_estimate_iscan_work(ctx);
-	*nr_threads = scrub_nproc(ctx) * 2;
+	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_METADIR)
+		scans++;
+	*nr_threads = scrub_nproc(ctx) * scans;
 	*rshift = 0;
 	return 0;
 }
diff --git a/scrub/scrub.h b/scrub/scrub.h
index c3eed1b261d511..3bb3ea1d07bf40 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -108,6 +108,13 @@ scrub_item_init_file(struct scrub_item *sri, const struct xfs_bulkstat *bstat)
 	sri->sri_gen = bstat->bs_gen;
 }
 
+static inline void
+scrub_item_init_metapath(struct scrub_item *sri, uint64_t metapath)
+{
+	memset(sri, 0, sizeof(*sri));
+	sri->sri_ino = metapath;
+}
+
 void scrub_item_dump(struct scrub_item *sri, unsigned int group_mask,
 		const char *tag);
 

