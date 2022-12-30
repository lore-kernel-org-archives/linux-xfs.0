Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF540C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbiLaClB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbiLaCko (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:40:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C82BD4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:40:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25D16B81E08
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96ABC433EF;
        Sat, 31 Dec 2022 02:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454440;
        bh=k1iOpzSfh1AiUNApi+5H7MbtsEZ3IA0yJW2dhzF7NzU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k+HUJ9XXys/uxIc7u2+PcadVzzjp/KLXAf71mf3KzKCbE6AoJinVWpD/AL+0E2K3G
         NfBuJifTeqrpGpFqaYD7pSTSwujZJ8BlgfZOwn5PptqAgBg9udrZ1YG4yk0sK1m+vv
         f3rQSdXGj9a42qRgTM+MOXFeVwvEx8PGx1YBxvGGBvhPh/lTm7SbweScDgp/Pdouwx
         82tFl8GCTvv4Ix8MwLtUY7lBLXtO3h/Qg1nmFAAWP/cty3bmtFmFyFaDQQ/9r5TvIW
         RZnzqNEF4HyJmcbC2K0kU7lehnSSIC4NrUhQNzAWTjD48ztbqTU3wcargeVDKQnecG
         i8DGqVO4hC9/A==
Subject: [PATCH 41/45] xfs_scrub: scrub realtime allocation group metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:49 -0800
Message-ID: <167243878898.731133.9688954837507947732.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Scan realtime group metadata as part of phase 2, just like we do for AG
metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 scrub/scrub.h  |    9 +++++
 2 files changed, 104 insertions(+), 2 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index ebe3ad3ad5c..a224af11ed4 100644
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
 
@@ -178,6 +186,48 @@ scan_metafile(
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
+	int			ret;
+
+	if (sctl->aborted)
+		goto out;
+
+	scrub_item_init_rtgroup(&sri, rgno);
+	snprintf(descr, DESCR_BUFSZ, _("rtgroup %u"), rgno);
+
+	scrub_item_schedule_group(&sri, XFROG_SCRUB_GROUP_RTGROUP);
+	ret = scrub_item_check(ctx, &sri);
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
@@ -191,6 +241,7 @@ phase2_func(
 	struct scrub_item	sri;
 	const struct xfrog_scrub_descr *sc = xfrog_scrubbers;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	unsigned int		type;
 	int			ret, ret2;
 
@@ -256,8 +307,10 @@ phase2_func(
 		goto out_wq;
 
 	/*
-	 * Wait for the rt bitmap to finish scanning, then scan the rt summary
-	 * since the summary can be regenerated completely from the bitmap.
+	 * Wait for the rt bitmap to finish scanning, then scan the realtime
+	 * group metadata.  When rtgroups are enabled, the RTBITMAP scanner
+	 * only checks the inode and fork data of the rt bitmap file, and each
+	 * group checks its own part of the rtbitmap.
 	 */
 	ret = pthread_mutex_lock(&sctl.rbm_waitlock);
 	if (ret) {
@@ -274,6 +327,46 @@ phase2_func(
 	}
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
+	ret = pthread_mutex_lock(&sctl.rbm_group_waitlock);
+	if (ret) {
+		str_liberror(ctx, ret, _("waiting for rtgroup scrubbers"));
+		goto out_wq;
+	}
+	if (sctl.rbm_group_count > 0) {
+		ret = pthread_cond_wait(&sctl.rbm_group_wait,
+				&sctl.rbm_group_waitlock);
+		if (ret) {
+			str_liberror(ctx, ret,
+	_("waiting for rtgroup scrubbers"));
+			goto out_wq;
+		}
+	}
+	pthread_mutex_unlock(&sctl.rbm_group_waitlock);
+
 	if (sctl.aborted)
 		goto out_wq;
 
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 53354099c81..b7e6173f8fa 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -87,6 +87,15 @@ scrub_item_init_ag(struct scrub_item *sri, xfs_agnumber_t agno)
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

