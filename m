Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39380C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiLaAK4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLaAKz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:10:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCA8C29
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:10:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE0A461CD1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCA5C433D2;
        Sat, 31 Dec 2022 00:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445454;
        bh=J/Gl3bEVY05CI5XDaItz68wuo+PUqV86/Xe6pPLQYD4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hCnL+pyhNDKA/kflQL0qGMRfv4Q17DPnntrUWUl0h2HkKxJq8lHAIWoO0N+UWpwq7
         5ssmgI8IyzEVzuthd9SNVAf4S8zxIhyxFMbA7ekj4mQlOqkQjx4qOIDFyMFKutpwL4
         VUdDpkzyU1RvSqB123JNiPeOkIUwx3YrQeX03QMVO7uPOdn0Oj+JOJyLRaMMUG1Ea7
         K5OQnkOLDJDaQ0eap3y6jr8/11UpupNRu6b18671RbpfaViYoAWrI/s3PteVO5QyvC
         Vx5fHUuTome/jI+2n8yND5aHP4IS65SHEet+vb8OmdjFzGT9BxSu/q6+TUvXeA0cX7
         CSJ7SbWYQzhAw==
Subject: [PATCH 3/4] xfs: update health status if we get a clean bill of
 health
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:38 -0800
Message-ID: <167243865858.711359.2139998774089663481.stgit@magnolia>
In-Reply-To: <167243865816.711359.1865490497957941966.stgit@magnolia>
References: <167243865816.711359.1865490497957941966.stgit@magnolia>
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
 libfrog/scrub.c                     |    5 +++++
 libxfs/xfs_fs.h                     |    3 ++-
 man/man2/ioctl_xfs_scrub_metadata.2 |    6 ++++++
 scrub/scrub.c                       |    7 +------
 4 files changed, 14 insertions(+), 7 deletions(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 95daa78ba65..7cd241d9bce 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -144,6 +144,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "inode link counts",
 		.group	= XFROG_SCRUB_GROUP_ISCAN,
 	},
+	[XFS_SCRUB_TYPE_HEALTHY] = {
+		.name	= "healthy",
+		.descr	= "retained health records",
+		.group	= XFROG_SCRUB_GROUP_NONE,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 417cf85c0f7..400cf68e551 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
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
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index db238de1bb5..01f11058839 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -168,6 +168,12 @@ count) for errors.
 .TP
 .B XFS_SCRUB_TYPE_NLINKS
 Scan all inodes in the filesystem to verify each file's link count.
+
+.TP
+.B XFS_SCRUB_TYPE_HEALTHY
+Mark everything healthy after a clean scrub run.
+This clears out all the indirect health problem markers that might remain
+in the system.
 .RE
 
 .PD 1
diff --git a/scrub/scrub.c b/scrub/scrub.c
index fe5c8ade5d8..7f80b2de211 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -39,20 +39,15 @@ format_scrub_descr(
 	case XFROG_SCRUB_GROUP_PERAG:
 		return snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
 				_(sc->descr));
-		break;
 	case XFROG_SCRUB_GROUP_INODE:
 		return scrub_render_ino_descr(ctx, buf, buflen,
 				meta->sm_ino, meta->sm_gen, "%s",
 				_(sc->descr));
-		break;
 	case XFROG_SCRUB_GROUP_METAFILES:
 	case XFROG_SCRUB_GROUP_SUMMARY:
 	case XFROG_SCRUB_GROUP_ISCAN:
-		return snprintf(buf, buflen, _("%s"), _(sc->descr));
-		break;
 	case XFROG_SCRUB_GROUP_NONE:
-		assert(0);
-		break;
+		return snprintf(buf, buflen, _("%s"), _(sc->descr));
 	}
 	return -1;
 }

