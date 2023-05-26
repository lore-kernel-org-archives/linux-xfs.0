Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0859BC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjEZBDw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjEZBDv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:03:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74DF125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:03:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FCEB610A2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E213CC433EF;
        Fri, 26 May 2023 01:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063028;
        bh=CSxPrIffrTBst74BZjTF/frGck8+pfrM5b/Nxi4PSNw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=GTrmfATdk4h+7qB+lHTXiao6r66uZn05di1uxtt4DU/ygzvn0Li2hcBEuKya5eXdY
         tR8HaoLiZhOB+DPckFdf3SRUMjLLOZ2ouH/Zq6S+mAGgNhc9KMy0VFJdqOpUuaANfD
         nZD+PBBcW0Uguu43CnfrLeNlYUFOkFoEiFiADOXLm3mIyIOaM27qP0EMYJulwENLfp
         29HechQlQ97ucv99FhUbIMkZd9EEVjG/za3sYpkDpDlYLVyhC9ZOkbaRisl7SqXsbZ
         dgyZtIuK/BdwUUZ01mQN/XAKg2myLXI+2llMfshlLkMWslJwRlnUzx260aUiU2gDK1
         ZsWntWOKW7fOg==
Date:   Thu, 25 May 2023 18:03:48 -0700
Subject: [PATCH 3/3] xfs: update health status if we get a clean bill of
 health
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506061188.3732817.16665532866654060095.stgit@frogsfrogsfrogs>
In-Reply-To: <168506061141.3732817.12069555992432067658.stgit@frogsfrogsfrogs>
References: <168506061141.3732817.12069555992432067658.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If scrub finds that everything is ok with the filesystem, we need a way
to tell the health tracking that it can let go of indirect health flags,
since indirect flags only mean that at some point in the past we lost
some context.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |    3 ++
 fs/xfs/scrub/health.c  |   64 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/health.h  |    1 +
 fs/xfs/scrub/repair.c  |    1 +
 fs/xfs/scrub/scrub.c   |    6 +++++
 fs/xfs/scrub/trace.h   |    4 ++-
 6 files changed, 77 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 417cf85c0f70..400cf68e551e 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -712,9 +712,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
+#define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	27
+#define XFS_SCRUB_TYPE_NR	28
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 09569b8289d5..f1407f617395 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -16,6 +16,7 @@
 #include "xfs_health.h"
 #include "scrub/scrub.h"
 #include "scrub/health.h"
+#include "scrub/common.h"
 
 /*
  * Scrub and In-Core Filesystem Health Assessments
@@ -119,6 +120,24 @@ xchk_health_mask_for_scrub_type(
 	return type_to_health_flag[scrub_type].sick_mask;
 }
 
+/*
+ * Scrub gave the filesystem a clean bill of health, so clear all the indirect
+ * markers of past problems (at least for the fs and ags) so that we can be
+ * healthy again.
+ */
+STATIC void
+xchk_mark_all_healthy(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	xfs_fs_mark_healthy(mp, XFS_SICK_FS_INDIRECT);
+	xfs_rt_mark_healthy(mp, XFS_SICK_RT_INDIRECT);
+	for_each_perag(mp, agno, pag)
+		xfs_ag_mark_healthy(pag, XFS_SICK_AG_INDIRECT);
+}
+
 /*
  * Update filesystem health assessments based on what we found and did.
  *
@@ -136,6 +155,18 @@ xchk_update_health(
 	struct xfs_perag	*pag;
 	bool			bad;
 
+	/*
+	 * The HEALTHY scrub type is a request from userspace to clear all the
+	 * indirect flags after a clean scan of the entire filesystem.  As such
+	 * there's no sick flag defined for it, so we branch here ahead of the
+	 * mask check.
+	 */
+	if (sc->sm->sm_type == XFS_SCRUB_TYPE_HEALTHY &&
+	    !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
+		xchk_mark_all_healthy(sc->mp);
+		return;
+	}
+
 	if (!sc->sick_mask)
 		return;
 
@@ -259,3 +290,36 @@ xchk_ag_btree_healthy_enough(
 
 	return true;
 }
+
+/*
+ * Quick scan to double-check that there isn't any evidence of lingering
+ * primary health problems.  If we're still clear, then the health update will
+ * take care of clearing the indirect evidence.
+ */
+int
+xchk_health_record(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	unsigned int		sick;
+	unsigned int		checked;
+
+	xfs_fs_measure_sickness(mp, &sick, &checked);
+	if (sick & XFS_SICK_FS_PRIMARY)
+		xchk_set_corrupt(sc);
+
+	xfs_rt_measure_sickness(mp, &sick, &checked);
+	if (sick & XFS_SICK_RT_PRIMARY)
+		xchk_set_corrupt(sc);
+
+	for_each_perag(mp, agno, pag) {
+		xfs_ag_measure_sickness(pag, &sick, &checked);
+		if (sick & XFS_SICK_AG_PRIMARY)
+			xchk_set_corrupt(sc);
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/health.h b/fs/xfs/scrub/health.h
index 66a273f8585b..1a3ce4ea6213 100644
--- a/fs/xfs/scrub/health.h
+++ b/fs/xfs/scrub/health.h
@@ -10,5 +10,6 @@ unsigned int xchk_health_mask_for_scrub_type(__u32 scrub_type);
 void xchk_update_health(struct xfs_scrub *sc);
 bool xchk_ag_btree_healthy_enough(struct xfs_scrub *sc, struct xfs_perag *pag,
 		xfs_btnum_t btnum);
+int xchk_health_record(struct xfs_scrub *sc);
 
 #endif /* __XFS_SCRUB_HEALTH_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 7b3d88230b5b..787d3a706dfd 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -30,6 +30,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_reflink.h"
+#include "xfs_health.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index cfae97e3db04..d4396c351373 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -379,6 +379,12 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.scrub	= xchk_nlinks,
 		.repair	= xrep_nlinks,
 	},
+	[XFS_SCRUB_TYPE_HEALTHY] = {	/* fs healthy; clean all reminders */
+		.type	= ST_FS,
+		.setup	= xchk_setup_fs,
+		.scrub	= xchk_health_record,
+		.repair = xrep_notsupported,
+	},
 };
 
 static int
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 9df95fb67e78..d4f142929518 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -68,6 +68,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_QUOTACHECK);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -96,7 +97,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
 	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }, \
 	{ XFS_SCRUB_TYPE_QUOTACHECK,	"quotacheck" }, \
-	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }
+	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }, \
+	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \

