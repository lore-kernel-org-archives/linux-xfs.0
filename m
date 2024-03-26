Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3471512838F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 04:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425601; cv=none; b=AmsyVBS2mDAU+V8I0O69WtPyLiMg9JLhWiaqjEI1E/py43EhtInfIdnnM8Zmrlt2ee50oQScqCEs+unwdpJakrSoJLFQZ3WpFi1F6vIRvxCBR/s4WtuXmBvSAQsu9vPUx9XbBw8s1zxpSeA5VhDfL7HANl0mrV+JJz22icYUMlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425601; c=relaxed/simple;
	bh=1epDdQmniRTWF0LfFhNQb995wX3vz1GdiDZA/xjkCOk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l85PnryXTXrVTCbvsljmUIO4xwHm6qJWRMmGU3u8I7Sl4vBmcGtygwZDOaFM/DSu01NvayFJ/7RaeuM/VLfTsdMF9XMDKGWOmdgc5ll9nL9OmeaO/fdnfUyJsU7Nk7pORNlIf/ui+8632DgNP2j2nC4Ss3k5OlzVMn93Lq6OaSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrb+Pk3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrb+Pk3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1311FC433C7;
	Tue, 26 Mar 2024 04:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425601;
	bh=1epDdQmniRTWF0LfFhNQb995wX3vz1GdiDZA/xjkCOk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lrb+Pk3yUqMkZsgSHwLwvYJ1ItDP0JrhahPMsM6zZayxLEV5m3YDoLau3hXuAOhuV
	 AHMn2KO4Y6W0bA8VGg4/5PxViVy0byMt6+Qee3EMKzG3gt8jnrIUUHsLcY1suxIQ3b
	 TZ4VeND/r8fBi47s7hoF3v+JMvwvEY2uMRAgHUMpMZYV4sPENVgIn36pXbPV/Lub9U
	 OOsk44AalL5YPqyQ152nyzfEZ19+wcvvRPn++x6zOC3BTjl6Uq2yZjyIkjmJoaLqIh
	 XiY7EhwDMKqUfJsaoot3rtxAwZMlRRNTy66kBpydMtka4axb2shikWQ0KJHmgZ98UO
	 gL7C0GVCTObxA==
Date: Mon, 25 Mar 2024 21:00:00 -0700
Subject: [PATCH 4/5] xfs_scrub: use multiple threads to run in-kernel metadata
 scrubs that scan inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142134366.2218196.11088974993404154240.stgit@frogsfrogsfrogs>
In-Reply-To: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
References: <171142134302.2218196.4456442187285422971.stgit@frogsfrogsfrogs>
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

Instead of running the inode link count and quotacheck scanners in
serial, run them in parallel, with a slight delay to stagger the work to
reduce inode resource contention.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase5.c |  150 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 scrub/scrub.c  |   18 +++----
 scrub/scrub.h  |    1 
 3 files changed, 145 insertions(+), 24 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 0a91e4f0640b..b4c635d3452b 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -384,26 +384,146 @@ check_fs_label(
 	return error;
 }
 
