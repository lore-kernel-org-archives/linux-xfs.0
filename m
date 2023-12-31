Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D70C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BqxBf0Z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D02C433C7;
	Sun, 31 Dec 2023 23:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067173;
	bh=XpWX8tbVkQ7O/uZslUkkSD2j3g6XuD/D1QaUSjUprUw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BqxBf0Z3NpJ6h7tq8t1AiXH+gJnHelG2ETibgN6ylJgMsxMnQdeMBcicXdfSi9Bae
	 VP7u2F4mSE1lYmiiU5+50I3JQLDSHLqGGCqfLOovRxt6P38xoszaLeltdgEU1hJj6j
	 VEuHxXJQZroTCon3H+EHrceHjaV23pG3iiMGbH1kYpI5WsyKzs6hqP91td5yIICp2k
	 mW42nA/ucv81zrlUuHn3qHIp94/Tol3SiufwbrxmhbQPRo03mIUniu3PHLOq3CUGTx
	 jGQyDu55rBonW7CeNWBHEIyEtCGH0Z7fK+L9mfSbxUwV1yu8i4dCpnOen73dbwjmxM
	 mTSsXAMwMhUXw==
Date: Sun, 31 Dec 2023 15:59:33 -0800
Subject: [PATCH 46/52] xfs_scrub: scrub realtime allocation group metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012778.1811243.7471310653919922170.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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
metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 scrub/scrub.h  |    9 +++++
 2 files changed, 107 insertions(+), 2 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index c24d137358c..a3ada334e86 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -28,6 +28,14 @@ struct scan_ctl {
 	pthread_mutex_t		rbm_waitlock;
 	bool			rbm_done;
 
+	/*
+	 * Control mechanism to signal that each group's scan of the rt bitmap
+	 * file scan is done and wake up any waiters.
+	 */
+	pthread_cond_t		rbm_group_wait;
+	pthread_mutex_t		rbm_group_waitlock;
+	unsigned int		rbm_group_count;
+
 	bool			aborted;
 };
 
@@ -247,6 +255,61 @@ scan_fs_metadata(
 	}
 }
 
+/* Scrub each rt group's metadata. */
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
+		goto out;
+
+	scrub_item_init_rtgroup(&sri, rgno);
+	snprintf(descr, DESCR_BUFSZ, _("rtgroup %u"), rgno);
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
+		goto out;
+	}
+
+	ret = repair_and_scrub_loop(ctx, &sri, descr, &defer_repairs);
+	if (ret) {
+		sctl->aborted = true;
+		goto out;
+	}
+
+	/* Everything else gets fixed during phase 4. */
+	ret = defer_fs_repair(ctx, &sri);
+	if (ret) {
+		sctl->aborted = true;
+		goto out;
+	}
+
+out:
+	/* Signal anybody waiting for the group bitmap scan to finish. */
+	pthread_mutex_lock(&sctl->rbm_group_waitlock);
+	sctl->rbm_group_count--;
+	if (sctl->rbm_group_count == 0)
+		pthread_cond_broadcast(&sctl->rbm_group_wait);
+	pthread_mutex_unlock(&sctl->rbm_group_waitlock);
+}
+
 /* Scan all filesystem metadata. */
 int
 phase2_func(
@@ -260,6 +323,7 @@ phase2_func(
 	struct scrub_item	sri;
 	const struct xfrog_scrub_descr *sc = xfrog_scrubbers;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	unsigned int		type;
 	int			ret, ret2;
 
@@ -326,14 +390,46 @@ phase2_func(
 		goto out_wq;
 
 	/*
-	 * Wait for the rt bitmap to finish scanning, then scan the rt summary
-	 * since the summary can be regenerated completely from the bitmap.
+	 * Wait for the rt bitmap to finish scanning, then scan the realtime
+	 * group metadata.  When rtgroups are enabled, the RTBITMAP scanner
+	 * only checks the inode and fork data of the rt bitmap file, and each
+	 * group checks its own part of the rtbitmap.
 	 */
 	pthread_mutex_lock(&sctl.rbm_waitlock);
 	while (!sctl.rbm_done)
 		pthread_cond_wait(&sctl.rbm_wait, &sctl.rbm_waitlock);
 	pthread_mutex_unlock(&sctl.rbm_waitlock);
 
+	if (sctl.aborted)
+		goto out_wq;
+
+	for (rgno = 0;
+	     rgno < ctx->mnt.fsgeom.rgcount && !sctl.aborted;
+	     rgno++) {
+		pthread_mutex_lock(&sctl.rbm_group_waitlock);
+		sctl.rbm_group_count++;
+		pthread_mutex_unlock(&sctl.rbm_group_waitlock);
+		ret = -workqueue_add(&wq, scan_rtgroup_metadata, rgno, &sctl);
+		if (ret) {
+			str_liberror(ctx, ret,
+					_("queueing rtgroup scrub work"));
+			goto out_wq;
+		}
+	}
+
+	if (sctl.aborted)
+		goto out_wq;
+
+	/*
+	 * Wait for the rtgroups to finish scanning, then scan the rt summary
+	 * since the summary can be regenerated completely from the bitmap.
+	 */
+	pthread_mutex_lock(&sctl.rbm_group_waitlock);
+	while (sctl.rbm_group_count > 0)
+		pthread_cond_wait(&sctl.rbm_group_wait,
+				&sctl.rbm_group_waitlock);
+	pthread_mutex_unlock(&sctl.rbm_group_waitlock);
+
 	if (sctl.aborted)
 		goto out_wq;
 
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 3bb3ea1d07b..bb94a11dcfc 100644
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

