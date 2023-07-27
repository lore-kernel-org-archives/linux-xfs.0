Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FCBEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjG0WfQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbjG0Wes (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:34:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5301D30D3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA57F61F6E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CC4C433C8;
        Thu, 27 Jul 2023 22:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690497268;
        bh=mM3m8fm5M3/5wxVQA3UaFf1TCmIyBRPNPjrI6PGso50=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=mDnIzmfr7FD0koSGpsvUiGCURzLixNG0LYtujYOJIW2acDKshOhm8EiewLn5TB+Kv
         QQJvpjYN0A+sZnEwLsVo3fDfZeKHYvhulhcDAgsq+eXq7LTeKi4iuEafKZQtXprElV
         /NC+ATsDAuauhJzgTTvtwux5gsfgwVUCXTC10gBlionx2QZdnQL1cE8+reieLN6yHo
         dcfhbUKM5oYZwlCDiEvgfam17xgZt7Wck1LD8qkMmqeKwUgBrr17fn3/IJNZU+M5Pt
         pk2WTX084NcC28aoW1iQTuBwWC8Ni2dgGMwLuv4FFzKImC6TU0WdF2n91OmdTlxZgH
         tFJZlpodg0oaA==
Date:   Thu, 27 Jul 2023 15:34:27 -0700
Subject: [PATCH 3/5] xfs: refactor repair forcing tests into a repair.c helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049626905.922742.1121588706396832948.stgit@frogsfrogsfrogs>
In-Reply-To: <169049626854.922742.12128926563525648849.stgit@frogsfrogsfrogs>
References: <169049626854.922742.12128926563525648849.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are a couple of conditions that userspace can set to force repairs
of metadata.  These really belong in the repair code and not open-coded
into the check code, so refactor them into a helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |   22 ++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    2 ++
 fs/xfs/scrub/scrub.c  |   14 +-------------
 3 files changed, 25 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 9cb5ee0b1bd66..b1ba4c58d8612 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -27,6 +27,8 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_defer.h"
+#include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -937,3 +939,23 @@ xrep_reset_perag_resv(
 out:
 	return error;
 }
+
+/* Decide if we are going to call the repair function for a scrub type. */
+bool
+xrep_will_attempt(
+	struct xfs_scrub	*sc)
+{
+	/* Userspace asked us to rebuild the structure regardless. */
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD)
+		return true;
+
+	/* Let debug users force us into the repair routines. */
+	if (XFS_TEST_ERROR(false, sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
+		return true;
+
+	/* Metadata is corrupt or failed cross-referencing. */
+	if (xchk_needs_repair(sc->sm))
+		return true;
+
+	return false;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 6a960adcbf705..1ec850a8e70cc 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -20,6 +20,7 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
 /* Repair helpers */
 
 int xrep_attempt(struct xfs_scrub *sc, struct xchk_stats_run *run);
+bool xrep_will_attempt(struct xfs_scrub *sc);
 void xrep_failure(struct xfs_mount *mp);
 int xrep_roll_ag_trans(struct xfs_scrub *sc);
 int xrep_roll_trans(struct xfs_scrub *sc);
@@ -109,6 +110,7 @@ int xrep_reinit_pagi(struct xfs_scrub *sc);
 #else
 
 #define xrep_ino_dqattach(sc)	(0)
+#define xrep_will_attempt(sc)	(false)
 
 static inline int
 xrep_attempt(
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index d01f59706ad79..31023f82d4b58 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -14,8 +14,6 @@
 #include "xfs_inode.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
-#include "xfs_errortag.h"
-#include "xfs_error.h"
 #include "xfs_scrub.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
@@ -548,21 +546,11 @@ xfs_scrub_metadata(
 	xchk_update_health(sc);
 
 	if (xchk_could_repair(sc)) {
-		bool needs_fix = xchk_needs_repair(sc->sm);
-
-		/* Userspace asked us to rebuild the structure regardless. */
-		if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD)
-			needs_fix = true;
-
-		/* Let debug users force us into the repair routines. */
-		if (XFS_TEST_ERROR(needs_fix, mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
-			needs_fix = true;
-
 		/*
 		 * If userspace asked for a repair but it wasn't necessary,
 		 * report that back to userspace.
 		 */
-		if (!needs_fix) {
+		if (!xrep_will_attempt(sc)) {
 			sc->sm->sm_flags |= XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED;
 			goto out_nofix;
 		}

