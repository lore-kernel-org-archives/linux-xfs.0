Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0AF8C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiLaClD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236169AbiLaClB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:41:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB2D62FD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:40:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 28B88CE1A06
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6634BC433D2;
        Sat, 31 Dec 2022 02:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454456;
        bh=qBbU7P2UGSbrLYvWzT5xFtb9AgVtPubHpTp9ZhA1g54=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ulX+7w/VYmnWIzjpaMtDAKB1OegtzNwEMMHtHTMHgwScD+UwuWg6bXwgU3tg1ZFWh
         xQKhacCCUPeg2zqj8k8AwpRpThhE3YqkP6kgBIm0M4Vb0yJn/peFU1Mpqh5p6YdUIe
         eGSTm35NYdljr3lqD/74Ylw/eNPOmGLYgOFIVaWMIvCMxba40Ztv22QVeVRK6jUGrY
         VIMhfjx1Wtv5yjfwLpWMq/wm8swq/gLnB8VQWaJfmKZhYnpUEx9B8nbYldz6axwGod
         ZCMoU3ewK34ADvx/1IflLgJ1tX8wZCDsmAu6P8Du51MWFKzQ6EyirKlVPC6MhluuaT
         2RAVmjBI0jDUA==
Subject: [PATCH 42/45] xfs_scrub: fstrim each rtgroup in parallel
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:49 -0800
Message-ID: <167243878911.731133.1130139562119311184.stgit@magnolia>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/fsgeom.h |   21 +++++++++++++++++++++
 scrub/phase8.c   |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 1 deletion(-)


diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index 8c21b240bb2..6c6d6bb815a 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -203,4 +203,25 @@ cvt_b_to_agbno(
 	return cvt_daddr_to_agbno(xfd, cvt_btobbt(byteno));
 }
 
+/* Convert rtgroup number and rtgroup block to fs block number */
+static inline uint64_t
+cvt_rgbno_to_daddr(
+	struct xfs_fd		*xfd,
+	uint32_t		rgno,
+	uint32_t		rgbno)
+{
+	return cvt_off_fsb_to_bb(xfd,
+			(uint64_t)rgno * xfd->fsgeom.rgblocks + rgbno);
+}
+
+/* Convert rtgroup number and rtgroup block to a byte location on disk. */
+static inline uint64_t
+cvt_rgbno_to_b(
+	struct xfs_fd		*xfd,
+	xfs_rgnumber_t		rgno,
+	xfs_rgblock_t		rgbno)
+{
+	return cvt_bbtob(cvt_rgbno_to_daddr(xfd, rgno, rgbno));
+}
+
 #endif /* __LIBFROG_FSGEOM_H__ */
diff --git a/scrub/phase8.c b/scrub/phase8.c
index a8ea8db706b..cc4901f8614 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -48,6 +48,7 @@ fstrim_ok(
 
 struct trim_ctl {
 	uint64_t	datadev_end_pos;
+	uint64_t	rtdev_end_pos;
 	bool		aborted;
 };
 
@@ -80,6 +81,35 @@ trim_ag(
 	progress_add(1);
 }
 
+/* Trim each rt group. */
+static void
+trim_rtgroup(
+	struct workqueue	*wq,
+	xfs_agnumber_t		rgno,
+	void			*arg)
+{
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	struct trim_ctl		*tctl = arg;
+	uint64_t		pos, len, eortg_pos;
+	int			error;
+
+	pos = cvt_rgbno_to_b(&ctx->mnt, rgno, 0);
+	eortg_pos = cvt_rgbno_to_b(&ctx->mnt, rgno, ctx->mnt.fsgeom.rgblocks);
+	len = min(tctl->rtdev_end_pos, eortg_pos) - pos;
+
+	error = fstrim(ctx, pos + tctl->datadev_end_pos, len);
+	if (error) {
+		char		descr[DESCR_BUFSZ];
+
+		snprintf(descr, sizeof(descr) - 1, _("fstrim rgno %u"), rgno);
+		str_liberror(ctx, error, descr);
+		tctl->aborted = true;
+		return;
+	}
+
+	progress_add(1);
+}
+
 /* Trim the filesystem, if desired. */
 int
 phase8_func(
@@ -97,6 +127,8 @@ phase8_func(
 
 	tctl.datadev_end_pos = cvt_off_fsb_to_b(&ctx->mnt,
 			ctx->mnt.fsgeom.datablocks);
+	tctl.rtdev_end_pos = cvt_off_fsb_to_b(&ctx->mnt,
+			ctx->mnt.fsgeom.rtblocks);
 
 	error = -workqueue_create(&wq, (struct xfs_mount *)ctx,
 			disk_heads(ctx->datadev));
@@ -117,6 +149,18 @@ phase8_func(
 		}
 	}
 
+	/* Trim each rtgroup in parallel. */
+	for (agno = 0;
+	     agno < ctx->mnt.fsgeom.rgcount && !tctl.aborted;
+	     agno++) {
+		error = -workqueue_add(&wq, trim_rtgroup, agno, &tctl);
+		if (error) {
+			str_liberror(ctx, error,
+					_("queueing per-rtgroup fstrim work"));
+			goto out_wq;
+		}
+	}
+
 out_wq:
 	err2 = -workqueue_terminate(&wq);
 	if (err2) {
@@ -142,7 +186,7 @@ phase8_estimate(
 	*items = 0;
 
 	if (fstrim_ok(ctx))
-		*items = ctx->mnt.fsgeom.agcount;
+		*items = ctx->mnt.fsgeom.agcount + ctx->mnt.fsgeom.rgcount;
 
 	*nr_threads = disk_heads(ctx->datadev);
 	*rshift = 0;

