Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60ABCC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235436AbiL3Xbd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiL3Xbc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:31:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A140E164AF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:31:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ADC1B81DAD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1144C433D2;
        Fri, 30 Dec 2022 23:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443088;
        bh=DfL4US/qrq++PQHx9FAnPwDb4MTqMYUItRWQkIJ9Nfs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nmOALCNukLLPEMWeG/Y5tJKXdboTURXjXm5omTiIbQXC1bIXNFPNOEoR5e2L1+VLN
         cWV+ag4MIxTqO//nJyIGAS6NdgvgZz/oxDLGpcFgCYx9tPOM7KQA9bTqdlKmFta7Yg
         VX5cJWchYshk9vFLrXPfIx2wbsaqLVws+0AlsB5zyjSKfvMsAUwpEqdewWTQ3OOBZk
         yjZQmMOvMVZsil5dLA47HtbU5nvKmHSMwMZLEDBCIRRoj0GheUfZ0mvgcRilMQ9KF5
         TVIDv8KbV1uUz1U+xI5Sy3kjU5+lceldyYY4ksOn3fVV/5pOrBvB8826kLhoGFzfUH
         udIvdKmemJ9rQ==
Subject: [PATCH 3/5] xfs: refactor repair forcing tests into a repair.c helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:56 -0800
Message-ID: <167243837668.694993.13489281100215270997.stgit@magnolia>
In-Reply-To: <167243837619.694993.4421999845289107494.stgit@magnolia>
References: <167243837619.694993.4421999845289107494.stgit@magnolia>
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
index 55d096ad4c15..3f3554d82eeb 100644
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
@@ -925,3 +927,23 @@ xrep_reset_perag_resv(
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
index 054eb9324ba3..88af16715a46 100644
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
index 3ddc2790601e..61deec5a119a 100644
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
@@ -545,21 +543,11 @@ xfs_scrub_metadata(
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

