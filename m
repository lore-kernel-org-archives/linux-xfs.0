Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5186AC77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  1 May 2023 18:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjEAS1j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 May 2023 14:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjEAS1i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 May 2023 14:27:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21CF172B
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 11:27:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D5C60FA1
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 18:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9946DC433EF;
        Mon,  1 May 2023 18:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682965656;
        bh=rGzIfhdMTwKPZorogmBN09+qlhphPQtKjR7OJu6Rzmc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SREbhS77TkaodcbtELNER+60Yhtzm7lbr6VBsMrp6eTwJFq1vT+fl3EPni4RrE13v
         bf4RBELIIZLTEwVZIZlpaO//BUACFMML4JmRBGplMmwy0UqT5TbUr0orjEV+6I237s
         dVuGwME94eeg/e/6a5JTcgbWae2uAR0GLDo8oZXqzqkG6SpzRa0zoEQUxKICMh+gRT
         anE107dwb7xLm1fRmxxRnVMiCAtQra3GcQAHSkEdav9H8vZKKBj4wP2HcQcqNRq4J8
         HSV4ONwnxB2Y110lTE/OZpUqpwvkRpupa2zZiP56qznPDrGFOzvtSL+He77lPrvl1F
         8D0+F7I660j+g==
Subject: [PATCH 3/4] xfs: disable reaping in fscounters scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 01 May 2023 11:27:36 -0700
Message-ID: <168296565615.290156.10539363902684178027.stgit@frogsfrogsfrogs>
In-Reply-To: <168296563922.290156.2222659364666118889.stgit@frogsfrogsfrogs>
References: <168296563922.290156.2222659364666118889.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The fscounters scrub code doesn't work properly because it cannot
quiesce updates to the percpu counters in the filesystem, hence it
returns false corruption reports.  This has been fixed properly in
one of the online repair patchsets that are under review by replacing
the xchk_disable_reaping calls with an exclusive filesystem freeze.
Disabling background gc isn't sufficient to fix the problem.

In other words, scrub doesn't need to call xfs_inodegc_stop, which is
just as well since it wasn't correct to allow scrub to call
xfs_inodegc_start when something else could be calling xfs_inodegc_stop
(e.g. trying to freeze the filesystem).

Neuter the scrubber for now, and remove the xchk_*_reaping functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/common.c     |   26 --------------------------
 fs/xfs/scrub/common.h     |    2 --
 fs/xfs/scrub/fscounters.c |   13 ++++++-------
 fs/xfs/scrub/scrub.c      |    2 --
 fs/xfs/scrub/scrub.h      |    1 -
 fs/xfs/scrub/trace.h      |    1 -
 6 files changed, 6 insertions(+), 39 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 9aa79665c608..7a20256be969 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1164,32 +1164,6 @@ xchk_metadata_inode_forks(
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
index 18b5f2b62f13..791235cd9b00 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -156,8 +156,6 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 }
 
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
-void xchk_stop_reaping(struct xfs_scrub *sc);
-void xchk_start_reaping(struct xfs_scrub *sc);
 
 /*
  * Setting up a hook to wait for intents to drain is costly -- we have to take
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index faa315be7978..e382a35e98d8 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -150,13 +150,6 @@ xchk_setup_fscounters(
 	if (error)
 		return error;
 
-	/*
-	 * Pause background reclaim while we're scrubbing to reduce the
-	 * likelihood of background perturbations to the counters throwing off
-	 * our calculations.
-	 */
-	xchk_stop_reaping(sc);
-
 	return xchk_trans_alloc(sc, 0);
 }
 
@@ -453,6 +446,12 @@ xchk_fscounters(
 	if (frextents > mp->m_sb.sb_rextents)
 		xchk_set_corrupt(sc);
 
+	/*
+	 * XXX: We can't quiesce percpu counter updates, so exit early.
+	 * This can be re-enabled when we gain exclusive freeze functionality.
+	 */
+	return 0;
+
 	/*
 	 * If ifree exceeds icount by more than the minimum variance then
 	 * something's probably wrong with the counters.
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 02819bedc5b1..3d98f604765e 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -186,8 +186,6 @@ xchk_teardown(
 	}
 	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
 		mnt_drop_write_file(sc->file);
-	if (sc->flags & XCHK_REAPING_DISABLED)
-		xchk_start_reaping(sc);
 	if (sc->buf) {
 		if (sc->buf_cleanup)
 			sc->buf_cleanup(sc->buf);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index e71903474cd7..b38e93830dde 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -106,7 +106,6 @@ struct xfs_scrub {
 
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
-#define XCHK_REAPING_DISABLED	(1 << 1)  /* background block reaping paused */
 #define XCHK_FSGATES_DRAIN	(1 << 2)  /* defer ops draining enabled */
 #define XCHK_NEED_DRAIN		(1 << 3)  /* scrub needs to drain defer ops */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 68efd6fda61c..b3894daeb86a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -98,7 +98,6 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 
 #define XFS_SCRUB_STATE_STRINGS \
 	{ XCHK_TRY_HARDER,			"try_harder" }, \
-	{ XCHK_REAPING_DISABLED,		"reaping_disabled" }, \
 	{ XCHK_FSGATES_DRAIN,			"fsgates_drain" }, \
 	{ XCHK_NEED_DRAIN,			"need_drain" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }

