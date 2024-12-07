Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28AC4A24
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530588; cv=none; b=HH0gYyvtBL4iePsJaSVX32yTVVYJWqC+Ugh6av0obPyg0IjGY99u87h4JSYeyLcTYoaIgWO5SRXH6ab6dRz0xjrro0Da3PQCHs5eHp4oxGWqez6Ary8nQOA6iIAz+tMdJRkvoCHJL3Kq3IxC6LnRP9itcrtgY6hYDxtzCU8MGy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530588; c=relaxed/simple;
	bh=8M+fQHWxASbs+rsjPkqBKtD0cOQagWjYGXz3BgwyCcc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YBFdxp78CZYBCcMkEZN0pCNXFAPmwxtQ0MUSEIErnUgruEprUMg5l30vUk65eE2VXyH4dQz37OB2XeC1r2S/IsEii7ezw6q+tLVywwxLhMHSjnPJ7+/j/4c0z3WQyKOQCJoQHqTK8l+fnoj38IqyXzLpJbU3rKkMcUKFDZn40DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyJnuLjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyJnuLjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3AAC4CED1;
	Sat,  7 Dec 2024 00:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530586;
	bh=8M+fQHWxASbs+rsjPkqBKtD0cOQagWjYGXz3BgwyCcc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZyJnuLjXdJGwsbFljxs8MEcQ72jfyeJgyTRMKcX+ScLx8qI7r8K9CE15FVu16hX/x
	 Ojhm98HsYpggo31scZJPTTJg6r0pjZGVeXop7hfzWT88L9wL7zgvdzGfbWbgXASn3y
	 nlHuXmWcF7QNitAc2uYfkE0AeGyTVBR+ZrIoK3F3li6OnXmsKw81q4EWxF/IaQR8rC
	 CMUzMV179EHMCmQC8r5ScSgkqFjr8VPPtsW3QpxDRsrl4cIQvcDqfCXBXF8rNfliG9
	 an9lGmVKD/YHeroS9apNK3XhaX3fqzm5qu7jFDhXnoiPcvszxKNhfqTbJTbNeN/qvt
	 xumhJLnVN7Nsg==
