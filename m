Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FFDC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbiLaAHu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235857AbiLaAHt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:07:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE901CB3E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:07:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CE3B61CCF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C18C433EF;
        Sat, 31 Dec 2022 00:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445267;
        bh=s7VQBFUFlmuIRnOSVegn1CV2DMqqHeV5clMTY1dcVBg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pwdDmz+HdqlRGRwG4x0+Zi5dHxfwO9bCmzR3otuP6ySczYu9Jt1GABPf2+7ui0uyl
         HYYglH8SkRckeCU5KEzn9qikwIsY2YZtGBIuzQY9379JalPzVSgosCxYVZrKOUoU76
         3uIy5jSNerUu1WENOigcUR925IFZX2Z31tZs3XbXOdgdqEk7YI/Jg8jsC3/fnnN5GT
         C0EDHcNj6lHDoqF9Nw6vZMFXF+EugU1Y/GcUeHs4wYkOrE/6wV8VVQTu7Us6o4Y1M9
         gI0OilxRzcYndkYwJ3gvFvI7WhBKiI7Tdmwt5ZgUcnqiDwRVzfjo7RRsT0oIP2FNvW
         zZ060/MU0qFHg==
Subject: [PATCH 3/4] libfrog: rename the scrub "fs" group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:25 -0800
Message-ID: <167243864594.708428.5929123086143791935.stgit@magnolia>
In-Reply-To: <167243864554.708428.558285078019160851.stgit@magnolia>
References: <167243864554.708428.558285078019160851.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The only members of XFROG_SCRUB_GROUP_FS are metadata files.  Although
each of these files have full-filesystem scope, let's rename the group
so that it's more obvious that the group scans metadata files, not the
entire fs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/scrub.c      |    6 +++---
 libfrog/scrub.c |   10 +++++-----
 libfrog/scrub.h |    2 +-
 scrub/scrub.c   |    6 +++---
 4 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index 4cfa4bc3c4c..3971a9fedb5 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -66,7 +66,7 @@ scrub_ioctl(
 		meta.sm_gen = control2;
 		break;
 	case XFROG_SCRUB_GROUP_NONE:
-	case XFROG_SCRUB_GROUP_FS:
+	case XFROG_SCRUB_GROUP_METAFILES:
 	case XFROG_SCRUB_GROUP_SUMMARY:
 		/* no control parameters */
 		break;
@@ -167,7 +167,7 @@ parse_args(
 			return 0;
 		}
 		break;
-	case XFROG_SCRUB_GROUP_FS:
+	case XFROG_SCRUB_GROUP_METAFILES:
 	case XFROG_SCRUB_GROUP_NONE:
 	case XFROG_SCRUB_GROUP_SUMMARY:
 		if (optind != argc) {
@@ -260,7 +260,7 @@ repair_ioctl(
 		meta.sm_gen = control2;
 		break;
 	case XFROG_SCRUB_GROUP_NONE:
-	case XFROG_SCRUB_GROUP_FS:
+	case XFROG_SCRUB_GROUP_METAFILES:
 	case XFROG_SCRUB_GROUP_SUMMARY:
 		/* no control parameters */
 		break;
diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 5a5f522a425..2e4d96caaa1 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -107,27 +107,27 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_RTBITMAP] = {
 		.name	= "rtbitmap",
 		.descr	= "realtime bitmap",
-		.group	= XFROG_SCRUB_GROUP_FS,
+		.group	= XFROG_SCRUB_GROUP_METAFILES,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {
 		.name	= "rtsummary",
 		.descr	= "realtime summary",
-		.group	= XFROG_SCRUB_GROUP_FS,
+		.group	= XFROG_SCRUB_GROUP_METAFILES,
 	},
 	[XFS_SCRUB_TYPE_UQUOTA] = {
 		.name	= "usrquota",
 		.descr	= "user quotas",
-		.group	= XFROG_SCRUB_GROUP_FS,
+		.group	= XFROG_SCRUB_GROUP_METAFILES,
 	},
 	[XFS_SCRUB_TYPE_GQUOTA] = {
 		.name	= "grpquota",
 		.descr	= "group quotas",
-		.group	= XFROG_SCRUB_GROUP_FS,
+		.group	= XFROG_SCRUB_GROUP_METAFILES,
 	},
 	[XFS_SCRUB_TYPE_PQUOTA] = {
 		.name	= "prjquota",
 		.descr	= "project quotas",
-		.group	= XFROG_SCRUB_GROUP_FS,
+		.group	= XFROG_SCRUB_GROUP_METAFILES,
 	},
 	[XFS_SCRUB_TYPE_FSCOUNTERS] = {
 		.name	= "fscounters",
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index 68f1a968103..14c4857bede 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -11,7 +11,7 @@ enum xfrog_scrub_group {
 	XFROG_SCRUB_GROUP_NONE,		/* not metadata */
 	XFROG_SCRUB_GROUP_AGHEADER,	/* per-AG header */
 	XFROG_SCRUB_GROUP_PERAG,	/* per-AG metadata */
-	XFROG_SCRUB_GROUP_FS,		/* per-FS metadata */
+	XFROG_SCRUB_GROUP_METAFILES,	/* whole-fs metadata files */
 	XFROG_SCRUB_GROUP_INODE,	/* per-inode metadata */
 	XFROG_SCRUB_GROUP_SUMMARY,	/* summary metadata */
 };
diff --git a/scrub/scrub.c b/scrub/scrub.c
index b7e120e91d6..1fcd5b8e85d 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -45,7 +45,7 @@ format_scrub_descr(
 				meta->sm_ino, meta->sm_gen, "%s",
 				_(sc->descr));
 		break;
-	case XFROG_SCRUB_GROUP_FS:
+	case XFROG_SCRUB_GROUP_METAFILES:
 	case XFROG_SCRUB_GROUP_SUMMARY:
 		return snprintf(buf, buflen, _("%s"), _(sc->descr));
 		break;
@@ -406,7 +406,7 @@ scrub_fs_metadata(
 	struct scrub_ctx		*ctx,
 	struct action_list		*alist)
 {
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_FS, 0, alist);
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_METAFILES, 0, alist);
 }
 
 /* Scrub all FS summary metadata. */
@@ -443,7 +443,7 @@ scrub_estimate_ag_work(
 		case XFROG_SCRUB_GROUP_PERAG:
 			estimate += ctx->mnt.fsgeom.agcount;
 			break;
-		case XFROG_SCRUB_GROUP_FS:
+		case XFROG_SCRUB_GROUP_METAFILES:
 			estimate++;
 			break;
 		default:

