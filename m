Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6481C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbjEZAux (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235953AbjEZAuv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:50:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411C91B5
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9552464C20
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EA6C433EF;
        Fri, 26 May 2023 00:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062248;
        bh=q1r9w2PPq6E0OjcaA1wkA8dE0dGvdOGJGCatDJGTnoc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=YhRhocclwfbm+tzLBE63DjzDPpBBcRRdifhpZOuIcS1HXaOMAMI8ahvPqTEFjSu66
         c/ppOGCzf0797xLCdBlZQbTRUPz+lg3H2AiWl0k3RnYqQdleGJXIFbJ82TQeTfDUY9
         YXmg+2rcXSx6D2iQkN0hLHm7vL6M09rhD/4rd2RybmkrVoXAr47AkXUCuLSjjYSf91
         Lr+n2NsOYOH3SoRfGSdMFcgzgojoBIi9os594K+rbYTw2XdjGHibgPpuZi6HwecGng
         Lde3ammXAnhQpoNn5BM3yragQWcP9ru6i9KTGP1L4n0X4CIaql54B+xViKtdIgNWCj
         /IVy1SLAd3Kuw==
Date:   Thu, 25 May 2023 17:50:47 -0700
Subject: [PATCH 2/2] xfs: allow userspace to rebuild metadata structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506057600.3730125.4561906767586624097.stgit@frogsfrogsfrogs>
In-Reply-To: <168506057570.3730125.9735079571472245559.stgit@frogsfrogsfrogs>
References: <168506057570.3730125.9735079571472245559.stgit@frogsfrogsfrogs>
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
index 8960053b6ae5..a5b9bbbbdfaa 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -410,6 +410,11 @@ xchk_validate_inputs(
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
@@ -534,8 +539,12 @@ xfs_scrub_metadata(
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
index f5498f628c17..6b47f1b5e07c 100644
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

