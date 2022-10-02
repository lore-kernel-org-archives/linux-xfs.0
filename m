Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B507C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJBSaK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiJBSaI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:30:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E4514D19
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C175FB80D81
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80396C433D6;
        Sun,  2 Oct 2022 18:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735404;
        bh=Y4wNejEo22iJv1/ts0LqxwL+/qYVmu1FzuF8aZXG0kk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KZfpvdgtB6Djcr63QaaIN9DwKrhs8Rqm2t0B6fNgZoJGV7+8frKlN215P8N8OV+iL
         QU6p6QpH5nrY5/mRJnJBOZlqJ7/GUjv4QwrIjYNl94iPZWJzJa94gIE9MiOGnEzRdg
         toRdtaOH5TZvVwd4Ip3jLbw9pSDk5j2/Eya9zy4x0dm2OZ/fIZWym9uTbijgaNUrSa
         fb0gkPXlhGA3WivLm57FRmDksmWIhGxkxa2Dmtb5IZPLNvMrJ2rrCXwI4U6jW9rzRB
         AybYiRZPLTz4EwBLbS3E5tr+/0vBM7XpMbI4zje7Kw0l/fAZW06/Q99l9rDaS6Kd+Z
         Tvdo2K+W8jLWw==
Subject: [PATCH 5/5] xfs: scrub should use ECHRNG to signal that the drain is
 needed
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:59 -0700
Message-ID: <166473479948.1083534.14181109733305126043.stgit@magnolia>
In-Reply-To: <166473479864.1083534.16821762305468128245.stgit@magnolia>
References: <166473479864.1083534.16821762305468128245.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In the previous patch, we added jump labels to the intent drain code so
that regular filesystem operations need not pay the price of checking
for someone (scrub) waiting on intents to drain from some part of the
filesystem when that someone isn't running.

However, I observed that xfs/285 now spends a lot more time pushing the
AIL from the inode btree scrubber than it used to.  This is because the
inobt scrubber will try push the AIL to try to get logged inode cores
written to the filesystem when it sees a weird discrepancy between the
ondisk inode and the inobt records.  This AIL push is triggered when the
setup function sees TRY_HARDER is set; and the requisite EDEADLOCK
return is initiated when the discrepancy is seen.

