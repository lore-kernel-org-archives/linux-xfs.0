Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A08C38B
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PCMifAAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2A2C433C7;
	Mon,  1 Jan 2024 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068285;
	bh=RV8k+ZNnm4zWeQrBxr+3hToN2EeqI0S926hEUq/xdw0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PCMifAAkI9niHOGZ/d1HYJJInKXT0qqMcZL2+tBgYiGcjCvPy74OOG4ncoJVKO8Iv
	 ts1epxRdIuyf77m15r1HKVKXSZ5ocOzqeBrU70lMALiALd0i/TfDlnTAJjMtZFsoo8
	 DDujcZQ0qr/v7SqI3QmCxlFoc+pmPzHP+HGv3+AX9EaBKBF2BLY0fAJynS37b7Z52P
	 tiFIyzWDa7DG3OjJZrN66DabWVssZOiRQNPQvafq5l2x/MA9aaJeGCyC1Du73XtwRO
	 6bu//oxD4nJXWD0f1apZSZa4OhucwgQIopx8tdXARBGWBWs8BBpECO4nImKsmmJXYL
	 DOqNHx1RRaW8w==
Date: Sun, 31 Dec 2023 16:18:04 +9900
Subject: [PATCH 29/47] xfs_scrub: check rtrmapbt metadata directory
 connections
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015699.1815505.15975120265587182090.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Run the rt rmap btree metapath scrubber during phase 5 to ensure that
it's still connected to the metadir tree after we've pruned any bad
links.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase5.c |   24 ++++++++++++++++++++++--
 scrub/scrub.h  |    4 +++-
 2 files changed, 25 insertions(+), 3 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 3b8daf39ae6..6fd3c698270 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -743,6 +743,7 @@ static int
 queue_metapath_scan(
 	struct workqueue	*wq,
 	bool			*abortedp,
+	xfs_rgnumber_t		rgno,
 	uint64_t		type)
 {
 	struct fs_scan_item	*item;
@@ -755,7 +756,7 @@ queue_metapath_scan(
 		str_liberror(ctx, ret, _("setting up metapath scan"));
 		return ret;
 	}
-	scrub_item_init_metapath(&item->sri, type);
+	scrub_item_init_metapath(&item->sri, rgno, type);
 	scrub_item_schedule(&item->sri, XFS_SCRUB_TYPE_METAPATH);
 	item->abortedp = abortedp;
 
@@ -778,6 +779,7 @@ run_kernel_metadir_path_scrubbers(
 	const struct xfrog_scrub_descr	*sc;
 	uint64_t		type;
 	unsigned int		nr_threads = scrub_nproc_workqueue(ctx);
+	xfs_rgnumber_t		rgno;
 	bool			aborted = false;
 	int			ret, ret2;
 
@@ -797,7 +799,7 @@ run_kernel_metadir_path_scrubbers(
 		if (sc->group != XFROG_SCRUB_GROUP_FS)
 			continue;
 
-		ret = queue_metapath_scan(&wq, &aborted, type);
+		ret = queue_metapath_scan(&wq, &aborted, 0, type);
 		if (ret) {
 			str_liberror(ctx, ret,
  _("queueing metapath scrub work"));
@@ -805,6 +807,24 @@ run_kernel_metadir_path_scrubbers(
 		}
 	}
 
+	/* Scan all rtgroup metadata files */
+	for (rgno = 0;
+	     rgno < ctx->mnt.fsgeom.rgcount && !aborted;
+	     rgno++) {
+		for (type = 0; type < XFS_SCRUB_METAPATH_NR; type++) {
+			sc = &xfrog_metapaths[type];
+			if (sc->group != XFROG_SCRUB_GROUP_RTGROUP)
+				continue;
+
+			ret = queue_metapath_scan(&wq, &aborted, rgno, type);
+			if (ret) {
+				str_liberror(ctx, ret,
+  _("queueing metapath scrub work"));
+				goto wait;
+			}
+		}
+	}
+
 wait:
 	ret2 = -workqueue_terminate(&wq);
 	if (ret2) {
diff --git a/scrub/scrub.h b/scrub/scrub.h
index bb94a11dcfc..24b5ad629c5 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -118,9 +118,11 @@ scrub_item_init_file(struct scrub_item *sri, const struct xfs_bulkstat *bstat)
 }
 
 static inline void
-scrub_item_init_metapath(struct scrub_item *sri, uint64_t metapath)
+scrub_item_init_metapath(struct scrub_item *sri, xfs_rgnumber_t rgno,
+		uint64_t metapath)
 {
 	memset(sri, 0, sizeof(*sri));
+	sri->sri_agno = rgno;
 	sri->sri_ino = metapath;
 }
 