-/* Check directory connectivity. */
-int
-phase5_func(
-	struct scrub_ctx	*ctx)
-{
+typedef int (*fs_scan_item_fn)(struct scrub_ctx *, struct action_list *);
+
+struct fs_scan_item {
 	struct action_list	alist;
-	bool			aborted = false;
+	bool			*abortedp;
+	fs_scan_item_fn		scrub_fn;
+};
+
+/* Run one full-fs scan scrubber in this thread. */
+static void
+fs_scan_worker(
+	struct workqueue	*wq,
+	xfs_agnumber_t		nr,
+	void			*arg)
+{
+	struct timespec		tv;
+	struct fs_scan_item	*item = arg;
+	struct scrub_ctx	*ctx = wq->wq_ctx;
 	int			ret;
 
 	/*
-	 * Check and fix anything that requires a full inode scan.  We do this
-	 * after we've checked all inodes and repaired anything that could get
-	 * in the way of a scan.
+	 * Delay each successive fs scan by a second so that the threads are
+	 * less likely to contend on the inobt and inode buffers.
 	 */
-	action_list_init(&alist);
-	ret = scrub_iscan_metadata(ctx, &alist);
-	if (ret)
-		return ret;
-	ret = action_list_process(ctx, ctx->mnt.fd, &alist,
+	if (nr) {
+		tv.tv_sec = nr;
+		tv.tv_nsec = 0;
+		nanosleep(&tv, NULL);
+	}
+
+	ret = item->scrub_fn(ctx, &item->alist);
+	if (ret) {
+		str_liberror(ctx, ret, _("checking fs scan metadata"));
+		*item->abortedp = true;
+		goto out;
+	}
+
+	ret = action_list_process(ctx, ctx->mnt.fd, &item->alist,
 			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
+	if (ret) {
+		str_liberror(ctx, ret, _("repairing fs scan metadata"));
+		*item->abortedp = true;
+		goto out;
+	}
+
+out:
+	free(item);
+	return;
+}
+
+/* Queue one full-fs scan scrubber. */
+static int
+queue_fs_scan(
+	struct workqueue	*wq,
+	bool			*abortedp,
+	xfs_agnumber_t		nr,
+	fs_scan_item_fn		scrub_fn)
+{
+	struct fs_scan_item	*item;
+	struct scrub_ctx	*ctx = wq->wq_ctx;
+	int			ret;
+
+	item = malloc(sizeof(struct fs_scan_item));
+	if (!item) {
+		ret = ENOMEM;
+		str_liberror(ctx, ret, _("setting up fs scan"));
+		return ret;
+	}
+	action_list_init(&item->alist);
+	item->scrub_fn = scrub_fn;
+	item->abortedp = abortedp;
+
+	ret = -workqueue_add(wq, fs_scan_worker, nr, item);
+	if (ret)
+		str_liberror(ctx, ret, _("queuing fs scan work"));
+
+	return ret;
+}
+
+/* Run multiple full-fs scan scrubbers at the same time. */
+static int
+run_kernel_fs_scan_scrubbers(
+	struct scrub_ctx	*ctx)
+{
+	struct workqueue	wq_fs_scan;
+	unsigned int		nr_threads = scrub_nproc_workqueue(ctx);
+	xfs_agnumber_t		nr = 0;
+	bool			aborted = false;
+	int			ret, ret2;
+
+	ret = -workqueue_create(&wq_fs_scan, (struct xfs_mount *)ctx,
+			nr_threads);
+	if (ret) {
+		str_liberror(ctx, ret, _("setting up fs scan workqueue"));
+		return ret;
+	}
+
+	/*
+	 * The nlinks scanner is much faster than quotacheck because it only
+	 * walks directories, so we start it first.
+	 */
+	ret = queue_fs_scan(&wq_fs_scan, &aborted, nr, scrub_nlinks);
+	if (ret)
+		goto wait;
+
+	if (nr_threads > 1)
+		nr++;
+
+	ret = queue_fs_scan(&wq_fs_scan, &aborted, nr, scrub_quotacheck);
+	if (ret)
+		goto wait;
+
+wait:
+	ret2 = -workqueue_terminate(&wq_fs_scan);
+	if (ret2) {
+		str_liberror(ctx, ret2, _("joining fs scan workqueue"));
+		if (!ret)
+			ret = ret2;
+	}
+	if (aborted && !ret)
+		ret = ECANCELED;
+
+	workqueue_destroy(&wq_fs_scan);
+	return ret;
+}
+
+/* Check directory connectivity. */
+int
+phase5_func(
+	struct scrub_ctx	*ctx)
+{
+	bool			aborted = false;
+	int			ret;
+
+	/*
+	 * Check and fix anything that requires a full filesystem scan.  We do
+	 * this after we've checked all inodes and repaired anything that could
+	 * get in the way of a scan.
+	 */
+	ret = run_kernel_fs_scan_scrubbers(ctx);
 	if (ret)
 		return ret;
 
@@ -436,7 +556,7 @@ phase5_estimate(
 	int			*rshift)
 {
 	*items = scrub_estimate_iscan_work(ctx);
-	*nr_threads = scrub_nproc(ctx);
+	*nr_threads = scrub_nproc(ctx) * 2;
 	*rshift = 0;
 	return 0;
 }
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 436ccb0ca8c3..cf056779526e 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -417,15 +417,6 @@ scrub_summary_metadata(
 	return scrub_group(ctx, XFROG_SCRUB_GROUP_SUMMARY, 0, alist);
 }
 
-/* Scrub all metadata requiring a full inode scan. */
-int
-scrub_iscan_metadata(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
-{
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_ISCAN, 0, alist);
-}
-
 /* Scrub /only/ the superblock summary counters. */
 int
 scrub_fs_counters(
@@ -444,6 +435,15 @@ scrub_quotacheck(
 	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_QUOTACHECK, 0, alist);
 }
 
+/* Scrub /only/ the file link counters. */
+int
+scrub_nlinks(
+	struct scrub_ctx		*ctx,
+	struct action_list		*alist)
+{
+	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_NLINKS, 0, alist);
+}
+
 /* How many items do we have to check? */
 unsigned int
 scrub_estimate_ag_work(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 927f86de9ec2..5e3f40bf1f41 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -28,6 +28,7 @@ int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_nlinks(struct scrub_ctx *ctx, struct action_list *alist);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);