The solution to this performance slow down is to use a different result
code (ECHRNG) for scrub code to signal that it needs to wait for
deferred intent work items to drain out of some part of the filesystem.
When this happens, set a new scrub state flag (XCHK_NEED_DRAIN) so that
setup functions will activate the jump label.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/btree.c   |    1 +
 fs/xfs/scrub/common.c  |    4 +++-
 fs/xfs/scrub/common.h  |    2 +-
 fs/xfs/scrub/dabtree.c |    1 +
 fs/xfs/scrub/repair.c  |    3 +++
 fs/xfs/scrub/scrub.c   |   10 ++++++++++
 fs/xfs/scrub/scrub.h   |    1 +
 fs/xfs/scrub/trace.h   |    1 +
 8 files changed, 21 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 566a093b2cf3..47fa14311d17 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -36,6 +36,7 @@ __xchk_btree_process_error(
 
 	switch (*error) {
 	case -EDEADLOCK:
+	case -ECHRNG:
 		/* Used to restart an op with deadlock avoidance. */
 		trace_xchk_deadlock_retry(sc->ip, sc->sm, *error);
 		break;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 74ad1a211216..60c4d33fe6f5 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -75,6 +75,7 @@ __xchk_process_error(
 	case 0:
 		return true;
 	case -EDEADLOCK:
+	case -ECHRNG:
 		/* Used to restart an op with deadlock avoidance. */
 		trace_xchk_deadlock_retry(
 				sc->ip ? sc->ip : XFS_I(file_inode(sc->file)),
@@ -130,6 +131,7 @@ __xchk_fblock_process_error(
 	case 0:
 		return true;
 	case -EDEADLOCK:
+	case -ECHRNG:
 		/* Used to restart an op with deadlock avoidance. */
 		trace_xchk_deadlock_retry(sc->ip, sc->sm, *error);
 		break;
@@ -480,7 +482,7 @@ xchk_perag_lock(
 		}
 
 		if (!(sc->flags & XCHK_FSHOOKS_DRAIN))
-			return -EDEADLOCK;
+			return -ECHRNG;
 		error = xfs_ag_drain_intents(sa->pag);
 		if (error == -ERESTARTSYS)
 			error = -EINTR;
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 4de5677390a4..0efe6b947d88 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -161,7 +161,7 @@ void xchk_start_reaping(struct xfs_scrub *sc);
  */
 static inline bool xchk_need_fshook_drain(struct xfs_scrub *sc)
 {
-	return sc->flags & XCHK_TRY_HARDER;
+	return sc->flags & XCHK_NEED_DRAIN;
 }
 
 void xchk_fshooks_enable(struct xfs_scrub *sc, unsigned int scrub_fshooks);
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index d17cee177085..957a0b1a2f0b 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -39,6 +39,7 @@ xchk_da_process_error(
 
 	switch (*error) {
 	case -EDEADLOCK:
+	case -ECHRNG:
 		/* Used to restart an op with deadlock avoidance. */
 		trace_xchk_deadlock_retry(sc->ip, sc->sm, *error);
 		break;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 34fc0dc5f200..be65357285e6 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -60,6 +60,9 @@ xrep_attempt(
 		sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
 		sc->flags |= XREP_ALREADY_FIXED;
 		return -EAGAIN;
+	case -ECHRNG:
+		sc->flags |= XCHK_NEED_DRAIN;
+		return -EAGAIN;
 	case -EDEADLOCK:
 		/* Tell the caller to try again having grabbed all the locks. */
 		if (!(sc->flags & XCHK_TRY_HARDER)) {
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8f8a4eb758ea..7a3557a69fe0 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -510,6 +510,8 @@ xfs_scrub_metadata(
 	error = sc->ops->setup(sc);
 	if (error == -EDEADLOCK && !(sc->flags & XCHK_TRY_HARDER))
 		goto try_harder;
+	if (error == -ECHRNG && !(sc->flags & XCHK_NEED_DRAIN))
+		goto need_drain;
 	if (error)
 		goto out_teardown;
 
@@ -517,6 +519,8 @@ xfs_scrub_metadata(
 	error = sc->ops->scrub(sc);
 	if (error == -EDEADLOCK && !(sc->flags & XCHK_TRY_HARDER))
 		goto try_harder;
+	if (error == -ECHRNG && !(sc->flags & XCHK_NEED_DRAIN))
+		goto need_drain;
 	if (error || (sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE))
 		goto out_teardown;
 
@@ -575,6 +579,12 @@ xfs_scrub_metadata(
 		error = 0;
 	}
 	return error;
+need_drain:
+	error = xchk_teardown(sc, 0);
+	if (error)
+		goto out_sc;
+	sc->flags |= XCHK_NEED_DRAIN;
+	goto retry_op;
 try_harder:
 	/*
 	 * Scrubbers return -EDEADLOCK to mean 'try harder'.  Tear down
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index daf87c4331fd..92b383061e88 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -98,6 +98,7 @@ struct xfs_scrub {
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
 #define XCHK_REAPING_DISABLED	(1 << 1)  /* background block reaping paused */
 #define XCHK_FSHOOKS_DRAIN	(1 << 2)  /* defer ops draining enabled */
+#define XCHK_NEED_DRAIN		(1 << 3)  /* scrub needs to use intent drain */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
 #define XCHK_FSHOOKS_ALL	(XCHK_FSHOOKS_DRAIN)
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 89414eb743f1..8738e6881ffc 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -97,6 +97,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 	{ XCHK_TRY_HARDER,			"try_harder" }, \
 	{ XCHK_REAPING_DISABLED,		"reaping_disabled" }, \
 	{ XCHK_FSHOOKS_DRAIN,			"fshooks_drain" }, \
+	{ XCHK_NEED_DRAIN,			"need_drain" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 
 DECLARE_EVENT_CLASS(xchk_class,

