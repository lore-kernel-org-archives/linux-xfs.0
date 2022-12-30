Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA62C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbiLaAIz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbiLaAIx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:08:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5966D1E3C3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:08:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19021B81DF8
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE06DC433D2;
        Sat, 31 Dec 2022 00:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445329;
        bh=JJxiucz+QmsbKzHrNdnKFpJn367sj8ul+7AqnFl1ibo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Zg3OSuVPMMADNhVIxC0oovys57lZmQyfmfISzLe2vZpbOjkDy2bTHO0NonKaiIcUM
         DHzLsCiqcM167JDIV6afAItZMtFeiBYG+IJrMb6kOgvQ5q2iGDA/SNp4XBYWk4z+js
         7hV6fwFcMcSFJ5wgUhpAMPftYDek/Mx1hfqilieUXJyLRaaXabf/1P9DeMvFexvQE/
         6Pl0A8+6Rig0ABlDuBUFHWqsnvpzYNaw6H5Q7ZYOBIvZh3Avv2bn7CCYdf3mln+2Cs
         h/XoaNszbBUdAa+F2vWAJ8a8pslfpwHrBHEhcMGrb8w4EoT1lSll+2582LZ59Hz1LZ
         dqIprtULub1Jg==
Subject: [PATCH 3/3] xfs: implement live quotacheck inode scan
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:29 -0800
Message-ID: <167243864931.708814.14967976429445381977.stgit@magnolia>
In-Reply-To: <167243864892.708814.13943121883358066158.stgit@magnolia>
References: <167243864892.708814.13943121883358066158.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new trio of scrub functions to check quota counters.  While the
dquots themselves are filesystem metadata and should be checked early,
the dquot counter values are computed from other metadata and are
therefore summary counters.  We don't plug these into the scrub dispatch
just yet, because we still need to be able to watch quota updates while
doing our scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c |    5 +++++
 libxfs/xfs_fs.h |    3 ++-
 scrub/phase4.c  |   17 +++++++++++++++++
 scrub/repair.c  |    3 +++
 scrub/scrub.c   |    9 +++++++++
 scrub/scrub.h   |    1 +
 6 files changed, 37 insertions(+), 1 deletion(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 2e4d96caaa1..3718d56eae3 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -134,6 +134,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "filesystem summary counters",
 		.group	= XFROG_SCRUB_GROUP_SUMMARY,
 	},
+	[XFS_SCRUB_TYPE_QUOTACHECK] = {
+		.name	= "quotacheck",
+		.descr	= "quota counters",
+		.group	= XFROG_SCRUB_GROUP_ISCAN,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 7e86e1db66d..6612c89944d 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -708,9 +708,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_GQUOTA	22	/* group quotas */
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
+#define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	25
+#define XFS_SCRUB_TYPE_NR	26
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 3c985cdc13a..da9e8759134 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -128,6 +128,7 @@ int
 phase4_func(
 	struct scrub_ctx	*ctx)
 {
+	struct xfs_fsop_geom	fsgeom;
 	int			ret;
 
 	if (!have_action_items(ctx))
@@ -143,6 +144,22 @@ phase4_func(
 	if (ret)
 		return ret;
 
+	/*
+	 * Repair possibly bad quota counts before starting other repairs,
+	 * because wildly incorrect quota counts can cause shutdowns.
+	 * Quotacheck scans all inodes, so we only want to do it if we know
+	 * it's sick.
+	 */
+	ret = xfrog_geometry(ctx->mnt.fd, &fsgeom);
+	if (ret)
+		return ret;
+
+	if (fsgeom.sick & XFS_FSOP_GEOM_SICK_QUOTACHECK) {
+		ret = scrub_quotacheck(ctx, &ctx->action_lists[0]);
+		if (ret)
+			return ret;
+	}
+
 	ret = repair_everything(ctx);
 	if (ret)
 		return ret;
diff --git a/scrub/repair.c b/scrub/repair.c
index 67900ea4208..8a1ae0226a0 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -84,6 +84,9 @@ xfs_action_item_priority(
 	case XFS_SCRUB_TYPE_GQUOTA:
 	case XFS_SCRUB_TYPE_PQUOTA:
 		return PRIO(aitem, XFS_SCRUB_TYPE_UQUOTA);
+	case XFS_SCRUB_TYPE_QUOTACHECK:
+		/* This should always go after [UGP]QUOTA no matter what. */
+		return PRIO(aitem, aitem->type);
 	case XFS_SCRUB_TYPE_FSCOUNTERS:
 		/* This should always go after AG headers no matter what. */
 		return PRIO(aitem, INT_MAX);
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 5c7fc4c2a3a..f2dd9bb9d0b 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -440,6 +440,15 @@ scrub_fs_counters(
 	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, alist);
 }
 
+/* Scrub /only/ the quota counters. */
+int
+scrub_quotacheck(
+	struct scrub_ctx		*ctx,
+	struct action_list		*alist)
+{
+	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_QUOTACHECK, 0, alist);
+}
+
 /* How many items do we have to check? */
 unsigned int
 scrub_estimate_ag_work(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 5d365f99148..42b91fbc3ed 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -27,6 +27,7 @@ int scrub_metadata_file(struct scrub_ctx *ctx, unsigned int scrub_type,
 int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);