Date: Fri, 06 Dec 2024 16:16:25 -0800
Subject: [PATCH 44/50] xfs_scrub: scrub realtime allocation group metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752618.126362.9145973725226791141.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Scan realtime group metadata as part of phase 2, just like we do for AG
metadata.  For pre-rtgroup filesystems, pretend that this is a "rtgroup
0" scrub request because the kernel expects that.  Replace the old
cond_wait code with a scrub barrier because they're equivalent for two
items that cannot be scrubbed in parallel.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/scrub.c |    4 +-
 scrub/phase2.c  |  124 ++++++++++++++++++++++++++++++++++++++-----------------
 scrub/scrub.c   |    1 
 scrub/scrub.h   |    9 ++++
 4 files changed, 98 insertions(+), 40 deletions(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 66000f1ed66be4..d40364d35ce0b4 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -107,12 +107,12 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_RTBITMAP] = {
 		.name	= "rtbitmap",
 		.descr	= "realtime bitmap",
-		.group	= XFROG_SCRUB_GROUP_FS,
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {
 		.name	= "rtsummary",
 		.descr	= "realtime summary",
-		.group	= XFROG_SCRUB_GROUP_FS,
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
 	[XFS_SCRUB_TYPE_UQUOTA] = {
 		.name	= "usrquota",
diff --git a/scrub/phase2.c b/scrub/phase2.c
index c24d137358c74d..c7828c332e7c3a 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -21,12 +21,10 @@
 
 struct scan_ctl {
 	/*
-	 * Control mechanism to signal that the rt bitmap file scan is done and
-	 * wake up any waiters.
+	 * Control mechanism to signal that each group's scan of the rt bitmap
+	 * file scan is done and wake up any waiters.
 	 */
-	pthread_cond_t		rbm_wait;
-	pthread_mutex_t		rbm_waitlock;
-	bool			rbm_done;
+	unsigned int		rbm_group_count;
 
 	bool			aborted;
 };
@@ -202,7 +200,7 @@ scan_fs_metadata(
 	int			ret;
 
 	if (sctl->aborted)
-		goto out;
+		return;
 
 	/*
 	 * Try to check all of the metadata files that we just scheduled.  If
@@ -215,14 +213,14 @@ scan_fs_metadata(
 	ret = scrub_item_check(ctx, &sri);
 	if (ret) {
 		sctl->aborted = true;
-		goto out;
+		return;
 	}
 
 	ret = repair_and_scrub_loop(ctx, &sri, xfrog_scrubbers[type].descr,
 			&defer_repairs);
 	if (ret) {
 		sctl->aborted = true;
-		goto out;
+		return;
 	}
 	if (defer_repairs)
 		goto defer;
@@ -235,15 +233,60 @@ scan_fs_metadata(
 	ret = defer_fs_repair(ctx, &sri);
 	if (ret) {
 		sctl->aborted = true;
-		goto out;
+		return;
 	}
+}
 
-out:
-	if (type == XFS_SCRUB_TYPE_RTBITMAP) {
-		pthread_mutex_lock(&sctl->rbm_waitlock);
-		sctl->rbm_done = true;
-		pthread_cond_broadcast(&sctl->rbm_wait);
-		pthread_mutex_unlock(&sctl->rbm_waitlock);
+/*
+ * Scrub each rt group's metadata.  For pre-rtgroup filesystems, we ask to
+ * scrub "rtgroup 0" because that's how the kernel ioctl works.
+ */
+static void
+scan_rtgroup_metadata(
+	struct workqueue	*wq,
+	xfs_agnumber_t		rgno,
+	void			*arg)
+{
+	struct scrub_item	sri;
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	struct scan_ctl		*sctl = arg;
+	char			descr[DESCR_BUFSZ];
+	bool			defer_repairs;
+	int			ret;
+
+	if (sctl->aborted)
+		return;
+
+	scrub_item_init_rtgroup(&sri, rgno);
+	if (ctx->mnt.fsgeom.rgcount == 0)
+		snprintf(descr, DESCR_BUFSZ, _("realtime"));
+	else
+		snprintf(descr, DESCR_BUFSZ, _("rtgroup %u"), rgno);
+
+	/*
+	 * Try to check all of the rtgroup metadata items that we just
+	 * scheduled.  If we return with some types still needing a check, try
+	 * repairing any damaged metadata that we've found so far, and try
+	 * again.  Abort if we stop making forward progress.
+	 */
+	scrub_item_schedule_group(&sri, XFROG_SCRUB_GROUP_RTGROUP);
+	ret = scrub_item_check(ctx, &sri);
+	if (ret) {
+		sctl->aborted = true;
+		return;
+	}
+
+	ret = repair_and_scrub_loop(ctx, &sri, descr, &defer_repairs);
+	if (ret) {
+		sctl->aborted = true;
+		return;
+	}
+
+	/* Everything else gets fixed during phase 4. */
+	ret = defer_fs_repair(ctx, &sri);
+	if (ret) {
+		sctl->aborted = true;
+		return;
 	}
 }
 
@@ -255,17 +298,14 @@ phase2_func(
 	struct workqueue	wq;
 	struct scan_ctl		sctl = {
 		.aborted	= false,
-		.rbm_done	= false,
 	};
 	struct scrub_item	sri;
 	const struct xfrog_scrub_descr *sc = xfrog_scrubbers;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	unsigned int		type;
 	int			ret, ret2;
 
-	pthread_mutex_init(&sctl.rbm_waitlock, NULL);
-	pthread_cond_init(&sctl.rbm_wait, NULL);
-
 	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
@@ -311,8 +351,6 @@ phase2_func(
 	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
 		if (sc->group != XFROG_SCRUB_GROUP_FS)
 			continue;
-		if (type == XFS_SCRUB_TYPE_RTSUM)
-			continue;
 
 		ret = -workqueue_add(&wq, scan_fs_metadata, type, &sctl);
 		if (ret) {
@@ -325,24 +363,37 @@ phase2_func(
 	if (sctl.aborted)
 		goto out_wq;
 
-	/*
-	 * Wait for the rt bitmap to finish scanning, then scan the rt summary
-	 * since the summary can be regenerated completely from the bitmap.
-	 */
-	pthread_mutex_lock(&sctl.rbm_waitlock);
-	while (!sctl.rbm_done)
-		pthread_cond_wait(&sctl.rbm_wait, &sctl.rbm_waitlock);
-	pthread_mutex_unlock(&sctl.rbm_waitlock);
+	if (ctx->mnt.fsgeom.rgcount == 0) {
+		/*
+		 * When rtgroups were added, the bitmap and summary files
+		 * became per-rtgroup metadata so the scrub interface for the
+		 * two started to accept sm_agno.  For pre-rtgroups
+		 * filesystems, we still accept sm_agno==0, so invoke scrub in
+		 * this manner.
+		 */
+		ret = -workqueue_add(&wq, scan_rtgroup_metadata, 0, &sctl);
+		if (ret) {
+			str_liberror(ctx, ret,
+					_("queueing realtime scrub work"));
+			goto out_wq;
+		}
+	}
+
+	/* Scan each rtgroup in parallel. */
+	for (rgno = 0;
+	     rgno < ctx->mnt.fsgeom.rgcount && !sctl.aborted;
+	     rgno++) {
+		ret = -workqueue_add(&wq, scan_rtgroup_metadata, rgno, &sctl);
+		if (ret) {
+			str_liberror(ctx, ret,
+					_("queueing rtgroup scrub work"));
+			goto out_wq;
+		}
+	}
 
 	if (sctl.aborted)
 		goto out_wq;
 
-	ret = -workqueue_add(&wq, scan_fs_metadata, XFS_SCRUB_TYPE_RTSUM, &sctl);
-	if (ret) {
-		str_liberror(ctx, ret, _("queueing rtsummary scrub work"));
-		goto out_wq;
-	}
-
 out_wq:
 	ret2 = -workqueue_terminate(&wq);
 	if (ret2) {
@@ -352,9 +403,6 @@ phase2_func(
 	}
 	workqueue_destroy(&wq);
 out_wait:
-	pthread_cond_destroy(&sctl.rbm_wait);
-	pthread_mutex_destroy(&sctl.rbm_waitlock);
-
 	if (!ret && sctl.aborted)
 		ret = ECANCELED;
 	return ret;
diff --git a/scrub/scrub.c b/scrub/scrub.c
index a2fd8d77d82be0..de687af687d32d 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -50,6 +50,7 @@ static const unsigned int scrub_deps[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= DEP(XFS_SCRUB_TYPE_UQUOTA) |
 					  DEP(XFS_SCRUB_TYPE_GQUOTA) |
 					  DEP(XFS_SCRUB_TYPE_PQUOTA),
+	[XFS_SCRUB_TYPE_RTSUM]		= DEP(XFS_SCRUB_TYPE_RTBITMAP),
 };
 #undef DEP
 
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 3bb3ea1d07bf40..bb94a11dcfce71 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -90,6 +90,15 @@ scrub_item_init_ag(struct scrub_item *sri, xfs_agnumber_t agno)
 	sri->sri_gen = -1U;
 }
 
+static inline void
+scrub_item_init_rtgroup(struct scrub_item *sri, xfs_rgnumber_t rgno)
+{
+	memset(sri, 0, sizeof(*sri));
+	sri->sri_agno = rgno;
+	sri->sri_ino = -1ULL;
+	sri->sri_gen = -1U;
+}
+
 static inline void
 scrub_item_init_fs(struct scrub_item *sri)
 {

