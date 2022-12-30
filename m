Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65935C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiLaCee (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236245AbiLaCeb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:34:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885F826D9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:34:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E835FCE1926
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20967C433EF;
        Sat, 31 Dec 2022 02:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454067;
        bh=aMEk3z3oha5Jm0jmAqpy62J7bLJmYD53pzcLrv1EBMo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=svKY12Yd5BXCsF3P3ZA1/LF5N+e/j3tHcB5JcLKEYmP5+pN/3zODqf/ttkfurYIWy
         yxAK3K8UW62LHGOftMB3gcYlqYrZHmnMYFq58KAbel6QARvUarfWl/gP4loX9l+4uw
         KPptHK2SCm6K3TdFy4mvjPoP80F5xiIngK+KD9BSN/Zq91TQDFkS/JsfXBILcKSFja
         ryE2O/TdNWb1QrIobi2osMDU+zPZrKNGTgd1kP+uw6Dwbabv7QRf41AAnX3Ux2uurY
         9SsaKXmCMZNYUjTL8ql+21skWX15e8umCl89q860kPQ/XEMTQqQ2oLiqtkM4+r1OnP
         o6vJTN2FSowwg==
Subject: [PATCH 17/45] xfs: scrub the realtime group superblock
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:45 -0800
Message-ID: <167243878587.731133.13102036028058926154.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enable scrubbing of realtime group superblocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/scrub.c      |   15 +++++++++++++++
 libfrog/scrub.c |    5 +++++
 libfrog/scrub.h |    1 +
 libxfs/xfs_fs.h |    3 ++-
 scrub/repair.c  |    2 ++
 scrub/scrub.c   |    4 ++++
 6 files changed, 29 insertions(+), 1 deletion(-)


diff --git a/io/scrub.c b/io/scrub.c
index 0ad1b0229cc..d764a5a997b 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -59,6 +59,7 @@ scrub_ioctl(
 	switch (sc->group) {
 	case XFROG_SCRUB_GROUP_AGHEADER:
 	case XFROG_SCRUB_GROUP_PERAG:
+	case XFROG_SCRUB_GROUP_RTGROUP:
 		meta.sm_agno = control;
 		break;
 	case XFROG_SCRUB_GROUP_INODE:
@@ -178,6 +179,19 @@ parse_args(
 			return 0;
 		}
 		break;
+	case XFROG_SCRUB_GROUP_RTGROUP:
+		if (optind != argc - 1) {
+			fprintf(stderr,
+				_("Must specify one rtgroup number.\n"));
+			return 0;
+		}
+		control = strtoul(argv[optind], &p, 0);
+		if (*p != '\0') {
+			fprintf(stderr,
+				_("Bad rtgroup number '%s'.\n"), argv[optind]);
+			return 0;
+		}
+		break;
 	default:
 		ASSERT(0);
 		break;
@@ -255,6 +269,7 @@ repair_ioctl(
 	switch (sc->group) {
 	case XFROG_SCRUB_GROUP_AGHEADER:
 	case XFROG_SCRUB_GROUP_PERAG:
+	case XFROG_SCRUB_GROUP_RTGROUP:
 		meta.sm_agno = control;
 		break;
 	case XFROG_SCRUB_GROUP_INODE:
diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 3e322b4717d..7d6c9c69e4a 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -149,6 +149,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "retained health records",
 		.group	= XFROG_SCRUB_GROUP_NONE,
 	},
+	[XFS_SCRUB_TYPE_RGSUPER] = {
+		.name	= "rgsuper",
+		.descr	= "realtime group superblock",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 #undef DEP
 
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index a59371fe141..7155e6a9b0e 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -15,6 +15,7 @@ enum xfrog_scrub_group {
 	XFROG_SCRUB_GROUP_INODE,	/* per-inode metadata */
 	XFROG_SCRUB_GROUP_ISCAN,	/* metadata requiring full inode scan */
 	XFROG_SCRUB_GROUP_SUMMARY,	/* summary metadata */
+	XFROG_SCRUB_GROUP_RTGROUP,	/* per-rtgroup metadata */
 };
 
 /* Catalog of scrub types and names, indexed by XFS_SCRUB_TYPE_* */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index e3d87665e4a..c12be9dbb59 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -741,9 +741,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
+#define XFS_SCRUB_TYPE_RGSUPER	28	/* realtime superblock */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	28
+#define XFS_SCRUB_TYPE_NR	29
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/scrub/repair.c b/scrub/repair.c
index 6629125578c..10db103c87f 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -108,6 +108,7 @@ xfs_repair_metadata(
 	switch (xfrog_scrubbers[scrub_type].group) {
 	case XFROG_SCRUB_GROUP_AGHEADER:
 	case XFROG_SCRUB_GROUP_PERAG:
+	case XFROG_SCRUB_GROUP_RTGROUP:
 		meta.sm_agno = sri->sri_agno;
 		break;
 	case XFROG_SCRUB_GROUP_INODE:
@@ -412,6 +413,7 @@ repair_item_difficulty(
 		case XFS_SCRUB_TYPE_REFCNTBT:
 		case XFS_SCRUB_TYPE_RTBITMAP:
 		case XFS_SCRUB_TYPE_RTSUM:
+		case XFS_SCRUB_TYPE_RGSUPER:
 			ret |= REPAIR_DIFFICULTY_PRIMARY;
 			break;
 		}
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 19c35bfd907..a6d5ec056c8 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -49,6 +49,9 @@ format_scrub_descr(
 	case XFROG_SCRUB_GROUP_ISCAN:
 	case XFROG_SCRUB_GROUP_NONE:
 		return snprintf(buf, buflen, _("%s"), _(sc->descr));
+	case XFROG_SCRUB_GROUP_RTGROUP:
+		return snprintf(buf, buflen, _("rtgroup %u %s"), meta->sm_agno,
+				_(sc->descr));
 	}
 	return -1;
 }
@@ -97,6 +100,7 @@ xfs_check_metadata(
 	switch (group) {
 	case XFROG_SCRUB_GROUP_AGHEADER:
 	case XFROG_SCRUB_GROUP_PERAG:
+	case XFROG_SCRUB_GROUP_RTGROUP:
 		meta.sm_agno = sri->sri_agno;
 		break;
 	case XFROG_SCRUB_GROUP_METAFILES:

