Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3DCC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbjEZAya (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235169AbjEZAy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:54:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303F412E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:54:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B978061B75
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255ACC433D2;
        Fri, 26 May 2023 00:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062467;
        bh=HCG14N3h6lsWHi3C4gsOG9b46kcYuApCAiFFreUu2Fo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=fFYLTmQpFsL/hiMPiOiPIFdlbgHXalf1Eb8UZgOCmOFi5NZpATrrwE+bKHAWlpGeO
         gD+fiIHjrvyDjt1ePUe20IgRTJGHW4rZ1v/ldZV5D4rtLnapWoI0+5w/lQejGczq4h
         W4kcOBWBWCdvSHsNJ56WqAiQIOIuxurw1ReLOmSv0MEyoQ7z1XFvYn5dfYRp+DghGl
         8FPUK/cKN2R12jZb22hn19CTRM5aDLAXBMqwfP1vZbl4f9YMpAWx1h/YM6pl5jc118
         9cvEBUdJCSFwYeJ1ge5T8KZ0uXfl66lSafJRcTjg1Jmwf6YCc4IpgG+Re2vM5u9DaC
         03CotK3nZsNbg==
Date:   Thu, 25 May 2023 17:54:26 -0700
Subject: [PATCH 3/5] xfs: refactor repair forcing tests into a repair.c helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506058755.3730621.8139705928409505880.stgit@frogsfrogsfrogs>
In-Reply-To: <168506058705.3730621.6175016885493289346.stgit@frogsfrogsfrogs>
References: <168506058705.3730621.6175016885493289346.stgit@frogsfrogsfrogs>
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
index b79fecd1c005..f77cec95c509 100644
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
@@ -928,3 +930,23 @@ xrep_reset_perag_resv(
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
index 67082c1b206f..df59f15e0379 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -18,6 +18,7 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
 /* Repair helpers */
 
 int xrep_attempt(struct xfs_scrub *sc);
+bool xrep_will_attempt(struct xfs_scrub *sc);
 void xrep_failure(struct xfs_mount *mp);
 int xrep_roll_ag_trans(struct xfs_scrub *sc);
 int xrep_roll_trans(struct xfs_scrub *sc);
@@ -107,6 +108,7 @@ int xrep_reinit_pagi(struct xfs_scrub *sc);
 #else
 
 #define xrep_ino_dqattach(sc)	(0)
+#define xrep_will_attempt(sc)	(false)
 
 static inline int
 xrep_attempt(
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 3d2ea2cc8f6a..da65e5bf0bc1 100644
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
@@ -543,21 +541,11 @@ xfs_scrub_metadata(
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

