Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842B6C11F70
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 04:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C386608FE
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 04:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhGNEWT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 00:22:19 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:34470 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230270AbhGNEWJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 00:22:09 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 086FC5EE1
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 14:19:16 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3WMe-006JK8-Ch
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 14:19:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m3WMe-00B15J-4J
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 14:19:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/16] xfs: convert scrub to use mount-based feature checks
Date:   Wed, 14 Jul 2021 14:19:08 +1000
Message-Id: <20210714041912.2625692-13-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714041912.2625692-1-david@fromorbit.com>
References: <20210714041912.2625692-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=lPfTsDkcHX0jXrNCi6cA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

THe scrub feature checks are the last place that the superblock
feature checks are used. Convert them to mount based feature checks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/scrub.c | 12 ++++++------
 fs/xfs/scrub/scrub.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a5b1ea9361b3..57ecbc48bbd5 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -239,21 +239,21 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_iallocbt,
 		.scrub	= xchk_finobt,
-		.has	= xfs_sb_version_hasfinobt,
+		.has	= xfs_has_finobt,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_rmapbt,
 		.scrub	= xchk_rmapbt,
-		.has	= xfs_sb_version_hasrmapbt,
+		.has	= xfs_has_rmapbt,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_REFCNTBT] = {	/* refcountbt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_refcountbt,
 		.scrub	= xchk_refcountbt,
-		.has	= xfs_sb_version_hasreflink,
+		.has	= xfs_has_reflink,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_INODE] = {	/* inode record */
@@ -308,14 +308,14 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_rt,
 		.scrub	= xchk_rtbitmap,
-		.has	= xfs_sb_version_hasrealtime,
+		.has	= xfs_has_realtime,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
 		.type	= ST_FS,
 		.setup	= xchk_setup_rt,
 		.scrub	= xchk_rtsummary,
-		.has	= xfs_sb_version_hasrealtime,
+		.has	= xfs_has_realtime,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */
@@ -383,7 +383,7 @@ xchk_validate_inputs(
 	if (ops->setup == NULL || ops->scrub == NULL)
 		goto out;
 	/* Does this fs even support this type of metadata? */
-	if (ops->has && !ops->has(&mp->m_sb))
+	if (ops->has && !ops->has(mp))
 		goto out;
 
 	error = -EINVAL;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 08a483cb46e2..b8e7ccc5e6c3 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -27,7 +27,7 @@ struct xchk_meta_ops {
 	int		(*repair)(struct xfs_scrub *);
 
 	/* Decide if we even have this piece of metadata. */
-	bool		(*has)(struct xfs_sb *);
+	bool		(*has)(struct xfs_mount *);
 
 	/* type describing required/allowed inputs */
 	enum xchk_type	type;
-- 
2.31.1

