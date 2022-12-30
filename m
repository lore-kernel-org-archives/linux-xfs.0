Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C76C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiL3Whz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3Whz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:37:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9BB18692
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:37:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2898B81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E393C433D2;
        Fri, 30 Dec 2022 22:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439871;
        bh=+0pIOR4EyElPBnkwIgl89n2atnoM+NbiOnW7L/9syc8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Rf5IS8MPQqa4e3PjrOpzBqLxA1q46utAyusyZocQGifWe6XPPJazmqBWw1JZbc7M+
         GET3BykvwG/C/gEcGgbsWl3ANmHa7k5Zd69P45pquDCaFhUYvfg2KqkT4E7e9BmTh9
         mDzExck127P/5Rt3r8IMHvqgvfyInf7smFeCIC6YaePLqyiTNAOGA8aL1OQM54xbin
         UVC0iQy8dRj+EYgDZ7FVyA+MuSYqL3HWIf33TROD1Eqpc0BunNKIXywsg6FelTnJho
         /3WnYV5MPXvQSeRCTxQ6bksZnQivaASCUYfTW88SaQL+t33Lkg9ekHnpOCxSQJ50ce
         VLwtDpRKB6I6A==
Subject: [PATCH 5/5] xfs: scrub should use ECHRNG to signal that the drain is
 needed
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:08 -0800
Message-ID: <167243826823.683691.784371328375186365.stgit@magnolia>
In-Reply-To: <167243826744.683691.2061427880010614570.stgit@magnolia>
References: <167243826744.683691.2061427880010614570.stgit@magnolia>
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
index 0fd36d5b4646..ebbf1c5fd0c6 100644
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
index 2c8ce015f3a9..b21d675dd158 100644
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
 		error = xfs_perag_drain_intents(sa->pag);
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
index a0b85bdd4c5a..446ffe987ca0 100644
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
index 4ff4b19bee3d..85c055c2ddc5 100644
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
index 034b80371da5..cd9cfe98f14f 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -100,6 +100,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 	{ XCHK_TRY_HARDER,			"try_harder" }, \
 	{ XCHK_REAPING_DISABLED,		"reaping_disabled" }, \
 	{ XCHK_FSHOOKS_DRAIN,			"fshooks_drain" }, \
+	{ XCHK_NEED_DRAIN,			"need_drain" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 
 DECLARE_EVENT_CLASS(xchk_class,

