Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261BE8BE8
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610453; cv=none; b=s1zc0K2osYe2IvD2R2u8CTiLljqGPZV+s7qMrp909/r4ka0ICGSTMwIXV7fbj8ssmP91HkzxLwaBjd4XtxsJJjOTZVLXbLYMlzxSlz5G2FoUE0toXHKcg+xR1EBc5EkahD9RgOM9yknQHCPw9yVgs8WDdNLBpFbuApojpYBHEeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610453; c=relaxed/simple;
	bh=UGirZHk/K5ZV+hZri3HA7RAha+ZUQkPl4haCW73kQ1M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nz6kQ3uw5+/SEGJiXKUHkLRlpEIrEyCqDcSHZHtgIWXqjlHDcy+IPqBCjXLMRWFrt7avNLdz4+7+dmDoY8TAimxA4Z9V06czEB5KXVPnzsMalA4ThQT52n8R+Hswk/iBVQZ+7AKB4+WPO7xveKCSgdIKWbcDzGRaS+iYOyQnh38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLdEtTKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLdEtTKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF0EC4CEC5;
	Fri, 11 Oct 2024 01:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610452;
	bh=UGirZHk/K5ZV+hZri3HA7RAha+ZUQkPl4haCW73kQ1M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oLdEtTKxrZtTWFMGEtJNUkQoHoQ38ce0k3CHmJD3LLv5MD497bMpGt4uGO2m+ZYnS
	 ANXH7TfzbY6ILFPFQtJ+YGv39yUF0QtEyYWISarAWPHGyKV3yciTJ3MFrrXujDDtdA
	 0rMSzqC0lr94LgTbEzifBnOyqUZsnDaE8p8zpIX02Ci9v86W4cqOiy9bboYhXnErhP
	 2lvnf/byE2e1qIm9mDMRgafKn5HEnAE3Q5qWCYvTwAVDI2Hg96WSCFnP3Rcb130sWT
	 Y6GK2hz9BIdDg3cz2vi5ALSG7UZhu4AF3Z1sxVNmkuL8yB9Lljl2UhoH1YoLcyYKUn
	 DvQNiLcO3JRPA==
Date: Thu, 10 Oct 2024 18:34:12 -0700
Subject: [PATCH 37/43] xfs_scrub: scrub realtime allocation group metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655933.4184637.13511720071459479813.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

Scan realtime group metadata as part of phase 2, just like we do for AG
metadata.  For pre-rtgroup filesystems, pretend that this is a "rtgroup
0" scrub request because the kernel expects that.  Replace the old
cond_wait code with a scrub barrier because they're equivalent for two
items that cannot be scrubbed in parallel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

