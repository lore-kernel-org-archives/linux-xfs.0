Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29E7D527
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZI/WTttc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B86C433C7;
	Sun, 31 Dec 2023 23:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065923;
	bh=uhkrAwSn9YDN3LU2hBpf8JlND93rsrsYOoRgNIi0zkw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZI/WTttcmTakfW51xB84mdCOa5F4xlkHwc8UO2OhAjNgEbxeklG9xwRppBo4bSSrK
	 NlI6XQIxM2RN8CkUfyZfLTzG+ODzZTHFXyyPOJ8iQve7R66u+c2H/o8kJE3Hll1Bao
	 FV8vL6k5bVrI6OjyfluCFUGFl//fDyBrB1L7o5Og3oiTDqRyil3M1N03Tl03KmQUnp
	 xSLOo9elnlhrxZkHTs8DNv6b+eLTe+SQ9Ozce8hT33UHIVB2FLhzVsIfLJiEOo6G55
	 f/lUCPlt1RXHrsnZdqd6TG00S+gOe01NCn6iqcqPEUSbZuvLmcq/ZEFSZgttSc00I4
	 VSjFtMGvWa0dg==
Date: Sun, 31 Dec 2023 15:38:42 -0800
Subject: [PATCH 35/58] xfs_scrub: re-run metafile scrubbers during phase 5
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010414.1809361.2743640004913728693.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
index b922f53398e..3b8daf39ae6 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -738,6 +738,87 @@ run_kernel_fs_scan_scrubbers(
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
@@ -746,6 +827,16 @@ phase5_func(
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
@@ -798,8 +889,12 @@ phase5_estimate(
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
index c3eed1b261d..3bb3ea1d07b 100644
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
 

