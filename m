Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823EAC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiL3X2H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3X1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:27:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD861DDEA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:27:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73CDC61C31
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D193DC433D2;
        Fri, 30 Dec 2022 23:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442870;
        bh=LWC7uB5zwxUTKAwTE14xUFF2iu39aCGbdDhZYCI409Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=X7tOEUViSioEQEkZJFm3yzyoJW4DysqnjanV3CTqfZ3K2WK8A6sJOisRcMZwacwsG
         f7xIVw0TpGLkPaWHKQttK3oFWzpEaj56uZ+fcP7vctnB10SK+sovD6NGDvC9ayRIRH
         r+eWcZiQIR7L1DGehWVKZ9L8YcVlGexoqVXAEfgwJTFzEB5saM6qeG9UzvCg7dZR9y
         aWqhvDS7JQNGYlrxbdKf9fBW9+jgis1TPgR71LRn3Rvu4g4DR1ASzVZZT8BNJVgGoq
         6HkDM/m+JZMa6i/tO9GXP4EOqd1nBJPlcR2cw5vWkAVLlFLzNWUueoQYEjCtrMjbhN
         sqCSFe7ZXIKRQ==
Subject: [PATCH 2/2] xfs: allow userspace to rebuild metadata structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:45 -0800
Message-ID: <167243836566.692955.11429471313463580772.stgit@magnolia>
In-Reply-To: <167243836537.692955.2878906942781441773.stgit@magnolia>
References: <167243836537.692955.2878906942781441773.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new (superuser-only) flag to the online metadata repair ioctl to
force it to rebuild structures, even if they're not broken.  We will use
this to move metadata structures out of the way during a free space
defragmentation operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |    6 +++++-
 fs/xfs/scrub/scrub.c   |   11 ++++++++++-
 fs/xfs/scrub/trace.h   |    3 ++-
 3 files changed, 17 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1cfd5bc6520a..920fd4513fcb 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -741,7 +741,11 @@ struct xfs_scrub_metadata {
  */
 #define XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED (1u << 7)
 
-#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR)
+/* i: Rebuild the data structure. */
+#define XFS_SCRUB_IFLAG_FORCE_REBUILD	(1 << 31)
+
+#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR | \
+				 XFS_SCRUB_IFLAG_FORCE_REBUILD)
 #define XFS_SCRUB_FLAGS_OUT	(XFS_SCRUB_OFLAG_CORRUPT | \
 				 XFS_SCRUB_OFLAG_PREEN | \
 				 XFS_SCRUB_OFLAG_XFAIL | \
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index cda7b55d77a5..60975d050b82 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -412,6 +412,11 @@ xchk_validate_inputs(
 		goto out;
 	}
 
+	/* No rebuild without repair. */
+	if ((sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) &&
+	    !(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
+		return -EINVAL;
+
 	/*
 	 * We only want to repair read-write v5+ filesystems.  Defer the check
 	 * for ops->repair until after our scrub confirms that we need to
@@ -536,8 +541,12 @@ xfs_scrub_metadata(
 	    !(sc->flags & XREP_ALREADY_FIXED)) {
 		bool needs_fix = xchk_needs_repair(sc->sm);
 
+		/* Userspace asked us to rebuild the structure regardless. */
+		if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD)
+			needs_fix = true;
+
 		/* Let debug users force us into the repair routines. */
-		if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
+		if (XFS_TEST_ERROR(needs_fix, mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
 			needs_fix = true;
 
 		/*
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 8d9a5e8c59e2..788a02aee689 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -98,7 +98,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 	{ XFS_SCRUB_OFLAG_XCORRUPT,		"xcorrupt" }, \
 	{ XFS_SCRUB_OFLAG_INCOMPLETE,		"incomplete" }, \
 	{ XFS_SCRUB_OFLAG_WARNING,		"warning" }, \
-	{ XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED,	"norepair" }
+	{ XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED,	"norepair" }, \
+	{ XFS_SCRUB_IFLAG_FORCE_REBUILD,	"rebuild" }
 
 #define XFS_SCRUB_STATE_STRINGS \
 	{ XCHK_TRY_HARDER,			"try_harder" }, \

