Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB1EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiL3Xkz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbiL3Xkw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:40:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CC3BE23
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:40:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D792B81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF61C433EF;
        Fri, 30 Dec 2022 23:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443649;
        bh=QcIBTOrI1IXCHvYVpwJMuUPjpFt24wqzSqwcV86i1Yk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cXtgEzjUoZmZPWIEryzqbTv6lPQEjXY0Bupf5t27ks9A8ZSer61K4s//RJI7MeKgX
         eKFaCE3CeKXIK08TsUwP4SVIW4eTUgQe9SXNuGBF3lX2Qzv0LtADINacwWCQRAIdFG
         yR8JGfakyPVb7nCWXhXxHdDSm245RzA4QvVJmNpjnIAfRyqE7T7tjXhKzMZC6gzWcU
         4mGEEyg2Gd79QVhckgYouC3hHyLW3877s6HmcTc4RUyLtdmWaP2+j11YPav1dSGEcG
         Ff+gQi3NamM/qLJdaKwxcvL689VudgV6E4hwyXDoSPu3bHJljTeskChqqaR2J4gJx7
         KTkOYjv4Kxljg==
Subject: [PATCH 2/3] xfs: remove XCHK_REAPING_DISABLED from scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:22 -0800
Message-ID: <167243840278.696415.14969960380614471344.stgit@magnolia>
In-Reply-To: <167243840246.696415.12006477739455537131.stgit@magnolia>
References: <167243840246.696415.12006477739455537131.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Nobody uses this code anymore, so get rid of it.  It was racy with
regards to freezes and remounts anyway.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |   26 --------------------------
 fs/xfs/scrub/common.h |    2 --
 fs/xfs/scrub/scrub.c  |    2 --
 fs/xfs/scrub/scrub.h  |    3 +--
 fs/xfs/scrub/trace.h  |    1 -
 5 files changed, 1 insertion(+), 33 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index ef2dd59d0ac9..d96355ca4175 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1239,32 +1239,6 @@ xchk_metadata_inode_forks(
 	return 0;
 }
 
-/* Pause background reaping of resources. */
-void
-xchk_stop_reaping(
-	struct xfs_scrub	*sc)
-{
-	sc->flags |= XCHK_REAPING_DISABLED;
-	xfs_blockgc_stop(sc->mp);
-	xfs_inodegc_stop(sc->mp);
-}
-
-/* Restart background reaping of resources. */
-void
-xchk_start_reaping(
-	struct xfs_scrub	*sc)
-{
-	/*
-	 * Readonly filesystems do not perform inactivation or speculative
-	 * preallocation, so there's no need to restart the workers.
-	 */
-	if (!xfs_is_readonly(sc->mp)) {
-		xfs_inodegc_start(sc->mp);
-		xfs_blockgc_start(sc->mp);
-	}
-	sc->flags &= ~XCHK_REAPING_DISABLED;
-}
-
 /*
  * Enable filesystem hooks (i.e. runtime code patching) before starting a scrub
  * operation.  Callers must not hold any locks that intersect with the CPU
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 45318bd5678d..6992e3db5f11 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -213,8 +213,6 @@ static inline bool xchk_could_repair(const struct xfs_scrub *sc)
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
-void xchk_stop_reaping(struct xfs_scrub *sc);
-void xchk_start_reaping(struct xfs_scrub *sc);
 
 /*
  * Setting up a hook to wait for intents to drain is costly -- we have to take
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 6728b1409fea..4ec9ff259c5e 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -191,8 +191,6 @@ xchk_teardown(
 		sc->flags &= ~XCHK_HAVE_FREEZE_PROT;
 		mnt_drop_write_file(sc->file);
 	}
-	if (sc->flags & XCHK_REAPING_DISABLED)
-		xchk_start_reaping(sc);
 	if (sc->xfile) {
 		xfile_destroy(sc->xfile);
 		sc->xfile = NULL;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 12d1ba2aa83b..04afb584f504 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -118,12 +118,11 @@ struct xfs_scrub {
 
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
-#define XCHK_REAPING_DISABLED	(1 << 1)  /* background block reaping paused */
+#define XCHK_HAVE_FREEZE_PROT	(1 << 1)  /* do we have freeze protection? */
 #define XCHK_FSHOOKS_DRAIN	(1 << 2)  /* defer ops draining enabled */
 #define XCHK_NEED_DRAIN		(1 << 3)  /* scrub needs to use intent drain */
 #define XCHK_FSHOOKS_QUOTA	(1 << 4)  /* quota live update enabled */
 #define XCHK_FSHOOKS_NLINKS	(1 << 5)  /* link count live update enabled */
-#define XCHK_HAVE_FREEZE_PROT	(1 << 6)  /* do we have freeze protection? */
 #define XREP_RESET_PERAG_RESV	(1 << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 19b2d569d0c8..e0de12c4fcf4 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -114,7 +114,6 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 #define XFS_SCRUB_STATE_STRINGS \
 	{ XCHK_TRY_HARDER,			"try_harder" }, \
 	{ XCHK_HAVE_FREEZE_PROT,		"nofreeze" }, \
-	{ XCHK_REAPING_DISABLED,		"reaping_disabled" }, \
 	{ XCHK_FSHOOKS_DRAIN,			"fshooks_drain" }, \
 	{ XCHK_NEED_DRAIN,			"need_drain" }, \
 	{ XCHK_FSHOOKS_QUOTA,			"fshooks_quota" }, \

